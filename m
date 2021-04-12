Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F71EC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 05:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBF746105A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 05:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhDLF1e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 01:27:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:57750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhDLF1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 01:27:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5CD92ACC5;
        Mon, 12 Apr 2021 05:27:15 +0000 (UTC)
Subject: Re: [PATCH v9 13/13] lpfc: vmid: Introducing vmid in io path.
To:     James Smart <jsmart2021@gmail.com>,
        Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-14-git-send-email-muneendra.kumar@broadcom.com>
 <91b0c309-6908-8fd9-ac60-a8572500c3ed@suse.de>
 <201c6604-8e9d-bfcb-f39e-be507f8b02d6@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <edbcc321-fba1-e908-7932-ecb6b70ffc50@suse.de>
Date:   Mon, 12 Apr 2021 07:27:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <201c6604-8e9d-bfcb-f39e-be507f8b02d6@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/10/21 5:00 PM, James Smart wrote:
> On 4/8/2021 1:46 AM, Hannes Reinecke wrote:
>> On 4/7/21 1:06 AM, Muneendra wrote:
>>> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> ...
>>> +        /* while the read lock was released, in case the entry was */
>>> +        /* added by other context or is in process of being added */
>>> +        if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
>>> +            lpfc_vmid_update_entry(vport, cmd, vmp, tag);
>>> +            write_unlock(&vport->vmid_lock);
>>> +            return 0;
>>> +        } else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
>>> +            write_unlock(&vport->vmid_lock);
>>> +            return -EBUSY;
>>> +        }
>>> +
>>> +        /* else search and allocate a free slot in the hash table */
>>> +        if (vport->cur_vmid_cnt < vport->max_vmid) {
>>> +            for (i = 0; i < vport->max_vmid; ++i) {
>>> +                vmp = vport->vmid + i;
>>> +                if (vmp->flag == LPFC_VMID_SLOT_FREE) {
>>> +                    vmp = vport->vmid + i;
> 
> delete this last line and adjust parens - really odd that it replicates 
> the assignment 2 lines earlier.
> 
>>> +                    break;
>>> +                }
>>> +            }
> 
> I would prefer that if the table is expended and no slots free, that 
> -ENOMEM is returned here. Rather than falling down below and qualifying 
> by slot free, then by pending (set only if slot free).  I can't believe 
> there is a reason the idle timer has to be started if no slots free as 
> all the other fail cases don't bother with it.
> 
> This also helps indentation levels below.
> 
>>> +        } else {
>>> +            write_unlock(&vport->vmid_lock);
>>> +            return -ENOMEM;
>>> +        }
>>> +
>>> +        if (vmp && (vmp->flag == LPFC_VMID_SLOT_FREE)) {
>>> +            /* Add the vmid and register  */
>>> +            lpfc_put_vmid_in_hashtable(vport, hash, vmp);
>>> +            vmp->vmid_len = len;
>>> +            memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
>>> +            vmp->io_rd_cnt = 0;
>>> +            vmp->io_wr_cnt = 0;
>>> +            vmp->flag = LPFC_VMID_SLOT_USED;
>>> +
>>> +            vmp->delete_inactive =
>>> +                vport->vmid_inactivity_timeout ? 1 : 0;
>>> +
>>> +            /* if type priority tag, get next available vmid */
>>> +            if (lpfc_vmid_is_type_priority_tag(vport))
>>> +                lpfc_vmid_assign_cs_ctl(vport, vmp);
>>> +
>>> +            /* allocate the per cpu variable for holding */
>>> +            /* the last access time stamp only if vmid is enabled */
>>> +            if (!vmp->last_io_time)
>>> +                vmp->last_io_time =
>>> +                    __alloc_percpu(sizeof(u64),
>>> +                           __alignof__(struct
>>> +                                   lpfc_vmid));
>>> +
>>> +            /* registration pending */
>>> +            pending = 1;
>>> +        } else {
>>> +            rc = -ENOMEM;
>>> +        }
>>> +        write_unlock(&vport->vmid_lock);
>>> +
>>> +        /* complete transaction with switch */
>>> +        if (pending) {
>>> +            if (lpfc_vmid_is_type_priority_tag(vport))
>>> +                rc = lpfc_vmid_uvem(vport, vmp, true);
>>> +            else
>>> +                rc = lpfc_vmid_cmd(vport,
>>> +                           SLI_CTAS_RAPP_IDENT,
>>> +                           vmp);
>>> +            if (!rc) {
>>> +                write_lock(&vport->vmid_lock);
>>> +                vport->cur_vmid_cnt++;
>>> +                vmp->flag |= LPFC_VMID_REQ_REGISTER;
>>> +                write_unlock(&vport->vmid_lock);
>>> +            }
>>> +        }
>>> +
>>> +        /* finally, enable the idle timer once */
>>> +        if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
>>> +            mod_timer(&vport->phba->inactive_vmid_poll,
>>> +                  jiffies +
>>> +                  msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
>>> +            vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
>>> +        }
>>> +    }
>>> +    return rc;
>>> +}
>>> +
>>> +/*
>>> + * lpfc_is_command_vm_io - get the uuid from blk cgroup
>>> + * @cmd:Pointer to scsi_cmnd data structure
>>> + * Returns uuid if present if not null
>>> + */
>>> +static char *lpfc_is_command_vm_io(struct scsi_cmnd *cmd)
>>> +{
>>> +    char *uuid = NULL;
>>> +
>>> +    if (cmd->request) {
>>> +        if (cmd->request->bio)
>>> +            uuid = blkcg_get_fc_appid(cmd->request->bio);
>>> +    }
>>> +    return uuid;
>>> +}
>>> +
>>>   /**
>>>    * lpfc_queuecommand - scsi_host_template queuecommand entry point
>>>    * @shost: kernel scsi host pointer.
>>> @@ -5288,6 +5437,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, 
>>> struct scsi_cmnd *cmnd)
>>>       int err, idx;
>>>   #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>>>       uint64_t start = 0L;
>>> +    u8 *uuid = NULL;
>>>       if (phba->ktime_on)
>>>           start = ktime_get_ns();
>>> @@ -5415,6 +5565,25 @@ lpfc_queuecommand(struct Scsi_Host *shost, 
>>> struct scsi_cmnd *cmnd)
>>>       }
>>> +    /* check the necessary and sufficient condition to support VMID */
>>> +    if (lpfc_is_vmid_enabled(phba) &&
>>> +        (ndlp->vmid_support ||
>>> +         phba->pport->vmid_priority_tagging ==
>>> +         LPFC_VMID_PRIO_TAG_ALL_TARGETS)) {
>>> +        /* is the IO generated by a VM, get the associated virtual */
>>> +        /* entity id */
>>> +        uuid = lpfc_is_command_vm_io(cmnd);
>>> +
>>> +        if (uuid) {
>>> +            err = lpfc_vmid_get_appid(vport, uuid, cmnd,
>>> +                (union lpfc_vmid_io_tag *)
>>> +                    &lpfc_cmd->cur_iocbq.vmid_tag);
>>> +            if (!err)
>>> +                lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_VMID;
>>> +        }
>>> +    }
>>> +
>>> +    atomic_inc(&ndlp->cmd_pending);
>>>   #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>>>       if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
>>>           this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
>>>
>> And that's the bit which I don't particular like.
>>
>> Essentially we'll have to inject additional ELS commands _on each I/O_ 
>> to get a valid VMID.
>> Where there are _so_ many things which might get wrong, causing an I/O 
>> stall.
> 
> I don't follow you - yes ELS's are injected when there isn't an entry 
> for the VM, but once there is, there isn't further ELS's. That is the 
> cost. as we don't know what uuid's I/O will be sent to before hand, so 
> it has to be siphoned off during the I/O flow.  I/O's can be sent 
> non-tagged while the ELS's are completing (and there aren't multiple 
> sets of ELS's as long as it's the same uuid), which is fine.
> 
> so I disagree with "_on each I/O_".
> 
Yeah, that was an exaggeration.
Not on each I/O; I should've said 'on each unregistered I/O'.

This really is my unhappiness with the entire VMID specification,
where you can time out VMIDs after a certain period, and hence never
be sure if any particular I/O really _is_ registered.

>> I would have vastly preferred if we could _avoid_ having to do 
>> additional ELS commands for VMID registration in the I/O path
>> (ie only allow for I/O with a valid VMID), and reject the I/O 
>> otherwise until VMID registration is complete.
>>
>> IE return 'BUSY' (or even a command retry?) when no valid VMID for 
>> this particular I/O is found, register the VMID (preferably in another 
>> thread), and restart the queue once the VMID is registered.
> 
> Why does it bother you with the I/O path ?  It's actually happening in 
> parallel with no real relation between the two.
> 
> I seriously disagree with reject if no vmid tag. Why?  what do you gain 
> ? This actually introduces more disruption than the parallel flow with 
> the ELSs.   Also, after link bounce, where all VMID's have to be done, 
> it adds a stall window after link up right when things are trying to 
> resume after rports rejoin. Why add the i/o rebouncing ? There no real 
> benefit. Issuing a few untagged I/O doesn't hurt.
> 
That indeed is a valid point. I retract my objection.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

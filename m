Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9B3C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282F561166
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhDHIqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:46:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:43346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229566AbhDHIqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Apr 2021 04:46:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7A075AE58;
        Thu,  8 Apr 2021 08:46:12 +0000 (UTC)
Subject: Re: [PATCH v9 13/13] lpfc: vmid: Introducing vmid in io path.
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-14-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <91b0c309-6908-8fd9-ac60-a8572500c3ed@suse.de>
Date:   Thu, 8 Apr 2021 10:46:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1617750397-26466-14-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 1:06 AM, Muneendra wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> The patch introduces the vmid in the io path. It checks if the vmid is
> enabled and if io belongs to a vm or not and acts accordingly. Other
> supporing APIs are also included in the patch.

supporting (sp)

> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v9:
> Added changes related to locking and new hashtable implementation
> 
> v8:
> Added proper error codes
> updated logic while handling vmid
> 
> v7:
> No change
> 
> v6:
> No change
> 
> v5:
> No change
> 
> v4:
> No change
> 
> v3:
> Replaced blkcg_get_app_identifier with blkcg_get_fc_appid
> 
> v2:
> Ported the patch on top of 5.10/scsi-queue
> Added a fix for issuing QFPA command which was not included in the
> last submit
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 169 ++++++++++++++++++++++++++++++++++
>   1 file changed, 169 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index f81178464436..3267c5858238 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -5263,6 +5263,155 @@ static void lpfc_vmid_assign_cs_ctl(struct lpfc_vport *vport,
>   	}
>   }
>   
> +/*
> + * lpfc_vmid_get_appid- get the vmid associated with the uuid
> + * @vport: The virtual port for which this call is being executed.
> + * @uuid: uuid associated with the VE
> + * @cmd: address of scsi cmmd descriptor
> + * @tag: VMID tag
> + * Returns status of the function
> + */
> +static int lpfc_vmid_get_appid(struct lpfc_vport *vport, char *uuid, struct
> +			       scsi_cmnd * cmd, union lpfc_vmid_io_tag *tag)
> +{
> +	struct lpfc_vmid *vmp = NULL;
> +	int hash, len, rc, i;
> +	u8 pending = 0;
> +
> +	/* check if QFPA is complete */
> +	if (lpfc_vmid_is_type_priority_tag(vport) && !(vport->vmid_flag &
> +	      LPFC_VMID_QFPA_CMPL)) {
> +		vport->work_port_events |= WORKER_CHECK_VMID_ISSUE_QFPA;
> +		return -EAGAIN;
> +	}
> +
> +	/* search if the uuid has already been mapped to the vmid */
> +	len = strlen(uuid);
> +	hash = lpfc_vmid_hash_fn(uuid, len);
> +
> +	/* search for the VMID in the table */
> +	read_lock(&vport->vmid_lock);
> +	vmp = lpfc_get_vmid_from_hastable(vport, hash, uuid);
> +
> +	/* if found, check if its already registered  */
> +	if (vmp  && vmp->flag & LPFC_VMID_REGISTERED) {
> +		read_unlock(&vport->vmid_lock);
> +		lpfc_vmid_update_entry(vport, cmd, vmp, tag);
> +		rc = 0;
> +	} else if (vmp && (vmp->flag & LPFC_VMID_REQ_REGISTER ||
> +			   vmp->flag & LPFC_VMID_DE_REGISTER)) {
> +		/* else if register or dereg request has already been sent */
> +		/* Hence vmid tag will not be added for this IO */
> +		read_unlock(&vport->vmid_lock);
> +		rc = -EBUSY;
> +	} else {
> +		/* The vmid was not found in the hashtable. At this point, */
> +		/* drop the read lock first before proceeding further */
> +		read_unlock(&vport->vmid_lock);
> +		/* start the process to obtain one as per the */
> +		/* type of the vmid indicated */
> +		write_lock(&vport->vmid_lock);
> +		vmp = lpfc_get_vmid_from_hastable(vport, hash, uuid);
> +
> +		/* while the read lock was released, in case the entry was */
> +		/* added by other context or is in process of being added */
> +		if (vmp && vmp->flag & LPFC_VMID_REGISTERED) {
> +			lpfc_vmid_update_entry(vport, cmd, vmp, tag);
> +			write_unlock(&vport->vmid_lock);
> +			return 0;
> +		} else if (vmp && vmp->flag & LPFC_VMID_REQ_REGISTER) {
> +			write_unlock(&vport->vmid_lock);
> +			return -EBUSY;
> +		}
> +
> +		/* else search and allocate a free slot in the hash table */
> +		if (vport->cur_vmid_cnt < vport->max_vmid) {
> +			for (i = 0; i < vport->max_vmid; ++i) {
> +				vmp = vport->vmid + i;
> +				if (vmp->flag == LPFC_VMID_SLOT_FREE) {
> +					vmp = vport->vmid + i;
> +					break;
> +				}
> +			}
> +		} else {
> +			write_unlock(&vport->vmid_lock);
> +			return -ENOMEM;
> +		}
> +
> +		if (vmp && (vmp->flag == LPFC_VMID_SLOT_FREE)) {
> +			/* Add the vmid and register  */
> +			lpfc_put_vmid_in_hashtable(vport, hash, vmp);
> +			vmp->vmid_len = len;
> +			memcpy(vmp->host_vmid, uuid, vmp->vmid_len);
> +			vmp->io_rd_cnt = 0;
> +			vmp->io_wr_cnt = 0;
> +			vmp->flag = LPFC_VMID_SLOT_USED;
> +
> +			vmp->delete_inactive =
> +			    vport->vmid_inactivity_timeout ? 1 : 0;
> +
> +			/* if type priority tag, get next available vmid */
> +			if (lpfc_vmid_is_type_priority_tag(vport))
> +				lpfc_vmid_assign_cs_ctl(vport, vmp);
> +
> +			/* allocate the per cpu variable for holding */
> +			/* the last access time stamp only if vmid is enabled */
> +			if (!vmp->last_io_time)
> +				vmp->last_io_time =
> +				    __alloc_percpu(sizeof(u64),
> +						   __alignof__(struct
> +							       lpfc_vmid));
> +
> +			/* registration pending */
> +			pending = 1;
> +		} else {
> +			rc = -ENOMEM;
> +		}
> +		write_unlock(&vport->vmid_lock);
> +
> +		/* complete transaction with switch */
> +		if (pending) {
> +			if (lpfc_vmid_is_type_priority_tag(vport))
> +				rc = lpfc_vmid_uvem(vport, vmp, true);
> +			else
> +				rc = lpfc_vmid_cmd(vport,
> +						   SLI_CTAS_RAPP_IDENT,
> +						   vmp);
> +			if (!rc) {
> +				write_lock(&vport->vmid_lock);
> +				vport->cur_vmid_cnt++;
> +				vmp->flag |= LPFC_VMID_REQ_REGISTER;
> +				write_unlock(&vport->vmid_lock);
> +			}
> +		}
> +
> +		/* finally, enable the idle timer once */
> +		if (!(vport->phba->pport->vmid_flag & LPFC_VMID_TIMER_ENBLD)) {
> +			mod_timer(&vport->phba->inactive_vmid_poll,
> +				  jiffies +
> +				  msecs_to_jiffies(1000 * LPFC_VMID_TIMER));
> +			vport->phba->pport->vmid_flag |= LPFC_VMID_TIMER_ENBLD;
> +		}
> +	}
> +	return rc;
> +}
> +
> +/*
> + * lpfc_is_command_vm_io - get the uuid from blk cgroup
> + * @cmd:Pointer to scsi_cmnd data structure
> + * Returns uuid if present if not null
> + */
> +static char *lpfc_is_command_vm_io(struct scsi_cmnd *cmd)
> +{
> +	char *uuid = NULL;
> +
> +	if (cmd->request) {
> +		if (cmd->request->bio)
> +			uuid = blkcg_get_fc_appid(cmd->request->bio);
> +	}
> +	return uuid;
> +}
> +
>   /**
>    * lpfc_queuecommand - scsi_host_template queuecommand entry point
>    * @shost: kernel scsi host pointer.
> @@ -5288,6 +5437,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
>   	int err, idx;
>   #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>   	uint64_t start = 0L;
> +	u8 *uuid = NULL;
>   
>   	if (phba->ktime_on)
>   		start = ktime_get_ns();
> @@ -5415,6 +5565,25 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
>   	}
>   
>   
> +	/* check the necessary and sufficient condition to support VMID */
> +	if (lpfc_is_vmid_enabled(phba) &&
> +	    (ndlp->vmid_support ||
> +	     phba->pport->vmid_priority_tagging ==
> +	     LPFC_VMID_PRIO_TAG_ALL_TARGETS)) {
> +		/* is the IO generated by a VM, get the associated virtual */
> +		/* entity id */
> +		uuid = lpfc_is_command_vm_io(cmnd);
> +
> +		if (uuid) {
> +			err = lpfc_vmid_get_appid(vport, uuid, cmnd,
> +				(union lpfc_vmid_io_tag *)
> +					&lpfc_cmd->cur_iocbq.vmid_tag);
> +			if (!err)
> +				lpfc_cmd->cur_iocbq.iocb_flag |= LPFC_IO_VMID;
> +		}
> +	}
> +
> +	atomic_inc(&ndlp->cmd_pending);
>   #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>   	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
>   		this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
> 
And that's the bit which I don't particular like.

Essentially we'll have to inject additional ELS commands _on each I/O_ 
to get a valid VMID.
Where there are _so_ many things which might get wrong, causing an I/O 
stall.

I would have vastly preferred if we could _avoid_ having to do 
additional ELS commands for VMID registration in the I/O path
(ie only allow for I/O with a valid VMID), and reject the I/O otherwise 
until VMID registration is complete.

IE return 'BUSY' (or even a command retry?) when no valid VMID for this 
particular I/O is found, register the VMID (preferably in another 
thread), and restart the queue once the VMID is registered.

That way we have a clear separation, and the I/O path will always work 
with valid VMIDs.

Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

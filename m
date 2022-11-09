Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC109C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 07:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiKIHLW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 02:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKIHLV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 02:11:21 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B862E1E732;
        Tue,  8 Nov 2022 23:11:19 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 681121F390;
        Wed,  9 Nov 2022 07:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667977878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2X4GL+yuaODHYG9ltA/qFWoMqn1ado+q/aELZMKXbqE=;
        b=sFdKUpPRfBuRF5/PMCqpqmgOXVpVdMbg/d2yXFP+YxZVx2awaVQAYbOrm9GsP6/01AqSQ5
        gelNCVaqPqMswRaURSeJ4onkgmTx9cUlEK0/DIqIaFKUtL36Y8L9xN/Us9R6vBmAexrQgU
        tD8Jstf4Y4e1VWt6A0Z/AHRIjPasPHg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667977878;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2X4GL+yuaODHYG9ltA/qFWoMqn1ado+q/aELZMKXbqE=;
        b=fK18HurE5rOGGvbV0eiAd+Y2Rre0dPNQdNzdUUQvIrm7mpSer7rrFitM9JgDWqxmSkN/r+
        DyDxQcrLCQlBK7DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2753D1331F;
        Wed,  9 Nov 2022 07:11:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RoGpB5ZSa2N2KQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Nov 2022 07:11:18 +0000
Message-ID: <c0a34e41-17ca-cbc1-cf54-9fee23b830a3@suse.de>
Date:   Wed, 9 Nov 2022 08:11:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20221107161036.670237-1-niklas.cassel@wdc.com>
 <5a4fa5db-c706-5cf2-1145-bf091445d20e@oracle.com>
 <Y2mbX8MvYrF0FHaI@x1-carbon>
 <976bdcb7-cb97-9332-2bcc-5d98bc41871b@opensource.wdc.com>
 <Y2ri7EVPZb2O9iD8@x1-carbon>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <Y2ri7EVPZb2O9iD8@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 00:14, Niklas Cassel wrote:
> On Tue, Nov 08, 2022 at 12:50:44PM +0900, Damien Le Moal wrote:
>>>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>>>> index 4cb914103382..383a208f5f99 100644
>>>>> --- a/drivers/ata/libata-scsi.c
>>>>> +++ b/drivers/ata/libata-scsi.c
>>>>> @@ -1736,6 +1736,26 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
>>>>>    	if (xlat_func(qc))
>>>>>    		goto early_finish;
>>>>> +	/*
>>>>> +	 * scsi_queue_rq() will defer commands when in state SHOST_RECOVERY.
>>>>> +	 *
>>>>> +	 * When getting an error interrupt, ata_port_abort() will be called,
>>>>> +	 * which ends up calling ata_qc_schedule_eh() on all QCs.
>>>>> +	 *
>>>>> +	 * ata_qc_schedule_eh() will call ata_eh_set_pending() and then call
>>>>> +	 * blk_abort_request() on the given QC. blk_abort_request() will
>>>>> +	 * asynchronously end up calling scsi_eh_scmd_add(), which will set
>>>>> +	 * the state to SHOST_RECOVERY and wake up SCSI EH.
>>>>> +	 *
>>>>> +	 * In order to avoid requests from being issued to the device from the
>>>>> +	 * time ata_eh_set_pending() is called, to the time scsi_eh_scmd_add()
>>>>> +	 * sets the state to SHOST_RECOVERY, we defer requests here as well.
>>>>> +	 */
>>>>> +	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS)) {
>>>>> +		rc = ATA_DEFER_LINK;
>>>>> +		goto defer;
>>>>
>>>> Could we move this check earlier? I mean, we didn't need to have the qc
>>>> alloc'ed and xlat'ed for this check to be done, right?
>>>
>>> Sure, we could put it in e.g. ata_scsi_queuecmd() or __ata_scsi_queuecmd().
>>>
>>>
>>> Or, perhaps it is just time to accept that ATA EH is so interconnected with
>>> SCSI EH, so the simplest thing is just to do:
>>>
>>> --- a/drivers/ata/libata-eh.c
>>> +++ b/drivers/ata/libata-eh.c
>>> @@ -913,6 +913,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
>>>   
>>>          qc->flags |= ATA_QCFLAG_FAILED;
>>>          ata_eh_set_pending(ap, 1);
>>> +       scsi_host_set_state(ap->scsi_host, SHOST_RECOVERY);
>>
>> Why put this in this function ? Nothing in ata_qc_schedule_eh() calls
>> scsi_schedule_eh() or scsi_eh_scmd_add(), which set that state.
> 
> It does, but after calling blk_abort_request(), we need to wait for
> two different workqueues to run their work, before the SHOST_RECOVERY
> state gets set:
> 
> blk_abort_request() -> kblockd_schedule_work(&req->q->timeout_work) ->
> queue_work(kblockd_workqueue, work)
> 
> ... -> blk_mq_timeout_work() -> blk_mq_handle_expired() ->
> blk_mq_rq_timed_out() -> req->q->mq_ops->timeout() (scsi_timeout()) ->
> scsi_abort_command() ->
> queue_delayed_work(shost->tmf_work_q, &scmd->abort_work, HZ / 100);
> 
> ... -> scmd_eh_abort_handler() -> scsi_eh_scmd_add() ->
> scsi_host_set_state(shost, SHOST_RECOVERY)
> 
> After setting state to SHOST_RECOVERY, scsi_eh_scmd_add() will
> call scsi_eh_inc_host_failed(), which will cause the while (true) loop
> in scsi_error_handler() to proceed to perform SCSI EH, and eventually
> call shost->transportt->eh_strategy_handler(shost) which for ATA is set
> to ata_scsi_error().
> 
> Then we have the regular ATA side of things:
> ata_scsi_error() -> ata_scsi_port_error_handler() ->
> ap->ops->error_handler(ap) -> (for e.g. AHCI) ahci_error_handler() ->
> sata_pmp_error_handler() -> ata_eh_autopsy() -> ata_eh_link_autopsy() ->
> ata_eh_analyze_ncq_error(). (Where reading the NCQ error log in the
> command that brings the device out of error state.)
> 
> 
> Looking at this original commit, there are two ways for libata to trigger
> SCSI EH:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7b70fc039824bc7303e4007a5f758f832de56611
> 
> ata_qc_schedule_eh(): which is explained above. It indirectly schedules
> SCSI with an associated QC.
> 
> ata_port_schedule_eh(): It directly schedules EH for @ap without an
> associated qc. (I assume this is for e.g. an errors with the link,
> where we get an error interrupt and need to read SError register.)
> 
> 
> The commit message here:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ee7863bc68fa6ad6fe7cfcc0e5ebe9efe0c0664e
> 
> "In short, SCSI host is not supposed to know about exceptions unrelated
> to specific device or command.  Such exceptions should be handled by
> transport layer proper.  However, the distinction is not essential to
> ATA and libata is planning to depart from SCSI, so, for the time
> being, libata will be using SCSI EH to handle such exceptions."
> 
> So it appears that this distinction is not important for libata.
> Sure, if libata EH function ata_scsi_error() sees any commands in
> host->eh_cmd_q, then we know that they timed out or aborted.
> But ata_scsi_cmd_error_handler() will leave any QC alone that
> has ATA_QCFLAG_FAILED flag set.
> Those QCs will instead be processed by ata_scsi_port_error_handler()
> which totally ignores the host->eh_cmd_q list supplied by SCSI EH,
> and only looks at QCs with ATA_QCFLAG_FAILED set.
> 
> 
> So it would be tempting to do something like:
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -1001,8 +1001,7 @@ static int ata_do_link_abort(struct ata_port *ap, struct ata_link *link)
>                  }
>          }
>   
> -       if (!nr_aborted)
> -               ata_port_schedule_eh(ap);
> +       ata_port_schedule_eh(ap);
>   
>          return nr_aborted;
> 
> 
> However, doing so would go against how this API is supposed to be used, see:
> 36fed4980529 ("[SCSI] libsas: cleanup spurious calls to scsi_schedule_eh")
> 
> I did decide to try it anyway, but it turns out both this and the previous
> suggestion:
> 
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -913,6 +913,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
> 
>          qc->flags |= ATA_QCFLAG_FAILED;
>          ata_eh_set_pending(ap, 1);
> +       scsi_host_set_state(ap->scsi_host, SHOST_RECOVERY);
> 
> 
> Both actually lead to two error interrupts.
> (We should only have one.)
> 
> QEMU shows that this is from scsi_restart_operations(),
> which temporary clears the SHOST_RECOVERY bit, then calls
> scsi_run_host_queues().
> 
> Since we've reached this far, that must mean that in
> #3  scsi_queue_rq
> 
> when the:
> if (unlikely(scsi_host_in_recovery(shost))) {
> check was done, we were not in recovery.
> 
> But from that time, to #0, we must have received an error irq,
> because a:
> (gdb) p /x scmd->device->host->shost_state
> $9 = 0x5
> 
> which is SHOST_RECOVERY,
> 
> 
> #0  __ata_scsi_queuecmd (scmd=scmd@entry=0xffff8881016d7b88, dev=0xffff888101e124c0) at drivers/ata/libata-scsi.c:4256
> #1  0xffffffff819c1d8b in ata_scsi_queuecmd (shost=<optimized out>, cmd=0xffff8881016d7b88) at drivers/ata/libata-scsi.c:4337
> #2  0xffffffff81995c41 in scsi_dispatch_cmd (cmd=0xffff8881016d7b88) at drivers/scsi/scsi_lib.c:1516
> #3  scsi_queue_rq (hctx=<optimized out>, bd=<optimized out>) at drivers/scsi/scsi_lib.c:1757
> --Type <RET> for more, q to quit, c to continue without paging--
> #4  0xffffffff81578a42 in blk_mq_dispatch_rq_list (hctx=hctx@entry=0xffff8881008e0000, list=list@entry=0xffffc90000367da0, nr_budgets=0, nr_budgets@entry=1) at block/blk-mq.c:2056
> #5  0xffffffff8157ef1b in __blk_mq_do_dispatch_sched (hctx=0xffff8881008e0000) at block/blk-mq-sched.c:173
> #6  blk_mq_do_dispatch_sched (hctx=hctx@entry=0xffff8881008e0000) at block/blk-mq-sched.c:187
> #7  0xffffffff8157f238 in __blk_mq_sched_dispatch_requests (hctx=hctx@entry=0xffff8881008e0000) at block/blk-mq-sched.c:313
> #8  0xffffffff8157f2fb in blk_mq_sched_dispatch_requests (hctx=hctx@entry=0xffff8881008e0000) at block/blk-mq-sched.c:339
> #9  0xffffffff81573cc0 in __blk_mq_run_hw_queue (hctx=0xffff8881008e0000) at block/blk-mq.c:2174
> #10 0xffffffff8157546c in __blk_mq_delay_run_hw_queue (hctx=<optimized out>, async=<optimized out>, msecs=msecs@entry=0) at block/blk-mq.c:2250
> #11 0xffffffff815756a6 in blk_mq_run_hw_queue (hctx=<optimized out>, async=async@entry=false) at block/blk-mq.c:2298
> #12 0xffffffff81575990 in blk_mq_run_hw_queues (q=0xffff888102530000, async=async@entry=false) at block/blk-mq.c:2346
> #13 0xffffffff8199221d in scsi_run_queue (q=<optimized out>) at drivers/scsi/scsi_lib.c:457
> #14 0xffffffff81994ead in scsi_run_host_queues (shost=shost@entry=0xffff888101ca2000) at drivers/scsi/scsi_lib.c:475
> #15 0xffffffff819918bf in scsi_restart_operations (shost=0xffff888101ca2000) at drivers/scsi/scsi_error.c:2134
> #16 scsi_error_handler (data=0xffff888101ca2000) at drivers/scsi/scsi_error.c:2327
> 
> 
> So it appears that simply checking if SHOST_RECOVERY is set in
> scsi_queue_rq() is not enough. Since this is done without holding
> ap->lock (which is in libata..), we can always get an error irq.
> 
> So the only reliable way to ensure that we don't send down requests
> while the drive is in error state, is to have a check against
> ATA_PFLAG_EH_PENDING inside __ata_scsi_queuecmd(), while holding
> the ap->lock.
> Will send a V3 that is similar to V2, but with the check inside
> __ata_scsi_queuecmd().
> Thanks for the detailed explanation, Niklas.

However, one fundamental thing is still unresolved:
I've switched SCSI EH to do asynchronous aborts with commit e494f6a72839 
("[SCSI] improved eh timeout handler"); since then commands will be 
aborted without invoking SCSI EH.

This goes _fundamentally_ against libata's .eh_strategy (as it's never 
invoked), and as such libata _cannot_ use command aborts.
Which typically wouldn't matter as ATA doesn't have command aborts, and 
realistically any error is causing the NCQ queue to be drained.

So SCSI EH scsi_abort_command() really shouldn't queue a workqueue item, 
as it'll never be able to do anything meaningful.

You need this patch:

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index be2a70c5ac6d..4fb72b73871e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
                 return FAILED;
         }

+       if (!hostt->eh_abort_handler) {
+               /* No abort handler, fail command directly */
+               return FAILED;
+       }
+
         spin_lock_irqsave(shost->host_lock, flags);
         if (shost->eh_deadline != -1 && !shost->last_reset)
                 shost->last_reset = jiffies;

to avoid having libata trying to queue a (pointless) abort workqueue 
item, and get rid of the various workqueue thingies you mentioned above.

And it's a sensible fix anyway, will be sending it as a separate patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman


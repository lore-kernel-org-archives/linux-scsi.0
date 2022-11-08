Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2BFC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 04:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiKHEDw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 23:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiKHEDQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 23:03:16 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D065731EF1
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 20:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667880186; x=1699416186;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zWCZlBV0Du560Hsw2iMyyo75APBF5iv+MkGPs81UfQQ=;
  b=HfH7hz0LUtvBGZl6kj2mv/up0BqbqO/6YvnhNA5uUENjE/isd031nUnK
   Zj8rCU+Do1OGlR7q6KolMgY4MqNJX1fj1ZGPSPAD+5zpnGwtvFUpjulSQ
   RjtKWjwGFf3No/FPiPaS8w/9ZQXFpGMRqQhsQpGcReZs0IQ0LlpJPLnRC
   5Kc1KyLIRmvz3AP4t8xY9x+RIiQzxwQ/5lTNswBZ+vcEPVUCHLtw3zu+4
   kaV5oa1H5YpmEa2Rbqm4In0Y/1mYKr6dQtIJZSs82akDjyNqW6NtZTLpz
   6H1mjlKVHY5dQwe7JB3lSaUAqnyVN1iSVC3o/NM6W/CsfdIASPcL9CHD2
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,145,1665417600"; 
   d="scan'208";a="215725359"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2022 12:03:06 +0800
IronPort-SDR: 7tMKhkDrxux66BefeTmYPus5vOl1GYbGM9hqGI0tLB/5HmhtosX2AiDHoB/0yJ9hxkxO2RcIJl
 0wEHHrFgu9Rokyfv3vwtCV2NYILli+4cNFu+t0YHoBef29+DCExYPSK2ZXEY6VD0avj3sq2WSC
 adU5zn6GOjW5t5zO5LzfET/P6F4A6fbYU2vQzQ4POFHKM7xVMLv9BtOkf2JDoKk3T+XwgHvW53
 wLoFP7WZ43jU8sp4ynYZ6r+sHLymujZCXbLfaZZNHnUcZVyE7kacdi3XKWMXVtTBrpPvrVCO7e
 OOY=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Nov 2022 19:22:12 -0800
IronPort-SDR: RIa6S0QjYhbeRAEQDs2xKbuY8qGmkUwaRFv+ElAt2+E6w5cbMq1+69E8QRvQUBjDpjl+Vrypy1
 9SHJD/BRmrD/ebGq36jcmYy59md5CgeuPbxXIXA9ue9DeuIWHEZUXOIhjkgqmRlIRm4zJazFDu
 UE2ltFm1R2Rrzacr/3PXGYltSLrkkVXbx9IMurZva2zkwI3ulX3qk3mzKQslDBc0+VEn+Ws8Nl
 D4M6fEp5Oq7icJCbgVRVe1uqHSS/0+858t7jSYZrC5/jlA0bx7BDN7AgUFc12RoxIqoqQEdoQw
 usM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Nov 2022 20:03:06 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N5vJm67CNz1Rwt8
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 19:50:48 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667879447; x=1670471448; bh=zWCZlBV0Du560Hsw2iMyyo75APBF5iv+MkG
        Ps81UfQQ=; b=QCilGdrE2aqDwoWOvbH52jTJfkeMCBflDkaj0Js77GIbKVdlBcw
        tR5EWa9P2qVUoQYhuPLk6tBtnY13AY1/6UFMKIfdVNamHY7Aryi3FY26Mu30sn8j
        vuDIHLkJHIqLI70cC/VoIXrY3H1mherXZTE1gj3YnCAGPnwNXO8gVCvV+tAGCYZr
        kCnh0ivYjfQ0WkwGYTX6XWXW9UonMiSNE6UDebYNeoa62jXggA4T3A6f6FagFwkt
        nYYtie9usTK87JbsVd6HQSq7fDhpRgGiMdeMy/UJOP9Zh0Xg4Pc43oDoPxNe/unC
        2htXozfsunTwF4QYCRZ61lUAszCClE/XufQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id mrfe9NsnGglX for <linux-scsi@vger.kernel.org>;
        Mon,  7 Nov 2022 19:50:47 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N5vJk311nz1RvLy;
        Mon,  7 Nov 2022 19:50:46 -0800 (PST)
Message-ID: <976bdcb7-cb97-9332-2bcc-5d98bc41871b@opensource.wdc.com>
Date:   Tue, 8 Nov 2022 12:50:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2] ata: libata-core: do not issue non-internal commands
 once EH is pending
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>
Cc:     "tj@kernel.org" <tj@kernel.org>, "hare@suse.de" <hare@suse.de>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
References: <20221107161036.670237-1-niklas.cassel@wdc.com>
 <5a4fa5db-c706-5cf2-1145-bf091445d20e@oracle.com>
 <Y2mbX8MvYrF0FHaI@x1-carbon>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y2mbX8MvYrF0FHaI@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


+ linux-scsi, Martin and James

On 11/8/22 08:57, Niklas Cassel wrote:
> On Mon, Nov 07, 2022 at 05:01:53PM +0000, John Garry wrote:
>> On 07/11/2022 16:10, Niklas Cassel wrote:
>>> scsi_queue_rq() will check if scsi_host_in_recovery() (state is
>>> SHOST_RECOVERY), and if so, it will _not_ issue a command via:
>>> scsi_dispatch_cmd() -> host->hostt->queuecommand() (ata_scsi_queuecmd())
>>> -> __ata_scsi_queuecmd() -> ata_scsi_translate() -> ata_qc_issue()
>>>
>>> Before commit e494f6a72839 ("[SCSI] improved eh timeout handler"),
>>> when receiving a TFES error IRQ, this was the call chain:
>>> ahci_error_intr() -> ata_port_abort() -> ata_do_link_abort() ->
>>> ata_qc_complete() -> ata_qc_schedule_eh() -> blk_abort_request() ->
>>> blk_rq_timed_out() -> q->rq_timed_out_fn() (scsi_times_out()) ->
>>> scsi_eh_scmd_add() -> scsi_host_set_state(shost, SHOST_RECOVERY)
>>>
>>> Which meant that as soon as the error IRQ was serviced, no additional
>>> commands sent from the block layer (scsi_queue_rq()) would be sent down
>>> to the device. (ATA internal commands originating for ATA EH could of
>>> course still be sent.)
>>>
>>> However, after commit e494f6a72839 ("[SCSI] improved eh timeout handler"),
>>> scsi_times_out() would instead result in a call to scsi_abort_command() ->
>>> queue_delayed_work(). work function: scmd_eh_abort_handler() would call
>>> scsi_eh_scmd_add(), which calls scsi_host_set_state(shost, SHOST_RECOVERY).
>>>
>>> (It was possible to get the old behavior if host->hostt->no_async_abort
>>> was set, but libata never used it, and this option was completely removed
>>> in commit a06586325f37 ("scsi: make asynchronous aborts mandatory"))
>>>
>>> Additionally, later in commit 358f70da49d7 ("blk-mq: make
>>> blk_abort_request() trigger timeout path"), blk_abort_request() was changed
>>> to also call the abort callback asynchronously.
>>>
>>> So now, after the TFES error irq has been serviced, we need to wait for
>>> two different workqueues to run their work, before the SHOST_RECOVERY
>>> state gets set.
>>>
>>> While the ATA specification states that a device should return command
>>> aborted for all commands queued after the device has entered error state,
>>> since ATA only keeps the sense data for the latest command (in non-NCQ
>>> case), we really don't want to send block layer commands to the device
>>> after it has entered error state. (Only ATA EH commands should be sent,
>>> to read the sense data etc.)
>>>
>>> While we could just call scsi_host_set_state(shost, SHOST_RECOVERY) from
>>> ata_qc_schedule_eh() directly, that might be a layering violation.
>>> So instead of doing that, add an additional check against the libata's own
>>> EH flag(s) before calling the qc_defer callback.
>>>
>>> Fixes: e494f6a72839 ("[SCSI] improved eh timeout handler")
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> ---
>>> Changes since v1:
>>> -Implemented review comments from Damien.
>>>
>>>   drivers/ata/libata-scsi.c | 20 ++++++++++++++++++++
>>>   1 file changed, 20 insertions(+)
>>>
>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>> index 4cb914103382..383a208f5f99 100644
>>> --- a/drivers/ata/libata-scsi.c
>>> +++ b/drivers/ata/libata-scsi.c
>>> @@ -1736,6 +1736,26 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
>>>   	if (xlat_func(qc))
>>>   		goto early_finish;
>>> +	/*
>>> +	 * scsi_queue_rq() will defer commands when in state SHOST_RECOVERY.
>>> +	 *
>>> +	 * When getting an error interrupt, ata_port_abort() will be called,
>>> +	 * which ends up calling ata_qc_schedule_eh() on all QCs.
>>> +	 *
>>> +	 * ata_qc_schedule_eh() will call ata_eh_set_pending() and then call
>>> +	 * blk_abort_request() on the given QC. blk_abort_request() will
>>> +	 * asynchronously end up calling scsi_eh_scmd_add(), which will set
>>> +	 * the state to SHOST_RECOVERY and wake up SCSI EH.
>>> +	 *
>>> +	 * In order to avoid requests from being issued to the device from the
>>> +	 * time ata_eh_set_pending() is called, to the time scsi_eh_scmd_add()
>>> +	 * sets the state to SHOST_RECOVERY, we defer requests here as well.
>>> +	 */
>>> +	if (ap->pflags & (ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS)) {
>>> +		rc = ATA_DEFER_LINK;
>>> +		goto defer;
>>
>> Could we move this check earlier? I mean, we didn't need to have the qc
>> alloc'ed and xlat'ed for this check to be done, right?
> 
> Sure, we could put it in e.g. ata_scsi_queuecmd() or __ata_scsi_queuecmd().
> 
> 
> Or, perhaps it is just time to accept that ATA EH is so interconnected with
> SCSI EH, so the simplest thing is just to do:
> 
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -913,6 +913,7 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
>  
>         qc->flags |= ATA_QCFLAG_FAILED;
>         ata_eh_set_pending(ap, 1);
> +       scsi_host_set_state(ap->scsi_host, SHOST_RECOVERY);

Why put this in this function ? Nothing in ata_qc_schedule_eh() calls
scsi_schedule_eh() or scsi_eh_scmd_add(), which set that state.
It looks like ata_port->ops->sched_eh(), that is, ata_std_sched_eh(),
would be a better place for this.

>  
>         /* The following will fail if timeout has already expired.
>          * ata_scsi_error() takes care of such scmds on EH entry.
> 
> 
> Which appears to work just as well as the patch in $subject.
> 
> In commit ee7863bc68fa ("[PATCH] SCSI: implement shost->host_eh_scheduled")
> Tejun mentioned that "... libata is planning to depart from SCSI, so, for the
> time being, libata will be using SCSI EH to handle such exceptions."
> 
> Now, 16 years later, ATA is still using SCSI EH (see ata_port_schedule_eh() and
> ata_std_sched_eh()) to schedule EH in the case when there are no QCs to abort:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/ata/libata-eh.c?h=v6.1-rc4#n1004
> 
> Damien, thoughts?

I like this simpler fix better, but it does introduce a risk of (again)
having problems with ata EH if scsi EH trigger/timing is changed.
Unlikely now, but as this fix proves, not unheard of.

The v2 change is fine too, modulo John's suggestion, which I agree with.
At least it is consistent with the ata internal eh state accounting, so
self contained within libata and somewhat less dependent on scsi state
machine.

Martin ? James ? Thoughts ?

-- 
Damien Le Moal
Western Digital Research


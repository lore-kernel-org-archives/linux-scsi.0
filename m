Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2218DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0232D60F6D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 08:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238079AbhIMIyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 04:54:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:64327 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238310AbhIMIyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 04:54:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10105"; a="307164359"
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="307164359"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 01:53:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,288,1624345200"; 
   d="scan'208";a="543069217"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Sep 2021 01:52:56 -0700
Subject: Re: [PATCH V3 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Wei Li <liwei213@huawei.com>, linux-scsi@vger.kernel.org
References: <20210905095153.6217-1-adrian.hunter@intel.com>
 <20210905095153.6217-2-adrian.hunter@intel.com>
 <a12d88b3-8402-34bb-fe97-90b7aa2c2c39@acm.org>
 <835c5eab-5a7b-269d-7483-227978b80cd7@intel.com>
 <d9656961-4abb-aff0-e34d-d8082a1f4eaa@acm.org>
 <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
 <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
 <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <fae15188-2c1d-b953-f6e4-6e5ac1902b24@intel.com>
Date:   Mon, 13 Sep 2021 11:53:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <9220f68e-dc5e-9520-6e55-2a4d86809b44@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/21 6:17 am, Bart Van Assche wrote:
> On 9/11/21 09:47, Adrian Hunter wrote:
>> On 8/09/21 1:36 am, Bart Van Assche wrote:
>>> --- a/drivers/scsi/ufs/ufshcd.c +++ b/drivers/scsi/ufs/ufshcd.c 
>>> @@ -2707,6 +2707,14 @@ static int ufshcd_queuecommand(struct
>>> Scsi_Host *host, struct scsi_cmnd *cmd) } fallthrough; case
>>> UFSHCD_STATE_RESET: +        /* +         * The SCSI error
>>> handler only starts after all pending commands +         * have
>>> failed or timed out. Complete commands with +         *
>>> DID_IMM_RETRY to allow the error handler to start +         * if
>>> it has been scheduled. +         */ +        set_host_byte(cmd,
>>> DID_IMM_RETRY); +        cmd->scsi_done(cmd);
>> 
>> Setting non-zero return value, in this case "err =
>> SCSI_MLQUEUE_HOST_BUSY" will anyway cause scsi_dec_host_busy(), so
>> does this make any difference?
> 
> The return value should be changed into 0 since returning
> SCSI_MLQUEUE_HOST_BUSY is only allowed if cmd->scsi_done(cmd) has not
> yet been called.
> 
> I expect that setting the host byte to DID_IMM_RETRY and calling
> scsi_done will make a difference, otherwise I wouldn't have suggested
> this. As explained in my previous email doing that triggers the SCSI> command completion and resubmission paths. Resubmission only happens
> if the SCSI error handler has not yet been scheduled. The SCSI error
> handler is scheduled after for all pending commands scsi_done() has
> been called or a timeout occurred. In other words, setting the host
> byte to DID_IMM_RETRY and calling scsi_done() makes it possible for
> the error handler to be scheduled, something that won't happen if
> ufshcd_queuecommand() systematically returns SCSI_MLQUEUE_HOST_BUSY.

Not getting it, sorry. :-(

The error handler sets UFSHCD_STATE_RESET and never leaves the state
as UFSHCD_STATE_RESET, so that case does not need to start the error
handler because it is already running.

The error handler is always scheduled after setting 
UFSHCD_STATE_EH_SCHEDULED_FATAL.

scsi_dec_host_busy() is called for any non-zero return value like
SCSI_MLQUEUE_HOST_BUSY:

i.e.
	reason = scsi_dispatch_cmd(cmd);
	if (reason) {
		scsi_set_blocked(cmd, reason);
		ret = BLK_STS_RESOURCE;
		goto out_dec_host_busy;
	}

	return BLK_STS_OK;

out_dec_host_busy:
	scsi_dec_host_busy(shost, cmd);

And that will wake the error handler:

static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
{
	unsigned long flags;

	rcu_read_lock();
	__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
	if (unlikely(scsi_host_in_recovery(shost))) {
		spin_lock_irqsave(shost->host_lock, flags);
		if (shost->host_failed || shost->host_eh_scheduled)
			scsi_eh_wakeup(shost);
		spin_unlock_irqrestore(shost->host_lock, flags);
	}
	rcu_read_unlock();
}

Note that scsi_host_queue_ready() won't let any requests through
when scsi_host_in_recovery(), so the potential problem is with
requests that have already been successfully submitted to the
UFS driver but have not completed. The change you suggest
does not help with that.

That seems like another problem with the patch 
"scsi: ufs: Synchronize SCSI and UFS error handling".


> In the latter case the block layer timer is reset over and over
> again. See also the blk_mq_start_request() in scsi_queue_rq(). One
> could wonder whether this is really what the SCSI core should do if a
> SCSI LLD keeps returning the SCSI_MLQUEUE_HOST_BUSY status code ...
> 
> Bart.


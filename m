Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FACC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 16:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A91D61212
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Sep 2021 16:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhIKQs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Sep 2021 12:48:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:2829 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhIKQs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Sep 2021 12:48:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10104"; a="201501164"
X-IronPort-AV: E=Sophos;i="5.85,285,1624345200"; 
   d="scan'208";a="201501164"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2021 09:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,285,1624345200"; 
   d="scan'208";a="431970270"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.174]) ([10.237.72.174])
  by orsmga006.jf.intel.com with ESMTP; 11 Sep 2021 09:47:11 -0700
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <36245674-b179-d25e-84c3-417ef2d85620@intel.com>
Date:   Sat, 11 Sep 2021 19:47:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e5307bbe-1cda-fdd2-a666-ae57cd90de07@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/09/21 1:36 am, Bart Van Assche wrote:
> On 9/7/21 9:56 AM, Bart Van Assche wrote:
>> On 9/7/21 8:43 AM, Adrian Hunter wrote:
>>> No.  Requests cannot make progress when ufshcd_state is
>>> UFSHCD_STATE_EH_SCHEDULED_FATAL, and only the error handler can change that,
>>> so if the error handler is waiting to enter the queue and blk_mq_freeze_queue()
>>> is waiting for outstanding requests, they will deadlock.
>>
>> How about adding the above text as a comment above ufshcd_clear_ua_wluns() such
>> that this information becomes available to those who have not followed this
>> conversation?
> 
> After having given patch 1/3 some further thought: an unfortunate
> effect of this patch is that unit attention clearing is skipped for
> the states UFSHCD_STATE_EH_SCHEDULED_FATAL and UFSHCD_STATE_RESET.

Only if the error handler is racing with blk_mq_freeze_queue(), but it
is not ideal.

> How about replacing patch 1/3 with the untested patch below since that
> patch does not have the disadvantage of sometimes skipping clearing UA?

I presume you mean without reverting "scsi: ufs: Synchronize SCSI
and UFS error handling" but in that case the deadlock happens because:

error handler is waiting on blk_queue_enter()
blk_queue_enter() is waiting on blk_mq_freeze_queue()
blk_mq_freeze_queue() is waiting on outstanding requests
outstanding requests are blocked by the SCSI error handler shost_state == SHOST_RECOVERY set by scsi_schedule_eh()

> 
> Thanks,
> 
> Bart.
> 
> [PATCH] scsi: ufs: Fix a recently introduced deadlock
> 
> Completing pending commands with DID_IMM_RETRY triggers the following
> code paths:
> 
>   scsi_complete()
>   -> scsi_queue_insert()
>     -> __scsi_queue_insert()
>       -> scsi_device_unbusy()
>         -> scsi_dec_host_busy()
>       -> scsi_eh_wakeup()
>       -> blk_mq_requeue_request()
> 
>   scsi_queue_rq()
>   -> scsi_host_queue_ready()
>     -> scsi_host_in_recovery()
> 
> Fixes: a113eaaf8637 ("scsi: ufs: Synchronize SCSI and UFS error handling")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c2c614da1fb8..9560f34f3d27 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2707,6 +2707,14 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>          }
>          fallthrough;
>      case UFSHCD_STATE_RESET:
> +        /*
> +         * The SCSI error handler only starts after all pending commands
> +         * have failed or timed out. Complete commands with
> +         * DID_IMM_RETRY to allow the error handler to start
> +         * if it has been scheduled.
> +         */
> +        set_host_byte(cmd, DID_IMM_RETRY);
> +        cmd->scsi_done(cmd);

Setting non-zero return value, in this case "err = SCSI_MLQUEUE_HOST_BUSY"
will anyway cause scsi_dec_host_busy(), so does this make any difference?


>          err = SCSI_MLQUEUE_HOST_BUSY;
>          goto out;
>      case UFSHCD_STATE_ERROR:


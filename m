Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43CFC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 06:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D2FD23100
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 06:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAGGIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:08:06 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:57449 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAGGIG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 01:08:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609999666; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=7fshkn7pRC+xQGJefTHPAx+Ob/QQACNkxHyRcSYC2wQ=;
 b=tMrluAVtPz/j4FxlXwOI1t/qAAkMVd1qn7ptPvEb+eTOFsSQ/JyBuTGuPs+jfNwxEcmFla9Z
 oIbvvB3aG8zne1imrMauWu85Z9fr4Q1yxuVm7drchfepruiZ+3Zs6snhmOC1zAVDCWkwZL8d
 f7bdLniW6FEfvWA39GpTNsEZwNE=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5ff6a513661021aa28fadf99 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Jan 2021 06:07:15
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0C950C433ED; Thu,  7 Jan 2021 06:07:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30FF4C433CA;
        Thu,  7 Jan 2021 06:07:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Jan 2021 14:07:14 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH v3 2/2] scsi: ufs: handle LINERESET with correct tm_cmd
In-Reply-To: <20210106214109.44041-3-jaegeuk@kernel.org>
References: <20210106214109.44041-1-jaegeuk@kernel.org>
 <20210106214109.44041-3-jaegeuk@kernel.org>
Message-ID: <96a159d6b64fce18ee63a12a6acde2a2@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jaegeuk,

On 2021-01-07 05:41, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> This fixes a warning caused by wrong reserve tag usage in 
> __ufshcd_issue_tm_cmd.
> 
> WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 
> blk_get_request+0x68/0x70
> WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 
> blk_mq_get_tag+0x438/0x46c
> 
> And, in ufshcd_err_handler(), we can avoid to send tm_cmd before 
> aborting
> outstanding commands by waiting a bit for IO completion like this.
> 
> __ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1678cec08b51..47fc8da3cbf9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -44,6 +44,9 @@
>  /* Query request timeout */
>  #define QUERY_REQ_TIMEOUT 1500 /* 1.5 seconds */
> 
> +/* LINERESET TIME OUT */
> +#define LINERESET_IO_TIMEOUT_MS			(30000) /* 30 sec */
> +
>  /* Task management command timeout */
>  #define TM_CMD_TIMEOUT	100 /* msecs */
> 
> @@ -5899,6 +5902,8 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	 * check if power mode restore is needed.
>  	 */
>  	if (hba->saved_uic_err & UFSHCD_UIC_PA_GENERIC_ERROR) {
> +		ktime_t start = ktime_get();

I don't see the connection btw line-reset and following tmf cmd.
My point is that line-reset is not the only non-fatal error which
leads us to the following tmf cmd. So the wait should be outside
of this check - just put it right before clearing outstanding reqs.

Thanks,
Can Guo.

> +
>  		hba->saved_uic_err &= ~UFSHCD_UIC_PA_GENERIC_ERROR;
>  		if (!hba->saved_uic_err)
>  			hba->saved_err &= ~UIC_ERROR;
> @@ -5906,6 +5911,20 @@ static void ufshcd_err_handler(struct 
> work_struct *work)
>  		if (ufshcd_is_pwr_mode_restore_needed(hba))
>  			needs_restore = true;
>  		spin_lock_irqsave(hba->host->host_lock, flags);
> +		/* Wait for IO completion to avoid aborting IOs */
> +		while (hba->outstanding_reqs) {
> +			ufshcd_complete_requests(hba);
> +			spin_unlock_irqrestore(hba->host->host_lock, flags);
> +			schedule();
> +			spin_lock_irqsave(hba->host->host_lock, flags);
> +			if (ktime_to_ms(ktime_sub(ktime_get(), start)) >
> +						LINERESET_IO_TIMEOUT_MS) {
> +				dev_err(hba->dev, "%s: timeout, outstanding=0x%lx\n",
> +					__func__, hba->outstanding_reqs);
> +				break;
> +			}
> +		}
> +
>  		if (!hba->saved_err && !needs_restore)
>  			goto skip_err_handling;
>  	}
> @@ -6302,9 +6321,13 @@ static irqreturn_t ufshcd_intr(int irq, void 
> *__hba)
>  		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
>  	}
> 
> -	if (enabled_intr_status && retval == IRQ_NONE) {
> -		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
> -					__func__, intr_status);
> +	if (enabled_intr_status && retval == IRQ_NONE &&
> +				!ufshcd_eh_in_progress(hba)) {
> +		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 
> 0x%08x)\n",
> +					__func__,
> +					intr_status,
> +					hba->ufs_stats.last_intr_status,
> +					enabled_intr_status);
>  		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
>  	}
> 
> @@ -6348,7 +6371,11 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba 
> *hba,
>  	 * Even though we use wait_event() which sleeps indefinitely,
>  	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
>  	 */
> -	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> +	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED |
> +						BLK_MQ_REQ_NOWAIT);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
>  	req->end_io_data = &wait;
>  	free_slot = req->tag;
>  	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
> @@ -9355,6 +9382,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
> 
>  	hba->tmf_tag_set = (struct blk_mq_tag_set) {
>  		.nr_hw_queues	= 1,
> +		.reserved_tags	= 1,
>  		.queue_depth	= hba->nutmrs,
>  		.ops		= &ufshcd_tmf_ops,
>  		.flags		= BLK_MQ_F_NO_SCHED,

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D974DC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 08:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 881782312F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 08:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbhAGIDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:03:33 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:57513 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbhAGIDd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 03:03:33 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610006590; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XlEY8yxgI8delZYCWoEHjc5wuL1+0bXAptPyM1VtN6U=;
 b=A1RJnHbvSm8rAsZi16k7W8WmrZDl8Ch87ibwnoLN67SuIkzNl2MRNyJ0Ofp4oogiYlk84AcL
 7OxxZKTZmISfaEt/4GDLMgiS10e43SIYkJ1YUPzwvXNhPdzoKFBCaCymL39TN4Y/43mjdej6
 vY1Qbzf45b4oAUaRNbLSjNwJGZc=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5ff6c023fc3778927e21b7a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Jan 2021 08:02:43
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 95101C43465; Thu,  7 Jan 2021 08:02:43 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A459DC433CA;
        Thu,  7 Jan 2021 08:02:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Jan 2021 16:02:42 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH v4 2/2] scsi: ufs: handle LINERESET with correct tm_cmd
In-Reply-To: <20210107074710.549309-3-jaegeuk@kernel.org>
References: <20210107074710.549309-1-jaegeuk@kernel.org>
 <20210107074710.549309-3-jaegeuk@kernel.org>
Message-ID: <03a47a3f49914230653bea777e2ee550@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-07 15:47, Jaegeuk Kim wrote:
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
> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to
> allocate and free TMFs")
> Fixes: 2355b66ed20c ("scsi: ufs: Handle LINERESET indication in err 
> handler")

Hi Jaegeuk,

Sorry, what is wrong with commit 2355b66ed20c? Clearing pending I/O
reqs is a general procedure for handling all non-fatal errors.

Thanks,
Can Guo.

> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 35 +++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e6e7bdf99cd7..340dd5e515dd 100644
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
> @@ -5826,6 +5829,7 @@ static void ufshcd_err_handler(struct work_struct 
> *work)
>  	int err = 0, pmc_err;
>  	int tag;
>  	bool needs_reset = false, needs_restore = false;
> +	ktime_t start;
> 
>  	hba = container_of(work, struct ufs_hba, eh_work);
> 
> @@ -5911,6 +5915,22 @@ static void ufshcd_err_handler(struct 
> work_struct *work)
>  	}
> 
>  	hba->silence_err_logs = true;
> +
> +	/* Wait for IO completion for non-fatal errors to avoid aborting IOs 
> */
> +	start = ktime_get();
> +	while (hba->outstanding_reqs) {
> +		ufshcd_complete_requests(hba);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		schedule();
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		if (ktime_to_ms(ktime_sub(ktime_get(), start)) >
> +						LINERESET_IO_TIMEOUT_MS) {
> +			dev_err(hba->dev, "%s: timeout, outstanding=0x%lx\n",
> +					__func__, hba->outstanding_reqs);
> +			break;
> +		}
> +	}
> +
>  	/* release lock as clear command might sleep */
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>  	/* Clear pending transfer requests */
> @@ -6302,9 +6322,13 @@ static irqreturn_t ufshcd_intr(int irq, void 
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
> @@ -6348,7 +6372,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba 
> *hba,
>  	 * Even though we use wait_event() which sleeps indefinitely,
>  	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
>  	 */
> -	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
> +	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(req))
> +		return PTR_ERR(req);
> +
>  	req->end_io_data = &wait;
>  	free_slot = req->tag;
>  	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);

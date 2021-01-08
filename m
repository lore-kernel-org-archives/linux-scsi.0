Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D436C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5416223447
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbhAHAy0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:54:26 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:30269 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbhAHAy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 19:54:26 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610067240; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ZnflnoUouOv7Eqb6dF8qeZur2ghTIhhUt8tvBtyEcJE=;
 b=RdgkrRUZ/8zNVKbiopVBwHgCaqYsKpYgxyiGIMBbEdlEwWKf5vLZWbV0G67cZP+mGz0l1ZQ3
 f7Elmu1ryFuBZaNMy7AHpp9FoCl1KfOEfxM+PJo5jMxb3NnOobeRnmsQ3+pmV4zmfdVO4SaG
 kz5OsQVimGh7OyTdCeWQqNNvyzo=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5ff7ad0befc4a0d0baed19a8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 08 Jan 2021 00:53:31
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 01CDCC43466; Fri,  8 Jan 2021 00:53:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F3136C433C6;
        Fri,  8 Jan 2021 00:53:29 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 08 Jan 2021 08:53:29 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH v5 2/2] scsi: ufs: fix tm request correctly when non-fatal
 error happens
In-Reply-To: <20210107185316.788815-3-jaegeuk@kernel.org>
References: <20210107185316.788815-1-jaegeuk@kernel.org>
 <20210107185316.788815-3-jaegeuk@kernel.org>
Message-ID: <acf85e531f282b3d1162a4879a1160d5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-08 02:53, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> When non-fatal error like line-reset happens, ufshcd_err_handler() 
> starts to
> abort tasks by ufshcd_try_to_abort_task(). When it tries to issue tm 
> request,
> we've hit two warnings.
> 
> WARNING: CPU: 7 PID: 7 at block/blk-core.c:630 
> blk_get_request+0x68/0x70
> WARNING: CPU: 4 PID: 157 at block/blk-mq-tag.c:82 
> blk_mq_get_tag+0x438/0x46c
> 
> After fixing the above warnings, I've hit another tm_cmd timeout, which 
> may be
> caused by unstable controller state.
> 
> __ufshcd_issue_tm_cmd: task management cmd 0x80 timed-out
> 
> Then, ufshcd_err_handler() enters full reset, and I hit kernel stuck. 
> It turned
> out ufshcd_print_trs() printed too many messages in console which 
> requires CPU
> locks. Likewise hba->silence_err_logs, we need to avoid too verbose 
> messages.
> Actually it came from ufshcd_transfer_rsp_status() when requeuing 
> commands back.
> Indeed, this is actually not an error case, so let's fix it.
> 
> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to
> allocate and free TMFs")
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

It is really good to find out the root cause! Thanks for the fix.

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index e6e7bdf99cd7..2a715f13fe1d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4996,7 +4996,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  		break;
>  	} /* end of switch */
> 
> -	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
> +	if ((host_byte(result) != DID_OK) &&
> +	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
>  		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
>  	return result;
>  }
> @@ -6302,9 +6303,13 @@ static irqreturn_t ufshcd_intr(int irq, void 
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
> @@ -6348,7 +6353,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba 
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

Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B625C433E1
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 16:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A5872083B
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 16:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="EG9LRmPD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgHCQDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 12:03:48 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:50848 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725945AbgHCQDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 12:03:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596470628; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=3o7Ua/B/jlY2+3cBPDuyOtwpBPiWkJKI/dCE//TXyZ0=; b=EG9LRmPDo016boP9ujfxfLAoqw6EDn3bQzZEVL4JbiBFNjxySXrlp3lCvnCinMGm3MXyv3S8
 lXyCrLbCBnf4nT5X7o1DXV5bR8aYuFuzzGRGCeorH4nWv+LUL4hGGSkSVnEbjbOsRKAKdAOo
 5/OWz4EeUt77znaAxSif5XIjXfo=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f283510798b10296811bd5e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 03 Aug 2020 16:02:24
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1C6F7C433A0; Mon,  3 Aug 2020 16:02:21 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 47208C433C9;
        Mon,  3 Aug 2020 16:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 47208C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v9 7/9] scsi: ufs: Move dumps in IRQ handler to error
 handler
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
 <1596445485-19834-8-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <502fb8a9-db80-2d74-3272-52f2d1593451@codeaurora.org>
Date:   Mon, 3 Aug 2020 09:02:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1596445485-19834-8-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/2020 2:04 AM, Can Guo wrote:
> Sometime dumps in IRQ handler are heavy enough to cause system stability
> issues, move them to error handler and only print basic host regs here.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Bean Huo <beanhuo@micron.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 23 +++++++++++++++--------
>   1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 6a10003..a79fbbd 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5696,6 +5696,19 @@ static void ufshcd_err_handler(struct work_struct *work)
>   				    UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
>   		needs_reset = true;
>   
> +	if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
> +			      UFSHCD_UIC_HIBERN8_MASK)) {
> +		bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
> +
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +		ufshcd_print_host_state(hba);
> +		ufshcd_print_pwr_info(hba);
> +		ufshcd_print_host_regs(hba);
> +		ufshcd_print_tmrs(hba, hba->outstanding_tasks);
> +		ufshcd_print_trs(hba, hba->outstanding_reqs, pr_prdt);
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +	}
> +
>   	/*
>   	 * if host reset is required then skip clearing the pending
>   	 * transfers forcefully because they will get cleared during
> @@ -5915,18 +5928,12 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
>   
>   		/* dump controller state before resetting */
>   		if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
> -			bool pr_prdt = !!(hba->saved_err &
> -					SYSTEM_BUS_FATAL_ERROR);
> -
>   			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
>   					__func__, hba->saved_err,
>   					hba->saved_uic_err);
> -
> -			ufshcd_print_host_regs(hba);
> +			ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE,
> +					 "host_regs: ");
>   			ufshcd_print_pwr_info(hba);
> -			ufshcd_print_tmrs(hba, hba->outstanding_tasks);
> -			ufshcd_print_trs(hba, hba->outstanding_reqs,
> -					pr_prdt);
>   		}
>   		ufshcd_schedule_eh_work(hba);
>   		retval |= IRQ_HANDLED;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86FF2C63697
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 17:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D192246A6
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 17:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="LluWHpnz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgKQRXd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 12:23:33 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:26611 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbgKQRXc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 12:23:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605633812; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=HKBzQf+Wq3jLBX3M54k/nh+GCQY6+jg1bPUkUq9gsbU=; b=LluWHpnzYtmMB0Zy+XmmTbX8CkHfhbGNzsOE7/SgdiTGFVEAZwkF5G6p4SqEd5KnFxjN1+QE
 eK2hu9tLVFjClhLbf+LzzPmh663PK27Ks+bRqq+GA8+OMRZO7dqkC9kpL9xu4lvUAywa4QzI
 AOJiE4VH9WnFpXOXuoY4TAfUKR4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fb407139a53d19da939e6e4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 17 Nov 2020 17:23:31
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57530C43464; Tue, 17 Nov 2020 17:23:31 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A6587C43460;
        Tue, 17 Nov 2020 17:23:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A6587C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v3 3/3] scsi: ufs: Print host regs in IRQ handler when AH8
 error happens
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1605596660-2987-1-git-send-email-cang@codeaurora.org>
 <1605596660-2987-4-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <1b2aacf0-ebc2-e541-2db5-2d595b4b392f@codeaurora.org>
Date:   Tue, 17 Nov 2020 09:23:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1605596660-2987-4-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/2020 11:04 PM, Can Guo wrote:
> When AH8 error happens, all the regs and states are dumped in err handler.
> Sometime we need to look into host regs right after AH8 error happens,
> which is before leaving the IRQ handler.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cd7394e..a7857f6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6057,7 +6057,8 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba)
>   		hba->saved_uic_err |= hba->uic_error;
>   
>   		/* dump controller state before resetting */
> -		if ((hba->saved_err & (INT_FATAL_ERRORS)) ||
> +		if ((hba->saved_err &
> +		     (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
>   		    (hba->saved_uic_err &&
>   		     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
>   			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

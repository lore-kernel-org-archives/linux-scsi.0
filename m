Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F11BC63777
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 04:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6F1E20872
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 04:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="iRG9t8f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbgKYESH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 23:18:07 -0500
Received: from z5.mailgun.us ([104.130.96.5]:17942 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgKYESH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 23:18:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606277886; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=sXXeHQcnq6lCeXEsk4jZuctTNRCfX/sdc8ME9NH6fks=;
 b=iRG9t8f06tPeMkVrVVV5vClEOGv5a28tXaMvYcyYNzk3iQPS7gbP1EQtUOjbDSDQ/X+7oDhy
 7ifFcs0sk1V38AIAgpfa4iszemXwOyOTRrYT8wWlC4YcP3PrspsUaItpJ8Cpe+4mst/34eFV
 l3SZ2ADnJDV0RUTVeCmu5A4Qbs4=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5fbddaf922377520eea23333 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 04:18:01
 GMT
Sender: nguyenb=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB302C43467; Wed, 25 Nov 2020 04:18:00 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1678DC433ED;
        Wed, 25 Nov 2020 04:17:59 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 20:17:59 -0800
From:   nguyenb@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] scsi: ufs: Print host regs in IRQ handler when AH8
 error happens
In-Reply-To: <1605596660-2987-4-git-send-email-cang@codeaurora.org>
References: <1605596660-2987-1-git-send-email-cang@codeaurora.org>
 <1605596660-2987-4-git-send-email-cang@codeaurora.org>
Message-ID: <c6ef8b22f151668037fb31c8163d588e@codeaurora.org>
X-Sender: nguyenb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-16 23:04, Can Guo wrote:
> When AH8 error happens, all the regs and states are dumped in err 
> handler.
> Sometime we need to look into host regs right after AH8 error happens,
> which is before leaving the IRQ handler.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index cd7394e..a7857f6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6057,7 +6057,8 @@ static irqreturn_t ufshcd_check_errors(struct
> ufs_hba *hba)
>  		hba->saved_uic_err |= hba->uic_error;
> 
>  		/* dump controller state before resetting */
> -		if ((hba->saved_err & (INT_FATAL_ERRORS)) ||
> +		if ((hba->saved_err &
> +		     (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK)) ||
>  		    (hba->saved_uic_err &&
>  		     (hba->saved_uic_err != UFSHCD_UIC_PA_GENERIC_ERROR))) {
>  			dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",

Reviewed-by: Bao D. Nguyen <nguyenb@codeaurora.org>

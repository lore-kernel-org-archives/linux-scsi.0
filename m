Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E308FC32771
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B21012072C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="q82AUQge"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390696AbgAXSD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 13:03:59 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:42131 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389638AbgAXSD5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 13:03:57 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579889037; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=/wvlJaRdxr+I0mnJPd3iMiQ1F3dK2CPJjaJ02DPirBo=; b=q82AUQgeZZgDFrWJD+edvdn1Y+SHGQioVzGlfBG22mnct6mj9IFteZy/sQnE9+LwH/BU2OKW
 Lc6lSsyYR2fASlh8l++hGtDaAL0fyd2C7FH5E1uWwHza2uTJRAv2oYY3Xf8OAjR/vmEW/mVE
 ZLRjjxjn+KX+ORvU4WYmSqkAoxE=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2b317b.7f0189c55bc8-smtp-out-n02;
 Fri, 24 Jan 2020 18:03:39 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 344B6C447B2; Fri, 24 Jan 2020 18:03:37 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EC3A1C447A2;
        Fri, 24 Jan 2020 18:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EC3A1C447A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-9-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <ce8a29c0-cc96-7f9d-9cb2-c18e537a6bef@codeaurora.org>
Date:   Fri, 24 Jan 2020 10:03:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579764349-15578-9-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/2020 11:25 PM, Can Guo wrote:
> ADAPT is added specifically for HS Gear4 mode only, select INITIAL adapt
> before do power mode change to G4 and select no adapt before switch to
> non-G4 modes.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

LGTM.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 14 +++++++++++++-
>   drivers/scsi/ufs/ufshci.h |  1 +
>   drivers/scsi/ufs/unipro.h |  7 +++++++
>   3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1ee2187..f6d4828 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4134,6 +4134,17 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
>   		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
>   						pwr_mode->hs_rate);
>   
> +	if (hba->ufs_version >= UFSHCI_VERSION_30) {
> +		if (pwr_mode->gear_tx == UFS_HS_G4)
> +			/* INITIAL ADAPT */
> +			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
> +					PA_INITIAL_ADAPT);
> +		else
> +			/* NO ADAPT */
> +			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
> +					PA_NO_ADAPT);
> +	}
> +
>   	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
>   			| pwr_mode->pwr_tx);
>   
> @@ -8422,7 +8433,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>   	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>   	    (hba->ufs_version != UFSHCI_VERSION_11) &&
>   	    (hba->ufs_version != UFSHCI_VERSION_20) &&
> -	    (hba->ufs_version != UFSHCI_VERSION_21))
> +	    (hba->ufs_version != UFSHCI_VERSION_21) &&
> +	    (hba->ufs_version != UFSHCI_VERSION_30))
>   		dev_err(hba->dev, "invalid UFS version 0x%x\n",
>   			hba->ufs_version);
>   
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> index dbb75cd..95b4b03 100644
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -104,6 +104,7 @@ enum {
>   	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
>   	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
>   	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
> +	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
>   };
>   
>   /*
> diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> index f539f87..960d175 100644
> --- a/drivers/scsi/ufs/unipro.h
> +++ b/drivers/scsi/ufs/unipro.h
> @@ -146,6 +146,12 @@
>   #define PA_SLEEPNOCONFIGTIME	0x15A2
>   #define PA_STALLNOCONFIGTIME	0x15A3
>   #define PA_SAVECONFIGTIME	0x15A4
> +#define PA_TXHSADAPTTYPE	0x15D4
> +
> +/* Adpat type for PA_TXHSADAPTTYPE attribute */
> +#define PA_REFRESH_ADAPT	0x00
> +#define PA_INITIAL_ADAPT	0x01
> +#define PA_NO_ADAPT		0x03
>   
>   #define PA_TACTIVATE_TIME_UNIT_US	10
>   #define PA_HIBERN8_TIME_UNIT_US		100
> @@ -192,6 +198,7 @@ enum ufs_hs_gear_tag {
>   	UFS_HS_G1,		/* HS Gear 1 (default for reset) */
>   	UFS_HS_G2,		/* HS Gear 2 */
>   	UFS_HS_G3,		/* HS Gear 3 */
> +	UFS_HS_G4,		/* HS Gear 4 */
>   };
>   
>   enum ufs_unipro_ver {
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

Return-Path: <SRS0=jGTy=33=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03EAC2BA83
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 18:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5A6020726
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Feb 2020 18:14:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="mC3+NctI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgBGSOp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Feb 2020 13:14:45 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:62576 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727532AbgBGSOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2020 13:14:45 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581099284; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=Iv4PGza4+6jG1rG8Ui2Bh8AMg6XFP9qGnwOYs7sfY/g=; b=mC3+NctILQStJwPK6qbWGT+kwWW+nzZ/sU+BOkCupZ92uVwU8vu4kZOSO/ATm7/oVpOjfcQ5
 q/1wlPY8mXBQrgqBR7vwDf2fCIjZiv/QIU0cr4KPvSJMy0XC962Y6Y+9NQr6EZCTPs+tFBNv
 KmT8Zcy97whH9xIGu7wwskgTkW8=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3da913.7ff5558e33e8-smtp-out-n01;
 Fri, 07 Feb 2020 18:14:43 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 07B3CC447A2; Fri,  7 Feb 2020 18:14:42 +0000 (UTC)
Received: from [10.71.154.194] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB10BC43383;
        Fri,  7 Feb 2020 18:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB10BC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 2/2] scsi: ufs: introduce common function to disable
 host TX LCC
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, beanhuo@micron.com
Cc:     cang@codeaurora.org, matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200207070357.17169-1-stanley.chu@mediatek.com>
 <20200207070357.17169-3-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <3edbf9cd-a3cb-7a99-f6ef-f767fdf64f1e@codeaurora.org>
Date:   Fri, 7 Feb 2020 10:14:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200207070357.17169-3-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/6/2020 11:03 PM, Stanley Chu wrote:
> Many vendors would like to disable host TX LCC during initialization
> flow. Introduce a common function for all users to make drivers easier to
> read and maintained. This patch does not change any functionality.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/cdns-pltfrm.c  | 2 +-
>   drivers/scsi/ufs/ufs-hisi.c     | 2 +-
>   drivers/scsi/ufs/ufs-mediatek.c | 2 +-
>   drivers/scsi/ufs/ufs-qcom.c     | 4 +---
>   drivers/scsi/ufs/ufshcd-pci.c   | 2 +-
>   drivers/scsi/ufs/ufshcd.h       | 5 +++++
>   6 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.c
> index 56a6a1ed5ec2..da065a259f6e 100644
> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> @@ -192,7 +192,7 @@ static int cdns_ufs_link_startup_notify(struct ufs_hba *hba,
>   	 * and device TX LCC are disabled once link startup is
>   	 * completed.
>   	 */
> -	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
> +	ufshcd_disable_host_tx_lcc(hba);
>   
>   	/*
>   	 * Disabling Autohibern8 feature in cadence UFS
> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
> index 5d6487350a6c..074a6a055a4c 100644
> --- a/drivers/scsi/ufs/ufs-hisi.c
> +++ b/drivers/scsi/ufs/ufs-hisi.c
> @@ -235,7 +235,7 @@ static int ufs_hisi_link_startup_pre_change(struct ufs_hba *hba)
>   	ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
>   
>   	/* Unipro PA_Local_TX_LCC_Enable */
> -	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x155E, 0x0), 0x0);
> +	ufshcd_disable_host_tx_lcc(hba);
>   	/* close Unipro VS_Mk2ExtnSupport */
>   	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xD0AB, 0x0), 0x0);
>   	ufshcd_dme_get(hba, UIC_ARG_MIB_SEL(0xD0AB, 0x0), &value);
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 8f73c860f423..9d05962feb15 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -318,7 +318,7 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
>   	 * to make sure that both host and device TX LCC are disabled
>   	 * once link startup is completed.
>   	 */
> -	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
> +	ret = ufshcd_disable_host_tx_lcc(hba);
>   	if (ret)
>   		return ret;
>   
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index c69c29a1ceb9..c2e703d58f63 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -554,9 +554,7 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
>   		 * completed.
>   		 */
>   		if (ufshcd_get_local_unipro_ver(hba) != UFS_UNIPRO_VER_1_41)
> -			err = ufshcd_dme_set(hba,
> -					UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE),
> -					0);
> +			err = ufshcd_disable_host_tx_lcc(hba);
>   
>   		break;
>   	case POST_CHANGE:
> diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
> index 3b19de3ae9a3..8f78a8151499 100644
> --- a/drivers/scsi/ufs/ufshcd-pci.c
> +++ b/drivers/scsi/ufs/ufshcd-pci.c
> @@ -44,7 +44,7 @@ static int ufs_intel_disable_lcc(struct ufs_hba *hba)
>   
>   	ufshcd_dme_get(hba, attr, &lcc_enable);
>   	if (lcc_enable)
> -		ufshcd_dme_set(hba, attr, 0);
> +		ufshcd_disable_host_tx_lcc(hba);
>   
>   	return 0;
>   }
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 81c71a3e3474..8f516b205c32 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -914,6 +914,11 @@ static inline bool ufshcd_is_hs_mode(struct ufs_pa_layer_attr *pwr_info)
>   		pwr_info->pwr_tx == FASTAUTO_MODE);
>   }
>   
> +static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
> +{
> +	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
> +}
> +
>   /* Expose Query-Request API */
>   int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
>   				  enum query_opcode opcode,
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

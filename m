Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F880C33CB8
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AF0822522
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 20:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="DoBBimC8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgATUw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 15:52:26 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:33583 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbgATUwZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 15:52:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579553545; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=/F/P/PamSf53/0NktI+vEIZjO2L7dILbSNYBUNX/1aI=; b=DoBBimC86L77ZDVQVIT+RW4lGLACCn8hlRzCszNWcWc/HUrjvuzwCNW0x1vEsyERAbvnDYOM
 pqrf5nW8yPdpQepVjGzggoktBhjd5T1wz8PHs+NokQKPta8P75AIVI1AsmPTICVwzm0OH+gw
 mf9mkiXHtGv1xM1x4dxWX+5yID0=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e261305.7f6447773fb8-smtp-out-n03;
 Mon, 20 Jan 2020 20:52:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A1680C4479C; Mon, 20 Jan 2020 20:52:19 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6EB9C433CB;
        Mon, 20 Jan 2020 20:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E6EB9C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 3/3] scsi: ufs-mediatek: enable low-power mode for
 hibern8 state
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200117035108.19699-1-stanley.chu@mediatek.com>
 <20200117035108.19699-4-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <38b2614d-1fdd-8bad-63a1-e9bc5698cc66@codeaurora.org>
Date:   Mon, 20 Jan 2020 12:52:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200117035108.19699-4-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/2020 7:51 PM, Stanley Chu wrote:
> In MediaTek Chipsets, UniPro link and ufshci can enter proprietary
> low-power mode while link is in hibern8 state.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufs-mediatek.c | 53 +++++++++++++++++++++++++++++++++
>   1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index d5194d0c4ef5..f32f3f34f6d0 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -382,11 +382,60 @@ static void ufs_mtk_device_reset(struct ufs_hba *hba)
>   	dev_info(hba->dev, "device reset done\n");
>   }
>   
> +static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
> +{
> +	int err;
> +
> +	err = ufshcd_hba_enable(hba);
> +	if (err)
> +		return err;
> +
> +	err = ufshcd_dme_set(hba,
> +			     UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> +			     0);
> +	if (err)
> +		return err;
> +
> +	err = ufshcd_uic_hibern8_exit(hba);
> +	if (!err)
> +		ufshcd_set_link_active(hba);
> +	else
> +		return err;
> +
> +	err = ufshcd_make_hba_operational(hba);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static int ufs_mtk_link_set_lpm(struct ufs_hba *hba)
> +{
> +	int err;
> +
> +	err = ufshcd_dme_set(hba,
> +			     UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> +			     1);
> +	if (err) {
> +		/* Resume UniPro state for following error recovery */
> +		ufshcd_dme_set(hba,
> +			       UIC_ARG_MIB_SEL(VS_UNIPROPOWERDOWNCONTROL, 0),
> +			       0);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
>   static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   {
> +	int err;
>   	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
>   
>   	if (ufshcd_is_link_hibern8(hba)) {
> +		err = ufs_mtk_link_set_lpm(hba);
> +		if (err)
> +			return -EAGAIN;
>   		phy_power_off(host->mphy);
>   		ufs_mtk_setup_ref_clk(hba, false);
>   	}
> @@ -397,10 +446,14 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   {
>   	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
> +	int err;
>   
>   	if (ufshcd_is_link_hibern8(hba)) {
>   		ufs_mtk_setup_ref_clk(hba, true);
>   		phy_power_on(host->mphy);
> +		err = ufs_mtk_link_set_hpm(hba);
> +		if (err)
> +			return err;
>   	}
>   
>   	return 0;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

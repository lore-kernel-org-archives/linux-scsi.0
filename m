Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1634C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 07:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED1F2173E
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 07:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="cKP1d/CC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEBHrq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 03:47:46 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:34146 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726486AbgEBHrq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 03:47:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588405665; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=P+Pvp39gn+Bpe9NwwIoHKwbE66BqpUQZbbB9u3baf8E=;
 b=cKP1d/CC+7+rJCIR6dgMoMNgpbPng1LboDUOKCqpGvpHaEw4924Qq2Up4blnBiC9ILuwAfzA
 T0/kyBKEloIHyqY8DbpLYiQQcNG7vfD9OdR1sqLYIDL05j9rcDXfrKRzOV98z+sc3e1E3euV
 OfUF6FVtNmudPa+jU5C1mN/0zX4=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ead259a.7f7767357570-smtp-out-n02;
 Sat, 02 May 2020 07:47:38 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6B9F4C44788; Sat,  2 May 2020 07:47:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8F629C433D2;
        Sat,  2 May 2020 07:47:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 02 May 2020 15:47:36 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        asutoshd@codeaurora.org, beanhuo@micron.com,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v3 1/5] scsi: ufs: enable WriteBooster on some pre-3.1 UFS
 devices
In-Reply-To: <20200501143835.26032-2-stanley.chu@mediatek.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
 <20200501143835.26032-2-stanley.chu@mediatek.com>
Message-ID: <1d471d07084d7323f0ef021e2c1b9d4e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-05-01 22:38, Stanley Chu wrote:
> WriteBooster feature can be supported by some pre-3.1 UFS devices
> by upgrading firmware.
> 
> To enable WriteBooster feature in such devices, introduce a device
> quirk to relax the entrance condition of ufshcd_wb_probe() to allow
> host driver to check those devices' WriteBooster capability.
> 
> WriteBooster feature can be available if below all conditions are
> satisfied,
> 
> 1. Host enables WriteBooster capability
> 2. UFS 3.1 device or UFS pre-3.1 device with quirk
>    UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES enabled
> 3. Device descriptor has dExtendedUFSFeaturesSupport field
> 4. WriteBooster support is specified in above field
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs_quirks.h |  7 ++++
>  drivers/scsi/ufs/ufshcd.c     | 66 ++++++++++++++++++++++-------------
>  2 files changed, 48 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs_quirks.h 
> b/drivers/scsi/ufs/ufs_quirks.h
> index df7a1e6805a3..e3175a63c676 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -101,4 +101,11 @@ struct ufs_dev_fix {
>   */
>  #define UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME	(1 << 9)
> 
> +/*
> + * Some pre-3.1 UFS devices can support extended features by upgrading
> + * the firmware. Enable this quirk to make UFS core driver probe and 
> enable
> + * supported features on such devices.
> + */
> +#define UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES (1 << 10)
> +
>  #endif /* UFS_QUIRKS_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 915e963398c4..c6668799d956 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -229,6 +229,8 @@ static struct ufs_dev_fix ufs_fixups[] = {
>  		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
>  	UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
>  		UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
> +	UFS_FIX(UFS_VENDOR_SKHYNIX, "H9HQ21AFAMZDAR",
> +		UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES),
> 
>  	END_FIX
>  };
> @@ -6800,9 +6802,19 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba 
> *hba)
> 
>  static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
>  {
> +	if (!ufshcd_is_wb_allowed(hba))
> +		return;
> +
> +	if (hba->desc_size.dev_desc <= DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP)
> +		goto wb_disabled;
> +
>  	hba->dev_info.d_ext_ufs_feature_sup =
>  		get_unaligned_be32(desc_buf +
>  				   DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
> +
> +	if (!(hba->dev_info.d_ext_ufs_feature_sup & 
> UFS_DEV_WRITE_BOOSTER_SUP))
> +		goto wb_disabled;
> +
>  	/*
>  	 * WB may be supported but not configured while provisioning.
>  	 * The spec says, in dedicated wb buffer mode,
> @@ -6818,11 +6830,29 @@ static void ufshcd_wb_probe(struct ufs_hba
> *hba, u8 *desc_buf)
>  	hba->dev_info.b_presrv_uspc_en =
>  		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
> 
> -	if (!((hba->dev_info.d_ext_ufs_feature_sup &
> -		 UFS_DEV_WRITE_BOOSTER_SUP) &&
> -		hba->dev_info.b_wb_buffer_type &&
> +	if (!(hba->dev_info.b_wb_buffer_type &&
>  	      hba->dev_info.d_wb_alloc_units))
> -		hba->caps &= ~UFSHCD_CAP_WB_EN;
> +		goto wb_disabled;
> +
> +	return;
> +
> +wb_disabled:
> +	hba->caps &= ~UFSHCD_CAP_WB_EN;
> +}
> +
> +static void ufs_fixup_device_setup(struct ufs_hba *hba)
> +{
> +	struct ufs_dev_fix *f;
> +	struct ufs_dev_info *dev_info = &hba->dev_info;
> +
> +	for (f = ufs_fixups; f->quirk; f++) {
> +		if ((f->wmanufacturerid == dev_info->wmanufacturerid ||
> +		     f->wmanufacturerid == UFS_ANY_VENDOR) &&
> +		     ((dev_info->model &&
> +		       STR_PRFX_EQUAL(f->model, dev_info->model)) ||
> +		      !strcmp(f->model, UFS_ANY_MODEL)))
> +			hba->dev_quirks |= f->quirk;
> +	}
>  }
> 
>  static int ufs_get_device_desc(struct ufs_hba *hba)
> @@ -6862,10 +6892,6 @@ static int ufs_get_device_desc(struct ufs_hba 
> *hba)
> 
>  	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
> 
> -	/* Enable WB only for UFS-3.1 */
> -	if (dev_info->wspecversion >= 0x310)
> -		ufshcd_wb_probe(hba, desc_buf);
> -
>  	err = ufshcd_read_string_desc(hba, model_index,
>  				      &dev_info->model, SD_ASCII_STD);
>  	if (err < 0) {
> @@ -6874,6 +6900,13 @@ static int ufs_get_device_desc(struct ufs_hba 
> *hba)
>  		goto out;
>  	}
> 
> +	ufs_fixup_device_setup(hba);
> +
> +	/* Enable WB only for UFS-3.1 */

Also update this comment to reflect your change?

> +	if (dev_info->wspecversion >= 0x310 ||
> +	    (hba->dev_quirks & UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES))
> +		ufshcd_wb_probe(hba, desc_buf);
> +

Can we somehow move this after ufshcd_tune_unipro_params() or come up 
with
a better way to leverage ufshcd_vops_apply_dev_quirks()? I am asking 
this
because if we only rely on adding quirks to ufs_fixups in ufshcd.c, the
table will keep growing and I am sure it will - as flash vendors are 
trying
to make their UFS2.1 products to be capable of WB (different densities 
and
different NAND processes from different vendors, the combos can be quite 
a
few). Meanwhile, some models are specifically made for some customers to
support WB, meaning having them in the table may not help in a 
generalized
way, and it is not like some hot fixes that we have to take, it is just 
for
a non-standard feature. If we can leverage 
ufshcd_vops_apply_dev_quirks(),
SoC vendors can freely add the quirk without touching ufs_fixups table,
which means you don't need to update ufs_fixups every time just for 
adding
a new model (GKI rules), you can have your own WB white list in vendor
driver. What do you think?

Thanks,

Can Guo.

>  	/*
>  	 * ufshcd_read_string_desc returns size of the string
>  	 * reset the error value
> @@ -6893,21 +6926,6 @@ static void ufs_put_device_desc(struct ufs_hba 
> *hba)
>  	dev_info->model = NULL;
>  }
> 
> -static void ufs_fixup_device_setup(struct ufs_hba *hba)
> -{
> -	struct ufs_dev_fix *f;
> -	struct ufs_dev_info *dev_info = &hba->dev_info;
> -
> -	for (f = ufs_fixups; f->quirk; f++) {
> -		if ((f->wmanufacturerid == dev_info->wmanufacturerid ||
> -		     f->wmanufacturerid == UFS_ANY_VENDOR) &&
> -		     ((dev_info->model &&
> -		       STR_PRFX_EQUAL(f->model, dev_info->model)) ||
> -		      !strcmp(f->model, UFS_ANY_MODEL)))
> -			hba->dev_quirks |= f->quirk;
> -	}
> -}
> -
>  /**
>   * ufshcd_tune_pa_tactivate - Tunes PA_TActivate of local UniPro
>   * @hba: per-adapter instance
> @@ -7244,8 +7262,6 @@ static int ufshcd_device_params_init(struct 
> ufs_hba *hba)
> 
>  	ufshcd_get_ref_clk_gating_wait(hba);
> 
> -	ufs_fixup_device_setup(hba);
> -
>  	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
>  			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>  		hba->dev_info.f_power_on_wp_en = flag;

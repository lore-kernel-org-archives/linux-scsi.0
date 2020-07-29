Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F21AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 09:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C79920838
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 09:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="fY+iDjNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgG2JVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 05:21:51 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:43538 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgG2JVv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 05:21:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596014510; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=etwntT/UXHBGXrs4qAMnLbYZVQi1JM8geWOVCkcTuo0=;
 b=fY+iDjNcQwBZZKTi7HCkSjgMLmX0k6zWD5U8XJo9XoQHS11JatOk0M4QDdOoyxQV3BfbWsIq
 3eAnjuHkahIz+5F/5lwys+tDGWlOnm+8lTS2o8+JzTnEfkYbUSKRCST4YGI//cFlV4ss8ExP
 6OADBs9TngVSSWHPpT4ESc3ssig=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-east-1.postgun.com with SMTP id
 5f213fad1db0b33fd8e1e5a0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 29 Jul 2020 09:21:49
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EB02CC43391; Wed, 29 Jul 2020 09:21:48 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B7C02C433C6;
        Wed, 29 Jul 2020 09:21:47 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Jul 2020 17:21:47 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
Subject: Re: [PATCH v1 1/2] scsi: ufs: Introduce device quirk
 "DELAY_AFTER_LPM"
In-Reply-To: <20200729051840.31318-2-stanley.chu@mediatek.com>
References: <20200729051840.31318-1-stanley.chu@mediatek.com>
 <20200729051840.31318-2-stanley.chu@mediatek.com>
Message-ID: <1cf315e12d21dd91906321d7303cff99@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-29 13:18, Stanley Chu wrote:
> Some UFS devices require delay after VCC power rail is turned-off.
> Introduce a device quirk "DELAY_AFTER_LPM" to add 5ms delays after
> VCC power-off during suspend flow.
> 
> Signed-off-by: Andy Teng <andy.teng@mediatek.com>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs_quirks.h |  7 +++++++
>  drivers/scsi/ufs/ufshcd.c     | 11 +++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs_quirks.h 
> b/drivers/scsi/ufs/ufs_quirks.h
> index 2a0041493e30..07f559ac5883 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -109,4 +109,11 @@ struct ufs_dev_fix {
>   */
>  #define UFS_DEVICE_QUIRK_SUPPORT_EXTENDED_FEATURES (1 << 10)
> 
> +/*
> + * Some UFS devices require delay after VCC power rail is turned-off.
> + * Enable this quirk to introduce 5ms delays after VCC power-off 
> during
> + * suspend flow.
> + */
> +#define UFS_DEVICE_QUIRK_DELAY_AFTER_LPM        (1 << 11)
> +
>  #endif /* UFS_QUIRKS_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index acba2271c5d3..63f4e2f75aa1 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8111,6 +8111,8 @@ static int ufshcd_link_state_transition(struct
> ufs_hba *hba,
> 
>  static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
>  {
> +	bool vcc_off = false;
> +
>  	/*
>  	 * It seems some UFS devices may keep drawing more than sleep current
>  	 * (atleast for 500us) from UFS rails (especially from VCCQ rail).
> @@ -8139,13 +8141,22 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba 
> *hba)
>  	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba) &&
>  	    !hba->dev_info.is_lu_power_on_wp) {
>  		ufshcd_setup_vreg(hba, false);
> +		vcc_off = true;
>  	} else if (!ufshcd_is_ufs_dev_active(hba)) {
>  		ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
> +		vcc_off = true;
>  		if (!ufshcd_is_link_active(hba)) {
>  			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
>  			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq2);
>  		}
>  	}
> +
> +	/*
> +	 * Some UFS devices require delay after VCC power rail is turned-off.
> +	 */
> +	if (vcc_off && hba->vreg_info.vcc &&
> +		hba->dev_quirks & UFS_DEVICE_QUIRK_DELAY_AFTER_LPM)
> +		usleep_range(5000, 5100);
>  }
> 
>  static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)

Reviewed-by: Can Guo <cang@codeaurora.org>

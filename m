Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB3FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Nov 2023 20:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjKGUPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Nov 2023 15:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjKGUPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2023 15:15:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF2D12F
        for <linux-scsi@vger.kernel.org>; Tue,  7 Nov 2023 12:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699388069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpwVUsKsWJB8ELVQCuxVLyRNagfKcI1oOQIR0b5JV9c=;
        b=ASjxKDTFXVhq8bfonfVbFf06UZpPyIMK7nnMCuM2c0vnyTEZN9XxQxG7Sj7ts5Nv2Y/MbH
        UXwR9D75m6A/ZqDkd6ka66b7BUZcbY00U7kmVSqav+mnRye9oKpZ6YzGgLUSvsOhIweH1H
        ipxKKVTb/guEuqWSQnzfl9Q7ECgkyxE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-Z-_5dWTBPdSqfnzcZ75qtQ-1; Tue, 07 Nov 2023 15:14:25 -0500
X-MC-Unique: Z-_5dWTBPdSqfnzcZ75qtQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-670aa377deeso74708366d6.3
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2023 12:14:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388064; x=1699992864;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpwVUsKsWJB8ELVQCuxVLyRNagfKcI1oOQIR0b5JV9c=;
        b=tPLJKDLQ6s0dR2AS46qqLdkwAEN6Xb7UwjHKVnCpvOn+T/G98aHSoO7g0O2gaTEpQ1
         pZItLjiwjm1ojUt8nXnXVoflD2z6THkYt2JNzsYyiOKLJstsfct0FMgKwZTnO2RIL5nL
         fpDT3xheLFswhoLFnkOdqzhmpWqHcpl4FS+2Lk9ZOnl5vyimbKqUyJ9q3VSyXoui+qaQ
         NMTK4w8B1BsJolBJX66prb690URvVa25uh362um9JtiO5PNwiyVDE9mHhZLEymehL3BI
         alLid3aqxqEiy0Acc05EBBajd8PIFVQnlEKmVRynOtB95wUW/Iskj4eG3xbI8ua8VCpS
         UgyQ==
X-Gm-Message-State: AOJu0Yyo4n8SeOpJiQRj42gu7IT6PaHFWJSDi3A04lpjn7EqH16OkTWv
        8VTCq4aWSkuY94pW6MvpGRax1eI2bQhNnQAzHmVAcuDNgAHgGNrb7ElJFl6T9STdfxcZSbYM6Sj
        5bZ/V9VnVSWyeSm2Dx4zkEV4SGvFn5g==
X-Received: by 2002:a0c:cb88:0:b0:66d:5d31:999e with SMTP id p8-20020a0ccb88000000b0066d5d31999emr29908600qvk.43.1699388064505;
        Tue, 07 Nov 2023 12:14:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVYjdKwQ+pE8aJZPxVzo9sq0Gg+0h0LojH6Wg7xle1xVHG2mmu2Be0/uKehTX60Jrx8gapeQ==
X-Received: by 2002:a0c:cb88:0:b0:66d:5d31:999e with SMTP id p8-20020a0ccb88000000b0066d5d31999emr29908579qvk.43.1699388064237;
        Tue, 07 Nov 2023 12:14:24 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id p14-20020a0cc3ce000000b0065b1f90ff8csm247125qvi.40.2023.11.07.12.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 12:14:23 -0800 (PST)
Date:   Tue, 7 Nov 2023 14:14:21 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Can Guo <cang@qti.qualcomm.com>
Cc:     quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        "Bao D . Nguyen" <quic_nguyenb@quicinc.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] scsi: ufs: ufs-qcom: Setup host power mode during
 init
Message-ID: <pami4442fspxmmyg32jjn2iyzozkyeblcuzwpmkql7wfa3xvq5@ftblajt7hsgo>
References: <1699332374-9324-1-git-send-email-cang@qti.qualcomm.com>
 <1699332374-9324-3-git-send-email-cang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1699332374-9324-3-git-send-email-cang@qti.qualcomm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2023 at 08:46:08PM -0800, Can Guo wrote:
> From: Can Guo <quic_cang@quicinc.com>
> 
> Setup host power mode and its limitations during UFS host driver init to
> avoid repetitive work during every power mode change.
> 
> Co-developed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 22 ++++++++++++++--------
>  drivers/ufs/host/ufs-qcom.h |  1 +
>  2 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index aee66a3..cc0eb37 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -898,7 +898,7 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  				struct ufs_pa_layer_attr *dev_req_params)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> -	struct ufs_host_params host_params;
> +	struct ufs_host_params *host_params = &host->host_params;
>  	int ret = 0;
>  
>  	if (!dev_req_params) {
> @@ -908,13 +908,7 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  
>  	switch (status) {
>  	case PRE_CHANGE:
> -		ufshcd_init_host_param(&host_params);
> -		host_params.hs_rate = UFS_QCOM_LIMIT_HS_RATE;

You drop the setting of hs_rate in your new function. It seems setting that's
also overkill since UFS_QCOM_LIMIT_HS_RATE == PA_HS_MODE_B. hs_rate is
already set to that in ufshcd_init_host_param(), so removing it makes
sense.

Can you remove it prior in its own patch, and remove the now unused
UFS_QCOM_LIMIT_HS_RATE as well from ufs-qcom.h?

With that in place this seems like a good improvement:

Acked-by: Andrew Halaney <ahalaney@redhat.com>

> -
> -		/* This driver only supports symmetic gear setting i.e., hs_tx_gear == hs_rx_gear */
> -		host_params.hs_tx_gear = host_params.hs_rx_gear = ufs_qcom_get_hs_gear(hba);
> -
> -		ret = ufshcd_negotiate_pwr_param(&host_params, dev_max_params, dev_req_params);
> +		ret = ufshcd_negotiate_pwr_param(host_params, dev_max_params, dev_req_params);
>  		if (ret) {
>  			dev_err(hba->dev, "%s: failed to determine capabilities\n",
>  					__func__);
> @@ -1049,6 +1043,17 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>  		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>  }
>  
> +static void ufs_qcom_set_host_params(struct ufs_hba *hba)
> +{
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> +	struct ufs_host_params *host_params = &host->host_params;
> +
> +	ufshcd_init_host_param(host_params);
> +
> +	/* This driver only supports symmetic gear setting i.e., hs_tx_gear == hs_rx_gear */
> +	host_params->hs_tx_gear = host_params->hs_rx_gear = ufs_qcom_get_hs_gear(hba);
> +}
> +
>  static void ufs_qcom_set_caps(struct ufs_hba *hba)
>  {
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
> @@ -1273,6 +1278,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  
>  	ufs_qcom_set_caps(hba);
>  	ufs_qcom_advertise_quirks(hba);
> +	ufs_qcom_set_host_params(hba);
>  
>  	err = ufs_qcom_ice_init(host);
>  	if (err)
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 9950a00..ab94c54 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -240,6 +240,7 @@ struct ufs_qcom_host {
>  
>  	struct gpio_desc *device_reset;
>  
> +	struct ufs_host_params host_params;
>  	u32 phy_gear;
>  
>  	bool esi_enabled;
> -- 
> 2.7.4
> 
> 


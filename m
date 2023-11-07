Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEA2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Nov 2023 19:37:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbjKGThQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Nov 2023 14:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbjKGThP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2023 14:37:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6FE184
        for <linux-scsi@vger.kernel.org>; Tue,  7 Nov 2023 11:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699385785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f2GkHL9Asj7cZ9gDAWnYJZ3/Dq1fD/MZuGhccXlmPBI=;
        b=MgREWolNd1OUGwr4kUNuSSAb+3Cf4DB7DMJ6pfT8lNvGQRTQDXvOZSPCmyD+TA+kvoWMC+
        mJ0b7TkM2NU1Ut0nQ9hGr0YB9rLGnoBe9b75MZPfEQRUunLEH9wuzs01O/WRXgJcSjBXJ3
        D5QDXqEVlYuyFD9rbih1RVQyOf84Jxw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-uj53yCZSMKSb1wIBx0TbyA-1; Tue, 07 Nov 2023 14:36:24 -0500
X-MC-Unique: uj53yCZSMKSb1wIBx0TbyA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-778a455f975so692311885a.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2023 11:36:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699385784; x=1699990584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2GkHL9Asj7cZ9gDAWnYJZ3/Dq1fD/MZuGhccXlmPBI=;
        b=D7KMOZs+rbz6jI1oUaWf3POFIpksSPJAtFyFIssK87tRotBLDmKh1LZ5lzdyLPtbBX
         EE72tJa9mP28QY4EuC8ba58L1RE9hkDi+XYkBNBi9+QbOgY4wcT6U9D7LyhfWfXIzL40
         D6iBt8ujS++EZndsIr3pwPgJp2Bf4di5jGc/3Bfdropip6dvGx2VPxLixUwu4rxBbfT0
         Z75puUdPiKEWYvSFbWj4f0W5qGHFcz1DPFfMaJrJMIhpeauX6o7LNg9lwLIbTAA+TIB6
         rfar2z8srYgRL/noZxAPCxrjjXuFiaYDoKcKyU1FdUFNjkdBH2L4KS5ObwXRw+g2L2kx
         VidQ==
X-Gm-Message-State: AOJu0YzpHEkfDk+soaWRlPDwna4V5OcVtNxduspUSSTEa5z3/KzX4rHk
        YL0/e418hrOk35WnwLbolWrgR7/D3tmXarKuUIUQsTgCu23EJBfR5KxyICzZWUhsdCr5NtvsCTZ
        QNTjNHHcdrLjYucg2qf9BSQ==
X-Received: by 2002:ad4:5ecf:0:b0:675:6a83:8084 with SMTP id jm15-20020ad45ecf000000b006756a838084mr17136101qvb.14.1699385783797;
        Tue, 07 Nov 2023 11:36:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCasVvUsu1Pm+2+uqpGskpzIAz52YVkupGLyfFo54ljOeoSzf1eiTLLEVSdNTLByNhDpkAJg==
X-Received: by 2002:ad4:5ecf:0:b0:675:6a83:8084 with SMTP id jm15-20020ad45ecf000000b006756a838084mr17136067qvb.14.1699385783454;
        Tue, 07 Nov 2023 11:36:23 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id k16-20020ad44210000000b0067169e210b3sm206076qvp.70.2023.11.07.11.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 11:36:23 -0800 (PST)
Date:   Tue, 7 Nov 2023 13:36:20 -0600
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Can Guo <cang@qti.qualcomm.com>
Cc:     quic_cang@quicinc.com, bvanassche@acm.org, mani@kernel.org,
        stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Brian Masney <bmasney@redhat.com>,
        "moderated list:ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..." 
        <linux-mediatek@lists.infradead.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..." 
        <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] scsi: ufs: host: Rename structure ufs_dev_params
 to ufs_host_params
Message-ID: <fcovysoo6vxvqdrypfbnfyclrmifibio46rne5zhiqnmqhzd7k@5ltemasdhfxp>
References: <1699332374-9324-1-git-send-email-cang@qti.qualcomm.com>
 <1699332374-9324-2-git-send-email-cang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1699332374-9324-2-git-send-email-cang@qti.qualcomm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 06, 2023 at 08:46:07PM -0800, Can Guo wrote:
> From: Can Guo <quic_cang@quicinc.com>
> 
> Structure ufs_dev_params is actually used in UFS host vendor drivers to
> declare host specific power mode parameters, like ufs_<vendor>_params or
> host_cap, which makes the code not very straightforward to read. Rename the
> structure ufs_dev_params to ufs_host_params and unify the declarations in
> all vendor drivers to host_params.
> 
> In addition, rename the two functions ufshcd_init_dev_pwr_param() and

nit: s/ufshcd_init_dev_pwr_param/ufshcd_init_pwr_dev_param/

> ufshcd_get_dev_pwr_param() which work based on the ufs_host_params to

nit: s/ufshcd_get_dev_pwr_param/ufshcd_get_pwr_dev_param/

> ufshcd_init_host_param() and ufshcd_negotiate_pwr_param() respectively to
> avoid confusions.
> 
> This change does not change any functionalities or logic.
> 
> Signed-off-by: Can Guo <quic_cang@quicinc.com>
> ---
>  drivers/ufs/host/ufs-exynos.c    |  7 +++---
>  drivers/ufs/host/ufs-hisi.c      | 11 ++++-----
>  drivers/ufs/host/ufs-mediatek.c  | 12 ++++------
>  drivers/ufs/host/ufs-qcom.c      | 12 ++++------
>  drivers/ufs/host/ufshcd-pltfrm.c | 49 ++++++++++++++++++++--------------------
>  drivers/ufs/host/ufshcd-pltfrm.h | 10 ++++----
>  6 files changed, 47 insertions(+), 54 deletions(-)
> 

<snip>

> diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> index da2558e..6e65b61 100644
> --- a/drivers/ufs/host/ufshcd-pltfrm.c
> +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> @@ -285,17 +285,17 @@ static int ufshcd_parse_operating_points(struct ufs_hba *hba)
>  }
>  
>  /**
> - * ufshcd_get_pwr_dev_param - get finally agreed attributes for
> + * ufshcd_negotiate_pwr_param - get finally agreed attributes for
>   *                            power mode change
> - * @pltfrm_param: pointer to platform parameters
> + * @host_param: pointer to platform parameters
>   * @dev_max: pointer to device attributes
>   * @agreed_pwr: returned agreed attributes
>   *
>   * Return: 0 on success, non-zero value on failure.
>   */
> -int ufshcd_get_pwr_dev_param(const struct ufs_dev_params *pltfrm_param,
> -			     const struct ufs_pa_layer_attr *dev_max,
> -			     struct ufs_pa_layer_attr *agreed_pwr)
> +int ufshcd_negotiate_pwr_param(const struct ufs_host_params *host_param,
> +			       const struct ufs_pa_layer_attr *dev_max,
> +			       struct ufs_pa_layer_attr *agreed_pwr)
>  {
>  	int min_pltfrm_gear;

If you're going to change pltfrm -> host, maybe do so for
min_pltfrm_gear too? I think this all reads nicer with the functions
changed as is, but the consistency would be nice in my opinion.

Outside of those nits, I think this reads nicer now as well.

Acked-by: Andrew Halaney <ahalaney@redhat.com>


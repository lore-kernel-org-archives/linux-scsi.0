Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFFCC83012
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E99C22206
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 08:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728811AbgLBIZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 03:25:49 -0500
Received: from m42-5.mailgun.net ([69.72.42.5]:54276 "EHLO m42-5.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgLBIZt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Dec 2020 03:25:49 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Dec 2020 03:25:48 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606897523; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=UYqvFofyELSc9o6qASO+qKPaOY+Ee0XgW1jNEcCb6qA=;
 b=o0eW0EIc9bPVbgx9RCg1e49Bsu0iwG59Ac+FL/q71OCPGgkdFCqiGRDUXBNi0eMM4m2ipdGW
 b3grybSj89Us8Ftz6bOVWSi3Y9Ey3IItlhaB2K79NVdPProLQ8b1z/kyBY7DSsLWfmf8y1WA
 T/4scISTiWl4QmcUygTSDlf5n9U=
X-Mailgun-Sending-Ip: 69.72.42.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fc74e181f6054cb8d6f069d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 08:19:36
 GMT
Sender: nguyenb=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 37A3FC43468; Wed,  2 Dec 2020 08:19:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nguyenb)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03215C43463;
        Wed,  2 Dec 2020 08:19:33 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Dec 2020 00:19:33 -0800
From:   nguyenb@codeaurora.org
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, chaotian.jing@mediatek.com,
        cc.chou@mediatek.com, jiajie.hao@mediatek.com,
        alice.chao@mediatek.com
Subject: Re: [PATCH v2] scsi: ufs: Remove pre-defined initial voltage values
 of device powers
In-Reply-To: <20201201065114.1001-1-stanley.chu@mediatek.com>
References: <20201201065114.1001-1-stanley.chu@mediatek.com>
Message-ID: <c855aaeb419bc7c124889c5afb0cae71@codeaurora.org>
X-Sender: nguyenb@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-30 22:51, Stanley Chu wrote:
> UFS specficication allows different VCC configurations for UFS devices,
> for example,
> 	(1). 2.70V - 3.60V (Activated by default in UFS core driver)
> 	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
>                           device tree)
> 	(3). 2.40V - 2.70V (Supported since UFS 3.x)
> 
> With the introduction of UFS 3.x products, an issue is happening that
> UFS driver will use wrong "min_uV-max_uV" values to configure the
> voltage of VCC regulator on UFU 3.x products with the configuration (3)
> used.
> 
> To solve this issue, we simply remove pre-defined initial VCC voltage
> values in UFS core driver with below reasons,
> 
> 1. UFS specifications do not define how to detect the VCC configuration
>    supported by attached device.
> 
> 2. Device tree already supports standard regulator properties.
> 
> Therefore VCC voltage shall be defined correctly in device tree, and
> shall not changed by UFS driver. What UFS driver needs to do is simply
> enable or disable the VCC regulator only.
> 
> Similar change is applied to VCCQ and VCCQ2 as well.
> 
> Note that we keep struct ufs_vreg unchanged. This is allow vendors to
> configure proper min_uV and max_uV of any regulators to make
> regulator_set_voltage() works during regulator toggling flow.
> Without specific vendor configurations, min_uV and max_uV will be NULL
> by default and UFS core driver will enable or disable the regulator
> only without adjusting its voltage.
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c 
> b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index a6f76399b3ae..09e2f04bf4f6 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -133,22 +133,6 @@ static int ufshcd_populate_vreg(struct device
> *dev, const char *name,
>  		vreg->max_uA = 0;
>  	}
> 
> -	if (!strcmp(name, "vcc")) {
> -		if (of_property_read_bool(np, "vcc-supply-1p8")) {
> -			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
> -			vreg->max_uV = UFS_VREG_VCC_1P8_MAX_UV;
> -		} else {
> -			vreg->min_uV = UFS_VREG_VCC_MIN_UV;
> -			vreg->max_uV = UFS_VREG_VCC_MAX_UV;
> -		}
> -	} else if (!strcmp(name, "vccq")) {
> -		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
> -		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
> -	} else if (!strcmp(name, "vccq2")) {
> -		vreg->min_uV = UFS_VREG_VCCQ2_MIN_UV;
> -		vreg->max_uV = UFS_VREG_VCCQ2_MAX_UV;
> -	}
> -
>  	goto out;
Do we need this "goto out;"?

> 
>  out:

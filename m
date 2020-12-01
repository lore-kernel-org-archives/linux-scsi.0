Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986CAC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E0DB20758
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:50:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="p2g3RSqn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390654AbgLAQuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:50:24 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:29445 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387673AbgLAQuX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:50:23 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2020 11:50:23 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606841402; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=J4NInOiSsOXx9djpu9n6TUdGlG96H46ZcKWid9CcFaU=; b=p2g3RSqn1vGGlPbZYyQ8B7jcNSCgaJ1puTV5yFwm3EHjSy/sfPOUjRc0M7LGicLg3oAt8A6Z
 1W15ycGINaw9JtQfGo1X/1xn7CUKdj3u+/8JPtYQSc/7JGQ7UmpmAtVibWz3HgyT74/8PUhW
 YfbJJz9MFXEHUTQBh28IgMUhPPg=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fc672b451762b1886ea4dee (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Dec 2020 16:43:32
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 531DCC43460; Tue,  1 Dec 2020 16:43:31 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D80AC433ED;
        Tue,  1 Dec 2020 16:43:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D80AC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2] scsi: ufs: Remove pre-defined initial voltage values
 of device powers
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, bjorn.andersson@linaro.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
References: <20201201065114.1001-1-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <1ad24257-70cd-b16a-6ad4-c6705189a0e6@codeaurora.org>
Date:   Tue, 1 Dec 2020 08:43:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201201065114.1001-1-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/2020 10:51 PM, Stanley Chu wrote:
> UFS specficication allows different VCC configurations for UFS devices,
> for example,
> 	(1). 2.70V - 3.60V (Activated by default in UFS core driver)
> 	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
>                            device tree)
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
>     supported by attached device.
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

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd-pltfrm.c | 16 ----------------
>   1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index a6f76399b3ae..09e2f04bf4f6 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -133,22 +133,6 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
>   		vreg->max_uA = 0;
>   	}
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
>   	goto out;
>   
>   out:
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project

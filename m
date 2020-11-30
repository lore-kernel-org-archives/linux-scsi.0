Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854A3C83016
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 23:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36091208C3
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 23:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FMuoHiP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbgK3XKR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 18:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731152AbgK3XKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 18:10:15 -0500
Received: from mail-oo1-xc43.google.com (mail-oo1-xc43.google.com [IPv6:2607:f8b0:4864:20::c43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD27AC0613D2
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 15:09:35 -0800 (PST)
Received: by mail-oo1-xc43.google.com with SMTP id t142so3084359oot.7
        for <linux-scsi@vger.kernel.org>; Mon, 30 Nov 2020 15:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ElQq1bkIiUYhrFnOCJXzaDWlbvoQCXiavddjZw8fCCM=;
        b=FMuoHiP05HX4Iz0WlIi5VX49F90NYlSP+7bikhMJh2BsC+xXuTlcK9Z1kZf3N5vC+w
         iY7nofNxeSeb0INIGsnvNaEMT/Jnk/cccAvTNLBvGVrltFDk65xHRGuA5rsl7QmxOhLG
         2x39e51e5VzrLbsvHMi7oIW/mOKEspqgfb3cQ5jJSbXkmSXRHDHeHpx0Z0pAj8YbcdSJ
         COvnLQpn3IcUdhEejlQQsBZiEL779czeYspfppjy3ZhsEvGP7IMmQIAx8ABlytPME2Mz
         iHZESCTK/CK33qNW2BrWgDI4EvztYXJx4wcDs+tQKF7em1iNZORrDeSB+rTEf2/U7m4N
         uAnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ElQq1bkIiUYhrFnOCJXzaDWlbvoQCXiavddjZw8fCCM=;
        b=cL+m3eflkoLTpHN+wv5JKiXzzqNoM6vk6YMR50MiYni0pCV0bui332VM+ydOwtXUSY
         zA8kGQobmLwEQ9tquxzJsjsqb29KMzVgyGRFM5dHDM08P1Bj2TvoMut3KxaD3WvVEFqw
         d4lobfhx0BpYdgxIQBLdSPgrG8TiEJgFisz386YHOAqCzFTxyYXhzHfy+7NAA3g/MYm/
         CzQD26cWv+HxmqB2l6MydyKYCzIhY5EfAS68kg4tevfrPeqt7ZIoHQsiZBxWoUo2kBoY
         QrrCjAgxzma3AKHvZTPygVAar6R2/KSQL8MzY8StZIV3yvptlDCPHVpkV4nI84zsqbIT
         UPzg==
X-Gm-Message-State: AOAM5338TbsmdhQlprhL/g+Dx8g4Ih2EBivyRUYB+HeBlyK5py6jwdcl
        3BQFiisAjPUJjb29BsuqSQJ8Eg==
X-Google-Smtp-Source: ABdhPJxGYQ4JvywSH3rS4u9MQVQ1PyCUIezE6Kx9aV63JKBzcvEBclFVAIjJGy8bzkoxOT8vS5Yi7g==
X-Received: by 2002:a4a:91de:: with SMTP id e30mr17437722ooh.58.1606777775002;
        Mon, 30 Nov 2020 15:09:35 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id m8sm5603517otm.71.2020.11.30.15.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 15:09:34 -0800 (PST)
Date:   Mon, 30 Nov 2020 17:09:32 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org, cang@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nguyenb@codeaurora.org, kuohong.wang@mediatek.com,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com, chaotian.jing@mediatek.com,
        cc.chou@mediatek.com, jiajie.hao@mediatek.com,
        alice.chao@mediatek.com
Subject: Re: [RFC PATCH v1] scsi: ufs: Remove pre-defined initial VCC voltage
 values
Message-ID: <X8V7rM6GJd2IOo1f@builder.lan>
References: <20201130091610.2752-1-stanley.chu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130091610.2752-1-stanley.chu@mediatek.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon 30 Nov 03:16 CST 2020, Stanley Chu wrote:

> UFS specficication allows different VCC configurations for UFS devices,
> for example,
> 	(1). 2.70V - 3.60V (By default)
> 	(2). 1.70V - 1.95V (Activated if "vcc-supply-1p8" is declared in
>                           device tree)
> 	(3). 2.40V - 2.70V (Supported since UFS 3.x)
> 
> With the introduction of UFS 3.x products, an issue is happening that
> UFS driver will use wrong "min_uV/max_uV" configuration to toggle VCC
> regulator on UFU 3.x products with VCC configuration (3) used.
> 
> To solve this issue, we simply remove pre-defined initial VCC voltage
> values in UFS driver with below reasons,
> 
> 1. UFS specifications do not define how to detect the VCC configuration
>    supported by attached device.
> 
> 2. Device tree already supports standard regulator properties.
> 
> Therefore VCC voltage shall be defined correctly in device tree, and
> shall not be changed by UFS driver. What UFS driver needs to do is simply
> enabling or disabling the VCC regulator only.
> 
> This is a RFC conceptional patch. Please help review this and feel
> free to feedback any ideas. Once this concept is accepted, and then
> I would post a more completed patch series to fix this issue.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>


This is the correct thing to do and I would prefer that we did the same
for vccq and vccq2 as well - and thereby remove the min_uV and max_uV
from ufs_vreg.

Regards,
Bjorn

> ---
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
> index a6f76399b3ae..3965be03c136 100644
> --- a/drivers/scsi/ufs/ufshcd-pltfrm.c
> +++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
> @@ -133,15 +133,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
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
> +	if (!strcmp(name, "vccq")) {
>  		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
>  		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
>  	} else if (!strcmp(name, "vccq2")) {
> -- 
> 2.18.0
> 

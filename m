Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29B3C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DA12207AB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 06:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732625AbgLRGKC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 01:10:02 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:12722 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgLRGKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 01:10:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608271782; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=wvH4HZDno0lJ1hR1mOD7hwlzls6bXIAXkA0JtzPzJ6o=;
 b=emjO4B5MY4DK0dTVU8KlT5nj8aLIimmc/9ZKDqaDU+0jAzLSgrKJLO7aWaGuQgO0Zl31z3E4
 /l9S9Bb9o0MEkvFh5NxBV2QYyudZpYJhKIBOr10Xx61PP5biwX5ZuMTtC1JziwpXR8dBk7zP
 nfINCyHgXXXpkQ+cpd09VqKRidQ=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fdc478b93a3d2b1cdc83cfa (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Dec 2020 06:09:15
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D4E34C433CA; Fri, 18 Dec 2020 06:09:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 195D2C433C6;
        Fri, 18 Dec 2020 06:09:15 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Dec 2020 14:09:15 +0800
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
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH v2 2/4] scsi: ufs: Remove redundant null checking of
 devfreq instance
In-Reply-To: <20201216131639.4128-3-stanley.chu@mediatek.com>
References: <20201216131639.4128-1-stanley.chu@mediatek.com>
 <20201216131639.4128-3-stanley.chu@mediatek.com>
Message-ID: <06d27572bb06ed44e914b830201b2e45@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-16 21:16, Stanley Chu wrote:
> hba->devfreq is zero-initialized thus it is not required
> to check its existence in ufshcd_add_lus() function which
> is invoked during initialization only.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a91b73a1fc48..9cc16598136d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7636,15 +7636,13 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>  			&hba->pwr_info,
>  			sizeof(struct ufs_pa_layer_attr));
>  		hba->clk_scaling.saved_pwr_info.is_valid = true;
> -		if (!hba->devfreq) {
> -			hba->clk_scaling.is_allowed = true;
> -			ret = ufshcd_devfreq_init(hba);
> -			if (ret)
> -				goto out;
> +		hba->clk_scaling.is_allowed = true;
> +		ret = ufshcd_devfreq_init(hba);
> +		if (ret)
> +			goto out;
> 
> -			hba->clk_scaling.is_enabled = true;
> -			ufshcd_clkscaling_init_sysfs(hba);
> -		}
> +		hba->clk_scaling.is_enabled = true;
> +		ufshcd_clkscaling_init_sysfs(hba);
>  	}
> 
>  	ufs_bsg_probe(hba);

Reviewed-by: Can Guo <cang@codeaurora.org>

Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A1AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 21:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbiGVVAQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 17:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiGVVAP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 17:00:15 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371D660F9
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 14:00:13 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id q22so183990pgt.9
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 14:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rAec0w8oMUoPsElfLNtomIsL0LPvjitCy/MNYGvUdLc=;
        b=kANu5Xo/80iB8NiJmLq7Co6PaivU2TiIOzkVIf4G+cHpAB20ZschAVHuKvAu6HG5+j
         xZqu3+uHMarcxjLaA5nZdgnqPjU7ZkGuELI3Py3S46nwAr0hLFfZHEB7alSI+g6zg+p9
         YVfjolsuCVv41qLBzlbnCGt3X/Tormh74YTrpkKanz9RdPIs/C/r97XILE2UElPu/1Zt
         i558i5c35uUabKm99aGfaSfwDUmTqAOikPepi/Qe1/4sHzxtqi3qDs0o0bklXMP3Mrq5
         oppqE0lBps1LKMbyiT7VGRx6Z+HhbuF8NxmcW0MGv77TvnSsR5HtHmIDVd2bVQowBvIU
         8Y6w==
X-Gm-Message-State: AJIora9TxeLNvZ7oQsjGTtzGZu7rGrnVDeCP28uZiq0HUiEae+oeMVnP
        RkzyRGtaAejeE6E5fznVLk504vd3LVM=
X-Google-Smtp-Source: AGRyM1t+ijklLhfmBdOq5r6R7WmV+GtYNSI28+OipEEnUJGpIeFJD3mpD7JFwof03lwnS9zEhENM6g==
X-Received: by 2002:a65:6907:0:b0:415:c9c1:eb4f with SMTP id s7-20020a656907000000b00415c9c1eb4fmr1369175pgq.193.1658523612485;
        Fri, 22 Jul 2022 14:00:12 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:805b:3c64:6a1f:424c? ([2620:15c:211:201:805b:3c64:6a1f:424c])
        by smtp.gmail.com with ESMTPSA id e15-20020a63544f000000b00419b128cf98sm3856789pgm.54.2022.07.22.14.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 14:00:11 -0700 (PDT)
Message-ID: <c9138aae-db78-7163-e207-3fb134db226c@acm.org>
Date:   Fri, 22 Jul 2022 14:00:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1] ufs: core: fix lockdep warning of clk_scaling_lock
Content-Language: en-US
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com
References: <20220722095308.10112-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220722095308.10112-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/22/22 02:53, peter.wang@mediatek.com wrote:
> This patch only release write lock of clk_scaling_lock before
> ufshcd_wb_toggle.

The above is not clear to me. Please make the above more clear.

Additionally, patches must be signed before these can be merged 
upstream. Where is your Signed-off-by?

> -	/* Enable Write Booster if we have scaled up else disable it */
> -	downgrade_write(&hba->clk_scaling_lock);
> -	is_writelock = false;
> -	ufshcd_wb_toggle(hba, scale_up);
> +	wb_toggle = true;
>   
>   out_unprepare:
> -	ufshcd_clock_scaling_unprepare(hba, is_writelock);
> +	ufshcd_clock_scaling_unprepare(hba);
> +
> +	/* Enable Write Booster if we have scaled up else disable it */
> +	if (wb_toggle)
> +		ufshcd_wb_toggle(hba, scale_up);
> +
>   	return ret;
>   }

The patch description should mention that this patch changes the 
ufshcd_wb_toggle() call: before this patch clk_scaling_lock was held in 
reader mode during the ufshcd_wb_toggle() call and with this patch 
applied clk_scaling_lock is not held while ufshcd_wb_toggle() is called. 
I'm missing an explanation of why this change is safe.

Thanks,

Bart.



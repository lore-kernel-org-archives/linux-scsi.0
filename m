Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA2BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 15:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55D564EC3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Feb 2021 15:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBYPAB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Feb 2021 10:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhBYO7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2021 09:59:55 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D8FC06174A;
        Thu, 25 Feb 2021 06:59:39 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id mm21so9076891ejb.12;
        Thu, 25 Feb 2021 06:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KdvCOoGwc01pWj3zqit8lvG+zKUB7O20UVPK03THNP4=;
        b=aiB780fqG+lMV0qHVrbZKuWfDRwQ555saLIEqG9xmXTWW3j5ZH4bsrNLh2Ri8oKLqV
         h1BSGhj53+kXfUuxLmHzE4aSeYBfbU1JTBC7VAesQM3d/wTaL302bwm6PMwH9Cfx8k8M
         XnFSAJJ0RwsS/omDxOXcrcfO2DM/GhuUXsBdlpzszutJtBc9bwQ+hEglG+hj5d9hEjty
         2ZgvEkJCJ21szGtlotNGWpGjy66gzWrnWBno4Wh/Ry087KSlSgGO0JbJS0iGT4sdxFD2
         ajeuFBd48Bj/joqs9Ogzn7Zs/UcV+qLA8MoSz8E3R+q5Ylnbd71So7r20yWiTpuxiyHO
         yXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KdvCOoGwc01pWj3zqit8lvG+zKUB7O20UVPK03THNP4=;
        b=dQGtF6Ps0EqJK9ALFjZ8dyE49x0TTYSjzdtWRXmcH5bN1582FqD+NkhLhyLD/jjaqb
         JFDZrSOqYXrgpdPoLItM1xfpaL9t/KNxiuV3daO0w2ZdYWCgGUyWj129MENrEDJJmxdg
         XhvUstw7SE5Mqt3ksMpFuSRF2vAIgNmtyvzpnkm1gMQkUc6SNzG/waafzTdBCJ3RmW00
         US27xxaDBwevAVg1R7Gv6a5vXopy5RwFqdtxdq1CMPzKTubFmZE3iIw7yqa6jyolLir+
         tN1xJrzrAXQgVbiLp0LU9TWQsTscLz+qYzJHVqDbxbX3g7iz84w9pjeKKICtxbbnW1ou
         ArrA==
X-Gm-Message-State: AOAM530z/cqymxlDs5fa13kcuJQHNLBK9lBQKV/NB1YzkkjKmpiFff6z
        NXjpVCmsJ6mU5Ms7a2Rln74=
X-Google-Smtp-Source: ABdhPJyODUvvQvgTK6/qjd6qJbaxonWfMg0MxVfoP/KHn/A/kiMr3yFuH26yVr2ne5IwxpmO1rln5A==
X-Received: by 2002:a17:906:6047:: with SMTP id p7mr3011865ejj.400.1614265178501;
        Thu, 25 Feb 2021 06:59:38 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bec1d.dynamic.kabel-deutschland.de. [95.91.236.29])
        by smtp.googlemail.com with ESMTPSA id r5sm3141799ejx.96.2021.02.25.06.59.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Feb 2021 06:59:38 -0800 (PST)
Message-ID: <23b7d59df2b83cdac53fdb4567c41c007257b436.camel@gmail.com>
Subject: Re: [PATCH v24 2/4] scsi: ufs: L2P map management for HPB read
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com, Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Thu, 25 Feb 2021 15:59:35 +0100
In-Reply-To: <20210224045437epcms2p7ed0a41233d899337ddbd3525fddeb042@epcms2p7>
References: <20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p6>
         <CGME20210224045323epcms2p66cc6a4b73086621e050da37f12f432f0@epcms2p7>
         <20210224045437epcms2p7ed0a41233d899337ddbd3525fddeb042@epcms2p7>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-02-24 at 13:54 +0900, Daejun Park wrote:
> +static int ufshpb_init_mem_wq(void)
> +{
> +       int ret;
> +       unsigned int pool_size;
> +
> +       ufshpb_mctx_cache = kmem_cache_create("ufshpb_mctx_cache",
> +                                       sizeof(struct
> ufshpb_map_ctx),
> +                                       0, 0, NULL);
> +       if (!ufshpb_mctx_cache) {
> +               pr_err("ufshpb: cannot init mctx cache\n");
> +               return -ENOMEM;
> +       }
> +
> +       pool_size = PAGE_ALIGN(ufshpb_host_map_kbytes * 1024) /
> PAGE_SIZE;
> +       pr_info("%s:%d ufshpb_host_map_kbytes %u pool_size %u\n",
> +              __func__, __LINE__, ufshpb_host_map_kbytes,
> pool_size);
> +

I think print function name is not proper while booting.
And one HPB is associated with one HBA, if there are two UFS
controllers, how can I differentiate them? 

Bean


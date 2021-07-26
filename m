Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB425C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 22:06:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AAE60F6E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 22:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhGZV02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 17:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhGZV02 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 17:26:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5776FC061757;
        Mon, 26 Jul 2021 15:06:55 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id p21so5504211edi.9;
        Mon, 26 Jul 2021 15:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AJj8nnGd25iP2yGKwO3nNtHXyPTqFZ0evYNG2czor7E=;
        b=nSJomeVNRbkzexv04pvPtHTzeKY5gOFCV+VgcFUHwbNIDJ2gsh0/+mDlXN6860JsRV
         wtV5znBYkgy0TJaCBbbVHO2jfvmk3TaA+D4JPVPzuJIG5AXMbSlIVsZJVo76dUJJScep
         l3bj/UKrIVm9eNYGrSFS76PCS42mfM5ubDXcSw2Fo/64Xw+O4gYd7VuXJLYYpmWXCTP4
         8L5EO38F/Y+oO9GA6vl3D3ibyYJDtOYlwbKT0FjPAAGBvdgma/NzJJ4lZ1iRlMFXEJcu
         QhjlA7br2nhaN1davzgJRX3LBH8nZg9qpAwV6D/XC6rscQPUq2H+t9LFkD3qashe6LPy
         +SYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AJj8nnGd25iP2yGKwO3nNtHXyPTqFZ0evYNG2czor7E=;
        b=Pxvn5EPGrzvyPTVwggDB9aQDjsGP8tLw7d/MxHeuJeNYzf0J+C8cKXBZioT0kO6dMG
         XzrRQ1npf/ZKZgtqWngnNjeJ1FBl2OlJzurEhaQyKdOZQyFnpjcS0WkAuqXmsXG1buC6
         cEKcIIlYhtC9qj9xJqWguZuaonwJTmyUAEXn56YYoAFucLwzNRbtnCWXECSo4qLieokZ
         Ibvdy4J+DDjIP2cuae4FRs85mL5XwD22E9AqnMDsT7FCoDRtAm7Mymrls56L9V4n6V+m
         t3CIB3vI3I4JtaYrP4OLWzM8RftFt9GbaXoQZxpx1ARePlaEsjRYhkeu0lTsA0nWrqv6
         +15g==
X-Gm-Message-State: AOAM531uwhEG//0L/P7uC4hWP0xxXvmmqTjBXfPMyNoY/mqB+d6aWPSa
        mEWi+brYlTosJp2rEcudD0Y=
X-Google-Smtp-Source: ABdhPJxAI6r1AWlkF47pOuXqmRciaBxyDZROmwNFTR914RljNyMz8jHk5wgwQaja7aXYgMu6VpmY/A==
X-Received: by 2002:a05:6402:28a4:: with SMTP id eg36mr3772711edb.84.1627337213254;
        Mon, 26 Jul 2021 15:06:53 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec25.dynamic.kabel-deutschland.de. [95.91.236.37])
        by smtp.googlemail.com with ESMTPSA id op23sm275930ejb.7.2021.07.26.15.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 15:06:53 -0700 (PDT)
Message-ID: <74e1269acaee8ddd97e9035543753ddbb9645579.camel@gmail.com>
Subject: Re: [PATCH v2 14/15] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
From:   Bean Huo <huobean@gmail.com>
To:     Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Bart Van Assche <bvanassche@acm.org>,
        jongmin jeong <jjmin.jeong@samsung.com>,
        Gyunghoon Kwon <goodjob.kwon@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org
Date:   Tue, 27 Jul 2021 00:06:47 +0200
In-Reply-To: <20210714071131.101204-15-chanho61.park@samsung.com>
References: <20210714071131.101204-1-chanho61.park@samsung.com>
         <CGME20210714071200epcas2p3f76e68f6bbb4755574dba2055a8130ab@epcas2p3.samsung.com>
         <20210714071131.101204-15-chanho61.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-14 at 16:11 +0900, Chanho Park wrote:
>  
> 
> +static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs)
> 
> +{
> 
> +       struct ufs_hba *hba = ufs->hba;
> 
> +
> 
> +       /* Enable Virtual Host #1 */
> 
> +       ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
> 
> +       /* Default VH Transfer permissions */
> 
> +       hci_writel(ufs, 0x03FFE1FE, HCI_MH_ALLOWABLE_TRAN_OF_VH);
> 
> +       /* IID information is replaced in TASKTAG[7:5] instead of IID
> in UCD */
> 
> +       hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);

Here you meant the IID in the UPIU header will be set according to the
Task_tag[7:5] value? and this will be done by your HW controller or SW
driver?

Kind regards,
Bean



> 
> +
> 
> +       return 0;
> 
> +}


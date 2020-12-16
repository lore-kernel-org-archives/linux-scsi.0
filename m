Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9198C3526B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 20:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3CD1235F9
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 20:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgLPURx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 15:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbgLPURx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 15:17:53 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDE0C061794;
        Wed, 16 Dec 2020 12:17:12 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u19so26267424edx.2;
        Wed, 16 Dec 2020 12:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OGqml7cNQ934/fU3LVSDbnKf/tJQTzGUkVuBuZynyhE=;
        b=mKUkfR4uBmBnEqP2XCFlpvlCXa6gm0fy5gKERHYvVjYgihb5oN5cTbty4GyKD321kN
         n+tpsv71iUDSLA9X6WscaFfIqwiwjWaWxH4CE1avcr/8u9gBm524rW86Ui9r3ZGckpXM
         ACP5DZo5TPRmhsbILEB4/kVLO9ilkVqOhUQBywmvYTslYiaOx7hicfQbDO8afQuJA+Hr
         AC82tz3Ahhfy+Rn0UHRCBFTa2RE/Wz859WUqB1Qlqlw3L4tR9N1vdFYOg1KdeL1VZoYa
         VStkESeduTxVJ4MCHW5BVaHCXa9p/h7ybDnFSRp7Lr6reAJI/iJFEcifaUfZGQFmO6RM
         wyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OGqml7cNQ934/fU3LVSDbnKf/tJQTzGUkVuBuZynyhE=;
        b=pUTP54FtAnnSrWQ8ErIhLL97uPP0ajWwyLyAr4TDqtB33L9DwXlv0hqtn6KsZmJpik
         ygqYGOlTGTD9XK0yJ0PUQ9eSpY52mzb16eLscdrJVwZ7s1OKqmdqkUwuiaAb1qzhI3r4
         MlQc+jEMcfVDRMegkGZk11DyU/lleoxsJlKHf1BMx2ZW1UW2p0jIzNRtloikdXFjrRNT
         a+trxLiw/6JtChK7rzpnauEQPS+YXh1HklQrt1H4mfvv6O6nRAhJuRkpyKpr+q3EBfqV
         LUCJtMxHUw8eO5cxkmSCdc4EpY4I0AnJJCi+z2/myqsOtXimbhomQclmaJXgsPK8BmL4
         PJ2Q==
X-Gm-Message-State: AOAM532Cce3p4yb5pcMQ1DhHyGfV+/CSSDfv1aF/2S9Jlcei7HwdvSKw
        pCFHC7qPmWMskXnb8X1wkWwkPlZXrEagmA==
X-Google-Smtp-Source: ABdhPJwceJnmY9nzHb+/pFABD6tj/TRJvnilchVnGqDms5ei/9QR50gzeuqqmglo1c+bWLSUmIWZzA==
X-Received: by 2002:a05:6402:22e1:: with SMTP id dn1mr36238078edb.347.1608149831669;
        Wed, 16 Dec 2020 12:17:11 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id b7sm2140609ejp.5.2020.12.16.12.17.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Dec 2020 12:17:10 -0800 (PST)
Message-ID: <920b01c29525ff1cf894a2cf9c809750533ddc13.camel@gmail.com>
Subject: Re: [PATCH V2] scsi: ufs-debugfs: Add error counters
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Wed, 16 Dec 2020 21:16:54 +0100
In-Reply-To: <20201216185145.25800-1-adrian.hunter@intel.com>
References: <20201216185145.25800-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-16 at 20:51 +0200, Adrian Hunter wrote:
>                 ufshcd_variant_hba_exit(hba);
>                 ufshcd_setup_vreg(hba, false);
>                 ufshcd_suspend_clkscaling(hba);
> @@ -9436,6 +9441,20 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_init);
>  
> +static int __init ufshcd_core_init(void)
> +{
> +       ufs_debugfs_init();
> +       return 0;
> +}
> +
> +static void __exit ufshcd_core_exit(void)
> +{
> +       ufs_debugfs_exit();
> +}

Hi, Adrian

The purpose of patch is acceptable, but I don't know why you choose
using ufshcd_core_* here. 
Also. I don't know if module_init()  is a proper way here.

thanks,
Bean

> 
> n
> +
> +module_init(ufshcd_core_init);
> +module_exit(ufshcd_core_exit)


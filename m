Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8410CC4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 18:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3158A23B26
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 18:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392598AbgLJSEA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 13:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392560AbgLJSDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 13:03:48 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E576C061793;
        Thu, 10 Dec 2020 10:03:08 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id ga15so8613937ejb.4;
        Thu, 10 Dec 2020 10:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6q578J6A1fbtKR8a+hbQPlwUDllTgydW2mEl6lc3Zdo=;
        b=pJcBbImRzRTvMGRNhg6vF0yB0MhgDQudL1Fe65Yge9FrK32TBovGPy/H8OtLOntZUH
         dnN4RgmwMqUh6QdN6iBvGCfhRb0FqaD8RudvM9c+PMwR+2Yed77VH8mNrY1cXl4GYnDH
         E+uKxVvqaSGGIqeW2+4HgSwYDa9hpuKtt75887XtZZLHsn3ksQqeBtBhHFhkp4GU26g1
         vR4TFd9HeYM+nDtrhEkA4o/FpbsdBHqnG/s+Ut9tvsMgG/lDlWv7W6OfKUjwm44jha/J
         T7fMGV+50kebGdK329J0s761q2cKdAREMShHBa34h0eV3dvL+ieDJcK7DKB13oIIz8Nl
         ORCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6q578J6A1fbtKR8a+hbQPlwUDllTgydW2mEl6lc3Zdo=;
        b=GmFRFb57CinJVSYsvMpIY6EGCkw5kFI8qpnZOvdFWYbOLrNEhaXw/g1yHcnV+8uQ5b
         9y2MiCN64cSEJPQdsP9WvilRmgUrCyZZmmf0y4QU6k1a1Jsw6PQAgMdAJVhVanD0Hw6c
         yx6ylKeJIC814TXPFbsLthp4cT3bvlMrpxyQpuIOGIo/q1b1PBtk13Nm/7YQ05qbArBU
         Jf6d0X6D0vREhErmfz1wPuFNg0PS+8iJ4zm2djhEcnyVxQA10+XghUvbh0HuzHvXLRpm
         n4pUya8ZSdMJ7m3tbudNOVb4JAInYugSpO0/C42Uy4YS87LOhGZKcTjQKaZtUBgFMTth
         nkYQ==
X-Gm-Message-State: AOAM532eKWkDS0appZMCI3oJ1IHLJArdl2PWgXNsWFuMrMzpqlawgrJp
        MWV8VrJU2by6V+QCFxxnmZY=
X-Google-Smtp-Source: ABdhPJwm2SoJa+GRCQsQwjtVyMGYTKu8R75ywRQ1ki7thPaqC254JYaTZm3YuoFX1INsf5XCmQI6Aw==
X-Received: by 2002:a17:906:52da:: with SMTP id w26mr7606530ejn.347.1607623386979;
        Thu, 10 Dec 2020 10:03:06 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id k3sm5014070ejd.36.2020.12.10.10.03.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 10:03:06 -0800 (PST)
Message-ID: <f12d2c516d2a038bcc27677d9b982c52d19d5027.camel@gmail.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Clean up ufshcd_exit_clk_scaling/gating()
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 10 Dec 2020 19:03:05 +0100
In-Reply-To: <1607520942-22254-3-git-send-email-cang@codeaurora.org>
References: <1607520942-22254-1-git-send-email-cang@codeaurora.org>
         <1607520942-22254-3-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-12-09 at 05:35 -0800, Can Guo wrote:
> ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling()
> and
> ufshcd_exit_clk_gating(), so move ufshcd_exit_clk_scaling/gating() to
> ufshcd_hba_exit().
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 12266bd..41a12d6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1846,11 +1846,14 @@ static void ufshcd_init_clk_scaling(struct
> ufs_hba *hba)
>         snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
>                  hba->host->host_no);
>         hba->clk_scaling.workq =
> create_singlethread_workqueue(wq_name);
> +
> +       hba->clk_scaling.is_initialized = true;
>  }
>  
>  static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
>  {
> -       if (!ufshcd_is_clkscaling_supported(hba))
> +       if (!ufshcd_is_clkscaling_supported(hba) ||
> +           !hba->clk_scaling.is_initialized)
>                 return;
>  
>         if (hba->devfreq)
> @@ -1894,12 +1897,16 @@ static void ufshcd_init_clk_gating(struct
> ufs_hba *hba)
>         hba->clk_gating.enable_attr.attr.mode = 0644;
>         if (device_create_file(hba->dev, &hba-
> >clk_gating.enable_attr))
>                 dev_err(hba->dev, "Failed to create sysfs for
> clkgate_enable\n");
> +
> +       hba->clk_gating.is_initialized = true;
>  }

you don't need these two is_initialized at all. they are only be false
when scaling/gating is not supported??

Bean



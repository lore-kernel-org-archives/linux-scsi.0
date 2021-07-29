Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0649C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80FB561078
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhG2IHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbhG2IHn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 04:07:43 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC5DC061757
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:07:39 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id j2so5742654wrx.9
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=172vGKTkHoCoOfqbAnn/KlYPWdKhJJwwK5eatKoFT/Y=;
        b=Pr0ULnqtvhBGeTjfHFrpi5+kfXi48wJ7mRs3+z5/T4DapLRfIc1trTT6RIbnQ0vMtO
         RC9PzwCFIz0ccmksYBZ1KRedhOT0aHhr1DaPVtZ+Mg/cXh53put3fViKylXmscUzEOvz
         vQWpAeBoanSdtGtbyTR0COFJSxqGSXZIdKUFJfXYVu85xqpW6NBcvK0n7HdjhEV9dYh5
         MQEz7EiynQ+xfYOFxveT5DmK26GiR4/px+punajEreiu2qomf5zJ8w4TMjGiY+LaYXuD
         a/+7kxjck+tMvWt7P3qNshtOuGMmXvLdla+Bmw0PnNc/ZuhXCKVb+7JrS33/06sTUbY5
         aaDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=172vGKTkHoCoOfqbAnn/KlYPWdKhJJwwK5eatKoFT/Y=;
        b=JJN9s0/vwwcnkB69dlNImZ+QrGFAkeVnVff1jarV1MUdnm9v9nh1vGlUidfr0XEAXo
         14U7SPi5OJbgeta6mOWEmg7AfQ9tqw5oK+5puW0jjOWrWhV8j7i/ufy5fVTo4EljGqdh
         RL55xBw+etdlwwyGxQc2fjgX5+ZIK+Dgkh0bTQzwYEda6WQ8BPosAEu/3xA1F1Mpez7B
         4rGtgq/cev6HQQOpvK5LItl/hOowZ6Of73ipp4iSTczDss0uGCipqhpVn/8LUT6P9/IR
         xsm1Yd5njkLT1oQR9RmaQH4w3wHAIWVVCdH+o8u5+H8GMGfO2Nd+6QDqQa1hM7HNhSMW
         38OQ==
X-Gm-Message-State: AOAM533cj5Z3smb2z9GPrWXIRm0lXMa3c2ZW/QvCtYBLdcVZ++5CfoUZ
        1/xXIXFJ7g7DjwcbwJV1oi4=
X-Google-Smtp-Source: ABdhPJy28kGvKjYWwW7wwmmD3rFKp4RHgV8q4NXvZ9S8jEotIyW8ki/DPVUU6rL1nIOi+OtTKgVNUA==
X-Received: by 2002:a5d:64cb:: with SMTP id f11mr3536164wri.310.1627546057999;
        Thu, 29 Jul 2021 01:07:37 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id f7sm2986152wrr.54.2021.07.29.01.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 01:07:37 -0700 (PDT)
Message-ID: <4c1bdc703b30f3891269a76b16a2a6ad4331e37a.camel@gmail.com>
Subject: Re: [PATCH v3 12/18] scsi: ufs: Optimize serialization of
 setup_xfer_req() calls
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
Date:   Thu, 29 Jul 2021 10:07:36 +0200
In-Reply-To: <20210722033439.26550-13-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-13-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> -       ufshcd_vops_setup_xfer_req(hba, task_tag, (lrbp->cmd ? true :
> false));
> 
>         ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
> 
>         ufshcd_clk_scaling_start_busy(hba);
> 
>         if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
> 
>                 ufshcd_start_monitor(hba, lrbp);
> 
>         spin_lock_irqsave(hba->host->host_lock, flags);
> 
> +       if (hba->vops && hba->vops->setup_xfer_req)
> 
> +               hba->vops->setup_xfer_req(hba, task_tag, !!lrbp->

Nice!

Reviewed-by: Bean Huo <beanhuo@micron.com>


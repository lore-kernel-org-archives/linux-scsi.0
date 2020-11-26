Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C43C64E75
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8041020DD4
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 13:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="YGcu1A/b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389957AbgKZN6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 08:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389923AbgKZN6n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Nov 2020 08:58:43 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4C5C0613D4
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 05:58:42 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id 7so3122391ejm.0
        for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2020 05:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ZnlpdHGKLLs1HjgjZ57oIwQ/E9hSKGuo9TRf/d6l7Y=;
        b=YGcu1A/bGEojIh2hXNbJIpvpVFABgN62i6zbiwIMkmT7nl5y8yS4N8sQWHV5/pTku5
         a/9kwotcQNIUyhtm4NKxkST1Fe+RSzolno64PbsvHvEHvsHnFF1RBeQX46g4gDlyyIjX
         st/xPIn6drh6b3MpPfMnYnFQJ6RBDxkEFpdg0RBaagKQ6qHnNd9+KmbdrDdLSTI8qJhI
         /7gn48pxJCmB88DAcKSKghG6NdJVBSjJXeoPOS/6mEg1mMZ1svvletkcVbVKakF6xkiU
         Laol6REYX5yAcFDzOhSBTiBeRcBQ6VBpO7MXE5nhJkxxdn1wO/7VLGQaE4u7P9IGraCh
         G3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ZnlpdHGKLLs1HjgjZ57oIwQ/E9hSKGuo9TRf/d6l7Y=;
        b=s5AP/NtNuPtfa7jOopugHHeeSV/4Y6f6mRPjh0lMJ5YPDev6B452HWfwLMkeySFfpf
         2wXGQnNkBV2TwywNM+tHujoCCH866Bf16TvatExRtHCY9LzATbSMCYUiZKYzcOG68fuI
         ZZHntj3ZAXSYFzioZaGXsyOJc6Kb17kXOw89X3VGdFzBBcr0p0FVz4YxAGgp6HB1wOFF
         iBdRL8KIKBVE418kkaM0nvbIApC12Gzf6C3HZOQa/3CrpOI1wEaSc+1tbA5OZEFp1pNB
         wbZijmeiQ3T/8R+g4yVKgyJNxfhEyyL7tXDJ8aPWRvZhxnr7fwbuXCWtADvtNCfFMD7M
         4ueQ==
X-Gm-Message-State: AOAM533YBS3dwi7sVB+dZjOzXult0EW5ZDvMcud3NY8uOK+FpAIDe/D1
        ZO1TPaBqONRGea5OJVwvPQUyATPjUH4POrZspAe3Kw==
X-Google-Smtp-Source: ABdhPJxQ3lbgok2nzajF7J3WM8tj9j7hS/DQ1abTCwysoqXRwAZKsSfY3arkEzD7W3qCTRbOaxjD6QmKApOjXisCCz0=
X-Received: by 2002:a17:906:94ca:: with SMTP id d10mr1435532ejy.62.1606399121382;
 Thu, 26 Nov 2020 05:58:41 -0800 (PST)
MIME-Version: 1.0
References: <20201126132952.2287996-1-bigeasy@linutronix.de> <20201126132952.2287996-2-bigeasy@linutronix.de>
In-Reply-To: <20201126132952.2287996-2-bigeasy@linutronix.de>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 26 Nov 2020 14:58:30 +0100
Message-ID: <CAMGffE=7=Tjx53gb8s8tjJQ5VeVtQN7OZzNro0ghpQH_pUWMzw@mail.gmail.com>
Subject: Re: [PATCH 01/14] scsi: pm80xx: Do not sleep in atomic context.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        John Garry <john.garry@huawei.com>,
        linux-m68k@lists.linux-m68k.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2020 at 2:30 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>
> hw_event_sas_phy_up() is used in hardirq/softirq context:
>
>  pm8001_interrupt_handler_msix() || pm8001_interrupt_handler_intx() || pm8001_tasklet
>    => PM8001_CHIP_DISP->isr() = pm80xx_chip_isr()
>      => process_oq() [spin_lock_irqsave(&pm8001_ha->lock,)]
>        => process_one_iomb()
>          => mpi_hw_event()
>            => hw_event_sas_phy_up()
>              => msleep(200)
>
> Revert the msleep() back to an mdelay() to avoid sleeping in atomic
> context.
>
> Fixes: 4daf1ef3c681 ("scsi: pm80xx: Convert 'long' mdelay to msleep")
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Vikram Auradkar <auradkar@google.com>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Indeed, thx for the fix.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 69f8244539e04..7d838e316657c 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -3296,7 +3296,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>         pm8001_get_attached_sas_addr(phy, phy->sas_phy.attached_sas_addr);
>         spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
>         if (pm8001_ha->flags == PM8001F_RUN_TIME)
> -               msleep(200);/*delay a moment to wait disk to spinup*/
> +               mdelay(200);/*delay a moment to wait disk to spinup*/
>         pm8001_bytes_dmaed(pm8001_ha, phy_id);
>  }
>
> --
> 2.29.2
>

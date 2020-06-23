Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC04BC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 10:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83DA020738
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 10:58:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibN85Yme"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732280AbgFWK6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 06:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732205AbgFWK6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 06:58:19 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940FEC061573
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 03:58:19 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id l24so909475uar.10
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 03:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spN5iUXEvYVRmMHvMH7JugZ7onNL+3vwpiwmObFUaaM=;
        b=ibN85Yme2r1dWw9xY48/NAJKZSJy2BgPGeTqZ3k6aV2MrfyKj43nHSUcVsBQMDlXAX
         qIlz26etSvDFaR5bdt0Z6vZy3bGOW5jgZZvPsODLHGp4pCshyNIG4OOAozcDNTXybCqq
         XAR8/bNyissxdfqobvvpaNF6l/qhLRvvJI7W6Nm1u6nXepOgn1u5ygfkZPI71Ro8Tpoo
         P0lvKNxNAqIv4cCg7FuGhDO6ewrdJqVZ4lwWeKJxyz5re3J7wM+ZAztLtF9OUtmO+XEm
         b0E4HsUgSNPGX0Vch94x52XUNQ91yMb1mbNa3qHizp3AOLwERAVW0RupSGP27YUITC0D
         AF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spN5iUXEvYVRmMHvMH7JugZ7onNL+3vwpiwmObFUaaM=;
        b=a6YEDV9yajlYbgBrJKp5LXhPU25HQyVzHvdM8eWvdxOCBIiNoF2ZxPRLNdyBzUXaiO
         SvVxCxHaPe4PTRTKn1bCTzKrO8Q7GZWjNh/hSE9TgnJA3QA0LWK8umGbRIeKWAwIIEqc
         qIz9JN+iNSqyN7wnUyI981fuhg/yL/WiJIlfYuRKYRdMvC5KG3/mT5XXUuxqH6MPnMEy
         OplQXMB8swOw6M05m1WYwKaZDBvtdUgmLf7ne6lGGphtpR/Q2vWiGA8J/6QV7pFeFVyr
         KKSDUbNjHZXihwpP86vL5kBTfDG+vxBsB2NKOOj/SxPgFJ9sFUzyUix4sQo/6Zuu6UfR
         jGiA==
X-Gm-Message-State: AOAM532jB6JX6PnASFJVmNSSmhVlOUmSW147c4UsWmriLqKpyuITkA8t
        sWRGLXQRAbAg9musuIbq3GAWwWB8/eiU9GNF3Zw=
X-Google-Smtp-Source: ABdhPJw2UAfnDDrWlSg+YJg2rcx9Uo4wjpJl/jTFAuOHxHdQGTSgxkYq5ceg0xLrCxddZCAVvpS8kzphxdZhH/UjSYY=
X-Received: by 2002:ab0:5b91:: with SMTP id y17mr1244302uae.95.1592909898682;
 Tue, 23 Jun 2020 03:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200618024736.97207-1-satyat@google.com> <20200618024736.97207-4-satyat@google.com>
In-Reply-To: <20200618024736.97207-4-satyat@google.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Tue, 23 Jun 2020 16:27:41 +0530
Message-ID: <CAGOxZ51L7oesrBm1GnYQ7fo0ZbS+Pkq8RUfyoOouF6-0C99=tA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: Add inline encryption support to UFS
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-scsi@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Satya

On Thu, Jun 18, 2020 at 8:18 AM Satya Tangirala <satyat@google.com> wrote:
>
> Wire up ufshcd.c with the UFS Crypto API, the block layer inline
> encryption additions and the keyslot manager.
PORT_SYMBOL_GPL(ufshcd_dealloc_host);
> @@ -8872,6 +8899,13 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>         /* Reset the attached device */
>         ufshcd_vops_device_reset(hba);
>
> +       /* Init crypto */
> +       err = ufshcd_hba_init_crypto(hba);
How about checking the capabilities of host controller in
ufshcd_hba_capabilities() itself and then proceed?

> +       if (err) {
> +               dev_err(hba->dev, "crypto setup failed\n");
> +               goto free_tmf_queue;
> +       }
> +
>         /* Host controller enable */
>         err = ufshcd_hba_enable(hba);
>         if (err) {
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 271fc19f8002..1cb0fde5772c 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -184,6 +184,8 @@ struct ufs_pm_lvl_states {
>   * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
>   * @issue_time_stamp: time stamp for debug purposes
>   * @compl_time_stamp: time stamp for statistics
> + * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
> + * @data_unit_num: the data unit number for the first block for inline crypto
>   * @req_abort_skip: skip request abort task flag
>   */
>  struct ufshcd_lrb {
> @@ -208,6 +210,10 @@ struct ufshcd_lrb {
>         bool intr_cmd;
>         ktime_t issue_time_stamp;
>         ktime_t compl_time_stamp;
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +       int crypto_key_slot;
> +       u64 data_unit_num;
> +#endif
>
>         bool req_abort_skip;
>  };
> --
> 2.27.0.290.gba653c62da-goog
>


-- 
Regards,
Alim

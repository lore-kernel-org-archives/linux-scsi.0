Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EBEFC33CB1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3C82072B
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 14:13:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOuc3nSY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgASON2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 09:13:28 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:33920 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgASON2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2020 09:13:28 -0500
Received: by mail-vs1-f66.google.com with SMTP id g15so17518055vsf.1;
        Sun, 19 Jan 2020 06:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WS4hpiPJ4ZsLS0bhjTBuxcDiBx1tLS6ob2vAGCFesxE=;
        b=QOuc3nSYWc5b82Vq+EXtiBO+wIuxcXrcnVdRw/OwDX2vo59211p80vm6G1wVNEp1FM
         M1hPMqTOcarVwUNrjg0dqeaFu8FrMx59Dq3k2BSCiVoScLFrbKnUz3Lskx8u/csP/K2M
         n3hJXUaO58pnk9dWkgzWpLCq7BbR5svTUBAoLU1f3Gd05sNJQGmX2fGVE0MEKIbc5FFd
         E3prO93PSEy3ktg88DgQuxu7NSiW+hufzXPrXUjeJwpW3pegx9B9nCoevU333c5xsZv0
         XLa0eXZQUyIC0ansVKKx0WYWEEdb+ZWaapL8tieFU1MjzPyZv77eb/HbXLh4f82hziGm
         iTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WS4hpiPJ4ZsLS0bhjTBuxcDiBx1tLS6ob2vAGCFesxE=;
        b=dqe/9zuBGHt+xcE49nHOCFmvWfqMt+pCRb5PPpd4or8DcgPl9pXukmMG4DV5nJF8sK
         ifpc+4h7r/529SJ/mkSXTlaKlm1NIKLfEQ0Gm+mMhSOfIQhVFK/vMnA9Il+KtWWh/R0e
         +DVHLe0UYV+ZVv8Fa5yr9NHZjD84F5rnLiBPYxRWmQ+XaLsSm62dun8XKCnFl74MW0ld
         ViWaFfsRj6OEBOKWYuTjESde4KdcOS+wx0IQXT8iE8f7ed/i1rEYDSZuVlyQ9MIPYNIA
         YJTTwVt+lFecINy/c/gDxAhs5r7CnWE0U5oLlnd/kPVLmiG4fz8yMFZdxxteeO0S4GBf
         7thg==
X-Gm-Message-State: APjAAAUFUtkje91gHKu1+MLdxdh93daHD0yut1kYiZLxYIEXrYNC/WVa
        s30oEaIdmDfRu6Q9ITz/uU/o/6u6VXZzqR3+z5U=
X-Google-Smtp-Source: APXvYqzJeseQkiqZA+gTc1YOvzk4DZiccEVSWTY2QS9PIluU6q/4bOX3Rmonl/yu7V0uTSOkcMg7w5SonnYmnn5BK1o=
X-Received: by 2002:a67:1447:: with SMTP id 68mr9872067vsu.76.1579443206847;
 Sun, 19 Jan 2020 06:13:26 -0800 (PST)
MIME-Version: 1.0
References: <20200117035108.19699-1-stanley.chu@mediatek.com> <20200117035108.19699-3-stanley.chu@mediatek.com>
In-Reply-To: <20200117035108.19699-3-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Sun, 19 Jan 2020 19:42:50 +0530
Message-ID: <CAGOxZ51K1EWY56Kw1aBJJ-8DubXjmY+ew6XUYKSCPXzPZvcs2w@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] scsi: ufs: export some functions for vendor usage
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>, asutoshd@codeaurora.org,
        Can Guo <cang@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 17, 2020 at 9:45 AM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Export below functions for vendor usage,
>
> int ufshcd_hba_enable(struct ufs_hba *hba);
> int ufshcd_make_hba_operational(struct ufs_hba *hba);
> int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufshcd.c | 11 +++++++----
>  drivers/scsi/ufs/ufshcd.h |  3 +++
>  2 files changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bea036ab189a..1168baf358ea 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -250,7 +250,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
>  static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>                                  bool skip_ref_clk);
>  static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
> -static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>  static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
>  static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
> @@ -3865,7 +3864,7 @@ static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>         return ret;
>  }
>
> -static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
> +int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>  {
>         struct uic_command uic_cmd = {0};
>         int ret;
> @@ -3891,6 +3890,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_uic_hibern8_exit);
>
>  void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
>  {
> @@ -4162,7 +4162,7 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> -static int ufshcd_make_hba_operational(struct ufs_hba *hba)
> +int ufshcd_make_hba_operational(struct ufs_hba *hba)
>  {
>         int err = 0;
>         u32 reg;
> @@ -4208,6 +4208,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>  out:
>         return err;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
>
>  /**
>   * ufshcd_hba_stop - Send controller to reset state
> @@ -4285,7 +4286,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>         return 0;
>  }
>
> -static int ufshcd_hba_enable(struct ufs_hba *hba)
> +int ufshcd_hba_enable(struct ufs_hba *hba)
>  {
>         int ret;
>
> @@ -4310,6 +4311,8 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
> +
>  static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
>  {
>         int tx_lanes, i, err = 0;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index b1a1c65be8b1..fca372d98495 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -799,8 +799,11 @@ static inline void ufshcd_rmwl(struct ufs_hba *hba, u32 mask, u32 val, u32 reg)
>
>  int ufshcd_alloc_host(struct device *, struct ufs_hba **);
>  void ufshcd_dealloc_host(struct ufs_hba *);
> +int ufshcd_hba_enable(struct ufs_hba *hba);
>  int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
> +int ufshcd_make_hba_operational(struct ufs_hba *hba);
>  void ufshcd_remove(struct ufs_hba *);
> +int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>  int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
>                                 u32 val, unsigned long interval_us,
>                                 unsigned long timeout_ms, bool can_sleep);
> --
> 2.18.0



-- 
Regards,
Alim

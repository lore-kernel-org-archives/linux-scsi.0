Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F74C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C81D8222C2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 18:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="glXTEz6x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLSSdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 13:33:00 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:36517 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfLSSdA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 13:33:00 -0500
Received: by mail-ua1-f68.google.com with SMTP id k33so2320431uag.3;
        Thu, 19 Dec 2019 10:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOyymaYGcmSJ1WRzuqz4Ak0rmhgIqLCqZ8zG2kPHNMo=;
        b=glXTEz6xo8pZIYtMNXBEZKiZ6kJgRXxgzHEMYNU3S58gEmx1YdW2HvnbOPO9ixmQ1w
         JTqyRLAr76LLdCT4bxMI1SmmDS/6dXWPYgyri6gBmzDXrBgFdhKFUgezb0cIDPigANgE
         E9IZQvFNURFRyGqU7OKos8+sbog3m8xUCEzQCYb4PR/viN3IIsMviu0e1K/E5IbFVg4t
         oPHGjpJNZInKrcf3fI8mbv5IeegUQpAy8NxZ4n9nvDz3nSOZYq9q7WQZ9J6+V08tlCJl
         sylHG8fEiJAvulZsLjgf3pWqz+Jj4RgxEue9g0gKXdrtHYI/6Nz0A9v/zZ5U0kZbdVX0
         awWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOyymaYGcmSJ1WRzuqz4Ak0rmhgIqLCqZ8zG2kPHNMo=;
        b=mxtjBEeEKNZyTak+W9hlYkZ3xTpgE0hb/9FroS+ZixytH6tiJU3DHUVmPTIFI1zoPd
         RqIuPjxg5kgEAn5z+ptAD/Q5QTpOdVkSJkUcJh80k4fq5J8xyPt/SXWljEQac/FVkq3a
         2tHOmJ+QX+MpoyJ7e0PFg6jmQQdtXd+RtpnQ06HWazKTPqaU6mNmGvw6x4cxpCnlhpG4
         w7ZEd3NpJy1gTHMfpirHmtj0hlKFu7FiXcgk8zirO4lVyjv4n/zMhYre2d/g//ZRDgGL
         m9LAc4QO6bIjAWjMdJAYl7lU4rfTqY9VzBTHywgnWTcGJDuwHo8/KT5S6ath5YzGODsY
         OMzA==
X-Gm-Message-State: APjAAAV7LVPtp7Q4vtDUJo0Dnweu0XTtKP5y9qg7AWh9jHK+wnlkL3h2
        zQZwxOOWerj4nvVjpGdEYAlyvw0xOakgSABdKTo=
X-Google-Smtp-Source: APXvYqwM3UEwSjHttH0IdDl/GVqzd05+x7SvoHGEo+WgDCx2bVOHaGPhK0SsHTOHsJq/GpXPgXIoNGKQmA3xGy6FlWA=
X-Received: by 2002:ab0:7049:: with SMTP id v9mr6389360ual.95.1576780379310;
 Thu, 19 Dec 2019 10:32:59 -0800 (PST)
MIME-Version: 1.0
References: <1576224695-22657-1-git-send-email-stanley.chu@mediatek.com> <1576224695-22657-3-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1576224695-22657-3-git-send-email-stanley.chu@mediatek.com>
From:   Alim Akhtar <alim.akhtar@gmail.com>
Date:   Fri, 20 Dec 2019 00:02:22 +0530
Message-ID: <CAGOxZ52ffkFwkcrdyq+gjuXarjr-aqGRw2ck25Yu0QgppGh9hQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] scsi: ufs: export ufshcd_auto_hibern8_update for
 vendor usage
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        peter.wang@mediatek.com, chun-hung.wu@mediatek.com,
        andy.teng@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 13, 2019 at 2:07 PM Stanley Chu <stanley.chu@mediatek.com> wrote:
>
> Export ufshcd_auto_hibern8_update to allow vendors to use common
> interface to customize auto-hibernate timer.
>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 20 --------------------
>  drivers/scsi/ufs/ufshcd.c    | 18 ++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h    |  1 +
>  3 files changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index ad2abc96c0f1..720be3f64be7 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -118,26 +118,6 @@ static ssize_t spm_target_link_state_show(struct device *dev,
>                                 ufs_pm_lvl_states[hba->spm_lvl].link_state));
>  }
>
> -static void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
> -{
> -       unsigned long flags;
> -
> -       if (!ufshcd_is_auto_hibern8_supported(hba))
> -               return;
> -
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> -       if (hba->ahit != ahit)
> -               hba->ahit = ahit;
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -       if (!pm_runtime_suspended(hba->dev)) {
> -               pm_runtime_get_sync(hba->dev);
> -               ufshcd_hold(hba, false);
> -               ufshcd_auto_hibern8_enable(hba);
> -               ufshcd_release(hba);
> -               pm_runtime_put(hba->dev);
> -       }
> -}
> -
>  /* Convert Auto-Hibernate Idle Timer register value to microseconds */
>  static int ufshcd_ahit_to_us(u32 ahit)
>  {
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b5966faf3e98..589f519316aa 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3956,6 +3956,24 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
>         return ret;
>  }
>
> +void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
> +{
> +       unsigned long flags;
> +
> +       if (!(hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT))
> +               return;
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (hba->ahit == ahit)
> +               goto out_unlock;
> +       hba->ahit = ahit;
> +       if (!pm_runtime_suspended(hba->dev))
> +               ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
> +out_unlock:
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
> +
>  void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
>  {
>         unsigned long flags;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 2740f6941ec6..86586a0b9aa5 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -927,6 +927,7 @@ int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
>         enum flag_idn idn, bool *flag_res);
>
>  void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
> +void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
>
>  #define SD_ASCII_STD true
>  #define SD_RAW false
> --
> 2.18.0



-- 
Regards,
Alim

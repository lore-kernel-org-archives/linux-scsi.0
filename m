Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7258C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0C464F2B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbhCDJyI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbhCDJyG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:54:06 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4538C061762
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:53:25 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id bd6so20700348edb.10
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OTcQ8HgK4xyfwhINSgp1y1iTr9PgQDJ2c/607cyGHGo=;
        b=IsM7FCFoOX7Ne2WFWvbKg3XJeuCz6uhuQFOyWd7YtBYuo33lgKCxql1VghtgcyVFNA
         XU+jKyjednPG8tBJl/lJCnxgtAGQamTleQ/CqD4pcrqfhyhaz2t1zo2tW8XR3Z3Blh/U
         WbTiYo1+yMyCndKQWvw3+gpdX8+JbQQS5WAwqVB16b81gock5Ktq1OfvsPnOB53+MsCa
         qSSRna6d+Ukz8LDZWSsEi4vTabbWQHjV185FbVgoP75cw2hoOXiP9M7p4nJ2b0tf8LaK
         qReCWTuAgZUkH3lKGMzZzTYiDwxpA1bWMDBYZI5q2QbKG7ZJoKKWpyuNMg3tI9ehfKn4
         DDYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OTcQ8HgK4xyfwhINSgp1y1iTr9PgQDJ2c/607cyGHGo=;
        b=MfKNwPUChqPuoHZyJM7y6HF99o/w1P/o0MIwSyj4QF8x1Vapz68yXeHGZ2TWgDxkTT
         EqvFNaczncLgNgKNVbDplXZuu68/X50zYiCmV7H+17iiAQpVufoGpiPvFOR6/VLOBZXx
         SL0umcLoo4+Alr46xxKevQxI2gAgnhkXyFtFQOklym2i4JQBkJ5oy2rdvHb1+/hx3NfH
         C3Vhx0ASJKZQ0WkqVoMRSgLVDf+3EG3AskqF7oxDYqIy5QTZ7flL8HMZOE5t3nCn01ja
         21Ve55H3sD/A6UHDNpf53HQlKpxluZP121DjOu1MZ9V8nGmEWCSkTCCWQ4RTwyC3xrr1
         7ngw==
X-Gm-Message-State: AOAM5329c2UwuKsP+bKIEyWvVKlVjcojuT/plRws1oOtjlOXLKLJTk4m
        nEa530JWNiHmBsL8J+ynxjrQbVcG39Q45s2aYrA6Vg==
X-Google-Smtp-Source: ABdhPJz6Dj0a0IikbpQXchtVdO8tIE2nsniGPcwwE+9AaiI73lLIy5D97wzFfkMITMwrpAcRZtd/LijwTg43rmnqzWE=
X-Received: by 2002:a05:6402:ce:: with SMTP id i14mr3439724edu.42.1614851604560;
 Thu, 04 Mar 2021 01:53:24 -0800 (PST)
MIME-Version: 1.0
References: <20210303144631.3175331-1-lee.jones@linaro.org> <20210303144631.3175331-19-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-19-lee.jones@linaro.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:53:13 +0100
Message-ID: <CAMGffEkGT0tRSM51pikNc3d+w1mYJCN-oWzRxFA_wPRXE+d=Ow@mail.gmail.com>
Subject: Re: [PATCH 18/30] scsi: pm8001: pm8001_hwi: Fix some misnamed
 function descriptions
To:     Lee Jones <lee.jones@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 3, 2021 at 3:47 PM Lee Jones <lee.jones@linaro.org> wrote:
>
> Fixes the following W=1 kernel build warning(s):
>
>  drivers/scsi/pm8001/pm8001_hwi.c:1183: warning: expecting prototype for pm8001_chip_interrupt_enable(). Prototype was for pm8001_chip_intx_interrupt_enable() instead
>  drivers/scsi/pm8001/pm8001_hwi.c:1257: warning: expecting prototype for pm8001_chip_intx_interrupt_disable(). Prototype was for pm8001_chip_interrupt_disable() instead
>  drivers/scsi/pm8001/pm8001_hwi.c:3235: warning: expecting prototype for asd_get_attached_sas_addr(). Prototype was for pm8001_get_attached_sas_addr() instead
>  drivers/scsi/pm8001/pm8001_hwi.c:3555: warning: expecting prototype for fw_flash_update_resp(). Prototype was for pm8001_mpi_fw_flash_update_resp() instead
>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Thanks
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 49bf2f70a470e..6b600e33e9e8d 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1175,7 +1175,7 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
>
>  #ifndef PM8001_USE_MSIX
>  /**
> - * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
> + * pm8001_chip_intx_interrupt_enable - enable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
>   */
>  static void
> @@ -1248,7 +1248,7 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  }
>
>  /**
> - * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
> + * pm8001_chip_interrupt_disable - disable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
>   * @vec: unused
>   */
> @@ -3219,7 +3219,7 @@ void pm8001_get_lrate_mode(struct pm8001_phy *phy, u8 link_rate)
>  }
>
>  /**
> - * asd_get_attached_sas_addr -- extract/generate attached SAS address
> + * pm8001_get_attached_sas_addr - extract/generate attached SAS address
>   * @phy: pointer to asd_phy
>   * @sas_addr: pointer to buffer where the SAS address is to be written
>   *
> @@ -3546,7 +3546,7 @@ int pm8001_mpi_dereg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  }
>
>  /**
> - * fw_flash_update_resp - Response from FW for flash update command.
> + * pm8001_mpi_fw_flash_update_resp - Response from FW for flash update command.
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> --
> 2.27.0
>

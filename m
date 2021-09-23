Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFF4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 21:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F00D60EB4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 21:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbhIWVNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 17:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243233AbhIWVNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 17:13:49 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7338C061756
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 14:12:17 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id i84so1209029ybc.12
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 14:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4I0eibrZ4QXFLaZnyg/T68NEGU52nG0wW6n1XbQIjQ=;
        b=dG37ybSuZM/2PWO2WUAlCFTgei4CWvCR+/3V/ba5AqbouIgMtK6R/N88t2fL6e8ES2
         HXlfmDfLIxlNVt61DT2aeO3iHi1ERInV9PLlsO/SPeZ8qseDFM20DxIJnOXzZymLl5ma
         Sf4KMe1TIhD6jwCpVfOKcATIO++tuc9tkqgIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4I0eibrZ4QXFLaZnyg/T68NEGU52nG0wW6n1XbQIjQ=;
        b=cQBb3zPSc01PCJ5Mm4B5lp4roFMZYDVk+YUZK020EzjDHCugBw7Bium/qqUWkjOprP
         QR6YgQPMereVZUiQ8XHEEqyX1ahAwjpR1MqIsOfZPeC+1g9revGX/HiMOJ1GBerucO9i
         W2Sf6PJ3XRtg9R2Ss3yMKgTGVYlJydpE971Lk4A5hLhAu8LHwynwo3n+773PKpqI6YC1
         qQitvNeJkSL5kuJCwIU8QM+SaJhywRfCwb9car4J1fAdJCWlR1/5+Gy1iJHm4gw7bL+c
         G3v7EdZd4LtWz+pQo1EZy1NUYwjEkoucAWDs5bhZk+GCeBVZ5ryz9DUoW9iTcrCe8fBq
         K4lw==
X-Gm-Message-State: AOAM533taLPdL0E5qDbvcCq1mTMlRGJB/fQLzTmVxUGaX/iG9856lvpA
        FeakcJtbB00l0Qi8qHTT7r8+vGjTgHCjEND4ah169w==
X-Google-Smtp-Source: ABdhPJzPbZJuTOrMwImBU82x1iGNKaxl7ZrrpRIXcHLQEZ89VXGY0DTN1rpeXB3OFka4syEsC81GUEXozb35nSZ2MSQ=
X-Received: by 2002:a25:748c:: with SMTP id p134mr7788992ybc.361.1632431536689;
 Thu, 23 Sep 2021 14:12:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632420430.git.leonro@nvidia.com> <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
In-Reply-To: <e7708737fadf4fe6f152afc76145c728c201adad.1632420430.git.leonro@nvidia.com>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Thu, 23 Sep 2021 14:11:40 -0700
Message-ID: <CAKOOJTz4A2ER8MQE1dW27Spocds09SYafjeuLcFDJ0nL6mKyOw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/6] bnxt_en: Check devlink allocation and
 registration status
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev <netdev@vger.kernel.org>,
        Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 23, 2021 at 11:13 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> devlink is a software interface that doesn't depend on any hardware
> capabilities. The failure in SW means memory issues, wrong parameters,
> programmer error e.t.c.
>
> Like any other such interface in the kernel, the returned status of
> devlink APIs should be checked and propagated further and not ignored.
>
> Fixes: 4ab0c6a8ffd7 ("bnxt_en: add support to enable VF-representors")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  5 ++++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 ++++++-------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h | 13 -------------
>  3 files changed, 10 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 037767b370d5..4c483fd91dbe 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -13370,7 +13370,9 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>         }
>
>         bnxt_inv_fw_health_reg(bp);
> -       bnxt_dl_register(bp);
> +       rc = bnxt_dl_register(bp);
> +       if (rc)
> +               goto init_err_dl;
>
>         rc = register_netdev(dev);
>         if (rc)
> @@ -13390,6 +13392,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>
>  init_err_cleanup:
>         bnxt_dl_unregister(bp);
> +init_err_dl:
>         bnxt_shutdown_tc(bp);
>         bnxt_clear_int_mode(bp);
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> index bf7d3c17049b..dc0851f709f5 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> @@ -134,7 +134,7 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
>  {
>         struct bnxt_fw_health *health = bp->fw_health;
>
> -       if (!bp->dl || !health)
> +       if (!health)
>                 return;
>
>         if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
> @@ -188,7 +188,7 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
>  {
>         struct bnxt_fw_health *health = bp->fw_health;
>
> -       if (!bp->dl || !health)
> +       if (!health)
>                 return;
>
>         if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
> @@ -781,6 +781,7 @@ int bnxt_dl_register(struct bnxt *bp)
>  {
>         const struct devlink_ops *devlink_ops;
>         struct devlink_port_attrs attrs = {};
> +       struct bnxt_dl *bp_dl;
>         struct devlink *dl;
>         int rc;
>
> @@ -795,7 +796,9 @@ int bnxt_dl_register(struct bnxt *bp)
>                 return -ENOMEM;
>         }
>
> -       bnxt_link_bp_to_dl(bp, dl);
> +       bp->dl = dl;
> +       bp_dl = devlink_priv(dl);
> +       bp_dl->bp = bp;
>
>         /* Add switchdev eswitch mode setting, if SRIOV supported */
>         if (pci_find_ext_capability(bp->pdev, PCI_EXT_CAP_ID_SRIOV) &&
> @@ -826,7 +829,6 @@ int bnxt_dl_register(struct bnxt *bp)
>  err_dl_port_unreg:
>         devlink_port_unregister(&bp->dl_port);
>  err_dl_free:
> -       bnxt_link_bp_to_dl(bp, NULL);
>         devlink_free(dl);
>         return rc;
>  }
> @@ -835,9 +837,6 @@ void bnxt_dl_unregister(struct bnxt *bp)
>  {
>         struct devlink *dl = bp->dl;
>
> -       if (!dl)
> -               return;
> -

minor nit: There's obviously nothing incorrect about doing this (and
adding the additional error label in the cleanup code above), but bnxt
has generally adopted a style of having cleanup functions being
idempotent. It generally makes error handling simpler and less error
prone.

>         if (BNXT_PF(bp)) {
>                 bnxt_dl_params_unregister(bp);
>                 devlink_port_unregister(&bp->dl_port);
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
> index d889f240da2b..406dc655a5fc 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
> @@ -20,19 +20,6 @@ static inline struct bnxt *bnxt_get_bp_from_dl(struct devlink *dl)
>         return ((struct bnxt_dl *)devlink_priv(dl))->bp;
>  }
>
> -/* To clear devlink pointer from bp, pass NULL dl */
> -static inline void bnxt_link_bp_to_dl(struct bnxt *bp, struct devlink *dl)
> -{
> -       bp->dl = dl;
> -
> -       /* add a back pointer in dl to bp */
> -       if (dl) {
> -               struct bnxt_dl *bp_dl = devlink_priv(dl);
> -
> -               bp_dl->bp = bp;
> -       }
> -}
> -
>  #define NVM_OFF_MSIX_VEC_PER_PF_MAX    108
>  #define NVM_OFF_MSIX_VEC_PER_PF_MIN    114
>  #define NVM_OFF_IGNORE_ARI             164
> --
> 2.31.1
>

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Regards,
Edwin Peer

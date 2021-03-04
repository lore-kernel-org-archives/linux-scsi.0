Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08EDC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE6364F04
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 09:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237543AbhCDJ3D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237541AbhCDJ2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2021 04:28:55 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B0CC06175F
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 01:28:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id dm26so10282669edb.12
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 01:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Ehv2kf1tag9EO78jPnCxpYNbaxVuOd9a7Ggdpi6cJU=;
        b=SvnBRwg0MH6amaI0NM09FCvwaT/ReJNZHx5TY0RQph59UdwaTC5RX+0boDDWtu69yr
         QRCysDQnRUZf0U8iErEdFdaFPetdoKyvS94Pa2xD1ObglqOrhgoCsiflVjF5KNctLUyn
         F3uDZbNTgBQNRB1lHNh0tfFicQxiTw3+4nOEKG8iYh2g2+YqrYm4jFcjdOaHjnb6MF6M
         JbsCOEOdFIUK7zbRifpb8BNB27yNJNuXwKZmZxsTgdLqI9FatQL23PcNDDrqvX8E/yDj
         1l1TiPJpZC+LvZGPcMg7a8uDi1bkth4ne/52PVNg6OOJOG7FZEZXAO5XDtYBYVwpjQxo
         fcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Ehv2kf1tag9EO78jPnCxpYNbaxVuOd9a7Ggdpi6cJU=;
        b=dHszz6czK2FD8tO8azKW8QQkjKxK2LI9xas2yM2SvsKPX+LJ83ZCQ2hcweKecWFi1f
         1B9q6YvFt1XaY6FXEqHQAOMqqeBnJ7ZHbbU/5Da0/62J7gGaGGxFgpvHFOr7IOQ80pAg
         sgxgRN7bfM0EPu++qb0r7iyGbRyZUYUShGSaVlhKWmDIBu2DNZmhIMpxICXpOBvi4c2Z
         ebVA05q0KMoZ5aivxiioC6WalF1J5t130q+YjX9jGQmLmmkeAXx6h6+eUw4NaiaEbJ8Q
         0likuniXwgokh7lxrleskp9djkbi9pKVJAqd4nqqHQTIs6y5zivNnsEqVx3RAd4P1/og
         DzdA==
X-Gm-Message-State: AOAM533rO4IjaWmVTRoyuo3X/SsgvflgguyjXSr2y8S4tJTfWFpI10RO
        YWJ9+INkl18K3FNeTresp8/1MRsWLZNSkJaT+ZUXOA==
X-Google-Smtp-Source: ABdhPJzS4biC+pSsATS1+cGkLsWzen3JSxZ98AKQr3GE5ZiTX+KlwZq9K7+oO0Cd5SisvEuiXJk+PntZrcSNEH6JagY=
X-Received: by 2002:a50:f38f:: with SMTP id g15mr3274594edm.262.1614850094077;
 Thu, 04 Mar 2021 01:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20210224155802.13292-1-Viswas.G@microchip.com> <20210224155802.13292-5-Viswas.G@microchip.com>
In-Reply-To: <20210224155802.13292-5-Viswas.G@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 4 Mar 2021 10:28:03 +0100
Message-ID: <CAMGffEmxqcduAMHND3q4BPsr8LAg_J3r635_xxUCha_LCFehhw@mail.gmail.com>
Subject: Re: [PATCH 4/7] pm80xx: Add sysfs attribute to track iop1 count
To:     Viswas G <Viswas.G@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com,
        Vishakha Channapattan <vishakhavc@google.com>,
        Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 24, 2021 at 4:48 PM Viswas G <Viswas.G@microchip.com> wrote:
>
> From: Vishakha Channapattan <vishakhavc@google.com>
>
> A new sysfs variable 'ctl_iop1_count' is being introduced that tells if
> the controller is alive by indicating controller ticks. If on subsequent
> run we see the ticks changing that indicates that controller is not
> dead.
>
> Tested: Using 'ctl_iop1_count' sysfs variable we can see ticks
> incrementing
> mvae14:~# cat  /sys/class/scsi_host/host*/ctl_iop1_count
> IOP1TCNT=0x00000069
> IOP1TCNT=0x0000006b
> IOP1TCNT=0x0000006d
> IOP1TCNT=0x00000072
>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
> Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 8470bce2cee1..9bc9ef446801 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -967,6 +967,30 @@ static ssize_t ctl_iop0_count_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(ctl_iop0_count);
>
> +/**
> + * ctl_iop1_count_show - controller iop1 count check
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
> +
> +static ssize_t ctl_iop1_count_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       unsigned int iop1cnt = 0;
> +       int c;
> +
> +       pm8001_dbg(pm8001_ha, IOCTL, "%s\n", __func__);
> +       iop1cnt = pm8001_mr32(pm8001_ha->general_stat_tbl_addr, 20);
> +       c = sprintf(buf, "IOP1TCNT=0x%08x\n", iop1cnt);
> +       return c;
> +}
New file should use  sysfs_emit instead of sprintf.
> +static DEVICE_ATTR_RO(ctl_iop1_count);
> +
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> @@ -993,6 +1017,7 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_ctl_mpi_state,
>         &dev_attr_ctl_raae_count,
>         &dev_attr_ctl_iop0_count,
> +       &dev_attr_ctl_iop1_count,
>         NULL,
>  };
>
> --
> 2.16.3
>

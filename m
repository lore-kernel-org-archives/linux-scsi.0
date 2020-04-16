Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9959AC2BB55
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 11:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D8421D7F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 11:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Yr7gYavj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634314AbgDPL5d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 07:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634536AbgDPL5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2020 07:57:22 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A255CC061A0F
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 04:57:21 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t8so6635844ilj.3
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2020 04:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nwHHV6GYSGQe4aA3HIb5FYFf4qpvmqjjOVVsHw8zmMQ=;
        b=Yr7gYavjWTXEBvOy/f/e2KIRIAhymFnAFYUgZPBObSoiUtKwqdEk/aJuBsL3I/VozD
         19INfd9bEer2csiIHD8VCCWL7UI3jpOLEWg2M0mcsbis/KN46Ahn58doiwUBWUIok1xF
         lYWC0rf7ot8Ulh3wNWN0bN7Z0OJFAZkbkYINjQg2ESBPfxW3XePAeBKWlxgJq8pG3H9f
         HH7hGz8fXeBCtnDj1ujbd/dXxPjxXR8S66S9oz8EIDQODVUIJ+ge37L83TU69558YA68
         fArGSBuQNJy3dpS5rEy3RmaxF+hdk+U3kbxANniXxOuBJrrro8gbLUzxdod6JJXo+N3g
         1E5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nwHHV6GYSGQe4aA3HIb5FYFf4qpvmqjjOVVsHw8zmMQ=;
        b=rXNNLWZXDxwrCjqVuSNCdC0fPBOMk6VNiG8FisUXYIIu7OgCDPe1vZ1+BDNgYVtden
         eBW8q2UrJD5sw4+xebwlsl48m43hxfZHK5nfKAc5/2aVWfpzMZmyrD2CjNsJxgBZfaC+
         CZbCmSLtx42tTo1iR0FVCM9gjCGcTwaOn8Ze+avuagpCFrid/nebSAe68yfjU9Sercrm
         DpFy754iXAtl9eviGowBV7jRKMtaNfzxoMcl/VVerVMuOMEwY5iw8aGiA2D1QNXYwKSB
         o9hwXjncIpe9E1xqZXCfA4v69VRaSH6tygRdD4DeRGfz9wvDPEBnTIznHgtqzRNOdlz7
         fuMg==
X-Gm-Message-State: AGi0PubPyJ4JtteAKfXVo/o8c+NV2YInG9z9j+kpmhKLrQOqb7ppCH6l
        XEkxVDBTKfFuwH3vQAIOgctqfW79M6v72TdwdLvGAw==
X-Google-Smtp-Source: APiQypKqk3qLUV+AJXNL6lhqrQ4SzrBlzOL5hqEzY5zeuMqNl7y+L4aP6YcMZqLGuu5O4dOSzHHE3LsFAOz5MFqmf8w=
X-Received: by 2002:a92:ba01:: with SMTP id o1mr7826074ili.217.1587038240886;
 Thu, 16 Apr 2020 04:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200413094938.6182-1-deepak.ukey@microchip.com> <20200413094938.6182-4-deepak.ukey@microchip.com>
In-Reply-To: <20200413094938.6182-4-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 16 Apr 2020 13:57:09 +0200
Message-ID: <CAMGffEnGvZw0=H0VYR7b9LQaSsEwFwBtJBF88+iSuygWaACKUw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pm80xx : Wait for PHY startup before draining libsas queue.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jinpu Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 13, 2020 at 11:40 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: peter chang <dpf@google.com>
>
> Until udev rolls out we can't proceed past module loading w/ device
> discovery in progress because things like the init scripts only work
> over the currently discovered block devices.
Just curious, what's this udev rollout?

The drivers for disk
> controllers have various forms of 'barriers' to prevent this from
> happening depending on their underlying support libraries.
> The host's scan finish waits for the libsas queue to drain. However,
> if the PHYs are still in the process of starting then the queue will
> be empty. This means that we declare the scan finished before it has
> even started. Here we wait for various events from the firmware-side,
> and even though we disable staggered spinup we still pretend like
> it's there.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: peter chang <dpf@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  | 36 +++++++++++++++++++++
>  drivers/scsi/pm8001/pm8001_defs.h |  6 ++--
>  drivers/scsi/pm8001/pm8001_init.c | 25 +++++++++++++++
>  drivers/scsi/pm8001/pm8001_sas.c  | 61 +++++++++++++++++++++++++++++++++--
>  drivers/scsi/pm8001/pm8001_sas.h  |  3 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 67 ++++++++++++++++++++++++++++++++-------
>  6 files changed, 181 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 3c9f42779dd0..eae629610a5f 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -88,6 +88,41 @@ static ssize_t controller_fatal_error_show(struct device *cdev,
>  }
>  static DEVICE_ATTR_RO(controller_fatal_error);
>
> +/**
> + * phy_startup_timeout_show - per-phy discovery timeout
> + * @cdev: pointer to embedded class device
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read/write' shost attribute.
> + */
> +static ssize_t phy_startup_timeout_show(struct device *cdev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       return snprintf(buf, PAGE_SIZE, "%08xh\n",
> +               pm8001_ha->phy_startup_timeout / HZ);
> +}
> +
> +static ssize_t phy_startup_timeout_store(struct device *cdev,
> +       struct device_attribute *attr, const char *buf, size_t count)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       int val = 0;
> +
> +       if (kstrtoint(buf, 0, &val) < 0)
> +               return -EINVAL;
> +
> +       pm8001_ha->phy_startup_timeout = val * HZ;
> +       return strlen(buf);
> +}
> +
> +static DEVICE_ATTR_RW(phy_startup_timeout);
> +
>  /**
>   * pm8001_ctl_fw_version_show - firmware version
>   * @cdev: pointer to embedded class device
> @@ -867,6 +902,7 @@ static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,
>  struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_interface_rev,
>         &dev_attr_controller_fatal_error,
> +       &dev_attr_phy_startup_timeout,
>         &dev_attr_fw_version,
>         &dev_attr_update_fw,
>         &dev_attr_aap_log,
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index fd700ce5e80c..aaeabb2f2808 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -141,7 +141,9 @@ enum pm8001_hba_info_flags {
>   */
>  #define PHY_LINK_DISABLE       0x00
>  #define PHY_LINK_DOWN          0x01
> -#define PHY_STATE_LINK_UP_SPCV 0x2
> -#define PHY_STATE_LINK_UP_SPC  0x1
> +#define PHY_STATE_LINK_UP_SPCV 0x02
> +#define PHY_STATE_LINK_UP_SPC  0x01
> +#define PHY_STATE_LINK_RESET   0x03
> +#define PHY_STATE_HARD_RESET   0x04
>
>  #endif
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 6cbb8fa74456..560dd9c3f745 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -61,6 +61,30 @@ MODULE_PARM_DESC(staggered_spinup, "enable the staggered spinup feature.\n"
>                 " 0/N: false\n"
>                 " 1/Y: true\n");
>
> +/* if nothing is detected, the PHYs will reset continuously once they
> + * are started. we don't have a good way of differentiating a trained
> + * but waiting-on-signature from one that's never going to train
> + * (nothing attached or dead drive), so we wait an possibly
> + * unreasonable amount of time. this is stuck in start_timeout, and
> + * checked in the host's scan_finished callback for PHYs that haven't
> + * yet come up.
> + *
> + * the timeout here was experimentally determined by looking at our
> + * current worst-case spin-up drive (seagate 8T) which has
> + * the most drive-to-drive variance, some issues coming up from the
> + * sleep state (randomly applied ~10s delay to non-data operations),
> + * and errors from IDENTIFY.
> + *
> + * NB: this a workaround to handle current lack of udev. once
> + * that's everywhere and dynamically dealing w/ device add/remove
> + * (step one doesn't deal w/ this later condition) then the patches
> + * can be removed.

If it's just a workaround for missing proper udev rule, I think we
shouldnt' include it in upstream.
> + */
> +static ulong phy_startup_timeout = 60;
> +module_param(phy_startup_timeout, ulong, 0644);
> +MODULE_PARM_DESC(phy_startup_timeout_s,
> +               " seconds to wait for discovery, per-PHY.");
> +
>  static struct scsi_transport_template *pm8001_stt;
>
>  /**
> @@ -493,6 +517,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>         pm8001_ha->id = pm8001_id++;
>         pm8001_ha->logging_level = logging_level;
>         pm8001_ha->staggered_spinup = staggered_spinup;
> +       pm8001_ha->phy_startup_timeout = phy_startup_timeout * HZ;
>         pm8001_ha->non_fatal_count = 0;
>         if (link_rate >= 1 && link_rate <= 15)
>                 pm8001_ha->link_rate = (link_rate << 8);
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 806845203602..470fe4dd3b52 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -39,6 +39,7 @@
>   */
>
>  #include <linux/slab.h>
> +#include "pm80xx_hwi.h"
>  #include "pm8001_sas.h"
>
>  /**
> @@ -257,6 +258,54 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
>         return rc;
>  }
>
> +static int pm8001_update_phy_mask(struct pm8001_hba_info *pm8001_ha)
> +{
> +       struct phy_profile *profile = &pm8001_ha->phy_profile_resp.phy.status;
> +       DECLARE_COMPLETION_ONSTACK(comp);
> +       unsigned long timeout = msecs_to_jiffies(2000);
> +       int ret = 0;
> +       int i;
> +
> +       for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
> +               struct pm8001_phy *phy = pm8001_ha->phy + i;
> +
> +               if (pm8001_ha->phy_mask & (1 << i) && phy->phy_state) {
> +                       pm8001_ha->phyprofile_completion = &comp;
Ok, you have phyprofile_completion init here, I think it should be
moved to first patch.

Thanks!

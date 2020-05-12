Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D51C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3A7620714
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:33:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="L/R0XOnR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgELGdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 02:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725933AbgELGdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 02:33:09 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039D7C061A0C
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 23:33:08 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g16so10149755eds.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 23:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t8sXIaJcTEx1QKczWUVLuSAXIZTyd8QhnIAwQsQ+itM=;
        b=L/R0XOnRTljw8NI7zzigTuBeQ4Xrvw8nVT/AFTV3ZWs7Hz3AMfkvdSlWqEwqpGz0Oh
         0NggQCIMVRhkFeBDEI0QMViodsZUk5VWCUlS2PSkv1Oophrd/WKO4H2LWf0shsnPIsFP
         zEDhGASLZHbEf4yckkrRQldmmu5VkmB2hkxKhnJVM7riVWyOZ21yROiAk9bJYVGXjciz
         PO+fW9MUZj6kB7ggTgc5YS75f5Ttd5dPdCHYK1me3DbClc+wxzWYoYFqAQ1ptlPAxFSQ
         /SYhrhD05R157qrYMsLbMhg4fTMY+ipCPqVnVbtJj7ebunDGXbfHBfCbLYwgiGQeZTCZ
         BPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t8sXIaJcTEx1QKczWUVLuSAXIZTyd8QhnIAwQsQ+itM=;
        b=dPrh17hzgq9nMtWJaA0CCu/ZT3zDXNwmcXKFBeJ1OBFjliaIJ8ydhoak7Xlj6pNGzF
         CcvQ+4VxMFCmphWjQpZspt5gUXFFNQhGslNIQooE59EDmVCo6kAcNXfNnQr/c09R+oG/
         RkARQJ8YsCUy+XvZufyZ8aPYFYVXCxuSkd+a01//1uc0naKmkPuFMVs+t7RgCxIQyFgz
         9gOF/1jdsToLaJwv8anO3+Pmh6sFIcBFKhFVOXFeEPLVARWvg8lZr5OJj8NPB7YIQHI/
         31n2AIHunJe+RS/Ebs9znwdooUobUiyu1Gk1xZZjpuAAjG+WYM7xKqVtUDHzpPO89FGy
         qm4g==
X-Gm-Message-State: AOAM531gB8AAXgwO1LZd+oi2yrhIP4vOM+iqP7UinDcbuBjAkVUhjA0j
        Batrk0mooMooAWkfkh6Se7UwWTEoUkJN6+CmOPw0Jg==
X-Google-Smtp-Source: ABdhPJxNpXkC3tJF5LTJKKW6/SmUg6LPnfOAdKmxBQw5xu51TOwEUFxXeetHiFrKJYiJ7vRHVVDdGtQo1NXC99o44mw=
X-Received: by 2002:aa7:d787:: with SMTP id s7mr4772089edq.104.1589265186487;
 Mon, 11 May 2020 23:33:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200413094938.6182-1-deepak.ukey@microchip.com>
 <20200413094938.6182-4-deepak.ukey@microchip.com> <CAMGffEnGvZw0=H0VYR7b9LQaSsEwFwBtJBF88+iSuygWaACKUw@mail.gmail.com>
 <MN2PR11MB36794A34979006EC157A48DFEFBE0@MN2PR11MB3679.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB36794A34979006EC157A48DFEFBE0@MN2PR11MB3679.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Tue, 12 May 2020 08:32:55 +0200
Message-ID: <CAMGffEkoLz=RrFqiO8USKqEZMUMS_UbxTAytk9grxtX_9vnhag@mail.gmail.com>
Subject: Re: [PATCH 3/3] pm80xx : Wait for PHY startup before draining libsas queue.
To:     Deepak Ukey <Deepak.Ukey@microchip.com>
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

On Tue, May 12, 2020 at 7:32 AM <Deepak.Ukey@microchip.com> wrote:
>
> On Mon, Apr 13, 2020 at 11:40 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
> >
> > From: peter chang <dpf@google.com>
> >
> > Until udev rolls out we can't proceed past module loading w/ device
> > discovery in progress because things like the init scripts only work
> > over the currently discovered block devices.
> Just curious, what's this udev rollout?
>
> The drivers for disk
> > controllers have various forms of 'barriers' to prevent this from
> > happening depending on their underlying support libraries.
> > The host's scan finish waits for the libsas queue to drain. However,
> > if the PHYs are still in the process of starting then the queue will
> > be empty. This means that we declare the scan finished before it has
> > even started. Here we wait for various events from the firmware-side,
> > and even though we disable staggered spinup we still pretend like it's
> > there.
> >
> > Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> > Signed-off-by: Viswas G <Viswas.G@microchip.com>
> > Signed-off-by: Radha Ramachandran <radha@google.com>
> > Signed-off-by: peter chang <dpf@google.com>
> > ---
> >  drivers/scsi/pm8001/pm8001_ctl.c  | 36 +++++++++++++++++++++
> > drivers/scsi/pm8001/pm8001_defs.h |  6 ++--
> > drivers/scsi/pm8001/pm8001_init.c | 25 +++++++++++++++
> > drivers/scsi/pm8001/pm8001_sas.c  | 61
> > +++++++++++++++++++++++++++++++++--
> >  drivers/scsi/pm8001/pm8001_sas.h  |  3 ++
> > drivers/scsi/pm8001/pm80xx_hwi.c  | 67
> > ++++++++++++++++++++++++++++++++-------
> >  6 files changed, 181 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_ctl.c
> > b/drivers/scsi/pm8001/pm8001_ctl.c
> > index 3c9f42779dd0..eae629610a5f 100644
> > --- a/drivers/scsi/pm8001/pm8001_ctl.c
> > +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> > @@ -88,6 +88,41 @@ static ssize_t controller_fatal_error_show(struct
> > device *cdev,  }  static DEVICE_ATTR_RO(controller_fatal_error);
> >
> > +/**
> > + * phy_startup_timeout_show - per-phy discovery timeout
> > + * @cdev: pointer to embedded class device
> > + * @buf: the buffer returned
> > + *
> > + * A sysfs 'read/write' shost attribute.
> > + */
> > +static ssize_t phy_startup_timeout_show(struct device *cdev,
> > +       struct device_attribute *attr, char *buf) {
> > +       struct Scsi_Host *shost = class_to_shost(cdev);
> > +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> > +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> > +
> > +       return snprintf(buf, PAGE_SIZE, "%08xh\n",
> > +               pm8001_ha->phy_startup_timeout / HZ); }
> > +
> > +static ssize_t phy_startup_timeout_store(struct device *cdev,
> > +       struct device_attribute *attr, const char *buf, size_t count)
> > +{
> > +       struct Scsi_Host *shost = class_to_shost(cdev);
> > +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> > +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> > +       int val = 0;
> > +
> > +       if (kstrtoint(buf, 0, &val) < 0)
> > +               return -EINVAL;
> > +
> > +       pm8001_ha->phy_startup_timeout = val * HZ;
> > +       return strlen(buf);
> > +}
> > +
> > +static DEVICE_ATTR_RW(phy_startup_timeout);
> > +
> >  /**
> >   * pm8001_ctl_fw_version_show - firmware version
> >   * @cdev: pointer to embedded class device @@ -867,6 +902,7 @@ static
> > DEVICE_ATTR(update_fw, S_IRUGO|S_IWUSR|S_IWGRP,  struct
> > device_attribute *pm8001_host_attrs[] = {
> >         &dev_attr_interface_rev,
> >         &dev_attr_controller_fatal_error,
> > +       &dev_attr_phy_startup_timeout,
> >         &dev_attr_fw_version,
> >         &dev_attr_update_fw,
> >         &dev_attr_aap_log,
> > diff --git a/drivers/scsi/pm8001/pm8001_defs.h
> > b/drivers/scsi/pm8001/pm8001_defs.h
> > index fd700ce5e80c..aaeabb2f2808 100644
> > --- a/drivers/scsi/pm8001/pm8001_defs.h
> > +++ b/drivers/scsi/pm8001/pm8001_defs.h
> > @@ -141,7 +141,9 @@ enum pm8001_hba_info_flags {
> >   */
> >  #define PHY_LINK_DISABLE       0x00
> >  #define PHY_LINK_DOWN          0x01
> > -#define PHY_STATE_LINK_UP_SPCV 0x2
> > -#define PHY_STATE_LINK_UP_SPC  0x1
> > +#define PHY_STATE_LINK_UP_SPCV 0x02
> > +#define PHY_STATE_LINK_UP_SPC  0x01
> > +#define PHY_STATE_LINK_RESET   0x03
> > +#define PHY_STATE_HARD_RESET   0x04
> >
> >  #endif
> > diff --git a/drivers/scsi/pm8001/pm8001_init.c
> > b/drivers/scsi/pm8001/pm8001_init.c
> > index 6cbb8fa74456..560dd9c3f745 100644
> > --- a/drivers/scsi/pm8001/pm8001_init.c
> > +++ b/drivers/scsi/pm8001/pm8001_init.c
> > @@ -61,6 +61,30 @@ MODULE_PARM_DESC(staggered_spinup, "enable the staggered spinup feature.\n"
> >                 " 0/N: false\n"
> >                 " 1/Y: true\n");
> >
> > +/* if nothing is detected, the PHYs will reset continuously once they
> > + * are started. we don't have a good way of differentiating a trained
> > + * but waiting-on-signature from one that's never going to train
> > + * (nothing attached or dead drive), so we wait an possibly
> > + * unreasonable amount of time. this is stuck in start_timeout, and
> > + * checked in the host's scan_finished callback for PHYs that haven't
> > + * yet come up.
> > + *
> > + * the timeout here was experimentally determined by looking at our
> > + * current worst-case spin-up drive (seagate 8T) which has
> > + * the most drive-to-drive variance, some issues coming up from the
> > + * sleep state (randomly applied ~10s delay to non-data operations),
> > + * and errors from IDENTIFY.
> > + *
> > + * NB: this a workaround to handle current lack of udev. once
> > + * that's everywhere and dynamically dealing w/ device add/remove
> > + * (step one doesn't deal w/ this later condition) then the patches
> > + * can be removed.
>
> If it's just a workaround for missing proper udev rule, I think we shouldnt' include it in upstream.
>
> Thank you for your suggestion, we are looking into the possibility of handling this behavior with udev.
> Since some drives take longer to respond back to that phy start request, the following wait does nothing, since the sas workqueue is empty.
>     /* Wait for discovery to finish */
>         sas_drain_work(ha);
> The "wait" behavior could be exposed as a module parameter, if the parameter is enabled, the driver will wait for the phy up event from the firmware, before proceeding with load.  Would this be acceptable as an alternative solution?
Sounds fine to me!

Thanks

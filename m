Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE82BC5DF60
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84BA521D79
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 08:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="PgOELs+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfKGIgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:36:36 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39351 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKGIgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 03:36:36 -0500
Received: by mail-io1-f67.google.com with SMTP id k1so1375472ioj.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 00:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Di1PDjrBt4pvcUNn0rviodoITzqn8bvTdHj3GJEzBfw=;
        b=PgOELs+df2q+3rwn9j/FriE8m3XP4pRA2xwb1G1raCTd3aFLtr8eUQcFkInNJ2TWdQ
         VQ01y/Y620G8unk719lURb757uWbieW9enM/nHpPc8fZmT4t0N5WmZrciT7o8jlE944n
         Ssr+tkI+/4sP6PDGyGeNBRIEmVOZSdwofdRveerNI29VHq0BgbqQNa6WIWZ6lm/aVf6H
         6UTG6N75+m5oRgBSQMlEFkNw5kStuN6ogLg4LQAr5HmMCsdrCgmKNlXUUSSQzZ+ELtcv
         NQvsHFyQc2Y4uSmY1nkNdB8MmJVtj8n5j6Gcin4hcTcOhbFAo0275pXvmSxEB7qX0Fhh
         TROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Di1PDjrBt4pvcUNn0rviodoITzqn8bvTdHj3GJEzBfw=;
        b=PXmMye3IaYlaEKx7g3qqkBg+7eugmOU81mykvDRIw0KR3wdzb9DGeK6gTV9XANUD2a
         vYnGAfPUyeecZseUxctk9yA8DTZY7FxWJXTmCp8lW1qfOOX5vXZJZ2OSVqg4W/Y42SkK
         NeXU2C+PI/6xuaI3tzalrXoKQn27JQvDK0qxkkX2v3MY6Vq6JDETAbnnV4vDEESQOtQs
         LI9muNIKSDLQEHIQZg8fLJj4KIZwcXdUAoMtAx5MgHyP93cRbAUsqoKc0yOFDNhzYA7w
         v0oB0du+aYwOb+2xbvKNOQ4Ln0sZvMbQCmJLvF3he/Lk6dQfe1LDruYUqjsvWLSBb/HD
         id4g==
X-Gm-Message-State: APjAAAVSc7z+0LhgISvfxtEi7Rs9JrdV2n1LF2aDeoOH6dSxIAMWZIwR
        DnMfXVBEhYhcjbXowqTS/EFKJVHWgfiIPEWZU2UCyA==
X-Google-Smtp-Source: APXvYqzSbXcHw5bDRvhrjiVDNnZ0K/y9/WTqVqhbCnX3+wpoIElSQR4pNn+tVWbxwMfyK+VZoF06jPpsHSBk6IhINk0=
X-Received: by 2002:a5d:80d5:: with SMTP id h21mr2200884ior.298.1573115793588;
 Thu, 07 Nov 2019 00:36:33 -0800 (PST)
MIME-Version: 1.0
References: <20191031051241.6762-1-deepak.ukey@microchip.com>
 <20191031051241.6762-11-deepak.ukey@microchip.com> <CAMGffE=qMtx7m_9up1N9j0bGT+cjb0VOUwB2LD5z8=BMU_3MRA@mail.gmail.com>
 <MN2PR11MB3550193FA72FEF6C5E862E6DEF780@MN2PR11MB3550.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3550193FA72FEF6C5E862E6DEF780@MN2PR11MB3550.namprd11.prod.outlook.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Thu, 7 Nov 2019 09:36:23 +0100
Message-ID: <CAMGffE=CcXj9kHdzv=qMfs0ZXcJJ=7h=OtnDb2pcZKCQkkhkvQ@mail.gmail.com>
Subject: Re: [PATCH 10/12] pm80xx : Controller fatal error through sysfs.
To:     Deepak Ukey <Deepak.Ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 7, 2019 at 7:20 AM <Deepak.Ukey@microchip.com> wrote:
>
> On Thu, Oct 31, 2019 at 6:12 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
> >
> > From: Deepak Ukey <Deepak.Ukey@microchip.com>
> >
> > Added support to check controller fatal error through sysfs.
> >
> > Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> > Signed-off-by: Viswas G <Viswas.G@microchip.com>
> > ---
> >  drivers/scsi/pm8001/pm8001_ctl.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/drivers/scsi/pm8001/pm8001_ctl.c
> > b/drivers/scsi/pm8001/pm8001_ctl.c
> > index 6b85016b4db3..fbdd0bf0e1ab 100644
> > --- a/drivers/scsi/pm8001/pm8001_ctl.c
> > +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> > @@ -69,6 +69,25 @@ static ssize_t
> > pm8001_ctl_mpi_interface_rev_show(struct device *cdev,  static
> > DEVICE_ATTR(interface_rev, S_IRUGO, pm8001_ctl_mpi_interface_rev_show,
> > NULL);
> >
> > +/**
> > + * pm8001_ctl_controller_fatal_err - check controller is under fatal
> > +err
> > + * @cdev: pointer to embedded class device
> > + * @buf: the buffer returned
> > + *
> > + * A sysfs 'read only' shost attribute.
> > + */
> > +static ssize_t controller_fatal_error_show(struct device *cdev,
> > +               struct device_attribute *attr, char *buf)
> The kernel-doc doesn't match the function name, please fix it.
> --Can you please tell me which function name you are pointing out. Is it about the difference in function description in the
> comment (pm8001_ctl_controller_fatal_err)  and actual function name (controller_fatal_error_show) ?
Yes.

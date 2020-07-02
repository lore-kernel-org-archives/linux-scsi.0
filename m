Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E18FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 07:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 254DF20899
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 07:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dNwVdPQb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgGBHoa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgGBHo3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 03:44:29 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4166FC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 00:44:29 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id l63so21490607oih.13
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2020 00:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QhtCrKOMrJh3dOcRpwDTzVQmrK8ccdkhNUWjR8SDdak=;
        b=dNwVdPQbrpvT7ObgsYlTmcaMHTcC4PbyhPm9N82buSlZms2hf0zWtsoIapur9pQNWo
         ajgm3sm2FfnzLL0pYRl3zgnUWQ+JdbcJQFm7sfiCHD92flM2w5DQ3c9zDgj2TnUTRNbw
         AjF86PZZkx4QQVzgEWGebTcHqAMT92EY9makg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QhtCrKOMrJh3dOcRpwDTzVQmrK8ccdkhNUWjR8SDdak=;
        b=ZX3LrhRXtn3zA/7TNb1BGJoJ30qbdaiXpHv65lX64NTVqYk0an/5GhOpHuPfhKpotB
         iOmV+KYxUkZOi5SLbXpXo2VOfiOWqb9N0Yn7RtqEoAH/IqQULpInANcaH0D8Pk8EjY2g
         K43eMBvgZav9mDtwW/CV829tTqXT406FYoGaBzxCOdqLx7UKeSi48Ae7IWtBF676dW0t
         LsWuW++bn6hyFMtpaPLcqUVWf/x3DWl2FUk+5RNK50RGZEN/hJsGhR9M5Moc0D87QqoZ
         eCFv2PEolIaGjf9RgSccmBx5gionHDPUV+qx1I4Hjq3cDBgbCtESJkxbe3pJ2RvGnF1u
         TXAg==
X-Gm-Message-State: AOAM5337il+DruvXwUtftMDy61nQvOw/cOdX4ZWxAAozw4nNx/0ZTkN1
        k8jSMYtWvdWXdRBazSmiGSpLpS6cQBFMbyM3uMBCtg==
X-Google-Smtp-Source: ABdhPJy3XskR8y4hxKjt5LF3DD/Ie00Ywo1Qfyx4y1aYc8KJQdr2CmtMJEpM9xy4KCfs1QJwUgUmhuaexvuIRyXcv+I=
X-Received: by 2002:aca:4844:: with SMTP id v65mr18178442oia.152.1593675868529;
 Thu, 02 Jul 2020 00:44:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200701131454.5255-1-johannes.thumshirn@wdc.com> <CY4PR04MB3751A35F8324DC1D0B949720E76D0@CY4PR04MB3751.namprd04.prod.outlook.com>
In-Reply-To: <CY4PR04MB3751A35F8324DC1D0B949720E76D0@CY4PR04MB3751.namprd04.prod.outlook.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Thu, 2 Jul 2020 13:14:17 +0530
Message-ID: <CAK=zhgozmJ=HJjj1E6i6Y4nLtP=4nCSrMRRU8sF2crfAmatNAg@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: fix error returns in BRM_status_show
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 2, 2020 at 6:36 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2020/07/01 22:15, Johannes Thumshirn wrote:
> > BRM_status_show() has several error branches, but none of them record the
> > error in the error return.]
> >
> > Also while at it remove the manual mutex_unlock() of the pci_access_mutex
> > in case of an ongoing pci error recovery or host removal and jump to the
> > cleanup lable instead.
> >
> > Note: we can safely jump to out as from here as io_unit_pg3 is initialized
> > to NULL and if it hasn't been allocated kfree() skips the NULL pointer.
> >
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> > ---
> >  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > index 62e552838565..70d2d0987249 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> > @@ -3149,20 +3149,20 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
> >       }
> >       /* pci_access_mutex lock acquired by sysfs show path */
> >       mutex_lock(&ioc->pci_access_mutex);
> > -     if (ioc->pci_error_recovery || ioc->remove_host) {
> > -             mutex_unlock(&ioc->pci_access_mutex);
> > -             return 0;
> > -     }
> > +     if (ioc->pci_error_recovery || ioc->remove_host)
> > +             goto out;
> >
> >       /* allocate upto GPIOVal 36 entries */
> >       sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
> >       io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
> >       if (!io_unit_pg3) {
> > +             rc = -ENOMEM;
> >               ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
> >                       __func__, sz);
> >               goto out;
> >       }
> >
> > +     rc = -EINVAL;
> >       if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
> >           0) {
> >               ioc_err(ioc, "%s: failed reading iounit_pg3\n",
> >
>
> Looks good.
>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

Patch looks good.
Acked-by: sreekanth reddy <sreekanth.reddy@broadcom.com>

Thanks,
Sreekanth

>
> --
> Damien Le Moal
> Western Digital Research

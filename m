Return-Path: <SRS0=de5d=CV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0011C43461
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 12:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9957D21548
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Sep 2020 12:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgILMtb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Sep 2020 08:49:31 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53819 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgILMt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Sep 2020 08:49:27 -0400
Received: from mail-qv1-f53.google.com ([209.85.219.53]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1N5lvf-1kbYKm0KRX-017BQ3; Sat, 12 Sep 2020 14:49:23 +0200
Received: by mail-qv1-f53.google.com with SMTP id f11so6621513qvw.3;
        Sat, 12 Sep 2020 05:49:22 -0700 (PDT)
X-Gm-Message-State: AOAM533sOcbi7WSDKDcMCBo1OvZ5gufzWgmCKpk62PQRjN8qWeBrhMYu
        dR2wXJA5dYyNTxx44W17zuH6XbdLkfy0W7ZICJs=
X-Google-Smtp-Source: ABdhPJyLEDkslxh1oVotoSzP+nGCkJSzjl5kt5d+bZeXmJIsOrYDMIBvdEsFhNPlKgNJ/CGOaVtnR2q+VfduVo+Z6Y0=
X-Received: by 2002:ad4:4f8f:: with SMTP id em15mr5944664qvb.65.1599914961745;
 Sat, 12 Sep 2020 05:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-3-arnd@arndb.de>
 <20200912074757.GA6688@infradead.org>
In-Reply-To: <20200912074757.GA6688@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 12 Sep 2020 14:49:05 +0200
X-Gmail-Original-Message-ID: <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
Message-ID: <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
Subject: Re: [PATCH 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:3VtwXdaeY72RCb46valaWLRKciz3X3uyxZeUvhzjR+GfuePUhKp
 UL7ThI592lVuGpOc0kFPuWh9s5i/StNsUBU6nDtXZ4SxzEwKBR97hkjQi0EdyZSQ910dxZI
 8RtfCN0jjIBvWSlczJkAefJ7awBWiHwb0y5oGOJ0oTj8pgpNnn1ELnZvEMrzAjjWrhZYWkx
 kS4pPGeCiRHukAghnITAw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:iPi3+o0//cw=:TWQrKio8l+Fp8owlMrHvbU
 HHq0TexJf8RgIAe5I+bRAVX6uxgUHv6bS8rNbF33HyLoS2PnsV2M3f2fu/wZgPn0NxEHVgeo/
 dvea9DPj5WjzS/zxTwI0vuMKlTamMnhknAIG4EBZn8i/joL+8xF1TozskwYpPDnEiPuStFlY7
 3WdcuxdQcqc8f78p8XKZQnHEYltC+9kktwbjIWUCjj05vgB1WDzndXR+t8ho1Rtp70gsMgGaj
 AJoxnzU0dvC3laD1T23Bon7ERPepgghHT3hL1N7j63RvqAkfUlA3DS1sCxkGPCKccO39Bwi1F
 SxOtUyZvvMA+auxhK6p36kaWDUSglffYQZomqM2WwJAufXNMKRgiT8Zc3dtfVLD2OuKwn5ll0
 96FooQONUxDVn2Z9jcJ6pkO2UrZELlhcIFvrXyDfkYtdOqbGt1Vo/UNu6qSJQG36BDtMWd5yq
 wcm64LCgGKsg4+L+Tfzz8sVGMVm22hmnphYB+gZU8QIN264pkDNs+WM5CWT5JEZcTsvFfRtmb
 /AEbvYuxHDIpkt69pFxc5MQInvkooFjfFOVpB76iQxDszruhar6stg6zu/da+EaIG6WO4G6+3
 D8BDg4Rx6cxNj5Tv4XTfRtIQdafUbSEiiDs63Layml8zEuP5eGrmg2GagpTaX43uFbSgm7caA
 ZWHN6gGgQcmvqvWLLP2Pzz7B7s4RZwGxd99bggLl4cbsAmcpWT4BKZ7rd5vH7tsWiUjwNYrhR
 cFmkeIptn3PbVxyo8MOxm8E4C+MwaCHYdefsQh5BXVCWWKjDouLxQhXwd+S3ezIRMpyCSdcTe
 lw8HqMzApRiymEsuxJ3+4E2vw2iDyoJjXDO5MII5T/gJCJajtJhqFSqXaZtcz3xZfgOyQWa
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 12, 2020 at 9:48 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Sep 08, 2020 at 11:36:23PM +0200, Arnd Bergmann wrote:
> > There have been several attempts to fix serious problems
> > in the compat handling in megasas_mgmt_compat_ioctl_fw(),
> > and it also uses the compat_alloc_user_space() function.
>
> I just looked into this a few weeks ago but didn't get that far..

Ok. To make sure we don't needlessly duplicate work, here are the
ones I have looked at over the past few days:

drivers/scsi/aacraid/linit.c: f = compat_alloc_user_space(sizeof(*f));
drivers/scsi/megaraid/megaraid_sas_base.c:
compat_alloc_user_space(sizeof(struct megasas_iocpacket));

Sent out here.

drivers/video/fbdev/core/fbmem.c: cmap = compat_alloc_user_space(sizeof(*cmap));
fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
fs/quota/compat.c: fsqstat = compat_alloc_user_space(sizeof(struct
fs_quota_stat));
kernel/kexec.c: ksegments = compat_alloc_user_space(nr_segments * sizeof(out));
mm/mempolicy.c: nm = compat_alloc_user_space(alloc_size);
mm/mempolicy.c: nm = compat_alloc_user_space(alloc_size);
mm/mempolicy.c: nm = compat_alloc_user_space(alloc_size);
mm/mempolicy.c: old = compat_alloc_user_space(new_nodes ? size * 2 : size);
mm/mempolicy.c: new = compat_alloc_user_space(size);
mm/migrate.c: pages = compat_alloc_user_space(nr_pages * sizeof(void *));
net/socket.c: rxnfc = compat_alloc_user_space(buf_size);
net/socket.c: uifr = compat_alloc_user_space(sizeof(*uifr));
sound/core/control_compat.c: data = compat_alloc_user_space(sizeof(*data));
sound/core/hwdep_compat.c: dst = compat_alloc_user_space(sizeof(*dst));
drivers/video/fbdev/sbuslib.c: struct fbcursor __user *p =
compat_alloc_user_space(sizeof(*p));

I have patches pending for all the above, but not sent out.

drivers/media/v4l2-core/v4l2-compat-ioctl32.c: *new_p64 =
compat_alloc_user_space(size + aux_space);

Currently looking at this. I have a plan but it's not as easy.

drivers/video/fbdev/sbuslib.c: struct fbcmap __user *p =
compat_alloc_user_space(sizeof(*p));

I played around with this one but could not come up with a solution that
is better than the current one. It's only used on sparc64 though, so we
might just leave the interface on that architecture until someone else
takes care of it.

drivers/staging/media/atomisp/pci/atomisp_compat_ioctl32.c: karg =
compat_alloc_user_space(

Had a brief look but did not investigate further, it's complicated.

drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
compat_alloc_user_space(sizeof(*args));
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
compat_alloc_user_space(sizeof(*args) +
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
compat_alloc_user_space(sizeof(*args));
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
compat_alloc_user_space(sizeof(*args) +
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
compat_alloc_user_space(sizeof(*args));
drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
compat_alloc_user_space(sizeof(*args));

Should not be too hard, but I have not looked in detail.


> > +static struct megasas_iocpacket *megasas_compat_iocpacket_get_user(void __user *arg)
>
> Pointlessly long line.

Ok

> > +{
> > +     int err = -EFAULT;
> > +#ifdef CONFIG_COMPAT
>
> I find the ifdef inside the function a little weird.  Doing it in the
> caller would be a little less bad.  What I ended up doing in my
> unfinished patch was to move the compat handling into a new
> megaraid_sas_compat.c file, so we'd always get the prototypes in a
> header, but given that all the calls are eliminated for the !COMPAT
> case we'd avoid ifdefs entirely, but having that file for a single
> function is also rather silly.

My first attempt was to have no #ifdef at all, but that would require
moving "struct compat_iovec" definition outside of the CONFIG_COMPAT
check as well. That might be the cleanest though.

The reason I ended up with the #ifdef inside of the function was that
otherwise I either needed one around the caller and one around
the function definition, or an empty inline in the #else path.

> > +     struct megasas_iocpacket *ioc;
> > +     struct compat_megasas_iocpacket __user *cioc = arg;
> > +     int i;
> > +
> > +     ioc = kzalloc(sizeof(*ioc), GFP_KERNEL);
>
> Missing NULL check here.

ok.

> > +     if (copy_from_user(ioc, arg,
> > +                        offsetof(struct megasas_iocpacket, frame) + 128))
> > +             goto out;
>
> the 128 here while copied from the original code should probably be
> replaced with a sizeof(frame->raw).

ok.

> > +     if (ioc->sense_len) {
> > +             compat_uptr_t *sense_ioc_ptr;
> > +             void __user *sense_cioc;
> > +
> > +             /* make sure the pointer is inside of frame.raw */
> > +             if (ioc->sense_off >
> > +                 (sizeof(ioc->frame.raw) - sizeof(void __user*))) {
> > +                     err = -EINVAL;
> > +                     goto out;
> > +             }
> > +
> > +             sense_ioc_ptr = (compat_uptr_t *)&ioc->frame.raw[ioc->sense_off];
> > +             sense_cioc = compat_ptr(get_unaligned(sense_ioc_ptr));
> > +             put_unaligned((unsigned long)sense_cioc, (void **)sense_ioc_ptr);
>
> I think we should really handle this where the sense point is set up.
> This is the untested hunk I had:
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 48fad675b5ed02..c3ddcfce86df50 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8231,7 +8231,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
>                         goto out;
>                 }
>
> -               sense_ptr = (void *)cmd->frame + ioc->sense_off;
> +               if (in_compat_syscall())
> +                       sense_ptr = compat_ptr((uintptr_t)cmd->frame) +
> +                                       ioc->sense_off;
> +               else
> +                       sense_ptr = (void *)cmd->frame + ioc->sense_off;
> +
>                 if (instance->consistent_mask_64bit)
>                         put_unaligned_le64(sense_handle, sense_ptr);
>                 else
>
> The same might make sense for the iovecs, but I didn't get to that
> yet..

I think you got the wrong one there, the code above is where the
dma address gets stored in the in-kernel copy of the sense data
based on the user space offset. Conceptually it does make sense
though and would end up looking something like

        if (ioc->sense_len) {
                /*
                 * sense_ptr points to the location that has the user
                 * sense buffer address
                 */
                sense_ptr = (void *)ioc->frame.raw + ioc->sense_off;
                if (in_compat_syscall())
                        uptr = compat_ptr(get_unaligned(u32 *)sense_ptr);
                else
                        uptr = get_unaligned((void __user **)sense_ptr);

                if (copy_to_user(uptr, sense, ioc->sense_len)) {

> >  static long
> >  megasas_mgmt_compat_ioctl(struct file *file, unsigned int cmd,
> >                         unsigned long arg)
> >  {
> >       switch (cmd) {
> >       case MEGASAS_IOC_FIRMWARE32:
> > -             return megasas_mgmt_compat_ioctl_fw(file, arg);
> > +             return megasas_mgmt_ioctl_fw(file, arg);
> >       case MEGASAS_IOC_GET_AEN:
> >               return megasas_mgmt_ioctl_aen(file, arg);
> >       }
>
> We should be able to kill off megasas_mgmt_compat_ioctl entirely now.

I tried that, but there is still one difference because one of them uses
MEGASAS_IOC_FIRMWARE while the other one uses
MEGASAS_IOC_FIRMWARE32. It would be possible to have
a common handler that always handles both command codes.
I tried to avoid changing the behavior that way though.

     Arnd

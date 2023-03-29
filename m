Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D8EC74A5B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 19:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjC2T24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 15:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjC2T2z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 15:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37048114
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 12:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680118084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6PAUPUdT43+ksdzWANA/6TUrN7YZ26PeZzcu2OMSrw=;
        b=Gac9KPdb+7ic9FgO0fgwoNygv9a5HXaKu5NCvsOsdeafqXKz+e4I19Fa/KkODnPwDNjc9v
        zv7dkMrNnZdOkgQ9oTn66S762YhbcDUajxXE+SMq7nZ7PIEBOJLd+v6Wx/5sgnKYOLnjWj
        FBOn98+2L3kS9dTL1Icu+YTFBSRQtns=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-7HaHh2MwMJSpJ4UPAOwfbw-1; Wed, 29 Mar 2023 15:28:02 -0400
X-MC-Unique: 7HaHh2MwMJSpJ4UPAOwfbw-1
Received: by mail-qt1-f197.google.com with SMTP id c14-20020ac87d8e000000b003e38726ec8bso10908452qtd.23
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 12:28:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680118081;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B6PAUPUdT43+ksdzWANA/6TUrN7YZ26PeZzcu2OMSrw=;
        b=ikfh6c1rc7djnkHDkerGaxzPx12G7+aaqjF9c+kW6KGziZW7fiPd+gtTX1xvhTdEWQ
         VL3oB5rGfehsH8iiZhXSyJO70e4fLDoSHUcEEl2tCHd67A57RQgWhOHfUmmNn77jcRc8
         /VxE3lEFSH370Rk9Ycn9aMNMyDZg4ObwrgcP1SN9bZ5XjSWkHyeflgKajAvhjLYq6QMz
         Gm4iZa8bdO2gO8Oz9k1YlfwCPDr+cCq3PIZOjrTyL+btENxulwdg+yQNhWjlK3wefmlD
         OxJe2Ountq8qKFcf17cAb1wlh2RKrVpd8hMQWStJU8HYG7TYDbTcAb80xP0/iaRs6wLj
         OY0g==
X-Gm-Message-State: AAQBX9cCwrU4vVxVIn78FuZsm8pWSgzHi5HFC5HrLxjUcbhTMsYNfz2v
        WuIxFmPH+eVewFTs3y49wNwJ58XrKRcaBoOFYR93nT0WlyFcVfkKkPIM6BxQnLc0qSgP5vY8t7C
        Fuduh1ukL9ezYeN4xkMwlpA==
X-Received: by 2002:a05:6214:224f:b0:5dd:5c8d:8667 with SMTP id c15-20020a056214224f00b005dd5c8d8667mr6434821qvc.5.1680118080776;
        Wed, 29 Mar 2023 12:28:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350YbP22vqP7axEErFvF6yFS08YKqaG4JCF/jXKjcjR2916bB59csiy04m66u1irhZGaqXXujFw==
X-Received: by 2002:a05:6214:224f:b0:5dd:5c8d:8667 with SMTP id c15-20020a056214224f00b005dd5c8d8667mr6434795qvc.5.1680118080473;
        Wed, 29 Mar 2023 12:28:00 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id qd11-20020ad4480b000000b005dd8b9345e4sm4828970qvb.124.2023.03.29.12.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 12:28:00 -0700 (PDT)
Date:   Wed, 29 Mar 2023 15:27:58 -0400
From:   Adrien Thierry <athierry@redhat.com>
To:     Stanley Chu <chu.stanley@gmail.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, peter.wang@mediatek.com
Subject: Re: [PATCH v3] scsi: ufs: initialize devfreq synchronously
Message-ID: <ZCSRPqeBsFt/p4IA@fedora>
References: <20230217194423.42553-1-athierry@redhat.com>
 <CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On Wed, Mar 29, 2023 at 04:39:30PM +0800, Stanley Chu wrote:
> Hi Adrien,
> 
> On Sat, Feb 18, 2023 at 3:50 AM Adrien Thierry <athierry@redhat.com> wrote:
> >
> > During ufs initialization, devfreq initialization is asynchronous:
> > ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
> > devfreq for ufs. The simple ondemand governor is then loaded. If it is
> > built as a module, request_module() is called and throws a warning:
> >
> >   WARNING: CPU: 7 PID: 167 at kernel/kmod.c:136 __request_module+0x1e0/0x460
> >   Modules linked in: crct10dif_ce llcc_qcom phy_qcom_qmp_usb ufs_qcom phy_qcom_snps_femto_v2 ufshcd_pltfrm phy_qcom_qmp_combo ufshcd_core phy_qcom_qmp_ufs qcom_wdt socinfo fuse ipv6
> >   CPU: 7 PID: 167 Comm: kworker/u16:3 Not tainted 6.2.0-rc6-00009-g58706f7fb045 #1
> >   Hardware name: Qualcomm SA8540P Ride (DT)
> >   Workqueue: events_unbound async_run_entry_fn
> >   pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> >   pc : __request_module+0x1e0/0x460
> >   lr : __request_module+0x1d8/0x460
> >   sp : ffff800009323b90
> >   x29: ffff800009323b90 x28: 0000000000000000 x27: 0000000000000000
> >   x26: ffff800009323d50 x25: ffff7b9045f57810 x24: ffff7b9045f57830
> >   x23: ffffdc5a83e426e8 x22: ffffdc5ae80a9818 x21: 0000000000000001
> >   x20: ffffdc5ae7502f98 x19: ffff7b9045f57800 x18: ffffffffffffffff
> >   x17: 312f716572667665 x16: 642f7366752e3030 x15: 0000000000000000
> >   x14: 000000000000021c x13: 0000000000005400 x12: ffff7b9042ed7614
> >   x11: ffff7b9042ed7600 x10: 00000000636c0890 x9 : 0000000000000038
> >   x8 : ffff7b9045f2c880 x7 : ffff7b9045f57c68 x6 : 0000000000000080
> >   x5 : 0000000000000000 x4 : 8000000000000000 x3 : 0000000000000000
> >   x2 : 0000000000000000 x1 : ffffdc5ae5d382f0 x0 : 0000000000000001
> >   Call trace:
> >    __request_module+0x1e0/0x460
> >    try_then_request_governor+0x7c/0x100
> >    devfreq_add_device+0x4b0/0x5fc
> >    ufshcd_async_scan+0x1d4/0x310 [ufshcd_core]
> >    async_run_entry_fn+0x34/0xe0
> >    process_one_work+0x1d0/0x320
> >    worker_thread+0x14c/0x444
> >    kthread+0x10c/0x110
> >    ret_from_fork+0x10/0x20
> >
> > This occurs because synchronous module loading from async is not
> > allowed. According to __request_module():
> >
> >   /*
> >    * We don't allow synchronous module loading from async.  Module
> >    * init may invoke async_synchronize_full() which will end up
> >    * waiting for this task which already is waiting for the module
> >    * loading to complete, leading to a deadlock.
> >    */
> >
> > I experienced such a deadlock on the Qualcomm QDrive3/sa8540p-ride. With
> > DEVFREQ_GOV_SIMPLE_ONDEMAND=m, the boot hangs after the warning.
> >
> > This patch fixes both the warning and the deadlock, by moving devfreq
> > initialization out of the async routine.
> >
> > I tested this on the sa8540p-ride by using fio to put the UFS under
> > load, and printing the trace generated by
> > /sys/kernel/tracing/events/ufs/ufshcd_clk_scaling events. The trace
> > looks similar with and without the change.
> >
> > Signed-off-by: Adrien Thierry <athierry@redhat.com>
> > ---
> > v3: Addressed Bart's comments
> > v2: Addressed Bart's comments
> >
> >  drivers/ufs/core/ufshcd.c | 47 ++++++++++++++++++++++++++-------------
> >  include/ufs/ufshcd.h      |  1 +
> >  2 files changed, 32 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 3a1c4d31e010..2c22a1367440 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -1357,6 +1357,13 @@ static int ufshcd_devfreq_target(struct device *dev,
> >         struct ufs_clk_info *clki;
> >         unsigned long irq_flags;
> >
> > +       /*
> > +        * Skip devfreq if ufs initialization is not finished.
> > +        * Otherwise ufs could be in a inconsistent state.
> > +        */
> > +       if (!smp_load_acquire(&hba->logical_unit_scan_finished))
> > +               return 0;
> > +
> >         if (!ufshcd_is_clkscaling_supported(hba))
> >                 return -EINVAL;
> >
> > @@ -8136,22 +8143,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
> >         if (ret)
> >                 goto out;
> >
> > -       /* Initialize devfreq after UFS device is detected */
> > -       if (ufshcd_is_clkscaling_supported(hba)) {
> > -               memcpy(&hba->clk_scaling.saved_pwr_info.info,
> > -                       &hba->pwr_info,
> > -                       sizeof(struct ufs_pa_layer_attr));
> > -               hba->clk_scaling.saved_pwr_info.is_valid = true;
> > -               hba->clk_scaling.is_allowed = true;
> > -
> > -               ret = ufshcd_devfreq_init(hba);
> > -               if (ret)
> > -                       goto out;
> > -
> > -               hba->clk_scaling.is_enabled = true;
> > -               ufshcd_init_clk_scaling_sysfs(hba);
> > -       }
> > -
> >         ufs_bsg_probe(hba);
> >         ufshpb_init(hba);
> >         scsi_scan_host(hba->host);
> > @@ -8290,6 +8281,12 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
> >         if (ret) {
> >                 pm_runtime_put_sync(hba->dev);
> >                 ufshcd_hba_exit(hba);
> > +       } else {
> > +               /*
> > +                * Make sure that when reader code sees ufs initialization has finished,
> > +                * all initialization steps have really been executed.
> > +                */
> > +               smp_store_release(&hba->logical_unit_scan_finished, true);
> >         }
> >  }
> >
> > @@ -9896,12 +9893,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
> >          */
> >         ufshcd_set_ufs_dev_active(hba);
> >
> > +       /* Initialize devfreq */
> > +       if (ufshcd_is_clkscaling_supported(hba)) {
> > +               memcpy(&hba->clk_scaling.saved_pwr_info.info,
> > +                       &hba->pwr_info,
> > +                       sizeof(struct ufs_pa_layer_attr));
> 
> Here, hba->pwr_info is not initialized yet, so
> hba->clk_scaling.saved_pwr_info will also have uninitialized values.
> This is logically incorrect.
> 
> First of all, hba->saved_pwr_info is originally designed to keep the
> "scaled-up" gear. This statement breaks it.
> 
> In addition, the incorrect hba->save_pwr_info may cause serious issues
> in ufshcd_scale_gear(), as power mode changes will fail due to
> incorrect "new_pwr_info".
> 
> Could you please revert this patch first and then upload a fixed one?

Thanks for pointing that out.

I also realized today that the patch introduces a devfreq warning:
"devfreq 1d84000.ufs: Couldn't update frequency transition information".

So I'm going to post a revert and take the time to come up with an
improved solution that fixes both issues.

Best,

Adrien


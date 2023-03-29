Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05985C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 08:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjC2Ijs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 04:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjC2Ijq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 04:39:46 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25181716
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 01:39:44 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j11so19120232lfg.13
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 01:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680079183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiZ+hOlV2qAEzowqzZnLsiYEIsh8wRIzUjOIZE+hawI=;
        b=icoqmbf71ICPj3rOewqEl6SUcdISf7yKitjE6qbf0KbNBur7BNBByZey+sZhlyle6f
         G2VeHw3HS43IecmbVPpUhAhB0HFYZrdWDD1OSxNw8R+THSX7AFLgWGL5FCvd0jZpjTES
         Uahb/GHknDikPdpk4glv0LxkhjJg3y/Vq1gZ41MiIArIGAhBWXTxK5/PB+KN72ugUnhH
         EGhGaT0WARe9ueTj0sDrdWItGQpBIYsEZlqkox/5k3ZEsOeym51B7pB9doDWzAnI7bW2
         oi1BYBtjw4O7YmG9TNov/PVXEbHsXNabd9urszszqstQq67cXGzMNs0eg6HGz5CRsOHX
         SYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680079183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JiZ+hOlV2qAEzowqzZnLsiYEIsh8wRIzUjOIZE+hawI=;
        b=Qtwidigpkz88DfbcYujYo3/zYkhtfqaB5vO7nTC+m/JUyipa2i1w1bJYapcrjIB2xD
         H+NCXdmxlnEkwvKUPPX6mhF8fPlZgnnlGm2CxA2SMUuEyaiDQLGAnOm4WELUyyvxwHIA
         SYRY5aeoA632+zPF0QoP+agIowXOB6IOCMA95tUu5tFt9LXISrkRaYyGeyWrqNKQB5lh
         FHPpo9r30adlnXgHsPoDhgG46xqb0xuy2tZjdaSGqld0uk3/NJFTnPKxHLQMNk7HC0go
         fpbXjqeK9ZkhClWOQh9/cC8CkP132orVtzpPkc5mdkfqwARMaV8tGDhaavkIo6evRa5k
         wN7w==
X-Gm-Message-State: AAQBX9fxrbjKdeCIX4MbheSO0WfHKBFfboBXg/59IgOFDrBQsuB0muZc
        79e9JDCOcZp9I/AHCtaG3eKwhKp0LRungC4fcA==
X-Google-Smtp-Source: AKy350aQLs905KV0qaGWn1zT3HvTU5RjQac6JDE5JGewTkADkopUpU09eZINdngvuVlhgNv0Ab6QsXNSVqWwZSWwOaQ=
X-Received: by 2002:ac2:43a5:0:b0:4e8:4b7a:6b73 with SMTP id
 t5-20020ac243a5000000b004e84b7a6b73mr5155646lfl.4.1680079182610; Wed, 29 Mar
 2023 01:39:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230217194423.42553-1-athierry@redhat.com>
In-Reply-To: <20230217194423.42553-1-athierry@redhat.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Wed, 29 Mar 2023 16:39:30 +0800
Message-ID: <CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com>
Subject: Re: [PATCH v3] scsi: ufs: initialize devfreq synchronously
To:     Adrien Thierry <athierry@redhat.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, peter.wang@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Adrien,

On Sat, Feb 18, 2023 at 3:50=E2=80=AFAM Adrien Thierry <athierry@redhat.com=
> wrote:
>
> During ufs initialization, devfreq initialization is asynchronous:
> ufshcd_async_scan() calls ufshcd_add_lus(), which in turn initializes
> devfreq for ufs. The simple ondemand governor is then loaded. If it is
> built as a module, request_module() is called and throws a warning:
>
>   WARNING: CPU: 7 PID: 167 at kernel/kmod.c:136 __request_module+0x1e0/0x=
460
>   Modules linked in: crct10dif_ce llcc_qcom phy_qcom_qmp_usb ufs_qcom phy=
_qcom_snps_femto_v2 ufshcd_pltfrm phy_qcom_qmp_combo ufshcd_core phy_qcom_q=
mp_ufs qcom_wdt socinfo fuse ipv6
>   CPU: 7 PID: 167 Comm: kworker/u16:3 Not tainted 6.2.0-rc6-00009-g58706f=
7fb045 #1
>   Hardware name: Qualcomm SA8540P Ride (DT)
>   Workqueue: events_unbound async_run_entry_fn
>   pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
>   pc : __request_module+0x1e0/0x460
>   lr : __request_module+0x1d8/0x460
>   sp : ffff800009323b90
>   x29: ffff800009323b90 x28: 0000000000000000 x27: 0000000000000000
>   x26: ffff800009323d50 x25: ffff7b9045f57810 x24: ffff7b9045f57830
>   x23: ffffdc5a83e426e8 x22: ffffdc5ae80a9818 x21: 0000000000000001
>   x20: ffffdc5ae7502f98 x19: ffff7b9045f57800 x18: ffffffffffffffff
>   x17: 312f716572667665 x16: 642f7366752e3030 x15: 0000000000000000
>   x14: 000000000000021c x13: 0000000000005400 x12: ffff7b9042ed7614
>   x11: ffff7b9042ed7600 x10: 00000000636c0890 x9 : 0000000000000038
>   x8 : ffff7b9045f2c880 x7 : ffff7b9045f57c68 x6 : 0000000000000080
>   x5 : 0000000000000000 x4 : 8000000000000000 x3 : 0000000000000000
>   x2 : 0000000000000000 x1 : ffffdc5ae5d382f0 x0 : 0000000000000001
>   Call trace:
>    __request_module+0x1e0/0x460
>    try_then_request_governor+0x7c/0x100
>    devfreq_add_device+0x4b0/0x5fc
>    ufshcd_async_scan+0x1d4/0x310 [ufshcd_core]
>    async_run_entry_fn+0x34/0xe0
>    process_one_work+0x1d0/0x320
>    worker_thread+0x14c/0x444
>    kthread+0x10c/0x110
>    ret_from_fork+0x10/0x20
>
> This occurs because synchronous module loading from async is not
> allowed. According to __request_module():
>
>   /*
>    * We don't allow synchronous module loading from async.  Module
>    * init may invoke async_synchronize_full() which will end up
>    * waiting for this task which already is waiting for the module
>    * loading to complete, leading to a deadlock.
>    */
>
> I experienced such a deadlock on the Qualcomm QDrive3/sa8540p-ride. With
> DEVFREQ_GOV_SIMPLE_ONDEMAND=3Dm, the boot hangs after the warning.
>
> This patch fixes both the warning and the deadlock, by moving devfreq
> initialization out of the async routine.
>
> I tested this on the sa8540p-ride by using fio to put the UFS under
> load, and printing the trace generated by
> /sys/kernel/tracing/events/ufs/ufshcd_clk_scaling events. The trace
> looks similar with and without the change.
>
> Signed-off-by: Adrien Thierry <athierry@redhat.com>
> ---
> v3: Addressed Bart's comments
> v2: Addressed Bart's comments
>
>  drivers/ufs/core/ufshcd.c | 47 ++++++++++++++++++++++++++-------------
>  include/ufs/ufshcd.h      |  1 +
>  2 files changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 3a1c4d31e010..2c22a1367440 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1357,6 +1357,13 @@ static int ufshcd_devfreq_target(struct device *de=
v,
>         struct ufs_clk_info *clki;
>         unsigned long irq_flags;
>
> +       /*
> +        * Skip devfreq if ufs initialization is not finished.
> +        * Otherwise ufs could be in a inconsistent state.
> +        */
> +       if (!smp_load_acquire(&hba->logical_unit_scan_finished))
> +               return 0;
> +
>         if (!ufshcd_is_clkscaling_supported(hba))
>                 return -EINVAL;
>
> @@ -8136,22 +8143,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>         if (ret)
>                 goto out;
>
> -       /* Initialize devfreq after UFS device is detected */
> -       if (ufshcd_is_clkscaling_supported(hba)) {
> -               memcpy(&hba->clk_scaling.saved_pwr_info.info,
> -                       &hba->pwr_info,
> -                       sizeof(struct ufs_pa_layer_attr));
> -               hba->clk_scaling.saved_pwr_info.is_valid =3D true;
> -               hba->clk_scaling.is_allowed =3D true;
> -
> -               ret =3D ufshcd_devfreq_init(hba);
> -               if (ret)
> -                       goto out;
> -
> -               hba->clk_scaling.is_enabled =3D true;
> -               ufshcd_init_clk_scaling_sysfs(hba);
> -       }
> -
>         ufs_bsg_probe(hba);
>         ufshpb_init(hba);
>         scsi_scan_host(hba->host);
> @@ -8290,6 +8281,12 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
>         if (ret) {
>                 pm_runtime_put_sync(hba->dev);
>                 ufshcd_hba_exit(hba);
> +       } else {
> +               /*
> +                * Make sure that when reader code sees ufs initializatio=
n has finished,
> +                * all initialization steps have really been executed.
> +                */
> +               smp_store_release(&hba->logical_unit_scan_finished, true)=
;
>         }
>  }
>
> @@ -9896,12 +9893,30 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
>          */
>         ufshcd_set_ufs_dev_active(hba);
>
> +       /* Initialize devfreq */
> +       if (ufshcd_is_clkscaling_supported(hba)) {
> +               memcpy(&hba->clk_scaling.saved_pwr_info.info,
> +                       &hba->pwr_info,
> +                       sizeof(struct ufs_pa_layer_attr));

Here, hba->pwr_info is not initialized yet, so
hba->clk_scaling.saved_pwr_info will also have uninitialized values.
This is logically incorrect.

First of all, hba->saved_pwr_info is originally designed to keep the
"scaled-up" gear. This statement breaks it.

In addition, the incorrect hba->save_pwr_info may cause serious issues
in ufshcd_scale_gear(), as power mode changes will fail due to
incorrect "new_pwr_info".

Could you please revert this patch first and then upload a fixed one?

Thanks.
Stanley

Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB87C2D0CF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 10:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBBAF206B7
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 10:51:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OXORYFS6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfLXKvM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 05:51:12 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39265 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLXKvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 05:51:12 -0500
Received: by mail-ot1-f65.google.com with SMTP id 77so25909015oty.6
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 02:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J88KQkLJwp6npGyj7JR/Bh7HFbLug48Gcj2j4OlHtOA=;
        b=OXORYFS6uZcL0bCc/pMQ8CGTEmiCGI39XhriAhGKfKke+XjJd8imr/5C5E/3Swc1Sd
         V9kiWhbZT7d2p/M9x2yNzVJ/WFEA769KJoPgz1ap8y/lpsOv3fq2WLV43FQT2mfxjqLy
         Py4YhfM4JiXaG7ACmu8T9QQ1CEeMPgSPlUpVs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J88KQkLJwp6npGyj7JR/Bh7HFbLug48Gcj2j4OlHtOA=;
        b=n1Z7jEDFvqCpgIDYpL0GdiL7pjPKSzcTb+0+13qKU7daZY6S84KdW68/dbWQsSPLVG
         99kEBmWJA4ZEPkgkzAri3fVJVlmDAhKch9MHob7jn8m/nOlahuqBp/w6ywmNh51knwPy
         sLLGRMKS7KFWBmjryKwvg2RzW/oCtp9iyPriWP2WBiYIKwVdw7nbeMWIYRfahnHgZvec
         58SuF5YutVMa2nixhOKDLqZ2ZVBgd3Ta+gKKELxhxzXbVerankysKRuilJ2W+2gkxbgE
         NlEEkPGrKJbunmmuIWirdFsG40vx6+N7wZFAzKXe6rVfoix7ICGdw7nKOLQE0pst8i7I
         6tDQ==
X-Gm-Message-State: APjAAAUgaAYpiDADZ8jBbCNUEfdlsQU1rWKXLdWn4qFQBEMGoaiDztSg
        pMYmTLDD5hyWpl5EysaGeKVHmKZTrIVdLt2dHoVVJg==
X-Google-Smtp-Source: APXvYqzy5QHdU4NZBl5kt/lwjfi12koDt+YXYAzey6IU4S+8i0zwlrSPsJDqtu//gNtXDuwWrHC8TcSzjV2GNHU6AKQ=
X-Received: by 2002:a05:6830:1385:: with SMTP id d5mr6778761otq.61.1577184670540;
 Tue, 24 Dec 2019 02:51:10 -0800 (PST)
MIME-Version: 1.0
References: <20191220103210.43631-1-suganath-prabu.subramani@broadcom.com>
 <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com> <20191224054340.GA55348@ubuntu-m2-xlarge-x86>
In-Reply-To: <20191224054340.GA55348@ubuntu-m2-xlarge-x86>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Tue, 24 Dec 2019 16:20:58 +0530
Message-ID: <CAK=zhgpc6XzQ8=yeQc5-E0Ue4vnRsZgdyusUJhtMu7rDmv=CMA@mail.gmail.com>
Subject: Re: [PATCH 02/10] mpt3sas: Add support for NVMe shutdown.
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 11:13 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Fri, Dec 20, 2019 at 05:32:02AM -0500, Suganath Prabu S wrote:
> <snip>
>
> Hi Suganath,
>
> We received an email from the 0day bot about this patch (see below)
> about this patch. Would you look into addressing it?

Thanks Nathan, we will fix this and will send the patch with fix ASAP.

Regards,
Sreekanth

>
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > index a038be8..c451e57 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -1049,6 +1049,34 @@ mpt3sas_get_pdev_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle)
> >       return pcie_device;
> >  }
> >
> > +/**
> > + * _scsih_set_nvme_max_shutdown_latency - Update max_shutdown_latency.
> > + * @ioc: per adapter object
> > + * Context: This function will acquire ioc->pcie_device_lock
> > + *
> > + * Update ioc->max_shutdown_latency to that NVMe drives RTD3 Entry Latency
> > + * which has reported maximum among all available NVMe drives.
> > + * Minimum max_shutdown_latency will be six seconds.
> > + */
> > +static void
> > +_scsih_set_nvme_max_shutdown_latency(struct MPT3SAS_ADAPTER *ioc)
> > +{
> > +     struct _pcie_device *pcie_device;
> > +     unsigned long flags;
> > +     u16 shutdown_latency = IO_UNIT_CONTROL_SHUTDOWN_TIMEOUT;
> > +
> > +     spin_lock_irqsave(&ioc->pcie_device_lock, flags);
> > +     list_for_each_entry(pcie_device, &ioc->pcie_device_list, list) {
> > +             if (pcie_device->shutdown_latency) {
> > +                     if (shutdown_latency < pcie_device->shutdown_latency)
> > +                             shutdown_latency =
> > +                                     pcie_device->shutdown_latency;
> > +             }
> > +     }
> > +     ioc->max_shutdown_latency = shutdown_latency;
> > +     spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
> > +}
> > +
> >  /**
> >   * _scsih_pcie_device_remove - remove pcie_device from list.
> >   * @ioc: per adapter object
> > @@ -1063,6 +1091,7 @@ _scsih_pcie_device_remove(struct MPT3SAS_ADAPTER *ioc,
> >  {
> >       unsigned long flags;
> >       int was_on_pcie_device_list = 0;
> > +     u8 update_latency;
>
> This should be initialized to 0 like the remove_by_handle function
> below.
>
> Cheers,
> Nathan
>
> On Tue, Dec 24, 2019 at 05:13:52AM +0800, kbuild test robot wrote:
> > CC: kbuild-all@lists.01.org
> > In-Reply-To: <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com>
> > References: <20191220103210.43631-3-suganath-prabu.subramani@broadcom.com>
> > TO: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> > CC: linux-scsi@vger.kernel.org, martin.petersen@oracle.com
> > CC: sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com, kashyap.desai@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> >
> > Hi Suganath,
> >
> > I love your patch! Perhaps something to improve:
> >
> > [auto build test WARNING on scsi/for-next]
> > [also build test WARNING on mkp-scsi/for-next v5.5-rc3 next-20191220]
> > [if your patch is applied to the wrong git tree, please drop us a note to help
> > improve the system. BTW, we also suggest to use '--base' option to specify the
> > base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> >
> > url:    https://github.com/0day-ci/linux/commits/Suganath-Prabu-S/mpt3sas-Enhancements-of-phase14/20191223-182859
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> > config: arm64-defconfig (attached as .config)
> > compiler: clang version 10.0.0 (git://gitmirror/llvm_project 891e25b02d760d0de18c7d46947913b3166047e7)
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # save the attached .config to linux build tree
> >         make.cross ARCH=arm64
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> drivers/scsi/mpt3sas/mpt3sas_scsih.c:1114:6: warning: variable 'update_latency' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
> >            if (pcie_device->shutdown_latency == ioc->max_shutdown_latency)
> >                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    drivers/scsi/mpt3sas/mpt3sas_scsih.c:1128:6: note: uninitialized use occurs here
> >            if (update_latency)
> >                ^~~~~~~~~~~~~~
> >    drivers/scsi/mpt3sas/mpt3sas_scsih.c:1114:2: note: remove the 'if' if its condition is always true
> >            if (pcie_device->shutdown_latency == ioc->max_shutdown_latency)
> >            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    drivers/scsi/mpt3sas/mpt3sas_scsih.c:1094:19: note: initialize the variable 'update_latency' to silence this warning
> >            u8 update_latency;
> >                             ^
> >                              = '\0'
> >    1 warning generated.

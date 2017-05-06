From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: Re: [PATCH] scsi: qedf: Avoid reading past end of buffer
Date: Sat, 6 May 2017 15:00:17 -0400 (EDT)
Message-ID: <alpine.OSX.2.00.1705061459240.688@n5127mncfb42q1.qlogic.org>
References: <20170505224255.GA21521@beast> <1494025263.2744.22.camel@sandisk.com> <CAGXu5jJicmBq36EBbyP_k0YKVOwoSA1FRs=ApRtOYFRV=d0avA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0074.outbound.protection.outlook.com ([104.47.36.74]:19677
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752505AbdEFTAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 6 May 2017 15:00:37 -0400
In-Reply-To: <CAGXu5jJicmBq36EBbyP_k0YKVOwoSA1FRs=ApRtOYFRV=d0avA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "QLogic-Storage-Upstream@cavium.com" <QLogic-Storage-Upstream@cavium.com>, "danielmicay@gmail.com" <danielmicay@gmail.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>


On Fri, 5 May 2017, 7:10pm, Kees Cook wrote:

> On Fri, May 5, 2017 at 4:01 PM, Bart Van Assche
> <Bart.VanAssche@sandisk.com> wrote:
> > On Fri, 2017-05-05 at 15:42 -0700, Kees Cook wrote:
> >> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> >> index cceddd995a4b..a5c97342fd5d 100644
> >> --- a/drivers/scsi/qedf/qedf_main.c
> >> +++ b/drivers/scsi/qedf/qedf_main.c
> >> @@ -2895,7 +2895,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
> >>       slowpath_params.drv_minor = QEDF_DRIVER_MINOR_VER;
> >>       slowpath_params.drv_rev = QEDF_DRIVER_REV_VER;
> >>       slowpath_params.drv_eng = QEDF_DRIVER_ENG_VER;
> >> -     memcpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
> >> +     strncpy(slowpath_params.name, "qedf", QED_DRV_VER_STR_SIZE);
> >>       rc = qed_ops->common->slowpath_start(qedf->cdev, &slowpath_params);
> >>       if (rc) {
> >>               QEDF_ERR(&(qedf->dbg_ctx), "Cannot start slowpath.\n");
> >
> > Hello Kees,
> >
> > Although this patch looks fine to me, isn't strlcpy() preferred over strncpy()?
> 
> strlcpy doesn't zero-pad, so I think strncpy is preferred here,
> otherwise we may risk leaving portions of the destination buffer
> filled with uninitialized data, maybe leaking kernel memory contents.
> 
> -Kees
> 

I'd agree with strncpy so we zero out the rest of the buffer.

Acked-by: Chad Dupuis <chad.dupuis@cavium.com> 

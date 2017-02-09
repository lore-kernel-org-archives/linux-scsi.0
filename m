From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Thu, 9 Feb 2017 10:39:51 +0530
Message-ID: <CAK=zhgoEep5afmFq05kn0bxhuykSQH_BJE3ZzJrhzr+Y3M23vw@mail.gmail.com>
References: <20161228110524.7516-1-ojab@ojab.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:32950 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdBIFJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 00:09:53 -0500
Received: by mail-qk0-f182.google.com with SMTP id s140so146189145qke.0
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2017 21:09:53 -0800 (PST)
In-Reply-To: <20161228110524.7516-1-ojab@ojab.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ojab <ojab@ojab.ru>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Dec 28, 2016 at 4:35 PM, ojab <ojab@ojab.ru> wrote:
> MPI2 controllers sometimes got lost (i. e. disappears from
> /sys/bus/pci/devices) if ASMP is enabled.
>
> Signed-off-by: Slava Kardakov <ojab@ojab.ru>
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=60644

>From some of our system engineers team, I came to known that ASPM
needs to be disabled.
So this patch looks good. Please consider this patch as

Acked-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Thanks,
Sreekanth

> ---
> V2: use name in Signed-off-by
>
> Not sure if it's a complete fix, but at least I can't reproduce the issue
> locally with it applied.
>
> Also it's my first patch, so I've surely screwed up some formatting etc.
>
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b5c966e..203651a 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -51,6 +51,7 @@
>  #include <linux/workqueue.h>
>  #include <linux/delay.h>
>  #include <linux/pci.h>
> +#include <linux/pci-aspm.h>
>  #include <linux/interrupt.h>
>  #include <linux/aer.h>
>  #include <linux/raid_class.h>
> @@ -8734,6 +8735,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>
>         switch (hba_mpi_version) {
>         case MPI2_VERSION:
> +               pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
> +                       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
>                 /* Use mpt2sas driver host template for SAS 2.0 HBA's */
>                 shost = scsi_host_alloc(&mpt2sas_driver_template,
>                   sizeof(struct MPT3SAS_ADAPTER));
> --
> 2.10.0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

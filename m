From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: enable intx only if msix request fails
Date: Wed, 8 Mar 2017 21:13:22 +0530
Message-ID: <0e9730931dd328f944a859db25da5309@mail.gmail.com>
References: <1488452056-16083-1-git-send-email-kashyap.desai@broadcom.com> <20170308150927.GA27450@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33796 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdCHPn4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 10:43:56 -0500
Received: by mail-qk0-f178.google.com with SMTP id p64so72080363qke.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2017 07:43:25 -0800 (PST)
In-Reply-To: <20170308150927.GA27450@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, hare@suse.de

> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index 7ac9a9e..82a8ec8 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -4990,6 +4990,7 @@ int megasas_set_crash_dump_params(struct
> megasas_instance *instance,
> >  	struct pci_dev *pdev;
> >
> >  	pdev = instance->pdev;
> > +	pci_intx(pdev, 1);
>
> Please use pci_alloc_irq_vectors with the PCI_IRQ_LEGACY flag here, I'd
like to
> phase out the pci_intx API.

I will resubmit v2 patch using pci_alloc_irq_vectors.

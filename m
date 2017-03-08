From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: enable intx only if msix request fails
Date: Wed, 8 Mar 2017 19:52:59 +0530
Message-ID: <4c6a52161122397dc46823ef1d44b1bb@mail.gmail.com>
References: <1488452056-16083-1-git-send-email-kashyap.desai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:33949 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbdCHOXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 09:23:02 -0500
Received: by mail-qk0-f181.google.com with SMTP id p64so68081157qke.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Mar 2017 06:23:01 -0800 (PST)
In-Reply-To: <1488452056-16083-1-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, hare@suse.de

Any feedback ? We have few more patches to be submitted, so looking for
review of this pending patch.

Thanks, Kashyap

> -----Original Message-----
> From: Kashyap Desai [mailto:kashyap.desai@broadcom.com]
> Sent: Thursday, March 02, 2017 4:24 PM
> To: linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; hare@suse.de; Kashyap Desai
> Subject: [PATCH] megaraid_sas: enable intx only if msix request fails
>
> Without this fix, driver will enable INTx Interrupt pin even  though
MSI-x
> vectors are enabled. See below lspci output. DisINTx is unset  for MSIx
setup.
>
> lspci -s 85:00.0 -vvv |grep INT |grep Control
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>
> After applying this fix, driver will enable INTx Interrupt pin only if
Legacy
> interrupt method is required.
> See below lspci output. DisINTx is unset for MSIx setup.
> lspci -s 85:00.0 -vvv |grep INT |grep Control
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx+
>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 7ac9a9e..82a8ec8 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4990,6 +4990,7 @@ int megasas_set_crash_dump_params(struct
> megasas_instance *instance,
>  	struct pci_dev *pdev;
>
>  	pdev = instance->pdev;
> +	pci_intx(pdev, 1);
>  	instance->irq_context[0].instance = instance;
>  	instance->irq_context[0].MSIxIndex = 0;
>  	if (request_irq(pci_irq_vector(pdev, 0), @@ -5277,10 +5278,6 @@
> static int megasas_init_fw(struct megasas_instance *instance)
>  			MPI2_REPLY_POST_HOST_INDEX_OFFSET);
>  	}
>
> -	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
> -	if (i < 0)
> -		goto fail_setup_irqs;
> -
>  	dev_info(&instance->pdev->dev,
>  		"firmware supports msix\t: (%d)", fw_msix_count);
>  	dev_info(&instance->pdev->dev,
> @@ -5494,7 +5491,6 @@ static int megasas_init_fw(struct
> megasas_instance *instance)
>  	instance->instancet->disable_intr(instance);
>  fail_init_adapter:
>  	megasas_destroy_irqs(instance);
> -fail_setup_irqs:
>  	if (instance->msix_vectors)
>  		pci_free_irq_vectors(instance->pdev);
>  	instance->msix_vectors = 0;
> --
> 1.8.3.1

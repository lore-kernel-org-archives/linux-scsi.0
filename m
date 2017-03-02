From: =?UTF-8?Q?Lo=c3=afc_Yhuel?= <loic.yhuel@gmail.com>
Subject: Re: [regression] vmw_pvscsi probe fails on 4.11
Date: Thu, 2 Mar 2017 20:39:30 +0100
Message-ID: <94cdc24f-999a-9a16-c6a8-84ab1a82f74b@gmail.com>
References: <cd383513-7fc2-5cec-9471-808e97bef27a@gmail.com>
 <20170302160553.GA4353@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33812 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751849AbdCBTs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 14:48:28 -0500
Received: by mail-wr0-f193.google.com with SMTP id u48so10857070wrc.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Mar 2017 11:48:27 -0800 (PST)
In-Reply-To: <20170302160553.GA4353@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jim Gill <jgill@vmware.com>, linux-scsi@vger.kernel.org

Le 02/03/2017 à 17:05, Christoph Hellwig a écrit :
> Please try this patch:
>
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index ef474a748744..c374e3b5c678 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -1487,7 +1487,7 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   		irq_flag &= ~PCI_IRQ_MSI;
>   
>   	error = pci_alloc_irq_vectors(adapter->dev, 1, 1, irq_flag);
> -	if (error)
> +	if (error < 0)
>   		goto out_reset_adapter;
>   
>   	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
It works, thanks.

Btw, vmw_vmci has the same issue.

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c 
b/drivers/misc/vmw_vmci/vmci_guest.c
index 9d659542a335..dad5abee656e 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -566,10 +566,10 @@ static int vmci_guest_probe_device(struct pci_dev 
*pdev,
          */
         error = pci_alloc_irq_vectors(pdev, VMCI_MAX_INTRS, VMCI_MAX_INTRS,
                         PCI_IRQ_MSIX);
-       if (error) {
+       if (error < 0) {
                 error = pci_alloc_irq_vectors(pdev, 1, 1,
                                 PCI_IRQ_MSIX | PCI_IRQ_MSI | 
PCI_IRQ_LEGACY);
-               if (error)
+               if (error < 0)
                         goto err_remove_bitmap;
         } else {
                 vmci_dev->exclusive_vectors = true;

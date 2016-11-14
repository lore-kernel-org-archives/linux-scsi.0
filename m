From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] megaraid_sas: switch to pci_alloc_irq_vectors
Date: Mon, 14 Nov 2016 13:48:55 +0100
Message-ID: <20161114124855.GC14653@lst.de>
References: <1478857492-4581-1-git-send-email-hare@suse.de> <1478857492-4581-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48968 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932172AbcKNMs6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Nov 2016 07:48:58 -0500
Content-Disposition: inline
In-Reply-To: <1478857492-4581-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>  	if (instance->msix_vectors)
>  		for (i = 0; i < instance->msix_vectors; i++) {
> +			free_irq(pci_irq_vector(instance->pdev, i),
>  				 &instance->irq_context[i]);
>  		}
>  	else
> +		free_irq(pci_irq_vector(instance->pdev, 0),
> +			 &instance->irq_context[0]);
>  }

Don't forget to replace the call to pci_disable_msix with one to pci_free_irq_vectors.

>  
>  /**
> @@ -5018,6 +5004,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  	int i, loop, fw_msix_count = 0;
>  	struct IOV_111 *iovPtr;
>  	struct fusion_context *fusion;
> +	int irq_flags = PCI_IRQ_MSIX;
>  
>  	fusion = instance->ctrl_context;
>  
> @@ -5134,15 +5121,18 @@ static int megasas_init_fw(struct megasas_instance *instance)
>  		/* Don't bother allocating more MSI-X vectors than cpus */
>  		instance->msix_vectors = min(instance->msix_vectors,
>  					     (unsigned int)num_online_cpus());
> -		for (i = 0; i < instance->msix_vectors; i++)
> -			instance->msixentry[i].entry = i;
> -		i = pci_enable_msix_range(instance->pdev, instance->msixentry,
> -					  1, instance->msix_vectors);
> +		if (smp_affinity_enable)
> +			irq_flags |= PCI_IRQ_AFFINITY;
> +		i = pci_alloc_irq_vectors(instance->pdev, 1,
> +					  instance->msix_vectors, irq_flags);
>  		if (i > 0)
>  			instance->msix_vectors = i;
>  		else
>  			instance->msix_vectors = 0;
>  	}
> +	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
> +	if (i < 0)
> +		goto fail_setup_irqs;

This looks wrong - you have to call to pci_alloc_irq_vectors right next
to each other here, so for the MSI-X case you'll still end up calling
the second one as well, which will then fail.  I think the better way
to structure the driver would be to do the following here.

 - Rename the msix_vectors field to irq_vectors, and make sure it's
   initialized to 1 for non-MSI-X capable adapters.
 - Have a single call to pci_alloc_irq_vectors here.
 - Have all the request_irq/free_irq code iterate over ->irq_vectors
   instead of duplicating it
 - use pdev->msix_enabled for the few cases that need to check for
   MSI-X mode specificly.

>  	/* Now re-enable MSI-X */
> -	if (instance->msix_vectors &&
> -	    pci_enable_msix_exact(instance->pdev, instance->msixentry,
> -				  instance->msix_vectors))
> +	if (instance->msix_vectors)
> +		irq_flags = PCI_IRQ_MSIX;
> +	if (smp_affinity_enable)
> +		irq_flags |= PCI_IRQ_AFFINITY;
> +	rval = pci_alloc_irq_vectors(instance->pdev, 1,
> +				     instance->msix_vectors ?
> +				     instance->msix_vectors : 1, irq_flags);
> +	if (rval < 0)

The old code is doing a pci_enable_msix_exact so you also need to pass
the number of vectors as the first argument here.

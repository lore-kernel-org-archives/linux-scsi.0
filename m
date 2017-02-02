From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH] PCI/MSI: don't apply affinity if there aren't enough
 vectors left
Date: Thu, 2 Feb 2017 11:36:59 -0600
Message-ID: <20170202173659.GD21267@bhelgaas-glaptop.roam.corp.google.com>
References: <1485778541-28994-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbdBBRhJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Feb 2017 12:37:09 -0500
Content-Disposition: inline
In-Reply-To: <1485778541-28994-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: bhelgaas@google.com, bart.vanassche@sandisk.com, tglx@linutronix.de, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 30, 2017 at 01:15:41PM +0100, Christoph Hellwig wrote:
> Bart reported a problem wіth an out of bounds access in the low-level
> IRQ affinity code, which we root caused to the qla2xxx driver assigning
> all it's MSI-X vectors to the pre and post vectors, and not having any
> left for the actually spread IRQs.

s/it's/its/

> This fixes this issue by not asking for affinity assignment when there
> are not vectors to assign left.

s/not/no/

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Fixes: 402723ad ("PCI/MSI: Provide pci_alloc_irq_vectors_affinity()")
> Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Tested-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/pci/msi.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 50c5003..7f73bac 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -1206,6 +1206,16 @@ int pci_alloc_irq_vectors_affinity(struct pci_dev *dev, unsigned int min_vecs,
>  	if (flags & PCI_IRQ_AFFINITY) {
>  		if (!affd)
>  			affd = &msi_default_affd;
> +
> +		if (affd->pre_vectors + affd->post_vectors > min_vecs)
> +			return -EINVAL;
> +
> +		/*
> +		 * If there aren't any vectors left after applying the pre/post
> +		 * vectors don't bother with assigning affinity.
> +		 */
> +		if (affd->pre_vectors + affd->post_vectors == min_vecs)
> +			affd = NULL;
>  	} else {
>  		if (WARN_ON(affd))
>  			affd = NULL;

You didn't say exactly where the out of bounds access was, but I assume
it's probably in irq_create_affinity_masks() in this path:

  pci_alloc_irq_vectors_affinity(..., affd)
    __pci_enable_msix_range(..., minvec, maxvec, affd)
      # decide on nvec
      irq_calc_affinity_vectors(nvec, affd)
      __pci_enable_msix(..., nvec, affd)
        msix_capability_init(..., nvec, affd)
          msix_setup_entries(..., nvec, affd)
            irq_create_affinity_masks(nvec, affd)
              affv = nvecs - affd->pre_vectors - affd->post_vectors

              masks = kcalloc(nvecs, ...)
              for (curvec = 0; curvec < affd->pre_vectors; ...)
                cpumask_copy(masks + curvec, irq_default_affinity)

The fix in pci_alloc_irq_vectors_affinity() looks fine, but I wish it
were closer to the actual problem.

I think irq_create_affinity_masks() should be a little more careful
with the assumptions it makes about the relationships between nvecs,
affd->pre_vectors, and affd->post_vectors.

For example, it allocates with size "nvec" and iterates with a limit
of "affd->pre_vectors", which assumes "affd->pre_vectors < nvec".  And
of course, "affv" may end up being negative, which can't be good.

If we made irq_create_affinity_masks() more robust, I don't think
you'd need to set affd to NULL in pci_alloc_irq_vectors_affinity().
But maybe you would still want at least the -EINVAL change so the
caller gets an indication that it is doing something wrong?

Bjorn

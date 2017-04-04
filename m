From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] aacraid: pci_alloc_consistent() failures on ARM64
Date: Mon, 3 Apr 2017 23:56:27 -0700
Message-ID: <20170404065627.GA4614@infradead.org>
References: <1491288799-18659-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56063 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdDDG42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 02:56:28 -0400
Content-Disposition: inline
In-Reply-To: <1491288799-18659-1-git-send-email-mahesh.rajashekhara@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>

On Tue, Apr 04, 2017 at 12:23:19PM +0530, Mahesh Rajashekhara wrote:
> +#if defined(CONFIG_ARM64)
> +static inline void *
> +aac_pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
> +		     dma_addr_t *dma_handle) {
> +	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
> +				  size,
> +				  dma_handle,
> +				  GFP_KERNEL);
> +}
> +#else
> +static inline void *
> +aac_pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
> +		     dma_addr_t *dma_handle) {
> +	return pci_alloc_consistent(hwdev, size, dma_handle);
> +}
> +#endif

Please just call the dma_*_coherent routines directly all the time.
hwdev should never be NULL, so that workaround can be dropped as well.

And while you're at it please remove all the casts to and from
void * in the arguments and return values.

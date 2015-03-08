From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 16/41] hpsa: break hpsa_free_irqs_and_disable_msix
 into two functions
Date: Sun, 8 Mar 2015 08:42:13 -0700
Message-ID: <20150308154213.GD17534@infradead.org>
References: <20150306233504.29973.41322.stgit@brunhilda>
 <20150306234712.29973.63719.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35155 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbbCHPmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2015 11:42:13 -0400
Content-Disposition: inline
In-Reply-To: <20150306234712.29973.63719.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

On Fri, Mar 06, 2015 at 05:47:12PM -0600, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
> 
> replace calls to hpsa_free_irqs_and_disable_msix with
> hpsa_free_irqs and hpsa_disable_interrupt_mode
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |   37 ++++++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 229366b..177a38f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6405,10 +6405,22 @@ static int find_PCI_BAR_index(struct pci_dev *pdev, unsigned long pci_bar_addr)
>  	return -1;
>  }
>  
> +static void hpsa_disable_interrupt_mode(struct ctlr_info *h)
> +{
> +#ifdef CONFIG_PCI_MSI
> +	if (h->msix_vector) {
> +		if (h->pdev->msix_enabled)
> +			pci_disable_msix(h->pdev);
> +	} else if (h->msi_vector) {
> +		if (h->pdev->msi_enabled)
> +			pci_disable_msi(h->pdev);
> +	}
> +#endif /* CONFIG_PCI_MSI */
> +}

No need for the ifdef, both pci_disable_msix and pci_disable_msi
are provided as empty stubs for the !CONFIG_PCI_MSI case.


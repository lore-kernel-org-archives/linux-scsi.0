From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact() instead
 of pci_enable_msix()
Date: Mon, 11 Aug 2014 09:39:02 +0200
Message-ID: <20140811073902.GB16504@dhcp-27-160.brq.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <bc13ddf17d035921de994d2f8a52902e0a5d1a60.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bc13ddf17d035921de994d2f8a52902e0a5d1a60.1405533479.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:08PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Anil, Sudarsana,

Could you please review bfa patches in this series?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Anil Gurumurthy <agurumur@brocade.com>
> Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> ---
>  drivers/scsi/bfa/bfad.c |   20 ++++++--------------
>  1 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
> index c18279f..e90a374 100644
> --- a/drivers/scsi/bfa/bfad.c
> +++ b/drivers/scsi/bfa/bfad.c
> @@ -1234,29 +1234,21 @@ bfad_setup_intr(struct bfad_s *bfad)
>  	if ((bfa_asic_id_ctc(pdev->device) && !msix_disable_ct) ||
>  	   (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {
>  
> -		error = pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
> +		error = pci_enable_msix_exact(bfad->pcidev,
> +					      msix_entries, bfad->nvec);
>  		/* In CT1 & CT2, try to allocate just one vector */
> -		if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
> +		if (error == -ENOSPC && bfa_asic_id_ctc(pdev->device)) {
>  			printk(KERN_WARNING "bfa %s: trying one msix "
>  			       "vector failed to allocate %d[%d]\n",
>  			       bfad->pci_name, bfad->nvec, error);
>  			bfad->nvec = 1;
> -			error = pci_enable_msix(bfad->pcidev,
> -						msix_entries, bfad->nvec);
> +			error = pci_enable_msix_exact(bfad->pcidev,
> +						      msix_entries, 1);
>  		}
>  
> -		/*
> -		 * Only error number of vector is available.
> -		 * We don't have a mechanism to map multiple
> -		 * interrupts into one vector, so even if we
> -		 * can try to request less vectors, we don't
> -		 * know how to associate interrupt events to
> -		 *  vectors. Linux doesn't duplicate vectors
> -		 * in the MSIX table for this case.
> -		 */
>  		if (error) {
>  			printk(KERN_WARNING "bfad%d: "
> -			       "pci_enable_msix failed (%d), "
> +			       "pci_enable_msix_exact failed (%d), "
>  			       "use line based.\n",
>  				bfad->inst_no, error);
>  			goto line_based;
> -- 
> 1.7.7.6
> 

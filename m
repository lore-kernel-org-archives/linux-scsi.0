From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] isci: switch to pci_alloc_irq_vectors
Date: Wed, 30 Nov 2016 16:04:03 +0100
Message-ID: <1d0e24b6-8f11-7b12-dfac-aa828a6995de@intel.com>
References: <1479449432-7375-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35915 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933615AbcK3PFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 10:05:54 -0500
In-Reply-To: <1479449432-7375-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: intel-linux-scu@intel.com, linux-scsi@vger.kernel.org

On 11/18/2016 07:10 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/isci/host.h |  1 -
>  drivers/scsi/isci/init.c | 21 +++++++++------------
>  2 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
> index 22a9bb1..b353992 100644
> --- a/drivers/scsi/isci/host.h
> +++ b/drivers/scsi/isci/host.h
> @@ -295,7 +295,6 @@ enum sci_controller_states {
>  #define SCI_MAX_MSIX_INT (SCI_NUM_MSI_X_INT*SCI_MAX_CONTROLLERS)
>  
>  struct isci_pci_info {
> -	struct msix_entry msix_entries[SCI_MAX_MSIX_INT];
>  	struct isci_host *hosts[SCI_MAX_CONTROLLERS];
>  	struct isci_orom *orom;
>  };
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index 77128d68..7cddebb 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -350,16 +350,12 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
>  	 */
>  	num_msix = num_controllers(pdev) * SCI_NUM_MSI_X_INT;
>  
> -	for (i = 0; i < num_msix; i++)
> -		pci_info->msix_entries[i].entry = i;
> -
> -	err = pci_enable_msix_exact(pdev, pci_info->msix_entries, num_msix);
> +	err = pci_alloc_irq_vectors(pdev, num_msix, num_msix, PCI_IRQ_MSIX);
>  	if (err)
>  		goto intx;

pci_enable_msix_exact() returns 0 or -ERROR but pci_alloc_irq_vectors()
returns the number of vectors allocated if successful, so this also
should be changed:

-	if (err)
+	if (err < 0)
		goto intx;

The rest looks good to me.

Thanks,
Artur

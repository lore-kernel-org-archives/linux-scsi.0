From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH v2 RESEND 09/23] hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Fri, 15 Aug 2014 10:48:03 -0500
Message-ID: <20140815154803.GY19666@beardog.cce.hp.com>
References: <cover.1405533479.git.agordeev@redhat.com> <fa8dc16252a7afa6186b78af4b90590755f45507.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:20011 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHOPs4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2014 11:48:56 -0400
Content-Disposition: inline
In-Reply-To: <fa8dc16252a7afa6186b78af4b90590755f45507.1405533479.git.agordeev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, scameron@beardog.cce.hp.com

On Wed, Jul 16, 2014 at 08:05:13PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
> Cc: iss_storagedev@hp.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/scsi/hpsa.c |   27 ++++++++++++---------------
>  1 files changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 648dec2..5c4ab6e 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -6160,25 +6160,22 @@ static void hpsa_interrupt_mode(struct ctlr_info *h)
>  		h->msix_vector = MAX_REPLY_QUEUES;
>  		if (h->msix_vector > num_online_cpus())
>  			h->msix_vector = num_online_cpus();
> -		err = pci_enable_msix(h->pdev, hpsa_msix_entries,
> -				      h->msix_vector);
> -		if (err > 0) {
> +		err = pci_enable_msix_range(h->pdev, hpsa_msix_entries,
> +					    1, h->msix_vector);
> +		if (err < 0) {
> +			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n", err);
> +			h->msix_vector = 0;
> +			goto single_msi_mode;
> +		} else if (err < h->msix_vector) {
>  			dev_warn(&h->pdev->dev, "only %d MSI-X vectors "
>  			       "available\n", err);
> -			h->msix_vector = err;
> -			err = pci_enable_msix(h->pdev, hpsa_msix_entries,
> -					      h->msix_vector);
> -		}
> -		if (!err) {
> -			for (i = 0; i < h->msix_vector; i++)
> -				h->intr[i] = hpsa_msix_entries[i].vector;
> -			return;
> -		} else {
> -			dev_warn(&h->pdev->dev, "MSI-X init failed %d\n",
> -			       err);
> -			h->msix_vector = 0;
>  		}
> +		h->msix_vector = err;
> +		for (i = 0; i < h->msix_vector; i++)
> +			h->intr[i] = hpsa_msix_entries[i].vector;
> +		return;
>  	}
> +single_msi_mode:
>  	if (pci_find_capability(h->pdev, PCI_CAP_ID_MSI)) {
>  		dev_info(&h->pdev->dev, "MSI\n");
>  		if (!pci_enable_msi(h->pdev))
> -- 
> 1.7.7.6

Ack. 

I had previously acked an older, but seemingly semantically identical patch.
Was requested to ack this one as well.

-- steve


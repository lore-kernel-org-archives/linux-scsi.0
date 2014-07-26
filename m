From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 07/23] fnic: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Sat, 26 Jul 2014 09:15:02 +0100
Message-ID: <20140726081502.GD21129@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <e8cc7988e4b0a38f59d3e854d387c7c0d95b058c.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e8cc7988e4b0a38f59d3e854d387c7c0d95b058c.1405533479.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 16, 2014 at 08:05:11PM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hi Hiral, Suma, Brian,

Could you please review this patch?

Thanks!

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Hiral Patel <hiralpat@cisco.com>
> Cc: Suma Ramars <sramars@cisco.com>
> Cc: Brian Uchino <buchino@cisco.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/fnic/fnic_isr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
> index 7d9b54a..a0dd1b6 100644
> --- a/drivers/scsi/fnic/fnic_isr.c
> +++ b/drivers/scsi/fnic/fnic_isr.c
> @@ -257,8 +257,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
>  	    fnic->raw_wq_count >= m &&
>  	    fnic->wq_copy_count >= o &&
>  	    fnic->cq_count >= n + m + o) {
> -		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
> -				    n + m + o + 1)) {
> +		if (!pci_enable_msix_exact(fnic->pdev, fnic->msix_entry,
> +					   n + m + o + 1)) {
>  			fnic->rq_count = n;
>  			fnic->raw_wq_count = m;
>  			fnic->wq_copy_count = o;
> -- 
> 1.7.7.6
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

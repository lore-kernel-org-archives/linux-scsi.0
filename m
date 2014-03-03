From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH v2 10/23] isci: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Date: Mon, 3 Mar 2014 13:56:30 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A6F3E19@IRSMSX105.ger.corp.intel.com>
References: <cover.1393191330.git.agordeev@redhat.com>
 <b6c5934fa5e2f17f49a48a38f036bcd5149455c6.1393191330.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b6c5934fa5e2f17f49a48a38f036bcd5149455c6.1393191330.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, intel-linux-scu <intel-linux-scu@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Monday, February 24, 2014 9:02 AM Alexander Gordeev <agordeev@redhat.com> wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Lukasz Dorau <lukasz.dorau@intel.com>
> Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: intel-linux-scu@intel.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/isci/init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index d25d0d8..ce40538 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -356,7 +356,7 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
>  	for (i = 0; i < num_msix; i++)
>  		pci_info->msix_entries[i].entry = i;
> 
> -	err = pci_enable_msix(pdev, pci_info->msix_entries, num_msix);
> +	err = pci_enable_msix_exact(pdev, pci_info->msix_entries, num_msix);
>  	if (err)
>  		goto intx;
> 
> --
> 1.7.7.6

Looks fine.

Acked-by: Lukasz Dorau <lukasz.dorau@intel.com>

Thanks,
Lukasz

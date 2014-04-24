From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 RESEND 00/23] scsi: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Date: Thu, 24 Apr 2014 11:09:03 -0600
Message-ID: <20140424170903.GA29593@google.com>
References: <cover.1397461652.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1397461652.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, James Bottomley <jbottomley@parallels.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com, intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 14, 2014 at 10:05:24AM +0200, Alexander Gordeev wrote:
> Hello,
> 
> This series is against 3.15-rc1.
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hi James,

These depend on f7fc32c, which appeared in v3.15-rc1.  I had intended
to merge these scsi updates at the same time, but I failed.  Would you
like to take them now that f7fc32c is upstream?

If not, I'd still be glad to do it, but it might avoid some conflicts
if you took them.

Bjorn

> There are no major changes in this series since I posted
> it last time.
> 
> Thanks!
> 
> Cc: iss_storagedev@hp.com
> Cc: intel-linux-scu@intel.com
> Cc: support@lsi.com
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: qla2xxx-upstream@qlogic.com
> Cc: iscsi-driver@qlogic.com
> Cc: pv-drivers@vmware.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> 
> 
> Alexander Gordeev (23):
>   be2iscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   bfa: Do not call pci_enable_msix() after it failed once
>   bfa: Cleanup bfad_setup_intr() function
>   bfa: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   csiostor: Remove superfluous call to pci_disable_msix()
>   csiostor: Use pci_enable_msix_range() instead of pci_enable_msix()
>   fnic: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   isci: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   hpsa: Fallback to MSI rather than to INTx if MSI-X failed
>   hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
>   lpfc: Remove superfluous call to pci_disable_msix()
>   lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
>   megaraid: Fail resume if MSI-X re-initialization failed
>   megaraid: Use pci_enable_msix_range() instead of pci_enable_msix()
>   mpt2sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   mpt3sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   pm8001: Fix invalid return when request_irq() failed
>   pm8001: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   pmcraid: Get rid of a redundant assignment
>   pmcraid: Use pci_enable_msix_range() instead of pci_enable_msix()
>   qla2xxx: Use pci_enable_msix_range() instead of pci_enable_msix()
>   qla4xxx: Use pci_enable_msix_exact() instead of pci_enable_msix()
>   vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
> 
>  drivers/scsi/be2iscsi/be_main.c           |    6 +--
>  drivers/scsi/bfa/bfad.c                   |   62 ++++++++++++-----------------
>  drivers/scsi/csiostor/csio_hw.h           |    2 +-
>  drivers/scsi/csiostor/csio_isr.c          |   24 ++++-------
>  drivers/scsi/fnic/fnic_isr.c              |    4 +-
>  drivers/scsi/hpsa.c                       |   30 ++++++--------
>  drivers/scsi/isci/init.c                  |    2 +-
>  drivers/scsi/lpfc/lpfc_init.c             |   47 +++++++++++-----------
>  drivers/scsi/megaraid/megaraid_sas_base.c |   24 +++++------
>  drivers/scsi/mpt2sas/mpt2sas_base.c       |    6 +-
>  drivers/scsi/mpt3sas/mpt3sas_base.c       |    4 +-
>  drivers/scsi/pm8001/pm8001_init.c         |   44 +++++++++++----------
>  drivers/scsi/pmcraid.c                    |   14 +------
>  drivers/scsi/qla2xxx/qla_isr.c            |   27 +++++-------
>  drivers/scsi/qla4xxx/ql4_nx.c             |    2 +-
>  drivers/scsi/vmw_pvscsi.c                 |    2 +-
>  16 files changed, 129 insertions(+), 171 deletions(-)
> 
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

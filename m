From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 00/23] scsi: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:00 +0100
Message-ID: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, iss_storagedev@hp.com, intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello!

This series is against James Bottomley's SCSI tree [1], but it needs
commit f7fc32c ("PCI/MSI: Add pci_enable_msi_exact() and
pci_enable_msix_exact()") from from Bjorn Helgaas's PCI tree [2]:

1. git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
2. git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git pci/msi

Recently pci_enable_msix_exact() function has been accepted to
the mainline. That is a variation of pci_enable_msix_range() which
allows a device driver to request a particular number of MSI-Xs.

As result, most of the changes posted in version 1 of this series
are invalidated and need to use pci_enable_msix_exact() instead of
originally posted pci_enable_msix_range() usages.

I removed almost all ACKs, since unlike pci_enable_msix_range()
function which returns the number of MSI-Xs allocated or negative
errno, pci_enable_msix_exact() returns either zero success code or
a negative errno. Although this change is simple, it still entails
an updated error code analysis and would be better reviewed by
driver maintainers.

Thanks!

Cc: iss_storagedev@hp.com
Cc: intel-linux-scu@intel.com
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: qla2xxx-upstream@qlogic.com
Cc: iscsi-driver@qlogic.com
Cc: pv-drivers@vmware.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (23):
  be2iscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
  bfa: Do not call pci_enable_msix() after it failed once
  bfa: Cleanup bfad_setup_intr() function
  bfa: Use pci_enable_msix_exact() instead of pci_enable_msix()
  csiostor: Remove superfluous call to pci_disable_msix()
  csiostor: Use pci_enable_msix_range() instead of pci_enable_msix()
  fnic: Use pci_enable_msix_exact() instead of pci_enable_msix()
  hpsa: Fallback to MSI rather than to INTx if MSI-X failed
  hpsa: Use pci_enable_msix_exact() instead of pci_enable_msix()
  isci: Use pci_enable_msix_exact() instead of pci_enable_msix()
  lpfc: Remove superfluous call to pci_disable_msix()
  lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
  megaraid: Fail resume if MSI-X re-initialization failed
  megaraid: Use pci_enable_msix_range() instead of pci_enable_msix()
  mpt2sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
  mpt3sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
  pm8001: Fix invalid return when request_irq() failed
  pm8001: Use pci_enable_msix_exact() instead of pci_enable_msix()
  pmcraid: Get rid of a redundant assignment
  pmcraid: Use pci_enable_msix_range() instead of pci_enable_msix()
  qla2xxx: Use pci_enable_msix_range() instead of pci_enable_msix()
  qla4xxx: Use pci_enable_msix_exact() instead of pci_enable_msix()
  vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()

 drivers/scsi/be2iscsi/be_main.c           |    6 +--
 drivers/scsi/bfa/bfad.c                   |   62 ++++++++++++-----------------
 drivers/scsi/csiostor/csio_hw.h           |    2 +-
 drivers/scsi/csiostor/csio_isr.c          |   24 ++++-------
 drivers/scsi/fnic/fnic_isr.c              |    4 +-
 drivers/scsi/hpsa.c                       |   12 +-----
 drivers/scsi/isci/init.c                  |    2 +-
 drivers/scsi/lpfc/lpfc_init.c             |   54 ++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_base.c |   24 +++++------
 drivers/scsi/mpt2sas/mpt2sas_base.c       |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c       |    4 +-
 drivers/scsi/pm8001/pm8001_init.c         |   44 +++++++++++----------
 drivers/scsi/pmcraid.c                    |   14 +------
 drivers/scsi/qla2xxx/qla_isr.c            |   27 +++++-------
 drivers/scsi/qla4xxx/ql4_nx.c             |    2 +-
 drivers/scsi/vmw_pvscsi.c                 |    2 +-
 16 files changed, 121 insertions(+), 168 deletions(-)

-- 
1.7.7.6

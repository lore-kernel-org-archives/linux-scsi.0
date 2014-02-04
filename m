From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 00/22] scsi: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:16:46 +0100
Message-ID: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbaBDLPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Feb 2014 06:15:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, pv-drivers@vmware.com, iscsi-driver@qlogic.com, qla2xxx-upstream@qlogic.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, intel-linux-scu@intel.com, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Cc: pv-drivers@vmware.com
Cc: iscsi-driver@qlogic.com
Cc: qla2xxx-upstream@qlogic.com
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: intel-linux-scu@intel.com
Cc: iss_storagedev@hp.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (22):
  be2iscsi: Use pci_enable_msix_range()
  bfa: Do not call pci_enable_msix() once it failed
  bfa: Cleanup bfad_setup_intr()
  bfa: Use pci_enable_msix_range()
  csiostor: Remove superfluous call to pci_disable_msix()
  csiostor: Use pci_enable_msix_range()
  fnic: Use pci_enable_msix_range()
  hpsa: Fallback to MSI rather than to INTx if MSI-X failed
  hpsa: Use pci_enable_msix_range()
  isci: Use pci_enable_msix_range()
  lpfc: Remove superfluous call to pci_disable_msix()
  lpfc: Use pci_enable_msix_range()
  megaraid: Use pci_enable_msix_range()
  mpt2sas: Use pci_enable_msix_range()
  mpt3sas: Use pci_enable_msix_range()
  pm8001: Fix invalid success return when request_irq() failed
  pm8001: Use pci_enable_msix_range()
  pmcraid: Get rid of a redundant assignment
  pmcraid: Use pci_enable_msix_range()
  qla2xxx: Use pci_enable_msix_range()
  qla4xxx: Use pci_enable_msix_range()
  vmw_pvscsi: Use pci_enable_msix_range()

 drivers/scsi/be2iscsi/be_main.c           |    6 +-
 drivers/scsi/bfa/bfad.c                   |   62 ++++++++++++-----------------
 drivers/scsi/csiostor/csio_hw.h           |    2 +-
 drivers/scsi/csiostor/csio_isr.c          |   26 +++++-------
 drivers/scsi/fnic/fnic_isr.c              |    4 +-
 drivers/scsi/hpsa.c                       |   23 ++++------
 drivers/scsi/isci/init.c                  |    5 +-
 drivers/scsi/lpfc/lpfc_init.c             |   30 +++++++-------
 drivers/scsi/megaraid/megaraid_sas_base.c |   25 +++++------
 drivers/scsi/mpt2sas/mpt2sas_base.c       |   11 +++--
 drivers/scsi/mpt3sas/mpt3sas_base.c       |    9 +++-
 drivers/scsi/pm8001/pm8001_init.c         |   46 +++++++++++----------
 drivers/scsi/pmcraid.c                    |   14 +------
 drivers/scsi/qla2xxx/qla_isr.c            |   27 +++++-------
 drivers/scsi/qla4xxx/ql4_nx.c             |    5 +-
 drivers/scsi/vmw_pvscsi.c                 |    4 +-
 16 files changed, 134 insertions(+), 165 deletions(-)

-- 
1.7.7.6


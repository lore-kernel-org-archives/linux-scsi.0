From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 00/13] scsi: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:40 +0200
Message-ID: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, James Smart <james.smart@emulex.com>, Naresh Kumar Inna <naresh@chelsio.com>, Arvind Bhushan <arvindb@chelsio.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Tomas Henzl <thenzl@redhat.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Kashyap Desai <Kashyap.desai@avagotech.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

This series is against 3.17-rc1. Patches 0-7 have been acked.
Patches 8-13 still need reviews and are resent without changes
except 'lpfc' which concerns latest James comments.

Thanks!

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Smart <james.smart@emulex.com>
Cc: Naresh Kumar Inna <naresh@chelsio.com>
Cc: Arvind Bhushan <arvindb@chelsio.com>
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Tomas Henzl <thenzl@redhat.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Kashyap Desai <Kashyap.desai@avagotech.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: iss_storagedev@hp.com
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (13):
  hpsa: Fallback to MSI rather than to INTx if MSI-X failed
  hpsa: Use pci_enable_msix_range() instead of pci_enable_msix()
  megaraid: Fail resume if MSI-X re-initialization failed
  megaraid: Use pci_enable_msix_range() instead of pci_enable_msix()
  mpt2sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
  mpt3sas: Use pci_enable_msix_exact() instead of pci_enable_msix()
  qla2xxx: Use pci_enable_msix_range() instead of pci_enable_msix()
  be2iscsi: Use pci_enable_msix_range()
  csiostor: Remove superfluous call to pci_disable_msix()
  csiostor: Use pci_enable_msix_range() instead of pci_enable_msix()
  lpfc: Use pci_enable_msix_range() instead of pci_enable_msix()
  pmcraid: Get rid of a redundant assignment
  pmcraid: Use pci_enable_msix_range() instead of pci_enable_msix()

 drivers/scsi/be2iscsi/be_main.c           |  6 ++---
 drivers/scsi/csiostor/csio_hw.h           |  2 +-
 drivers/scsi/csiostor/csio_isr.c          | 24 +++++++------------
 drivers/scsi/hpsa.c                       | 28 ++++++++++------------
 drivers/scsi/lpfc/lpfc_init.c             | 39 ++++++++++++++-----------------
 drivers/scsi/megaraid/megaraid_sas_base.c | 24 ++++++++-----------
 drivers/scsi/mpt2sas/mpt2sas_base.c       |  6 ++---
 drivers/scsi/mpt3sas/mpt3sas_base.c       |  4 ++--
 drivers/scsi/pmcraid.c                    | 14 ++---------
 drivers/scsi/qla2xxx/qla_isr.c            | 27 +++++++++------------
 10 files changed, 70 insertions(+), 104 deletions(-)

-- 
1.9.3

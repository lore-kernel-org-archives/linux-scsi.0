From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 0/7] Phase out pci_enable_msi_block()
Date: Tue,  7 Jan 2014 19:05:35 +0100
Message-ID: <cover.1389103215.git.agordeev@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@us.ibm.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, Kalle Valo <kvalo@qca.qualcomm.com>, Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>, linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com, ath10k@lists.infradead.org, linux-nvme@lists.infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of recent deprecation of MSI-X/MSI enablement
interfaces pci_enable_msi_block(), pci_enable_msi() and
pci_enable_msix() all drivers need to be updated to use
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

This is the first in a series of updates, to phase out
pci_enable_msi_block() function.

This series is against pci/msi branch in Bjorn Helgaas's repo:
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git

Thanks!

Alexander Gordeev (7):
  ipr: Do not call pci_disable_msi/msix() if pci_enable_msi/msix()
    failed
  ipr: Use new interfaces for MSI/MSI-X enablement
  ahci: Use new interfaces for MSI/MSI-X enablement
  nvme: Use new interfaces for MSI/MSI-X enablement
  vfio: Use new interfaces for MSI/MSI-X enablement
  ath10k: Use new interfaces for MSI enablement
  wil6210: Use new interfaces for MSI enablement

 drivers/ata/ahci.c                          |   15 +++-----
 drivers/block/nvme-core.c                   |   33 ++++-------------
 drivers/net/wireless/ath/ath10k/pci.c       |   22 ++++++------
 drivers/net/wireless/ath/wil6210/pcie_bus.c |   36 ++++++++++---------
 drivers/scsi/ipr.c                          |   51 +++++++++-----------------
 drivers/vfio/pci/vfio_pci_intrs.c           |    8 ++--
 6 files changed, 66 insertions(+), 99 deletions(-)

-- 
1.7.7.6


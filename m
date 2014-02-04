From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH 22/22] vmw_pvscsi: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:17:08 +0100
Message-ID: <9a6fa1d91c1f23ee0bbde7c854ce03f22054345a.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Arvind Kumar <arvindkumar@vmware.com>, pv-drivers@vmware.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: pv-drivers@vmware.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/vmw_pvscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index b9755ec..c521f8e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1078,8 +1078,8 @@ static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
 	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
 	int ret;
 
-	ret = pci_enable_msix(adapter->dev, &entry, 1);
-	if (ret)
+	ret = pci_enable_msix_range(adapter->dev, &entry, 1, 1);
+	if (ret < 0)
 		return ret;
 
 	*irq = entry.vector;
-- 
1.7.7.6

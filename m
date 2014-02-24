From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v2 07/23] fnic: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Mon, 24 Feb 2014 09:02:07 +0100
Message-ID: <84bc68d568ec7f7175d2448fffdea9d9ca2d9db3.1393191330.git.agordeev@redhat.com>
References: <cover.1393191330.git.agordeev@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1393191330.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/fnic/fnic_isr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 7d9b54a..a0dd1b6 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -257,8 +257,8 @@ int fnic_set_intr_mode(struct fnic *fnic)
 	    fnic->raw_wq_count >= m &&
 	    fnic->wq_copy_count >= o &&
 	    fnic->cq_count >= n + m + o) {
-		if (!pci_enable_msix(fnic->pdev, fnic->msix_entry,
-				    n + m + o + 1)) {
+		if (!pci_enable_msix_exact(fnic->pdev, fnic->msix_entry,
+					   n + m + o + 1)) {
 			fnic->rq_count = n;
 			fnic->raw_wq_count = m;
 			fnic->wq_copy_count = o;
-- 
1.7.7.6

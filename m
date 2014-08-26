From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH RESEND 4/6] qla2xxx: Schedule board_disable only once
Date: Tue, 26 Aug 2014 17:12:01 -0400
Message-ID: <1409087521-18828-1-git-send-email-joe.lawrence@stratus.com>
References: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:56942 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaHZVNn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Aug 2014 17:13:43 -0400
In-Reply-To: <1409087303-18479-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

There are various callers of qla2x00_check_reg{32,16}_for_disconnect
that may schedule board removal on PCI-disconnect. Test-and-set a
dedicated flag before scheduling board_disable so it is invoked only
once.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 +++
 drivers/scsi/qla2xxx/qla_isr.c |   14 ++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b643991..4267ec6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3402,6 +3402,9 @@ typedef struct scsi_qla_host {
 #define FX00_CRITEMP_RECOVERY	25
 #define FX00_HOST_INFO_RESEND	26
 
+	unsigned long	pci_flags;
+#define PFLG_DISCONNECTED	0	/* PCI device removed */
+
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
 #define DFLG_NO_CABLE		BIT_1
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 016ebed..fd75b91 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -117,12 +117,14 @@ qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
 {
 	/* Check for PCI disconnection */
 	if (reg == 0xffffffff) {
-		/*
-		 * Schedule this on the default system workqueue so that all the
-		 * adapter workqueues and the DPC thread can be shutdown
-		 * cleanly.
-		 */
-		schedule_work(&vha->hw->board_disable);
+		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags)) {
+			/*
+			 * Schedule this (only once) on the default system
+			 * workqueue so that all the adapter workqueues and the
+			 * DPC thread can be shutdown cleanly.
+			 */
+			schedule_work(&vha->hw->board_disable);
+		}
 		return true;
 	} else
 		return false;
-- 
1.7.10.4


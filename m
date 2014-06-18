From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 6/6] qla2xxx: Prevent probe and board_disable race
Date: Wed, 18 Jun 2014 10:04:44 -0400
Message-ID: <1403100284-1872-2-git-send-email-joe.lawrence@stratus.com>
References: <1403100139-1798-1-git-send-email-joe.lawrence@stratus.com>
 <1403100284-1872-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:37413 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaFRON4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2014 10:13:56 -0400
In-Reply-To: <1403100284-1872-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>, Bill Kuzeja <william.kuzeja@stratus.com>, Dave Bulkow <david.bulkow@stratus.com>, Joe Lawrence <joe.lawrence@stratus.com>

The PCI register read checking introduced in commit f3ddac19 "qla2xxx:
Disable adapter when we encounter a PCI disconnect" is active during
driver probe.  Hold off scheduling any board removal until the driver
probe has completed.  This ensures that the the board_disable work
structure is initialized and more importantly, avoids racing
qla2x00_probe_one.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c  |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7c441c9..253a89d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3405,6 +3405,7 @@ typedef struct scsi_qla_host {
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
 #define PFLG_DRIVER_REMOVING	1	/* PCI driver .remove */
+#define PFLG_DRIVER_PROBING	2	/* PCI driver .probe */
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ee5eef4..4ea8252 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -118,7 +118,8 @@ qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
 	/* Check for PCI disconnection */
 	if (reg == 0xffffffff) {
 		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags) &&
-		    !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags)) {
+		    !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags) &&
+		    !test_bit(PFLG_DRIVER_PROBING, &vha->pci_flags)) {
 			/*
 			 * Schedule this (only once) on the default system
 			 * workqueue so that all the adapter workqueues and the
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 51cba37..0b39425 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2629,6 +2629,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pci_set_drvdata(pdev, base_vha);
+	set_bit(PFLG_DRIVER_PROBING, &base_vha->pci_flags);
 
 	host = base_vha->host;
 	base_vha->req = req;
@@ -2920,6 +2921,7 @@ skip_dpc:
 
 	qlt_add_target(ha, base_vha);
 
+	clear_bit(PFLG_DRIVER_PROBING, &base_vha->pci_flags);
 	return 0;
 
 probe_init_failed:
-- 
1.7.10.4


From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 3/8] snic: Handling control path queue issues
Date: Thu, 17 Mar 2016 00:51:12 -0700
Message-ID: <1458201077-10211-3-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:21738 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645AbcCQH5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:37 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

Fix handles control path queue issues such as queue full, and
sudden removal of hardware.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/vnic_dev.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/snic/vnic_dev.c b/drivers/scsi/snic/vnic_dev.c
index e0b5549..dad5fc6 100644
--- a/drivers/scsi/snic/vnic_dev.c
+++ b/drivers/scsi/snic/vnic_dev.c
@@ -263,12 +263,20 @@ static int _svnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 	int wait)
 {
 	struct devcmd2_controller *dc2c = vdev->devcmd2;
-	struct devcmd2_result *result = dc2c->result + dc2c->next_result;
+	struct devcmd2_result *result = NULL;
 	unsigned int i;
 	int delay;
 	int err;
 	u32 posted;
+	u32 fetch_idx;
 	u32 new_posted;
+	u8 color;
+
+	fetch_idx = ioread32(&dc2c->wq_ctrl->fetch_index);
+	if (fetch_idx == 0xFFFFFFFF) { /* check for hardware gone  */
+		/* Hardware surprise removal: return error */
+		return -ENODEV;
+	}
 
 	posted = ioread32(&dc2c->wq_ctrl->posted_index);
 
@@ -278,6 +286,13 @@ static int _svnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 	}
 
 	new_posted = (posted + 1) % DEVCMD2_RING_SIZE;
+	if (new_posted == fetch_idx) {
+		pr_err("%s: wq is full while issuing devcmd2 command %d, fetch index: %u, posted index: %u\n",
+			pci_name(vdev->pdev), _CMD_N(cmd), fetch_idx, posted);
+
+		return -EBUSY;
+	}
+
 	dc2c->cmd_ring[posted].cmd = cmd;
 	dc2c->cmd_ring[posted].flags = 0;
 
@@ -299,14 +314,22 @@ static int _svnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 	if (dc2c->cmd_ring[posted].flags & DEVCMD2_FNORESULT)
 		return 0;
 
+	result = dc2c->result + dc2c->next_result;
+	color = dc2c->color;
+
+	/*
+	 * Increment next_result, after posting the devcmd, irrespective of
+	 * devcmd result, and it should be done only once.
+	 */
+	dc2c->next_result++;
+	if (dc2c->next_result == dc2c->result_size) {
+		dc2c->next_result = 0;
+		dc2c->color = dc2c->color ? 0 : 1;
+	}
+
 	for (delay = 0; delay < wait; delay++) {
 		udelay(100);
-		if (result->color == dc2c->color) {
-			dc2c->next_result++;
-			if (dc2c->next_result == dc2c->result_size) {
-				dc2c->next_result = 0;
-				dc2c->color = dc2c->color ? 0 : 1;
-			}
+		if (result->color == color) {
 			if (result->error) {
 				err = (int) result->error;
 				if (err != ERR_ECMDUNKNOWN ||
@@ -317,13 +340,6 @@ static int _svnic_dev_cmd2(struct vnic_dev *vdev, enum vnic_devcmd_cmd cmd,
 				return err;
 			}
 			if (_CMD_DIR(cmd) & _CMD_DIR_READ) {
-				/*
-				 * Adding the rmb() prevents the compiler
-				 * and/or CPU from reordering the reads which
-				 * would potentially result in reading stale
-				 * values.
-				 */
-				rmb();
 				for (i = 0; i < VNIC_DEVCMD_NARGS; i++)
 					vdev->args[i] = result->results[i];
 			}
-- 
1.8.5.4


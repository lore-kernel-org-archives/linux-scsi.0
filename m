From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] scsi: hpsa: use %phN for short hex dumps
Date: Wed, 30 Nov 2016 23:35:47 +0100
Message-ID: <1480545348-32669-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, iss_storagedev@hp.com, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Passing one instead of 8 or 16 arguments reduces the size of the
generated code somewhat:

add/remove: 2/3 grow/shrink: 1/4 up/down: 1772/-2137 (-365)

There's one more candidate, unique_id_show, but that uses %02X, and I'm
not sure it would be ok to start using lowercase there, so I've left it
alone for now.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/scsi/hpsa.c | 40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1d6ab76a514..d74268ffb71e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -700,9 +700,7 @@ static ssize_t lunid_show(struct device *dev,
 	}
 	memcpy(lunid, hdev->scsi3addr, sizeof(lunid));
 	spin_unlock_irqrestore(&h->lock, flags);
-	return snprintf(buf, 20, "0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-		lunid[0], lunid[1], lunid[2], lunid[3],
-		lunid[4], lunid[5], lunid[6], lunid[7]);
+	return snprintf(buf, 20, "0x%8phN\n", lunid);
 }
 
 static ssize_t unique_id_show(struct device *dev,
@@ -2824,14 +2822,8 @@ static void hpsa_print_cmd(struct ctlr_info *h, char *txt,
 	const u8 *cdb = c->Request.CDB;
 	const u8 *lun = c->Header.LUN.LunAddrBytes;
 
-	dev_warn(&h->pdev->dev, "%s: LUN:%02x%02x%02x%02x%02x%02x%02x%02x"
-	" CDB:%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-		txt, lun[0], lun[1], lun[2], lun[3],
-		lun[4], lun[5], lun[6], lun[7],
-		cdb[0], cdb[1], cdb[2], cdb[3],
-		cdb[4], cdb[5], cdb[6], cdb[7],
-		cdb[8], cdb[9], cdb[10], cdb[11],
-		cdb[12], cdb[13], cdb[14], cdb[15]);
+	dev_warn(&h->pdev->dev, "%s: LUN:%8phN CDB:%16phN\n",
+		 txt, lun, cdb);
 }
 
 static void hpsa_scsi_interpret_error(struct ctlr_info *h,
@@ -5999,11 +5991,9 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 
 	if (h->raid_offload_debug > 0)
 		dev_info(&h->pdev->dev,
-			"scsi %d:%d:%d:%d %s scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
+			"scsi %d:%d:%d:%d %s scsi3addr 0x%8phN\n",
 			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
-			"Reset as abort",
-			scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
-			scsi3addr[4], scsi3addr[5], scsi3addr[6], scsi3addr[7]);
+			"Reset as abort", scsi3addr);
 
 	if (!dev->offload_enabled) {
 		dev_warn(&h->pdev->dev,
@@ -6020,32 +6010,28 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 	/* send the reset */
 	if (h->raid_offload_debug > 0)
 		dev_info(&h->pdev->dev,
-			"Reset as abort: Resetting physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-			psa[0], psa[1], psa[2], psa[3],
-			psa[4], psa[5], psa[6], psa[7]);
+			"Reset as abort: Resetting physical device at scsi3addr 0x%8phN\n",
+			psa);
 	rc = hpsa_do_reset(h, dev, psa, HPSA_PHYS_TARGET_RESET, reply_queue);
 	if (rc != 0) {
 		dev_warn(&h->pdev->dev,
-			"Reset as abort: Failed on physical device at scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-			psa[0], psa[1], psa[2], psa[3],
-			psa[4], psa[5], psa[6], psa[7]);
+			"Reset as abort: Failed on physical device at scsi3addr 0x%8phN\n",
+			psa);
 		return rc; /* failed to reset */
 	}
 
 	/* wait for device to recover */
 	if (wait_for_device_to_become_ready(h, psa, reply_queue) != 0) {
 		dev_warn(&h->pdev->dev,
-			"Reset as abort: Failed: Device never recovered from reset: 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-			psa[0], psa[1], psa[2], psa[3],
-			psa[4], psa[5], psa[6], psa[7]);
+			"Reset as abort: Failed: Device never recovered from reset: 0x%8phN\n",
+			psa);
 		return -1;  /* failed to recover */
 	}
 
 	/* device recovered */
 	dev_info(&h->pdev->dev,
-		"Reset as abort: Device recovered from reset: scsi3addr 0x%02x%02x%02x%02x%02x%02x%02x%02x\n",
-		psa[0], psa[1], psa[2], psa[3],
-		psa[4], psa[5], psa[6], psa[7]);
+		"Reset as abort: Device recovered from reset: scsi3addr 0x%8phN\n",
+		psa);
 
 	return rc; /* success */
 }
-- 
2.1.4

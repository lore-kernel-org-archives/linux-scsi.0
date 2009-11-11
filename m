From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 12/17] hpsa: decode unit attention condition and retry
	commands.
Date: Wed, 11 Nov 2009 10:51:24 -0600
Message-ID: <20091111165124.17754.4579.stgit@beardog.cce.hp.com>
References: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:28265 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbZKKQt6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2009 11:49:58 -0500
In-Reply-To: <20091111164803.17754.11900.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scameron@beardog.cce.hp.com, mikem@beardog.cce.hp.com

hpsa: decode unit attention condition and mark commands with DID_SOFT_ERROR
to make the mid-layer retry them.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
---

 drivers/scsi/hpsa.c     |   69 ++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/hpsa_cmd.h |   23 ++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f893a53..6f63d45 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -149,6 +149,10 @@ static ssize_t unique_id_show(struct device *dev,
 static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno);
 static ssize_t host_store_rescan(struct device *dev,
 	 struct device_attribute *attr, const char *buf, size_t count);
+static int check_for_unit_attention(struct ctlr_info *h,
+	struct CommandList *c);
+static void check_ioctl_unit_attention(struct ctlr_info *h,
+	struct CommandList *c);
 
 DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
@@ -317,6 +321,57 @@ static int scan_thread(__attribute__((unused)) void *data)
 	return 0;
 }
 
+static int check_for_unit_attention(struct ctlr_info *h,
+	struct CommandList *c)
+{
+	if (c->err_info->SenseInfo[2] != UNIT_ATTENTION)
+		return 0;
+
+	switch (c->err_info->SenseInfo[12]) {
+	case STATE_CHANGED:
+		dev_warn(&h->pdev->dev, "hpsa%d: a state change "
+			"detected, command retried\n", h->ctlr);
+		break;
+	case LUN_FAILED:
+		dev_warn(&h->pdev->dev, "hpsa%d: LUN failure "
+			"detected, action required\n", h->ctlr);
+		break;
+	case REPORT_LUNS_CHANGED:
+		dev_warn(&h->pdev->dev, "hpsa%d: report LUN data "
+			"changed\n", h->ctlr);
+	/*
+	 * Here, we could call add_to_scan_list and wake up the scan thread,
+	 * except that it's quite likely that we will get more than one
+	 * REPORT_LUNS_CHANGED condition in quick succession, which means
+	 * that those which occur after the first one will likely happen
+	 * *during* the scan_thread's rescan.  And the rescan code is not
+	 * robust enough to restart in the middle, undoing what it has already
+	 * done, and it's not clear that it's even possible to do this, since
+	 * part of what it does is notify the SCSI mid layer, which starts
+	 * doing it's own i/o to read partition tables and so on, and the
+	 * driver doesn't have visibility to know what might need undoing.
+	 * In any event, if possible, it is horribly complicated to get right
+	 * so we just don't do it for now.
+	 *
+	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the MSA2012.
+	 */
+		break;
+	case POWER_OR_RESET:
+		dev_warn(&h->pdev->dev, "hpsa%d: a power on "
+			"or device reset detected\n", h->ctlr);
+		break;
+	case UNIT_ATTENTION_CLEARED:
+		dev_warn(&h->pdev->dev, "hpsa%d: unit attention "
+		    "cleared by another initiator\n", h->ctlr);
+		break;
+	default:
+		dev_warn(&h->pdev->dev, "hpsa%d: unknown "
+			"unit attention detected\n", h->ctlr);
+		break;
+	}
+	return 1;
+}
+
 static ssize_t host_store_rescan(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
@@ -903,7 +958,10 @@ static void complete_scsi_command(struct CommandList *cp,
 		}
 
 		if (ei->ScsiStatus == SAM_STAT_CHECK_CONDITION) {
-
+			if (check_for_unit_attention(h, cp)) {
+				cmd->result = DID_SOFT_ERROR << 16;
+				break;
+			}
 			if (sense_key == ILLEGAL_REQUEST) {
 				/* If ASC/ASCQ indicate Logical Unit
 				 * Not Supported condition,
@@ -2295,6 +2353,7 @@ static int hpsa_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	hpsa_pci_unmap(h->pdev, c, 1, PCI_DMA_BIDIRECTIONAL);
+	check_ioctl_unit_attention(h, c);
 
 	/* Copy the error information out */
 	memcpy(&iocommand.error_info, c->err_info,
@@ -2423,6 +2482,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	}
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	hpsa_pci_unmap(h->pdev, c, sg_used, PCI_DMA_BIDIRECTIONAL);
+	check_ioctl_unit_attention(h, c);
 	/* Copy the error information out */
 	memcpy(&ioc->error_info, c->err_info, sizeof(ioc->error_info));
 	if (copy_to_user(argp, ioc, sizeof(*ioc))) {
@@ -2455,6 +2515,13 @@ cleanup1:
 	return status;
 }
 
+static void check_ioctl_unit_attention(struct ctlr_info *h,
+	struct CommandList *c)
+{
+	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
+			c->err_info->ScsiStatus != SAM_STAT_CHECK_CONDITION)
+		(void) check_for_unit_attention(h, c);
+}
 /*
  * ioctl
  */
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 0564df2..12d7138 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -41,6 +41,29 @@
 #define CMD_TIMEOUT             0x000B
 #define CMD_UNABORTABLE		0x000C
 
+/* Unit Attentions ASC's as defined for the MSA2012sa */
+#define POWER_OR_RESET			0x29
+#define STATE_CHANGED			0x2a
+#define UNIT_ATTENTION_CLEARED		0x2f
+#define LUN_FAILED			0x3e
+#define REPORT_LUNS_CHANGED		0x3f
+
+/* Unit Attentions ASCQ's as defined for the MSA2012sa */
+
+	/* These ASCQ's defined for ASC = POWER_OR_RESET */
+#define POWER_ON_RESET			0x00
+#define POWER_ON_REBOOT			0x01
+#define SCSI_BUS_RESET			0x02
+#define MSA_TARGET_RESET		0x03
+#define CONTROLLER_FAILOVER		0x04
+#define TRANSCEIVER_SE			0x05
+#define TRANSCEIVER_LVD			0x06
+
+	/* These ASCQ's defined for ASC = STATE_CHANGED */
+#define RESERVATION_PREEMPTED		0x03
+#define ASYM_ACCESS_CHANGED		0x06
+#define LUN_CAPACITY_CHANGED		0x09
+
 /* transfer direction */
 #define XFER_NONE               0x00
 #define XFER_WRITE              0x01


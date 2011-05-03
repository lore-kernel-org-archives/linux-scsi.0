From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/16] hpsa: do not attempt PCI power management reset method
	if we know it won't work.
Date: Tue, 03 May 2011 15:00:01 -0500
Message-ID: <20110503200001.5478.65080.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:44287 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1ECUGg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2011 16:06:36 -0400
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Just go straight to the soft-reset method instead.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   52 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ca8ee92..5c03cb5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -273,7 +273,7 @@ static ssize_t host_show_transport_mode(struct device *dev,
 			"performant" : "simple");
 }
 
-/* List of controllers which cannot be reset on kexec with reset_devices */
+/* List of controllers which cannot be hard reset on kexec with reset_devices */
 static u32 unresettable_controller[] = {
 	0x324a103C, /* Smart Array P712m */
 	0x324b103C, /* SmartArray P711m */
@@ -291,16 +291,45 @@ static u32 unresettable_controller[] = {
 	0x409D0E11, /* Smart Array 6400 EM */
 };
 
-static int ctlr_is_resettable(struct ctlr_info *h)
+/* List of controllers which cannot even be soft reset */
+static u32 soft_unresettable_controller[] = {
+	/* Exclude 640x boards.  These are two pci devices in one slot
+	 * which share a battery backed cache module.  One controls the
+	 * cache, the other accesses the cache through the one that controls
+	 * it.  If we reset the one controlling the cache, the other will
+	 * likely not be happy.  Just forbid resetting this conjoined mess.
+	 * The 640x isn't really supported by hpsa anyway.
+	 */
+	0x409C0E11, /* Smart Array 6400 */
+	0x409D0E11, /* Smart Array 6400 EM */
+};
+
+static int ctlr_is_hard_resettable(u32 board_id)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(unresettable_controller); i++)
-		if (unresettable_controller[i] == h->board_id)
+		if (unresettable_controller[i] == board_id)
+			return 0;
+	return 1;
+}
+
+static int ctlr_is_soft_resettable(u32 board_id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(soft_unresettable_controller); i++)
+		if (soft_unresettable_controller[i] == board_id)
 			return 0;
 	return 1;
 }
 
+static int ctlr_is_resettable(u32 board_id)
+{
+	return ctlr_is_hard_resettable(board_id) ||
+		ctlr_is_soft_resettable(board_id);
+}
+
 static ssize_t host_show_resettable(struct device *dev,
 	struct device_attribute *attr, char *buf)
 {
@@ -308,7 +337,7 @@ static ssize_t host_show_resettable(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 
 	h = shost_to_hba(shost);
-	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h));
+	return snprintf(buf, 20, "%d\n", ctlr_is_resettable(h->board_id));
 }
 
 static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
@@ -3334,20 +3363,15 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * using the doorbell register.
 	 */
 
-	/* Exclude 640x boards.  These are two pci devices in one slot
-	 * which share a battery backed cache module.  One controls the
-	 * cache, the other accesses the cache through the one that controls
-	 * it.  If we reset the one controlling the cache, the other will
-	 * likely not be happy.  Just forbid resetting this conjoined mess.
-	 * The 640x isn't really supported by hpsa anyway.
-	 */
 	rc = hpsa_lookup_board_id(pdev, &board_id);
-	if (rc < 0) {
+	if (rc < 0 || !ctlr_is_resettable(board_id)) {
 		dev_warn(&pdev->dev, "Not resetting device.\n");
 		return -ENODEV;
 	}
-	if (board_id == 0x409C0E11 || board_id == 0x409D0E11)
-		return -ENOTSUPP;
+
+	/* if controller is soft- but not hard resettable... */
+	if (!ctlr_is_hard_resettable(board_id))
+		return -ENOTSUPP; /* try soft reset later. */
 
 	/* Save the PCI command register */
 	pci_read_config_word(pdev, 4, &command_register);


From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 7/9] hpsa: forbid hard reset of 640x boards
Date: Wed, 16 Jun 2010 13:51:45 -0500
Message-ID: <20100616185145.22798.34553.stgit@beardog.cce.hp.com>
References: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:23668 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0FPSqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 14:46:47 -0400
In-Reply-To: <20100616184510.22798.26206.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andriusb@redhat.com, James.Bottomley@HansenPartnership.com, dab@hp.com, thenzl@redhat.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: forbid hard reset of 640x boards
The 6402/6404 are two PCI devices -- two Smart Array controllers
-- that fit into one slot.  It is possible to reset them independently,
however, they share a battery backed cache module.  One of the pair
controls the cache and the 2nd one access the cache through the first
one.  If you reset the one controlling the cache, the other one will
not be a happy camper.  So we just forbid resetting this conjoined
mess.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 58690dc..0600c8d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -179,6 +179,7 @@ static int __devinit hpsa_find_cfg_addrs(struct pci_dev *pdev,
 	u64 *cfg_offset);
 static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar);
+static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
 
 static DEVICE_ATTR(raid_level, S_IRUGO, raid_level_show, NULL);
 static DEVICE_ATTR(lunid, S_IRUGO, lunid_show, NULL);
@@ -3148,7 +3149,7 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	int rc, i;
 	struct CfgTable __iomem *cfgtable;
 	bool use_doorbell;
-
+	u32 board_id;
 
 	/* For controllers as old as the P600, this is very nearly
 	 * the same thing as
@@ -3170,6 +3171,18 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * method of resetting doesn't work so we have another way
 	 * using the doorbell register.
 	 */
+
+	/* Exclude 640x boards.  These are two pci devices in one slot
+	 * which share a battery backed cache module.  One controls the
+	 * cache, the other accesses the cache through the one that controls
+	 * it.  If we reset the one controlling the cache, the other will
+	 * likely not be happy.  Just forbid resetting this conjoined mess.
+	 * The 640x isn't really supported by hpsa anyway.
+	 */
+	hpsa_lookup_board_id(pdev, &board_id);
+	if (board_id == 0x409C0E11 || board_id == 0x409D0E11)
+		return -ENOTSUPP;
+
 	for (i = 0; i < 32; i++)
 		pci_read_config_word(pdev, 2*i, &saved_config_space[i]);
 
@@ -3669,7 +3682,8 @@ static __devinit int hpsa_init_reset_devices(struct pci_dev *pdev)
 
 	/* -ENOTSUPP here means we cannot reset the controller
 	 * but it's already (and still) up and running in
-	 * "performant mode".
+	 * "performant mode".  Or, it might be 640x, which can't reset
+	 * due to concerns about shared bbwc between 6402/6404 pair.
 	 */
 	if (rc == -ENOTSUPP)
 		return 0; /* just try to do the kdump anyhow. */


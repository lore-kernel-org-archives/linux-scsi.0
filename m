From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: disable doorbell reset on reset_devices
Date: Wed, 25 Aug 2010 10:44:14 -0500
Message-ID: <20100825154414.4977.87696.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:35751 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0HYPiI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Aug 2010 11:38:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

The doorbell reset initially appears to work correctly,
the controller resets, comes up, some i/o can even be
done, but on at least some Smart Arrays in some servers,
it eventually causes a subsequent controller lockup due
to some kind of PCIe error, and kdump can end up leaving
the root filesystem in an unbootable state.  For this
reason, until the problem is fixed, or at least isolated
to certain hardware enough to be avoided, the doorbell
reset should not be used at all.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4f5551b..c5d0606 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3231,6 +3231,12 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	misc_fw_support = readl(&cfgtable->misc_fw_support);
 	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 
+	/* The doorbell reset seems to cause lockups on some Smart
+	 * Arrays (e.g. P410, P410i, maybe others).  Until this is
+	 * fixed or at least isolated, avoid the doorbell reset.
+	 */
+	use_doorbell = 0;
+
 	rc = hpsa_controller_hard_reset(pdev, vaddr, use_doorbell);
 	if (rc)
 		goto unmap_cfgtable;


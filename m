From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] hpsa: change confusing comment to more clear
Date: Thu, 13 Oct 2011 11:44:06 -0500
Message-ID: <20111013164406.GA17444@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:14544 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1JMQoK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 12:44:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: thenzl@redhat.com, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, scameron@beardog.cce.hp.com

Patch 1 of 1
hpsa: clarify comment in kdump reset code

From: Mike Miller <mike.miller@hp.com>

The following warning message may be confusing to some users:

dev_warn(&pdev->dev, "Controller claims that "
		"'Bit 2 doorbell reset' is "
		"supported, but not 'bit 5 doorbell reset'.  "
		"Firmware update is recommended.\n");

Most users don't know or care what bit we may be hitting. Also change
"recommended" to "required."

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 311bf7a..f7a569e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3450,10 +3450,8 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	} else {
 		use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 		if (use_doorbell) {
-			dev_warn(&pdev->dev, "Controller claims that "
-				"'Bit 2 doorbell reset' is "
-				"supported, but not 'bit 5 doorbell reset'.  "
-				"Firmware update is recommended.\n");
+			dev_warn(&pdev->dev, "Soft reset not supported. "
+				"Firmware update is required.\n");
 			rc = -ENOTSUPP; /* try soft reset */
 			goto unmap_cfgtable;
 		}

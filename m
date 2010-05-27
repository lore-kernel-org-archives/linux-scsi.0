From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 20/24] hpsa: remove unused firm_ver member of the per-hba
	structure
Date: Thu, 27 May 2010 15:14:24 -0500
Message-ID: <20100527201424.3116.53531.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:40839 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:09:45 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: remove unused firm_ver member of the per-hba structure

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 ------
 drivers/scsi/hpsa.h |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3fb4322..6abebef 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1440,12 +1440,6 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		goto bail_out;
 	}
 
-	/* As a side effect, record the firmware version number
-	 * if we happen to be talking to the RAID controller.
-	 */
-	if (is_hba_lunid(scsi3addr))
-		memcpy(h->firm_ver, &inq_buff[32], 4);
-
 	this_device->devtype = (inq_buff[0] & 0x1f);
 	memcpy(this_device->scsi3addr, scsi3addr, 8);
 	memcpy(this_device->vendor, &inq_buff[8],
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 1bb5233..a203ef6 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -53,7 +53,6 @@ struct ctlr_info {
 	int	ctlr;
 	char	devname[8];
 	char    *product_name;
-	char	firm_ver[4]; /* Firmware version */
 	struct pci_dev *pdev;
 	u32	board_id;
 	void __iomem *vaddr;


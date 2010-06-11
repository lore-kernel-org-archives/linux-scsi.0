From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: fix use of uninitialized variable in
	hpsa_add_msa2xxx_enclosure_device()
Date: Fri, 11 Jun 2010 11:18:26 -0500
Message-ID: <20100611161826.13000.57963.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:34929 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0FKQNo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2010 12:13:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix use of uninitialized variable in hpsa_add_msa2xxx_enclosure_device()

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2c75f68..52fe4ee 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1595,6 +1595,8 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 	if (lun == 0) /* if lun is 0, then obviously we have a lun 0. */
 		return 0;
 
+	memset(scsi3addr, 0, 8);
+	scsi3addr[3] = target;
 	if (is_hba_lunid(scsi3addr))
 		return 0; /* Don't add the RAID controller here. */
 
@@ -1609,8 +1611,6 @@ static int add_msa2xxx_enclosure_device(struct ctlr_info *h,
 		return 0;
 	}
 
-	memset(scsi3addr, 0, 8);
-	scsi3addr[3] = target;
 	if (hpsa_update_device_info(h, scsi3addr, this_device))
 		return 0;
 	(*nmsa2xxx_enclosures)++;


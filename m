From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 02/29] cxlflash: Add a literal for units of max_sector
Date: Fri, 11 Sep 2015 16:10:07 -0500
Message-ID: <1442005807-46384-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:53792 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbIKVK0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:10:26 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:10:25 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 078DC19D801C
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:01:17 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BL7N3W28311752
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:07:23 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLALb0006447
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:10:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

From: Manoj Kumar <kumarmn@us.ibm.com>

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 3 ++-
 drivers/scsi/cxlflash/superpipe.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index f1b62ce..affec2d 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1375,7 +1375,8 @@ out_attach:
 	attach->block_size = gli->blk_len;
 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
 	attach->last_lba = gli->max_lba;
-	attach->max_xfer = (sdev->host->max_sectors * 512) / gli->blk_len;
+	attach->max_xfer = (sdev->host->max_sectors * MAX_SECTOR_UNIT) /
+		gli->blk_len;
 
 out:
 	attach->adap_fd = fd;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index d7dc88b..5c39f2c 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -30,6 +30,8 @@ extern struct cxlflash_global global;
 
 #define MC_DISCOVERY_TIMEOUT 5  /* 5 secs */
 
+#define MAX_SECTOR_UNIT  512 /* max_sector is in 512 byte multiples */
+
 #define CHAN2PORT(_x)	((_x) + 1)
 #define PORT2CHAN(_x)	((_x) - 1)
 
-- 
2.1.0


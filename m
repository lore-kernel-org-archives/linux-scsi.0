From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Tue, 20 May 2014 13:03:08 +0200
Message-ID: <1400583791-123120-3-git-send-email-hare@suse.de>
References: <1400583791-123120-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbaETLDO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2014 07:03:14 -0400
In-Reply-To: <1400583791-123120-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

Sequential scan for more than 256 LUNs is very fragile as
LUNs might not be numbered sequentially after that point.

SAM revisions later than SCSI-3 impose a structure on
LUNs larger than 256, making LUN numbers between 256
and 16384 illegal.
SCSI-3, however allows for plain 64-bit numbers with
no internal structure.

So restrict sequential LUN scan to 256 LUNs and add a
new blacklist flag 'BLIST_SCSI3LUN' to scan up to
max_lun devices.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c    | 6 ++++++
 include/scsi/scsi_devinfo.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8564bdc..a02f7b0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1235,6 +1235,12 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 		max_dev_lun = min(8U, max_dev_lun);
 
 	/*
+	 * Stop scanning at 255 unless BLIST_SCSI3LUN
+	 */
+	if (!(bflags & BLIST_SCSI3LUN))
+		max_dev_lun = min(256U, max_dev_lun);
+
+	/*
 	 * We have already scanned LUN 0, so start at LUN 1. Keep scanning
 	 * until we reach the max, or no LUN is found and we are not
 	 * sparse_lun.
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 447d2d7..8670c04 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,4 +32,6 @@
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
+#define BLIST_SCSI3LUN		0x8000000 /* Scan more than 256 LUNs
+					     for sequential scan */
 #endif
-- 
1.7.12.4


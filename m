From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06 of 16] Detect devices with protection information turned on
	in INQUIRY
Date: Fri, 25 Apr 2008 19:12:08 -0400
Message-ID: <bfbea544d34232d4da56.1209165128@sermon.lab.mkp.net>
References: <patchbomb.1209165122@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:44313 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759018AbYDYXR2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 19:17:28 -0400
In-Reply-To: <patchbomb.1209165122@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2 files changed, 4 insertions(+)
drivers/scsi/scsi_scan.c   |    3 +++
include/scsi/scsi_device.h |    1 +


Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 26ccaf2ccdc5 -r bfbea544d342 drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Fri Apr 25 17:39:29 2008 -0400
+++ b/drivers/scsi/scsi_scan.c	Fri Apr 25 17:39:29 2008 -0400
@@ -877,6 +877,9 @@
 
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
+
+	if (inq_result[5] & 0x1)
+		sdev->protection = 1;
 
 	/* set the device running here so that slave configure
 	 * may do I/O */
diff -r 26ccaf2ccdc5 -r bfbea544d342 include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	Fri Apr 25 17:39:29 2008 -0400
+++ b/include/scsi/scsi_device.h	Fri Apr 25 17:39:29 2008 -0400
@@ -140,6 +140,7 @@
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* Always read last sector in a 1 sector read */
+	unsigned protection:1;		/* Data Integrity Field */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */



From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/2] sd: Try READ CAPACITY 16 first for SBC-2 devices
Date: Thu, 12 Mar 2009 14:20:30 -0400
Message-ID: <1236882030-27964-3-git-send-email-willy@linux.intel.com>
References: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ottawa-hs-206-191-39-47.d-ip.magma.ca ([206.191.39.47]:38384
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756345AbZCLSay (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 14:30:54 -0400
In-Reply-To: <1236882030-27964-1-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

New features are being added to the READ CAPACITY 16 results, so we
want to issue it in preference to READ CAPACITY 10.  Unfortunately, some
devices misbehave when they see a READ CAPACITY 16, so we restrict this
command to devices which claim conformance to SPC-3 (aka SBC-2), or claim
they have features which are only reported in the READ CAPACITY 16 data.

The READ CAPACITY 16 command is optional, even for SBC-2 devices, so
we fall back to READ CAPACITY 10 if READ CAPACITY 16 fails.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6cf0c25..b155488 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1418,6 +1418,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	return sector_size;
 }
 
+static int sd_try_rc16_first(struct scsi_device *sdp)
+{
+	if (sdp->scsi_level > SCSI_SPC_2)
+		return 1;
+	if (scsi_device_protection(sdp))
+		return 1;
+	return 0;
+}
+
 /*
  * read disk capacity
  */
@@ -1427,11 +1436,14 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
 
-	/* Force READ CAPACITY(16) when PROTECT=1 */
-	if (scsi_device_protection(sdp)) {
+	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
 		if (sector_size == -EOVERFLOW)
 			goto got_data;
+		if (sector_size == -ENODEV)
+			return;
+		if (sector_size < 0)
+			sector_size = read_capacity_10(sdkp, sdp, buffer);
 		if (sector_size < 0)
 			return;
 	} else {
-- 
1.6.1.3


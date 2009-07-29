From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Avoid sending extended inquiry to legacy devices
Date: Wed, 29 Jul 2009 14:06:53 -0400
Message-ID: <yq1ljm75poi.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:22155 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZG2SHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2009 14:07:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


Some USB devices crash when we send them an inquiry with the EVPD bit
set, regardless of page requested (i.e. including page 0).

We only need the extended inquiry to gain access to VPD pages 0xB0 and
0xB1.  These appeared in SBC2 and SBC3 respectively, so we can restrict
sending the extended inquiry to devices reporting SPC3 or higher.

This fixes bugzilla.kernel.org #13657.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5616cd7..9b703fd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1840,6 +1840,13 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	kfree(buffer);
 }
 
+static int sd_try_extended_inquiry(struct scsi_device *sdp)
+{
+	if (sdp->scsi_level > SCSI_SPC_2)
+		return 1;
+	return 0;
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -1877,8 +1884,12 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->media_present) {
 		sd_read_capacity(sdkp, buffer);
-		sd_read_block_limits(sdkp);
-		sd_read_block_characteristics(sdkp);
+
+		if (sd_try_extended_inquiry(sdp)) {
+			sd_read_block_limits(sdkp);
+			sd_read_block_characteristics(sdkp);
+		}
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);


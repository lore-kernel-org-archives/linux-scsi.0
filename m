From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [BISECTED] Re: [BUG] Linux-2.6.31-rc1 Fails To Recognize Some USB Disks
Date: Sun, 26 Jul 2009 21:28:15 -0400
Message-ID: <yq1hbwykj80.fsf@sermon.lab.mkp.net>
References: <4A4472DF.1050900@turknet.net.tr>
	<yq1zlbrn2rj.fsf@sermon.lab.mkp.net> <4A4878AC.3050208@turknet.net.tr>
	<yq1fxdji03l.fsf@sermon.lab.mkp.net> <4A69932E.90906@turknet.net.tr>
	<yq1fxcmnpqa.fsf@sermon.lab.mkp.net> <4A69D093.8020108@turknet.net.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:47267 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbZG0B2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2009 21:28:40 -0400
In-Reply-To: <4A69D093.8020108@turknet.net.tr> (Tarkan Erimer's message of
	"Fri, 24 Jul 2009 18:17:39 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

>>>>> "Tarkan" == Tarkan Erimer <tarkan.erimer@turknet.net.tr> writes:

Tarkan> root@tarkane:~# sg_inq -e /dev/sdb
Tarkan> VPD INQUIRY: extended INQUIRY data page
Tarkan> inquiry: transport: Host_status=0x05 [DID_ABORT]
Tarkan> Driver_status=0x00 [DRIVER_OK, SUGGEST_OK]
Tarkan>     inquiry: failed, res=-1

*sigh*


sd: Avoid sending extended inquiry to legacy/broken devices

Our existing check for VPD page validity does not handle devices that
refuse to respond to INQUIRY with the EVPD bit set.

Restrict extended inquiry to devices reporting SBC2/SPC3 or higher.

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

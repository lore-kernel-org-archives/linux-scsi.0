From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 3/3] scsi_debug: bump inquiry version to SPC-4, update version
 descriptors
Date: Tue, 05 Aug 2014 12:21:53 +0200
Message-ID: <53E0B041.2050009@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070006050605070601020101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32825 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbaHEKVz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 06:21:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

This is a multi-part message in MIME format.
--------------070006050605070601020101
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Since a lot of functionality from SPC-4 is supported by this
driver (e.g. LBP and PI) then bump the default INQUIRY version
from SPC-3 to SPC-4. Also update the INQUIRY version
descriptors.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>


--------------070006050605070601020101
Content-Type: text/x-patch;
 name="0003-up-inquiry-version-to-SPC-4-update-version-descripto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-up-inquiry-version-to-SPC-4-update-version-descripto.pa";
 filename*1="tch"

---
 drivers/scsi/scsi_debug.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 693f2fa..1c475e9 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -123,7 +123,7 @@ static const char *scsi_debug_version_date = "20140706";
 #define DEF_PHYSBLK_EXP 0
 #define DEF_PTYPE   0
 #define DEF_REMOVABLE false
-#define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
+#define DEF_SCSI_LEVEL   6    /* INQUIRY, byte2 [6->SPC-4] */
 #define DEF_SECTOR_SIZE 512
 #define DEF_TAGGED_QUEUING 0 /* 0 | MSG_SIMPLE_TAG | MSG_ORDERED_TAG */
 #define DEF_UNMAP_ALIGNMENT 0
@@ -1056,15 +1056,15 @@ static int resp_inquiry(struct scsi_cmnd *scp, int target,
 	memcpy(&arr[16], inq_product_id, 16);
 	memcpy(&arr[32], inq_product_rev, 4);
 	/* version descriptors (2 bytes each) follow */
-	arr[58] = 0x0; arr[59] = 0x77; /* SAM-3 ANSI */
-	arr[60] = 0x3; arr[61] = 0x14;  /* SPC-3 ANSI */
+	arr[58] = 0x0; arr[59] = 0xa2;  /* SAM-5 rev 4 */
+	arr[60] = 0x4; arr[61] = 0x68;  /* SPC-4 rev 37 */
 	n = 62;
 	if (scsi_debug_ptype == 0) {
-		arr[n++] = 0x3; arr[n++] = 0x3d; /* SBC-2 ANSI */
+		arr[n++] = 0x4; arr[n++] = 0xc5; /* SBC-4 rev 36 */
 	} else if (scsi_debug_ptype == 1) {
-		arr[n++] = 0x3; arr[n++] = 0x60; /* SSC-2 no version */
+		arr[n++] = 0x5; arr[n++] = 0x25; /* SSC-4 rev 3 */
 	}
-	arr[n++] = 0xc; arr[n++] = 0xf;  /* SAS-1.1 rev 10 */
+	arr[n++] = 0x20; arr[n++] = 0xe6;  /* SPL-3 rev 7 */
 	ret = fill_from_dev_buffer(scp, arr,
 			    min(alloc_len, SDEBUG_LONG_INQ_SZ));
 	kfree(arr);
@@ -3205,7 +3205,7 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err...
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
-MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
+MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=6[SPC-4])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
-- 
1.9.1



--------------070006050605070601020101--

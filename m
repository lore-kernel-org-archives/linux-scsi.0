From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 1/1] cciss: add init of drv->cylinders back to cciss_geometry_inquiry
Date: Wed, 4 Apr 2007 12:24:20 -0500
Message-ID: <20070404172420.GD5412@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751883AbXDDRYX@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, coughlan@redhat.com, coldwell@redhat.com
List-Id: linux-scsi@vger.kernel.org

PATCH 1/1

This patch adds initialization of drv->cylinders back into the failing case in
cciss_geometry_inquiry. I inadvertently removed it in one my 2TB updates.

Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
------------------------------------------------------------------------------------------
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 072e18e..14d7806 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1915,6 +1915,7 @@ static void cciss_geometry_inquiry(int c
 			       "does not support reading geometry\n");
 			drv->heads = 255;
 			drv->sectors = 32;	// Sectors per track
+			drv->cylinders = total_size + 1;
 			drv->raid_level = RAID_UNKNOWN;
 		} else {
 			drv->heads = inq_buff->data_byte[6];

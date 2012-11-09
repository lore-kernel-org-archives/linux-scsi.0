From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH] USB enclosures seem to require read(16) with >2TB drives
Date: Fri, 9 Nov 2012 16:33:39 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40294C344C61@G1W3652.americas.hpqcorp.net>
References: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16433 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2KIQeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2012 11:34:09 -0500
In-Reply-To: <1352477289-8133-1-git-send-email-hernejj@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>

I recommend broadening this patch.  T10 is discussing making READ (10), WRITE (10), etc. obsolete in SBC-4 in favor of their 16-byte CDB counterparts.  

The algorithm should be:
1. During discovery, determine if 16-byte CDBs are supported.  There are several ways to determine this:
a) REPORT SUPPORTED OPERATION CODES command succeeds and reports that READ (16) et al are supported.
b) READ (16) command specifying a Transfer Length of zero succeeds.
c) READ CAPACITY (16) command succeeds and reports that the capacity is > 2 TiB.
d) (future) INQUIRY command succeeds fetching the Block Device Characteristics VPD page and notices a new field added by the SBC-4 simplified SCSI feature set proposal.

Since REPORT SUPPORTED OPERATION CODES is optional, it won't always work. READ CAPACITY (16) used to be optional for < 2 TiB drives, so it won't always work either. READ (16) will always work, but requires the drive to be spun up beforehand (e.g., with START STOP UNIT).
 
2. if 16-byte CDBs are supported, then use them; only drop down to 10-byte CDBs if 16-byte CDBs are unavailable.  Don't make the decision by comparing the LBA on every IO.



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jason J. Herne
Sent: Friday, November 09, 2012 9:08 AM
To: linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org; stern@rowland.harvard.edu; Jason J. Herne
Subject: [PATCH] USB enclosures seem to require read(16) with >2TB drives

From: "Jason J. Herne" <hernejj@gmail.com>

Force large capacity (> 2TB) drives in USB enclosures to use READ(16) instead
of READ(10).  Some(most/all?) enclosures do not like READ(10) commands when a
large capacity drive is installed.

Signed-off-by: Jason J. Herne <hernejj@gmail.com>
---
 drivers/scsi/sd.c              |    7 +++++--
 drivers/usb/storage/scsiglue.c |    5 +++++
 include/scsi/scsi_device.h     |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4b63c73..9b65ddf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -649,7 +649,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	sector_t block = blk_rq_pos(rq);
 	sector_t threshold;
 	unsigned int this_count = blk_rq_sectors(rq);
-	int ret, host_dif;
+	int ret, host_dif, force_read16;
 	unsigned char protect;
 
 	/*
@@ -797,6 +797,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	else
 		protect = 0;
 
+	/* Many large capacity USB drives/controllers require the use of read(16). */
+	force_read16 = (sdkp->capacity > 0xffffffffULL && sdp->force_read_16);
+
 	if (host_dif == SD_DIF_TYPE2_PROTECTION) {
 		SCpnt->cmnd = mempool_alloc(sd_cdb_pool, GFP_ATOMIC);
 
@@ -833,7 +836,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (block > 0xffffffff) {
+	} else if (block > 0xffffffff || force_read16) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 13b8bcd..6ff785e 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -251,6 +251,11 @@ static int slave_configure(struct scsi_device *sdev)
 					US_FL_SCM_MULT_TARG)) &&
 				us->protocol == USB_PR_BULK)
 			us->use_last_sector_hacks = 1;
+
+		/* Force read-16 for large capacity drives. */
+		sdev->force_read_16 = 1;
+
+
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5591ed5..e92b846 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -134,6 +134,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned force_read_16:1; /* Use read(16) over read(10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

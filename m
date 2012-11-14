From: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Try #3: Use SCSI read/write(16) with > 32-bit LBA drives
Date: Wed, 14 Nov 2012 10:39:36 -0500
Message-ID: <1352907576-29285-1-git-send-email-hernejj@gmail.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, Elliott-VXdhtT5mjnY@public.gmane.org, "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: "Jason J. Herne" <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Force large capacity (> 0xFFFFFFFF blocks) drives to use READ/WRITE(16) instead
of READ/WRITE(10). Some(most/all?) USB enclosures do not like READ(10) commands
when a large capacity drive is installed.

Signed-off-by: Jason J. Herne <hernejj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/scsi/sd.c          |    5 ++++-
 include/scsi/scsi_device.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 12f6fdf..f7913c0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -887,7 +887,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
 		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
 		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
-	} else if (block > 0xffffffff) {
+	} else if (sdp->use_16_for_rw) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
 		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
@@ -2054,6 +2054,9 @@ got_data:
 		}
 	}
 
+	/* Use read/write(16) for > 32-bit LBA disks */
+	sdp->use_16_for_rw = (sdkp->capacity > 0xffffffff);
+
 	/* Rescale capacity to 512-byte units */
 	if (sector_size == 4096)
 		sdkp->capacity <<= 3;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 88fae8d..19ab8f1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -135,6 +135,7 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
-- 
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

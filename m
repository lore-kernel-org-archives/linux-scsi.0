From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI bug fixes for 2.6.36-rc7
Date: Wed, 13 Oct 2010 09:45:51 -0400
Message-ID: <1286977551.2969.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch set fixes a couple of longstanding bugs in SCSI.  The VPD
patch fix a possible buffer overrun in the VPD code (only tripped if the
device has a huge number of VPD pages).  The other is where the status
return code on our BSG interface is wrongly right shifted one place.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

FUJITA Tomonori (1):
      bsg: fix incorrect device_status value

Martin K. Petersen (1):
      Fix VPD inquiry page wrapper


The diffstat is:

 block/bsg.c         |    2 +-
 drivers/scsi/scsi.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

And the full diff is below.

James

---

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..5974682 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -426,7 +426,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors && 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..348fba0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1046,13 +1046,13 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
-		return -EINVAL;
+		return 0;
 
 	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
 		if (buf[i + 4] == page)
 			goto found;
 
-	if (i < buf[3] && i > buf_len)
+	if (i < buf[3] && i >= buf_len - 4)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
 	/* The device claims it doesn't support the requested page */

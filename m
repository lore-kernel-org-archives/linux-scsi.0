From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] lguest: replace VIRTIO_F_BARRIER support with VIRTIO_F_FLUSH/FUA support
Date: Mon, 16 Aug 2010 18:52:01 +0200
Message-ID: <1281977523-19335-4-git-send-email-tj@kernel.org>
References: <1281977523-19335-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1281977523-19335-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.
Cc: Tejun Heo <tj@kernle.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Tejun Heo <tj@kernle.org>

VIRTIO_F_BARRIER is deprecated.  Replace it with VIRTIO_F_FLUSH/FUA
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index e9ce3c5..3be47d4 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1639,15 +1639,6 @@ static void blk_request(struct virtqueue *vq)
 	off = out->sector * 512;
 
 	/*
-	 * The block device implements "barriers", where the Guest indicates
-	 * that it wants all previous writes to occur before this write.  We
-	 * don't have a way of asking our kernel to do a barrier, so we just
-	 * synchronize all the data in the file.  Pretty poor, no?
-	 */
-	if (out->type & VIRTIO_BLK_T_BARRIER)
-		fdatasync(vblk->fd);
-
-	/*
 	 * In general the virtio block driver is allowed to try SCSI commands.
 	 * It'd be nice if we supported eject, for example, but we don't.
 	 */
@@ -1679,6 +1670,19 @@ static void blk_request(struct virtqueue *vq)
 			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, ret);
 		}
+
+		/* Honor FUA by syncing everything. */
+		if (ret >= 0 && (out->type & VIRTIO_BLK_T_FUA)) {
+			ret = fdatasync(vblk->fd);
+			verbose("FUA fdatasync: %i\n", ret);
+		}
+
+		wlen = sizeof(*in);
+		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
+	} else if (out->type & VIRTIO_BLK_T_FLUSH) {
+		/* Flush */
+		ret = fdatasync(vblk->fd);
+		verbose("FLUSH fdatasync: %i\n", ret);
 		wlen = sizeof(*in);
 		*in = (ret >= 0 ? VIRTIO_BLK_S_OK : VIRTIO_BLK_S_IOERR);
 	} else {
@@ -1702,15 +1706,6 @@ static void blk_request(struct virtqueue *vq)
 		}
 	}
 
-	/*
-	 * OK, so we noted that it was pretty poor to use an fdatasync as a
-	 * barrier.  But Christoph Hellwig points out that we need a sync
-	 * *afterwards* as well: "Barriers specify no reordering to the front
-	 * or the back."  And Jens Axboe confirmed it, so here we are:
-	 */
-	if (out->type & VIRTIO_BLK_T_BARRIER)
-		fdatasync(vblk->fd);
-
 	/* Finished that request. */
 	add_used(vq, head, wlen);
 }
@@ -1735,8 +1730,9 @@ static void setup_block_file(const char *filename)
 	vblk->fd = open_or_die(filename, O_RDWR|O_LARGEFILE);
 	vblk->len = lseek64(vblk->fd, 0, SEEK_END);
 
-	/* We support barriers. */
-	add_feature(dev, VIRTIO_BLK_F_BARRIER);
+	/* We support FLUSH and FUA. */
+	add_feature(dev, VIRTIO_BLK_F_FLUSH);
+	add_feature(dev, VIRTIO_BLK_F_FUA);
 
 	/* Tell Guest how many sectors this device has. */
 	conf.capacity = cpu_to_le64(vblk->len / 512);
-- 
1.7.1


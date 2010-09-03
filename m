From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/41] lguest: replace VIRTIO_F_BARRIER support
	with VIRTIO_F_FLUSH support
Date: Fri,  3 Sep 2010 12:29:35 +0200
Message-ID: <1283509796-1510-21-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

VIRTIO_F_BARRIER is deprecated.  Replace it with VIRTIO_F_FLUSH
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>
---
 Documentation/lguest/lguest.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/Documentation/lguest/lguest.c b/Documentation/lguest/lguest.c
index 8a6a8c6..dc73bc5 100644
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1640,15 +1640,6 @@ static void blk_request(struct virtqueue *vq)
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
@@ -1680,6 +1671,13 @@ static void blk_request(struct virtqueue *vq)
 			/* Die, bad Guest, die. */
 			errx(1, "Write past end %llu+%u", off, ret);
 		}
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
@@ -1703,15 +1701,6 @@ static void blk_request(struct virtqueue *vq)
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
@@ -1736,8 +1725,8 @@ static void setup_block_file(const char *filename)
 	vblk->fd = open_or_die(filename, O_RDWR|O_LARGEFILE);
 	vblk->len = lseek64(vblk->fd, 0, SEEK_END);
 
-	/* We support barriers. */
-	add_feature(dev, VIRTIO_BLK_F_BARRIER);
+	/* We support FLUSH. */
+	add_feature(dev, VIRTIO_BLK_F_FLUSH);
 
 	/* Tell Guest how many sectors this device has. */
 	conf.capacity = cpu_to_le64(vblk->len / 512);
-- 
1.7.1

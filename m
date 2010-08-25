From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/30] virtio_blk: drop REQ_HARDBARRIER support
Date: Wed, 25 Aug 2010 17:47:32 +0200
Message-ID: <1282751267-3530-16-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Remove now unused REQ_HARDBARRIER support.  virtio_blk already
supports REQ_FLUSH and the usefulness of REQ_FUA for virtio_blk is
questionable at this point, so there's nothing else to do to support
new REQ_FLUSH/FUA interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/block/virtio_blk.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index d10b635..1260628 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -128,9 +128,6 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	if (vbr->req->cmd_flags & REQ_HARDBARRIER)
-		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
-
 	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
 	/*
@@ -388,13 +385,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->driverfs_dev = &vdev->dev;
 	index++;
 
-	/*
-	 * If the FLUSH feature is supported we do have support for
-	 * flushing a volatile write cache on the host.  Use that to
-	 * implement write barrier support; otherwise, we must assume
-	 * that the host does not perform any kind of volatile write
-	 * caching.
-	 */
+	/* configure queue flush support */
 	if (virtio_has_feature(vdev, VIRTIO_BLK_F_FLUSH))
 		blk_queue_flush(q, REQ_FLUSH);
 
@@ -515,9 +506,9 @@ static const struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_BLK_F_BARRIER, VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX,
-	VIRTIO_BLK_F_GEOMETRY, VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE,
-	VIRTIO_BLK_F_SCSI, VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
+	VIRTIO_BLK_F_SEG_MAX, VIRTIO_BLK_F_SIZE_MAX, VIRTIO_BLK_F_GEOMETRY,
+	VIRTIO_BLK_F_RO, VIRTIO_BLK_F_BLK_SIZE, VIRTIO_BLK_F_SCSI,
+	VIRTIO_BLK_F_FLUSH, VIRTIO_BLK_F_TOPOLOGY
 };
 
 /*
-- 
1.7.1

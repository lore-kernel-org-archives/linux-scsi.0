From: mchristi@redhat.com
Subject: [PATCH 22/32] block/fs/drivers: set bi_op to REQ_OP
Date: Wed,  4 Nov 2015 16:08:19 -0600
Message-ID: <1446674909-5371-23-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch sets the bi_op to a REQ_OP for users where it
was a simple one line change.

For compat reasons, we are still ORing the op into bi_rw. This
will be dropped in later patches in this series when everyone
is updated.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/pktcdvd.c            | 2 ++
 drivers/md/dm-crypt.c              | 1 +
 drivers/md/dm.c                    | 1 +
 drivers/scsi/osd/osd_initiator.c   | 4 ++++
 drivers/target/target_core_pscsi.c | 4 +++-
 fs/btrfs/volumes.c                 | 1 +
 fs/exofs/ore.c                     | 1 +
 7 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 7be2375..bbb7a45 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1075,6 +1075,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 		atomic_inc(&pkt->io_wait);
 		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 		pkt_queue_bio(pd, bio);
 		frames_read++;
 	}
@@ -1337,6 +1338,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	/* Start the write request */
 	atomic_set(&pkt->io_wait, 1);
 	pkt->w_bio->bi_rw = WRITE;
+	pkt->w_bio->bi_op = REQ_OP_WRITE;
 	pkt_queue_bio(pd, pkt->w_bio);
 }
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4b3b6f8..92689e5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1132,6 +1132,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
 	clone->bi_private = io;
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
+	clone->bi_op      = io->base_bio->bi_op;
 	clone->bi_rw      = io->base_bio->bi_rw;
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b5c604..d2cf6d9 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2329,6 +2329,7 @@ static struct mapped_device *alloc_dev(int minor)
 
 	bio_init(&md->flush_bio);
 	md->flush_bio.bi_bdev = md->bdev;
+	md->flush_bio.bi_op = REQ_OP_WRITE;
 	md->flush_bio.bi_rw = WRITE_FLUSH;
 
 	dm_stats_init(&md->stats);
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 0cccd60..ca7b4b6 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -729,6 +729,7 @@ static int _osd_req_list_objects(struct osd_request *or,
 		return PTR_ERR(bio);
 	}
 
+	bio->bi_op = REQ_OP_READ;
 	bio->bi_rw &= ~REQ_WRITE;
 	or->in.bio = bio;
 	or->in.total_bytes = bio->bi_iter.bi_size;
@@ -842,6 +843,7 @@ int osd_req_write_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw |= REQ_WRITE; /* FIXME: bio_set_dir() */
 	osd_req_write(or, obj, offset, bio, len);
 	return 0;
@@ -959,6 +961,7 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw |= REQ_WRITE;
 
 	/* integrity check the continuation before the bio is linked
@@ -1080,6 +1083,7 @@ int osd_req_write_sg_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw |= REQ_WRITE;
 	osd_req_write_sg(or, obj, bio, sglist, numentries);
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index de18790..00a7bda5 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -921,8 +921,10 @@ pscsi_map_sg(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 				if (!bio)
 					goto fail;
 
-				if (rw)
+				if (rw) {
+					bio->bi_op = REQ_OP_WRITE;
 					bio->bi_rw |= REQ_WRITE;
+				}
 
 				pr_debug("PSCSI: Allocated bio: %p,"
 					" dir: %s nr_vecs: %d\n", bio,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3dfac71..ef67c2f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5847,6 +5847,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	atomic_inc(&root->fs_info->nr_async_bios);
 	WARN_ON(bio->bi_next);
 	bio->bi_next = NULL;
+	bio->bi_op = op;
 	bio->bi_rw |= op | op_flags;
 
 	spin_lock(&device->io_lock);
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 7bd8ac8..7339bef 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -878,6 +878,7 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 			} else {
 				bio = master_dev->bio;
 				/* FIXME: bio_set_dir() */
+				bio->bi_op = REQ_OP_WRITE;
 				bio->bi_rw |= REQ_WRITE;
 			}
 
-- 
1.8.3.1

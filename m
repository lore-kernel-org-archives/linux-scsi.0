From: mchristi@redhat.com
Subject: [PATCH 05/32] drbd: prepare drbd for bi_rw split
Date: Wed,  4 Nov 2015 10:33:00 -0600
Message-ID: <1446654807-6935-6-git-send-email-mchristi@redhat.com>
References: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446654807-6935-1-git-send-email-mchristi@redhat.com>
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

This patch prepares drbd's submit_bio use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bio calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
modify the actual submit_bio call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/drbd/drbd_actlog.c | 30 ++++++++++++++++--------------
 drivers/block/drbd/drbd_bitmap.c |  4 ++--
 drivers/block/drbd/drbd_int.h    |  2 +-
 drivers/block/drbd/drbd_main.c   |  5 +++--
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index b3868e7..c290e8b 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -137,19 +137,19 @@ void wait_until_done_or_force_detached(struct drbd_device *device, struct drbd_b
 
 static int _drbd_md_sync_page_io(struct drbd_device *device,
 				 struct drbd_backing_dev *bdev,
-				 sector_t sector, int rw)
+				 sector_t sector, int op)
 {
 	struct bio *bio;
 	/* we do all our meta data IO in aligned 4k blocks. */
 	const int size = 4096;
-	int err;
+	int err, op_flags = 0;
 
 	device->md_io.done = 0;
 	device->md_io.error = -ENODEV;
 
-	if ((rw & WRITE) && !test_bit(MD_NO_FUA, &device->flags))
-		rw |= REQ_FUA | REQ_FLUSH;
-	rw |= REQ_SYNC | REQ_NOIDLE;
+	if ((op == REQ_OP_WRITE) && !test_bit(MD_NO_FUA, &device->flags))
+		op_flags |= REQ_FUA | REQ_FLUSH;
+	op_flags |= REQ_SYNC | REQ_NOIDLE;
 
 	bio = bio_alloc_drbd(GFP_NOIO);
 	bio->bi_bdev = bdev->md_bdev;
@@ -159,9 +159,9 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 		goto out;
 	bio->bi_private = device;
 	bio->bi_end_io = drbd_md_endio;
-	bio->bi_rw = rw;
+	bio->bi_rw = op | op_flags;
 
-	if (!(rw & WRITE) && device->state.disk == D_DISKLESS && device->ldev == NULL)
+	if (op != REQ_OP_WRITE && device->state.disk == D_DISKLESS && device->ldev == NULL)
 		/* special case, drbd_md_read() during drbd_adm_attach(): no get_ldev */
 		;
 	else if (!get_ldev_if_state(device, D_ATTACHING)) {
@@ -174,10 +174,10 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	bio_get(bio); /* one bio_put() is in the completion handler */
 	atomic_inc(&device->md_io.in_use); /* drbd_md_put_buffer() is in the completion handler */
 	device->md_io.submit_jif = jiffies;
-	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
+	if (drbd_insert_fault(device, (op == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_io_error(bio);
 	else
-		submit_bio(rw, bio);
+		submit_bio(op | op_flags, bio);
 	wait_until_done_or_force_detached(device, bdev, &device->md_io.done);
 	if (!bio->bi_error)
 		err = device->md_io.error;
@@ -188,7 +188,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 }
 
 int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bdev,
-			 sector_t sector, int rw)
+			 sector_t sector, int op)
 {
 	int err;
 	D_ASSERT(device, atomic_read(&device->md_io.in_use) == 1);
@@ -197,19 +197,21 @@ int drbd_md_sync_page_io(struct drbd_device *device, struct drbd_backing_dev *bd
 
 	dynamic_drbd_dbg(device, "meta_data io: %s [%d]:%s(,%llus,%s) %pS\n",
 	     current->comm, current->pid, __func__,
-	     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ",
+	     (unsigned long long)sector, (op == REQ_OP_WRITE) ? "WRITE" : "READ",
 	     (void*)_RET_IP_ );
 
 	if (sector < drbd_md_first_sector(bdev) ||
 	    sector + 7 > drbd_md_last_sector(bdev))
 		drbd_alert(device, "%s [%d]:%s(,%llus,%s) out of range md access!\n",
 		     current->comm, current->pid, __func__,
-		     (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ");
+		     (unsigned long long)sector,
+		     (op == REQ_OP_WRITE) ? "WRITE" : "READ");
 
-	err = _drbd_md_sync_page_io(device, bdev, sector, rw);
+	err = _drbd_md_sync_page_io(device, bdev, sector, op);
 	if (err) {
 		drbd_err(device, "drbd_md_sync_page_io(,%llus,%s) failed with error %d\n",
-		    (unsigned long long)sector, (rw & WRITE) ? "WRITE" : "READ", err);
+		    (unsigned long long)sector,
+		    (op == REQ_OP_WRITE) ? "WRITE" : "READ", err);
 	}
 	return err;
 }
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index e5e0f19..7ea1502 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -988,7 +988,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	struct drbd_bitmap *b = device->bitmap;
 	struct page *page;
 	unsigned int len;
-	unsigned int rw = (ctx->flags & BM_AIO_READ) ? READ : WRITE;
+	unsigned int rw = (ctx->flags & BM_AIO_READ) ? REQ_OP_READ : REQ_OP_WRITE;
 
 	sector_t on_disk_sector =
 		device->ldev->md.md_offset + device->ldev->md.bm_offset;
@@ -1020,7 +1020,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	bio->bi_private = ctx;
 	bio->bi_end_io = drbd_bm_endio;
 
-	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
+	if (drbd_insert_fault(device, (rw == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
 		bio->bi_rw |= rw;
 		bio_io_error(bio);
 	} else {
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 015c6e9..2934481 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1494,7 +1494,7 @@ extern int drbd_resync_finished(struct drbd_device *device);
 extern void *drbd_md_get_buffer(struct drbd_device *device, const char *intent);
 extern void drbd_md_put_buffer(struct drbd_device *device);
 extern int drbd_md_sync_page_io(struct drbd_device *device,
-		struct drbd_backing_dev *bdev, sector_t sector, int rw);
+		struct drbd_backing_dev *bdev, sector_t sector, int op);
 extern void drbd_ov_out_of_sync_found(struct drbd_device *, sector_t, int);
 extern void wait_until_done_or_force_detached(struct drbd_device *device,
 		struct drbd_backing_dev *bdev, unsigned int *done);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 74d97f4..9eb8039 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3080,7 +3080,7 @@ void drbd_md_write(struct drbd_device *device, void *b)
 	D_ASSERT(device, drbd_md_ss(device->ldev) == device->ldev->md.md_offset);
 	sector = device->ldev->md.md_offset;
 
-	if (drbd_md_sync_page_io(device, device->ldev, sector, WRITE)) {
+	if (drbd_md_sync_page_io(device, device->ldev, sector, REQ_OP_WRITE)) {
 		/* this was a try anyways ... */
 		drbd_err(device, "meta data update failed!\n");
 		drbd_chk_io_error(device, 1, DRBD_META_IO_ERROR);
@@ -3278,7 +3278,8 @@ int drbd_md_read(struct drbd_device *device, struct drbd_backing_dev *bdev)
 	bdev->md.meta_dev_idx = bdev->disk_conf->meta_dev_idx;
 	bdev->md.md_offset = drbd_md_ss(bdev);
 
-	if (drbd_md_sync_page_io(device, bdev, bdev->md.md_offset, READ)) {
+	if (drbd_md_sync_page_io(device, bdev, bdev->md.md_offset,
+				 REQ_OP_READ)) {
 		/* NOTE: can't do normal error processing here as this is
 		   called BEFORE disk is attached */
 		drbd_err(device, "Error while reading metadata.\n");
-- 
1.8.3.1

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 06/10 resend] libosd: osd_req_{read,write} takes a length parameter
Date: Sun, 24 May 2009 20:04:26 +0300
Message-ID: <1243184666-17062-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:1242 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753993AbZEXRE1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:04:27 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

For supporting of chained-bios we can not inspect the first
bio only, as before. Caller shall pass the total length of the
request, ie. sum_bytes(bio-chain).

Also since the bio might be a chain we don't set it's direction
on behalf of it's callers. The bio direction should be properly
set prior to this call. So fix a couple of write users that now
need to set the bio direction properly

[In this patch I change both library code and user sites at
 exofs, to make it easy on integration. It should be submitted
 via James's scsi-misc tree.]

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Jeff Garzik <jeff@garzik.org>
---
 drivers/scsi/osd/osd_initiator.c |   23 +++++++++++++----------
 fs/exofs/inode.c                 |    5 +++--
 include/scsi/osd_initiator.h     |    4 ++--
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index ba2ebae..3f5ec57 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -779,13 +779,14 @@ EXPORT_SYMBOL(osd_req_remove_object);
 */
 
 void osd_req_write(struct osd_request *or,
-	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
+	const struct osd_obj_id *obj, u64 offset,
+	struct bio *bio, u64 len)
 {
-	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, bio->bi_size);
+	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, len);
 	WARN_ON(or->out.bio || or->out.total_bytes);
-	bio->bi_rw |= (1 << BIO_RW);
+	WARN_ON(0 ==  bio_rw_flagged(bio, BIO_RW));
 	or->out.bio = bio;
-	or->out.total_bytes = bio->bi_size;
+	or->out.total_bytes = len;
 }
 EXPORT_SYMBOL(osd_req_write);
 
@@ -798,7 +799,8 @@ int osd_req_write_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	osd_req_write(or, obj, bio, offset);
+	bio->bi_rw |= (1 << BIO_RW); /* FIXME: bio_set_dir() */
+	osd_req_write(or, obj, offset, bio, len);
 	return 0;
 }
 EXPORT_SYMBOL(osd_req_write_kern);
@@ -828,13 +830,14 @@ void osd_req_flush_object(struct osd_request *or,
 EXPORT_SYMBOL(osd_req_flush_object);
 
 void osd_req_read(struct osd_request *or,
-	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
+	const struct osd_obj_id *obj, u64 offset,
+	struct bio *bio, u64 len)
 {
-	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, bio->bi_size);
+	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, len);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	bio->bi_rw &= ~(1 << BIO_RW);
+	WARN_ON(1 == bio_rw_flagged(bio, BIO_RW));
 	or->in.bio = bio;
-	or->in.total_bytes = bio->bi_size;
+	or->in.total_bytes = len;
 }
 EXPORT_SYMBOL(osd_req_read);
 
@@ -847,7 +850,7 @@ int osd_req_read_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	osd_req_read(or, obj, bio, offset);
+	osd_req_read(or, obj, offset, bio, len);
 	return 0;
 }
 EXPORT_SYMBOL(osd_req_read_kern);
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index ba8d9fa..f79e8e5 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -266,7 +266,7 @@ static int read_exec(struct page_collect *pcol, bool is_sync)
 		goto err;
 	}
 
-	osd_req_read(or, &obj, pcol->bio, i_start);
+	osd_req_read(or, &obj, i_start, pcol->bio, pcol->length);
 
 	if (is_sync) {
 		exofs_sync_op(or, pcol->sbi->s_timeout, oi->i_cred);
@@ -522,7 +522,8 @@ static int write_exec(struct page_collect *pcol)
 
 	*pcol_copy = *pcol;
 
-	osd_req_write(or, &obj, pcol_copy->bio, i_start);
+	pcol_copy->bio->bi_rw |= (1 << BIO_RW); /* FIXME: bio_set_dir() */
+	osd_req_write(or, &obj, i_start, pcol_copy->bio, pcol_copy->length);
 	ret = exofs_async_op(or, writepages_done, pcol_copy, oi->i_cred);
 	if (unlikely(ret)) {
 		EXOFS_ERR("write_exec: exofs_async_op() Faild\n");
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 6132790..8c1e3b8 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -363,7 +363,7 @@ void osd_req_create_object(struct osd_request *or, struct osd_obj_id *);
 void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *);
 
 void osd_req_write(struct osd_request *or,
-	const struct osd_obj_id *, struct bio *data_out, u64 offset);
+	const struct osd_obj_id *obj, u64 offset, struct bio *bio, u64 len);
 int osd_req_write_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 void osd_req_append(struct osd_request *or,
@@ -380,7 +380,7 @@ void osd_req_flush_object(struct osd_request *or,
 	/*V2*/ u64 offset, /*V2*/ u64 len);
 
 void osd_req_read(struct osd_request *or,
-	const struct osd_obj_id *, struct bio *data_in, u64 offset);
+	const struct osd_obj_id *obj, u64 offset, struct bio *bio, u64 len);
 int osd_req_read_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 
-- 
1.6.2.1


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170903;
	b=GLcwRkFbM2nOrVtFshmJB3jWTs5KmxfFz+VZxTqJYYeGq5VtpQdu/0m60iI31lvdQ+5I
	 a1YMTu9EgGD09yVWhNT34fk+oYxT8cDa1yh4Asn+lxmpeopF07/60y1NhAqFS9hERVpNs
	 nUgWaH6mYp2zcM8Vl4cK/VsD7zN2NojrIH7G13DDCzjS0oGjT39vFPN9kLr45VIkJBOpK
	 cMad/XXszxZoldxLXsXxm7MvpA/LZA54zFZJQcqgHTJY1Nt2RqDsemsoU1BcKpilaNBL1
	 qXCyQRZNmCeqoPLXaYV7yQ0JFJyaAa3cXdLItQyuV+SRzbWNOXWSTZwE8/sqaJdqyJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170903;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MyAWQuhn8V+44YfsjM97mHie938UeW0L0TmwXewiVmM=;
	b=cbTTo7qqv/1zwWBOvogH+qQ9+ASdWb0kj0c6bRB2HD9eDtZJrwOp1vxzgpVc8CVDKvAX
	 GNfgDu8DzGiBIlImRL7wX2F7kRWjG14iZHQq90xKbe9gjWhu4B4HRdLbqscEV+gmNzOFu
	 euiuILlV9dqxoYBOySC41ALYW40fWxpz8i10PgJS+mpgmxbztRJ0K3DY/RXvWhYyF5I3B
	 wAdHyEzs8ZoBqiddF05Tb1ZRyM6sBU4hTQwQZb7Wunp5TkUeO9LO8vYB8miwcSlvqkSnS
	 NHbLSXs6XfJw2Y0io15sI3/eRzdKHPUOmfjukg2VrRtBIlQ0qKqBEYPQvKpslUK+QZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=khlhW9ub;
	arc=none smtp.remote-ip=95.215.58.132
Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67535606A33B
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67535606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=khlhW9ub
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5TahV5Bolvu7HAVTbNzS+a27asy7oEz9GforUDQb/qY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170900; v=1; x=1794775700;
 b=khlhW9ubhSx5/iSC0kXlG6C8XUkpZA1X4tPVj9g2/p+J8vtY12Kjo+IDe4AuM5X8g6mKlTyx
 +3sz/qdRki2CYvq+/1Y2Kizoj5r3P8mjFwV8WDcDqgSMxbrOKjSJjqUgbfyoT7S3/UrXYiSDrmr
 lmENqV00kpWWMTVMr6sf4uns=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 1cc8975d10d3d544;
	Sun, 08 Nov 2026 20:48:20 +0000
X-Mizu-Trace-ID: 1cc8975d10d3d544
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 21/29] scsi-multipath: add scsi_mpath_{start,end}_request()
Date: Sun,  8 Nov 2026 20:47:25 +0000
Message-ID: <20261108204733.557995-22-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

New member Scsi_Host.mpath_nr_active is added. This is required for queue
depth multipath iopolicy.

For NVMe, this count is per controller. The reason is that many NSes may
be connected to a controller, so congestion should be judged at
controller level.

SCSI has no definition of a controller, but SCSI host is a comparable
concept.

Indeed, many SCSI disks may be connected to the same SCSI host, so it
makes sense to count number of active requests at this point. However,
for a transport like iSCSI Initiator over TCP/IP, we have a separate SCSI
host per SCSI device (so there the count would be same at SCSI device
level).

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  8 +++-
 drivers/scsi/scsi_multipath.c | 69 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h      |  9 ++++-
 include/scsi/scsi_host.h      |  4 ++
 include/scsi/scsi_multipath.h | 11 ++++++
 5 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4dbd01484b4a..13562c0ab48b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
-	if (blk_update_request(req, error, bytes))
+	if (sdev->scsi_mpath_dev && is_mpath_request(req)) {
+		if (scsi_mpath_end_request(req, error, bytes))
+			return true;
+	} else if (blk_update_request(req, error, bytes))
 		return true;
 
 	if (q->limits.features & BLK_FEAT_ADD_RANDOM)
@@ -1947,6 +1950,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
+	if (sdev->scsi_mpath_dev && is_mpath_request(req))
+		scsi_mpath_start_request(req);
+
 	blk_mq_start_request(req);
 	if (blk_mq_is_reserved_rq(req)) {
 		reason = shost->hostt->queue_reserved_command(shost, cmd);
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 2f47c39d8293..93a4545f1dbf 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -545,6 +545,75 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scsi_mpath_head)
 }
 EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
 
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_mpath_device *scsi_mpath_dev = sdev->scsi_mpath_dev;
+	struct scsi_mpath_head *scsi_mpath_head =
+				scsi_mpath_dev->scsi_mpath_head;
+	struct bio *clone = req->bio, *master;
+	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
+	struct gendisk *disk = mpath_head->disk;
+
+	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
+	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_inc(&shost->mpath_nr_active);
+		scmd->flags |= SCMD_MPATH_CNT_ACTIVE;
+	}
+
+	if (blk_rq_is_passthrough(req) || !blk_queue_io_stat(disk->queue))
+		return;
+
+	if (!clone) {
+		scmd->flags &= ~SCMD_MPATH_IO_STATS;
+		return;
+	}
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS)
+		return;
+
+	master = clone->bi_private;
+
+	scmd->flags |= SCMD_MPATH_IO_STATS;
+	scmd->start_time = bdev_start_io_acct(master->bi_bdev, req_op(req),
+				jiffies);
+	scmd->start_bytes = blk_rq_bytes(req);
+}
+
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+				unsigned int nr_bytes)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct block_device *bi_bdev = NULL;
+
+	if (scmd->flags & SCMD_MPATH_IO_STATS) {
+		struct bio *clone = req->bio, *master = clone->bi_private;
+
+		bi_bdev = master->bi_bdev;
+	}
+
+	if (blk_update_request(req, error, nr_bytes))
+		return true;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return false;
+	bdev_end_io_acct(bi_bdev, req_op(req),
+			 scmd->start_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+
+	return false;
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 5a8f7a45dc6d..62ffd33ba7ea 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -58,8 +58,11 @@ struct scsi_pointer {
  */
 #define SCMD_FORCE_EH_SUCCESS	(1 << 3)
 #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
+#define SCMD_MPATH_IO_STATS	(1 << 5)
+#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)
 /* flags preserved across unprep / reprep */
-#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
+#define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING | \
+				SCMD_MPATH_IO_STATS | SCMD_MPATH_CNT_ACTIVE)
 
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE	0
@@ -146,6 +149,10 @@ struct scsi_cmnd {
 					 * to release this memory.  (The memory
 					 * obtained by scsi_malloc is guaranteed
 					 * to be at an address < 16Mb). */
+	#ifdef CONFIG_SCSI_MULTIPATH
+	unsigned long		start_time;
+	unsigned int		start_bytes;
+	#endif
 
 	int result;		/* Status code from lower level driver */
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index daaf1247673f..8cbca6b75732 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -756,6 +756,10 @@ struct Scsi_Host {
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 
+	#ifdef CONFIG_SCSI_MULTIPATH
+	atomic_t mpath_nr_active;
+	#endif
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index 6e50da94fc5d..dca1307c9fa4 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -57,6 +57,9 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
 void scsi_mpath_dev_clear_path(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
+void scsi_mpath_start_request(struct request *req);
+bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -109,5 +112,13 @@ static inline
 void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev)
 {
 }
+static inline void scsi_mpath_start_request(struct request *req)
+{
+}
+static inline bool scsi_mpath_end_request(struct request *req, blk_status_t error,
+			       unsigned int nr_bytes)
+{
+	return false;
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.0


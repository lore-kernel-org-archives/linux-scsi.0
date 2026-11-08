Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170903;
	b=OV4YddGj/D74TdTR9FaMkfy9Hy/VTILQgHwCZInfdB9RlMv8vm6cavE/BclMf/2Gbc/x
	 iu1oxSwy/qiBFU8nDRXFfCIeUaI9on2Ry/0xEA9gnF+9D0RkFuqa7dxSjo7ul6uGMcRXM
	 dn2cgofKSWlBQCTFjHCHA2TblpQ+0MmSF5aJoU5lSSGqOnbeplNYwrbu2Kd7DVmcn+3FQ
	 5coCPunQxwQ5H9iYK0+s/alMCGtL04h1tGJpRaqGkonnLgnQYsBPreJQpnio0Fn6xBqZ1
	 r6yNIJbc8L2Ek0Ld3QdW9/KnzJXrAQgj0UGwrp5EoUDrMAx2DLwMOsHRQrJlQKKWnGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170903;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=djFhY6HrcugeDpQwTBeqH0wZRhMZ8g8NzZbKP0h6x10=;
	b=EnjVNUbjWSAyrqjYS7Rv/jm9r331+UIjt0O/P4dRktAjKyutrciE5SqWF6BPz59aHX9I
	 smi+pD+FCHK/WX7RYPEDtieU/ArNpT93lnRWvznP/+KF14N1XOZ7xtytW3kz8U0KxnBXA
	 e/PfvABht1P85HgvhU6dv4thanAeECBq2eJKTREwsC873m1MkPYSLMRbV9uQO+kjbYnoR
	 Ln4ot2lh2H0WOwrmsFPuUWZlCAAfv8B/eJP8WdaMVNYTPcB7a0tO+C49UIgIGkexb1aaj
	 OmRN3gDUNu1A5Mxr1JQF+P1qOibqgqUbne0nXzHBimxsT52TnVo5QG1iwq/wynicvdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LWvEao3h;
	arc=none smtp.remote-ip=91.218.175.58
Received: from mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA9F606D81B
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DA9F606D81B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LWvEao3h
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VPDIuqnyTg2xDal4wGmjULrT9obL2CYqMohvVopWv8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170901; v=1; x=1794775701;
 b=LWvEao3hU1X6wjvd723ICY/1A3hYV3FwBCHkaeL5hzX7UfEQYXS/oOS1VfzGv43oUBHzkevb
 /HoflbrEqLXqQsgRMQpEbLcXE7d/bwnkMuxZGjvtwO7AKMg67A5bjiukviY3IRwNRhm/YEsMPVq
 Nd8yw/tb/X6eFdL3+0MlQr9Y=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id d9db4c546fa1030a;
	Sun, 08 Nov 2026 20:48:21 +0000
X-Mizu-Trace-ID: d9db4c546fa1030a
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
Subject: [PATCH v9 22/29] scsi-multipath: update request for terminal request queuing error
Date: Sun,  8 Nov 2026 20:47:26 +0000
Message-ID: <20261108204733.557995-23-john.garry@linux.dev>
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

If we cannot queue a request in scsi_queue_rq(), then we may error out
with an error code which means that the block layer ends the request (and
does not requeue). Such an error scenario would be scsi_device transport
offline.

In this case, we should update the request to deal with when
SCMD_MPATH_IO_STATS and SCMD_MPATH_IO_STATS flags have been set.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_lib.c       |  3 +++
 drivers/scsi/scsi_multipath.c | 35 +++++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  5 +++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 13562c0ab48b..a5a2967d17a2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1996,6 +1996,9 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 			cmd->result = DID_NO_CONNECT << 16;
 		else
 			cmd->result = DID_ERROR << 16;
+
+		if (sdev->scsi_mpath_dev && is_mpath_request(req))
+			scsi_mpath_end_request_no_update(req, ret);
 		/*
 		 * Make sure to release all allocated resources when
 		 * we hit an error, as we will never see this command
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index 93a4545f1dbf..bec6dd94f3be 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -614,6 +614,41 @@ bool scsi_mpath_end_request(struct request *req, blk_status_t error,
 	return false;
 }
 
+void scsi_mpath_end_request_no_update(struct request *req, blk_status_t error)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct bio *clone = req->bio, *master = clone->bi_private;
+	struct block_device *bi_bdev = master->bi_bdev;
+	unsigned int nr_bytes;
+
+	/* Don't generate error logs if we are going to try another path */
+	if (blk_path_error(error))
+		req->rq_flags |= RQF_QUIET;
+
+	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
+		struct Scsi_Host *shost = sdev->host;
+
+		atomic_dec_if_positive(&shost->mpath_nr_active);
+	}
+
+	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
+		return;
+
+	/*
+	 * blk_rq_bytes() value should never exceed start_bytes, but check in
+	 * case.
+	 */
+	if (scmd->start_bytes > blk_rq_bytes(req))
+		nr_bytes = scmd->start_bytes - blk_rq_bytes(req);
+	else
+		nr_bytes = 0;
+
+	bdev_end_io_acct(bi_bdev, req_op(req),
+			 nr_bytes >> SECTOR_SHIFT,
+			 scmd->start_time);
+}
+
 int __init scsi_multipath_init(void)
 {
 	return class_register(&scsi_mpath_device_class);
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index dca1307c9fa4..72ad109a9a81 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -60,6 +60,7 @@ void scsi_mpath_revalidate_paths(struct scsi_mpath_device *scsi_mpath_dev);
 void scsi_mpath_start_request(struct request *req);
 bool scsi_mpath_end_request(struct request *req, blk_status_t error,
 			       unsigned int nr_bytes);
+void scsi_mpath_end_request_no_update(struct request *req, blk_status_t error);
 #else /* CONFIG_SCSI_MULTIPATH */
 
 struct scsi_mpath_head {
@@ -120,5 +121,9 @@ static inline bool scsi_mpath_end_request(struct request *req, blk_status_t erro
 {
 	return false;
 }
+static inline void scsi_mpath_end_request_no_update(struct request *req,
+				blk_status_t error)
+{
+}
 #endif /* CONFIG_SCSI_MULTIPATH */
 #endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.43.0


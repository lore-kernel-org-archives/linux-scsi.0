Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704201EEF9
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253352; cv=none; b=uHQcWl76NZLvz9W31ufDGBw69UIbYx1dsH81cJ1t3ynnxtIbYAtKKxED/KlJ2cKQXC3CixttOldGYmNh8hxzJAlIWQeFAdoz3Y23TUGY511L6lfNIfykzkWKXCFTx9G+C3y3hKmHHHWAaD6MtxH3AYYD682tOLvScw+/cyiFvlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253352; c=relaxed/simple;
	bh=RpG+MweoX3kajQv8EdYSe7ocXyXwF2mv8AM2nDB77o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e95+HnD7bI9tQHGx5WEf9pHNhfr+3W5dBXXhlgGohofW5zHbR4z9jVXNCekU00hK2mipJT0shxq4uuBZsdM+wYKJEVPre7k0iy+ADz7LcKZMUKbEjNnoOfxxrs/9zx50MGzAqvGrJ6M/1GsPoEb3405jlhjy0Qfjg/WBq1IBedU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hdiH2Zjq; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hdiH2Zjq"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPys46r5zm174B;
	Wed, 27 Aug 2025 00:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253348; x=1758845349; bh=4PRVg
	JOcqxAPafag14B/0WuRMkumUxPBTCMOMX9VFIs=; b=hdiH2Zjq5sO9gF1LS3bOn
	DEBcVobAu3t06GBHJenoMhdeWatqLuZPxke63P7r+fKUhZsxeG5erMRYCOzLcBQ2
	tGBhJcFA+PNzOhzrjnrLCSR/b1RRmcugPQZHKxwZsYFMJC/FWEnVNN7HrFrVYxxx
	1r8dV14ioZ3CRbNwPsAs5Y5Bquk3P89sDmaTbXyY/8QBSrwbtBRWwPRw8dNGu6Ig
	gxIR7ljY/KqvvVtPoRIj2wkZhgCxyDuer2QyFpYA/EeLlx+T+ON+OYWAuXE9IiBK
	g06gHQglcgf5H2bgqQHmGIxeAdVuz3NoemTgunKJODr9xolvzjHIM1tsyitDzESm
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MBBh8mJjGImJ; Wed, 27 Aug 2025 00:09:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPyl6wwDzm0ySM;
	Wed, 27 Aug 2025 00:09:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 05/26] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
Date: Tue, 26 Aug 2025 17:06:09 -0700
Message-ID: <20250827000816.2370150-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Hannes Reinecke <hare@suse.de>

Add helper functions to allow LLDDs to allocate and free internal command=
s.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: changed the 'nowait' argument into a 'flags' argument /
  added scsi_get_internal_cmd_hctx(). See also
  https://lore.kernel.org/linux-scsi/20211125151048.103910-3-hare@suse.de=
/ ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 80 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_cmnd.h   |  2 +
 include/scsi/scsi_device.h |  7 ++++
 3 files changed, 89 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2d81fd837d47..c988e6f8194b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1247,6 +1247,18 @@ struct request *scsi_alloc_request(struct request_=
queue *q, blk_opf_t opf,
 }
 EXPORT_SYMBOL_GPL(scsi_alloc_request);
=20
+struct request *scsi_alloc_request_hctx(struct request_queue *q, blk_opf=
_t opf,
+			blk_mq_req_flags_t flags, unsigned int hctx_idx)
+{
+	struct request *rq;
+
+	rq =3D blk_mq_alloc_request_hctx(q, opf, flags, hctx_idx);
+	if (!IS_ERR(rq))
+		scsi_initialize_rq(rq);
+	return rq;
+}
+EXPORT_SYMBOL_GPL(scsi_alloc_request_hctx);
+
 /*
  * Only called when the request isn't completed by SCSI, and not freed b=
y
  * SCSI
@@ -2139,6 +2151,74 @@ void scsi_mq_free_tags(struct kref *kref)
 	complete(&shost->tagset_freed);
 }
=20
+/**
+ * scsi_get_internal_cmd() - Allocate an internal SCSI command.
+ * @sdev: SCSI device from which to allocate the command
+ * @data_direction: Data direction for the allocated command
+ * @flags: request allocation flags, e.g. BLK_MQ_REQ_RESERVED or
+ *	BLK_MQ_REQ_NOWAIT.
+ *
+ * Allocates a SCSI command for internal LLDD use.
+ */
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags)
+{
+	enum req_op op =3D data_direction =3D=3D DMA_TO_DEVICE ? REQ_OP_DRV_OUT=
 :
+							   REQ_OP_DRV_IN;
+	struct scsi_cmnd *scmd;
+	struct request *rq;
+
+	rq =3D scsi_alloc_request(sdev->request_queue, op, flags);
+	if (IS_ERR(rq))
+		return NULL;
+	scmd =3D blk_mq_rq_to_pdu(rq);
+	scmd->device =3D sdev;
+
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
+
+/**
+ * scsi_get_internal_cmd_hctx() - Allocate an internal SCSI command from=
 a given
+ *	hardware queue.
+ * @sdev: SCSI device from which to allocate the command
+ * @data_direction: Data direction for the allocated command
+ * @flags: request allocation flags, e.g. BLK_MQ_REQ_RESERVED or
+ *	BLK_MQ_REQ_NOWAIT.
+ * @hctx_idx: Hardware queue index.
+ *
+ * Allocates a SCSI command for internal LLDD use.
+ */
+struct scsi_cmnd *scsi_get_internal_cmd_hctx(struct scsi_device *sdev,
+			enum dma_data_direction data_direction,
+			blk_mq_req_flags_t flags, unsigned int hctx_idx)
+{
+	enum req_op op =3D data_direction =3D=3D DMA_TO_DEVICE ? REQ_OP_DRV_OUT=
 :
+							   REQ_OP_DRV_IN;
+	struct scsi_cmnd *scmd;
+	struct request *rq;
+
+	rq =3D scsi_alloc_request_hctx(sdev->request_queue, op, flags, hctx_idx=
);
+	if (IS_ERR(rq))
+		return NULL;
+	scmd =3D blk_mq_rq_to_pdu(rq);
+	scmd->device =3D sdev;
+
+	return scmd;
+}
+EXPORT_SYMBOL_GPL(scsi_get_internal_cmd_hctx);
+
+/**
+ * scsi_put_internal_cmd() - Free an internal SCSI command.
+ * @scmd: SCSI command to be freed
+ */
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
+{
+	blk_mq_free_request(blk_mq_rq_from_pdu(scmd));
+}
+EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
+
 /**
  * scsi_device_from_queue - return sdev associated with a request_queue
  * @q: The request queue to return the sdev from
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db..a4cb836809df 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -396,5 +396,7 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, =
int desc,
=20
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t op=
f,
 				   blk_mq_req_flags_t flags);
+struct request *scsi_alloc_request_hctx(struct request_queue *q, blk_opf=
_t opf,
+			blk_mq_req_flags_t flags, unsigned int hctx_idx);
=20
 #endif /* _SCSI_SCSI_CMND_H */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3846f5dfc51c..1d83b17d95e6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -558,6 +558,13 @@ int scsi_execute_cmd(struct scsi_device *sdev, const=
 unsigned char *cmd,
 		     const struct scsi_exec_args *args);
 void scsi_failures_reset_retries(struct scsi_failures *failures);
=20
+struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
+					enum dma_data_direction data_direction,
+					blk_mq_req_flags_t flags);
+struct scsi_cmnd *scsi_get_internal_cmd_hctx(struct scsi_device *sdev,
+			enum dma_data_direction data_direction,
+			blk_mq_req_flags_t flags, unsigned int hctx_idx);
+void scsi_put_internal_cmd(struct scsi_cmnd *scmd);
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);

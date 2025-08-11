Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317C524DCFD
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933875; cv=none; b=f0H7Icyr9hDJEDvY4cjZ4hUP505zkp8n07JHYJSsGJGJk+4q1ywmDlkwIB8pnefd0L3URegeA4WKw/UzqYsw94iNy49UNJPzunZ0G//AgJXMUZJ7QCvGlrA6bwYyI1M9usVkGBO8k6/RRigPgdqtKjhjwvDacRICcw+lPH54AK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933875; c=relaxed/simple;
	bh=4GCjjSgk8jsBXozEasfF5HzwLws7rMg/ZjObNDpbTDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VreFmZoPNYgS7MAAuQ3L2ZpooJmVU4hoWbOrN1oU2xyNSl7NeoAs7Y5XLuU0UhfJlMQZPE3w2dh5TWrIdO4zcpeRYxIeRU9bLOwyUg2A9YTAJMfEMR3n9hrjGfhuAVwF/ioOTxrAe6e2JDMbuoSoum5etAxgCtxL59uV41NzUFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SQ4acZcY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SQ4acZcY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120H6d6tzlnfZS;
	Mon, 11 Aug 2025 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933870; x=1757525871; bh=DZmb0
	AXwk4kJDsid8SpFTgYwXSECVm4xcfxe989B5Fw=; b=SQ4acZcYM97Flen0cJyP5
	E2115Jh/daHjvMZY4E3L6qe8Xlg8zg4UFpIaHvE0DgV6AoTzIp1E/be1regGbBd/
	yQteocINGp3FM3XBV4S0n1ReC/gnBc8wiyBZ3UvypqJfZiLKj8nCDVCStgGpz3N/
	03sFkZZwhb1cpYyo2A9VJ4dPly7SPWrXo5UbRTHmLrJ3tY1n98e3PPrOo343cgOJ
	/nX8t8zU+EHaNYjkUkxSoM7gLN8MzD047oMm5jeFJk+ar6En/+NeJzbnoicy6Rwg
	XaMKa1f4+SR9OzbUsqDpm1I/NUmsj9ofaD8OghexvbUmDatWSwJFuryKV0XnkL0P
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CZ5E8fTf2Eoh; Mon, 11 Aug 2025 17:37:50 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c120B61J1zlngvS;
	Mon, 11 Aug 2025 17:37:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 04/30] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
Date: Mon, 11 Aug 2025 10:34:16 -0700
Message-ID: <20250811173634.514041-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
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
index 0112ad3859ff..b0a223dc86f3 100644
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
@@ -2117,6 +2129,74 @@ void scsi_mq_free_tags(struct kref *kref)
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

Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B078630648F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473118; cv=none; b=iZedQAj+9ENt7kMViLGmt8Y+uqtv3TLHo9+BkqHaSy2eyT1gNbxOd9IUNSE1p1EH0GU1qORKS4d+PoKXOT88A4Qjao9V4zHLKeRv0p68AN/T/CXOLThSZKgE4o7LXqOnblyZ4K356cyqSR7KXWLjusKuUFF0s5BrXVaU7xfbvXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473118; c=relaxed/simple;
	bh=Js6WrV8Q5Db9B8hPoQwmFTkOLWaarUiFh7Vorw4E9gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9xe20rfe3+/+F9cPXcnqJoeXe4RMIX9jsRGHnOtTp1o8wboK+t2xCKHbTLVcLfat5B5CS47JlOUxOIz9A2BEUAiw9LMv6LQAf8Qb3VxKTU8f+FqZm6Gaz+ebqFG9570XytwXMxinhGNFWQXcRCrDqBCcCOtDzyY4LPQKOU2Z9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cj29U7fN; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cj29U7fN"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQXC717rzm0yVM;
	Tue, 14 Oct 2025 20:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473114; x=1763065115; bh=3RIlX
	9dW7vojX932uAP4FBj2ZXKKVuWRSvwlsABi2eY=; b=cj29U7fNErIHM6JplOaDB
	BWqshTdIyTqh3KrJGE6B2ctqRK/eE34ZIw74cJ0OwBQBsnU1CZBsabyuLxYD7BRU
	C4R04iKIcbs/Uwb1E1SLPZCvgVoktwcjRDXJyErf8TlvFxn6fHZi787kEG+XroPX
	oKAJsc8xvRnE3NfZ7Zo0eETTQZrDD6QLTZV+X0LU6w2nvRZpM+ePwdiuDZxg1pHG
	ZvIlSskIZ2vIDI9PmhOnitdF87jOSb3sZaa8tYcmHAPiiGEHHbfx9f9QJlOuGD98
	DP3Kz6bNyO6GV56cqAIYx7YUzTjh1hwPqcU5NqLjwU2F5uRNyDIa8fIJJ+v9ooFE
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id js-jxne6QKMX; Tue, 14 Oct 2025 20:18:34 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQX65ZKCzm0yV3;
	Tue, 14 Oct 2025 20:18:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 06/28] scsi: core: Add scsi_{get,put}_internal_cmd() helpers
Date: Tue, 14 Oct 2025 13:15:48 -0700
Message-ID: <20251014201707.3396650-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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

Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: changed the 'nowait' argument into a 'flags' argument /
  added scsi_get_internal_cmd_hctx(). See also
  https://lore.kernel.org/linux-scsi/20211125151048.103910-3-hare@suse.de=
/ ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 79 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  7 ++++
 2 files changed, 86 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d4e874bbf2ea..9b1a254f92ba 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1247,6 +1247,17 @@ struct request *scsi_alloc_request(struct request_=
queue *q, blk_opf_t opf,
 }
 EXPORT_SYMBOL_GPL(scsi_alloc_request);
=20
+static struct request *scsi_alloc_request_hctx(struct request_queue *q,
+		blk_opf_t opf, blk_mq_req_flags_t flags, unsigned int hctx_idx)
+{
+	struct request *rq;
+
+	rq =3D blk_mq_alloc_request_hctx(q, opf, flags, hctx_idx);
+	if (!IS_ERR(rq))
+		scsi_initialize_rq(rq);
+	return rq;
+}
+
 /*
  * Only called when the request isn't completed by SCSI, and not freed b=
y
  * SCSI
@@ -2134,6 +2145,74 @@ void scsi_mq_free_tags(struct kref *kref)
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

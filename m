Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701F832A3C1
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745953; cv=none; b=OuqZqm7BBpqWrFHrQXwIy+mFAZ4z9495/pYK+3vx9dv2PjuJ1NG4NnuExG7kyYmYHNHqDIpXDwEEyoFfdjRiXXnecQViy9EZbGHQO3JpeeRCLZYqdviqcPudZYrLYV5uxJAbwWfJKGJPbZ14vld+CDA8MHlXwaf5COqUi4Zy2Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745953; c=relaxed/simple;
	bh=wr9EE9n3prrTP+1ljwSiRRg0VP2yVBnh/Co9JaOHTfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0mw94vHq4c80BHzUkGC9PL+zF4eORDGXHQqpVR3dt4zwI2tihX3I6KoQFytQygxaIuIHs6nQVV0lJagzs+NlOE9p+v3OyLWGS1joRUHA7lvdVRXGc4INtMubwBjoEV55NEwufQAmyIhsIexyQQafG8axai7kck5npzcLmgLgdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GBlmAL68; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GBlmAL68"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7nV3zlBzlgqVP;
	Wed, 24 Sep 2025 20:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745949; x=1761337950; bh=UnKa4
	ZDSq8RnqBMr4ohITKDa/Eds46+h2A1/hbNrvD8=; b=GBlmAL68UJmMH4/l5ypGa
	RYVxFUY9++JlUsmpH8t7L4gTWmGD6pC8czF6C12TNga8F23XakDJ67b9eOgqYgQq
	D3l7Kx4DXUkyXrlqBnl3tjufcWFc6EPRG9hxv4S1i/4E3yH/YG0Y7+7Tvx0OT41R
	T9/D3ck5a3T4ze+NPngjYerJkOylWVzE1dpmMrChvj7wIo08N3rzaiNoZZwV9l9t
	oQgFwLJsYpVFzIR4dTLTS1HeQC+RLqv9Y4AG1enjiWo14P5vWbyNvaM+8eYQrOzC
	Ae+NE5g3zleMI1yOhfBW+Gnm2q6bUXE0Aq/2Eyt4oTxVau8fAzsZjkmIqSfP+lKU
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WdfrybLbIZ2j; Wed, 24 Sep 2025 20:32:29 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7nR1CT0zlgqyg;
	Wed, 24 Sep 2025 20:32:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 07/28] scsi_debug: Abort SCSI commands via .queue_reserved_command()
Date: Wed, 24 Sep 2025 13:30:26 -0700
Message-ID: <20250924203142.4073403-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Add a .queue_reserved_command() implementation and call it from the code
path that aborts SCSI commands. This ensures that the code for
allocating a pseudo SCSI device and also the code for processing
reserved commands gets triggered while running blktests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 106 ++++++++++++++++++++++++++++++++++----
 1 file changed, 97 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2a8638937d23..b376331c4cce 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -451,6 +451,23 @@ struct sdeb_store_info {
 #define shost_to_sdebug_host(shost)	\
 	dev_to_sdebug_host(shost->dma_dev)
=20
+struct scsi_debug_abort_cmd {
+	u16 tag;
+	u16 hwq;
+};
+
+enum scsi_debug_internal_cmd_type {
+	SCSI_DEBUG_ABORT_CMD,
+};
+
+struct scsi_debug_internal_cmd {
+	enum scsi_debug_internal_cmd_type type;
+
+	union {
+		struct scsi_debug_abort_cmd abort_cmd;
+	};
+};
+
 enum sdeb_defer_type {SDEB_DEFER_NONE =3D 0, SDEB_DEFER_HRT =3D 1,
 		      SDEB_DEFER_WQ =3D 2, SDEB_DEFER_POLL =3D 3};
=20
@@ -466,6 +483,8 @@ struct sdebug_defer {
 struct sdebug_scsi_cmd {
 	spinlock_t   lock;
 	struct sdebug_defer sd_dp;
+
+	struct scsi_debug_internal_cmd internal_cmd;
 };
=20
 static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
@@ -6729,20 +6748,48 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd=
 *cmnd)
 	return false;
 }
=20
+static int scsi_debug_setup_abort_cmd(struct scsi_cmnd *cmd,
+			const struct scsi_debug_internal_cmd *internal_cmd)
+{
+	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmd);
+
+	sdsc->internal_cmd =3D *internal_cmd;
+
+	return 0;
+}
+
 /*
- * Called from scsi_debug_abort() only, which is for timed-out cmd.
+ * Abort a pending SCSI command. Only called from scsi_debug_abort(). Al=
though
+ * it would be possible to call scsi_debug_stop_cmnd() directly, an inte=
rnal
+ * command is allocated and submitted to use the reserved command
+ * infrastructure.
  */
 static bool scsi_debug_abort_cmnd(struct scsi_cmnd *cmnd)
 {
-	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmnd);
-	unsigned long flags;
-	bool res;
-
-	spin_lock_irqsave(&sdsc->lock, flags);
-	res =3D scsi_debug_stop_cmnd(cmnd);
-	spin_unlock_irqrestore(&sdsc->lock, flags);
+	struct request *rq =3D scsi_cmd_to_rq(cmnd);
+	u32 unique_tag =3D blk_mq_unique_tag(rq);
+	u16 hwq =3D blk_mq_unique_tag_to_hwq(unique_tag);
+	u16 tag =3D blk_mq_unique_tag_to_tag(unique_tag);
+	struct scsi_device *sdev =3D cmnd->device;
+	struct Scsi_Host *shost =3D sdev->host;
+	const struct scsi_debug_internal_cmd ic =3D {
+		.type =3D SCSI_DEBUG_ABORT_CMD,
+		.abort_cmd =3D {
+			.tag =3D tag,
+			.hwq =3D hwq,
+		},
+	};
+	struct scsi_cmnd *abort_cmd;
+	struct request *abort_rq;
=20
-	return res;
+	abort_cmd =3D scsi_get_internal_cmd(shost->pseudo_sdev, DMA_TO_DEVICE,
+					  BLK_MQ_REQ_RESERVED);
+	if (WARN_ON_ONCE(!abort_cmd))
+		return false;
+	scsi_debug_setup_abort_cmd(abort_cmd, &ic);
+	abort_rq =3D scsi_cmd_to_rq(abort_cmd);
+	abort_rq->timeout =3D secs_to_jiffies(3);
+	return blk_execute_rq(abort_rq, true) =3D=3D BLK_STS_OK;
 }
=20
 /*
@@ -9197,6 +9244,45 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd,=
 int *retval,
 	return ret;
 }
=20
+static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cm=
nd *scp)
+{
+	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(scp);
+	struct scsi_debug_abort_cmd *abort_cmd =3D
+		&sdsc->internal_cmd.abort_cmd;
+	struct blk_mq_tag_set *tag_set =3D &shost->tag_set;
+	unsigned int tag =3D abort_cmd->tag;
+	unsigned int hwq =3D abort_cmd->hwq;
+	struct blk_mq_tags *tags =3D tag_set->tags[hwq];
+	struct request *abort_rq =3D blk_mq_tag_to_rq(tags, tag);
+	struct scsi_cmnd *abort_scmd =3D blk_mq_rq_to_pdu(abort_rq);
+	struct sdebug_scsi_cmd *abort_sdsc =3D scsi_cmd_priv(abort_scmd);
+	bool res;
+
+	scoped_guard(spinlock_irqsave, &abort_sdsc->lock)
+		res =3D scsi_debug_stop_cmnd(abort_scmd);
+
+	scp->result =3D (res ? DID_OK : DID_ERROR) << 16;
+}
+
+static int scsi_debug_queue_reserved_command(struct Scsi_Host *shost,
+					     struct scsi_cmnd *scp)
+{
+	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(scp);
+
+	switch (sdsc->internal_cmd.type) {
+	case SCSI_DEBUG_ABORT_CMD:
+		scsi_debug_abort_cmd(shost, scp);
+		break;
+	default:
+		WARN_ON_ONCE(true);
+		scp->result =3D DID_ERROR << 16;
+		break;
+	}
+
+	scsi_done(scp);
+	return 0;
+}
+
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -9416,6 +9502,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.sdev_destroy =3D		scsi_debug_sdev_destroy,
 	.ioctl =3D		scsi_debug_ioctl,
 	.queuecommand =3D		scsi_debug_queuecommand,
+	.queue_reserved_command =3D scsi_debug_queue_reserved_command,
 	.change_queue_depth =3D	sdebug_change_qdepth,
 	.map_queues =3D		sdebug_map_queues,
 	.mq_poll =3D		sdebug_blk_mq_poll,
@@ -9425,6 +9512,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.eh_bus_reset_handler =3D scsi_debug_bus_reset,
 	.eh_host_reset_handler =3D scsi_debug_host_reset,
 	.can_queue =3D		SDEBUG_CANQUEUE,
+	.nr_reserved_cmds =3D	1,
 	.this_id =3D		7,
 	.sg_tablesize =3D		SG_MAX_SEGMENTS,
 	.cmd_per_lun =3D		DEF_CMD_PER_LUN,

Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9373C30595A
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473122; cv=none; b=TVgx1Xe/CRr9GTwTRMsuxW7L0sLFxD3O/SWyD11yqKPKCIg2tNPUXErTRkMl6qK8TuoLckDZiu+FtIDcgNuVU9Zebwsy9FmxRvtv26LE0zLAemZ4cSxOlrcWxqR9bKH188BZWwaLvvLlpO69+FawQQvunkl4AeCGl0uvc0ItywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473122; c=relaxed/simple;
	bh=wCvWLIgG8oyADGZLDdbF3ibESjVptaTAjI6o+FVrbe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka7LqHJK0pGEhSJ9RWvFIFy33V/zXHAwEoaXBGkwwr3pESZQr7DBwByEukItCbG2IyJgGMFicXqNCyKuo6BDnf8iS1YpSK7c3r2QaPhDnFEYg2ud4WV7li2p7DQf/YYbH3SO3cJcTeAufWi+A1e4GCyceJP8PqDToKNj5GVMbMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KDw3j2Bw; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KDw3j2Bw"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQXH5dgnzm0yV3;
	Tue, 14 Oct 2025 20:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473118; x=1763065119; bh=lkGxk
	0JN+ZuKh9+6DzNF5CCB/cUVLdiQvhKEPiSc+wo=; b=KDw3j2Bwymc/Li5BppbKf
	/MwutDCryp4E9ph3NHFuY9l9F746szGgvfKjQhwhC7FbRZ5r1jeL+y2O38QN4J9i
	uOlOVCqWOE7+zVWkMBTJa4KimUo/J30K9xMDz0gaR6v1Ki/3RiWDnaD/TIp2joRU
	p5fPZVqclyxwHkXpTFyw3CpVuigv2ABzpFD39b22gIiG4IoRKPteG87ixDn/FLmH
	CkdGgYdpr1s1mghqbXQLaZVi6W/KVQsbH34pOGf2OM+MRvJSrWQnZ7/VsMBLsyu/
	0R5jBfM6Bakc3Nzg17xVxU7FfxsgkwoVtzGjk1skL1eYKVo6HSsEMliWcoGbTxEz
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zhB828jQTEq9; Tue, 14 Oct 2025 20:18:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQXC32BKzm0yVJ;
	Tue, 14 Oct 2025 20:18:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 07/28] scsi_debug: Abort SCSI commands via an internal command
Date: Tue, 14 Oct 2025 13:15:49 -0700
Message-ID: <20251014201707.3396650-8-bvanassche@acm.org>
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

Add a .queue_reserved_command() implementation and call it from the code
path that aborts SCSI commands. This ensures that the code for
allocating a pseudo SCSI device and also the code for allocating and
processing reserved commands gets triggered while running blktests.

Most of the code in this patch is a modified version of code from John
Garry. See also
https://lore.kernel.org/linux-scsi/75018e17-4dea-4e1b-8c92-7a224a1e13b9@o=
racle.com/

Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 113 ++++++++++++++++++++++++++++++++++----
 1 file changed, 102 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3..cf1e0ef15811 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6752,20 +6752,59 @@ static bool scsi_debug_stop_cmnd(struct scsi_cmnd=
 *cmnd)
 	return false;
 }
=20
+struct sdebug_abort_cmd {
+	u32 unique_tag;
+};
+
+enum sdebug_internal_cmd_type {
+	SCSI_DEBUG_ABORT_CMD,
+};
+
+struct sdebug_internal_cmd {
+	enum sdebug_internal_cmd_type type;
+
+	union {
+		struct sdebug_abort_cmd abort_cmd;
+	};
+};
+
+union sdebug_priv {
+	struct sdebug_scsi_cmd c;
+	struct sdebug_internal_cmd ic;
+};
+
 /*
- * Called from scsi_debug_abort() only, which is for timed-out cmd.
+ * Abort a pending SCSI command. Only called from scsi_debug_abort(). Al=
though
+ * it would be possible to call scsi_debug_stop_cmnd() directly, an inte=
rnal
+ * command is allocated and submitted to trigger the reserved command
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
-
-	return res;
+	struct Scsi_Host *shost =3D cmnd->device->host;
+	struct request *rq =3D scsi_cmd_to_rq(cmnd);
+	u32 unique_tag =3D blk_mq_unique_tag(rq);
+	struct sdebug_internal_cmd *sdic;
+	struct scsi_cmnd *abort_cmd;
+	struct request *abort_rq;
+	blk_status_t res;
+
+	abort_cmd =3D scsi_get_internal_cmd(shost->pseudo_sdev, DMA_NONE,
+					  BLK_MQ_REQ_RESERVED);
+	if (!abort_cmd)
+		return false;
+	sdic =3D scsi_cmd_priv(abort_cmd);
+	*sdic =3D (struct sdebug_internal_cmd) {
+		.type =3D SCSI_DEBUG_ABORT_CMD,
+		.abort_cmd =3D {
+			.unique_tag =3D unique_tag,
+		},
+	};
+	abort_rq =3D scsi_cmd_to_rq(abort_cmd);
+	abort_rq->timeout =3D secs_to_jiffies(3);
+	res =3D blk_execute_rq(abort_rq, true);
+	scsi_put_internal_cmd(abort_cmd);
+	return res =3D=3D BLK_STS_OK;
 }
=20
 /*
@@ -9220,6 +9259,53 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd,=
 int *retval,
 	return ret;
 }
=20
+static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cm=
nd *scp)
+{
+	struct sdebug_internal_cmd *sdic =3D scsi_cmd_priv(scp);
+	struct sdebug_abort_cmd *abort_cmd =3D &sdic->abort_cmd;
+	const u32 unique_tag =3D abort_cmd->unique_tag;
+	struct scsi_cmnd *to_be_aborted_scmd =3D
+		scsi_host_find_tag(shost, unique_tag);
+	struct sdebug_scsi_cmd *to_be_aborted_sdsc =3D
+		scsi_cmd_priv(to_be_aborted_scmd);
+	bool res =3D false;
+
+	if (to_be_aborted_scmd) {
+		scoped_guard(spinlock_irqsave, &to_be_aborted_sdsc->lock)
+			res =3D scsi_debug_stop_cmnd(to_be_aborted_scmd);
+		if (res)
+			pr_info("%s: aborted command with tag %#x\n",
+				__func__, unique_tag);
+		else
+			pr_err("%s: failed to abort command with tag %#x\n",
+			       __func__, unique_tag);
+	} else {
+		pr_err("%s: command with tag %#x not found\n", __func__,
+		       unique_tag);
+	}
+
+	set_host_byte(scp, res ? DID_OK : DID_ERROR);
+}
+
+static int scsi_debug_process_reserved_command(struct Scsi_Host *shost,
+					       struct scsi_cmnd *scp)
+{
+	struct sdebug_internal_cmd *sdic =3D scsi_cmd_priv(scp);
+
+	switch (sdic->type) {
+	case SCSI_DEBUG_ABORT_CMD:
+		scsi_debug_abort_cmd(shost, scp);
+		break;
+	default:
+		WARN_ON_ONCE(true);
+		set_host_byte(scp, DID_ERROR);
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
@@ -9420,6 +9506,9 @@ static int sdebug_init_cmd_priv(struct Scsi_Host *s=
host, struct scsi_cmnd *cmd)
 	struct sdebug_scsi_cmd *sdsc =3D scsi_cmd_priv(cmd);
 	struct sdebug_defer *sd_dp =3D &sdsc->sd_dp;
=20
+	if (blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))
+		return 0;
+
 	spin_lock_init(&sdsc->lock);
 	hrtimer_setup(&sd_dp->hrt, sdebug_q_cmd_hrt_complete, CLOCK_MONOTONIC,
 		      HRTIMER_MODE_REL_PINNED);
@@ -9439,6 +9528,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.sdev_destroy =3D		scsi_debug_sdev_destroy,
 	.ioctl =3D		scsi_debug_ioctl,
 	.queuecommand =3D		scsi_debug_queuecommand,
+	.queue_reserved_command =3D scsi_debug_process_reserved_command,
 	.change_queue_depth =3D	sdebug_change_qdepth,
 	.map_queues =3D		sdebug_map_queues,
 	.mq_poll =3D		sdebug_blk_mq_poll,
@@ -9448,6 +9538,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.eh_bus_reset_handler =3D scsi_debug_bus_reset,
 	.eh_host_reset_handler =3D scsi_debug_host_reset,
 	.can_queue =3D		SDEBUG_CANQUEUE,
+	.nr_reserved_cmds =3D	1,
 	.this_id =3D		7,
 	.sg_tablesize =3D		SG_MAX_SEGMENTS,
 	.cmd_per_lun =3D		DEF_CMD_PER_LUN,
@@ -9456,7 +9547,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.module =3D		THIS_MODULE,
 	.skip_settle_delay =3D	1,
 	.track_queue_depth =3D	1,
-	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
+	.cmd_size =3D sizeof(union sdebug_priv),
 	.init_cmd_priv =3D sdebug_init_cmd_priv,
 	.target_alloc =3D		sdebug_target_alloc,
 	.target_destroy =3D	sdebug_target_destroy,

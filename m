Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A86328B6E
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943283; cv=none; b=gEWu1rBXX+shdfMHWvIRAqrgCD6QgdMulqiMfo5lasIU1z2ZgtvtuOPB1N7nFyTD/6/dfz5MuiyOKIynd52k9c19PXj3B0vltEg8tLl3UbeuaWeWkQe6o2cjSbMZsW+0x+QhnrhMNR5G1+05kTDxnMyCamZJc56rTRA1shXRmYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943283; c=relaxed/simple;
	bh=xdG468TSHfWWcykb3791BwomJOrtd6EkBMCEpVMTdn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmYJNCGy9YzySnGTMvjSxyiuvUHBg5ofh9NhWQvvi1r5uBqrx8tQD+CqFQ4erxqZy69PJTDcB19MreP3vvyJxyQ0aOvc83+eYzP5dCoPtIcwlNap8gomTYTF4IP4x1sy7/c6kPPpjCPPllajeFUN/4zbzaYu0O5+wo6DT/88PSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=m4urQeOk; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="m4urQeOk"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytDd0981zm0pJx;
	Fri, 31 Oct 2025 20:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943279; x=1764535280; bh=uyWYY
	fNYPReMV1wYYxUOfwl0vovT4RjpHiJ+aeVQ5lM=; b=m4urQeOkP8rNbDcPwJsbF
	M9Ev+q2PS0CQgsbHhl09x5AAv9OCx7zbM4gc6rp4oQHsrSR6ZVSlWKATsCz11qDU
	d7a21FnRD7H4+g7sWrPfVS6Jp4BgcRDjUkENOZtLN/NgtG6eCtFPBfikg/yxp4f0
	//9Oa6JncRPh0BgIZVEog/edK3YqS/5WCkMTL6LhB5ubKoUv80VM6LT3LkdcGnDK
	Rd4Bj8S2uMxyVDQoOeiCeQt137xdj4GQAO6MC4y2QvobWlYkbRksaKZUDmOeelPE
	R57YvQ6eYyOCJUy6/MizI7m8FmtEZxyUUAnWiUczc4mZxRZCkAkTk1qgickBm5Xn
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rQ55tBOy2dmj; Fri, 31 Oct 2025 20:41:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytDX4TSqzm0pKc;
	Fri, 31 Oct 2025 20:41:15 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v8 07/28] scsi_debug: Abort SCSI commands via an internal command
Date: Fri, 31 Oct 2025 13:39:15 -0700
Message-ID: <20251031204029.2883185-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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

Reviewed-by: John Garry <john.g.garry@oracle.com>
Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 116 ++++++++++++++++++++++++++++++++++----
 1 file changed, 105 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3..7291b7a7f1b0 100644
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
+	struct sdebug_scsi_cmd cmd;
+	struct sdebug_internal_cmd internal_cmd;
+};
+
 /*
- * Called from scsi_debug_abort() only, which is for timed-out cmd.
+ * Abort SCSI command @cmnd. Only called from scsi_debug_abort(). Althou=
gh
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
+	struct sdebug_internal_cmd *internal_cmd;
+	struct scsi_cmnd *abort_cmd;
+	struct request *abort_rq;
+	blk_status_t res;
+
+	abort_cmd =3D scsi_get_internal_cmd(shost->pseudo_sdev, DMA_NONE,
+					  BLK_MQ_REQ_RESERVED);
+	if (!abort_cmd)
+		return false;
+	internal_cmd =3D scsi_cmd_priv(abort_cmd);
+	*internal_cmd =3D (struct sdebug_internal_cmd) {
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
@@ -9220,6 +9259,56 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd,=
 int *retval,
 	return ret;
 }
=20
+/* Process @scp, a request to abort a SCSI command by tag. */
+static void scsi_debug_abort_cmd(struct Scsi_Host *shost, struct scsi_cm=
nd *scp)
+{
+	struct sdebug_internal_cmd *internal_cmd =3D scsi_cmd_priv(scp);
+	struct sdebug_abort_cmd *abort_cmd =3D &internal_cmd->abort_cmd;
+	const u32 unique_tag =3D abort_cmd->unique_tag;
+	struct scsi_cmnd *to_be_aborted_scmd =3D
+		scsi_host_find_tag(shost, unique_tag);
+	struct sdebug_scsi_cmd *to_be_aborted_sdsc =3D
+		scsi_cmd_priv(to_be_aborted_scmd);
+	bool res =3D false;
+
+	if (!to_be_aborted_scmd) {
+		pr_err("%s: command with tag %#x not found\n", __func__,
+		       unique_tag);
+		return;
+	}
+
+	scoped_guard(spinlock_irqsave, &to_be_aborted_sdsc->lock)
+		res =3D scsi_debug_stop_cmnd(to_be_aborted_scmd);
+
+	if (res)
+		pr_info("%s: aborted command with tag %#x\n",
+			__func__, unique_tag);
+	else
+		pr_err("%s: failed to abort command with tag %#x\n",
+		       __func__, unique_tag);
+
+	set_host_byte(scp, res ? DID_OK : DID_ERROR);
+}
+
+static int scsi_debug_process_reserved_command(struct Scsi_Host *shost,
+					       struct scsi_cmnd *scp)
+{
+	struct sdebug_internal_cmd *internal_cmd =3D scsi_cmd_priv(scp);
+
+	switch (internal_cmd->type) {
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
@@ -9420,6 +9509,9 @@ static int sdebug_init_cmd_priv(struct Scsi_Host *s=
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
@@ -9439,6 +9531,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.sdev_destroy =3D		scsi_debug_sdev_destroy,
 	.ioctl =3D		scsi_debug_ioctl,
 	.queuecommand =3D		scsi_debug_queuecommand,
+	.queue_reserved_command =3D scsi_debug_process_reserved_command,
 	.change_queue_depth =3D	sdebug_change_qdepth,
 	.map_queues =3D		sdebug_map_queues,
 	.mq_poll =3D		sdebug_blk_mq_poll,
@@ -9448,6 +9541,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.eh_bus_reset_handler =3D scsi_debug_bus_reset,
 	.eh_host_reset_handler =3D scsi_debug_host_reset,
 	.can_queue =3D		SDEBUG_CANQUEUE,
+	.nr_reserved_cmds =3D	1,
 	.this_id =3D		7,
 	.sg_tablesize =3D		SG_MAX_SEGMENTS,
 	.cmd_per_lun =3D		DEF_CMD_PER_LUN,
@@ -9456,7 +9550,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.module =3D		THIS_MODULE,
 	.skip_settle_delay =3D	1,
 	.track_queue_depth =3D	1,
-	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
+	.cmd_size =3D sizeof(union sdebug_priv),
 	.init_cmd_priv =3D sdebug_init_cmd_priv,
 	.target_alloc =3D		sdebug_target_alloc,
 	.target_destroy =3D	sdebug_target_destroy,

Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D131EEF9
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253346; cv=none; b=KAgP1KPHZdLiouBi8yGTr6cKa5AdFNcNJy2b9bfgeqL3FyRXqTgpe63B2uH+XwjsNEBXiAx1We8o5+qGVtIWKTx7+Qfzf8P4R6VMGwuO0UIHogGY8kCoLzP8ofnF6J2wX7ASxQm8Hy0kRzUWc7KI2R0wGpqWUnWM5Eyub5h8Wo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253346; c=relaxed/simple;
	bh=tOt3Xz6hs0eIcQTLT1GxIjn8yo1aU1RpEC6O4w/v8WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qd2T7ao3xrJW2p8zhZg7EQU1hO+E2p5Fbt6DzAvxN+NSmZ6iDyRYhJXIVvoO+fxXWmREmRwtZTYrMlWSFuJZRa9sRpU3spj972O5usoVl7V19auC93gyOGskrnfHMuIZzaaCTeddsttQIPE6T4kvxWp61bKRXAwOudxjK0/1amI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yNw0Swrx; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yNw0Swrx"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPym0xmvzm0ysy;
	Wed, 27 Aug 2025 00:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253342; x=1758845343; bh=uNl7M
	662b6rTAc3w7eNNsrRnRvweyUqgQlB/3Gg0vgA=; b=yNw0Swrxw170XFfuLM4ug
	rUcfQlmYatmhFgvrKw83iRwEqTn4LGiA3UFOrTByLly+xucf5SnWudDourDQlKuX
	FZSF/2XJKy7ZacY28Bxk9ROr3wETkpdLwQUSZHe0uQIjmm/xRqkZQ+QaI0MgezCX
	E+X7l7woygWzasJ/WfpimVg5RtuD6tYV8RT5qvzi6dXT/fchhCclyE2vJqaQhfoP
	WCLkMvWf5ZAVR0Tc8mFoH8ElwC2QDai3b7qfkCqaFAvG82+rMIRXCMooiFHATLJW
	MnJS7ZhSVqDQTwHw+lvAcyw1gQC+J+eFYJOOOOzH6GX3HXE1PAv7txP73WJG6cUZ
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NFsC56nsZ3Qh; Wed, 27 Aug 2025 00:09:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPyf5pvPzm0xkQ;
	Wed, 27 Aug 2025 00:08:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 04/26] scsi: core: Bypass the queue limit checks for reserved commands
Date: Tue, 26 Aug 2025 17:06:08 -0700
Message-ID: <20250827000816.2370150-5-bvanassche@acm.org>
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

From: John Garry <john.garry@huawei.com>

Reserved commands will be used by SCSI LLDs for submitting internal
commands. The SCSI host, target and device limits do not apply to these
use cases. Additionally, do not activate the SCSI error handler if a
reserved command fails such that reserved commands can be submitted from
inside the SCSI error handler.

Signed-off-by: John Garry <john.garry@huawei.com>
[ bvanassche: modified patch title and patch description. Renamed
  .reserved_queuecommand() into .queue_reserved_command(). Changed
  the second argument of __blk_mq_end_request() from 0 into error
  code in the completion path if cmd->result !=3D 0. Rewrote the
  scsi_queue_rq() changes. See also
  https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-j=
ohn.garry@huawei.com/ ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     |  6 +++++
 drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
 include/scsi/scsi_host.h |  6 +++++
 3 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e860ac93499d..75fe624366c3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -231,6 +231,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, =
struct device *dev,
 		goto fail;
 	}
=20
+	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
+		shost_printk(KERN_ERR, shost,
+			     "nr_reserved_cmds set but no method to queue\n");
+		goto fail;
+	}
+
 	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
 	shost->cmd_per_lun =3D min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0112ad3859ff..2d81fd837d47 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1539,6 +1539,14 @@ static void scsi_complete(struct request *rq)
 	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
 	enum scsi_disposition disposition;
=20
+	if (blk_mq_is_reserved_rq(rq)) {
+		/* Only pass-through requests are supported in this code path. */
+		WARN_ON_ONCE(!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)));
+		scsi_mq_uninit_cmd(cmd);
+		__blk_mq_end_request(rq, scsi_result_to_blk_status(cmd->result));
+		return;
+	}
+
 	INIT_LIST_HEAD(&cmd->eh_entry);
=20
 	atomic_inc(&cmd->device->iodone_cnt);
@@ -1828,25 +1836,31 @@ static blk_status_t scsi_queue_rq(struct blk_mq_h=
w_ctx *hctx,
 	WARN_ON_ONCE(cmd->budget_token < 0);
=20
 	/*
-	 * If the device is not in running state we will reject some or all
-	 * commands.
+	 * Bypass the SCSI device, SCSI target and SCSI host checks for
+	 * reserved commands.
 	 */
-	if (unlikely(sdev->sdev_state !=3D SDEV_RUNNING)) {
-		ret =3D scsi_device_state_check(sdev, req);
-		if (ret !=3D BLK_STS_OK)
-			goto out_put_budget;
-	}
+	if (!blk_mq_is_reserved_rq(req)) {
+		/*
+		 * If the device is not in running state we will reject some or
+		 * all commands.
+		 */
+		if (unlikely(sdev->sdev_state !=3D SDEV_RUNNING)) {
+			ret =3D scsi_device_state_check(sdev, req);
+			if (ret !=3D BLK_STS_OK)
+				goto out_put_budget;
+		}
=20
-	ret =3D BLK_STS_RESOURCE;
-	if (!scsi_target_queue_ready(shost, sdev))
-		goto out_put_budget;
-	if (unlikely(scsi_host_in_recovery(shost))) {
-		if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
-			ret =3D BLK_STS_OFFLINE;
-		goto out_dec_target_busy;
+		ret =3D BLK_STS_RESOURCE;
+		if (!scsi_target_queue_ready(shost, sdev))
+			goto out_put_budget;
+		if (unlikely(scsi_host_in_recovery(shost))) {
+			if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
+				ret =3D BLK_STS_OFFLINE;
+			goto out_dec_target_busy;
+		}
+		if (!scsi_host_queue_ready(q, shost, sdev, cmd))
+			goto out_dec_target_busy;
 	}
-	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
-		goto out_dec_target_busy;
=20
 	/*
 	 * Only clear the driver-private command data if the LLD does not suppl=
y
@@ -1875,6 +1889,14 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw=
_ctx *hctx,
 	cmd->submitter =3D SUBMITTED_BY_BLOCK_LAYER;
=20
 	blk_mq_start_request(req);
+	if (blk_mq_is_reserved_rq(req)) {
+		reason =3D shost->hostt->queue_reserved_command(shost, cmd);
+		if (reason) {
+			ret =3D BLK_STS_RESOURCE;
+			goto out_put_budget;
+		}
+		return BLK_STS_OK;
+	}
 	reason =3D scsi_dispatch_cmd(cmd);
 	if (reason) {
 		scsi_set_blocked(cmd, reason);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b5150759c44..0c7235410cc0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -86,6 +86,12 @@ struct scsi_host_template {
 	 */
 	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
=20
+	/*
+	 * Queue a reserved command (BLK_MQ_REQ_RESERVED). The .queuecommand()
+	 * documentation also applies to the .queue_reserved_command() callback=
.
+	 */
+	int (*queue_reserved_command)(struct Scsi_Host *, struct scsi_cmnd *);
+
 	/*
 	 * The commit_rqs function is used to trigger a hardware
 	 * doorbell after some requests have been queued with

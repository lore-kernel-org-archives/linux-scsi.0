Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F053009D5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701514; cv=none; b=kkPGQYNRdifOg+do2xd2/J2Ugs9sxKyy1td5KJVjn2s4lnKVEEE0GFDT54xSAvK1MHJSF4Fmg2ztrrXwSDPh1cNtb3lULWkIyKZXZAApFe+avlIStfyy3wHKGuLNX2v3UkQUvJx+LrxV5/Qs9u7birADZdEAm/NS6m4sd47GtB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701514; c=relaxed/simple;
	bh=3dhgeeNsJh+Px/iCsnvdCHcbItGyDzoR5dFBuC+sBk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWBDAVGrDrWNImVuQzBdnYJqJt5tu/btzOTgyWOT+jia5d3mRCL8p31T5pUYsUdcUVseMwCElzT0yXiUhqkQ74uWkeS2bSU1gDrqxJAW6lNGLUT2P7ueBAPIaom7y/9jCKv+B2MqMTGFaorgEl2zsy/tgGo05tk6ToBlwrRHNH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bhSwtmTC; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bhSwtmTC"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjX82fLzzlgqyk;
	Fri, 12 Sep 2025 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701511; x=1760293512; bh=q0SK/
	b7pCNR4kyTnBwEJ3t7ZivrSgEr67mEm7+WiuSw=; b=bhSwtmTCuG9yhzXOpfTRT
	55a+6XzMykgJaNiHbGkxoAh5jV6YzUizsGNxAXzOyPlEPFN93LbRymXuIE71lZUX
	/go3om3D/jVIaGVZivrG0zF3fBhb36zPDkk9u+5KjdJCit46LO1+c1xNCSwFPC/M
	2gNGgsNPwBc5mc3yw9euXvLYdxgNEImPm8Ucmvh3FAZB1dBkVufwOLHmBK9VBjnM
	yOVWAFURV9SjpBDvCmWSnUBkwtXkoZ/pqDqyukFUrJQngseKxrfTO4BRHdX/+mVA
	rDzPETc9nG/bW4j3hhmVfeZG1mtwDJouiwqzZk7dmyAkFBkOVS3EBVWHGoM+tMRx
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6o_qzF73-p1A; Fri, 12 Sep 2025 18:25:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjX41G5nzlssXb;
	Fri, 12 Sep 2025 18:25:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 05/29] scsi: core: Introduce .queue_reserved_command()
Date: Fri, 12 Sep 2025 11:21:26 -0700
Message-ID: <20250912182340.3487688-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: John Garry <john.garry@huawei.com>

Reserved commands will be used by SCSI LLDs for submitting internal
commands. Since the SCSI host, target and device limits do not apply to
the reserved command use cases, bypass the SCSI host limit checks for
reserved commands. Introduce the .queue_reserved_command() callback for
reserved commands. Additionally, do not activate the SCSI error handler
if a reserved command fails such that reserved commands can be submitted
from inside the SCSI error handler.

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
 drivers/scsi/hosts.c     |  8 +++++-
 drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
 include/scsi/scsi_host.h |  6 +++++
 3 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 986586bf67dc..3a62c51379ef 100644
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
@@ -307,7 +313,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, s=
truct device *dev,
 	if (error)
 		goto out_del_dev;
=20
-	if (sht->nr_reserved_cmds) {
+	if (sht->nr_reserved_cmds || sht->queue_reserved_command) {
 		shost->pseudo_sdev =3D scsi_get_pseudo_dev(shost);
 		if (!shost->pseudo_sdev) {
 			error =3D -ENOMEM;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 91a0c7f843c1..5e636e015352 100644
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
index 3bfb53cf5dfc..9a0b07bfd559 100644
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

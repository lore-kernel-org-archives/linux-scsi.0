Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A206832A3D4
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745945; cv=none; b=VbRr1Mxo5MEgQ7WHio/xXHV+ZT9qYYFnyCpTH1RwjBg/tlyq9QHFshR8S4pYWeHcd9ReuO7l10CoywvtNgZ+R3a4Po6wErJ4iN0E6AtWrnPIZ7Ecm+zhwpNt9e//+7o3v7FQK0fszpL/VudBZDhkWxp70nmPy+3n/F8yDmasmZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745945; c=relaxed/simple;
	bh=D4WcpxBY6Pxmj2FbdsPx46+KsQ3idl1zWO8V1aysqiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hq6kyKcN7jIFiopeghBtaMiliHWt/7uAlCjqCDuHpPA4049t+psB6fkjA9WeYZh/E9f3OtUKYtU1YUdILl1xyUrKJLmAJ3fAbs+Nj2kp4LNjqC90oVXG96fPE25tLssq+H29+0OkVsrkkG6+CjX3gYCc5sp9zI2hnmCC1OHGxf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fYLymSv9; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fYLymSv9"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7nL58cBzlh0dn;
	Wed, 24 Sep 2025 20:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745941; x=1761337942; bh=JEESJ
	y4Z3dKnAchl95PrvlW3lPHf8usCRSHCQuw5OFE=; b=fYLymSv9+zYLLiIMoLBjl
	5Jhl8CKjAr132Z78tYQhQ7Xnvaa66u9tBqSbToCFrtedwAwjpZFEVLopegT5GYkN
	TPRZvEYitNxmb02wqusjLeFYWil7FhumuyDx+UC9t62ZzQV+WJIvRcsf9CLCu+oQ
	1jtCNu5EDvOOkRfOHCmgtGFAn5J8Hmk7sO6Y/ItgYvO1mwAnTQLDcvpHnIgGGwQg
	aVfGD7iyHSdy9UpzOT9NfddwDeX2F+CW7bnmWNoCntJYCk51MCMR+n1q/+GARJUq
	yrxKQBKyQdfrmypVl/R9cKZMbyovnnvrK0PNLn9NyEuaToc6tGLDqjjUx50nrPNf
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HgCb4Rkr2DNd; Wed, 24 Sep 2025 20:32:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7nG3BYhzlgqVP;
	Wed, 24 Sep 2025 20:32:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 05/28] scsi: core: Introduce .queue_reserved_command()
Date: Wed, 24 Sep 2025 13:30:24 -0700
Message-ID: <20250924203142.4073403-6-bvanassche@acm.org>
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
index 8d711f6d8959..868013cb1f46 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1534,6 +1534,14 @@ static void scsi_complete(struct request *rq)
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
@@ -1823,25 +1831,31 @@ static blk_status_t scsi_queue_rq(struct blk_mq_h=
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
@@ -1870,6 +1884,14 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw=
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

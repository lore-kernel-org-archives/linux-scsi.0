Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C529D4908C2
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 21:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786569990; cv=none; b=jfqn1Kc/b3rz7hx/h3evlc00TgaFiM4Qifub+vMLVIwqJZzzSxAYWqstHNk3Lb2v/9EXEk22SXKa0LGUIiTkwiXPhvPnmH9TmXEOGxGUOXFMjIuRCpz1JpHUML2zkKLPYPetBHrPkeAyCWp7IdTsxbk5FqExcTUksj/lhkcN8n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786569990; c=relaxed/simple;
	bh=hf4daiP7tswFStk0sCIHMee3gjgIt+WAjGo0pcAOYrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndlEvmQ1p1UsG0Xs4UG0E8M1ZEL+9QiC4svi/eL9ekW/jQsUpimuz9l1hTyqvUcXevRqN0glraxBHMx2IWQL4042SqWAJkN8Wd8H0ppwiAv3AymRfnmQs8A4eJIQJvuCvNf01zQG6tU8RxYbKKl0Rx+LE6XJ4zwOjZ0hBEIHmHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wyRy0CcE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wyRy0CcE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hL1kj4xRWz1XM4TB;
	Wed, 12 Aug 2026 21:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786569958; x=1789161959; bh=yiD6b
	cgpKlPiSI/N1k9/IAOIapxWOBiWnxhV3koVOls=; b=wyRy0CcEri3SyJfbf+9Bi
	Esz1E36B9lsQZfx46mZSXegy+rfITZzIGLWz9aNHtJdt9ak4vLMH7LQ2q6YTHztE
	vMsIf16b+E1elg6bmiwxFbzrJRSVvYyAjMO9MtTNKl9Wem/hA8AJ9UHO/l2wzYqS
	rqs5lMoYJ9gAijWScIXxizXLD9qeJzHEhxg8Tq8ro7r9jox/vxj8RvL2M+4tg6CK
	01vCK9wH47wXcOdulColFjqfPQoFa4Dl7JlgWeRJjT0zNgIRDMOy1Nj6ivuizplY
	Je8299Iyjx7OSE2GGKFVC5Wu/BkW/HRkMnLi3VydbuKpzYAdLEiWPvEPEOACpq9N
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uE6MQh0eNBEP; Wed, 12 Aug 2026 21:25:58 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hL1kW00BKz1XM6JR;
	Wed, 12 Aug 2026 21:25:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Hyeoncheol Jeong <hyenc.jeong@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v2 2/2] ufs: core: Do not forcibly complete SCSI commands
Date: Wed, 12 Aug 2026 21:25:24 +0000
Message-ID: <c31da15ae9aa15d891ff69fd342294f9bf687480.1786569828.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
In-Reply-To: <cover.1786569828.git.bvanassche@acm.org>
References: <cover.1786569828.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The SCSI core error handler is responsible for deciding whether to abort =
or
to requeue SCSI commands. A SCSI LLD shouldn't interfere with this decisi=
on.
Hence, do not call scsi_done() from inside the UFS error handler.

Also call ufshcd_mcq_compl_all_cqes_lock() for reserved commands - there
is no reason to skip this call for reserved commands.

Fix the comment above ufshcd_mcq_compl_pending_transfer().

This patch makes the MCQ behavior consistent with the behavior for legacy=
 mode.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d719100bfe38..b1d8900f9821 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6020,28 +6020,13 @@ static int ufshcd_poll(struct Scsi_Host *shost, u=
nsigned int queue_num)
=20
 static bool ufshcd_mcq_force_compl_one(struct request *rq, void *priv)
 {
-	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
 	struct scsi_device *sdev =3D rq->q->queuedata;
 	struct Scsi_Host *shost =3D sdev->host;
 	struct ufs_hba *hba =3D shost_priv(shost);
 	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
=20
-	if (blk_mq_is_reserved_rq(rq) || !hwq)
-		return true;
-
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-
-	/*
-	 * For those cmds of which the cqes are not present in the cq, complete
-	 * them explicitly.
-	 */
-	scoped_guard(spinlock_irqsave, &hwq->cq_lock) {
-		if (!test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
-			set_host_byte(cmd, DID_REQUEUE);
-			ufshcd_release_scsi_cmd(hba, cmd);
-			scsi_done(cmd);
-		}
-	}
+	if (hwq)
+		ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
=20
 	return true;
 }
@@ -6068,7 +6053,7 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
  * @hba: per adapter instance
  * @force_compl: This flag is set to true when invoked
  * from ufshcd_host_reset_and_restore() in which case it requires specia=
l
- * handling because the host controller has been reset by ufshcd_hba_sto=
p().
+ * handling because the host controller has been disabled by ufshcd_hba_=
stop().
  */
 static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 					      bool force_compl)

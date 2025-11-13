Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CC53587D6
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763057866; cv=none; b=O7skZgbcNzU8dfZysS/BMvQYNvcADW+JCxlnUHzlZb69AJXvxGrpFTlZ0s2EzZa4KyqktMx3P1SntA2M5ExjvK8HoZCyvumWcgQaNc+CF+bVBrJl5l8cnTp0aJ63aGaJt6J1BIQE2exNrQzYA9PoqMf2pZ0CM5zAVvAPywNYae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763057866; c=relaxed/simple;
	bh=EXR2QD+AeWfQxA0xOI9BEserkQJnNEKXbbx4M/MMwzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=maPferOVi3IKDNmXd/S91MpqLQiv3/fZMt0CUNlv7vpgFB8UC4f8Gkq5V5wHIVOOZ+MkTnzYRnP9ha2GqLSngCy+PXJgWXXLrVEdbtyiNF67J79muzMdg0S44Kxm5722CirO9QMZorql41C7VEs3Fi47S+4x3fl/oDnD3YA4Dmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=REFesSNf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="REFesSNf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d6pQv6rfrzlnfq4;
	Thu, 13 Nov 2025 18:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1763057862; x=1765649863; bh=WCNrplmRFtKh/orFAtfSxV77ikNnFb5wZtu
	k4iOUVFM=; b=REFesSNfHINoR5vEScU4lCzWPcQAY7ywDtNoiDvh9RjvFMTY6+U
	PN1aJP7UbGfvM8pgIZwY1bpEj+7ERr+w9uGwbpTNgOIiWKDjqVBxZR/4fNlC+5YA
	tz4bPm4RcSTdkUk2IOmS6rkAPmdPEYH03Xo7zK8xga+r6aVKRJkXC50n7K6xv6eC
	6Ge3Ye9P7b0B2LKZ8JWobWgZEioesn1WLVCfBdMb18W5UgjPMrtQNdd8rERs/MVO
	zRbCnWDAQqoqvNf61YIMAAGwJ3TXpWIlnpL3O3c29ntt2JMSGU4oLKZVq1/93w6u
	9PDa8XNwxJVg0A7p8J6sy9Z/kfs9mwHoDkA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id STtB4tXhS9_K; Thu, 13 Nov 2025 18:17:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d6pQp4h1vzlgqj7;
	Thu, 13 Nov 2025 18:17:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Introduce an enumeration type for the SCSI_MLQUEUE constants
Date: Thu, 13 Nov 2025 10:17:30 -0800
Message-ID: <20251113181730.1109331-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Multiple functions in the SCSI core accept an 'int reason' argument.
The 'int' type of these arguments doesn't make it clear what values are
acceptable for these arguments. Document which values are supported for
these arguments by introducing the enumeration type scsi_qc_status. 'qc'
in the type name stands for 'queuecommand' since the values passed as the
'reason' argument are the .queuecommand() return values.

Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c  | 11 ++++++-----
 drivers/scsi/scsi_priv.h |  3 ++-
 include/scsi/scsi.h      | 13 ++++++++-----
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 51ad2ad07e43..75c94f353114 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -76,7 +76,7 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 }
=20
 static void
-scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
+scsi_set_blocked(struct scsi_cmnd *cmd, enum scsi_qc_status reason)
 {
 	struct Scsi_Host *host =3D cmd->device->host;
 	struct scsi_device *device =3D cmd->device;
@@ -139,7 +139,8 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd=
, unsigned long msecs)
  * for a requeue after completion, which should only occur in this
  * file.
  */
-static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool =
unbusy)
+static void __scsi_queue_insert(struct scsi_cmnd *cmd,
+				enum scsi_qc_status reason, bool unbusy)
 {
 	struct scsi_device *device =3D cmd->device;
=20
@@ -179,7 +180,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd=
, int reason, bool unbusy)
  * Context: This could be called either from an interrupt context or a n=
ormal
  * process context.
  */
-void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
+void scsi_queue_insert(struct scsi_cmnd *cmd, enum scsi_qc_status reason=
)
 {
 	__scsi_queue_insert(cmd, reason, true);
 }
@@ -1577,7 +1578,7 @@ static void scsi_complete(struct request *rq)
  * Return: nonzero return request was rejected and device's queue needs =
to be
  * plugged.
  */
-static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
+static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host =3D cmd->device->host;
 	int rtn =3D 0;
@@ -1826,7 +1827,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
 	struct Scsi_Host *shost =3D sdev->host;
 	struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(req);
 	blk_status_t ret;
-	int reason;
+	enum scsi_qc_status reason;
=20
 	WARN_ON_ONCE(cmd->budget_token < 0);
=20
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d07ec15d6c00..7a193cc04e5b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -102,7 +102,8 @@ void scsi_eh_done(struct scsi_cmnd *scmd);
=20
 /* scsi_lib.c */
 extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmn=
d *cmd);
-extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
+extern void scsi_queue_insert(struct scsi_cmnd *cmd,
+			      enum scsi_qc_status reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 96b350366670..08ac3200b4a4 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -106,12 +106,15 @@ enum scsi_disposition {
 };
=20
 /*
- * Midlevel queue return values.
+ * Status values returned by the .queuecommand() callback if a command h=
as not
+ * been queued.
  */
-#define SCSI_MLQUEUE_HOST_BUSY   0x1055
-#define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
-#define SCSI_MLQUEUE_EH_RETRY    0x1057
-#define SCSI_MLQUEUE_TARGET_BUSY 0x1058
+enum scsi_qc_status {
+	SCSI_MLQUEUE_HOST_BUSY   =3D 0x1055,
+	SCSI_MLQUEUE_DEVICE_BUSY =3D 0x1056,
+	SCSI_MLQUEUE_EH_RETRY    =3D 0x1057,
+	SCSI_MLQUEUE_TARGET_BUSY =3D 0x1058,
+};
=20
 /*
  *  Use these to separate status msg and our bytes

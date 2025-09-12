Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD15324B25
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701521; cv=none; b=oGG4Bc2knLPn8SPR3cXXb7kSxHyh4aFZnRXCMHluQqIiL7Gl6wl3zEiVA1TTPTy/R1TdTETL62AM+nPz7PHcSjmUPmg3fzHGWkOOZAxe3eJPOQQRR5UacgNWE8V1ML6bryoZ1QkjW1BbnitJWP/0narrvaMVnGTNuQdqbyBQt8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701521; c=relaxed/simple;
	bh=CXmJ6Ph9J7lEe/PY4V2SAHO+dHi7QY5elrkqO1gzlLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFCANjLLINqRfOkRd3PzNG+lkYERr4mBUqM4BPc4gygMYfs+FbZl56Fj4I6uUnmK8jgO6DGln2QLcgUNBvIVnqNqTlSpg6YjQaD7tfo4z1ywXHRdu1e+OAGlIkiOc9BHl1ncgkHr8cACTPvDSqin5ALsVb5oH/gkDXiiEa6s0No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qKZRVyT5; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qKZRVyT5"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjXH3JLRzltJQj;
	Fri, 12 Sep 2025 18:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701517; x=1760293518; bh=Hc5ss
	U9+/loxQGkmaoB0Ij4WzGHW0SVyI6/SdJV4W+I=; b=qKZRVyT5yKOuISwoRpPtE
	Aa/BDaYcccDdXdy7bOAm8+z4M015oBR7jOlmcI70K/d+inkfwTmryo48ysP2fR1Q
	LK3mUiXvoHOHmk0tNe5bhtqsFrAheh+O2WjixMMqCDNrT5yFNk1zzvXf6wJNeBO8
	ckTVRVNmWed9zuiOYo24wlxtoEFg6nRZNReoSFDSyIFb/2ZXfrej8D1ZFTHQLCCJ
	tTWuodUy2voGaYy+2JK9HItVK+BZIHFqLj8liXtjaFHIsDySHIQsWTipaFdrFBj8
	0047i8VAqcC3OZ01OV2NHOg//DWajnWBAKNIrKO7mdl3OfPyctENnOEN/YDtWGUk
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id l3kYQFqKyy41; Fri, 12 Sep 2025 18:25:17 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjX81q48zlgqVJ;
	Fri, 12 Sep 2025 18:25:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd() functionality
Date: Fri, 12 Sep 2025 11:21:27 -0700
Message-ID: <20250912182340.3487688-7-bvanassche@acm.org>
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

Make the @cmd argument optional. Add .init_cmd() and .copy_result()
callbacks in struct scsi_exec_args. Support allocating from a specific
hardware queue. This patch prepares for submitting reserved commands
with scsi_execute_cmd().

Cc: John Garry <john.g.garry@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 28 +++++++++++++++++++++++++---
 include/scsi/scsi_cmnd.h   |  2 ++
 include/scsi/scsi_device.h | 37 +++++++++++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5e636e015352..022cd454d658 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -308,7 +308,10 @@ int scsi_execute_cmd(struct scsi_device *sdev, const=
 unsigned char *cmd,
 		return -EINVAL;
=20
 retry:
-	req =3D scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
+	req =3D args->specify_hctx ?
+		scsi_alloc_request_hctx(sdev->request_queue, opf,
+					args->req_flags, args->hctx_idx) :
+		scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
=20
@@ -318,8 +321,12 @@ int scsi_execute_cmd(struct scsi_device *sdev, const=
 unsigned char *cmd,
 			goto out;
 	}
 	scmd =3D blk_mq_rq_to_pdu(req);
-	scmd->cmd_len =3D COMMAND_SIZE(cmd[0]);
-	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
+	if (cmd) {
+		scmd->cmd_len =3D COMMAND_SIZE(cmd[0]);
+		memcpy(scmd->cmnd, cmd, scmd->cmd_len);
+	}
+	if (args->init_cmd)
+		args->init_cmd(scmd, args);
 	scmd->allowed =3D ml_retries;
 	scmd->flags |=3D args->scmd_flags;
 	req->timeout =3D timeout;
@@ -353,6 +360,9 @@ int scsi_execute_cmd(struct scsi_device *sdev, const =
unsigned char *cmd,
 				     args->sshdr);
=20
 	ret =3D scmd->result;
+	if (ret =3D=3D 0 && args->copy_result)
+		args->copy_result(scmd, args);
+
  out:
 	blk_mq_free_request(req);
=20
@@ -1247,6 +1257,18 @@ struct request *scsi_alloc_request(struct request_=
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
index 3846f5dfc51c..2b2dc08962a2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -541,15 +541,36 @@ struct scsi_failures {
 	struct scsi_failure *failure_definitions;
 };
=20
-/* Optional arguments to scsi_execute_cmd */
+/**
+ * struct scsi_exec_args - Optional arguments to scsi_execute_cmd()
+ * @init_cmd: called before the command is executed.
+ * @copy_result: called after the command has been executed.
+ * @sense: sense buffer.
+ * @sense_len: sense buffer len
+ * @sshdr: decoded sense header
+ * @req_flags: BLK_MQ_REQ flags
+ * @scmd_flags: SCMD flags.
+ * @resid: residual length.
+ * @failures: which failures to retry.
+ * @specify_hctx: call scsi_alloc_request_hctx() if %true or
+	scsi_alloc_request() otherwise.
+ * @hctx_idx: Passed as fourth argument for scsi_alloc_request_hctx() if
+	@specify_hctx is %true.
+ */
 struct scsi_exec_args {
-	unsigned char *sense;		/* sense buffer */
-	unsigned int sense_len;		/* sense buffer len */
-	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
-	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
-	int scmd_flags;			/* SCMD flags */
-	int *resid;			/* residual length */
-	struct scsi_failures *failures;	/* failures to retry */
+	int (*init_cmd)(struct scsi_cmnd *cmd,
+			const struct scsi_exec_args *args);
+	void (*copy_result)(struct scsi_cmnd *cmd,
+			    const struct scsi_exec_args *args);
+	unsigned char *sense;
+	unsigned int sense_len;
+	struct scsi_sense_hdr *sshdr;
+	blk_mq_req_flags_t req_flags;
+	int scmd_flags;
+	int *resid;
+	struct scsi_failures *failures;
+	bool specify_hctx;
+	int hctx_idx;
 };
=20
 int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,

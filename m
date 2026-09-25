Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE194D7D3E
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361024; cv=none; b=OsHOTyblJ+lNws5FO/lsqtVrms1WSNxS+5XJbZJCySsyhVh64qUKoUh1e++qOPU53nNhoz/ejDAna7el17vApcwktJoXc8+A1Mv88oRmeR4WIRG1j3dIV/Dt2T9z+XVzwrevDKY6qhWTheWjEqj0T1oCf8KSg6JxljeYh9jJCrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361024; c=relaxed/simple;
	bh=6wcHFRggteGTn5sGYd1hC9urq3znmWpA6giAwQWaRpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb0uKv5M+FlYeoc9P/CwfS1jIVOdDJqAVtrsm/MhB6uMmMn6T6lMlL7ccXrTGjgWtbe+V+f9qJF2yNit47NbwG7j3Z5dhteQydgQVgh5FPqeVHSJam0SHVFMSq7x6S5vBf1pF340fEIUZwzkDZQWp6EG0gT/zzdhd/M888V2GrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=q4K0sprN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="q4K0sprN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzld4Lh3z1XM5kt;
	Fri, 25 Sep 2026 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361016; x=1792953017; bh=IE0uq
	Yh8f9EEGVTDBOB1/dplJKKA0lgYaWJsFi55+is=; b=q4K0sprNdfKCSRXcYn8e7
	qDB66Vnq6gqH1EcuhMHZEQcKZ+2/SS6Zsg50Um20SPxkqQK+BDOu/VL0FFWtamxH
	HnD5jKCbByiAauQojLIprSoK4gDMekjCxKwiAV7ryW8GC3T7/pXO59yyWyD9XTqq
	O1eQrMv96Id/es3HCy9Ul/h6cewZRrrwfoJtTOAMVvvGbg/McUF56uA785WBj9+6
	jsfx9BA1U1qJ+Fr11bVUTsScuUen+7L+rOCPxTO12zGD1anjAkB4oO0zEpX/Fpta
	J3DzA7V9se8HvVKbimw0HzK9+2bhY8kNQATT8aDpHqEYGem1+XQPJdkuRy16H2a+
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SB3KkBZSyIHJ; Fri, 25 Sep 2026 18:30:16 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzlV0Q8nz1XM5kY;
	Fri, 25 Sep 2026 18:30:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 19/54] scsi: bnx2i: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:57 -0700
Message-ID: <4cafc1018d9a072df3952488ca0bf4ffb7410be7.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold(). Add an __assume_ctx_loc=
k()
annotation where locking is missing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2i/Makefile      | 3 +++
 drivers/scsi/bnx2i/bnx2i_hwi.c   | 5 +++++
 drivers/scsi/bnx2i/bnx2i_iscsi.c | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/bnx2i/Makefile b/drivers/scsi/bnx2i/Makefile
index 25378671bb1e..2d8e8f0fdd29 100644
--- a/drivers/scsi/bnx2i/Makefile
+++ b/drivers/scsi/bnx2i/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 bnx2i-y :=3D bnx2i_init.o bnx2i_hwi.o bnx2i_iscsi.o bnx2i_sysfs.o
=20
 obj-$(CONFIG_SCSI_BNX2_ISCSI) +=3D bnx2i.o
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hw=
i.c
index 4d4eca23d471..c22f1c981d02 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -405,6 +405,11 @@ int bnx2i_send_iscsi_tmf(struct bnx2i_conn *bnx2i_co=
nn,
 	switch (tmfabort_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
 	case ISCSI_TM_FUNC_ABORT_TASK:
 	case ISCSI_TM_FUNC_TASK_REASSIGN:
+		/*
+		 * TODO: hold session->back_lock around the iscsi_itt_to_task()
+		 * call below.
+		 */
+		__assume_ctx_lock(&session->back_lock);
 		ctask =3D iscsi_itt_to_task(session, conn, tmfabort_hdr->rtt);
 		if (!ctask || !ctask->sc)
 			/*
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_=
iscsi.c
index 6c80e5b514fd..c868eada72c3 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1154,6 +1154,7 @@ static void bnx2i_cpy_scsi_cdb(struct scsi_cmnd *sc=
, struct bnx2i_cmd *cmd)
 }
=20
 static void bnx2i_cleanup_task(struct iscsi_task *task)
+	__must_hold(&task->conn->session->back_lock)
 {
 	struct iscsi_conn *conn =3D task->conn;
 	struct bnx2i_conn *bnx2i_conn =3D conn->dd_data;

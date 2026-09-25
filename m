Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7806E4D37BD
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360998; cv=none; b=shcU8CKO4Lfo1y6qEuvXXdRhgg3V4LCFHMcAD3fCHxMJ4mQYdpBRsg0pBREgcc9a7/iWqO29zRb19ApWSbVNy4LlwPKMi+QjLgsy5hZZV33TjSfw4Ggg5lQ5Px+NCqlvXdpUPDUgJIm1bB2BKoeFa4gKy93GlGXGuIr8Ux14ZSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360998; c=relaxed/simple;
	bh=8zlSSVjNpc4F8T/3Cv7VqjUzUEws6k/AHTd8sJgQbsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mErrS1mORW/0B03axXZBC9Smwr8T4H08QzL/Z2/ZPwpBqhPDBdAeHL5T8Fh7P1zrLcVEIIkPZPXxmooi8shnzxhfWwEfOerM69dOT1ye0cgxbAuU3CywJ7JmI8t1HbStWHxTetenrBeU/67T1U800XSFIocCvCmPuP8/hmS1LRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2CWxRo7J; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2CWxRo7J"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzl7400cz1XM5kY;
	Fri, 25 Sep 2026 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360991; x=1792952992; bh=jCq+A
	moHwtJOpmLpMJnBbBDF/lR981ysAXCBiPZpJ6E=; b=2CWxRo7JBJSpKDOuD8rph
	DxsOhKmrqC4mSzxIEvK9hhPFPeiPRQbJXON3TyEHH/8coAlTssJLX+YHpztKU5Ux
	xJ3aSK492AbXfnnDPJHqPIZGW88bg2ZR5Myf3q5R6i1+8/scJ+LRG0uOJUDcOO/X
	aw7PeCbkxKtd7VHzyDkKV2muMaWUO6NsMY/ZrBamZqHzirRiXx5xrLeyBUmk8Xed
	vzROWjfvqhO/E22ftf4HGQa5w4SIwqwFLtaisWpZyu1d/3C46Q2UYZlnciTY+8WQ
	xrlIC3Hw/2HV41eWlpnGSuL4IY7qnXNw0Xf0xB50lrfi3NdA+NEG52W2ZhO3gfsA
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RosdqOtnNdMp; Fri, 25 Sep 2026 18:29:51 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzl11K5sz1XM4Tl;
	Fri, 25 Sep 2026 18:29:48 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 14/54] scsi: be2iscsi: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:52 -0700
Message-ID: <e50dc59c2e48c84442e959e17989fb436eac6810.1790360262.git.bvanassche@acm.org>
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

Document locking requirements by annotating locking requirements with
__must_hold(). Enable lock context analysis for the be2iscsi driver by
setting CONTEXT_ANALYSIS in the Makefile.

Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/be2iscsi/Makefile  | 2 ++
 drivers/scsi/be2iscsi/be_main.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/be2iscsi/Makefile b/drivers/scsi/be2iscsi/Makef=
ile
index 910885343a75..73d47c687007 100644
--- a/drivers/scsi/be2iscsi/Makefile
+++ b/drivers/scsi/be2iscsi/Makefile
@@ -4,6 +4,8 @@
 #
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_BE2ISCSI) +=3D be2iscsi.o
=20
 be2iscsi-y :=3D be_iscsi.o be_main.o be_mgmt.o be_cmds.o
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
index c8ee0473a1dd..356ab9c0fb7c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1117,6 +1117,7 @@ static void
 be_complete_io(struct beiscsi_conn *beiscsi_conn,
 		struct iscsi_task *task,
 		struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct beiscsi_io_task *io_task =3D task->dd_data;
 	struct be_status_bhs *sts_bhs =3D
@@ -1185,6 +1186,7 @@ static void
 be_complete_logout(struct beiscsi_conn *beiscsi_conn,
 		    struct iscsi_task *task,
 		    struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct iscsi_logout_rsp *hdr;
 	struct beiscsi_io_task *io_task =3D task->dd_data;
@@ -1212,6 +1214,7 @@ static void
 be_complete_tmf(struct beiscsi_conn *beiscsi_conn,
 		 struct iscsi_task *task,
 		 struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct iscsi_tm_rsp *hdr;
 	struct iscsi_conn *conn =3D beiscsi_conn->conn;
@@ -1268,6 +1271,7 @@ static void
 be_complete_nopin_resp(struct beiscsi_conn *beiscsi_conn,
 			struct iscsi_task *task,
 			struct common_sol_cqe *csol_cqe)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct iscsi_nopin *hdr;
 	struct iscsi_conn *conn =3D beiscsi_conn->conn;
@@ -1423,6 +1427,7 @@ static void hwi_complete_cmd(struct beiscsi_conn *b=
eiscsi_conn,
 static unsigned int
 beiscsi_complete_pdu(struct beiscsi_conn *beiscsi_conn,
 		struct pdu_base *phdr, void *pdata, unsigned int dlen)
+	__must_hold(&beiscsi_conn->conn->session->back_lock)
 {
 	struct beiscsi_hba *phba =3D beiscsi_conn->phba;
 	struct iscsi_conn *conn =3D beiscsi_conn->conn;

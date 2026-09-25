Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403174D9549
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361144; cv=none; b=rc+wealJDCtPlyWI37kFqxmB3Wk0qHKP8qIxQha8B4VCi/dHce7dt+A0GNngi5/8TYB6ZPZmdzjq2b2E+Ad0zbpoxBrBRB3SXa6LjbXCmHt3zddkmw6xxUaXKusHmSZv8R1yVxqQ+3geRfIvc7M09PDhEyUG2Xg2FB9H6iSZvfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361144; c=relaxed/simple;
	bh=wm8Y0h7CXujuW+lUYAcVdgBOslcmjktFJbM1A4VlwkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMkXgm2sYlZHU7rcZcZIwaiojwKOLiP1uTNONqZYAFy489HTzU8bJ7wLaGtRv3UjdQwbYcpoUTqUJI4afNrW0/4Ee3AREc7+4tL+YUqBn5wNqIydKdWrdIpYy4RmZmtOGBnpPLqQ4IZBvihdWXZB+mfDVzDZEv4qyG0PB+UEGjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n3/Jpeom; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n3/Jpeom"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzny5hx6z1XM5kt;
	Fri, 25 Sep 2026 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361137; x=1792953138; bh=/rbpe
	/zDpJ0Uj5xNoJnswnIYWHF/6pcORhNGmUVRUPY=; b=n3/JpeomWWJuTW0pvk+Vy
	AJVQR4jqir7lMBdQuR7UzdIZ2BgbRI0eoulLGn5/+PJaZkniHQ9ilWWeyg6abq3A
	I7wQ/TCyVseSxZVP422HsEZBygB9w+BVwcAn1CBTO/4fkeM+r+gzs6noa9EjsT/R
	7XbHIyhKE76SpFIcx8y6DWe7f9krVm00KOzO0m0elwPu8n7NExHsZnuFAjZg47cp
	BKo3Wa24QGn46qzuvO1ek55F5oW2RLnKGPIpsiHZTH/p06rdZu7Ipoa2wvJWuB+i
	JiVP8ZYw4NIA2Vx5fbJGNbzn6P4sUG/BDd2DbCIofxtxZqIY61pIZCn94FG0kKou
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6vtJPyCLiEvP; Fri, 25 Sep 2026 18:32:17 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrznp6ncwz1XM4Sx;
	Fri, 25 Sep 2026 18:32:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 39/54] scsi: lpfc: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:26:17 -0700
Message-ID: <9ace40e6af0b7623c61d9e3caad997856455dbef.1790360262.git.bvanassche@acm.org>
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

Annotate the functions that perform conditional locking with
__context_unsafe().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 2 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 1 +
 drivers/scsi/lpfc/lpfc_scsi.c      | 1 +
 drivers/scsi/lpfc/lpfc_sli.c       | 2 ++
 4 files changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6f6394a0047c..9274f9b04057 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9597,6 +9597,7 @@ lpfc_els_timeout(struct timer_list *t)
  **/
 void
 lpfc_els_timeout_handler(struct lpfc_vport *vport)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct lpfc_hba  *phba =3D vport->phba;
 	struct lpfc_sli_ring *pring;
@@ -9719,6 +9720,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
  **/
 void
 lpfc_els_flush_cmd(struct lpfc_vport *vport)
+	__context_unsafe(/*conditional locking*/)
 {
 	LIST_HEAD(abort_list);
 	LIST_HEAD(cancel_list);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
index 9c449055a55e..179971a293f6 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -220,6 +220,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
  */
 void
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+	__context_unsafe(/*conditional locking*/)
 {
 	LIST_HEAD(abort_list);
 	LIST_HEAD(drv_cmpl_list);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
index 8dd876a1a78d..3f39cc065029 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5507,6 +5507,7 @@ void lpfc_vmid_vport_cleanup(struct lpfc_vport *vpo=
rt)
  **/
 static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct Scsi_Host  *shost =3D cmnd->device->host;
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(cmnd->device));
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cd285e87c278..8fb6d8a1cfb2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3722,6 +3722,7 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 static int
 lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *p=
ring,
 			  struct lpfc_iocbq *saveq)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct lpfc_iocbq *cmdiocbp;
 	unsigned long iflag;
@@ -12876,6 +12877,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16=
 tgt_id, u64 lun_id,
 int
 lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *=
pring,
 			uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd cmd)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct lpfc_hba *phba =3D vport->phba;
 	struct lpfc_io_buf *lpfc_cmd;

Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5E447B429
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573462; cv=none; b=Myu1EOsWAOOVImtqyejlzsoQvfwJU5O/P9hUN3CwFUI9u/AX6C0Jb9Lj7OvQCub/RzsOSo/RpR+wW0adWXW8hLarutAb6gL0wBesQWXRDkpKuea9TTB1YAg2Wld2zZFJyZtm4kRKg3pBxxQX+GSsuqAfBLe6S6TgYyRgVyEbblQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573462; c=relaxed/simple;
	bh=LNVHNIBrZ5OU3fBnKOVT4FWjEVcFDO3JG31V8X2/YJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fz8FKwPBjgMcKjOJ9eBuyYXa5YMAoyL/dip5BI9n+U4d5wB6VtyGiTZcE8boF/mF5HMtrqWsQgVA2zVQkkyHkxIQtGd/f/ex2WWusmNnJBFsqDxMww6tumHbNAQxRAf3Jvheb1fzFP/dLzU0qPYO7CYrbH7wBFUB54mmtvst/uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OOQo6YUZ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OOQo6YUZ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62d11Y8xzm1W1N;
	Thu, 30 Apr 2026 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573456; x=1780165457; bh=7KzzC
	ryJkqV9WP/MgULXnnr0Z03HaKL3uTsWP+33grA=; b=OOQo6YUZZ2c0TFLNrXolY
	AAR79lFh4Lqq/XCvOdeY3VEnZCwVHHHbmiX2KK12idyBOjX6bcaxHqixJrIi2/m7
	M8LWm7/tdgXeogJQWWoF/mMo++PzaaJdE7mn4xsg6JB08o/eG7F4A7XTSwM3Char
	n0rmLGu3QEfhc+n1yoRm4ukfuZNfZYf5w4ftkGH2E1dR1KxP+hHouW75UeCtcPeR
	CwdRJSfbopj+uuBc0ZwF07sSkWDmJXbM4gBArcwl5PpOdKzthNkSFFEW+kzgsMf2
	OcN3UPqZtsY/EZI4OJRTRyBJ6g06fLQSjbdoBP/4YMV8PFPZpvq8q3BwW7EBgyMT
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nRDPZ4KSSwAE; Thu, 30 Apr 2026 18:24:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62ct6qSPzlfvpH;
	Thu, 30 Apr 2026 18:24:14 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 38/56] scsi: lpfc: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:20:08 -0700
Message-ID: <20260430182130.1978347-39-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Annotate the functions that perform conditional locking with
__no_context_analysis.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/lpfc/lpfc_els.c       | 2 ++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 1 +
 drivers/scsi/lpfc/lpfc_scsi.c      | 1 +
 drivers/scsi/lpfc/lpfc_sli.c       | 2 ++
 4 files changed, 6 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4e3fe89283e4..938f5af2d01d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9597,6 +9597,7 @@ lpfc_els_timeout(struct timer_list *t)
  **/
 void
 lpfc_els_timeout_handler(struct lpfc_vport *vport)
+	__context_unsafe(conditional locking)
 {
 	struct lpfc_hba  *phba =3D vport->phba;
 	struct lpfc_sli_ring *pring;
@@ -9719,6 +9720,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
  **/
 void
 lpfc_els_flush_cmd(struct lpfc_vport *vport)
+	__context_unsafe(conditional locking)
 {
 	LIST_HEAD(abort_list);
 	LIST_HEAD(cancel_list);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
index 9c449055a55e..79e5e876c879 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -220,6 +220,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
  */
 void
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+	__context_unsafe(conditional locking)
 {
 	LIST_HEAD(abort_list);
 	LIST_HEAD(drv_cmpl_list);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
index 1dce33b79beb..028f7cf065f8 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5520,6 +5520,7 @@ void lpfc_vmid_vport_cleanup(struct lpfc_vport *vpo=
rt)
  **/
 static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
+	__context_unsafe(conditional locking)
 {
 	struct Scsi_Host  *shost =3D cmnd->device->host;
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(cmnd->device));
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d38fb374b379..14a4d4953657 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3721,6 +3721,7 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 static int
 lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *p=
ring,
 			  struct lpfc_iocbq *saveq)
+	__context_unsafe(conditional locking)
 {
 	struct lpfc_iocbq *cmdiocbp;
 	unsigned long iflag;
@@ -12871,6 +12872,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16=
 tgt_id, u64 lun_id,
 int
 lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *=
pring,
 			uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd cmd)
+	__context_unsafe(conditional locking)
 {
 	struct lpfc_hba *phba =3D vport->phba;
 	struct lpfc_io_buf *lpfc_cmd;

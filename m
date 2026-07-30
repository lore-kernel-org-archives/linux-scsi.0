Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A58D3B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451722; cv=none; b=S0qZaoyLQ1VDb1H59MajSgZybeyryHpHM8CVEzNkyIsXjOeuzR+zEIIz+yP0Kl3DRVglOOqYYeyDG30OD9yQftY5EEwXX2kfKh3iW+onavR7hMraoeVxh5EwVjyyLjNkKx0dYsb94MWDH9Tc5j3vhTYnxuxy6OVyMG9tZVt6vqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451722; c=relaxed/simple;
	bh=h1N9YffdUul8Qd0/OXJwUNRhYzvBRT/b8VTFFqg2YBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1V2YZe0Ha1VblUn9mt2H9/RUhqcdobTLjTePzNcbAFwgBPlbkbeWiykpbVnLBBV4mxfTu9wmalmu/k9TStqxDPLIfw3FMuFStdf6mJ3miu8ITd77M3LSWHyVOGfuP9ub78VCvlCDMPkZC2/mIMsH3zAIS6v4mIwcxZ+8ccnp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=40RWUBwZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="40RWUBwZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4B12TPPz1XM6Jk;
	Thu, 30 Jul 2026 22:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451715; x=1788043716; bh=GkQ9a
	PASz4pVAO/q7k8mRkb4cgHIt+kxGJdg67fLMCQ=; b=40RWUBwZOoVTArMLwXWll
	sORbwvquQHoE0gsQh0bqtUgNxXsixn/xMOZsE2lsBnutrw92EwMA0P6Xh5w2dKMh
	LID5sBrHMx+oFEQjnFINE5yJEVurdYCwRP9LOyc9cKWq7LqGxjdMTmG8TFFSipTy
	kOsb817NlsrzvVglsMyB4wDV6F914VeErucABdCu5BC1OQDxjwEYfgFJ3Te8DpQB
	haJclNkmaXVMBOB1vMkyjZkOJBiMa0iGFJBmF9e7ed75CvHD0KIqFkQYc3EVL0C0
	BRaSXPdgVFo5U+VngCQFWGGIRdnboHXIQ6ftify8hBvOE2pV2/wFWq50ICvPcrH9
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id p6-Zag0xbC5t; Thu, 30 Jul 2026 22:48:35 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49s5F74z1XM30k;
	Thu, 30 Jul 2026 22:48:33 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 38/57] scsi: lpfc: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:45:21 -0700
Message-ID: <d7f69e9511ca5b79b64f48b1e54fb417db4d294f.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
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
index 52fc5058976d..45e7f147b163 100644
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
index f2cab134af7f..6c3fd3c33c53 100644
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
index 62a30a92b792..c76d62e8907c 100644
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

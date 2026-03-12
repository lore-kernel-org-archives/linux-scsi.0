Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D8E26B2DA
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350284; cv=none; b=KDQPyvujnNDFFXQveg3VEwLpzKlSuKI3T1mned7eiVxjE1G7AvbxachPyysqn4idPWnb3jQslmpj/SbpIozuD7geBfbqJgmkwovOA09P2Gho8EKD+1T5kLONLKFlmfdohHOgD+fIy7OzUeauzZX/+pVDTajSWUqDkhmNMPu9aYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350284; c=relaxed/simple;
	bh=Y8raaA0f/A4UUdznSbiPdaiAAuZ3zy6R02dZuigy4ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heHw3JRplEsRs/4jRgcpQSxk0iY0RClS3Sq5DWX4mPF1juLEInILwQfbALda60SwjRe6N1gAWvmInmDKvip6VeP1i5HLcRASoPrsXRyl21e1OFNplvPt3NzkY6FjeMquGgYtExg0hvduu9jiJ6vfKO3DVrPOHKKmp+N9IKTGKvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=m3ByTHAC; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="m3ByTHAC"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0p30gGJzlfl5W;
	Thu, 12 Mar 2026 21:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350279; x=1775942280; bh=bFNCk
	41j9plMndv3RwYoYAO5dkzf0uxdQMFaxhF4JD8=; b=m3ByTHACzZYtG1YBM+DhS
	WCvJzPeq7A6utr8LFpn57s/+KZW6bvN/VRq+fMJ0RjFYNGmvJbXiIPVFWSBD1iKk
	fwOq43dMe/wUFVWNmPSXK13+5j7lvhX2BxZogQsko3/RPQLcORI9Yr4zhLJy8cCo
	N4GAnashJv0MUcIeRY9Zo+yfCAmSOixpiIrrSOau4+gBsV2PUudvtsG9Y8wUkEbu
	09+ykge15ZULi61HzBCEvYWno4gMxQn0eRW0T0QXjnqFbI4UVX8OWRVayvXCU0Va
	sZJ3HmEAzxopQQ14kmBJl+IGmfuz3y6U5jxcSREK5QXTpoSHHhl/6AyBum89s1Wz
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kH-vLAG0LCNX; Thu, 12 Mar 2026 21:17:59 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nx5xzgzlfl8L;
	Thu, 12 Mar 2026 21:17:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 24/36] scsi: lpfc: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:35 -0700
Message-ID: <20260312211636.3245119-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
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
index 10b3e6027a57..d09d64526c90 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9587,6 +9587,7 @@ lpfc_els_timeout(struct timer_list *t)
  **/
 void
 lpfc_els_timeout_handler(struct lpfc_vport *vport)
+	__no_context_analysis /* conditional locking */
 {
 	struct lpfc_hba  *phba =3D vport->phba;
 	struct lpfc_sli_ring *pring;
@@ -9709,6 +9710,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
  **/
 void
 lpfc_els_flush_cmd(struct lpfc_vport *vport)
+	__no_context_analysis /* conditional locking */
 {
 	LIST_HEAD(abort_list);
 	LIST_HEAD(cancel_list);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_=
nportdisc.c
index 5e431928de0b..29d860a082f5 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -220,6 +220,7 @@ lpfc_check_elscmpl_iocb(struct lpfc_hba *phba, struct=
 lpfc_iocbq *cmdiocb,
  */
 void
 lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
+	__no_context_analysis /* conditional locking */
 {
 	LIST_HEAD(abort_list);
 	LIST_HEAD(drv_cmpl_list);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c
index e9d27703bc44..273d40901e7d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5521,6 +5521,7 @@ void lpfc_vmid_vport_cleanup(struct lpfc_vport *vpo=
rt)
  **/
 static int
 lpfc_abort_handler(struct scsi_cmnd *cmnd)
+	__no_context_analysis /* conditional locking */
 {
 	struct Scsi_Host  *shost =3D cmnd->device->host;
 	struct fc_rport *rport =3D starget_to_rport(scsi_target(cmnd->device));
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bd71292e7480..c5f5f4826ee1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3728,6 +3728,7 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 static int
 lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *p=
ring,
 			  struct lpfc_iocbq *saveq)
+	__no_context_analysis /* conditional locking */
 {
 	struct lpfc_iocbq *cmdiocbp;
 	unsigned long iflag;
@@ -12886,6 +12887,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *vport, u16=
 tgt_id, u64 lun_id,
 int
 lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *=
pring,
 			uint16_t tgt_id, uint64_t lun_id, lpfc_ctx_cmd cmd)
+	__no_context_analysis /* conditional locking */
 {
 	struct lpfc_hba *phba =3D vport->phba;
 	struct lpfc_io_buf *lpfc_cmd;

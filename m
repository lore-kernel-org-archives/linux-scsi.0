Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127DF3A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361087; cv=none; b=rdztLtltHKBl2k6flRfyAYRtxGuVNneeEWDTra2Ul4SEjf1h21Xnxu7ac48AP/XNhHfqO/ZT+smnfqVrWbPiCCmzinPpasCPUv3h5VCYYPNsRsd9Vz47APK8QQQEEOd+UdVhjdcOGTPqHLDf8wkp7ZcC/zRB0oOsLDLMxTEXu7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361087; c=relaxed/simple;
	bh=pHcSU2s8YL+M8BQtj1cJYfWs2ypc38d0F4jZYSD0GBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUuFZPke4uS4ys6wOB0AbCjy1YZWamzzg/SXuR4Czq9uNkTDLsoGF9MFddfMxsXfeZLqFSSfPtAZzgcY0LcBUxC5zgY98QmdgEU5JeHVF8oF2Zap1WMc7J9w8jWm+mrJRxviyex9LUB2TKJ3XvMko+ZdOX7v6zmqJWqSuPhFm1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=W+zRUA1N; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="W+zRUA1N"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzms3n0Rz1XM30j;
	Fri, 25 Sep 2026 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361076; x=1792953077; bh=ZBIRe
	xYqEdO1UY0vgYXB0TbwBbzBOSiU45roEQIerGE=; b=W+zRUA1NImu/sOwN/wPqp
	Pq1Cez3W8knl63kwEkH7gwehubiyKJhUMbpwVvxrhxSG/oEGtvkOplIEHt6WsTnP
	60keEv0e0lRY0yVF63IGRg1S8PFfTOu5wskS/C1+cztZJEk7clKpbMsnfEltcUxR
	OBO8sQLWJAdjNBkchy2bbPamjKVD9E79pV04/nplQcG0Am/uWLnrjPlhaolQUc9z
	eLyT0SUwh0uwulEQ8NtHAVs21zJLkY1uRXMi0/mmgcoC9IqwrT9+7ysBWEbaSnv6
	EJ+nsBHeRvnzOVivV/96wYJwkk7/B5qtckIbCTZiqRn9p/bgKSkcHssBQQuVHHF1
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pl_Kk4tur4kq; Fri, 25 Sep 2026 18:31:16 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmd1yCQz1XM5kt;
	Fri, 25 Sep 2026 18:31:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 25/54] scsi: fnic: Pass pointers directly to several functions
Date: Fri, 25 Sep 2026 11:26:03 -0700
Message-ID: <8351d2f8c89a02fe537238d70d25d443375dca94.1790360262.git.bvanassche@acm.org>
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

In fdls_target_restart_nexus(), pass the struct fnic_iport_s pointer
directly from callers instead of deriving it from tport->iport. In
fnic_fdls_add_tport() and fnic_fdls_remove_tport(), pass the struct fnic
pointer directly instead of the struct fnic_iport_s pointer. This patch
prepares for enabling lock context analysis. No functionality has been
changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fdls_disc.c | 11 ++++++-----
 drivers/scsi/fnic/fnic_fcs.c  | 19 ++++++++-----------
 drivers/scsi/fnic/fnic_fdls.h |  7 +++----
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.=
c
index 8cb40466872f..7a33ec703391 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -87,7 +87,8 @@ static void fnic_fdls_start_flogi(struct fnic_iport_s *=
iport);
 static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport=
,
 					  uint32_t fcid,
 					  uint64_t wwpn);
-static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
+static void fdls_target_restart_nexus(struct fnic_iport_s *iport,
+				      struct fnic_tport_s *tport);
 static void fdls_start_tport_timer(struct fnic_iport_s *iport,
 					struct fnic_tport_s *tport, int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
@@ -1810,9 +1811,9 @@ static void fdls_tgt_discovery_start(struct fnic_ip=
ort_s *iport)
  * safely since the memory it is
  * pointing to it will be freed later
  */
-static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
+static void fdls_target_restart_nexus(struct fnic_iport_s *iport,
+				      struct fnic_tport_s *tport)
 {
-	struct fnic_iport_s *iport =3D tport->iport;
 	struct fnic_tport_s *new_tport =3D NULL;
 	uint32_t fcid;
 	uint64_t wwpn;
@@ -2767,7 +2768,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *ipo=
rt,
 	if (tport->state !=3D FDLS_TGT_STATE_PLOGI) {
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			     "PLOGI rsp recvd in wrong state. Drop the frame and restart nexu=
s");
-		fdls_target_restart_nexus(tport);
+		fdls_target_restart_nexus(iport, tport);
 		return;
 	}
=20
@@ -2893,7 +2894,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *ipor=
t,
 	if (tport->state !=3D FDLS_TGT_STATE_PRLI) {
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			     "PRLI rsp recvd in wrong state. Drop frame. Restarting nexus");
-		fdls_target_restart_nexus(tport);
+		fdls_target_restart_nexus(iport, tport);
 		return;
 	}
=20
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index b00672ef8b00..0668770dfb5d 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -942,10 +942,9 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vni=
c_wq_buf *buf)
 }
=20
 void
-fnic_fdls_add_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tpo=
rt,
-					unsigned long flags)
+fnic_fdls_add_tport(struct fnic *fnic, struct fnic_tport_s *tport,
+		    unsigned long flags)
 {
-	struct fnic *fnic =3D iport->fnic;
 	struct fc_rport *rport;
 	struct fc_rport_identifiers ids;
 	struct rport_dd_data_s *rdd_data;
@@ -975,18 +974,16 @@ fnic_fdls_add_tport(struct fnic_iport_s *iport, str=
uct fnic_tport_s *tport,
 	rport->supported_classes =3D FC_COS_CLASS3 | FC_RPORT_ROLE_FCP_TARGET;
 	rdd_data =3D rport->dd_data;
 	rdd_data->tport =3D tport;
-	rdd_data->iport =3D iport;
+	rdd_data->iport =3D &fnic->iport;
 	tport->rport =3D rport;
 	tport->flags |=3D FNIC_FDLS_SCSI_REGISTERED;
 }
=20
 void
-fnic_fdls_remove_tport(struct fnic_iport_s *iport,
-					   struct fnic_tport_s *tport, unsigned long flags)
+fnic_fdls_remove_tport(struct fnic *fnic, struct fnic_tport_s *tport,
+		       unsigned long flags)
 {
-	struct fnic *fnic =3D iport->fnic;
 	struct rport_dd_data_s *rdd_data;
-
 	struct fc_rport *rport;
=20
 	if (!tport)
@@ -1038,7 +1035,7 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
 		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
 		fnic_del_tport_timer_sync(fnic, tport);
 		if (IS_FNIC_FCP_INITIATOR(fnic))
-			fnic_fdls_remove_tport(&fnic->iport, tport, flags);
+			fnic_fdls_remove_tport(fnic, tport, flags);
 		else if (IS_FNIC_NVME_INITIATOR(fnic))
 			nvfnic_delete_tport(&fnic->iport, tport, flags);
 	}
@@ -1067,7 +1064,7 @@ void fnic_tport_event_handler(struct work_struct *w=
ork)
 						 "Add rport event");
 			if (tport->state =3D=3D FDLS_TGT_STATE_READY) {
 				if (IS_FNIC_FCP_INITIATOR(fnic))
-					fnic_fdls_add_tport(&fnic->iport, tport, flags);
+					fnic_fdls_add_tport(fnic, tport, flags);
 				else if (IS_FNIC_NVME_INITIATOR(fnic))
 					nvfnic_add_tport(fnic, tport, flags);
 			} else {
@@ -1081,7 +1078,7 @@ void fnic_tport_event_handler(struct work_struct *w=
ork)
 						 "Remove rport event");
 			if (tport->state =3D=3D FDLS_TGT_STATE_OFFLINING) {
 				if (IS_FNIC_FCP_INITIATOR(fnic))
-					fnic_fdls_remove_tport(&fnic->iport, tport, flags);
+					fnic_fdls_remove_tport(fnic, tport, flags);
 				else if (IS_FNIC_NVME_INITIATOR(fnic))
 					nvfnic_delete_tport(&fnic->iport, tport, flags);
 			} else {
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.=
h
index ce4b3aae77e3..75f83c78aea1 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -433,10 +433,9 @@ int fnic_send_fip_frame(struct fnic_iport_s *iport,
 	void *frame, int frame_size);
 void fnic_fdls_learn_fcoe_macs(struct fnic_iport_s *iport, void *rx_fram=
e,
 	uint8_t *fcid);
-void fnic_fdls_add_tport(struct fnic_iport_s *iport,
-		struct fnic_tport_s *tport, unsigned long flags);
-void fnic_fdls_remove_tport(struct fnic_iport_s *iport,
-			    struct fnic_tport_s *tport,
+void fnic_fdls_add_tport(struct fnic *fnic, struct fnic_tport_s *tport,
+			 unsigned long flags);
+void fnic_fdls_remove_tport(struct fnic *fnic, struct fnic_tport_s *tpor=
t,
 			    unsigned long flags);
 void fnic_fcpio_reset(struct fnic *fnic);
=20

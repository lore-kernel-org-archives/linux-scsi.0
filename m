Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F00336895
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350298; cv=none; b=Z91+dzxWMDIWT+YbDeca2b5MUJFAiilQ68f6jyJqq7Yp8qqw/IgpNOmv3TRvJPSY6fMAVmH9WD4ptntN5z3iErLAufjUmZSBTB85a9mKLeXbfbdlETFC5WL3Ee1dPmU1T4BQw34vz4RdjBp7h9+lqOKcArGtx/aCmZPny1cIlxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350298; c=relaxed/simple;
	bh=7rDk3q0omYRSNl83EbvzRcIBYQ0ux/f26QsPmEhXZI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tW+rUgX/2BHHLyTSKsoMSPNehWwqzXVmPSQwnPPoAvd7+F1niO2iNvUp+M7bMpHGnjP/75NzhIQ5UljCyWxLqFtyP+LFrGGS0+plTIhh0sSrMqKGkq/Fv1w9xmTN9asIhWjXjIQAp8p3jfmLzpPx+8qUrH1ueAnXTygqZjm+nE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U/rX1P8C; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U/rX1P8C"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pJ4rLZzlfl5V;
	Thu, 12 Mar 2026 21:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350292; x=1775942293; bh=OiALk
	qh2Tqw9S3saB751OKrRxUOuMTtzb/d2kjHzOrw=; b=U/rX1P8CAwUs/sMuSulyt
	0EQkM0nYBCZzBO0HsX9qkRbscFnDZ/K4dSoWi+7a/3fmkN7oYInDdsOXlhb/ifmv
	o1p8agaqHsNagfa3kXAzGI4jD65SN/XrOickDs4rSvpAFhe2T2SHgDttHUqc1Cu9
	zwNsVzkXJTx9EaXWRlFIhhYPdy6j2v/SLa3+yv8xE0DWss1sv5iAPnnWd3QaS/O3
	QZUk8SFH/yClB/DlOb8FX3G1g6ear1qTxCOUv6YoKS/smffjJM24WOQKQx3idDpm
	aEq3eS8cml7WYhSRmH1Xvv3jdDdpJes8US+yKnHi3yyZixbiMSqpRsZ9HJm3opwc
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tAiEskJtFiw5; Thu, 12 Mar 2026 21:18:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0pC0H4Xzlfl8L;
	Thu, 12 Mar 2026 21:18:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 30/36] scsi: qla2xxx: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:41 -0700
Message-ID: <20260312211636.3245119-31-bvanassche@acm.org>
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

Make several code blocks with conditional locking compatible with
thread-safety analysis. Annotate functions that perform conditional
locking with __no_context_analysis. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx.c     |  2 ++
 drivers/scsi/qla2xxx/qla_target.c | 29 ++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_tmpl.c   |  1 +
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.=
c
index 298c060c1292..85d228679e1e 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -431,6 +431,7 @@ static int qla82xx_crb_win_lock(struct qla_hw_data *h=
a)
=20
 int
 qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
+	__no_context_analysis /* conditional locking */
 {
 	void __iomem *off;
 	unsigned long flags =3D 0;
@@ -461,6 +462,7 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u=
32 data)
=20
 int
 qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
+	__no_context_analysis /* conditional locking */
 {
 	void __iomem *off;
 	unsigned long flags =3D 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
index e47da45e93a0..7681eb4530fe 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -383,11 +383,13 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_q=
la_host *vha,
 			    vha->vp_idx, entry->vp_index);
 			break;
 		}
-		if (!ha_locked)
+		if (!ha_locked) {
 			spin_lock_irqsave(&host->hw->hardware_lock, flags);
-		qlt_24xx_handle_abts(host, (struct abts_recv_from_24xx *)atio);
-		if (!ha_locked)
+			qlt_24xx_handle_abts(host, (struct abts_recv_from_24xx *)atio);
 			spin_unlock_irqrestore(&host->hw->hardware_lock, flags);
+		} else {
+			qlt_24xx_handle_abts(host, (struct abts_recv_from_24xx *)atio);
+		}
 		break;
 	}
=20
@@ -3774,6 +3776,7 @@ static int __qlt_send_term_exchange(struct qla_qpai=
r *qpair,
  */
 void qlt_send_term_exchange(struct qla_qpair *qpair,
 	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked)
+	__no_context_analysis /* conditional locking */
 {
 	struct scsi_qla_host *vha;
 	unsigned long flags =3D 0;
@@ -6727,11 +6730,13 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *v=
ha, struct qla_qpair *qpair,
 	if (ha->tgt.num_pend_cmds < Q_FULL_THRESH_HOLD(ha))
 		return 0;
=20
-	if (!ha_locked)
+	if (!ha_locked) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
-	qlt_send_busy(qpair, atio, qla_sam_status);
-	if (!ha_locked)
+		qlt_send_busy(qpair, atio, qla_sam_status);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	} else {
+		qlt_send_busy(qpair, atio, qla_sam_status);
+	}
=20
 	return 1;
 }
@@ -6740,6 +6745,7 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha=
, struct qla_qpair *qpair,
 /* called via callback from qla2xxx */
 static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint8_t ha_locked)
+	__no_context_analysis /* conditional locking */
 {
 	struct qla_hw_data *ha =3D vha->hw;
 	struct qla_tgt *tgt =3D vha->vha_tgt.qla_tgt;
@@ -6766,12 +6772,13 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_hos=
t *vha,
 			    "qla_target(%d): ATIO_TYPE7 "
 			    "received with UNKNOWN exchange address, "
 			    "sending QUEUE_FULL\n", vha->vp_idx);
-			if (!ha_locked)
+			if (!ha_locked) {
 				spin_lock_irqsave(&ha->hardware_lock, flags);
-			qlt_send_busy(ha->base_qpair, atio, qla_sam_status);
-			if (!ha_locked)
-				spin_unlock_irqrestore(&ha->hardware_lock,
-				    flags);
+				qlt_send_busy(ha->base_qpair, atio, qla_sam_status);
+				spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			} else {
+				qlt_send_busy(ha->base_qpair, atio, qla_sam_status);
+			}
 			break;
 		}
=20
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_t=
mpl.c
index b0a74b036cf4..aa5fff284285 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1004,6 +1004,7 @@ qla27xx_fwdt_template_valid(void *p)
=20
 void
 qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
+	__no_context_analysis /* conditional locking */
 {
 	ulong flags =3D 0;
=20

Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAC43A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361185; cv=none; b=SudjzvVNZZj3nIc8fviOHaXjnfdhtAV17Dg4ejsZic8FGKzA2BAJAH4syUwH8+3SP8uXCfrGecw1COOXclxyWmOXq5jSzPlhD94wB65EmVPYeHGzJqlJsbNLvnHtUB1MUBmIWjZ7dXC52wktgIzpXM86XWaNaWNDPpVTt4SAg3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361185; c=relaxed/simple;
	bh=FFBgE2LRiNYSltgCRfbTaqDx0DqsJLye/dq7eB/PB8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfZ1J5N+2v6Q3CuT99G/F0CAwemcmy64HzhHsHqQ+a4vIsk/28pWmPKRMqOWCZPOxJucaMXlzczXmXD2Nl5hecrfMGymf3baa2Pj17xDW3k8geQ+ibApiLh9tXEUtVEQ/TvVgwo7Xzs1lEFt7+dZSLoI2g4JPurL2h1VBs3XeEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Sd6tSlIB; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Sd6tSlIB"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpm120sz1XM5kt;
	Fri, 25 Sep 2026 18:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361176; x=1792953177; bh=WY8C/
	wxGFuHJDao+u+1SBbbweL9rpKAv9vJECN9flIE=; b=Sd6tSlIBIRlHA7TcAo9d2
	OiQxgxIoe4YmyBCfWyiFDKXYApPyHgKrjv+CZ41ZaGKjzYwekURWv1PqCcWkCYvE
	r3v054C0SIIVChguhdnExj4ybd0ZB0aPDoMbHEqQfifxBoIfIpp/29KvMOoBRvU7
	3a/wSKVCv1NVEX0P01so67AAROGeO7ApFxY4btSByRxJNwOYo/2BTdbL2kzZGUO7
	5w1QbZeDXDzs/1qXAu8dSfYWy5nDRw7rqWs9YaFy6fZMduqTCae65L4JWQ4qzjbO
	ZGfMvd48Mp1w3leJ8OChYly6V/6A33cwM0CGEcFQG4FyMbNQ36TW64kcH3R/vRfL
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bphx2pa2srNw; Fri, 25 Sep 2026 18:32:56 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpY6mcbz1XM4Sx;
	Fri, 25 Sep 2026 18:32:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 48/54] scsi: qla2xxx: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:26 -0700
Message-ID: <7ce5e2ceb5c479190c9c44b2bf4339c91a8e6c55.1790360262.git.bvanassche@acm.org>
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

Make several code blocks with conditional locking compatible with
thread-safety analysis. Annotate functions that perform conditional
locking with __context_unsafe(). No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/Makefile     |  3 +++
 drivers/scsi/qla2xxx/qla_nx.c     |  2 ++
 drivers/scsi/qla2xxx/qla_target.c | 29 ++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_tmpl.c   |  1 +
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefil=
e
index cbc1303e761e..095657510cc3 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 qla2xxx-y :=3D qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs=
.o \
 		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
 		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o \
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.=
c
index 2366cca51bce..1a9a0f148bb3 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -431,6 +431,7 @@ static int qla82xx_crb_win_lock(struct qla_hw_data *h=
a)
=20
 int
 qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
+	__context_unsafe(/*conditional locking*/)
 {
 	void __iomem *off;
 	unsigned long flags =3D 0;
@@ -461,6 +462,7 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u=
32 data)
=20
 int
 qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
+	__context_unsafe(/*conditional locking*/)
 {
 	void __iomem *off;
 	unsigned long flags =3D 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
index 431a59d499b3..5a7caff61b16 100644
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
@@ -3775,6 +3777,7 @@ static int __qlt_send_term_exchange(struct qla_qpai=
r *qpair,
  */
 void qlt_send_term_exchange(struct qla_qpair *qpair,
 	struct qla_tgt_cmd *cmd, struct atio_from_isp *atio, int ha_locked)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct scsi_qla_host *vha;
 	unsigned long flags =3D 0;
@@ -6728,11 +6731,13 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *v=
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
@@ -6741,6 +6746,7 @@ qlt_chk_qfull_thresh_hold(struct scsi_qla_host *vha=
, struct qla_qpair *qpair,
 /* called via callback from qla2xxx */
 static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint8_t ha_locked)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct qla_hw_data *ha =3D vha->hw;
 	struct qla_tgt *tgt =3D vha->vha_tgt.qla_tgt;
@@ -6767,12 +6773,13 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_hos=
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
index fd3984127497..f96b9eb15126 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1034,6 +1034,7 @@ qla27xx_fwdt_template_valid(void *p)
=20
 void
 qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
+	__context_unsafe(/*conditional locking*/)
 {
 	ulong flags =3D 0;
=20

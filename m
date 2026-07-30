Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60AC3CB56D
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451752; cv=none; b=eU5LpOk/IbrdoRi3YfRWBm4YFqkYETNyhnIrTswgZ7F1ocol7L068CbFP4MvaUv3xjzlhCU9ldpbwrys63EeCcmemSz2R6OFw0J7GQSDPaLY5A+F7oYNlPsDkElfILJFu4iVxA7R51Ifd+sRu3LAQph0Zy3QxEypk3oIqN3CXfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451752; c=relaxed/simple;
	bh=AEIJBm8svrCL0q2507PpFI8ddgD0mfcjmcNombF3svQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TguSnptnGPe162EIqAR0lU/V1e+XTTBKls+CRQCiQDSDyWvFT9AM6ZruGFhZ4uLYcgkFu/HyzljPyf9nyFirF1FLu95uv1Y4Fl4fq5DRvW4V9PLjzT+WKOKkiViuGKZaFNlVTfxCA2p6OXjlghoZKVP7RbDkPTToI7v266Duink=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TF/llvOz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TF/llvOz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BZ3v94z1XM30k;
	Thu, 30 Jul 2026 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451743; x=1788043744; bh=NLPXf
	F8nBhGVBt5DG55aqLCGdi8Uayn4RPlO881dBII=; b=TF/llvOzkqI+OD+CV6Jer
	+cG7ig1B5ToAYQH3MTamKSx7nNWyBjppJQzdvXVlMv5XlgJhvXQNDT1B1BPbHULP
	u0GWaHPbpO1B+W2PYk9nDNw2yUf3F88+oAkuRTvIG4BbDALH0QOs5FmUKh3kOax9
	2vd9T7EehciiYBblt6e13HkRGK4ClLpaWpbe/jEdy/+Zi4fG4rv9JNAUHuLJdW85
	vegkUlYMv/fT9ZPZvYkLVjmJqXod7pxQQujoChBynFLppERZyddKFAtc1P0BvV7s
	gk1DJv9JY+Z8kO5HTsxx5DROP19gM4tp800otLm0ozOp5VExdqoGz+oL31ElD9S0
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mi113tsDcGEP; Thu, 30 Jul 2026 22:49:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4BQ0fjbz1XM6Jm;
	Thu, 30 Jul 2026 22:49:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 48/57] scsi: qla2xxx: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:31 -0700
Message-ID: <5a1ec87c1d5400aca4bd15eace2f641e0e74ec9a.1785451174.git.bvanassche@acm.org>
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

Make several code blocks with conditional locking compatible with
thread-safety analysis. Annotate functions that perform conditional
locking with __no_context_analysis. No functionality has been changed.

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
index 298c060c1292..1950583c5734 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -431,6 +431,7 @@ static int qla82xx_crb_win_lock(struct qla_hw_data *h=
a)
=20
 int
 qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
+	__context_unsafe(conditional locking)
 {
 	void __iomem *off;
 	unsigned long flags =3D 0;
@@ -461,6 +462,7 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u=
32 data)
=20
 int
 qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
+	__context_unsafe(conditional locking)
 {
 	void __iomem *off;
 	unsigned long flags =3D 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
index e47da45e93a0..687ffd4bfdce 100644
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
+	__context_unsafe(conditional locking)
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
+	__context_unsafe(conditional locking)
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
index b0a74b036cf4..f31bd7aeb8dc 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -1004,6 +1004,7 @@ qla27xx_fwdt_template_valid(void *p)
=20
 void
 qla27xx_mpi_fwdump(scsi_qla_host_t *vha, int hardware_locked)
+	__context_unsafe(conditional locking)
 {
 	ulong flags =3D 0;
=20

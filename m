Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3283537FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573505; cv=none; b=W5tUFI8ioQpI/Vxbn/lJ4xz0NQBzTh1Y51DaH6cTWxs14QmlHQCSIOEIUV5leXUMx5dqAu7KrM4230ng/CqvdHS+95mR8phkJOq4wrnrA05+nIDfpgAPNckvxtYxgugUZAu5I/R8V5vxzFJ+1jbu5PqNcXHzEpBJlRWEPJsmp58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573505; c=relaxed/simple;
	bh=AEIJBm8svrCL0q2507PpFI8ddgD0mfcjmcNombF3svQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXuk+J9cVaxBxXvXqOIp4lv5MutI6G0Xu8yeJXe+2dORXSvUwlMDvf4cUO7nMd2h71dxjJ05jarpS0KlHud9NTQsqnvOmXdteLkbjD0RoxJs3tmXtQ5u98FueAhPe2N+jUJAXICRmglSWhtahSdcWJFfnsmIV56CbDft/ZBhiRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oaxBKzGq; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oaxBKzGq"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62dr1MQDzlfdds;
	Thu, 30 Apr 2026 18:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573498; x=1780165499; bh=NLPXf
	F8nBhGVBt5DG55aqLCGdi8Uayn4RPlO881dBII=; b=oaxBKzGqX70gH1F3ty7/6
	Bcj6v6rTcrUHrwW6866hqmT2EjsYwpUUtcMHR9CZFvECIryvodSQoSjo9zyYUZox
	yxxqXXfBfVgup6PBOV81yuI4lPSe/bu7+r/pFlPidZ9/o+yyZcr22RWHaqD4ocIL
	RXOnkx9f8Of5Un9KMU4VyaMiZOMBh1ZvQKhbAXKpi11ZT/SFCIsAVk+r/8ic5hvv
	mvs+VaF1nsnLt6XddyiV7oxa0UuWgv7Dr5s9NTKSPzvhIraRr5UdPNj+LPJ5Xepz
	ulR0ZtWAF7/M9YbS4nVuHZ8/v97bHdqZrZCxryjX+IAKK2omqDLGtlwpEweOhy7L
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xhy_f2fuGsNQ; Thu, 30 Apr 2026 18:24:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dh4mG5zlhpdN;
	Thu, 30 Apr 2026 18:24:56 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 48/56] scsi: qla2xxx: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:18 -0700
Message-ID: <20260430182130.1978347-49-bvanassche@acm.org>
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

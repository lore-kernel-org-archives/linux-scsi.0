Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E84199947;
	Tue, 15 Apr 2025 00:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676902; cv=none; b=Evs0FJ0dNYkahM4Hpsmibh254AH/H90vnI2bzKtsgTY4q67O+cBkbFdoOWFVHu1eaHPDq6auRDVggq5SmbXs79oIBL+754GYUh/e1kinduPF0HDin0kno0eILLAemdYU3S2YS5FDgVLelfAypZOObM+16BeF4AK4GugGqBKMG9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676902; c=relaxed/simple;
	bh=LSGfBItVUsOl4mKKrLJfO5mRhDJ5Ta0Er/mWO0L1HdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/6HjTYQErbNSL+yMia1BgSubqMvbGW6DCSrVOY79T3sAlt4gLOE7O/nMrrXweQUNVVBlthchaHdq2wlpzEGrI1FruKyAWeAvLG6/K4KBZfAIuc8IsRhMJiGr1ePaZN2R+bgp8k5zdZdDVpgOVBZQ7F6lRJrCrVhS3+i0KVTAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Pprjfvtw; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Pprjfvtw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=FvtDWiii0omRy58Xa7RJOR4M+Fmc8WqjWn2efxe+CUY=; b=PprjfvtwMOk/co1w
	FXCFNOhT1A1y4EF/dw/wbITRtN9lq2WElmPH5bJd9g4qPHHb8XXbzn6CVucO0qB19T5NDx+EtaViQ
	vdKE3SJhN0I9nADdyGvVvDeuS8wVMWtfIEXCHk7CJF0J7xUDGqWvOyWavxUq5XumK3bCh/VfYjxoQ
	PmKruQDQ2/HvCt5OrvGhuHi+puSp/yLmR8QBaAXI0mCgRMIqtxEinW3uzhAwxrywDaRQEUjKrSEpm
	tKFqykNc63uCnMEn++WLm4i6oyzKzj6fyZnARXyKoCIt5IYjGXVkXUJsB95HLxYBoXhsxmrQ5sWVi
	pjGtGIpU39JsdejqBg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9l-00BSPG-2V;
	Tue, 15 Apr 2025 00:28:05 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 2/8] scsi: qla2xxx: Remove unused qlt_fc_port_deleted
Date: Tue, 15 Apr 2025 01:27:57 +0100
Message-ID: <20250415002803.135909-3-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

qlt_fc_port_deleted() has been unused since the last use was removed
by 2017's
commit 726b85487067 ("qla2xxx: Add framework for async fabric discovery")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 44 -------------------------------
 drivers/scsi/qla2xxx/qla_target.h |  1 -
 2 files changed, 45 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8a892ac95417..15c6d95cc4f2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1454,50 +1454,6 @@ static struct fc_port *qlt_create_sess(
 	return sess;
 }
 
-/*
- * max_gen - specifies maximum session generation
- * at which this deletion requestion is still valid
- */
-void
-qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
-{
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct fc_port *sess = fcport;
-	unsigned long flags;
-
-	if (!vha->hw->tgt.tgt_ops)
-		return;
-
-	if (!tgt)
-		return;
-
-	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	if (tgt->tgt_stop) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		return;
-	}
-	if (!sess->se_sess) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		return;
-	}
-
-	if (max_gen - sess->generation < 0) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf092,
-		    "Ignoring stale deletion request for se_sess %p / sess %p"
-		    " for port %8phC, req_gen %d, sess_gen %d\n",
-		    sess->se_sess, sess, sess->port_name, max_gen,
-		    sess->generation);
-		return;
-	}
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
-
-	sess->local = 1;
-	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-	qlt_schedule_sess_for_deletion(sess);
-}
-
 static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 {
 	struct qla_hw_data *ha = tgt->ha;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 71cf0236ea7d..453eb2f6a7c9 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -1014,7 +1014,6 @@ extern int qlt_lport_register(void *, u64, u64, u64,
 extern void qlt_lport_deregister(struct scsi_qla_host *);
 extern void qlt_unreg_sess(struct fc_port *);
 extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
-extern void qlt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *, int);
 extern int __init qlt_init(void);
 extern void qlt_exit(void);
 extern void qlt_free_session_done(struct work_struct *);
-- 
2.49.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5391BB6A7;
	Mon, 17 Jun 2024 13:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630597; cv=none; b=oT6LKO1dN7Isqtyihk1bhscz2euzmvlnl0ldoQlFO8IC9SC4hUpSfZYMt+SF/3sm9/9g8VVyjrbQKDVZy9MNaGuhbQHkcN1ljlI/YBREHVJiEa4qoZLr7ee6uGupMJQzLUcj7Hn4sj82YBzfV5HsccjbTnUAC05P/iTWpn4suLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630597; c=relaxed/simple;
	bh=4GfPouMPCcLMz+pMaETCW3mlwIZdqAL21VrWjV0DEm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bagQ12q5R9n6Ub23c2oYPIM+oAF0PQ4d7RLMvhp0mzqHgUtu54TRgCM5bTdmsTs1mKbkarPzCU+jUDEgX1pvvt0YiXRpk6Qcmjm7xGZAaDichQuUzVtGP59FNPY1LDiZHd+dXvzspL21R0E4gCTVB4iVaBSfxHM04okmmj9IONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtKCd6+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtKCd6+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9A4C4AF1D;
	Mon, 17 Jun 2024 13:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718630597;
	bh=4GfPouMPCcLMz+pMaETCW3mlwIZdqAL21VrWjV0DEm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtKCd6+/kO1WDBoF3vDwigVpRmZX9glqU48X6NRVtNyBPJeH7Ih/WK0jPJW5OMPIu
	 2EXgI8ClxPYDe8lytwBUDObeguyZFrNY1fAT79dvwY2h8SctswruB9TpjXHHl29Win
	 4dA4XuDwCsnU2EzWMrL9sRTDQmndoEh52rLibYwdFfCrcUA7jsrr28/bF3sZNKWL+g
	 ngGK5Xunc/uWIfPzQtoPR3GOpDFNUJTDXyEB0/AEZaNHxNNhba8MmJ0xmWKUlhSUi+
	 A61q/ko7JlQSPNLmyaJxJ3WMFQUW1n71lVF8Rz92o7ijiiN93ZY5EulIEIaVPSWm2G
	 o7iHIfCIP0MBA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Saurav Kashyap <skashyap@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 04/35] scsi: qedf: Wait for stag work during unload
Date: Mon, 17 Jun 2024 09:22:02 -0400
Message-ID: <20240617132309.2588101-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240617132309.2588101-1-sashal@kernel.org>
References: <20240617132309.2588101-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.34
Content-Transfer-Encoding: 8bit

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit 78e88472b60936025b83eba57cffa59d3501dc07 ]

If stag work is already scheduled and unload is called, it can lead to
issues as unload cleans up the work element. Wait for stag work to get
completed before cleanup during unload.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240515091101.18754-3-skashyap@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 30 +++++++++++++++++++++++++++---
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 1619cc33034f2..c5d06d16c490f 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -362,6 +362,7 @@ struct qedf_ctx {
 #define QEDF_IN_RECOVERY		5
 #define QEDF_DBG_STOP_IO		6
 #define QEDF_PROBING			8
+#define QEDF_STAG_IN_PROGRESS		9
 	unsigned long flags; /* Miscellaneous state flags */
 	int fipvlan_retries;
 	u8 num_queues;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c27e27cff0790..c97e129194f78 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -318,11 +318,18 @@ static struct fc_seq *qedf_elsct_send(struct fc_lport *lport, u32 did,
 	 */
 	if (resp == fc_lport_flogi_resp) {
 		qedf->flogi_cnt++;
+		qedf->flogi_pending++;
+
+		if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+			QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+			qedf->flogi_pending = 0;
+		}
+
 		if (qedf->flogi_pending >= QEDF_FLOGI_RETRY_CNT) {
 			schedule_delayed_work(&qedf->stag_work, 2);
 			return NULL;
 		}
-		qedf->flogi_pending++;
+
 		return fc_elsct_send(lport, did, fp, op, qedf_flogi_resp,
 		    arg, timeout);
 	}
@@ -911,13 +918,14 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qedf_ctx *qedf;
 	struct qed_link_output if_link;
 
+	qedf = lport_priv(lport);
+
 	if (lport->vport) {
+		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
 
-	qedf = lport_priv(lport);
-
 	qedf->flogi_pending = 0;
 	/* For host reset, essentially do a soft link up/down */
 	atomic_set(&qedf->link_state, QEDF_LINK_DOWN);
@@ -937,6 +945,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	if (!if_link.link_up) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
 			  "Physical link is not up.\n");
+		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		return;
 	}
 	/* Flush and wait to make sure link down is processed */
@@ -949,6 +958,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 		  "Queue link up work.\n");
 	queue_delayed_work(qedf->link_update_wq, &qedf->link_update,
 	    0);
+	clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 }
 
 /* Reset the host by gracefully logging out and then logging back in */
@@ -3720,6 +3730,7 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedf_ctx *qedf;
 	int rc;
+	int cnt = 0;
 
 	if (!pdev) {
 		QEDF_ERR(NULL, "pdev is NULL.\n");
@@ -3737,6 +3748,17 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 		return;
 	}
 
+stag_in_prog:
+	if (test_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Stag in progress, cnt=%d.\n", cnt);
+		cnt++;
+
+		if (cnt < 5) {
+			msleep(500);
+			goto stag_in_prog;
+		}
+	}
+
 	if (mode != QEDF_MODE_RECOVERY)
 		set_bit(QEDF_UNLOADING, &qedf->flags);
 
@@ -4012,6 +4034,8 @@ void qedf_stag_change_work(struct work_struct *work)
 		return;
 	}
 
+	set_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.43.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3029019EEC8;
	Tue, 18 Jun 2024 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714426; cv=none; b=FrR7rMRwKpSjz5E8xgvim0Sr8iBJkYk+PXLGNij5261aBmwQ89Y9yXjelJTpNH3vdOPsmyYKAxeEHNyuOl0+tYFyGOR8qJ7/iCVnuFD9NdLdkJV0OFEixm9MQ9iuJw7twnYNhdVBG05HjBmrUxg+00jNpSrGao0G9PMrz/UxbQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714426; c=relaxed/simple;
	bh=euyVOrsIbNVe9ztIPQRpZo/xRYD1RMWD9/XqSLwatWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYzaaCw4UKt9HpVrXAEimmQocSKwRKCmxtwMOnKB6Rljim6/EItKGe7R/PhV1FifHBaWxpfAtjSdWpLmj/AdgQwTyHE1Xsne5oFwoCmRkhPtLXu7gahu8GkL+LVJ/tUGG9WunLvdZcFiDXXjJEeu5TusuRdSO2GJHJa3exasdH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RB4Tyu7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RB4Tyu7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF40FC4AF1D;
	Tue, 18 Jun 2024 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718714426;
	bh=euyVOrsIbNVe9ztIPQRpZo/xRYD1RMWD9/XqSLwatWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RB4Tyu7O5S+4O94k63MNm1VatNRzSm8mAAaFDE+DlqOTZjvyIS4csDEYUcMxIiwff
	 iR5zdM5N2JG/ft+XgLJzvRxWz/JG49u9XzyJM9ZS/yfnV4QhsFAQESrooVlIlTYSA9
	 cvGk3OXvfGNwBKxgK4pXoU7n5tIRNsznHFYCDEnjja0ydBT/b/kXXRXHY33ujrIAiG
	 rbt4MjSw2p+TMsVVD1rBrqIu6NXFi0gGcsxerpGMKBrtyJmLJ339IEkBcqNoYj7k71
	 pOXiqPv5K+JqzNPe6rP8aExYhB2kAy7baB/aoNQxkqwd7RW6ztZql/d4K9icNeiutO
	 JD1dvgcXqXwBw==
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
Subject: [PATCH AUTOSEL 6.1 04/29] scsi: qedf: Wait for stag work during unload
Date: Tue, 18 Jun 2024 08:39:30 -0400
Message-ID: <20240618124018.3303162-4-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618124018.3303162-1-sashal@kernel.org>
References: <20240618124018.3303162-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.94
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
index c5c0bbdafc4ea..81b84757faae0 100644
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
index 27f4028bff3bf..524807f9f4eb1 100644
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
@@ -3725,6 +3735,7 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedf_ctx *qedf;
 	int rc;
+	int cnt = 0;
 
 	if (!pdev) {
 		QEDF_ERR(NULL, "pdev is NULL.\n");
@@ -3742,6 +3753,17 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
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
 
@@ -4017,6 +4039,8 @@ void qedf_stag_change_work(struct work_struct *work)
 		return;
 	}
 
+	set_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.43.0


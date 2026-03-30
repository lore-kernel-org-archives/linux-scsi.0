Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3A22C11EE
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774895626; cv=none; b=oR3Yw7NAOrMqS5xVXd7h1GHAlcI8X//6inWpvFZ7OgFRbVHDHuWuzMI9bultcWeDVXLZpp8MnRmlZZfUsRo/BtAdPQw+lpDGqCowFEX7crG6aZ7nDrOCUohlvpEhh0dYi/i5GRpbK2Hhf75WyJ3lojFMGv4lGJT4YHiSHTKPBOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774895626; c=relaxed/simple;
	bh=SnedrEbroSGU29ITSx9zj8ese+bC056o24Z4dPy8aLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TNsEx+qzZnj9ywSPyJDhF9yxH9sLirczuafcPoCtd4s0PoGDk/K+CX1ATGqH+Pr0ZNjfQR+fpa7E4lhafmv/4Wfmb4IRt7JYWWhmlPOah+CpMvzUtTSdUFCcZV7NeOo8w/NRq4MTHKhZOOXiO5ohLEQv5Vwdi2QS6vTAx5gauKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZB1kxoW4; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZB1kxoW4"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fl0J84QBmzlgy0r;
	Mon, 30 Mar 2026 18:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1774895613; x=1777487614; bh=RUvL/
	jrsuLwnnL3sqOtbaxs3b4b73212IS9gnFjrVMA=; b=ZB1kxoW48fe6UdC/4MTSY
	7R0eeuO/l/hoIrB4c3XUSNLYefFvXiGc4RLu8WHiaEeHFIAWsLW9SHC74UcYWhdd
	97UbtiJiH1cTPyYtzrAFpm3jLUIayQAsl+JhnUDaUVvd1I4WND0mv2KfUQRBNx8S
	0BvFMt50nyRLel4MIBzAgo3pK0G9AXms+kiWWe6bFRNmmcZ3PBQCI5273o/uP33r
	eOQwcsHJUfApq9wx8Gc5jq+tRlid3gG9XqXAbUCQXGc2fKHrNYV61aOJ0wEs/wQA
	rOx7Jef4Janz8+s9L1Blbr7ZvFZHEKK1Wrfe7T3D5beoU2xvFnuarQcJXwEr8QDP
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PKa5O3CQ8DZC; Mon, 30 Mar 2026 18:33:33 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fl0Hp6S7zzlfpMB;
	Mon, 30 Mar 2026 18:33:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	vamshi gajjela <vamshigajjela@google.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	"ping.gao" <ping.gao@samsung.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Stanley Jhu <chu.stanley@gmail.com>
Subject: [PATCH 1/3] ufs: core: Fix ufshcd_mcq_force_compl_one()
Date: Mon, 30 Mar 2026 11:33:03 -0700
Message-ID: <20260330183311.1941942-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1118.gaef5881109-goog
In-Reply-To: <20260330183311.1941942-1-bvanassche@acm.org>
References: <20260330183311.1941942-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

There are two issues with the code in ufshcd_mcq_compl_all_cqes_lock():
- The completion queue is processed without checking first whether it is
  empty.
- It is attempted to process hwq->max_entries while there can be at most
  hwq->max_entries - 1 entries on a completion queue.

Fix this by replacing the only ufshcd_mcq_compl_all_cqes_lock() call with
a call to ufshcd_mcq_poll_cqe_lock().

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c     | 18 ------------------
 drivers/ufs/core/ufshcd-priv.h |  2 --
 drivers/ufs/core/ufshcd.c      |  2 +-
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 1b3062577945..8ccde4571859 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -322,24 +322,6 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *h=
ba,
 	}
 }
=20
-void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
-				    struct ufs_hw_queue *hwq)
-{
-	unsigned long flags;
-	u32 entries =3D hwq->max_entries;
-
-	spin_lock_irqsave(&hwq->cq_lock, flags);
-	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
-		ufshcd_mcq_inc_cq_head_slot(hwq);
-		entries--;
-	}
-
-	ufshcd_mcq_update_cq_tail_slot(hwq);
-	hwq->cq_head_slot =3D hwq->cq_tail_slot;
-	spin_unlock_irqrestore(&hwq->cq_lock, flags);
-}
-
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 				       struct ufs_hw_queue *hwq)
 {
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 0a72148cb053..96fcd935790b 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -71,8 +71,6 @@ int ufshcd_get_hba_mac(struct ufs_hba *hba);
 int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
 struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 					   struct request *req);
-void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
-				    struct ufs_hw_queue *hwq);
 bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
 int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag);
 int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cb81aa94d5c4..28b8e7291394 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5855,7 +5855,7 @@ static bool ufshcd_mcq_force_compl_one(struct reque=
st *rq, void *priv)
 	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
+	ufshcd_mcq_poll_cqe_lock(hba, hwq);
=20
 	/*
 	 * For those cmds of which the cqes are not present in the cq, complete

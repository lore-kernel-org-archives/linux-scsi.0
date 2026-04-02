Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504A73C3C1E
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 17:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775150077; cv=none; b=Y4y7FxQumT19nPvyryNnLYNTxyt+89V239bnxCHkeAlvkD3dq6aQK7QiAH4CbHFvNmptbe1MdeLtv0tc3pOkUFY1okYrX/0ES5Qdxt+ol2mY6kqR15E1mZPRc3iCPGkHVNVEdhpdt/ofm1YLZe69dhOKGIi+EASyIv/x/g5Tun0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775150077; c=relaxed/simple;
	bh=QWne1j+v+jIhqnxmUvQ+UcmNGqb+WNuTuuxuuiWFfcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx4V+t7qtmBCM4i6hjLZHyIvqsE9HhzDXBOyrkaxpO1WmPmE3MkVUFZvc+cfhZ8S+1UWoyu6+BK/e0FH2FQq7GAHZaCQ7WxDgLpoWgcw0JqB/dRWp3q59xCwQP4xY6x5pRjwD2tsH5vnRIZ2zEQlkN5ivCldvR8x3NqMfs4Khco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M/U8efY7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M/U8efY7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fmpPK6Q7Lz1XM6Jb;
	Thu,  2 Apr 2026 17:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1775150061; x=1777742062; bh=i5Toa
	KazAuQcQ2err7ibxsYWSeVlfkfFhsdu1Pfkt7I=; b=M/U8efY7aneuMUA1ulhxo
	Jvd0a9D9pjV7BXABDwIuiBEKXAJVrY4azK6AbzwtaEjk28/6fldlDxjS8tV8uciL
	fcE1TVWJSf2Wzv9cMqpjs04USD9xjaipctjGB2bgb60vlXaZwPW0jI8RRngb0UcF
	sEzXLjhk002UI0Gi+JpvYT+9GgQ4o1YRy8Img1eqMomsIS7u88zfgC8E//Rvxzl8
	WUvVhnP1jj6iwr5Dvb4P5pAJEv6vI6PZe9MiqtU8mE3sICM+Gck++u37kcwwYo/3
	9/HH+dddJpPd1SxpmvApRDdMEdN6apclBxCdW6d/8aLgvqJT8MacnzL4x35th5vJ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7E_z0VxHeLfg; Thu,  2 Apr 2026 17:14:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fmpP61kB9z1XM6JQ;
	Thu,  2 Apr 2026 17:14:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	vamshi gajjela <vamshigajjela@google.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	"ping.gao" <ping.gao@samsung.com>
Subject: [PATCH v2 1/2] ufs: core: Introduce ufshcd_mcq_poll_n_cqe_lock()
Date: Thu,  2 Apr 2026 10:14:01 -0700
Message-ID: <20260402171404.3008494-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260402171404.3008494-1-bvanassche@acm.org>
References: <20260402171404.3008494-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Introduce a new function for processing completions that accepts an
upper limit for the number of completions to poll. Tell
ufshcd_mcq_poll_cqe_lock() to poll at most hwq->max_entries. This is
sufficient to poll all pending completions since there are never more
than hwq->max_entries - 1 completions on a completion queue. This patch
prepares for reducing the interrupt latency.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 14 +++++++++++---
 include/ufs/ufshcd.h       |  3 +++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 1b3062577945..e6081b97ed74 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -340,15 +340,16 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba =
*hba,
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 }
=20
-unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-				       struct ufs_hw_queue *hwq)
+unsigned long ufshcd_mcq_poll_n_cqe_lock(struct ufs_hba *hba,
+					 struct ufs_hw_queue *hwq,
+					 unsigned int max_compl)
 {
 	unsigned long completed_reqs =3D 0;
 	unsigned long flags;
=20
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	ufshcd_mcq_update_cq_tail_slot(hwq);
-	while (!ufshcd_mcq_is_cq_empty(hwq)) {
+	while (!ufshcd_mcq_is_cq_empty(hwq) && completed_reqs < max_compl) {
 		ufshcd_mcq_process_cqe(hba, hwq);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		completed_reqs++;
@@ -360,6 +361,13 @@ unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hb=
a *hba,
=20
 	return completed_reqs;
 }
+EXPORT_SYMBOL_GPL(ufshcd_mcq_poll_n_cqe_lock);
+
+unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
+				       struct ufs_hw_queue *hwq)
+{
+	return ufshcd_mcq_poll_n_cqe_lock(hba, hwq, hwq->max_entries);
+}
 EXPORT_SYMBOL_GPL(ufshcd_mcq_poll_cqe_lock);
=20
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..aa5f9b31ea86 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1475,6 +1475,9 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32=
 max_active_cmds);
 unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba);
 u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
 void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
+unsigned long ufshcd_mcq_poll_n_cqe_lock(struct ufs_hba *hba,
+					 struct ufs_hw_queue *hwq,
+					 unsigned int max_compl);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
 					 struct ufs_hw_queue *hwq);
 void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);

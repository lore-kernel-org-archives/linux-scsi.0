Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10034C6C
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253410; cv=none; b=CXb6/gYP3cTlaJraXu1HG2CjgxYNFW666FuyTs+EEjsncPZ53U8uxISQomOROlQB+N/ziGKIDDJ+SQjIp0E/g0wGO/qJCHmiY9jofacDgNFkEDVfn6ypaG3c3fNt21Wq+VM1OYyH3NnmugywCrdgqhOQj7b6r+hXQfP5XS/3oME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253410; c=relaxed/simple;
	bh=oQqYAHPkISlYkAMKcL6rmfGwK3qC1HoCBpyvfB2A1H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmLFO2Q5a2mYBrIyFMqbWecGSM7F+9+t0/u8O4Cw46RNLoSq6QJudxsmnBIgVzjs9EIifD+UzqUusq8RkV8hTO64XOeJdozOkaO1+Ghi3rmXMJhjbxcQEBJxsFIMBOL+Y9iDJzZwaD1bP5E1XpcH7gjJv6RhI56Efd7hxsfebHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GQdZrPbr; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GQdZrPbr"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPzy08mlzm174B;
	Wed, 27 Aug 2025 00:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253404; x=1758845405; bh=AQW/7
	2fHboORTYziHqyRx1HCdJBGHMTsweFEz7mZF0U=; b=GQdZrPbrQ8tODrGc4IRJi
	O1fof7Ik0GDsZXNtWjkGcHxbG6RsR5sx4Dl5+AcomHsiINDhb4MQPQNuWppeayYg
	PlT7EHk40k5cO79SfjBw/jGf01HsAH6b9kdVMd5PEUT0RDMRhIP/1C6Q020KVlo7
	8HxX3a+iiIkj4oG0ZnHMHj5TG1Xihj8DzP6TT9bwBB+t68BYif7KNV9WXGyLniAM
	rUkcmtOsD4sKg/ODcqpgXNyZh9+eWshBFkSK4BfA33BwxzkzAmcaY7+1FOuzgPPF
	WORf4kAba9yvBl9VP1LEv6c0HLoX/8J87yBXJq1qIDQbv0CTCEUPWktdbLfkJXKZ
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dAVU6jJ4ElsU; Wed, 27 Aug 2025 00:10:04 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPzp5Dmrzm1742;
	Wed, 27 Aug 2025 00:09:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 11/26] ufs: core: Change the type of one ufshcd_send_command() argument
Date: Tue, 26 Aug 2025 17:06:15 -0700
Message-ID: <20250827000816.2370150-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Change the 'task_tag' argument into an LRB pointer. This patch prepares
for the removal of the hba->lrb[] array.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0ef3409d6230..02fae897a6bc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2346,14 +2346,13 @@ static void ufshcd_update_monitor(struct ufs_hba =
*hba, const struct ufshcd_lrb *
 /**
  * ufshcd_send_command - Send SCSI or device management commands
  * @hba: per adapter instance
- * @task_tag: Task tag of the command
+ * @lrbp: Local reference block of SCSI command
  * @hwq: pointer to hardware queue instance
  */
-static inline
-void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
-			 struct ufs_hw_queue *hwq)
+static inline void ufshcd_send_command(struct ufs_hba *hba,
+				       struct ufshcd_lrb *lrbp,
+				       struct ufs_hw_queue *hwq)
 {
-	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
 	unsigned long flags;
=20
 	if (hba->monitor.enabled) {
@@ -3062,7 +3061,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
-	ufshcd_send_command(hba, tag, hwq);
+	ufshcd_send_command(hba, lrbp, hwq);
=20
 out:
 	if (ufs_trigger_eh(hba)) {
@@ -3307,7 +3306,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
, struct ufshcd_lrb *lrbp,
 	int err;
=20
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
+	ufshcd_send_command(hba, lrbp, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,

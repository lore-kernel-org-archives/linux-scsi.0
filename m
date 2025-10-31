Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F722F3C1F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943333; cv=none; b=sbKBduFq4Ovzn7hwpoVuGQNzFEi7Zy9kwpDKSQB26LKb+yyyXgdeo/3LZZ9JMUfxe3WC9pGcMGM5grbzdWNaGvf6Ie/AT44pIu7Eg8DSKGdHdOy5yxXuiVVqUqFwx7qRO1+DMMrdJ8iczqwvFFiJ6oMx+ALnHjKBDOrU/6XkQS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943333; c=relaxed/simple;
	bh=u1i/5oXoPOHTM7eq+bIwsg00zS/zL4Af9N3HvP9F4Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEb8+TR378XjoqiKKRcNAHkKivcMv72S9d3bRs8zLgmMizZ4pR5qxW4U71TayebFYOclsSQjfYrNZi9RoWd2ZOukRSF4QTytU1UOvNWdfvOojifO7vpaTlI1nxzvSHN+GTylraCOA/DaBerIKsAeJreeyeGKhOwKmEXl3wAzGQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nKb69qQl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nKb69qQl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytFb4G3nzm0pKv;
	Fri, 31 Oct 2025 20:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943329; x=1764535330; bh=kEcfD
	aI+egga7Vp/27z21eVxPnVh9h5oMJGMCdSaO2w=; b=nKb69qQlvNmnM0CJz/EgN
	vWtz7pjY05kwjrjLnOiIUJU5pk4RnNODyXa/QXc8WcbZtF4W7Rftu/A65YQ8ZxKj
	HZBtIDuroad50TinuIWT6qk2UuVL+FdKBnIZ/gdQXaGR4WnU0iQ9EsgSwdHudiGb
	o6cw5JpY86UQAglhLkNAqAOgBgAACagXblblxmUxWv3mzqDGjCoLtEenS5TGfNCQ
	m8gi0VK2SekJcN/K3qcLvlw+wDCxhSTpn9CtkQLKoeE6XAzKU3gN63TT53e5odWw
	lrDIj/wLCmYPekERMmd7eXfevBVsIyzN30AIjBiFfjzfviXCBq6jmyJ1gGAcEClg
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lnjwc-3HeRAh; Fri, 31 Oct 2025 20:42:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytFP6f7Lzm0pKy;
	Fri, 31 Oct 2025 20:42:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v8 12/28] ufs: core: Change the type of one ufshcd_send_command() argument
Date: Fri, 31 Oct 2025 13:39:20 -0700
Message-ID: <20251031204029.2883185-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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
index edf56e9e825b..f478d5b5230d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2350,14 +2350,13 @@ static void ufshcd_update_monitor(struct ufs_hba =
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
@@ -3066,7 +3065,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
-	ufshcd_send_command(hba, tag, hwq);
+	ufshcd_send_command(hba, lrbp, hwq);
=20
 out:
 	if (ufs_trigger_eh(hba)) {
@@ -3312,7 +3311,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
, struct ufshcd_lrb *lrbp,
 	int err;
=20
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
+	ufshcd_send_command(hba, lrbp, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,

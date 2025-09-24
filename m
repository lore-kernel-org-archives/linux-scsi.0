Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77815329F07
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745995; cv=none; b=DWDmBnpgUsSbb5Jo+EZP5ef0+nvGEOB/cN6fIQWDcFjuZqS2fa7a/u1lvjjSv9N9gnhxtGuvzD6QarXiyj5KJwydpZ40M7SxPwb146rgwt9qkPH8gF/LGVkNRKZAfrBcNAr5FC3sIVwQF88lacJTFvMWohLm4WqxEHccJLeRyXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745995; c=relaxed/simple;
	bh=CqhfEI3xjF05jht4ww8b02HRgbkyFJoA7RXlcmBk0+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jV9rpS0UW2m8TOdpsQDOZkbbDf0g5NLbUaOEgaJ6GgS7diqpWqOPGNwTf9nAgdBN0jnwxCvrq/fNYbeoF4MJnUQDGoFt+efxOlkDYUi+/hz+meM6s78kQhI07fUhKlTPeT+5O6NYatMQWrYq/0RAbk6D6s2uE9kJ30m7bu42yjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O60Q2jYf; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O60Q2jYf"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7pH4692zlgqVP;
	Wed, 24 Sep 2025 20:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745989; x=1761337990; bh=fq2gZ
	R2enQMZQ4GNMNaS/0nk0s3kLqyJ7XBPqsraOqk=; b=O60Q2jYfP9HRYiQXfHJl5
	x2yURHprBd9as+SpwtqPVsmqb0tXULiexc4RHfbvG5O68/BPw441aWh/wVS1tvzV
	Cr/Il3kt3ILcoTKcVSvjFVTakbehSPIw1sp7MF4fKk8tCV1Z63D6LvO85dZp7KGq
	Q+8Agt4ogUk5cq90zpUx7LfzakVazDiHRyoe9jkpfMy++d0frJ8QnHpiTHqjL3gr
	xolnqJbd1k0o3ogieW5Ex1IMRWrWY5fhSrjPXcvuozBCtc+2eLong2c3mAUJ+9ty
	nk+07Ku/zJIKfzKtXUC0H7ISIP4pbymIAvOrcxAYTlmYiMeUENJVBG9NucPTkY62
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7JgsJvcafNi6; Wed, 24 Sep 2025 20:33:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7p80kHYzlgqxl;
	Wed, 24 Sep 2025 20:33:03 +0000 (UTC)
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
Subject: [PATCH v5 12/28] ufs: core: Change the type of one ufshcd_send_command() argument
Date: Wed, 24 Sep 2025 13:30:31 -0700
Message-ID: <20250924203142.4073403-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
index de04ee74cad6..abc843fdbbc4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2349,14 +2349,13 @@ static void ufshcd_update_monitor(struct ufs_hba =
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
@@ -3065,7 +3064,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
 	if (hba->mcq_enabled)
 		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
=20
-	ufshcd_send_command(hba, tag, hwq);
+	ufshcd_send_command(hba, lrbp, hwq);
=20
 out:
 	if (ufs_trigger_eh(hba)) {
@@ -3310,7 +3309,7 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba=
, struct ufshcd_lrb *lrbp,
 	int err;
=20
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
+	ufshcd_send_command(hba, lrbp, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
 	ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,

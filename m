Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663712836BF
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 15:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755618029; cv=none; b=thqhvnuGGMbkCKo+jMdRIZ9pYFrlPRs7vviV+nngBX0qwyMVR+pN9V36XwfACC6ciVsRNhQ8irkVxxr7cPRQ4wh+gTBu5aPcXH+ifA3HnnX3ceikWXkbxzpa31bjezqR/jKikNtdud1GcE63GmlA11ZLv46unP+/uEDxCDhzDs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755618029; c=relaxed/simple;
	bh=Skf+73mBcW6YshUN2V+FwAdtVy/fo8mxTfI6NoSEcGk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OXYFxLvEf4rxJ0H55YWkS7+wjZrf68MVQoKmWcY56f4Y/DZHNHPLRGpr6IrAgWuqsYBuFmtYmOEQdfllSIMtVwbahza8PfUrFepqEKRbGkhaSK7YlRX8lSa7k0ic3xhyTb38qDqoaGt0fd0CxhmQTXq/idrXhKzwcVi8EdKrBIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1lGpWLlg; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1lGpWLlg"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5v161mZDzlgqVY;
	Tue, 19 Aug 2025 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1755618023; x=1758210024; bh=gf8XAgjEeU+0OCd7fkpsWz1yop9Fuj8P8ge
	0eApCbvQ=; b=1lGpWLlgKYkBwOmb92OPuJFrzizuoGGk7tYVjPNt37+CWpy7b1P
	OYpXJCu/LUUUG9AVKrD4D+LOjn3AtML18FvwjajQVzOnII53aLdodhGrgn6VKt2X
	iBWuc7I82lA233Mv3XUXyppVkKU2j3PYx5er8CvPwskTxzjZef9OISG5zizYLOvX
	GLWdn+J9n45sKTSuLlwUVCz3BjBUeo1X1wJKK+pFYocQC62CB3Xymyued+qYDTeT
	lqJnZgez1CbSllzzRFTQ6vrEJMUvPLo4akB6mbWdCgc3haZrIP9rXIVak1Iq2ETh
	Hb2yycswn7RmhN34e/1BrPWYgorUQLVdKow==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rtl1FjPMwG15; Tue, 19 Aug 2025 15:40:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5v0p3s31zlgqTw;
	Tue, 19 Aug 2025 15:40:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <cang@codeaurora.org>,
	Bean Huo <beanhuo@micron.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2] ufs: core: Only collect timestamps if the monitoring functionality is enabled
Date: Tue, 19 Aug 2025 08:39:50 -0700
Message-ID: <20250819153958.2255907-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Every ktime_get() call in the hot path has a measurable impact on IOPS.
Hence, only collect timestamps if the monitoring functionality is enabled=
.

See also commit 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance
monitor sysfs nodes"; v5.14).

Cc: Can Guo <cang@codeaurora.org>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: in ufshcd_print_tr(), only report timestamps if t=
he
    monitoring functionality is enabled.

 drivers/ufs/core/ufshcd.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 18a22e578a1d..3bd4e5f92ad7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -607,10 +607,12 @@ void ufshcd_print_tr(struct ufs_hba *hba, int tag, =
bool pr_prdt)
=20
 	lrbp =3D &hba->lrb[tag];
=20
-	dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
-			tag, div_u64(lrbp->issue_time_stamp_local_clock, 1000));
-	dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n",
-			tag, div_u64(lrbp->compl_time_stamp_local_clock, 1000));
+	if (hba->monitor.enabled) {
+		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n", tag,
+			div_u64(lrbp->issue_time_stamp_local_clock, 1000));
+		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n", tag,
+			div_u64(lrbp->compl_time_stamp_local_clock, 1000));
+	}
 	dev_err(hba->dev,
 		"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
 		tag, (u64)lrbp->utrd_dma_addr);
@@ -2357,10 +2359,12 @@ void ufshcd_send_command(struct ufs_hba *hba, uns=
igned int task_tag,
 	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
 	unsigned long flags;
=20
-	lrbp->issue_time_stamp =3D ktime_get();
-	lrbp->issue_time_stamp_local_clock =3D local_clock();
-	lrbp->compl_time_stamp =3D ktime_set(0, 0);
-	lrbp->compl_time_stamp_local_clock =3D 0;
+	if (hba->monitor.enabled) {
+		lrbp->issue_time_stamp =3D ktime_get();
+		lrbp->issue_time_stamp_local_clock =3D local_clock();
+		lrbp->compl_time_stamp =3D ktime_set(0, 0);
+		lrbp->compl_time_stamp_local_clock =3D 0;
+	}
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	if (lrbp->cmd)
 		ufshcd_clk_scaling_start_busy(hba);
@@ -5622,8 +5626,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int=
 task_tag,
 	enum utp_ocs ocs;
=20
 	lrbp =3D &hba->lrb[task_tag];
-	lrbp->compl_time_stamp =3D ktime_get();
-	lrbp->compl_time_stamp_local_clock =3D local_clock();
+	if (hba->monitor.enabled) {
+		lrbp->compl_time_stamp =3D ktime_get();
+		lrbp->compl_time_stamp_local_clock =3D local_clock();
+	}
 	cmd =3D lrbp->cmd;
 	if (cmd) {
 		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

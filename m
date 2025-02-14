Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1191DE2B4
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739573053; cv=none; b=VRgoDCMlolLOMblDp1PVN4aSb2jao6/fErc7ePm9e8bQK4PUb35psvI6ExV+YjRWyomCgk8vjnzQpWNA4fXqRjGzPZNcz/UsifheihsjlLG7llVBb8p7y2Q/Pv3o2iIzoOu8i6RM1ii8SJJFJC3V+q5Oxllwf1kN/tNfEKb5nU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739573053; c=relaxed/simple;
	bh=OhqbbWDgmyYxvmOUD2pO+btmNokiHRwHldvpu91d0fk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G5bnI9ocrDgvW96TbcXhlFmKxeppobIUrz/w4SRnA9GKDsVcKyHihCo6Azc8fqgqHqzhJRR0H5PY3y1Y9xKIjKKsxEAylCfxVf+Qq9LL8Dnnjq+eziLQ8vhgE3GiKQUYNA9U0pjKvvZvWAq4O29MnJFMPigBvmdXS1E/Wvng95U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NFxImv1x; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NFxImv1x"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YvnCv1cyFzlgTwy;
	Fri, 14 Feb 2025 22:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1739573049; x=1742165050; bh=Br4D9BmiSeeeuFqu30mjQYb6OKt6EfykK3i
	/qqpCwu0=; b=NFxImv1xGjX9b2kDkBgss5aK36ThBZReAWeabLcYaqQriAvRk2Z
	9XEfOjRLhhq33J/tT7bu8zkMw+FpGiKLz585c4YMPY9/H1bseHprFjMmCP9OGK4y
	UIdJRxaRhgxbivcr36wbBc8IS3gIYIBDB5y/7QuJisI3ATwEphQpefNjbYWTye/f
	y3CST3iy0KzK519JUHFhi0Pn793HSjoi4akGLQxfx5Y9NTm9cZwW0bHouzNHYcRm
	jrTKWziQb9TSdxx/kBwPP1Zor0YkXhwPMGZCP5uH0+YAn45v/e2eUrOBRDYmd3WX
	Wi3/gd8dsdjNetCoM5QQzhEW1Kx5Brzn6pQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1tZTkufwgyxr; Fri, 14 Feb 2025 22:44:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YvnCp5Hh6zlgTwp;
	Fri, 14 Feb 2025 22:44:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Stanley Jhu <chu.stanley@gmail.com>
Subject: [PATCH] scsi: ufs: Fix ufshcd_is_ufs_dev_busy() and ufshcd_eh_timed_out()
Date: Fri, 14 Feb 2025 14:43:44 -0800
Message-ID: <20250214224352.3025151-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

ufshcd_is_ufs_dev_busy(), ufshcd_print_host_state() and
ufshcd_eh_timed_out() are used in both modes (legacy mode and MCQ mode).
hba->outstanding_reqs only represents the outstanding requests in legacy
mode. Hence, change hba->outstanding_reqs into scsi_host_busy(hba->host)
in these functions.

Fixes: eacb139b77ff ("scsi: ufs: core: mcq: Enable multi-circular queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ef56a5eb52dc..6098b997757e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -266,7 +266,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *=
hba)
=20
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
+	return scsi_host_busy(hba->host) || ufshcd_has_pending_tasks(hba);
 }
=20
 static const struct ufs_dev_quirk ufs_fixups[] =3D {
@@ -628,8 +628,8 @@ static void ufshcd_print_host_state(struct ufs_hba *h=
ba)
 	const struct scsi_device *sdev_ufs =3D hba->ufs_device_wlun;
=20
 	dev_err(hba->dev, "UFS Host state=3D%d\n", hba->ufshcd_state);
-	dev_err(hba->dev, "outstanding reqs=3D0x%lx tasks=3D0x%lx\n",
-		hba->outstanding_reqs, hba->outstanding_tasks);
+	dev_err(hba->dev, "%d outstanding reqs, tasks=3D0x%lx\n",
+		scsi_host_busy(hba->host), hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=3D0x%x, saved_uic_err=3D0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=3D%d, UIC link state=3D%d\n",
@@ -8907,7 +8907,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out=
(struct scsi_cmnd *scmd)
 	dev_info(hba->dev, "%s() finished; outstanding_tasks =3D %#lx.\n",
 		 __func__, hba->outstanding_tasks);
=20
-	return hba->outstanding_reqs ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
 }
=20
 static const struct attribute_group *ufshcd_driver_groups[] =3D {

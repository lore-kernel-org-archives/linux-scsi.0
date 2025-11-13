Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15259325727
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 23:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763078000; cv=none; b=TcECt6pcjr0l0HryZDD6rA4ZnMFB6a2oJ5r6At8zbPBrhotl6LcjuKL8/28d05n1UyQ8YG2hwSmi5QNaQx0DEncos3xTh5OP1HB9Ehu/OnVx0izdx9TZT6Z7rnmfocokjhe7A8QVFp4L1zX+KhMcdffBey+Jme5HcNuDzAMruGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763078000; c=relaxed/simple;
	bh=/DMVNZxqbRvxo+O9KqdNU/bsWULBLAbJiAl6QZ+Khkk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JrhWl9IrhDbWXKSfhiayuXrSJax3uoh86R0JNCvaYsx27LAn6tvPSwg2kOJqygMNbmCOtcCroiZP8j34Dl6d3f+mfQJM1QYd4r3cFock1tG2TnnPZkSNAEkOWBctuB0JhPx93B0tXXkPTJ3N1HAIaiHUDsCIVgM4FjakpPz/T4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LGVoBQ8n; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LGVoBQ8n"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d6xt45zqqzlmm7t;
	Thu, 13 Nov 2025 23:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1763077995; x=1765669996; bh=EthNqMueBu+2PwD50t/2fjFkq54ueYxJPwu
	2SENOCLQ=; b=LGVoBQ8nuNAlU8MMHGC0m7w1RqCKlE5VVwfjNOxkOqdE2oegEb/
	eqoBIQR2H5+p59ucqFnx6l2cKRB3W5m8EX/E+BgW9iMMZvFUpm1Od9M0/wQf8QJD
	9WL7uUOexBEIiu85LJ1z78IEnDMSIhGhCh4jIrSVPqJ0sT+uR0JCd+SI+WkxxPEx
	WDsn8q6jFOsFqZUtQNaE/40b5YpmCJmQPCL1FvoV6MQGYc0xSfVnR5SepodlrWVU
	MVITPpF6+0RvAchAKfSOGS0GIgFwcaTw/ziII3zrRFc1uxOBLr6rYAA1FmnFnvgU
	J1gzrVvQ+HcYHQ58ZP1s9NY/YBKzoGqRYOQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jKVPQkWd6b1p; Thu, 13 Nov 2025 23:53:15 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d6xsr4YhMzlv82K;
	Thu, 13 Nov 2025 23:53:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: core: Use scsi_device_busy()
Date: Thu, 13 Nov 2025 15:52:43 -0800
Message-ID: <20251113235252.2015185-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use scsi_device_busy() instead of open-coding it. This patch prepares
for skipping the SCSI device budget map initialization in certain cases.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 846d7f1138a8..78dd96c82d20 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1290,13 +1290,13 @@ static bool ufshcd_is_devfreq_scaling_required(st=
ruct ufs_hba *hba,
  */
 static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 {
-	const struct scsi_device *sdev;
+	struct scsi_device *sdev;
 	unsigned long flags;
 	u32 pending =3D 0;
=20
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	__shost_for_each_device(sdev, hba->host)
-		pending +=3D sbitmap_weight(&sdev->budget_map);
+		pending +=3D scsi_device_busy(sdev);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
=20
 	return pending;

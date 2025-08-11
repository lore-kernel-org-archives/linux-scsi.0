Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FD321771B
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934028; cv=none; b=nUHg+hBSDQNRPLxFrAqb7qGXH/FI8H4bkszhDsLAL0HdjByb53u7IuXQIC6OhOtFlolXykf2y48/NWjvNrmtP4sarTEfselsmBZvwwdse6IX+k8Cw+TDcKalhfcgGNQwuqDW9CBDavVQS01j+nKoWKYFyh/GK8IqQoxH++Y+Ork=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934028; c=relaxed/simple;
	bh=M7u3Jx7pJmeEsnaoKvGH64PGXa8DC7hDyZIDKmRl1kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCrmgJPF4MJ9wsp4F2x6OoazXOixgXvGhgtUISRU1LxGzXN6CEoc/zHJru1WHnJSD533uV1WcN9UEFJ/nTidOhOcWptKTkljjgzCOD2HHBBLXiOOMgGC36lp5MvRMHdp7bxk9TsUmngXy2NGBicxDS+aoqnIw4IurDyDBPD8EFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3Y9JNtSY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3Y9JNtSY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c123G6MDpzlgqTq;
	Mon, 11 Aug 2025 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934025; x=1757526026; bh=z870q
	YZhgxd+/1Y7HbkBo59Yg8KHX3dQNIDikH3m0ck=; b=3Y9JNtSYM9mqC9O9eWaxX
	AiqsTCuKfKO0mGbvZlqfdt32NLa91CfmPLlZX4lakCJ5xnMZcdOol/W5nLlToUaN
	kXd47uaYNP8b3+88cCUuey83boMtSq4QIiUaLB5/EPBu9XO/mIufC2NGE7JdobdS
	IJQ02IOQiVHvgTMMVcSk8cLhveStMQE+I+xA9n2YDsukLBk5wBl36SJhLQMZo0kA
	vopLnPi5TmPBdtedxrRUhwROWtJvs2oiE3W3HgGCuYS3HCKID2QmvlrbbmVpHmO9
	/AsJNg5iMEc9OqMoTT8MMZy/PJwuInutjLdJS3xdeMJLRrdRguZagtdrsCtT3yKh
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3KtYZ-9piK36; Mon, 11 Aug 2025 17:40:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c12390MlLzlgqV3;
	Mon, 11 Aug 2025 17:40:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 20/30] ufs: core: Allocate the SCSI host earlier
Date: Mon, 11 Aug 2025 10:34:32 -0700
Message-ID: <20250811173634.514041-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Call ufshcd_add_scsi_host() before any UPIU commands are sent to the UFS
device. This patch prepares for letting ufshcd_add_scsi_host() allocate
memory for both SCSI and UPIU commands.

Initially, allocate 32 commands (SCSI + reserved). In ufshcd_alloc_mcq(),
increase the SCSI host queue depth if necessary.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 23f7734d3cc1..82d804dd0c85 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9089,6 +9089,31 @@ static void ufshcd_async_scan(void *data, async_co=
okie_t cookie)
 	ktime_t probe_start;
 	int ret;
=20
+	if (is_mcq_supported(hba)) {
+		ufshcd_mcq_enable(hba);
+		ret =3D ufshcd_alloc_mcq(hba, hba->dev_info.bqueuedepth);
+		if (ret =3D=3D 0) {
+			ufshcd_config_mcq(hba);
+			ret =3D scsi_host_update_can_queue(
+				hba->host, hba->nutrs - UFSHCD_NUM_RESERVED);
+			if (ret)
+				goto out;
+		} else {
+			/* Continue with SDB mode */
+			ufshcd_mcq_disable(hba);
+			use_mcq_mode =3D false;
+			dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
+				ret);
+		}
+	}
+	if (!is_mcq_supported(hba) && !hba->lsdb_sup) {
+		dev_err(hba->dev,
+			"%s: failed to initialize (legacy doorbell mode not supported)\n",
+			__func__);
+		ret =3D -EINVAL;
+		goto out;
+	}
+
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
 	probe_start =3D ktime_get();
@@ -10574,9 +10599,12 @@ static int ufshcd_add_scsi_host(struct ufs_hba *=
hba)
 {
 	int err;
=20
+	WARN_ON_ONCE(!hba->host->can_queue);
+	WARN_ON_ONCE(!hba->host->cmd_per_lun);
+
 	if (is_mcq_supported(hba)) {
 		ufshcd_mcq_enable(hba);
-		err =3D ufshcd_alloc_mcq(hba, hba->dev_info.bqueuedepth);
+		err =3D ufshcd_alloc_mcq(hba, 32);
 		if (!err) {
 			ufshcd_config_mcq(hba);
 		} else {
@@ -10815,6 +10843,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 			    FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
 	}
=20
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
+
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
=20
@@ -10865,10 +10897,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
-	err =3D ufshcd_add_scsi_host(hba);
-	if (err)
-		goto out_disable;
-
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
=20

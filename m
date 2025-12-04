Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0522ED844
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764867916; cv=none; b=kRYSNhIlmRTdBtPk2R7DqCEyQxNOYkdMnskGLDyVHsDJPk6vpAKUkV3vXsZchFID6zESN0WfMVBEjoDVeoQ18gagvCF0EJfdZhhKPZjkWS+Sskt77zRzpjRdAGQDB5NSHb4vbsHL0xhVd3WlpQFJw6b6EP0avVyM8CQO49vCxCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764867916; c=relaxed/simple;
	bh=uyEuJFG/WJ+qHUos/dGYyI24pAul5qU1PF0RjN7DJ8g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kas6cODHSDK7jJDNg68FQlTJCZYz6TQe6kpnLHSGPcqFkjSo2rFGIrkKFQIM1mktQPQHS1c8NpSy3LFxoHjeRBsx6Ot7Sw9ni/BesEQpXUNiaoBOeWrh8+XgpktYmbN4Uamo6FDvs66pG9Xfh5ROcobD2mJ3Wz212vYHPZHJW/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XAjdRJyY; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XAjdRJyY"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dMgqY1Xg1zlxHwF;
	Thu,  4 Dec 2025 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1764867910; x=1767459911; bh=t+W4beQrgY6lJgYL2XBv5SmqVdABGHqNDg5
	tdTDaG/k=; b=XAjdRJyYos09o25/FUUasUe4b1LT8YqIruGOf4RUGlH27YqxrJC
	37df+odXb5QFiQzYm4Y7Z5kuhTtpT9K5mM6JpwRqpSby3lQiVHoGWNqXKUjAxhlD
	aDNg6JC46g//N58qDyMHQxQod5+pxU2jSQ2OzaBdgwBMFleQhbcoYATPKeoQEUpH
	uM0oDQ92WpfnnVD5fmoHT73rHcfWxjrXv8tAbHOeiBGd8mCXxGVTlcFFgnwoZOIO
	th9RaVJix+XRYonf8CRjm1htdVmJmbZ37t9nLdBe+9MBZK2XVgGxt2KE+wbrZskV
	Eacb8PCcs+pVS+EV2TxGLRNFmCxbQbCmByg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hvV9TgwTHpc1; Thu,  4 Dec 2025 17:05:10 +0000 (UTC)
Received: from bvanassche-glaptop2.roam.corp.google.com (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dMgqP4Ck8zlxCHd;
	Thu,  4 Dec 2025 17:05:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] ufs: core: Fix an error handler crash
Date: Thu,  4 Dec 2025 07:04:52 -1000
Message-ID: <20251204170457.994851-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.177.g9f829587af-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The UFS error handler may be activated before SCSI scanning has started a=
nd
hence before hba->ufs_device_wlun has been set. Check the
hba->ufs_device_wlun pointer before using it.

Cc: Peter Wang <peter.wang@mediatek.com>
Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock=
")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b834b9635062..80c0b49f30b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6698,19 +6698,22 @@ static void ufshcd_err_handler(struct work_struct=
 *work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
=20
-	/*
-	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
-	 * even if an error occurs during runtime suspend or runtime resume.
-	 * This avoids potential deadlocks that could happen if we tried to
-	 * resume the device while a PM operation is already in progress.
-	 */
-	ufshcd_rpm_get_noresume(hba);
-	if (hba->pm_op_in_progress) {
-		ufshcd_link_recovery(hba);
+	if (hba->ufs_device_wlun) {
+		/*
+		 * Use ufshcd_rpm_get_noresume() here to safely perform link
+		 * recovery even if an error occurs during runtime suspend or
+		 * runtime resume. This avoids potential deadlocks that could
+		 * happen if we tried to resume the device while a PM operation
+		 * is already in progress.
+		 */
+		ufshcd_rpm_get_noresume(hba);
+		if (hba->pm_op_in_progress) {
+			ufshcd_link_recovery(hba);
+			ufshcd_rpm_put(hba);
+			return;
+		}
 		ufshcd_rpm_put(hba);
-		return;
 	}
-	ufshcd_rpm_put(hba);
=20
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);

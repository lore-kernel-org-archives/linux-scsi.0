Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAE41591FC
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 22:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107932; cv=none; b=YtmVzCAE3P+JkbBhXE3MmQPVDbHyx4HtEBbLdBBUG+rFhSG8qw56UcxZay/o+eiQoHNEtwy5Kc28lUKQgS6WSGfLOYmzCAc4T1QFHxFKNy4tr8c+3/DKdVCZOIBz0FPO73hXHuOkurPuCNLOuCv+b1bU6w6DftbpmQtPxkRfXyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107932; c=relaxed/simple;
	bh=D/FdpSZrelHR55uGq7R5PLUuhBnzXtfJJM36ppXfMg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMcrPNf5cW2do8d7Ph0Ekax7BJ2OqoG8m5lp/LducaGcvhQkMlOfwms9E8pzXZfr8+ta3VjKwqJuUgHPihqQOFXdgMyYseGD1NmYH7cvaLOXd6I13v+dI+YKnMYkNAb0BfVSNxBWbPSgR1PzU74y6Csa+Vo6WyP+UKsIk7RaHe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VzMsfZUd; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VzMsfZUd"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wnnsl1n7Yz6ClY8q;
	Mon, 19 Aug 2024 22:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724107925; x=1726699926; bh=ixNiK
	m53XQvNLlvdc5xB/k4tIyUx7HCkhLVGC/2HXfc=; b=VzMsfZUdzQTf9tDQU/XxW
	nIsj5A/wZbyhBiHiQHvK69wYNuvavQ7WCOZGDwLk2e7JLi+XlGIC7ePFLfBn+9GA
	INvf8t7BDhn/4Ie9izrDLUlsHOiBn51xxa9bny4jUvpETUqPNLs25fJNpHHJrc5N
	xlv+hlVx/BcyGMtbn1TqqtW4RiSD+M2VLhpvYf2yRAarpU2/eU3gFl996ixa4ReK
	M0iEO7/vJds9wgXxrLpxdvfp5LorD/8Y2QHnxweCyHxxTtTUagB2j074nma4pKFL
	3e7+0gaNHG0CNXyoSdUyjwI3szSUxiVz4Xj0aHMPDU5yjdoOH8JrAL0ZxeqR8GWl
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H9AI-dWmfAKr; Mon, 19 Aug 2024 22:52:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnnsc2mDSz6Cnk9X;
	Mon, 19 Aug 2024 22:52:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 9/9] ufs: core: Remove the second argument of ufshcd_device_init()
Date: Mon, 19 Aug 2024 15:50:26 -0700
Message-ID: <20240819225102.2437307-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.184.g6999bdac58-goog
In-Reply-To: <20240819225102.2437307-1-bvanassche@acm.org>
References: <20240819225102.2437307-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Both ufshcd_device_init() callers pass 'false' as second argument. Hence,
remove that second argument.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 44 +++++----------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b3fae37e4f6a..9af293b39672 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -298,7 +298,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *h=
ba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
-static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)=
;
+static int ufshcd_device_init(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -7719,7 +7719,7 @@ static int ufshcd_host_reset_and_restore(struct ufs=
_hba *hba)
=20
 	/* Establish the link again and restore the device */
 	if (!err) {
-		err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		err =3D ufshcd_device_init(hba);
 		if (!err)
 			err =3D ufshcd_probe_hba(hba);
 	}
@@ -8793,9 +8793,8 @@ static int ufshcd_post_device_init(struct ufs_hba *=
hba)
 	return 0;
 }
=20
-static int ufshcd_device_init(struct ufs_hba *hba, bool init_dev_params)
+static int ufshcd_device_init(struct ufs_hba *hba)
 {
-	struct Scsi_Host *host =3D hba->host;
 	int ret;
=20
 	ret =3D ufshcd_activate_link(hba);
@@ -8803,7 +8802,7 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 		return ret;
=20
 	/* Reconfigure MCQ upon reset */
-	if (hba->mcq_enabled && !init_dev_params) {
+	if (hba->mcq_enabled) {
 		ufshcd_config_mcq(hba);
 		ufshcd_mcq_enable(hba);
 	}
@@ -8818,39 +8817,6 @@ static int ufshcd_device_init(struct ufs_hba *hba,=
 bool init_dev_params)
 	if (ret)
 		return ret;
=20
-	/*
-	 * Initialize UFS device parameters used by driver, these
-	 * parameters are associated with UFS descriptors.
-	 */
-	if (init_dev_params) {
-		ret =3D ufshcd_device_params_init(hba);
-		if (ret)
-			return ret;
-		if (is_mcq_supported(hba) && !hba->scsi_host_added) {
-			ufshcd_mcq_enable(hba);
-			ret =3D ufshcd_alloc_mcq(hba);
-			if (!ret) {
-				ufshcd_config_mcq(hba);
-			} else {
-				/* Continue with SDB mode */
-				ufshcd_mcq_disable(hba);
-				use_mcq_mode =3D false;
-				dev_err(hba->dev, "MCQ mode is disabled, err=3D%d\n",
-					 ret);
-			}
-			ret =3D scsi_add_host(host, hba->dev);
-			if (ret) {
-				dev_err(hba->dev, "scsi_add_host failed\n");
-				return ret;
-			}
-			hba->scsi_host_added =3D true;
-		} else if (is_mcq_supported(hba)) {
-			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
-			ufshcd_config_mcq(hba);
-			ufshcd_mcq_enable(hba);
-		}
-	}
-
 	return ufshcd_post_device_init(hba);
 }
=20
@@ -8884,7 +8850,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		}
=20
 		/* Reinit the device */
-		ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/false);
+		ret =3D ufshcd_device_init(hba);
 		if (ret)
 			goto out;
 	}

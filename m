Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC8D16DEBD;
	Thu, 31 Oct 2024 21:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730410019; cv=none; b=DhH062EEitwUazK+DaWa+shuJj3N2/f3E9BoHy6u0m4okwAhicyQhag6Fm9l0bZUFq6lzU3UTlMZtN0TzjDlDOWcUu7XrAkDuwoSJcBF0tHznXH86iR7dLtUemRFoPFkW3Fe5ky7T847q369vpqBxSzgtbPJUkUpVlH31bi8RmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730410019; c=relaxed/simple;
	bh=30hcqGzrrk77o5w95MDwGEVoR3WI5uOAHeO3GmHCGfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q8yl96GFBPatGcCtpKsfTzq4H9AW1RbIWkLF5kMQtnZ/Ttjv+zbG0zCTVx2vyWdRoE1451DcPz7TBQ1pftJonjsRg4xvCF4kTHFCJXNTKB5FIpJU3wobqyoBp2es4/mjXZGiLmnVgWKuwmimdzgVtcLvCfuMPv4c+J76Yq+gHOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ulB+gx/f; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ulB+gx/f"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XfcWW19zlz6CkhTC;
	Thu, 31 Oct 2024 21:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1730409999; x=1733002000; bh=kAg/7qpp3e0UzpDFIcI1WamXbWiQtAJ+3QM
	JmcPaWKU=; b=ulB+gx/fAlGT1H6G+UgPSQ5LOePl0RceICcX4xHnrb/L50weijU
	pHRb9WTTz0kT82YSsvFLwIqQHWt3QN+qRdf+xFw32kYQcdI9VY5DECv61tXtw0f5
	C/12kdvDaqilY2THdvuOE5v6qflwGYf2ifPvxzwDWb/GnzP6aF0EEANU2/3cBr//
	FZ3CRE5QSCwrrHnAJtzzdMEpQQuJNCtx3NDInRRO+c6OQH62kc+pDml9OlPCzJqd
	2A8hfJTTNOy3D2iqgR33U9K00m1lGJ368Zbqqm3kUy6p6llWtXpq1NrJKt5KT5hN
	q5x4p8VyBBAEscSBnrduQac/E29/22wvMFA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ObravQO2OgSh; Thu, 31 Oct 2024 21:26:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XfcWJ2HBWz6Ckj6M;
	Thu, 31 Oct 2024 21:26:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Mike Bi <mikebi@micron.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Luca Porzio <lporzio@micron.com>
Subject: [PATCH] scsi: ufs: Start the RTC update work later
Date: Thu, 31 Oct 2024 14:26:24 -0700
Message-ID: <20241031212632.2799127-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The RTC update work involves runtime resuming the UFS controller. Hence,
only start the RTC update work after runtime power management in the UFS
driver has been fully initialized. This patch fixes the following kernel
crash:

Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Workqueue: events ufshcd_rtc_work
Call trace:
 _raw_spin_lock_irqsave+0x34/0x8c (P)
 pm_runtime_get_if_active+0x24/0x9c (L)
 pm_runtime_get_if_active+0x24/0x9c
 ufshcd_rtc_work+0x138/0x1b4
 process_one_work+0x148/0x288
 worker_thread+0x2cc/0x3d4
 kthread+0x110/0x114
 ret_from_fork+0x10/0x20

Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae3=
77f6f5@linaro.org/
Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Cc: Bean Huo <beanhuo@micron.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 585557eaa9a2..ed82ff329314 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8633,6 +8633,14 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 		ufshcd_init_clk_scaling_sysfs(hba);
 	}
=20
+	/*
+	 * The RTC update code accesses the hba->ufs_device_wlun->sdev_gendev
+	 * pointer and hence must only be started after the WLUN pointer has
+	 * been initialized by ufshcd_scsi_add_wlus().
+	 */
+	schedule_delayed_work(&hba->ufs_rtc_update_work,
+			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
+
 	ufs_bsg_probe(hba);
 	scsi_scan_host(hba->host);
=20
@@ -8727,8 +8735,6 @@ static int ufshcd_post_device_init(struct ufs_hba *=
hba)
 	ufshcd_force_reset_auto_bkops(hba);
=20
 	ufshcd_set_timestamp_attr(hba);
-	schedule_delayed_work(&hba->ufs_rtc_update_work,
-			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
=20
 	if (!hba->max_pwr_info.is_valid)
 		return 0;

Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EEC12E4A
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109608; cv=none; b=V5CjmicGAjLGrWjkkR5sPpqapwKnherrJZJENlUeE6mY9iJbpG7BrmeYDYrTXf/uRZOZtInqRKvsi0/6RRZssta7bEN6sySP9xPCHY6mXlEIC/LUO9zlD+5s93N+lAfEXhwS7htUt3hJKH5f8mV6Ws5CrrrC19V8Wn4jHIdWGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109608; c=relaxed/simple;
	bh=Yu3RdaVQZFLF2pRAqaPh8Rgx84nbMv7fas4TICo94rE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tp6XvRkT5bB16ZW1QqEP19HdWuITZc+XSqG9AX44xgr+WT2OzWCj8W9Ws7feRP1nxONUP86pvPQAXBssmgFgxqCHCaY5Qh0TC7GkRHB/hbvOxz7cdSeKWYUfmvESR1qhSXBeX3CVaEV0ClEOo/AirI3nbZQwITxkozsiXV0yj98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JD9qo6R9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JD9qo6R9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMbp4sMLz6ClY9l;
	Wed, 16 Oct 2024 20:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109600; x=1731701601; bh=5BNhY
	V9M5GPzg2W8iLsE4XjZLDUUotPqrr4TPlEIU80=; b=JD9qo6R9f2VE4pXqLEhbg
	jii8sSVwYBz0nVKWLh2iixRVZ7rGnXnYKxwmw8vVoKBubxN1ORXQ9T8ggNY2mGgd
	fLz0qy2F9shtamC5rZvYHciuSBCneWPZ4M0IAqTCo63VnqVmBllzXiprIOlg0cmE
	o/R4zs1ZUDlG8WOAd2p6jsLf2ZQEzbAlFNMBooGj1u8GySRODaNce+MqWy7JByrJ
	7+Z8MQkR0LBbhnVKjTYWEkgv3KA1OgdmiXl5mM3oKhPYYvi2zm553thJZy+9nnbT
	kn/tCshK/85IlzNYvPSg07c0o8iUyG5tt61Fbn+IanOnLnH0t1W/0zx4H4lJKtTC
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id v7PUdmpNNAmC; Wed, 16 Oct 2024 20:13:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbg3fdJz6ClY9d;
	Wed, 16 Oct 2024 20:13:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 04/11] scsi: ufs: core: Introduce ufshcd_process_probe_result()
Date: Wed, 16 Oct 2024 13:12:00 -0700
Message-ID: <20241016201249.2256266-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for moving a ufshcd_device_init() call from inside
ufshcd_probe_hba() into the ufshcd_probe_hba() callers by introducing
the function ufshcd_process_probe_result(). No functionality has been
changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 17604397aaba..724060a9eae7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7684,6 +7684,29 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	return err;
 }
=20
+/**
+ * ufshcd_process_probe_result - Process the ufshcd_probe_hba() result.
+ * @hba: UFS host controller instance.
+ * @probe_start: time when the ufshcd_probe_hba() call started.
+ * @ret: ufshcd_probe_hba() return value.
+ */
+static void ufshcd_process_probe_result(struct ufs_hba *hba,
+					ktime_t probe_start, int ret)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ret)
+		hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
+	else if (hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET)
+		hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	trace_ufshcd_init(dev_name(hba->dev), ret,
+			  ktime_to_us(ktime_sub(ktime_get(), probe_start)),
+			  hba->curr_dev_pwr_mode, hba->uic_link_state);
+}
+
 /**
  * ufshcd_host_reset_and_restore - reset and restore host controller
  * @hba: per-adapter instance
@@ -8850,7 +8873,6 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
 	ktime_t start =3D ktime_get();
-	unsigned long flags;
 	int ret;
=20
 	ret =3D ufshcd_device_init(hba, init_dev_params);
@@ -8896,16 +8918,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, b=
ool init_dev_params)
 	ufshcd_configure_auto_hibern8(hba);
=20
 out:
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (ret)
-		hba->ufshcd_state =3D UFSHCD_STATE_ERROR;
-	else if (hba->ufshcd_state =3D=3D UFSHCD_STATE_RESET)
-		hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	trace_ufshcd_init(dev_name(hba->dev), ret,
-		ktime_to_us(ktime_sub(ktime_get(), start)),
-		hba->curr_dev_pwr_mode, hba->uic_link_state);
+	ufshcd_process_probe_result(hba, start, ret);
 	return ret;
 }
=20

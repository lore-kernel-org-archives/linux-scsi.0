Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4399D16C854
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005157; cv=none; b=AXXsjJZEkxVpOS7kxWJVjGR2xczcxtGcGzxQ7KkE08wptRLtFe/8eyhqakQ6JNXsjMjENWmx5sg3HJ1hKBXyYRK16Ug1Uj+a3kLrYcaFKgdKlUoKm1jl1M1Bk/cdQKlU96vbgVl8CJTtFLrkkkFmDecEqz1rExRKGs9jJFAtnms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005157; c=relaxed/simple;
	bh=U7lMu8m0dw0ArsEn5+e2wEp9zKzRCt/+KD0bd5BW5FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZtVyBcXDm6bJ+aYkoIIbeKq9p+zzcolaOWcrQHcU1bSg0LIHVJV8AbiQJo5HDFkEw/AMub8uo+ngmllb5A86ZAfjIiIHKY7DeUWw97EFQSEYFGNtvEXWxrh7M7V/DRZAC/QJ3HoRbmj/v4HvgatF9TKOYtHLnT8sqtn7/fCtCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QwbJLSog; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QwbJLSog"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HVq5h89z6ClY9K;
	Tue, 10 Sep 2024 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005150; x=1728597151; bh=NyjaE
	SiX1YAiX6d+ldZl6Ad4kITviHe/WoI+/kNDj2I=; b=QwbJLSogm8Tob77jKA0HG
	9iz1HL16rI6vrab8oLqw3Mgzm10B1EN9A7xOnNEU4nD9AsY2biIfi50/sCIhJ5SG
	LF3QWI8Nx/kxZ2vvbb72Y32HJArSkmJ3qnsXg0xhWoWmWOfT4K59WgdOSZDSNco9
	rvAvvSRPk0Apa4I+c4NHQba8G5MDegvW+LIEB6GSwv/GuVLprDJGl0aBf56omh/P
	TCIVYpYEqn+DDb4cx24LW9NqStgvYlJTSTzzqJIHUFFl/wuv+dvEswttDAP5lYZA
	XkQzt6SVOPLCfrj3pv/FI3Xv5+/2U5V1av/jqMdGrN5c+AnLbbxdkL3m91PKWwu3
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gLjoGcKcpjGe; Tue, 10 Sep 2024 21:52:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HVh5g7Kz6ClY9J;
	Tue, 10 Sep 2024 21:52:28 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 04/10] scsi: ufs: core: Introduce ufshcd_process_device_init_result()
Date: Tue, 10 Sep 2024 14:50:52 -0700
Message-ID: <20240910215139.3352387-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240910215139.3352387-1-bvanassche@acm.org>
References: <20240910215139.3352387-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for moving a ufshcd_device_init() call from inside
ufshcd_probe_hba() into the ufshcd_probe_hba() callers by introducing the
function ufshcd_process_device_init_result(). No functionality has been
changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6ebafd08ad6e..1094c1ba2212 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7664,6 +7664,29 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	return err;
 }
=20
+/**
+ * ufshcd_process_device_init_result - Process the ufshcd_device_init() =
result.
+ * @hba: UFS host controller instance.
+ * @start: time when the ufshcd_device_init() call started.
+ * @ret: ufshcd_device_init() return value.
+ */
+static void ufshcd_process_device_init_result(struct ufs_hba *hba,
+					ktime_t device_init_start, int ret)
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
+			ktime_to_us(ktime_sub(ktime_get(), device_init_start)),
+			hba->curr_dev_pwr_mode, hba->uic_link_state);
+}
+
 /**
  * ufshcd_host_reset_and_restore - reset and restore host controller
  * @hba: per-adapter instance
@@ -8827,7 +8850,6 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 {
 	ktime_t start =3D ktime_get();
-	unsigned long flags;
 	int ret;
=20
 	ret =3D ufshcd_device_init(hba, init_dev_params);
@@ -8873,16 +8895,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, b=
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
+	ufshcd_process_device_init_result(hba, start, ret);
 	return ret;
 }
=20

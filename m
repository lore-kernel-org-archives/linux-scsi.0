Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418D16C854
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 21:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726005179; cv=none; b=VpUMN8DAYp3v1OWpgswmt/0auVS+0sVEoKNYs6qwc+qEFTtoWrAl0IYNHcwouoMMSKYSRn78RMXgTHbRWX3aovyfi+/zyeYZEIG5lNqrpBfYWCzumVS1/HUFRuIf3mSsB8V4XzrnnPQuAXmFsET/q4527dQqsTrYpioUXH8fdlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726005179; c=relaxed/simple;
	bh=zNlCB08jDbibw0nhGvbGzTuYdrXLqSKTf4TVKOOWbik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnXcGV15B1BSWDa2o6aYSzV7wi+kkLOV17zHItbObbS6nkRPl46pa491x62GiQ/es7Mgf6vuFFLF+ejb0YpHD3BjJ0X4jGp+gnzJwIW9AxSuE5L54wwzQoXpUYdqm+eSL+sbmLYpwrZFYe1FTAUyiwAYtE3Su1oT955ZIGZ8jJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1/fHbeNj; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1/fHbeNj"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3HWD1LPSz6ClY9K;
	Tue, 10 Sep 2024 21:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726005167; x=1728597168; bh=be49l
	IEYpP6EJ8/UJiShDjP+G2nBMdGBWpxxS+kJn94=; b=1/fHbeNjbif1uv5kp/qXy
	RZY385dY4C6gtM8RDsWEJUdP7r3yZDsX2fhxTjs6KfQmayRlz97qts9Z7B25gzhp
	jYSultiE2LzJ9EAToCSH8cE0WJIWeN9pATbyv+qaKlvaTR9AfKCG92mS/kFoYR90
	Ls7Rb4QXn6r8qUIGlzw7EcMZHnLcvYjllpud/HNMev6E2E1jstFi3k+v6/0+C2Br
	2k3P+B4bimS7T5RA+81id5g+rU6qo46xN68oDh/yfDG3QI9E8Me67yn7OE1hTHW4
	rPbcAE9UTzn2e54q/2VwEVIU7QLc+usQ6cOB5tWbLAY1hDKwxAI+Ts5vF9O2CZIF
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dS-R03DnjCMB; Tue, 10 Sep 2024 21:52:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3HW04Gd1z6ClY9H;
	Tue, 10 Sep 2024 21:52:44 +0000 (UTC)
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
	Alim Akhtar <alim.akhtar@samsung.com>,
	Eric Biggers <ebiggers@google.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v5 06/10] scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
Date: Tue, 10 Sep 2024 14:50:54 -0700
Message-ID: <20240910215139.3352387-7-bvanassche@acm.org>
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

ufshcd_async_scan() is called (asynchronously) only by ufshcd_init().
Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
into ufshcd_init(). This patch prepares for moving both scsi_add_host()
calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
ufshcd_init() without holding hba->host_sem is safe. This is safe because
hba->host_sem serializes core code and sysfs callbacks. The
ufshcd_device_init() call is moved before the scsi_add_host() call and
hence happens before any SCSI sysfs attributes are created.

Since ufshcd_add_scsi_host() checks whether or not the MCQ mode is
enabled and since ufshcd_device_init() may modify hba->mcq_enabled,
only call scsi_add_host() from ufshcd_device_init() if the SCSI host
has not yet been added by ufshcd_device_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++++++-------
 include/ufs/ufshcd.h      |  3 +++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f62d257a92da..a3c5493ccc8f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8907,16 +8907,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, =
bool init_dev_params)
 static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 {
 	struct ufs_hba *hba =3D (struct ufs_hba *)data;
-	ktime_t device_init_start;
 	int ret;
=20
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
-	device_init_start =3D ktime_get();
-	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
-	if (ret =3D=3D 0)
-		ret =3D ufshcd_probe_hba(hba, true);
-	ufshcd_process_device_init_result(hba, device_init_start, ret);
+	ret =3D ufshcd_probe_hba(hba, true);
+	ufshcd_process_device_init_result(hba, hba->device_init_start, ret);
 	up(&hba->host_sem);
 	if (ret)
 		goto out;
@@ -10387,7 +10383,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
 {
 	int err;
=20
-	if (!is_mcq_supported(hba)) {
+	if (!hba->scsi_host_added) {
 		err =3D scsi_add_host(hba->host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
@@ -10610,6 +10606,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	/* Initialize hba, detect and initialize UFS device */
+	hba->device_init_start =3D ktime_get();
+	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (err)
+		goto out_disable;
+
 	err =3D ufshcd_add_scsi_host(hba);
 	if (err)
 		goto out_disable;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a43b14276bc3..55ec89fa16af 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -839,6 +839,7 @@ enum ufshcd_mcq_opr {
  * @dev: device handle
  * @ufs_device_wlun: WLUN that controls the entire UFS device.
  * @hwmon_device: device instance registered with the hwmon core.
+ * @device_init_start: start time of first ufshcd_device_init() call.
  * @curr_dev_pwr_mode: active UFS device power mode.
  * @uic_link_state: active state of the link to the UFS device.
  * @rpm_lvl: desired UFS power management level during runtime PM.
@@ -972,6 +973,8 @@ struct ufs_hba {
 	struct device *hwmon_device;
 #endif
=20
+	ktime_t device_init_start;
+
 	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
 	enum uic_link_state uic_link_state;
 	/* Desired UFS power management level during runtime PM */

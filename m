Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CA334B43F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588017; cv=none; b=Is2/ZpjE8LuVEA1d8O3ncWDGzqCZttZQ3urqXCrzuwbE+TfANXf0d82OzWv1fd9xMw6BEnWWrxzuuLX0CuGRNAD6Jn7NrCRxWyBEHjIax0hm8yJ+UVx7P1YDA6/pr6JKVRq41TEnw9AGc91+6QFghEm/8M4FlBsHTb0jg0Tpd/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588017; c=relaxed/simple;
	bh=1VnZETSWzVeBgCSHnrM7NnffQllZEoxFNUkBaU6vsTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQskqlweTlnQ+m1eqxRjIpNhXQaLEHuYvmlOsRIxENEFV/xukielcUEGe+CIw/1PwrbK6mHlnw7kStxMRM00w7FK2uyId7sPx0qHST012dwdei3jiZHRHV6F/Mx32TdX3qkuuNlrv82aX63XPeb1F6gnpxrytw+PpTOZmzeRvyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IDlxgKCw; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IDlxgKCw"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dt7bz5Wnzzlfl7l;
	Fri, 16 Jan 2026 18:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1768588013; x=1771180014; bh=RUQQh
	+pic7ST0AzV2eWYHqi2RgIQURsRWonWoP2YOtM=; b=IDlxgKCwAXpOysUdmIsqC
	RHlIut9tIlGV7iY4N10TLi82RI9d9VR6P47OuXlvdE7KtemEcOAcpkS+NOTkGoKy
	KULM4HU6jtnVyQ7VjLCTktW/q6eENvkSx8MaBDKxqWc3W/xenrC/J/6I8wsih/eN
	/Tn7w6wJi8lafUqjKZw7/T3Nu1jHr5uKcOTA+E0aXIkXrCbTYLtAPz+u224D5am1
	g151v6XITy19q2/UG+G2g19LunrH7VYwhwfmEnB/BU+IVqTg/pceBawR7QGHILEM
	QCV9LIjk4gtko+V0NuKb/tDMC554K3xptZ/pTLIZWHJW+yv/HrYGe0oySEiXJX+V
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fX3CNaGDms9x; Fri, 16 Jan 2026 18:26:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dt7bv6Wz9zlh1Vy;
	Fri, 16 Jan 2026 18:26:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 3/7] ufs: core: Redirect clock gating to RPM
Date: Fri, 16 Jan 2026 10:26:05 -0800
Message-ID: <20260116182628.3255116-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260116182628.3255116-1-bvanassche@acm.org>
References: <20260116182628.3255116-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Let the clkgate_enable and clkgate_delay_ms sysfs attributes control
runtime power management instead of clock gating. Enable runtime power
management if either UFSHCD_CAP_RPM_AUTOSUSPEND or UFSHCD_CAP_CLK_GATING
have been set.

This patch prepares for removing the clock gating code because:
- The functionality of the clock gating code is identical to the runtime
  power management code. Both track the number of SCSI commands that are =
in
  progress, gate clocks, disable VCC and VCCQ and trigger link hibernatio=
n
  after a delay if no commands are in progress.
- The runtime power management code is more efficient because it uses a
  per-CPU counter while the clock gating code uses a single counter that
  is protected by a spinlock. Every spinlock in the I/O path has a
  measurable performance impact. Additionally, the clock gating code
  sets the BLK_MQ_F_BLOCKING flag for all SCSI request queues. This flag
  increases the amount of time spent in the block layer on processing
  requests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 49 +++++++++++++++++++++++++--------------
 include/ufs/ufshcd.h      |  2 +-
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ee1947af797..900b945444d1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2107,18 +2107,31 @@ void ufshcd_release(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
=20
+/* The struct device instance that controls RPM for the UFS device. */
+static inline struct device *ufs_rpm_dev(struct ufs_hba *hba)
+{
+	return &hba->ufs_device_wlun->sdev_gendev;
+}
+
 static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	struct device *rpm_dev =3D ufs_rpm_dev(hba);
=20
-	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
+	if (!rpm_dev->power.use_autosuspend)
+		return -EIO;
+
+	return sysfs_emit(buf, "%u\n", rpm_dev->power.autosuspend_delay);
 }
=20
 void ufshcd_clkgate_delay_set(struct ufs_hba *hba, unsigned long value)
 {
-	guard(spinlock_irqsave)(&hba->clk_gating.lock);
-	hba->clk_gating.delay_ms =3D value;
+	struct device *rpm_dev =3D ufs_rpm_dev(hba);
+
+	device_lock(rpm_dev);
+	pm_runtime_set_autosuspend_delay(rpm_dev, value);
+	device_unlock(rpm_dev);
 }
 EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
=20
@@ -2126,8 +2139,12 @@ static ssize_t ufshcd_clkgate_delay_store(struct d=
evice *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	struct device *rpm_dev =3D ufs_rpm_dev(hba);
 	unsigned long value;
=20
+	if (!rpm_dev->power.use_autosuspend)
+		return -EIO;
+
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
=20
@@ -2140,31 +2157,27 @@ static ssize_t ufshcd_clkgate_enable_show(struct =
device *dev,
 {
 	struct ufs_hba *hba =3D dev_get_drvdata(dev);
=20
-	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
+	return sysfs_emit(buf, "%d\n", ufs_rpm_dev(hba)->power.runtime_auto);
 }
=20
 static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct ufs_hba *hba =3D dev_get_drvdata(dev);
-	u32 value;
-
-	if (kstrtou32(buf, 0, &value))
-		return -EINVAL;
-
-	value =3D !!value;
-
-	guard(spinlock_irqsave)(&hba->clk_gating.lock);
+	struct device *rpm_dev =3D ufs_rpm_dev(hba);
+	bool value;
+	int err;
=20
-	if (value =3D=3D hba->clk_gating.is_enabled)
-		return count;
+	err =3D kstrtobool(buf, &value);
+	if (err)
+		return err;
=20
+	device_lock(rpm_dev);
 	if (value)
-		__ufshcd_release(hba);
+		pm_runtime_allow(rpm_dev);
 	else
-		hba->clk_gating.active_reqs++;
-
-	hba->clk_gating.is_enabled =3D value;
+		pm_runtime_forbid(rpm_dev);
+	device_unlock(rpm_dev);
=20
 	return count;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index b4aef7acd351..dac07a5cd998 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1224,7 +1224,7 @@ static inline bool ufshcd_can_autobkops_during_susp=
end(struct ufs_hba *hba)
 }
 static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba=
)
 {
-	return hba->caps & UFSHCD_CAP_RPM_AUTOSUSPEND;
+	return hba->caps & (UFSHCD_CAP_RPM_AUTOSUSPEND | UFSHCD_CAP_CLK_GATING)=
;
 }
=20
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)

Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E771179A7;
	Thu, 23 Jan 2025 07:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737617804; cv=none; b=ItrbMF91VfLnMKOEqjO3Ds2zpeouELnehy7GF+G0XgDl0Be+AOR2/ut1iv9umZpWJRBtSQpkfw5ghIWDaj4C3x0HNYX2AolOZMDcJJ8ZwmA2MSYBAL0Fo43usEW0jNq4QBruzc0qhjxr537OjXIH3HI/oPSrDffspv3czzfGaJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737617804; c=relaxed/simple;
	bh=wTBUQbh6p6c8GRWQlSHXjiXan3OxBt6/XBH9ltE9mpA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lq5u+f+Fq6UTuoQxTXPfm0NwkxtiFVQ3twltbo1Bulx18mJUQDNlXk7+m7rPqJ3rMBgGkv4UB0A/OQkieHX/iOLNv2gCuJ+0S6F8h4eWaEibT3lOirQFZzQbeUQ0iwZqcKu8KxAQxw0xgc0o82tCd870BWnEGWrDMFjP+9ZKRrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GLaDH1jy; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GLaDH1jy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1737617803; x=1769153803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wTBUQbh6p6c8GRWQlSHXjiXan3OxBt6/XBH9ltE9mpA=;
  b=GLaDH1jy5HYPqHs6P4WMqm1rmsffOJz7q0mn4v3rCaDRWa4YB2GGSB1Y
   E4kB5EHDn8nzd99Dr0TJi66vOHfm1OLDotQZXrZQaEoo+BjtXgaoVBtv0
   J6dIU1T7PMDy74eEqDHT/zyYT5nNIgeExqUeGxO0L1his0xqbXg+aDugN
   Q69ucXv/5sZNyRKVuNdkS468qqUi9U6+qJqWnrAPAgXlnuCJdOpKoxjn2
   Po3uCdhdQ7xgKGeuE/6qb+X5GIeDm5TmFclO0Vaf58JcWR9z31QTvO58E
   RVagZLl7bfw7IzKThcFdks9m+1taHhx5/lb47uSBygvQLStk39qhucJZn
   w==;
X-CSE-ConnectionGUID: KUlNrfHtR5SfowXsWyXvaQ==
X-CSE-MsgGUID: HQrKgGQiQPOx4Ksa9SXhaw==
X-IronPort-AV: E=Sophos;i="6.13,227,1732550400"; 
   d="scan'208";a="36593340"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2025 15:36:40 +0800
IronPort-SDR: 6791e3ef_unY5EWiLjBUx/51Efoc+budlddbsiO14gIWzkQvdJ0tt+RQ
 LmKFdubZSyUPQlidOJx3JeBoJz4H/Pb66U6SAbw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jan 2025 22:38:39 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jan 2025 23:36:38 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <cang@qti.qualcomm.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2] scsi: ufs: Move clock gating sysfs entries to ufs-sysfs.c
Date: Thu, 23 Jan 2025 09:33:59 +0200
Message-Id: <20250123073359.3809072-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit moves the clock gating sysfs entries from `ufshcd.c` to
`ufs-sysfs.c` where it belongs. This change improves the organization of
the code by consolidating all sysfs-related code into a single file.

The `clkgate_enable` and `clkgate_delay_ms` attributes are now defined
and managed in `ufs-sysfs.c`, and the corresponding initialization and
removal functions in `ufshcd.c` are removed.

No functional change.

Signed-off-by: Avri Altman <avri.altman@wdc.com>

---
Changes compared to v1:
 - Use clang-format instead of checkpatch to fix coding style (Bart)
 - Use kstrbool instead of kstrtou32 (Bart)
---
 drivers/ufs/core/ufs-sysfs.c | 58 ++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c    | 85 ------------------------------------
 2 files changed, 58 insertions(+), 85 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 796e37a1d859..7183709603ae 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -458,6 +458,60 @@ static ssize_t pm_qos_enable_store(struct device *dev,
 	return count;
 }
 
+static ssize_t clkgate_enable_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
+}
+
+static ssize_t clkgate_enable_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	bool value;
+
+	if (kstrtobool(buf, &value))
+		return -EINVAL;
+
+	guard(spinlock_irqsave)(&hba->clk_gating.lock);
+
+	if (value == hba->clk_gating.is_enabled)
+		return count;
+
+	if (value)
+		ufshcd_release(hba);
+	else
+		hba->clk_gating.active_reqs++;
+
+	hba->clk_gating.is_enabled = value;
+
+	return count;
+}
+
+static ssize_t clkgate_delay_ms_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
+}
+
+static ssize_t clkgate_delay_ms_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	ufshcd_clkgate_delay_set(dev, value);
+	return count;
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -470,6 +524,8 @@ static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
+static DEVICE_ATTR_RW(clkgate_delay_ms);
+static DEVICE_ATTR_RW(clkgate_enable);
 
 static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_rpm_lvl.attr,
@@ -484,6 +540,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_flush_threshold.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
+	&dev_attr_clkgate_delay_ms.attr,
+	&dev_attr_clkgate_enable.attr,
 	NULL
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f6c38cf10382..901aef52a452 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2019,14 +2019,6 @@ void ufshcd_release(struct ufs_hba *hba)
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
 
-static ssize_t ufshcd_clkgate_delay_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-
-	return sysfs_emit(buf, "%lu\n", hba->clk_gating.delay_ms);
-}
-
 void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
@@ -2036,79 +2028,6 @@ void ufshcd_clkgate_delay_set(struct device *dev, unsigned long value)
 }
 EXPORT_SYMBOL_GPL(ufshcd_clkgate_delay_set);
 
-static ssize_t ufshcd_clkgate_delay_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	unsigned long value;
-
-	if (kstrtoul(buf, 0, &value))
-		return -EINVAL;
-
-	ufshcd_clkgate_delay_set(dev, value);
-	return count;
-}
-
-static ssize_t ufshcd_clkgate_enable_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-
-	return sysfs_emit(buf, "%d\n", hba->clk_gating.is_enabled);
-}
-
-static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct ufs_hba *hba = dev_get_drvdata(dev);
-	u32 value;
-
-	if (kstrtou32(buf, 0, &value))
-		return -EINVAL;
-
-	value = !!value;
-
-	guard(spinlock_irqsave)(&hba->clk_gating.lock);
-
-	if (value == hba->clk_gating.is_enabled)
-		return count;
-
-	if (value)
-		__ufshcd_release(hba);
-	else
-		hba->clk_gating.active_reqs++;
-
-	hba->clk_gating.is_enabled = value;
-
-	return count;
-}
-
-static void ufshcd_init_clk_gating_sysfs(struct ufs_hba *hba)
-{
-	hba->clk_gating.delay_attr.show = ufshcd_clkgate_delay_show;
-	hba->clk_gating.delay_attr.store = ufshcd_clkgate_delay_store;
-	sysfs_attr_init(&hba->clk_gating.delay_attr.attr);
-	hba->clk_gating.delay_attr.attr.name = "clkgate_delay_ms";
-	hba->clk_gating.delay_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_gating.delay_attr))
-		dev_err(hba->dev, "Failed to create sysfs for clkgate_delay\n");
-
-	hba->clk_gating.enable_attr.show = ufshcd_clkgate_enable_show;
-	hba->clk_gating.enable_attr.store = ufshcd_clkgate_enable_store;
-	sysfs_attr_init(&hba->clk_gating.enable_attr.attr);
-	hba->clk_gating.enable_attr.attr.name = "clkgate_enable";
-	hba->clk_gating.enable_attr.attr.mode = 0644;
-	if (device_create_file(hba->dev, &hba->clk_gating.enable_attr))
-		dev_err(hba->dev, "Failed to create sysfs for clkgate_enable\n");
-}
-
-static void ufshcd_remove_clk_gating_sysfs(struct ufs_hba *hba)
-{
-	if (hba->clk_gating.delay_attr.attr.name)
-		device_remove_file(hba->dev, &hba->clk_gating.delay_attr);
-	if (hba->clk_gating.enable_attr.attr.name)
-		device_remove_file(hba->dev, &hba->clk_gating.enable_attr);
-}
-
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
 	if (!ufshcd_is_clkgating_allowed(hba))
@@ -2126,8 +2045,6 @@ static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 		"ufs_clk_gating_%d", WQ_MEM_RECLAIM | WQ_HIGHPRI,
 		hba->host->host_no);
 
-	ufshcd_init_clk_gating_sysfs(hba);
-
 	hba->clk_gating.is_enabled = true;
 	hba->clk_gating.is_initialized = true;
 }
@@ -2137,8 +2054,6 @@ static void ufshcd_exit_clk_gating(struct ufs_hba *hba)
 	if (!hba->clk_gating.is_initialized)
 		return;
 
-	ufshcd_remove_clk_gating_sysfs(hba);
-
 	/* Ungate the clock if necessary. */
 	ufshcd_hold(hba);
 	hba->clk_gating.is_initialized = false;
-- 
2.25.1


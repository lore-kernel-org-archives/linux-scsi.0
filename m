Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794876453;
	b=Rchgs0vp/vzfcwVQdQKJGbZKqPtckyzGz+/ylOO9qyYFIOfzQ3pZ+jHGuXl6N400HLZh
	 xPSVvapSrBI1NtxVm+LAFvYqm6N2xuaOt7D2b8pKxbA5GshlAQoDGOTSJ0xL7nALWKmWF
	 6NM2ExsDV+Kwbh4FiPTlnEIfIByqi3dpStA5DnWgt9jK51t1QG0SsgNKC3lceqR7Pp8xj
	 cO5cmGNM67Z3KYE6FtcpnSxWvG99+5lE/FAd25LA5fzr9v7WC8u+bEIEv/6wERWzuZg/m
	 fW4ifvmDNp+whHwV5U4lsKPBf0J/Z9E7I7BsAAz5A1eg6dfQjE2x7hv/BTCBmPovdrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794876453;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=swz6q/fZll2L0/uYNXaS/pn/UP7s0ciyOT1o4K6UDYg=;
	b=H4Eo27qshUDtofiFNHD0JTz6IqHdYixTBkQiNCH9butfkFDeDHEIionGwAcAFXM55OIX
	 h3Pg2u30xrKV30cwITrkc1ctPfkxhBLGMiyRWid9kB1ve9jUZPVGY65NFGZo3g6OCq0nW
	 kB15uP5/u+fIwvVVewSsy6wNvzR3HIxJxvvKsugU4PFj1oHHJlbj2oYW58Q8zzWBG8PGn
	 5+iK9CCQQpsqczWC/GXKR3fWV/AE44+W9G1j0c4/aDDlej2w/yQ4zXPdixnogELAq8FYt
	 lryoXLCAfRI5XVwysp+nhKqnI69OlV5F5zepudgXgxpnyzao6Zxg2PBEdKdzkU3incA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--chullee.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eWuOrCdL;
	arc=none smtp.remote-ip=74.125.82.71
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CF8606A31C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 00:47:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49CF8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chullee.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=eWuOrCdL
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b3a348a6dbso3730135c88.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 16:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794876452; x=1795481252; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=swz6q/fZll2L0/uYNXaS/pn/UP7s0ciyOT1o4K6UDYg=;
        b=eWuOrCdLFTfzW+hV1tOD58ZJ3MIaMn+txmO9fkpo3elA/XTxHVHzH4Mo+hXmc9UtIF
         u+XXmdHPxHOUdhWkAbA9XmcaWD9hUkYfTtLWiI4xNqRS+tPb5drjX4N+h2neh+4qJGHQ
         xX1P5+2SD+n5n7Xr6JCsHxZI78zRo/F10alK78nm0nZ+rfHtZL8vPVdSwBSNgOu8Os1Y
         dP7feoYVZfVdXtwctmnOjcYoncIqGYZ12Vyp9bztrd+dBTsJMezxwfLT7g25C3V1Kj3T
         60vUxdGcMyDGIqir8iqi6iuN/y5v131fMN0WIdPtJGeMn4GEoxT8nn6lRaPt/y7zK4rv
         jpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794876452; x=1795481252;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=swz6q/fZll2L0/uYNXaS/pn/UP7s0ciyOT1o4K6UDYg=;
        b=FNNkQZGlMhKFFBLbgdmP63uR068bTRtM7G3faZZCldT40ihRRc0ob5YjFDS50ljoPF
         kBOznyK2Wp0PHmKGLQ+purjSpkPxocWRwRsq0YXiD08wrTKHaENPuhsnauIF2FzcITm9
         u7clcvdbCDTBoGqcwxPffxfNmpsDdI8OwkSZqzuPKb/HoWs0UyNmI8IZTn4W6P6yMY6o
         WRSiuBfD5pgBbkmhR5CSvf0yuIVj1ScVp8NQLAwQ/hjSX/Re/bAlaHxBwrcfeIO4CLD4
         YicnSwhLLD4/aFA64gKwPLDul8+CFsjqOigFjI5oDoQgzdX7EouCuoHMv7kjNoLXBEhY
         ZURA==
X-Forwarded-Encrypted: i=1; AL+hErHAPO8o3b9M46wTGuBfKL36b/dRqXoKS23y5ARaqzXsBjBYXcodeQOzfJOnj96ZaZB6QjcOiw6f4fpf@vger.kernel.org
X-Gm-Message-State: APuU4Z8DQCyY9fISQsvOlL/r/nr3q65esTjYVd/G9u+0/O3rxH9SZdlU
	V3niM2rqP9Sz0lcsmd7hB8sgbFCDV4HkDgK0ZnyXAcjLZaNdarvCbatYYiccniTZCFjelO26E+J
	bDmXj/362rg==
X-Received: from dleb17-n1.prod.google.com ([2002:a05:701b:4251:10b0:1b2:6e34:9a49])
 (user=chullee job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:f97:b0:1a7:216d:157c
 with SMTP id a92af1059eb24-1b503175931mr19380021c88.34.1794876451969; Mon, 16
 Nov 2026 16:47:31 -0800 (PST)
Date: Mon, 16 Nov 2026 17:47:29 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
Message-ID: <20261117004729.635562-1-chullee@google.com>
Subject: [PATCH v4] ufs: sysfs: Add WB partial flush mode support
From: Daniel Lee <chullee@google.com>
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@sandisk.com, bvanassche@acm.org, 
	tanghuan@vivo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chullee@google.com
Content-Type: text/plain; charset="UTF-8"

Expose the following JEDEC UFS 4.1 Extended WriteBooster attributes and
flags to sysfs to support FIFO and Pinned partial flush modes:

  - wb_partial_flush_mode
  - wb_max_fifo_size
  - wb_cur_fifo_size
  - wb_pinned_cur_size
  - wb_pinned_avail_pct
  - wb_pinned_cumulative_write_size
  - wb_pinned_size
  - wb_non_pinned_min_size
  - wb_unpin_enable

Introduce UFS_ATTRIBUTE_RW and UFS_FLAG_RW to support writable attributes
and flags.
Document the new entries under Documentation/ABI/testing/sysfs-driver-ufs.

Assisted-by: Gemini:gemini-3.1
Signed-off-by: Daniel Lee <chullee@google.com>
---
v4:
- Update ABI documentation (Date, units, granularity, and value formats).
- Use index 0 for device-level (Type "D") WB attributes and flags.
- Support 64-bit attributes in ufs_sysfs_attr_store().
- Check Extended WB capability bits and return -EOPNOTSUPP if unsupported.
- Fix QUERY_ATTR_IDN_PINNED_WB_CUMULATIVE_WS spelling.
v3:
- Fold ufs_wb_pfm_to_string() into wb_partial_flush_mode_show().
- Propagate actual error codes for non-OCS error (ret < 0), while keeping -EINVAL for OCS errors (ret > 0).
- Clean up blank lines.
v2:
- Change wb_partial_flush_mode attribute to accept and report strings instead of numbers for better usability.
- Order local variable declarations from longest to shortest in new functions.
 Documentation/ABI/testing/sysfs-driver-ufs |  89 +++++
 drivers/ufs/core/ufs-sysfs.c               | 384 +++++++++++++++++----
 include/ufs/ufs.h                          |  19 +
 3 files changed, 431 insertions(+), 61 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 3c422aac7..caa11276c 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1791,3 +1791,92 @@ Description:
 		will be rejected.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_partial_flush_mode
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_partial_flush_mode
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry controls Extended WriteBooster partial flush modes.
+
+		======  ==============================
+		none    No partial flush
+		fifo    FIFO mode
+		pinned  Pinned mode
+		======  ==============================
+
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_max_fifo_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_max_fifo_size
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry configures the maximum size in Allocation Units reserved for the
+		WriteBooster FIFO Buffer.
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_fifo_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_cur_fifo_size
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the current size in Allocation Units of the WriteBooster FIFO
+		Buffer.
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_size
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry configures the allocated size in Allocation Units for the UFS
+		Pinned WriteBooster buffer.
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_cur_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_cur_size
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the current allocated size in Allocation Units for the UFS
+		Pinned WriteBooster buffer.
+		The attribute is read-only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_avail_pct
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_avail_pct
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the percentage of available space remaining in the
+		Pinned WriteBooster buffer in 10% granularity (0x0: 0%,
+		0x1..0x9: 10%..90%, 0xA: 100%).
+		The attribute is read-only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_cumulative_write_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_cumulative_write_size
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the total cumulative size of data written to the
+		Pinned WriteBooster buffer in units of 10 MB (saturates at
+		0xFFFFFFFF).
+		The attribute is read-only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_non_pinned_min_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_non_pinned_min_size
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry configures the minimum size in Allocation Units for the
+		Non-Pinned WriteBooster Buffer area when Pinned partial flush mode is active.
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_unpin_enable
+What:		/sys/bus/platform/devices/*.ufs/flags/wb_unpin_enable
+Date:		November 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry controls the Pinned WriteBooster unpin enable flag (fUnpinEn).
+		Reading returns "false" or "true". Writing accepts standard
+		kstrtobool() strings (e.g. 0/1, false/true, n/y, off/on).
+
+		=====  ==============================================================
+		false  Unpin Disable: pinned data is not flushed by WriteBooster
+		       Buffer flush operation.
+		true   Unpin Enable: pinned data is flushed by WriteBooster
+		       Buffer flush operation.
+		=====  ==============================================================
+
+		The attribute is read-write.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index cf49ad025..5e3f29d17 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -89,6 +89,12 @@ static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
 	}
 }
 
+static const char * const wb_partial_flush_modes[] = {
+	[WB_PARTIAL_FLUSH_NONE]		= "none",
+	[WB_PARTIAL_FLUSH_FIFO]		= "fifo",
+	[WB_PARTIAL_FLUSH_PINNED]	= "pinned",
+};
+
 static const char * const ufs_hid_states[] = {
 	[HID_IDLE]		= "idle",
 	[ANALYSIS_IN_PROGRESS]	= "analysis_in_progress",
@@ -1532,37 +1538,110 @@ static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
 		idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8;
 }
 
+static bool ufshcd_is_wb_fifo_pfm_supported(struct ufs_hba *hba)
+{
+	return ufshcd_is_wb_allowed(hba) &&
+	       (hba->dev_info.ext_wb_sup & UFS_DEV_WB_FIFO_PFM);
+}
+
+static bool ufshcd_is_wb_pinned_pfm_supported(struct ufs_hba *hba)
+{
+	return ufshcd_is_wb_allowed(hba) &&
+	       hba->dev_info.b_presrv_uspc_en &&
+	       (hba->dev_info.ext_wb_sup & UFS_DEV_WB_PINNED_PFM);
+}
+
+static ssize_t ufs_sysfs_flag_show(struct device *dev,
+	struct device_attribute *attr, char *buf, enum flag_idn idn)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u8 index = 0;
+	bool flag;
+	int ret;
+
+	if (idn == QUERY_FLAG_IDN_WB_UNPIN_EN &&
+	    !ufshcd_is_wb_pinned_pfm_supported(hba))
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	if (ufshcd_is_wb_flags(idn))
+		index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+		idn, index, &flag);
+	ufshcd_rpm_put_sync(hba);
+	if (ret > 0)
+		ret = -EINVAL;
+	if (ret)
+		goto out;
+	ret = sysfs_emit(buf, "%s\n", str_true_false(flag));
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t ufs_sysfs_flag_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count,
+	enum flag_idn idn)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u8 index = 0;
+	bool value;
+	int ret;
+
+	if (idn == QUERY_FLAG_IDN_WB_UNPIN_EN &&
+	    !ufshcd_is_wb_pinned_pfm_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (kstrtobool(buf, &value))
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	if (ufshcd_is_wb_flags(idn))
+		index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_flag(hba,
+		value ? UPIU_QUERY_OPCODE_SET_FLAG : UPIU_QUERY_OPCODE_CLEAR_FLAG,
+		idn, index, NULL);
+	ufshcd_rpm_put_sync(hba);
+	if (ret > 0)
+		ret = -EINVAL;
+	up(&hba->host_sem);
+	return ret ? ret : count;
+}
+
 #define UFS_FLAG(_name, _uname)						\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
-	bool flag;							\
-	u8 index = 0;							\
-	int ret;							\
-	struct ufs_hba *hba = dev_get_drvdata(dev);			\
-									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
-		return -EBUSY;						\
-	}								\
-	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
-		index = ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
-	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
-		QUERY_FLAG_IDN##_uname, index, &flag);			\
-	ufshcd_rpm_put_sync(hba);					\
-	if (ret) {							\
-		ret = -EINVAL;						\
-		goto out;						\
-	}								\
-	ret = sysfs_emit(buf, "%s\n", str_true_false(flag));		\
-out:									\
-	up(&hba->host_sem);						\
-	return ret;							\
+	return ufs_sysfs_flag_show(dev, attr, buf,			\
+				   QUERY_FLAG_IDN##_uname);		\
 }									\
 static DEVICE_ATTR_RO(_name)
 
+#define UFS_FLAG_RW(_name, _uname)					\
+static ssize_t _name##_show(struct device *dev,				\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	return ufs_sysfs_flag_show(dev, attr, buf,			\
+				   QUERY_FLAG_IDN##_uname);		\
+}									\
+static ssize_t _name##_store(struct device *dev,			\
+	struct device_attribute *attr, const char *buf, size_t count)	\
+{									\
+	return ufs_sysfs_flag_store(dev, attr, buf, count,		\
+				    QUERY_FLAG_IDN##_uname);		\
+}									\
+static DEVICE_ATTR_RW(_name)
+
 UFS_FLAG(device_init, _FDEVICEINIT);
 UFS_FLAG(permanent_wpe, _PERMANENT_WPE);
 UFS_FLAG(power_on_wpe, _PWR_ON_WPE);
@@ -1574,6 +1653,7 @@ UFS_FLAG(disable_fw_update, _PERMANENTLY_DISABLE_FW_UPDATE);
 UFS_FLAG(wb_enable, _WB_EN);
 UFS_FLAG(wb_flush_en, _WB_BUFF_FLUSH_EN);
 UFS_FLAG(wb_flush_during_h8, _WB_BUFF_FLUSH_DURING_HIBERN8);
+UFS_FLAG_RW(wb_unpin_enable, _WB_UNPIN_EN);
 
 static struct attribute *ufs_sysfs_device_flags[] = {
 	&dev_attr_device_init.attr,
@@ -1587,6 +1667,7 @@ static struct attribute *ufs_sysfs_device_flags[] = {
 	&dev_attr_wb_enable.attr,
 	&dev_attr_wb_flush_en.attr,
 	&dev_attr_wb_flush_during_h8.attr,
+	&dev_attr_wb_unpin_enable.attr,
 	NULL,
 };
 
@@ -1672,8 +1753,29 @@ static DEVICE_ATTR_RW(max_number_of_rtt);
 
 static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 {
-	return idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
-		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
+	return (idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
+		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE) ||
+	       idn == QUERY_ATTR_IDN_MAX_FIFO_SIZE_WB_PFM ||
+	       idn == QUERY_ATTR_IDN_CURRENT_FIFO_SIZE_WB_PFM ||
+	       idn == QUERY_ATTR_IDN_PINNED_WB_SIZE ||
+	       idn == QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE;
+}
+
+static bool ufshcd_is_attr_supported(struct ufs_hba *hba, enum attr_idn idn)
+{
+	switch (idn) {
+	case QUERY_ATTR_IDN_MAX_FIFO_SIZE_WB_PFM:
+	case QUERY_ATTR_IDN_CURRENT_FIFO_SIZE_WB_PFM:
+		return ufshcd_is_wb_fifo_pfm_supported(hba);
+	case QUERY_ATTR_IDN_PINNED_WB_CURRENT_SIZE:
+	case QUERY_ATTR_IDN_PINNED_WB_AVAIL_PERC:
+	case QUERY_ATTR_IDN_PINNED_WB_CUMULATIVE_WS:
+	case QUERY_ATTR_IDN_PINNED_WB_SIZE:
+	case QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE:
+		return ufshcd_is_wb_pinned_pfm_supported(hba);
+	default:
+		return true;
+	}
 }
 
 static inline bool ufshcd_is_qword_attr(enum attr_idn idn)
@@ -1743,48 +1845,113 @@ static ssize_t wb_resize_status_show(struct device *dev,
 
 static DEVICE_ATTR_RO(wb_resize_status);
 
+static ssize_t ufs_sysfs_attr_show(struct device *dev,
+	struct device_attribute *attr, char *buf, enum attr_idn idn)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u64 qword_value;
+	u8 index = 0;
+	u32 value;
+	int ret;
+
+	if (!ufshcd_is_attr_supported(hba, idn))
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	if (ufshcd_is_wb_attrs(idn))
+		index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	if (ufshcd_is_qword_attr(idn))
+		ret = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, &qword_value);
+	else
+		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, &value);
+	ufshcd_rpm_put_sync(hba);
+	if (ret > 0)
+		ret = -EINVAL;
+	if (ret)
+		goto out;
+	if (ufshcd_is_qword_attr(idn))
+		ret = sysfs_emit(buf, "0x%016llX\n", qword_value);
+	else
+		ret = sysfs_emit(buf, "0x%08X\n", value);
+out:
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t ufs_sysfs_attr_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count,
+	enum attr_idn idn)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u64 qword_value;
+	u8 index = 0;
+	u32 value;
+	int ret;
+
+	if (!ufshcd_is_attr_supported(hba, idn))
+		return -EOPNOTSUPP;
+
+	if (ufshcd_is_qword_attr(idn)) {
+		if (kstrtou64(buf, 0, &qword_value))
+			return -EINVAL;
+	} else {
+		if (kstrtou32(buf, 0, &value))
+			return -EINVAL;
+	}
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	if (ufshcd_is_wb_attrs(idn))
+		index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	if (ufshcd_is_qword_attr(idn))
+		ret = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			idn, index, 0, &qword_value);
+	else
+		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			idn, index, 0, &value);
+	ufshcd_rpm_put_sync(hba);
+	if (ret > 0)
+		ret = -EINVAL;
+	up(&hba->host_sem);
+	return ret ? ret : count;
+}
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
 {									\
-	struct ufs_hba *hba = dev_get_drvdata(dev);			\
-	u64 qword_value;						\
-	u32 value;							\
-	int ret;							\
-	u8 index = 0;							\
-									\
-	down(&hba->host_sem);						\
-	if (!ufshcd_is_user_access_allowed(hba)) {			\
-		up(&hba->host_sem);					\
-		return -EBUSY;						\
-	}								\
-	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
-		index = ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
-	if (ufshcd_is_qword_attr(QUERY_ATTR_IDN##_uname))		\
-		ret = ufshcd_query_attr_qword(hba,			\
-			UPIU_QUERY_OPCODE_READ_ATTR,			\
-			QUERY_ATTR_IDN##_uname,				\
-			index, 0, &qword_value);			\
-	else								\
-		ret = ufshcd_query_attr(hba,				\
-			UPIU_QUERY_OPCODE_READ_ATTR,			\
-			QUERY_ATTR_IDN##_uname, index, 0, &value);	\
-	ufshcd_rpm_put_sync(hba);					\
-	if (ret) {							\
-		ret = -EINVAL;						\
-		goto out;						\
-	}								\
-	if (ufshcd_is_qword_attr(QUERY_ATTR_IDN##_uname))		\
-		ret = sysfs_emit(buf, "0x%016llX\n", qword_value);	\
-	else								\
-		ret = sysfs_emit(buf, "0x%08X\n", value);		\
-out:									\
-	up(&hba->host_sem);						\
-	return ret;							\
+	return ufs_sysfs_attr_show(dev, attr, buf,			\
+				   QUERY_ATTR_IDN##_uname);		\
 }									\
 static DEVICE_ATTR_RO(_name)
 
+#define UFS_ATTRIBUTE_RW(_name, _uname)					\
+static ssize_t _name##_show(struct device *dev,				\
+			    struct device_attribute *attr, char *buf)	\
+{									\
+	return ufs_sysfs_attr_show(dev, attr, buf,			\
+				   QUERY_ATTR_IDN##_uname);		\
+}									\
+static ssize_t _name##_store(struct device *dev,			\
+			     struct device_attribute *attr,		\
+			     const char *buf, size_t count)		\
+{									\
+	return ufs_sysfs_attr_store(dev, attr, buf, count,		\
+				    QUERY_ATTR_IDN##_uname);		\
+}									\
+static DEVICE_ATTR_RW(_name)
+
 UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
 UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
 UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
@@ -1805,6 +1972,93 @@ UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
 
+static ssize_t wb_partial_flush_mode_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	if (!ufshcd_is_wb_fifo_pfm_supported(hba) &&
+	    !ufshcd_is_wb_pinned_pfm_supported(hba))
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+		QUERY_ATTR_IDN_WB_PFM, 0, 0, &value);
+	ufshcd_rpm_put_sync(hba);
+	up(&hba->host_sem);
+	if (ret > 0)
+		ret = -EINVAL;
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", value < NUM_WB_PARTIAL_FLUSH_MODES ?
+			  wb_partial_flush_modes[value] : "unknown");
+}
+
+static ssize_t wb_partial_flush_mode_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int mode;
+	int ret;
+
+	mode = sysfs_match_string(wb_partial_flush_modes, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	switch (mode) {
+	case WB_PARTIAL_FLUSH_NONE:
+		if (!ufshcd_is_wb_fifo_pfm_supported(hba) &&
+		    !ufshcd_is_wb_pinned_pfm_supported(hba))
+			return -EOPNOTSUPP;
+		break;
+	case WB_PARTIAL_FLUSH_FIFO:
+		if (!ufshcd_is_wb_fifo_pfm_supported(hba))
+			return -EOPNOTSUPP;
+		break;
+	case WB_PARTIAL_FLUSH_PINNED:
+		if (!ufshcd_is_wb_pinned_pfm_supported(hba))
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	value = mode;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_WB_PFM, 0, 0, &value);
+	ufshcd_rpm_put_sync(hba);
+	up(&hba->host_sem);
+
+	if (ret > 0)
+		ret = -EINVAL;
+	return ret ? ret : count;
+}
+
+static DEVICE_ATTR_RW(wb_partial_flush_mode);
+UFS_ATTRIBUTE_RW(wb_max_fifo_size, _MAX_FIFO_SIZE_WB_PFM);
+UFS_ATTRIBUTE(wb_cur_fifo_size, _CURRENT_FIFO_SIZE_WB_PFM);
+UFS_ATTRIBUTE(wb_pinned_cur_size, _PINNED_WB_CURRENT_SIZE);
+UFS_ATTRIBUTE(wb_pinned_avail_pct, _PINNED_WB_AVAIL_PERC);
+UFS_ATTRIBUTE(wb_pinned_cumulative_write_size, _PINNED_WB_CUMULATIVE_WS);
+UFS_ATTRIBUTE_RW(wb_pinned_size, _PINNED_WB_SIZE);
+UFS_ATTRIBUTE_RW(wb_non_pinned_min_size, _NON_PINNED_WB_MIN_SIZE);
 
 static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_boot_lun_enabled.attr,
@@ -1829,6 +2083,14 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_cur_buf.attr,
 	&dev_attr_wb_resize_hint.attr,
 	&dev_attr_wb_resize_status.attr,
+	&dev_attr_wb_partial_flush_mode.attr,
+	&dev_attr_wb_max_fifo_size.attr,
+	&dev_attr_wb_cur_fifo_size.attr,
+	&dev_attr_wb_pinned_cur_size.attr,
+	&dev_attr_wb_pinned_avail_pct.attr,
+	&dev_attr_wb_pinned_cumulative_write_size.attr,
+	&dev_attr_wb_pinned_size.attr,
+	&dev_attr_wb_non_pinned_min_size.attr,
 	NULL,
 };
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index b0207e694..49534bb9d 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -151,6 +151,7 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
 	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
 	QUERY_FLAG_IDN_HPB_EN				= 0x12,
+	QUERY_FLAG_IDN_WB_UNPIN_EN			= 0x13,
 };
 
 /* Attribute idn for Query requests */
@@ -196,6 +197,14 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
+	QUERY_ATTR_IDN_WB_PFM			= 0x3F,
+	QUERY_ATTR_IDN_MAX_FIFO_SIZE_WB_PFM	= 0x40,
+	QUERY_ATTR_IDN_CURRENT_FIFO_SIZE_WB_PFM	= 0x41,
+	QUERY_ATTR_IDN_PINNED_WB_CURRENT_SIZE	= 0x42,
+	QUERY_ATTR_IDN_PINNED_WB_AVAIL_PERC	= 0x43,
+	QUERY_ATTR_IDN_PINNED_WB_CUMULATIVE_WS	= 0x44,
+	QUERY_ATTR_IDN_PINNED_WB_SIZE		= 0x45,
+	QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE	= 0x46,
 	QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS        = 0x47,
 	QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS_EXT    = 0x48,
 };
@@ -404,6 +413,16 @@ enum {
 /* Possible values for wExtendedWriteBoosterSupport */
 enum {
 	UFS_DEV_WB_BUF_RESIZE	= BIT(0),
+	UFS_DEV_WB_FIFO_PFM	= BIT(1),
+	UFS_DEV_WB_PINNED_PFM	= BIT(2),
+};
+
+/* Possible values for bWriteBoosterBufferPartialFlushMode */
+enum wb_partial_flush_mode {
+	WB_PARTIAL_FLUSH_NONE		= 0,
+	WB_PARTIAL_FLUSH_FIFO		= 1,
+	WB_PARTIAL_FLUSH_PINNED		= 2,
+	NUM_WB_PARTIAL_FLUSH_MODES	= 3,
 };
 
 /* Possible values for dExtendedUFSFeaturesSupport */
-- 
2.56.0.611.g1030f0b940-goog


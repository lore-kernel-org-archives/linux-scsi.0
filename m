Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899D53B71A3
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 09:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780651898; cv=none; b=XeCZlU1Ksmqe7nNm31kQz+TlN9rykYxSCnGqvXGUHy59IGx+HLJPz7e1BpFsthdmBKJJuBC2q7VQjK9aBj22JMfc43RgrtnZL4LJvQ09L/NnnMYcwaopy2U231KPHLPwssL3qTvculm7IYzrwpPTc6D6DWEnGN0pCOYFPhiwOss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780651898; c=relaxed/simple;
	bh=548iHHcJNN4ql5hf21pc5Ik5KShmA0d7i5yo5rbccJg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=c0SZLFRKWwDi5TSiaXosbcZPd31QUPjNNfc12aejcCghkuTMkS6ehYQKlvNZX4EPvaKhcBcENI8uIUl7qKW7xG2y34yMalAfDwjj4nbiG99wwYRrobdwLPKLD0xsOl/+HC1sTitCYYYrtTHCVbsmLrNiAXZ5xx17ieKjlYt49Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chullee.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O5uV4nxP; arc=none smtp.client-ip=74.125.82.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chullee.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O5uV4nxP"
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-304c652be4eso1601051eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 02:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780651896; x=1781256696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V7vd+OcbPQA8+JjZYx/ukIBUCK2wSTdVCSrXw1osysc=;
        b=O5uV4nxPw/3ULmJSiQijYwEmEmF1Fxug1skqfPny8En6B0kah6pQoBKh1//4Gd64gC
         seJPXuy505Tdjj2axqQfyMWF6bPMH2r7VuXRy/rV5+b/t823oDObdwhwFXIjB0A+PK8Q
         84BjDDkhzqjqttDNf7qZ1i6DjVM4r084Ws6QL428xSz5DOyJ03rufyM3PmfbhSLSkSLz
         C5bC5PrUOmt+e5Q65WagvNqxQ0N3KpCyn81l/waBXn7JOesFFbGqAHSa8xoPI850NnHa
         MCvAVaXRKyRdrgpAxtWm2wuKplxU6wtUirrWaajwyQ1zbOwHYwq9FNgoQ+DOuLgkzMu/
         ZN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780651896; x=1781256696;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V7vd+OcbPQA8+JjZYx/ukIBUCK2wSTdVCSrXw1osysc=;
        b=i7LxaJ+F1xuxv/xkRRP6fYmF7uflrW2Nh8TV04AJ4kxIZJcrvTOqkQAMN/Zz7Am+Wl
         Lb6k1BPUwMhIye3dtkG1gvx/ZbNzoHIZ73Tfk9XKFTMuNWzR7D0H/AcpU8BxXf1BeHX/
         nDB7VqJc4acmHsvNEvdmEtLILMF5vYMqn6exoTH+z1lBjTit6XpkA+2dBCaJsy+yuel9
         oIudppd2kYY0wRx6RYlBqVigiQlIcfCtDchBs3MkQOJ1O0tU79jkxMfxevaockvsQObF
         6k1UOn6LsVBh4k4/y+b9+VraCuwT/qN8posR1nqubbaDNZhGucmjTkuoPaK8ivqXRrz4
         vfBQ==
X-Forwarded-Encrypted: i=1; AFNElJ8R3+2EjZAJ2QVzDl7VsTw0jKJeA7qZwJtTNMHIA53rUFyHL3L48v+IgGAQhlnPv0n0ZezJsyNYG/7N@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf+ojuwmq9n9c6PcmjOAVKavGzDwW9OfTqdlHgF8OVyaZMABHi
	xwq82ggy0N2pCWBSlfKsL2wELvEdygQJNWljAq2xInR+3w2ueKOyZjdqsOd4ju5S5/kVqlc/4nj
	WNI+fa7hBpw==
X-Received: from dlbbs12.prod.google.com ([2002:a05:7022:90c:b0:136:787c:b82c])
 (user=chullee job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:122:b0:12d:c9b6:bbe2
 with SMTP id a92af1059eb24-13807d07321mr624401c88.2.1780651895326; Fri, 05
 Jun 2026 02:31:35 -0700 (PDT)
Date: Fri,  5 Jun 2026 02:31:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <20260605093111.2530863-1-chullee@google.com>
Subject: [PATCH] ufs: sysfs: Add WB partial flush mode support
From: Daniel Lee <chullee@google.com>
To: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org, 
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
 Documentation/ABI/testing/sysfs-driver-ufs |  86 +++++++
 drivers/ufs/core/ufs-sysfs.c               | 258 ++++++++++++++++-----
 include/ufs/ufs.h                          |   9 +
 3 files changed, 290 insertions(+), 63 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index 3c422aac778b..d295c0923e2e 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1791,3 +1791,89 @@ Description:
 		will be rejected.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_partial_flush_mode
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_partial_flush_mode
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry controls Extended WriteBooster partial flush modes.
+
+		======   ==============================
+		0        No partial flush
+		1        FIFO (first-in-first-out) mode
+		2        Pinned mode
+		Others   Reserved
+		======   ==============================
+
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_max_fifo_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_max_fifo_size
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry configures the maximum size in Allocation Units reserved for the
+		WriteBooster FIFO Buffer size.
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_fifo_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_cur_fifo_size
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the current size in Allocation Units of the WriteBooster FIFO
+		Buffer size.
+		The attribute is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_size
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry configures the allocated size in Allocation Units for the UFS
+		Pinned WriteBooster buffer.
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_cur_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_cur_size
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the current allocated size in Allocation Units for the UFS
+		Pinned WriteBooster buffer.
+		The attribute is read-only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_avail_pct
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_avail_pct
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the percentage of available space remaining in the
+		Pinned WriteBooster buffer.
+		The attribute is read-only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_pinned_cumulative_write_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_pinned_cumulative_write_size
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry shows the total cumulative size of data written to the
+		Pinned WriteBooster buffer.
+		The attribute is read-only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_non_pinned_min_size
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_non_pinned_min_size
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry configures the minimum size in Allocation Units for the
+		Non-Pinned WriteBooster Buffer area when Pinned partial flush mode is active.
+		The attribute is read-write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_unpin_enable
+What:		/sys/bus/platform/devices/*.ufs/flags/wb_unpin_enable
+Date:		June 2026
+Contact:	Daniel Lee <chullee@google.com>
+Description:	This entry controls the Pinned WriteBooster unpin enable flag (fUnpinEn).
+
+		======   ==============================================================
+		0        Unpin Disable: pinned data is not flushed by WriteBooster
+		         Buffer flush operation.
+		1        Unpin Enable: pinned data is flushed by WriteBooster
+		         Buffer flush operation.
+		======   ==============================================================
+
+		The attribute is read-write.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index d9dc4cc3452e..b981fbeda192 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1527,41 +1527,98 @@ static const struct attribute_group ufs_sysfs_string_descriptors_group = {
 
 static inline bool ufshcd_is_wb_flags(enum flag_idn idn)
 {
-	return idn >= QUERY_FLAG_IDN_WB_EN &&
-		idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8;
+	return (idn >= QUERY_FLAG_IDN_WB_EN &&
+		idn <= QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8) ||
+	       idn == QUERY_FLAG_IDN_WB_UNPIN_EN;
+}
+
+static ssize_t ufs_sysfs_flag_show(struct device *dev,
+	struct device_attribute *attr, char *buf, enum flag_idn idn)
+{
+	bool flag;
+	u8 index = 0;
+	int ret;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
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
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
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
+	bool value;
+	u8 index = 0;
+	int ret;
+	struct ufs_hba *hba = dev_get_drvdata(dev);
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
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
+out:
+	up(&hba->host_sem);
+	return ret ? ret : count;
 }
 
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
+
 UFS_FLAG(device_init, _FDEVICEINIT);
 UFS_FLAG(permanent_wpe, _PERMANENT_WPE);
 UFS_FLAG(power_on_wpe, _PWR_ON_WPE);
@@ -1573,6 +1630,7 @@ UFS_FLAG(disable_fw_update, _PERMANENTLY_DISABLE_FW_UPDATE);
 UFS_FLAG(wb_enable, _WB_EN);
 UFS_FLAG(wb_flush_en, _WB_BUFF_FLUSH_EN);
 UFS_FLAG(wb_flush_during_h8, _WB_BUFF_FLUSH_DURING_HIBERN8);
+UFS_FLAG_RW(wb_unpin_enable, _WB_UNPIN_EN);
 
 static struct attribute *ufs_sysfs_device_flags[] = {
 	&dev_attr_device_init.attr,
@@ -1586,6 +1644,7 @@ static struct attribute *ufs_sysfs_device_flags[] = {
 	&dev_attr_wb_enable.attr,
 	&dev_attr_wb_flush_en.attr,
 	&dev_attr_wb_flush_during_h8.attr,
+	&dev_attr_wb_unpin_enable.attr,
 	NULL,
 };
 
@@ -1671,10 +1730,14 @@ static DEVICE_ATTR_RW(max_number_of_rtt);
 
 static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 {
-	return idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
-		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
+	return (idn >= QUERY_ATTR_IDN_WB_FLUSH_STATUS &&
+		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE) ||
+	       (idn >= QUERY_ATTR_IDN_WB_PFM &&
+		idn <= QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE);
 }
 
+
+
 static inline bool ufshcd_is_qword_attr(enum attr_idn idn)
 {
 	return idn == QUERY_ATTR_IDN_TIMESTAMP ||
@@ -1742,48 +1805,101 @@ static ssize_t wb_resize_status_show(struct device *dev,
 
 static DEVICE_ATTR_RO(wb_resize_status);
 
+static ssize_t ufs_sysfs_attr_show(struct device *dev,
+	struct device_attribute *attr, char *buf, enum attr_idn idn)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u64 qword_value;
+	u32 value;
+	int ret;
+	u8 index = 0;
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
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
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
+	u32 value;
+	int ret;
+	u8 index = 0;
+
+	if (kstrtou32(buf, 0, &value))
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+	if (ufshcd_is_wb_attrs(idn))
+		index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		idn, index, 0, &value);
+	ufshcd_rpm_put_sync(hba);
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
+out:
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
+
 UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
 UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
 UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
@@ -1803,6 +1919,14 @@ UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
 UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
 UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
 UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
+UFS_ATTRIBUTE_RW(wb_partial_flush_mode, _WB_PFM);
+UFS_ATTRIBUTE_RW(wb_max_fifo_size, _MAX_FIFO_SIZE_WB_PFM);
+UFS_ATTRIBUTE(wb_cur_fifo_size, _CURRENT_FIFO_SIZE_WB_PFM);
+UFS_ATTRIBUTE(wb_pinned_cur_size, _PINNED_WB_CURRENT_SIZE);
+UFS_ATTRIBUTE(wb_pinned_avail_pct, _PINNED_WB_AVAIL_PERC);
+UFS_ATTRIBUTE(wb_pinned_cumulative_write_size, _PINNED_WB_CUMMULATIVE_WS);
+UFS_ATTRIBUTE_RW(wb_pinned_size, _PINNED_WB_SIZE);
+UFS_ATTRIBUTE_RW(wb_non_pinned_min_size, _NON_PINNED_WB_MIN_SIZE);
 
 
 static struct attribute *ufs_sysfs_attributes[] = {
@@ -1828,6 +1952,14 @@ static struct attribute *ufs_sysfs_attributes[] = {
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
index 0d48e137d66d..2d9455b7cd88 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -146,6 +146,7 @@ enum flag_idn {
 	QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8     = 0x10,
 	QUERY_FLAG_IDN_HPB_RESET                        = 0x11,
 	QUERY_FLAG_IDN_HPB_EN				= 0x12,
+	QUERY_FLAG_IDN_WB_UNPIN_EN			= 0x13,
 };
 
 /* Attribute idn for Query requests */
@@ -191,6 +192,14 @@ enum attr_idn {
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
 	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
+	QUERY_ATTR_IDN_WB_PFM			= 0x3F,
+	QUERY_ATTR_IDN_MAX_FIFO_SIZE_WB_PFM	= 0x40,
+	QUERY_ATTR_IDN_CURRENT_FIFO_SIZE_WB_PFM	= 0x41,
+	QUERY_ATTR_IDN_PINNED_WB_CURRENT_SIZE	= 0x42,
+	QUERY_ATTR_IDN_PINNED_WB_AVAIL_PERC	= 0x43,
+	QUERY_ATTR_IDN_PINNED_WB_CUMMULATIVE_WS	= 0x44,
+	QUERY_ATTR_IDN_PINNED_WB_SIZE		= 0x45,
+	QUERY_ATTR_IDN_NON_PINNED_WB_MIN_SIZE	= 0x46,
 	QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS        = 0x47,
 	QUERY_ATTR_IDN_TX_EQ_GN_SETTINGS_EXT    = 0x48,
 };
-- 
2.54.0.1032.g2f8565e1d1-goog


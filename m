Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892095;
	b=nfeozys/efM1b/opa5RjyTCEMGDtgiVHd6kwNF4PDhrlGtwFPg+NRODkJ9SJJfEowVRx
	 BWSvwojaDQfkCEJ4MY93ZwY7k4wILI9bWD9oIbPn+TdAvMZhV6RJ/qqKN/DeqK9S9wcK4
	 sKVM2AXyyuW6DZnYK9wA8c5fk31h4+MpVj/RGzRfIbqAyNTLnjZurGBRN+KUogPPiTyAR
	 p/QE1viZSwcS6CQ1Ag9dX/9nawhVy/ZxqlF6sUVOal3r+VEHz2daMEqRKLhfkuUvaDIFQ
	 IRbwMQHn/EHY9GYhywqmlXJ1PwMAp6e61Q9aZb7U1xsVdefoR2jDjEEZMPjFAxbhVsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892095;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=d8zTOCpdfLCFup0LtTUT8GHUquWtW5OhPtS3dNMqHJw=;
	b=pJS42yVKYEWpvOy8sU2ZO0gb9n2r8ZefCp9q1HkEmQaJcDq/KiuzH+pxD5XfZPC4AoXr
	 L54ARf8sTJPCeaFAhGrRPMfbiq6xKmzAz9rGMf7MSv1xAq+p8hD0KGQalRV5Gv8sv6INw
	 MDyPsIVYXAfuMRPkkdtIp+o+AFxkdyhfOZRwEcNK9E+g4B/JahDmaXcWcPeXihu8o6lNx
	 /hpBdB8mGmFq8SfJJX5Wo/7cWsq63oGFK8YFi0BYGmarlpy6A3ynk7N8AYgv99OCPr5dX
	 jx/CN1+86C8x6ACGiCNcYQ74KtIc0wroPEl5Q772GpNri3HyrMNsu71R1lE/dGq/EIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=INVTu4vU;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB55606A321
	for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 01:34:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAB55606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=INVTu4vU
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-89fb6a45c48so1939970b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 18:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792892094; x=1793496894; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d8zTOCpdfLCFup0LtTUT8GHUquWtW5OhPtS3dNMqHJw=;
        b=INVTu4vUwpEyC7ZtxvJsKVU2+nOgKLbSmZQV5fHfLi1+JJ898E1aLK08xff6wcILew
         LSG5Nk78eLrG9Y1U1tpmffPRoP1gn9jCLfbXSA0sMUN/r6Yzm1+pZyvghn3Vj2IIkzIY
         JgT5Y1kG1vcwJgXPaKd5+3cYPLiIBWsZ6fNFtHZtbMiWuKlQiVB2o2LXJ1HNlj0BmVsm
         ejI6O0J2ETi9brA+6Bf3P7RCRBJRcPhdzwkQ295uNPiJBrGd0Hzu39yZ2v3FNO/Mhc4O
         MVnCVqHltB160meoyBF8A0z8uTl8lnlx4mL/523peD9igjcf18omkXV2CoNFnFXIr8qg
         sr8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892094; x=1793496894;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d8zTOCpdfLCFup0LtTUT8GHUquWtW5OhPtS3dNMqHJw=;
        b=tvrv4K5LpnaDBnKHuCOGx/IPKHVolSdLdFCZ3531XORA88qCi9OX4lDkXaQkhcDrQk
         ODiDyy+pWZN++OxXC7OD9JXEAEAGT1W0+yofZ54URGuIkYykQe86c2zPN8CY+j+U/XBO
         8wI+4j30lmKvC5qWfihT8ujyCoPAZtP9mAMFdm8nIrAqOBW3g0bMOyG4WC7cXaAgYxIv
         K/WRjSAdb9g0Mfa+tsNQ5ElOzx+o80NcJEYwyXMW8EghFFdRlABJdXND5hzd61rCkIVv
         gT9sO56TBCaFxLJjllOFpzc/AWk5h6+VIsiGdlCkk0gGV0FVyHF3oz5vmbtTUbMtIn/7
         VMwQ==
X-Forwarded-Encrypted: i=1; AKwUvBziL2MSI5rKAq51ayjn5KFmC++/3vH4ZbtnAYO1Y3pNpmwgEUTU+Vu/tbD4W9dpTcZabWBIlavmQ8IB@vger.kernel.org
X-Gm-Message-State: AFq9FYLpMJ94dMm3aVwCYWgn0otE/iGnhxakd8t6v1pdxbgsPG+0twep
	Yx1L8v5xwIsLuyU4vkk324Nk9MPunkTxIja0NCoUkBWrck4jpnlGrYgX0af1ZM7uW0kr9Zd2fIa
	KycRF8UwQ2aKpQBr5deTpow==
X-Received: from pjblj15.prod.google.com ([2002:a17:90b:344f:b0:3a4:fb9f:4a65])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ac9:b0:3a7:db88:3491 with SMTP id 98e67ed59e1d1-3adeabe4324mr2618939a91.33.1792892093846;
 Sat, 24 Oct 2026 18:34:53 -0700 (PDT)
Date: Sun, 25 Oct 2026 09:34:44 +0800
In-Reply-To: <20261025013446.345974-1-stanleyjhu@google.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261025013446.345974-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261025013446.345974-4-stanleyjhu@google.com>
Subject: [PATCH 3/5] scsi: ufs: sysfs: Propagate runtime PM resume errors
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

All 14 ufshcd_rpm_get_sync() callers in ufs-sysfs.c ignore its return
value:

1. A user-space sysfs read or write runs when W-LUN runtime resume
   fails, when power.runtime_error is set from a failed runtime
   suspend, or when W-LUN runtime PM is disabled while not active.
2. ufshcd_rpm_get_sync() returns a negative errno without waking the
   device or host controller.
3. ufshcd_read_hci_reg() reads an HCI MMIO register on an unresumed
   controller, and the remaining handlers issue query UPIUs over a
   suspended or broken link.

Switch all 14 sysfs callers to ufshcd_rpm_resume_and_get() and return
the error after releasing any held buffer and hba->host_sem.

Fixes: aef80fd1da32 ("scsi: ufs: sysfs: Resume the proper SCSI device")
Fixes: b9d104465a6c ("scsi: ufs: Prepare to add HCI capabilities sysfs")
Fixes: 600edc6620a4 ("scsi: ufs: sysfs: Make max_number_of_rtt read-write")
Fixes: 6c4148ce7cc1 ("scsi: ufs: wb: Add explicit flush sysfs attribute")
Fixes: 500d4b742e0c ("scsi: ufs: core: Add WB buffer resize support")
Fixes: ae7795a8c258 ("scsi: ufs: core: Add HID support")
Fixes: 1fd2e77b8897 ("scsi: ufs: core: Add device level exception support")
Cc: stable@vger.kernel.org # needs "scsi: ufs: core: Introduce ufshcd_rpm_resume_and_get() helper"
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufs-sysfs.c | 67 ++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 14 deletions(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index cf49ad0258e1..19b62cf52410 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -250,13 +250,19 @@ EXPORT_SYMBOL_GPL(ufshcd_us_to_ahit);
 
 static int ufshcd_read_hci_reg(struct ufs_hba *hba, u32 *val, unsigned int reg)
 {
+	int ret;
+
 	down(&hba->host_sem);
 	if (!ufshcd_is_user_access_allowed(hba)) {
 		up(&hba->host_sem);
 		return -EBUSY;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret) {
+		up(&hba->host_sem);
+		return ret;
+	}
 	ufshcd_hold(hba);
 	*val = ufshcd_readl(hba, reg);
 	ufshcd_release(hba);
@@ -350,7 +356,9 @@ static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
 		goto out;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_rpm_resume_and_get(hba);
+	if (res)
+		goto out;
 	res = ufshcd_wb_toggle(hba, wb_enable);
 	ufshcd_rpm_put_sync(hba);
 out:
@@ -421,7 +429,9 @@ static ssize_t enable_wb_buf_flush_store(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_rpm_resume_and_get(hba);
+	if (res)
+		goto out;
 	res = ufshcd_wb_toggle_buf_flush(hba, enable_wb_buf_flush);
 	ufshcd_rpm_put_sync(hba);
 
@@ -490,7 +500,9 @@ static ssize_t wb_resize_enable_store(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_rpm_resume_and_get(hba);
+	if (res)
+		goto out;
 	res = ufshcd_wb_set_resize_en(hba, mode);
 	ufshcd_rpm_put_sync(hba);
 
@@ -598,7 +610,9 @@ static ssize_t device_lvl_exception_id_show(struct device *dev,
 	if (hba->dev_info.wspecversion < 0x410)
 		return -EOPNOTSUPP;
 
-	ufshcd_rpm_get_sync(hba);
+	err = ufshcd_rpm_resume_and_get(hba);
+	if (err)
+		return err;
 	err = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 				      QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID,
 				      0, 0, &exception_id);
@@ -1101,7 +1115,9 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
 				param_offset, desc_buf, param_size);
 	ufshcd_rpm_put_sync(hba);
@@ -1482,7 +1498,12 @@ static ssize_t _name##_show(struct device *dev,				\
 		up(&hba->host_sem);					\
 		return -ENOMEM;						\
 	}								\
-	ufshcd_rpm_get_sync(hba);					\
+	ret = ufshcd_rpm_resume_and_get(hba);				\
+	if (ret) {							\
+		kfree(desc_buf);					\
+		up(&hba->host_sem);					\
+		return ret;						\
+	}								\
 	ret = ufshcd_query_descriptor_retry(hba,			\
 		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
 		0, 0, desc_buf, &desc_len);				\
@@ -1548,7 +1569,9 @@ static ssize_t _name##_show(struct device *dev,				\
 	}								\
 	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
+	ret = ufshcd_rpm_resume_and_get(hba);				\
+	if (ret)							\
+		goto out;						\
 	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
 		QUERY_FLAG_IDN##_uname, index, &flag);			\
 	ufshcd_rpm_put_sync(hba);					\
@@ -1608,7 +1631,9 @@ static ssize_t max_number_of_rtt_show(struct device *dev,
 		return -EBUSY;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
 	ufshcd_rpm_put_sync(hba);
@@ -1648,7 +1673,9 @@ static ssize_t max_number_of_rtt_store(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 
 	memflags = memalloc_noio_save();
 	shost_for_each_device(sdev, hba->host)
@@ -1700,7 +1727,11 @@ static int wb_read_resize_attrs(struct ufs_hba *hba,
 	}
 
 	index = ufshcd_wb_get_query_index(hba);
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret) {
+		up(&hba->host_sem);
+		return ret;
+	}
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 			idn, index, 0, attr_val);
 	ufshcd_rpm_put_sync(hba);
@@ -1760,7 +1791,9 @@ static ssize_t _name##_show(struct device *dev,				\
 	}								\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
-	ufshcd_rpm_get_sync(hba);					\
+	ret = ufshcd_rpm_resume_and_get(hba);				\
+	if (ret)							\
+		goto out;						\
 	if (ufshcd_is_qword_attr(QUERY_ATTR_IDN##_uname))		\
 		ret = ufshcd_query_attr_qword(hba,			\
 			UPIU_QUERY_OPCODE_READ_ATTR,			\
@@ -1848,7 +1881,11 @@ static int hid_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 		return -EBUSY;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret) {
+		up(&hba->host_sem);
+		return ret;
+	}
 	ret = ufshcd_query_attr(hba, opcode, idn, 0, 0, attr_val);
 	ufshcd_rpm_put_sync(hba);
 
@@ -2121,7 +2158,9 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 		goto out;
 	}
 
-	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_rpm_resume_and_get(hba);
+	if (ret)
+		goto out;
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
 	ufshcd_rpm_put_sync(hba);
-- 
2.56.0.307.g5fe7bd680c-goog


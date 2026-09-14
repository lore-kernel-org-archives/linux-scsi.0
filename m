Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9985F480342
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405276; cv=none; b=sBcq4XkoNmcv34F+W5EidcV4nwFxPi6DMR2YWCZeWiRBSxG3V1iVJu6MYoko5r+pHGY28ea7LbueCsG2p4bPbvUwrFSfeS4f1JDIe91L2AJ8ylfFpzZaRe7DG7fv0U/2czbBZnpdJj3xcFMtxvqDl/G+SuwSUBLaEXC/OQpMBac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405276; c=relaxed/simple;
	bh=Pot7DABfZWAOQTpBXu0snDAhzCjg/cAOCKbAulbbLsU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PohgNI7qFoJ4s8mV5oa73heIXA1ELmj5Z5UCYOvI33NUdbQZD/vDmJNZq/H7+KX3twy9zJIHbftTY6ilX9je8UUzjAf8N/Q6IDcliitrPNuOYa860GMojMCNIYRQDdFw3K5fwc/B9mO4ehkKEBqQpVIND4/zeMmszyaovX1IntM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qStXK1QI; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qStXK1QI"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469b355ffso1345388b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 10:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789405274; x=1790010074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZ6LaPqlluWao8QrsL/nHA0PTVbB1kV2rtj0zeEKu7I=;
        b=qStXK1QIHnN10OOkH7n3GQy9D6DvspdyX7oRVF6u4X11QeS+kYKpexY3bdYEIAkL1R
         /hryec7k7mWjJ0p/v6jaRhTqhJ6jGITvcVaTUmwWb1wLEtuJ5zNQoTNib5AeA97OV8MB
         lBflMb10rlkdtiwvpv6SBuwUYOv2G4R3tKZjA9/T/4EXZY70MVs5/TOiIBHjavBYYhK+
         z9FrUfKpHn2OJEqsAIN59Gp8JXeQCSlCBbYq6YOLU+yQF77QEhurXbPSMuT136NOqKqb
         KPtrqxkVhoCv9M1n+rDgzInzc0Hv8VCYuXBdqWCxLsOVwzWzASagx/F+LMt4JPWvAhRc
         X9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789405274; x=1790010074;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JZ6LaPqlluWao8QrsL/nHA0PTVbB1kV2rtj0zeEKu7I=;
        b=jMIsa79t96GSdvbssfdoFAzmOEt1zezGJ6bLi4rQHJNaBfmhw9wqPy0hUPpJxpx4ld
         ntNi8PhlNtHn/pWY1f/MrbTj4wgmktYteGQTpsFkMEcgOmmQJ7jg9lopHPoWGm/GNZBB
         +PyNLFjpVcSIuJgljP84kzzHWGMJDeSPl7b0ifqyEn36Z714orVbzr2V6a8RBrEiBIRb
         gydlOnjV9b5og4fU7GMzFQYR8ii3xlsJrPLoWAA1hw1OGUfzQLdTj8UfRSsqW36yoce9
         Mlin/V0vs6K1mW4utSt8b4rON3Z5r3JdlV7QZ0MEQXJWhP0BhrH2H2779+3pc2DyUAAY
         /ZqQ==
X-Gm-Message-State: AFuF++lkwmeNxYD5euadurvZr/woaz6XTgsSQexLf6yHum/BAEpA+lxs
	7YDlUTRkpJlFPIWRTFAl5KTxFu+eB4LKb3tbpvU1wB4IOWsOOFaFSnyG
X-Gm-Gg: AYBFou0ODRsX/OPbVnKSbx6CU0TMC2ZxhfNlQ2XGQo6XE/c6OViNcBbrVspl0zV/5A3
	UwoHRtgYfKbbJoOsFhAzmhyIKCADa1T3P6HHvJgh7VyXS2JTkyIxrIeNvPTUyq9CKmAjqOcFvig
	CGvW30fXRzW5gQ3fNSHUue1FkGz0jstTmJ8KReSDqHRm69g5ceRRKAo4ZOT92rceiy8R68TGDib
	FXYGXmzSvmlONw1gWp8YKX86yFkTTw4L12+vJXeH/TgKYWCGC0g1i9Na0DO5HZlzcoOxxMjmqho
	cjxozdbtrXoxWcDScitnuHDat29FvvCqSLAYfy4OAKwpE0valcmrvXPhz1t0nV0RIo/Hz5saARL
	w0KP97yNFjl8ryU3LhPJ2kNZtvMlwvM2ZgX7J53H6TmDWvjVg7NEHp1quIzzdklpDcVYjDAk1XV
	RG0NBp/FYyQVNwQ8HWeikdYLiLSerh/Mc9hZBYpMSGkUXTncy6G38whLtBoR3vROf5v0yMgcJ99
	mlIWVX0FAhLn/e17VzvrUtvKQ1GZWWEbZS48z/cmy+Yq8P/J/AAqzZZ4V1GADL5TwbxSqpCyhxw
	eEmz9pbG7CvziutTKotgC1dFslxHSQ8=
X-Received: by 2002:a05:6a00:22d4:b0:86c:b39b:66f1 with SMTP id d2e1a72fcca58-86f84d108d0mr6528117b3a.17.1789405261791;
        Mon, 14 Sep 2026 10:01:01 -0700 (PDT)
Received: from NV-9MNJ414.tailae2068.ts.net (2001-b011-2005-787e-1dca-bd0c-04f0-d1fc.dynamic-ip6.hinet.net. [2001:b011:2005:787e:1dca:bd0c:4f0:d1fc])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28ec93b6sm5039090b3a.24.2026.09.14.10.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 10:01:01 -0700 (PDT)
From: Yiwei Lin <s921975628@gmail.com>
To: alim.akhtar@samsung.com,
	avri.altman@sandisk.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiwei Lin <s921975628@gmail.com>
Subject: [PATCH] ufs: sysfs: fix current_power_mode read without SSU
Date: Tue, 15 Sep 2026 01:00:32 +0800
Message-Id: <20260914170032.5551-1-s921975628@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

current_power_mode was generated by UFS_ATTRIBUTE(), which calls
ufshcd_rpm_get_sync() before issuing the query.

That resumes the UFS device WLUN, and ufshcd_wl_runtime_resume() sends
START STOP UNIT to bring the device back to Active. As a result
bCurrentPowerMode always read back as 0x11 (Active) no matter what
state the device was actually in. Sleep could never be observed through
sysfs.

Per the UFS spec, bCurrentPowerMode is the one attribute the device
must answer in any power mode, so there is no need to wake it.

Tested on hardware: with the device runtime-suspended, reading
current_power_mode used to return 0x11; after this change it returns
0x22 (Sleep), matching the device's real state.

Assisted-by: LLM
Signed-off-by: Yiwei Lin <s921975628@gmail.com>
---
 drivers/ufs/core/ufs-sysfs.c | 59 +++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 63e670d1a9d9e..36cffd535ab7d 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1786,7 +1786,64 @@ out:									\
 static DEVICE_ATTR_RO(_name)
 
 UFS_ATTRIBUTE(boot_lun_enabled, _BOOT_LU_EN);
-UFS_ATTRIBUTE(current_power_mode, _POWER_MODE);
+
+/*
+ * Per UFS spec, bCurrentPowerMode is the only attribute the device must
+ * respond to in any power mode.  Read it without waking the device to
+ * Active: restore HBA clocks via pm_runtime_get_sync(hba->dev) only
+ * (avoids triggering ufshcd_wl_runtime_resume and its START STOP UNIT),
+ * exit Hibern8 if needed so the link can carry the UPIU, then query.
+ */
+static ssize_t current_power_mode_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	u32 value;
+	int ret;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	ret = pm_runtime_get_sync(hba->dev);
+	if (ret < 0) {
+		pr_warn("%s: pm_runtime_get_sync failed %d\n", __func__, ret);
+		pm_runtime_put_noidle(hba->dev);
+		up(&hba->host_sem);
+		return ret;
+	}
+	ret = 0;
+
+	ufshcd_hold(hba);
+
+	if (ufshcd_is_link_hibern8(hba)) {
+		ret = ufshcd_uic_hibern8_exit(hba);
+		if (!ret)
+			ufshcd_set_link_active(hba);
+		else
+			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+				__func__, ret);
+	}
+
+	if (!ret)
+		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			QUERY_ATTR_IDN_POWER_MODE, 0, 0, &value);
+
+	ufshcd_release(hba);
+	pm_runtime_put(hba->dev);
+
+	if (ret) {
+		up(&hba->host_sem);
+		return -EINVAL;
+	}
+	ret = sysfs_emit(buf, "0x%08X\n", value);
+	up(&hba->host_sem);
+	return ret;
+}
+static DEVICE_ATTR_RO(current_power_mode);
+
 UFS_ATTRIBUTE(active_icc_level, _ACTIVE_ICC_LVL);
 UFS_ATTRIBUTE(ooo_data_enabled, _OOO_DATA_EN);
 UFS_ATTRIBUTE(bkops_status, _BKOPS_STATUS);
-- 
2.34.1


Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1135E3E63A3
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094607; cv=none; b=d3CsJw3CxgeAtJ4PEnM73aSETqct7r5DBx+oGpO4qaFgHfBW+2gSHSCJqVN618k+bgm3yikXAchDuUs7/DfnJLz6NGjigxvqfok9RizKbtTxM4P6jr3qxAB/TRp0iwo454zfkXwLECriAtBh2qMgBERE7anVgxVW4uBh2GZRimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094607; c=relaxed/simple;
	bh=SE5RaLn3Dzf2vFzZ+yhriAZI3DsHt9x+u8rqlBaLDPQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uIbic9VeiEv4ETktH01OL79q53pCKoTpBycN3c6APNcpkOoiAc9KU8sQEhsUhmsADRp/6loqCNbHKs2pFqN87S9i/1mafCzXd9+XJvUDrD3lpXw32HbexBRO+zL3fnQ1C1nsV750fqjf3ZgPy68Gy6cYGLkL0GXcFOqdEUa5ri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pXBvgsIW; arc=none smtp.client-ip=209.85.216.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pXBvgsIW"
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-396b9ef3070so715141a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 19:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789094605; x=1789699405; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mq94d3vXnQQDg8NO9kMY4Qofd5oIq09gpYbdjVFAs2k=;
        b=pXBvgsIWe9xr+KPNPSaIzw0w11ppsgqpn6V+2qCCvjKxfBju8JahySGrHRf1Qk5ary
         BWkXL6NZLV+C44I8o37tNL+3g+fwbdbDko7agSQNjJqn2vH1a9r+w7gal8GZ66q8myJ1
         mfV3GmXgNNoeSBqymeuyllD2QGnprES58ct7cR3/0SQzyzA4OftNkzzKlh+K877w4e2V
         w4hJigax9X+XrlFq8C88eTPDLkO05rrJMcD/U3qeO6GotesymGEMhpJr9Amg6GdSuZ9f
         e+dyfnd09Xmae+VXXa3+ymOjsscD2ktdJKDPYyU68E6WCsY0klco9Pg+KGiieiYGQp8L
         n7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789094605; x=1789699405;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mq94d3vXnQQDg8NO9kMY4Qofd5oIq09gpYbdjVFAs2k=;
        b=HE95jhqgP9A9P9FS13p5K3pFSJLtoob6Vozs1B8R3W2/HJGUezMk+vBf9Fb2SWtdfJ
         9nYDD5x0VRxG9cA1oGlVTjFXOV5hysifDJndhDMTZTmS1B0tDf/PojZup4jwHA0ulYiI
         gznynVtoQ5HShSJAnuiz3Gofhc51mtPsRHaxx9zAu/BNwu6vMmnchhGeKVZxZLXdll1B
         C0CuD/7Oftbj2wro5+AUKcmk+iJ/9scZGJtnL0Sll1eVPzoSvxNi5jQ6FhSveDjoD9A+
         feJf37K9fFpSB40ct29wRgNNftWYWt89nzHUDagUxxhq9ascJChIl7RUTyW/tywrbNX3
         lmow==
X-Gm-Message-State: AFuF++n7y3F3c3neFFXKBjlGC04bHiNJD9bUwu7RJkmZsaYkAuL1RTQ3
	DQ/1FeuSGPbraH9qPA/B1GT9b7nrDexJPQNKRQCLr7NBC/h69L+cy2CF1K4x9LuDuy1F6JjNF6Z
	9Qhn9kaXspnLeVkw8hLKUiA==
X-Received: from pjrx15.prod.google.com ([2002:a17:90a:bc8f:b0:39d:9869:f742])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d2cb:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-39d9c234851mr2889048a91.14.1789094605291;
 Thu, 10 Sep 2026 19:43:25 -0700 (PDT)
Date: Fri, 11 Sep 2026 10:43:19 +0800
In-Reply-To: <20260911024319.1346706-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260911024319.1346706-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911024319.1346706-3-stanleyjhu@google.com>
Subject: [PATCH 2/2] scsi: ufs: core: Dynamically disable timestamp on
 unsupported devices
From: Stanley Jhu <stanleyjhu@google.com>
To: mkp@kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bvanassche@acm.org, avri.altman@sandisk.com, alim.akhtar@samsung.com, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

JEDEC JESD220F specifies that the Timestamp attribute (qTimestamp) is
an optional feature for UFS devices. Some compliant UFS 4.0 devices do
not implement it and return QUERY_RESULT_INVALID_IDN (0xFD).

ufshcd_set_timestamp_attr() gates the write on wspecversion >= 0x400
and the absence of UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT. Neither
covers a device that advertises UFS 4.0 but declines the attribute, so
the write is reissued on every boot and every resume.

Record the capability in struct ufs_dev_info and clear it when the
device answers -EOPNOTSUPP, so the write is not retried. -ETIMEDOUT
and -EIO still reach dev_err(); they are transient and must not
disable the attribute.

Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 10 +++++++---
 include/ufs/ufs.h         |  1 +
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f01703c3825f..1964d0a23c17 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8962,6 +8962,9 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	ufs_fixup_device_setup(hba);
 
+	dev_info->timestamp_sup = dev_info->wspecversion >= 0x400 &&
+		!(hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT);
+
 	ufshcd_wb_probe(hba, desc_buf);
 
 	ufshcd_temp_notif_probe(hba, desc_buf);
@@ -9262,14 +9265,15 @@ static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
 	u64 ts_ns;
 	int err;
 
-	if (dev_info->wspecversion < 0x400 ||
-	    hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT)
+	if (!dev_info->timestamp_sup)
 		return;
 
 	ts_ns = ktime_get_real_ns();
 	err = ufshcd_query_attr_qword(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
 				      QUERY_ATTR_IDN_TIMESTAMP, 0, 0, &ts_ns);
-	if (err)
+	if (err == -EOPNOTSUPP)
+		dev_info->timestamp_sup = false;
+	else if (err)
 		dev_err(hba->dev, "%s: failed to set timestamp %d\n",
 			__func__, err);
 }
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index afbb32654fab..b0207e694911 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -662,6 +662,7 @@ struct ufs_dev_info {
 	u8 rtt_cap; /* bDeviceRTTCap */
 
 	bool hid_sup;
+	bool timestamp_sup;
 
 	/* Unique device ID string (manufacturer+model+serial+version+date) */
 	char *device_id;
-- 
2.55.0.1007.g17ff1f9808-goog


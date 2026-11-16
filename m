Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836372;
	b=Y1xMo5lPlrTqXb4qltlxscZVTiBzZuB3YZ4scGtote8iBQoJaypdncxNuTjj+c/tDY0f
	 fw+dmcvTG8nwEZUjt3JhgGF85altWTrdErqmwX3GAqwn0SlHfPYssjySpLTifqNPtfmYM
	 zXzbXv7lUMPjFBSpTaHfrWQHR+hALLZqlJck7cPXEJrK5AeZy4009+SXcssGoLITjRaKy
	 GeQCmfQ8k8fHS3nkl8CnysufxOKsjSZuScekVZbjqhSKuaCV+OopFWcX1ei8giTkSUTZU
	 UAQ5K8dBEPBYyYt5b24SfFNm7Lf2nAG2dmcm2NL7fhAOlSaIRkphNGfxSfG9xRJiQng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836372;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=OmxDzzpyB6E7CRRo9uqBsBEYLzdun/syuP5owNmqoic=;
	b=Om4/Gv+Xtdy5WMoD07aXdSTqI9cdNzzQ4dMBUQIwL8P8a2P0mfRCD5PSoodHkKPSTzu4
	 MxOTuFbOBuVwqEXGcwU0ZHb1fHEPAdHeqFcsYaPU0BXKOQntwGPZ3kRRLjwJZCoLyeYuV
	 eg03fe0Jdyi8Evj/NDPMriW9qXfy3ON5NdMpZakIGRpJynJVVmoaLar0g8Cj0jWUnofwa
	 HKu1s9FT9ZH/8tVJ/Y3Geb21WP6l+JatZgmrv35zftQld3xBdb1mn4WBl0snOuaoFZKOF
	 tO/mA4kWMzFobgx1+4tHFiTq6itLNib5cGGPh08Pb6OSLIskb635C2EMtwCJK9lk9uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BYpKIPCh;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BTztOGsX;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88910606A32F
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 13:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88910606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BYpKIPCh;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=BTztOGsX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794836370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OmxDzzpyB6E7CRRo9uqBsBEYLzdun/syuP5owNmqoic=;
	b=BYpKIPCh5mQo7Oxt3SWQPjiwnWCX4BIyQ2h8hzEDj5GELns+J/hdR4KMYxz5yDYOAxywBZ
	it2XfH27V7RL8h8NB/hdslPRgq7g3mLUbdjhjHs7GOJKIeOfOw7ZH/9bEiICNrYwf5WEbQ
	rcetHrxDe0LemlOmbLJBj5X5hszjMk8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-QQKUOvmUPyezttCZKngtBw-1; Mon, 16 Nov 2026 08:39:29 -0500
X-MC-Unique: QQKUOvmUPyezttCZKngtBw-1
X-Mimecast-MFC-AGG-ID: QQKUOvmUPyezttCZKngtBw_1794836368
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-490c1867490so126947f8f.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 05:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794836368; x=1795441168; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OmxDzzpyB6E7CRRo9uqBsBEYLzdun/syuP5owNmqoic=;
        b=BTztOGsXfFaxP6szTNQUmPZqJpbz4tLw1JZ0v49qQkNddLZ7YkaGedwBdvhDs7sz7g
         hhVyU/Yw8nKkFe7ty/H8NJnzEEso0ZZA7TnFPqPCW5LkQcxIYXzb9GOpdyt+/wyXEJ9X
         Jx9+gmBW+vvYv092nw0KPrUviySFdWNcfVExo9cX/GlNvyvmeZvbC00LyJwU6xnHuP6+
         mob1qrdiCMohkI9/hfo2CcBVVM6blQ8zSpZi/qNMYBKGfoQDtfDC3QoiqYaIBvkAUDf6
         Kwhz3mEw7CftNcmj4YGLHtiAYDMhTb0A8ZUNslciFEumhXXPUC5dzdEtU0mI+8I2DRKC
         Nd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794836368; x=1795441168;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OmxDzzpyB6E7CRRo9uqBsBEYLzdun/syuP5owNmqoic=;
        b=QWkLO9Vsz5akN7d4DZ1cqP6w8LDwgabPiFo7I3/u4oZugpO5Og2IZLo1DaySOeFNpQ
         FYjIi2soeG4IFJfuizB+2QdafXDoPwYaNWtfgyIaOUyAcrDQnCEwC/WPpvc4hoTP2MGF
         Mru3wRjBBhL5+9t3kMUDFis8VH3OiJUGRI210dssv6huRVn+lEDSYqw0nUGc8F1a6xf6
         Uem0h1O+RWO2nXVPemMe22ArBE5yl3Y3gsNb9VvHPOd/ej8W+TtUJeKfDCtrbOHy+BWO
         Hyz6Q1j0e0h1bmC3ttqpDFG++zCOShrXxX+k27G9kI51zJpeAOKwkJ4+LcHU/rUP9pSp
         S1jw==
X-Forwarded-Encrypted: i=1; AL+hErGh+zzhu/x0X4pV8ypCSV+RoR4ABuBHWSxF85uZJHMQhwk0ABQLKmBLmLzVkK06QL4lujSUzuP0qosm@vger.kernel.org
X-Gm-Message-State: APuU4Z/tfgmKzlKVvylbDzkGzt7w7s0omc2+e85vi4CwFCQOZdAALRZU
	AQVT7WvFJ8/wRpath4TUD2olRWTnNqRGO8++Jt3a1x+xW3aGQDgVgIKovJeQkOjib21OKrO7AXi
	mZ//yj/+DNse/ohn/EUNaat+mYnokYAlrYRmHA1Ivdh7xPeQSwV/LxGrupCmCVvQ=
X-Gm-Gg: AYBFou0jPDIsdSeMTHborGvdPbPJT6quVK+j0h6G6A1sSy25jTI7RbHA7Q+DxvqeeWY
	5JNFYNWaw1nM2xBmoH+nvsNPY9feE/O/qF7XzUfdIvwiepEnYAOovfzQ9k/+6UboEnzAgjUEeCT
	vQ9I0IdKf82hFZrJEGs+vQmUOSR9SNQbJZCj640QRxVBcxJ2iBPctcpVzJv3piqVnExLnEeRVb6
	Fe1bxjMEXkapDlr6NPRBgGOYi5iywbR2ijHSluN7dEMkh07b4l1Y46TYHoLwKG8Co81IJPleM9K
	yZfixcV9dLsUkRfyCisUAjKuCWB4l49yASRkgaH+Bv8oVEU1GsgwasiM7/ggXxeqVP0PpwSKzT7
	xeDcO2/Pa4lcbK9ee780gHx7FkwhgmlFzrd+NnSCALVGYtVMWlBdRPqJIA3GjoY/dPU0xhTTprL
	39mWq46HVjnzrz5Q==
X-Received: by 2002:a05:600c:16d5:b0:4bb:732a:2837 with SMTP id 5b1f17b1804b1-4bb732a2af5mr33746655e9.1.1794836367903;
        Mon, 16 Nov 2026 05:39:27 -0800 (PST)
X-Received: by 2002:a05:600c:16d5:b0:4bb:732a:2837 with SMTP id 5b1f17b1804b1-4bb732a2af5mr33746245e9.1.1794836367447;
        Mon, 16 Nov 2026 05:39:27 -0800 (PST)
Received: from localhost (119.red-83-42-172.dynamicip.rima-tde.net. [83.42.172.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb65ce005bsm207627955e9.14.2026.11.16.05.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 05:39:26 -0800 (PST)
From: Enric Balletbo i Serra <eballetb@redhat.com>
Date: Mon, 16 Nov 2026 14:39:24 +0100
Subject: [PATCH] scsi: ufs: core: Use ufshcd_query_attr_retry() for RTC
 update
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-ufs-rtc-query-retry-v1-1-4de69b175e8d@redhat.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MuwqAMAwAf0UyG7BV2uKviINooll8pCqK+O8Wl
 4Mb7h6IpEIR6uwBpVOiLHMSk2fQT908EsqQHGxhnTHG4cERde9xO0hvVNoTS7a+CBUHHxhSuSq
 xXP+1ad/3A8mVq9NlAAAA
X-Change-ID: 20261116-ufs-rtc-query-retry-3f27084f878f
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
 Stanley Jhu <stanleyjhu@google.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, Mike Bi <mikebi@micron.com>, 
 Avri Altman <avri.altman@sandisk.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, NXP S32 Linux Team <s32@nxp.com>, 
 linux-arm-kernel@lists.infradead.org, Frank Li <Frank.Li@nxp.com>, 
 Larisa Grigore <larisa.grigore@oss.nxp.com>, 
 Enric Balletbo i Serra <eballetb@redhat.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794836365; l=1772;
 i=eballetb@redhat.com; s=20261026; h=from:subject:message-id;
 bh=e4EQGaaTBbd9wtA70t1Vx8NEbGVqrdd2zRrcBNi9mFQ=;
 b=3o+DwdK7dIKBz6QiRt3MIR24WrlJ7wPWsVy0sCk7n5BUey0tWzgVYp0XfhwhC4Xu/UUj5MgWO
 gtYumqrnV9qALJkaY/8FbG0RNWLrN8fNYqVjOI3l2N916/2CHcnF0ud
X-Developer-Key: i=eballetb@redhat.com; a=ed25519;
 pk=5zh6xuAxTiQwglL2NXQFqWuyRPmCE8T5KPXLbNXhnKI=

ufshcd_update_rtc() uses ufshcd_query_attr() directly to write the
bSecondsPassed attribute, making it the only query attribute caller in
the UFS core that does not use the retry variant. All other callers use
ufshcd_query_attr_retry(), which retries up to three times on transient
failures before escalating to dev_err.

This causes spurious error messages during boot on some platforms when
the write-attribute command hits a transient OCS_INVALID_COMMAND_STATUS
error:

  ufs-s32n7 4ac80000.ufs: ufshcd_query_attr: opcode 0x04 for idn 15 failed, index 0, err = 15
  ufs-s32n7 4ac80000.ufs: ufshcd_update_rtc: Failed to update rtc 15

Switch to ufshcd_query_attr_retry() to handle transient failures
gracefully, consistent with every other attribute query in the driver.

Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Signed-off-by: Enric Balletbo i Serra <eballetb@redhat.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3c28bc67c65f..1cd32b7cc967 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8821,8 +8821,8 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
 	if (ufshcd_rpm_get_if_active(hba) <= 0)
 		return;
 
-	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
-				0, 0, &val);
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				     QUERY_ATTR_IDN_SECONDS_PASSED, 0, 0, &val);
 	ufshcd_rpm_put(hba);
 
 	if (err)

---
base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
change-id: 20261116-ufs-rtc-query-retry-3f27084f878f

Best regards,
-- 
Enric Balletbo i Serra <eballetb@redhat.com>


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578278;
	b=BAbuJb6uRDdfccY3OkV7i7UL9HRo2mmxX9MOiAR91BPvCQLVTceqQt4XhRujeOrEx0K0
	 2SM1adHMV8pL9lJQOIKCUZ6XmPxfCrf+nG8lVykVTFO0l+ovLm5iaEvpEVAnxpaEJgvxo
	 03UXNaeit8Xth+dlWoAmZDmEqugLrpn18Hpgy/NrNOAkvN5wn1ym3DeV1jp7325NgFmIr
	 vmW3jiT3pD8x619+33N6kI9LyiVrqYSxH4Fa8bIgEuXvGtMJ87ChruD8C/UQonCNOuNUT
	 EXDgVGuRKbshy3UtvSVFFOTpHY/M8/IQiJNv9/w/0eJOB5rtkYVlQ5qU6L0c5Fh3toA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=NkSN8UMfoTWKp8XmjqjM5ogwV9ygtNexpeqrEJLEfeA=;
	b=4ZEmoED5fcKRoXH1PkZ9zMjuRUZYOsJgOz+ruDsgmtK/MpLKrlKrtmp0lIlE1ZMh80Eu
	 UC+97kbmEcW/ATyihLX0cwAOpNc1EYB0EHeqk3PJW5nsLC0E93Uk52ZFY/3i0lA21dYR/
	 si5EYT9Rjrrxf4l8i7E2PjyxryYKY4JKromo2VCsy0qT0Ivkjbo9TMr3D0iV8MpNrzgN2
	 4ZqztMJAJj9t1MgXlTZh7xhsqDltcC9BNrBZKkuP52PWjG3n9Gv4AkoQkmQVJfAuNdidE
	 BXenDqeEhN1/7nXM6gqoxNlm11xa8cxsovRhFJarzsyVpMz7IN+Qk13kX+tUfgUKyTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U6bOHwnm;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611CE606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 611CE606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U6bOHwnm
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb61185057so34000785e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578277; x=1796183077; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NkSN8UMfoTWKp8XmjqjM5ogwV9ygtNexpeqrEJLEfeA=;
        b=U6bOHwnmylm4OE+OQdzOR2JcP9rnvceibNuVdlJsekQnAPHAVsZYjW961luTOjXupN
         t3xUWIXNIaoNJPNo9+7RtxFz0lxiEVNvXwuwAzvaNKt+uExLr9UdfkxcAzl+SZLOSUWG
         KJP3XKfq1w/+aVC1tphSyxoHeoLmZwQS9x0oWPEKUboTecNTFa/HyGSJ9eYoPQSqP5Ph
         SlveDU/SaJDo0dym3fZwa+VzPSK/ZXVcbdLbKqTP/fIu7gALpIhll57g8sERanCoCQuK
         vpMmXz9AJjcrs/xYMpw4fl+uKg/QLTqw4eAMNowVAcZ4RTa8IbYG1Kf4GZleu81dYikJ
         wxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578277; x=1796183077;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NkSN8UMfoTWKp8XmjqjM5ogwV9ygtNexpeqrEJLEfeA=;
        b=Iq5CRaNNUukrY3oodWVWekUHRgmCeyo4lNAu/zU9fZ6ORtToufu3PCZB3NtZJ1BruA
         acKEVDGlM3AnARmQMYY0B/B7CUnAfzWpG2/d1yqrpWS7L348LE39vBm7dmfBXpo5qr2c
         rTM/UmTPUjY3l796a2h1uCEGWSLrOJXpXcPJQhwShe6mf4W2HYQA23OYhc77TLWsqC1o
         O9qXdmDf9KF4810+9QSxg46/T+Ux6rP4rduJ661mJaF/+zOHyHluTOGl+BOeehSn5I9p
         Rnot4YABglO4lVFPUAaozxDVpX9R4qd4bFG67cAjs2vEhcx26Ts6RB9GNfkPvhvV+eV3
         EBJQ==
X-Forwarded-Encrypted: i=1; AL+hErEM25Xr8CCAI/5YSEzByf/+3TonveQDDWxVysGZsKVkb1HYeO/VNPtOb0t5wZptI5ktU0yvB//TUtno@vger.kernel.org
X-Gm-Message-State: APuU4Z93sHMcUC/5ZBOni3jyMoXLoVzS0/bJ8F6kA+G4RRWUu+OVPfyE
	wJdWlOxhfaL2WN4Ajb/SYK8DvTIdCEbkTITikqiskbYa4Z8PlluT75rM
X-Gm-Gg: AZFdTZfosaj9ou9E+DnY0zj5Ufl1J9CMV2gD2yr/P6K2Sy4IPLAgG7UUM5RRTBuyWMf
	nm38V62jM71ZRVrUzVWf4h5LSo2n+sUImqQB6giYcFnLMFDqW0vJUMWbMAbmDbEv/jEJZ2oh1pn
	WwnenGLG9SsYDnZZOnDDllcu6TVJ8o1Y3c4eSGEU3lFUi1j2tiQ7t1YYrV2dsar6nsYF1Dv3eZO
	L+64nW4Pg4z6bhVqIfpV3qLhrEVGnX11mAwa08K4TEk8mctVFmKYD6Ve8EDTVQ6CyIxLKr8Sybj
	7rSwWOO5ggJYPEcBIPx3sc0LI8Ept7n71QElO0SGskTvRQmS6rRl+/xXvVz9tHLYPVDB02XjYFL
	vgoqu5WiT3CLc7O4wBLF3+k3wlT+3qVIxZiXnmgeC/uFcxxRxe4TSSvVAx2X6mrfUf1/K9n5b5t
	8mhTcSY51UHkhtHypK5OGd+UcaXrDzEJS1uaEeq7d1HY3FtR4QZTnuUbEgNgcCqaV1AIXGWba9p
	FXt8y5L3fU7chXskcCwCJvnDpfPtdTof521sf42PP+tAiXED9LiKy7pT1lo/pzmHrQM621Gz1bo
	3mkQbIrGYJvXtvAwHNCFg+Kpfen5gC6CSTW+qQ==
X-Received: by 2002:a05:600c:a087:b0:4a2:5267:3cd4 with SMTP id 5b1f17b1804b1-4bb887c9fbamr346080945e9.3.1795578276823;
        Tue, 24 Nov 2026 19:44:36 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:36 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:08 +0000
Subject: [PATCH v3 12/14] soc: qcom: socinfo: Add SXR2250P SoC ID
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
Message-Id: <20261125-halliday-dts-v3-12-5c8311c0b70b@gmail.com>
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-usb@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org, 
 linux-crypto@vger.kernel.org, linux-pm@vger.kernel.org, 
 Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1207;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=sbEeAuvm0vdAU7a79gy3cwCbc+niIPSz0ebsMUqvyM8=;
 b=KR7TljwE3x2QteRIhm5O5gc+Ovt804bPNXZE2SHYg9Q0Owpdf51fj2CIb7ZGKKfP0khgNSrGC
 8wxHPG6P0W8DmuSngwRv4oXHEtyjNPML9jsnvTjumi9JPv03PdDisQP
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add the SoC ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2).

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 drivers/soc/qcom/socinfo.c       | 1 +
 include/linux/soc/qcom/socinfo.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 18105ddcf04d..72d282f17b0e 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -529,6 +529,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(SM7635) },
 	{ qcom_board_id(SM6650) },
 	{ qcom_board_id(SM6650P) },
+	{ qcom_board_id(SXR2250P) },
 	{ qcom_board_id(IPQ5321) },
 	{ qcom_board_id(IPQ5424) },
 	{ qcom_board_id(QCM6690) },
diff --git a/include/linux/soc/qcom/socinfo.h b/include/linux/soc/qcom/socinfo.h
index 317dcc26c504..3a3d7c7089d0 100644
--- a/include/linux/soc/qcom/socinfo.h
+++ b/include/linux/soc/qcom/socinfo.h
@@ -170,6 +170,7 @@ enum qcom_socinfo_feature_code {
 #define QCOM_ID_SM7635			636
 #define QCOM_ID_SM6650			640
 #define QCOM_ID_SM6650P			641
+#define QCOM_ID_SXR2250P		649
 #define QCOM_ID_IPQ5321			650
 #define QCOM_ID_IPQ5424			651
 #define QCOM_ID_QCM6690			657

-- 
2.55.0


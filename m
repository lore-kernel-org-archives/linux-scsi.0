Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578217;
	b=PQEBkeq6L7CDkafTgEPz8p4ePCvnpHdzrPErrorTKvdC0e4+XYEwC3i3I/GcWhw1NL3V
	 RqO4azSv7Eha1VLGw7YnCEJ/6EWwWZxyTTtH0c2Cgiv1BD2bzNWz40wd90cizQ9y06G7S
	 gQcDqWsnckL/SQQfroBQi6wLktPE/8TgLAPiNtXS/GO72SGj5VhfgZhuYFDqeNjv5HiUm
	 ncTAcQXXYfg2E4QugWEycpP5n25SfxD0f07ZnNOPqKh13l8Ux8JDg01NiIPVWrl1FY8IH
	 qH7ZRIOnSCMWepj9q+ukaXguLOOGRpaLiyHhIfo4KgRbY3qonhVcT6k15MfVhHy+nwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578217;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
	b=tTvrG3/mAhg7+EPXhBtcE1QzwiUTf511maOAaxEsY4Yg06Y41xDb5p+gCyU5OcWE3uiR
	 j/NkteOrKMzjtZEGaeQRn87A69JWpXWZ/jX9ySI1B5oKHYaavaXjAF3OSLF+mgsGVDgix
	 qxTWW/RPcn6HHQ54IW2xJyEzCP0CqcgAZJjoHYgkIFObGVFgvH7dbsugAqK1/A2SktPC0
	 K8zhe0K8/P7of4DokfO+UvahGsJGzIbW12PeGOroxhCH6lzl1UbHBCcfhZhknSsRG3zwI
	 cpcQ/ASO8arY2N+f5UshAW6XVaO2ZwIUej2IgtKPaaG856Xt/5JookMfVEucJk83xug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UHm56pzM;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C47606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36C47606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UHm56pzM
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so45196175e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578216; x=1796183016; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=UHm56pzME5QuJjhiAlkwHOpYeDJa6yB0YSYI1bvu1L2C1K/b8c8JqZfqvQO604D27u
         kbijntCdsTmXmZuyEXTOb3UWjibtttn9sm4yIUhv5BWWR4I4ZkBHypc2EQoj8gClP2kH
         iWlUwFG+ksAX8PfuGzyqwgPWimGWoKbwCaHODUEXgT6GTXr7IYQf2wZ866+zITCViM9+
         cWdmBvAUOA0q46kcT5cB45N/Ty+c6kaDy9tabJMeqja7JP84/DXzhEmYtOJHcJix8lMn
         ap6y5YurBKaiszdHFCygN5ro1OeYnibVACzFSOUr4CNcobuqzEvh4D1LFkTgVWGuKHY/
         cXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578216; x=1796183016;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=drwleRdoQE3pkKiq8NvL3TA0ZreOLUUT7TR68lPFDhc=;
        b=Dhf1UKY8+4xKv2p6JxH0VJUlSzX2hivcCnjPCq2qcbX8xqqHehE6hl63B5HohYAVI9
         +36D7m0Q4cEc1wHPkRZWbJ6G+ZQGLHz9CA/o9IP2yOCngsoaNt//Q/w7ZACvCm6LnNHe
         Czns4W4a27nhJJJqBuspN0tv1yW6KKo9R5U78qJ9enyDY0wZqpNRIY3thnYMEB58dkNI
         sGrF/MnoESvscrirQtZQLwS5S+m6FLi/CTfAIS40+5QYz1YR9agv1OqW6pAoHWWUqOIU
         zYH/mEUPUwlmbklRgCascIyljuUSmjmG2K7IYaEi5ojP6dCRs2gSy4gc4g6nyGlagTw/
         lv+Q==
X-Forwarded-Encrypted: i=1; AL+hErHHEyuCJedAm6UDJLuHFk/qzXFS+EcJAxTtP8pygDuUgB8tmvAeAlEGcZYWmjjqlkqfJRN7NrAcTHBW@vger.kernel.org
X-Gm-Message-State: APuU4Z8T/om/nNizZnlRd5+6wBWYL+ZdAreMKw7YWh/NGIuOoDoUMnR4
	M2zwFyOymAxZIRlcqI7P8/R8ZmFlg0x0ZjlwHyeHH/MtWnV42iRQ4NTh
X-Gm-Gg: AZFdTZcWxgvXuMvTi3TqABw/Xy9yTbIPnnKaQZWj4Cgt+rgwtWPpBk+DuyWoFgfRyu2
	RSsif2Ru1nBffSQa2YwrzG3UDgl5QvcSA0AejfnGjj9DH4MEne0fj0stVo9D/PvI7e3pu8IUc4b
	XRWGzj7mOnA7rAqsdCnzhPlffFMTKbhCwRt2TcnmPi4i+YQSKc0YqcWngdeGF7xS4vol+8YYkra
	X8XSthJO2ypOw1AVKHJ+ML3ZPAsRUj/RjmOSl9j2oNbSnk/EItD4TIzov+sa76JkxD9EurlBTxC
	v32vkoyAn/PUhabAI3bt6Q9ggtApDYZtQedk3t5lB3I8f7YO12M4Ps7y20pRiU3V6mjBnDOT6G+
	eibRV3AtTFmejwMit81XHqJ/TQm5EAYcvdkIfPD01S6BvZWD4mjqimkcJRBy9vKa72DGRNDLDVX
	yi0cmwgotJESTKmgyMtarYkqarBkcM8958P5pzjzBqXJtOnj2wb3HtayG4sTM5aIXs5PFYVIAOk
	AODLuyZ1VSe9YtZFJMCSx213gyW0ExG7g3jdWAdwJomWKsjCWzdy2L2KbE7kw14MdlYNtdQxSWo
	VVo1q1Tax8DM8H0GksftWzYLWAPRqljqR4YF7Q==
X-Received: by 2002:a05:600c:1d86:b0:4a1:fa27:df7c with SMTP id 5b1f17b1804b1-4bb88922972mr346329005e9.34.1795578215688;
        Tue, 24 Nov 2026 19:43:35 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:43:35 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:42:57 +0000
Subject: [PATCH v3 01/14] dt-bindings: interrupt-controller: qcom,pdc:
 Document Halliday PDC
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
Message-Id: <20261125-halliday-dts-v3-1-5c8311c0b70b@gmail.com>
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
 Stanislav Aleksandrov <lightofmysoul@gmail.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=910;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=TIEe9N/cyAzKgpuoZBtDZhrBfZnBIMsVZBId/jMf7sU=;
 b=h6Yv22yIDPhl899/gQR/dzgzFCiAwokqygzx53AniCMssmz68nf3bAUZ4boIxRmClQQzRo206
 0Yy7j0zKrrDAxm4EozqJW8b/LA63zgVJosiVzUEWd1tTWYtwAKtrSzc
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the Power Domain Controller on the Qualcomm Halliday SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
index 8401d3b48e0f..cf20041e86c8 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml
@@ -28,6 +28,7 @@ properties:
       - enum:
           - qcom,eliza-pdc
           - qcom,glymur-pdc
+          - qcom,halliday-pdc
           - qcom,hawi-pdc
           - qcom,kaanapali-pdc
           - qcom,kuno-pdc

-- 
2.55.0


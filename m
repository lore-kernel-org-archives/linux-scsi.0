Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795578243;
	b=M+m1iIHES2aNaw4fEbotgGVlV0JSzwrybGMjPdyozukR6nNQUw8Ljfitoy+ZAIbi7DGd
	 auLYYI9JiXnGNLGCusb7w4+b86vHyITBoME+aP4cUztbg5nS8QZMWZA82er+cMAMMX6VG
	 l53btZP97iSUfPZloyOpB+Qktyu4EfvTMJonupiMKvjHPY3Dfuni/T+zKoMkIIbp9LiRZ
	 V1TyVh2bz4axzM3u4kFtZqlbiMARjopudUQaH0iZQ1k+Dza1XveMKJoryvxZmKorzV3JI
	 4F66z6IArmyerS4v32PZQMmQWsV+d7XDRGag+d8XwWAzFTPiHnZdEHZOmdtgzRFha1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795578243;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=Qj41oco+fV9s3p+rSbInvqyHiLCYdw0nt/lz84zuf3M=;
	b=dnz/C2NofbVrdA7wdGUEsQBlMk5ivlVyQlr/CfK+tJJogN9VOwKN88PPXoM+etc4Cu1u
	 kvPXX9aULD5X+cOGl3vaj9C3cDgUrmSuHYPE11k2vxT1Uq9IFCdvjdtAQdAvWSBTMa822
	 aSwySVBGaYnYoVxdLveezuOw2Hm7CjLNlzq2WPBTTj4DYpDvVpCU4fuHPzlMMEKQJGC+y
	 +3n8nJv+RYz6gKbd8Mk2fRxJGdiMfdjgWoHZ5YHMLvxsuzSnXmmzrWikyVsJu4QMX2JHf
	 Mq6ix5casNglKbiOautes8o+fFx/UE9hVXxPhClNZU54JhwkH5jvypeQJN+S0K6dvFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xpr89P2u;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F4606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:44:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D74F4606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xpr89P2u
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so67625715e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 19:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795578241; x=1796183041; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qj41oco+fV9s3p+rSbInvqyHiLCYdw0nt/lz84zuf3M=;
        b=xpr89P2uVdNEVRU6ZFdn2eBT/t60OkWc0tfbtiVYSzLsut2olIQ8iMmMG03Qu8AXhV
         czmwY8klQILCpnQxdFXqLNpFHHOS3Fz70w915u6j1DQXaPm0RounccIivcFGNkTf7AUu
         Nq+70UK9MfiygohK2bEE6CLN+4jPinKxmEeKqfwkKmoHDDzWt0yNUPXMaIXugfvdARTl
         hp4EfLLqSIbgqR46C0zYggsGERYvEiVipCsnV5Pu0km4Qm/IUdXE9XNzt6Nv3V2YkFQR
         /QVF3UdadDR4/OB3HYNvw6ycaxZMdJnVuqLL/wTu56z1P7BgeqaDw9Eho8qpcwOOcKw7
         MHOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795578241; x=1796183041;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qj41oco+fV9s3p+rSbInvqyHiLCYdw0nt/lz84zuf3M=;
        b=NXI/TH3heZId1jm55Kul6OTPXzmH3xiCJFU/Oyj2OSp5lmt6B0R0frHKollTmMNFO9
         hS7ZNqyrZd0aBAE6XRXfsKqIPUkvJ2TK+uEg2ufKKvLaTHsJR4az8a3TQ4NHQmKDvNmj
         sW17il0Ze+edBFmcNqOrrl0EyvrfxYrqvWhrb01PsOr6NlSgFD0n7HyK2lew6Mtpx5Y7
         7IC9aV2ySxSMdSCn6rRGfq1xZu7y5TA8vSTs8olgWdYpEJIfyZ9b3vvps1Y9aKVMCfQU
         bSCxhjN+COx/tubq7A9w3vdXFwf4Q1hs+GSbNZKZBM7DmS8bPEKslsUfUmfW4Y3dfG5F
         EF+A==
X-Forwarded-Encrypted: i=1; AL+hErE9uIcJ0SmXnw7e5p65/Z4MKS7XpLlwTHDC4v2A6+ZpUgvmjwRIxwCw8C/AZ7z9HO93ix5985JhjxJl@vger.kernel.org
X-Gm-Message-State: APuU4Z/zszlyHpzoPzgwmfyXRtz2nOywb8B0r6TK3UQwPulwMOfxBf0V
	eUdDokp61WWGCZ3aXp3mmQGyuA9C8QIY4oWrW6ypPr0i0Xm16LYNcRbL
X-Gm-Gg: AZFdTZfTn36HbYYRCHcFPP4P35IE2LhJc9LDa4uDJlxu+EWYwrkTM3OwKLDFhZL+BqO
	0up1Ic//SyRRbfPL8X9gVLsrxUB49FGB5THGLTUUOQc4T+d79v4b6nAc0o83mGjNvdPeOMBrs7I
	F+fmIUdhegT7CPYF0nEgZYjeC5c5q8I7I04GmVKBOQy+xRJbipNZD05zXusoyysnMDn9+7qMKxp
	ten9SD7uBF2rfBR6Z/KjtWIw/cj96mtsKjGzGZxqdfEXZXYZFSQ6+sv3GwmbxfFtBaYW26BJoE+
	ph29ilh/4IC0WMe7JjS3uHM155Q3huEWJURRlOeDkvXBYY50A97LFKGmePwB1VOw0Rgk+6aYZf9
	wBjFWy5ulqah5JrrljKX3zWeqKIwfrrQS613XOCiN51x5v12a64sMqaQQGFHmNsP4Ynp/yag3xe
	QcSackCdmDBvMiz0zM43eNU40hyHPmi/JJHxWYrHRTSssNpRvoW1xB61E9qHvAeLDEfKME/xXdt
	EZimVNiUR19hzwwM/U0M5I2mw56iPODvdvrM23zc/3DHadrCWs14uAfWO5Y7745/gvQig+qn1Yr
	5fbmRP6TtkvQeS+2n/1pcJM6mf8/o5qTMvrN2re6lvVOReqDwSuAHmhZZJf0
X-Received: by 2002:a05:600c:6749:b0:4bb:5d38:259f with SMTP id 5b1f17b1804b1-4bb8881099cmr321134335e9.12.1795578241263;
        Tue, 24 Nov 2026 19:44:01 -0800 (PST)
Received: from [10.32.31.239] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm391107925e9.0.2026.11.24.19.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 19:44:00 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Wed, 25 Nov 2026 03:43:02 +0000
Subject: [PATCH v3 06/14] dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: Add
 Halliday
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
Message-Id: <20261125-halliday-dts-v3-6-5c8311c0b70b@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795578204; l=1066;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=LnBBJKb9fDjzFgKcPxLWG+G1ECrWNheGC13yLk2PP7U=;
 b=AK3HsTIHMWrfVz7oshpUweVMA1RMXUBxsZdz2vUtNRXnyYZuhyvlqRD0igQTo19XNPCP3yBIj
 lrBLDzvfhh3Dy0LccQPBEZwfCNYpwtXoUv7VnuZeXacHd0nFK00aqKC
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Document the QMP UFS PHY on the Qualcomm Halliday SoC, which is
compatible with the SM8450 one.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
index 10435a0b5230..a42bba9b550d 100644
--- a/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml
@@ -28,6 +28,10 @@ properties:
           - enum:
               - qcom,qcs615-qmp-ufs-phy
           - const: qcom,sm6115-qmp-ufs-phy
+      - items:
+          - enum:
+              - qcom,halliday-qmp-ufs-phy
+          - const: qcom,sm8450-qmp-ufs-phy
       - items:
           - enum:
               - qcom,x1e80100-qmp-ufs-phy

-- 
2.55.0


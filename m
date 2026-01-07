Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B2D22154F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773169; cv=none; b=PVMQv60nrsnGYTuVJbZOcwu3U8EUExqkzyfe4n/+dh7OtxhZPn4y+3857VK7WhJRhS/vFw3uk7biBta8knxZ7SkA2LBrND+nKy5lyXFbLLciBrBeji5lDR2CiZphh4qldqMJ7N0TTSbH4o/tJO8YlUFTBXjvXRMm9VJP4MVoFjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773169; c=relaxed/simple;
	bh=+tKKM8eQQWo+yQ33MK7IDCfz3vrpdNi8mDp5L1/eT14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GMReBy9bVPDRzQ5HqtHAi85liM13u0mLn0Db81ZE9gYmTdR+bKnf6Hj/FuRK85a2KKP9d/e3wxeMJ5mTcULl6uj2ywVgxbLrGtXQX2TpEl3WEe21Kp1PRZJOCmetKyTJKx0OddHB0k4Ay7mSXS/wXtHOABYhZ/zsKwa8gAglI8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=oV9w+4nL; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="oV9w+4nL"
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so2502749a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 00:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773166; x=1768377966; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2GgDJ/Fmj2hVxq0kt+KlgzxSiJNW4ugYNOpHPzq6Zeo=;
        b=oV9w+4nLjPZ+/SE24E/8IcOnT/AM+5PAsxwDhVFE3uGTGYZGUqpSqknrfSOfXEf/lN
         vJrmlqQ/gw17JQH8JOO5fc0gkdZD7Mjd/NUXVCuZIkajk5IZx7YTXa78XVcWIE8d9QZl
         CCvpP6nQSdwzWsMOKo86Usg/BtWct0GSG2DIcsyNpDdXInfRhbaPZM2aWSFaRtRq4cAD
         5VPcA9APpl4Iy9fw2UCkp8B+TlgLQ78+a3DQUpdieOtopJU00m/0MeiFbGrAgscw6nwU
         SLb4+L7qsCBr3ogBfbIj0ztK1Agig655uo2uifdEnd3vruQw79Nijo1DFZualc0fqOGW
         IO1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773166; x=1768377966;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2GgDJ/Fmj2hVxq0kt+KlgzxSiJNW4ugYNOpHPzq6Zeo=;
        b=o9wX5uy0kyEQtTuCtySjtdhUadqZIy25T7/6g8L2qtxdTKwli1F3qSD7DT8q5vZnB8
         YhzF8Icd0jtuCEfd+UQri3QY/dqwoO8qYBmKrra3rnJaqWtvgZ9eRC0fhPyEYZqUGzpT
         hEOYhZyfM2iwVzIdu19yy56IfkwZW0+iwE+PBKjWqKpoK7JcBm9/7inEEmddz6V4sWyD
         scLwTacs2XgHnSRlI+a/eQX99RQi+mxEAn16RBvFIYRh/iaQrXRDFnsgdnH66r3myG5/
         bayn3mX+/gI8LNiDREc/svOHAxP3DzJE9i+9DCilKIU8Snwr5YSGSiyvme1U8Qo44O8e
         K3Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWus8zZvKhNrlRp4BNpTcAwHlGcNirwB+3262Tic5Em44QCCqN16ktFdk12iWK8FeWHnPPM3VXvGoar@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9rzhBQ4Joyhu0nhei+uge2aWWggpJaghJ2DsJAjzBPAH0QtHR
	7m3KMZzCeYCZizem+TKSVOK1rKc6OFHmLO5Pub7CV1q43KSUGMo1ewRGjPTE4hiNJkI=
X-Gm-Gg: AY/fxX5V2jN+dn9HU1qm2KM6yANkRZp1nMCqlr7yCN2oP8QO0eTVGAirlPBGjlo6FJn
	+YkPr34rdwUliW5SYdWBHO/NFq9n1sjC5rycYWqi6TsVyeEB0XOu2lFmmKyIPx4bsrYYga+MDvd
	qZxlOjQtn0xDLcoX+5GXOkEmMfdzBR7xGfaeZrLXncTzch1F3S73UzFeo3rRTogJgo0hl6GNyfR
	VsLaL2zJtpsi7Q8haHbjpdbdVNkyZPPKCSAHzzxdHa164SmxZ+WDDaMjAMpMqcRRY5oh2/86EQ7
	1VSn+3BaKPKJ+n7Odu9PoBYaLm+RKBr0KepH+pHzvJDN4Qs/SO0lDm+l6XJWG5pNuaRdH68K4aJ
	Ezlle1lKtbsNQxWoCSCb0y5qWXGc+JyooOMBo9rtwsD9tTQTF1wBzirseuh2PyS8UEPklcoJ5Xi
	WiYnFi8NXwUB9MhexqHh0PCzfvfZpngrUxr6FV
X-Google-Smtp-Source: AGHT+IHPuKMiRpCxNqWVDZ6u4OSMQLbl2xruzqTtEZLMtSwwNhXW3B8I34BRmOAoeN3Blb8BbAq1Ng==
X-Received: by 2002:a05:6402:3546:b0:64b:4720:1c23 with SMTP id 4fb4d7f45d1cf-65097df5b56mr1391779a12.13.1767773165260;
        Wed, 07 Jan 2026 00:06:05 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:06:04 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 07 Jan 2026 09:05:51 +0100
Subject: [PATCH 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 document the Milos ICE
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260107-milos-ufs-v1-1-6982ab20d0ac@fairphone.com>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
In-Reply-To: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=908;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=+tKKM8eQQWo+yQ33MK7IDCfz3vrpdNi8mDp5L1/eT14=;
 b=lQ5mBpA+U7bYt0gJHGAAKSmbKFboogIa6LHo0xKezfRR8+VQMi1EJlEXC2zEEHIUnQXS6NZrt
 md+vcvmtCvgChFgL0K/iZrrR30Ruj3ZvPQ+/W60c/h1TrJirgsrRBca
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Inline Crypto Engine (ICE) on the Milos SoC.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d20..061ff718b23d 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,kaanapali-inline-crypto-engine
+          - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine

-- 
2.52.0


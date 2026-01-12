Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFBA355051
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 13:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226000; cv=none; b=MAcjzTVDjA7qO9jsdAXgqdF9QIVtkhtRJmVByIfIb65L7j5On6qinmHO0LEIPa1XStq+eyJVExrpxpj0xy4IGFRsnoaS33CRd9iSbT6m/9L+x+9ghUGJXSuhepBT+8P1x9KL/teto0eoO7sN6dEcdVtAVHfCthtgM67C1GzzNlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226000; c=relaxed/simple;
	bh=869qKXPKp/5HVz58yGdlPkNK/AkfXAZ4HLSxUNKXhtM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=GlDMzpCJtrPnqAsdSdn2LNdFotwP9xVNxFeLVyaAtDJBIQv2QmOQdndyOYX9fLhGHHfvIhNpZSnJeFkNVkKYDfi/V6sd5PQ7Bmzlri8mcJa2ZUJYPKiBXZ5JPWzRyXk+O3vvrl8od+H5lUNpdNTBXGhJrDNXgKnNLLMwV+S4j48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=HCdB2ELF; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="HCdB2ELF"
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b7ffbf4284dso927496266b.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 05:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768225997; x=1768830797; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gaVryPH+6C0Tqtqwm/Yuk9yK3m+Wj3s5OH+GPIlElSk=;
        b=HCdB2ELFcSZpD3xwA99hzBqSSgY/rleO2LCMi4XMPK8VNq/68RYfqSFFTkY3DgLGQp
         +Tx2i56mn+rVZyaDw8A1/kQM94aB0XWKPOP2yTi3eRDou9/ePQglfDQwdvTVAzUy11nz
         iPLz31s7GN8eDXTfbYNWGmiopGQBQmPii+IU4Ft0dVAz/XJ56EHPpVcZPhIkoburCzRJ
         rEUIMKErFoUdSiOAAHN9ZdO1ICmJCIvRUTQxxECEwtFi7PNbxzJA9wUtD2owZtQhTMLD
         H/gn8c64tZWD4QyVaJ+AmoJjew6eJDJ5I3eOq2n3gNNIrQqemsoYSI5TOs53wV+3Svf9
         5THw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225997; x=1768830797;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaVryPH+6C0Tqtqwm/Yuk9yK3m+Wj3s5OH+GPIlElSk=;
        b=jBgBv8h5Pr7cXgLMVBQZUqxVBY3ATNGkYgu0vNI7Vx+4hUSgexdggrmwIjWD4hZaxu
         hYWPMsZEDRvg6s/J+oPcIzsE2lbz+6Oc2qnES0HMr1Ibss7NzWQeOp7ogkblpcDhek36
         r1alRRiuO6ezLtZiDQTwYS0cHg//CD/5cNwTHb72RFOW7ABnhXj2vTo8p+UyG0I1nsLy
         aJA1cY+oYtt8+UghLk2kq0o7mN5kfXyd1sIncneO3549h3D0engsC5Xv+0NLeATzAsA5
         Y25+RzeaDd8GvzvGvHP5NPMHZxM8zqqb1fhp10q+Cdg+nWBO3U/8MK/G6/w/n+8f0P5O
         idNA==
X-Forwarded-Encrypted: i=1; AJvYcCVAsJMbRr2KBBj7i8Vt07sZVTBd861iGQsZ+T3JvuXGPyKAUpaIU1koIewnd8/YUf/Lw9urwNb0YCuo@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6XOqWcyoxDifHMVszktqiEDJqntTIXi+Xo0rjrGMGqRHLBOTl
	6GgEaATHLYwtn7DbCzQJdqKBmSu20jJeWQaIcKGJy7dkSBL6G1N2h9IP8eqDgcwHh6o=
X-Gm-Gg: AY/fxX4XJOEkSgSkENjDHNx10MNMopD+QhOzB3kksPvWEQruYAnzaG/wpDCEnTZ34eG
	y+0NLQr6pUNcTHUNoYJt+f43m1C1ODSz65aR6ZxYW7qDhv8Hob1pOZn9s5YcSK4/z+l0VfEZONc
	Ythf+DQtRdoIY+PGaeXvMWvItTkYYyJt/A7VWOpU1fbJGDXC9Zk+BqQnE3KNFdgUdJMx4phMT6w
	/RlcIpcGEUKfWcFI0IHcD3wGtj6kz6PWCiZxBcsXNhqYOABlEiSyjjk8JvDSsnZ//P2Lw+RJC9X
	SmTePIaMUVupOeqC4M5eTTQ8bOsQDX7V097m2gk3uwS2uIiR/N7Oy4iNC5u6NlB0u5mgsMPucF2
	/O/vv0jicC+VylKBfohHvHOYKMmUblBYN2vN5q5SEHC6BvRiZuVfQfUTw5ReAHL/zR567UYIs4y
	tDDCIv4J7FJbhyJfCUEZME10Aas8r8lUgQNHq/r57Q/DnMFUnsZ1hutZE89BPpv54a
X-Google-Smtp-Source: AGHT+IHzxEgz2KsBSO+arQBHVhJujP60zEh8vnZJ9xXT+N10U47A31S2v+8UfRza4bfmALX8ySwXSw==
X-Received: by 2002:a17:906:fe0a:b0:b83:3773:dd96 with SMTP id a640c23a62f3a-b8445030d72mr1887365266b.3.1768225996535;
        Mon, 12 Jan 2026 05:53:16 -0800 (PST)
Received: from [172.16.240.99] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8731f071e4sm25700466b.66.2026.01.12.05.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:53:16 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH v2 0/6] Enable UFS support on Milos
Date: Mon, 12 Jan 2026 14:53:13 +0100
Message-Id: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/02OQQ6CMBBFr0JmbU1pDFVW3sOwaMtUJpEW20Iwh
 LtbQROXb+b/N7NAxEAYoS4WCDhRJO8yiEMBplPujozazCC4qHjJK9bTw0c22siktrqV8mSUNJD
 zQ0BL8+a6NTsHfI5ZmfYhaBWRGd/3lOrC4ZzYVyvhU+goJh9e2y9TuTV++7+zU8k4qy5nobTgL
 VfmahWFofMOj9kNzbqub5GInBHXAAAA
X-Change-ID: 20260106-milos-ufs-7bfbd774ca7c
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
 Luca Weiss <luca.weiss@fairphone.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
 Abel Vesa <abel.vesa@oss.qualcomm.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768225995; l=1410;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=869qKXPKp/5HVz58yGdlPkNK/AkfXAZ4HLSxUNKXhtM=;
 b=ya0h1GWx9MbkL8J1GPpxKxKEPorYhGvXMWiaky/iNsRq8ZRWCVWK6G2OODVWZ8CbyrFGEcgyH
 tvHqCQKfapfACq0UkxcYG5jly+DRCv9gxdUuVrllWQA3147ZU6tLlAT
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add inline-crypto-engine and UFS bindings & driver parts, then add them
to milos dtsi and enable the UFS storage on Fairphone (Gen. 6).

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
Changes in v2:
- Add missing dma-coherent in milos.dtsi (Neil)
- Pick up tags
- Link to v1: https://lore.kernel.org/r/20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com

---
Luca Weiss (6):
      dt-bindings: crypto: qcom,inline-crypto-engine: document the Milos ICE
      scsi: ufs: qcom,sc7180-ufshc: dt-bindings: Document the Milos UFS Controller
      dt-bindings: phy: qcom,sc8280xp-qmp-ufs-phy: document the Milos QMP UFS PHY
      phy: qcom-qmp-ufs: Add Milos support
      arm64: dts: qcom: milos: Add UFS nodes
      arm64: dts: qcom: milos-fairphone-fp6: Enable UFS

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |   1 +
 .../bindings/phy/qcom,sc8280xp-qmp-ufs-phy.yaml    |   2 +
 .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml |   2 +
 arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts   |  18 +++
 arch/arm64/boot/dts/qcom/milos.dtsi                | 129 ++++++++++++++++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |  96 +++++++++++++++
 6 files changed, 245 insertions(+), 3 deletions(-)
---
base-commit: ef1c7b875741bef0ff37ae8ab8a9aaf407dc141c
change-id: 20260106-milos-ufs-7bfbd774ca7c

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>


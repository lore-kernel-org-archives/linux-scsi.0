Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF501224AF2
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 08:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773164; cv=none; b=uzhwDMMv0GlgUFQABL33YG/LTqo1f2PaRTEN5bxfS09ymc+kJbg86aP5egs7yIjmv3iaKxY67RgMtvxoxEv3ks5qy5no+JgSSmHuNrd+H0yf6BRLEpyA51ADoY6gjWr5hMK4Z3WlUKfO0+a7HNFWj3uNCOYLoi0Mw4TBtljv1cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773164; c=relaxed/simple;
	bh=pB3wFfFcfrB8Ff4wD4ThceQT023SqfNJq63rMjQeuWY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Td2s3CdQ5C4v0Q8lNhpngzOQvC1NEHsZQNMcmSqe7HIp5CE4+twK4W9vRae6E1f7ysk2LX285zntRI7ZCbTT+K7FBpS4PA8G3Dn4TWSGLJ0dEuHwNJit9ZSxhtBRXjjecEgNBk70KmW25mO5YKi4+7RkhWzgbkSSXkFNGSV44nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=t2n2Qap2; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="t2n2Qap2"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b560e425eso2392404a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2026 00:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1767773160; x=1768377960; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aea4uA3J/1hwOpuMUNDquHCAnGDE82D8jnGDI33DmmI=;
        b=t2n2Qap2snXJ1sgPwbbQSUltKuOtstCzls6HfXSYUXWTBv5cdXFmeTdOGG4SnRWyDY
         MqqWN91J07Y+/hd6pN4ySo8kJ53+bB0T3AUZ408/w02hYT+l9PhRqlv2VO/T8MZMSabn
         eGMvl5Zyv5QwfvzyLQcJSBUV58pflnm62BDPiS1JB/gIOR7idVbMhRuvm4XeHYPv4ewl
         N+4CqXRszLiTa0GYaYul86i66yIcqluvyhH88hevJ6oDnmxhcDPd4G71CCL32A1kIZgA
         Rr0KqRVEC229UFHiq7TQKY6ItjG159SC670qThAvSysNHAolhZ2EVmYt6aRLTnpJ7d3l
         WBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773160; x=1768377960;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aea4uA3J/1hwOpuMUNDquHCAnGDE82D8jnGDI33DmmI=;
        b=DXHywVhzxSJCzNcTFfPKavOmW7oQhjhFDNOy4hFzjJbIBypP/jImbSqW4lQzHjbnwm
         KbQQq5MiPqHWULQ3NGhyvncqhjA2lUaAVTi38e3GCpkF8BiS+msQc36dU78Kfaagu9EO
         I0CHJaMPVdA3xWF8ofsbY9FZRxt29bB3hcUuVN2NUyCAyDjlbmPRxQcLKF+MnTnumvCv
         jOyvF1S3Bgw4P6YwW8PUQxsS5UdNAv1XUIRz2y0n78QuVL/lOfQYa33whNpiugigd3on
         vXOjry/0Dh+mlv/cMajCDAbSat8Hl++gI5pEW+5PP3dYOZmw3Pch4XT7WtlQTE0lUqOu
         MKYw==
X-Forwarded-Encrypted: i=1; AJvYcCW3jG+ukJCqafYUrrVl2BT5WOmztSNbP7g+AjM9iPsg5hyEuap1Hx4vbQNyu0lQ8JaSvwlHAtcZ5xtS@vger.kernel.org
X-Gm-Message-State: AOJu0Ywlt/LEe2llpSPXMeiSRMbM/9k27OWKRhXW9XYRzT+wIIb8LHrL
	vybEQuXVYNKwMB/lDeBaTNAAmHVrEXz26yX0MwVhs7NlGvbxJTLKxZ7YxKF1let7J8w=
X-Gm-Gg: AY/fxX4QHA7wG2I0T0MkCfRa7FlCjWtm+rCAFi+taN7H6yqLWPicugF1Fr7YVakS8gt
	1hh7ptinUAa7lrbwI53xb7qJ2JABEqH9dkjkZKRN5BIhyhq1DD0tbiId957SfXEQuC1YB6iE+Bq
	wXo1BMW3/y8mtWH+YIcIACDleA8W7GfXDGKSfIZCc2Me+V4alR0HZce5+Ufs7mEF49AKqbb+xP2
	adB4+sDvGOk9ZuhU+K8t7DspY6SWNBaunLKjY8wT99Ey0/RrtfxLECj9QaBputOqZKMPhF0iQ4k
	jX2c5XPlwUP0q1d/0I8rxRfDYBI+4Mv/R/l4e7wySeDVJudJO69TREnJlsAEjsvB8N7sgVaKGqb
	I/6flfsRaNWJZ/4xHgozYGqfyACOucE/NWzcnT9fqDLo22j5Bel7+D8dkmGyubW1n8Jb7VBsWMr
	XfqgJPbrtiqQyxret2Naouw2Jr3A==
X-Google-Smtp-Source: AGHT+IHQhvsajZNsAjIqdeTR55Pw24pMGEFgeV3TrZGwVgpku5ShlzsTTOU37V7fY7XTDRiYIV76WA==
X-Received: by 2002:a05:6402:26d4:b0:649:cec4:2173 with SMTP id 4fb4d7f45d1cf-65097de6edfmr1372195a12.9.1767773160150;
        Wed, 07 Jan 2026 00:06:00 -0800 (PST)
Received: from [192.168.224.78] ([213.208.157.247])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf6d5absm3941299a12.33.2026.01.07.00.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:05:59 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 0/6] Enable UFS support on Milos
Date: Wed, 07 Jan 2026 09:05:50 +0100
Message-Id: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN4TXmkC/y3MQQrDIBCF4avIrDtgQomQq5Qs1IzpQNXWMSUQc
 vdKk+X/eHw7CBUmgVHtUOjLwjm16G4K/NOmhZDn1tDrftCdHjDyKwuuQdC44GZj7t4aD+3/LhR
 4+1uP6exCn7WR9RzBWSH0OUauo0q0VbxYA9Nx/ADuaakFjAAAAA==
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
 Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767773155; l=1231;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=pB3wFfFcfrB8Ff4wD4ThceQT023SqfNJq63rMjQeuWY=;
 b=Ijl4D0+iLyVGZ0M1qfLy2I2IXvmtEOs7o+3vK2uEs/UcQ6h1855hoeK3mjwjmyOcn4UdfWtNz
 38+258XrMLvAUktnYO0rAjq9N0IzcQtdcJnuqwDjihz3MjNAQHtFREY
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Add inline-crypto-engine and UFS bindings & driver parts, then add them
to milos dtsi and enable the UFS storage on Fairphone (Gen. 6).

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
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
 arch/arm64/boot/dts/qcom/milos.dtsi                | 127 ++++++++++++++++++++-
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            |  96 ++++++++++++++++
 6 files changed, 243 insertions(+), 3 deletions(-)
---
base-commit: ef1c7b875741bef0ff37ae8ab8a9aaf407dc141c
change-id: 20260106-milos-ufs-7bfbd774ca7c

Best regards,
-- 
Luca Weiss <luca.weiss@fairphone.com>


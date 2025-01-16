Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022D322B5B5
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737038969; cv=none; b=uo60IKTtAKT4tu+/IiyPi39/MWeaV/VAt5Sh5i29CiQtFWhVDpyKNKEqiRpFJIb3NOjyJaeUhCSpnL5Xywoxz++GImEjIjnjYSbINsKzUFfo//hHItvAP2m4D/8IHTT5TVpKW+2sVgyVKYEuRzzzxOI1l8NLy8YyVkvp5p1UpLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737038969; c=relaxed/simple;
	bh=XVIK6P3cDh2RmjY5FPX61raR0X7pooRB+f/SKenLnGU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=kH6vXT1uc+I4cmmDbfunnr5/hlCYW9A/bLNjjI3ESy+oh5xB+Z93hA5DA66RRmqLyOUVmmgNr3FfbmauIzc8ag/RDda8E8dEeB51CI6djiWirn2ll8y6t2o1UeNF0DaDqxXNArdWD308gbSVj3WyVnl2/0lvsCjxkqXxehCY9mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S2lDYYNx; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S2lDYYNx"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38a34e8410bso552305f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jan 2025 06:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737038966; x=1737643766; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fNrjqctMKz1qgAHIHsA7Z6UwsnVoB9RzOyu8rn1dpcM=;
        b=S2lDYYNx34IPRt14H45xXsjPe56VH+HhQ6g50uuguRS/24/LQakvFKBZcq/KoBaL50
         queYhgcLnNF1d1Yv143wxfyOK2ZjiEWGfcShK9frF+h+amlAmePw9OsBotlkSB7HXk8q
         frt/qCLxP1o7dxCorL6sMLmGqT1BNIV0ugP7AGXNUmxxdeq98WrPNpW+RtjF3IUnX/5X
         hFQMEabkOMkAOO1S7KQu1YdWE3pmI0IJOBTwgLw2ycZxNAGl3vjWYsJSBH8kSJ0qrdXy
         RPK6n2cp04zg6UeLDJ5PnrzZWm0btHyjWL6otZIdaK1snki28n80fDK1F2q4Q8fcVu+v
         mFRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737038966; x=1737643766;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fNrjqctMKz1qgAHIHsA7Z6UwsnVoB9RzOyu8rn1dpcM=;
        b=Eut80u4WtZYyzBeEgIDavK1eBv1w1TuN0GXKFDJFE7OD3NEyF6hFNWMJO6iH/sfrgU
         E364TAsC9aEhgi4Tx1vdQu5nsEPbxU2rU8zwC2HiI6VSM6CSqBCjvSo03Y6UUyeKIAsL
         Z0x8y1/OMsWb1soXlLl71uqGM6BR5ngMZe+B4/EnLy0r2vmuRJh/ijjCoW8INMfBVyB2
         mn+QETd61QufJj7d+BGfP2r1GBBU32/RnDxqefHo9dSItyHg1oCYqynhymyXiZ88WE6R
         H4LoJUuah5PRPuy4ety8bYv//PfY000QFlG1jCPY3IMx/KPi4A9zbLnkFF8yHooUJ9P9
         YX1A==
X-Forwarded-Encrypted: i=1; AJvYcCVmJ3EKyLsQBTsdakrS6BoNK82cFXf81tV/ib92F6wCFlEUaVjiRRFcV1gr8xDf952auez2s6gvuF+B@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8ecY9inkWmcQAl0DWEJ1mP4OKL5OnH1k1TD7RP0kywyb16ruI
	Yh5CFurSivWOtz4Dph7CDbWhSTeQLU2zFXpT9Xqgs/1pO+7TFhcvfcbBJaAVR9w=
X-Gm-Gg: ASbGncteno1pqm4Tdny7aHZP0I27cB67c+4WWz56cYgwnj3dYbNpTX/jV61CDpkuV/C
	l5Hx46sNguOKWCdscQ9Yww+zo1yfYfTtArEmLCQfeNtyTKunmXiEo00kmVuhYuG3noENEGZJBPt
	LLPsXQ/gi2gd5ZVSCSqT944s7AchI7ISfD6KGMSJ/Oo+R0OotycykdbcHMxo26VH2zb7aPluWsb
	bBUXRCmVZ2/DE0KIIQugWERVmymkCSGxyuGkp3sFmUf0riw84f1heBDQ61YDcXGnrSVxMvW0Zn2
	TSnOMx30/6l95ceFeboO8kWJhpobzSSmvHLP
X-Google-Smtp-Source: AGHT+IHl1kBetyaeOjNXShWAh0tzmG4VVpCeXqjWskMJPe10ftzlUB/8CSFuRx56YA1k5IbFK1rVNg==
X-Received: by 2002:a5d:64cb:0:b0:385:ee40:2d88 with SMTP id ffacd0b85a97d-38a872d2a11mr30493102f8f.3.1737038966300;
        Thu, 16 Jan 2025 06:49:26 -0800 (PST)
Received: from ta2.c.googlers.com (169.178.77.34.bc.googleusercontent.com. [34.77.178.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf321508esm70310f8f.10.2025.01.16.06.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 06:49:25 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 0/4] soc: qcom: ice: fix dev reference leaked through
 of_qcom_ice_get
Date: Thu, 16 Jan 2025 14:49:04 +0000
Message-Id: <20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGAciWcC/x2MWwqAIBAArxL73YJGBnWV6MPHWktvBQmkuyd9D
 sNMhkiBKcJQZQiUOPJ5FJB1BXbRx0zIrjA0olFCSoG3PXdkS+j5QUcJN9IrGuO96nXftd5Aaa9
 Axf/fcXrfD46tawpnAAAA
To: Krzysztof Kozlowski <krzk@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Abel Vesa <abel.vesa@linaro.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@google.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 andre.draszik@linaro.org, peter.griffin@linaro.org, willmcvicker@google.com, 
 kernel-team@android.com, Tudor Ambarus <tudor.ambarus@linaro.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737038965; l=1305;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=XVIK6P3cDh2RmjY5FPX61raR0X7pooRB+f/SKenLnGU=;
 b=yULsW9f8ssEvEIwNMrzYj/f7k5qacJ3+E77jHSGJ2rn5hN6wtSPSVE4x7pLEBB2tiVmrN95Xp
 hz0cCTM8VKID360TwWCYa3w3quENHLTqwgc4qE9guKQZPT2HIFL4Jcz
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Hi!

I was recently pointed to this driver for an example on how consumers
can get a pointer to the supplier's driver data and I noticed a leak.

Callers of of_qcom_ice_get() leak the device reference taken by
of_find_device_by_node(). Introduce devm variant for of_qcom_ice_get()
to spare consumers of an extra call to put the dev reference.

This set touches mmc and scsi subsystems. Since the fix is trivial for
them, I'd suggest taking everything through the SoC tree with Acked-by
tags if people consider this useful. Thanks!

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
Tudor Ambarus (4):
      soc: qcom: ice: introduce devm_of_qcom_ice_get
      mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get
      scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
      soc: qcom: ice: make of_qcom_ice_get() static

 drivers/mmc/host/sdhci-msm.c |  2 +-
 drivers/soc/qcom/ice.c       | 37 +++++++++++++++++++++++++++++++++++--
 drivers/ufs/host/ufs-qcom.c  |  2 +-
 include/soc/qcom/ice.h       |  3 ++-
 4 files changed, 39 insertions(+), 5 deletions(-)
---
base-commit: b323d8e7bc03d27dec646bfdccb7d1a92411f189
change-id: 20250110-qcom-ice-fix-dev-leak-bbff59a964fb

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@linaro.org>


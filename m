Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BBD2AF04
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737123547; cv=none; b=EX12EkXCqkHT3myZ3ERKjH2OyZtLO8hRaWsaA5jnbkA3ZnNBFTGtcgSYLm1EmMZbCq5ZDc1SjtShLG/q9vik13o/vKXzS1GnCHkEmrt0iMgHCQnUdFn8wMV8GZDUDFP+1M9AqNSwtgCPIGEiv68EJrcoHmVv6wdd68AoRtExoYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737123547; c=relaxed/simple;
	bh=tkyMhbw6EAVau4B8wFXwelogqHkWruGf2uFflN3bC8I=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=PIqRK6u4dMOnnj/yj3EZQP/YaMjW2wPMA4h6rdeD4UMulQXLJ4fa6u/HmhEuah4QYIom6wPTW1IbpOwFl0wyKDSNsdq6xi8lXCFfXLyztybXcppryRT6feRyBZxrVodqu0Tvy9CMHY7bDMbtThV4TaaOD3M+8IvztfgSCE9r6qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=InMMqpql; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="InMMqpql"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso20163835e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2025 06:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737123542; x=1737728342; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GMxaEhjAgDOvjE897xyr1NhIWqPvzD4fT3lJ/e+qfPU=;
        b=InMMqpql5MgvP/TOjZVNmre+kYI/kEaO+8R6y1kTxeHbpsFhjZbFmKAZH0TGvjzxRA
         bua56sVwSl3U1Rsw88XiVTbmqjsSXbwQpzQvDWzWJOHiKHGUFJqQIn0vS/w1PdB9QQbe
         FL7jHkPcrxWnJg6g/syTlk6vZMOhgD22cMurGnbZduZl4gxoAI9jc+XXVZHxNc9xK8yO
         9XiXtEgkuTLE+Qjei83Dpd5zV/04QMxjzsc+qDjKJX2k/If4kH1rJf4QQrO0/DFRBjl2
         hZNmppyVSWkMdVA1nPma50lI21rYOG3obsAvNjqz9UvHBrS25FZXoxX1qBSAUqWML6JM
         hvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737123542; x=1737728342;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GMxaEhjAgDOvjE897xyr1NhIWqPvzD4fT3lJ/e+qfPU=;
        b=J19bPENUuFFM8nhin5z+uoq7k60snt50GoMXzRi5teRxMuKAyof+WVSRbOXlxW73yh
         3K26uMfNn5IoMkIZ2wgYF9i8ZQ35QfIiwPxxVDXbbtDIDPbww8oPWh5QxsLlHnOBOZyp
         OPFFpnsdDYBJ0dsPu9L4ka3b14cZVYDZPQoIS3Pgy6VxHFyQVrufHVZy1qdc5QAPNW4s
         sORlhFNvvtLqY6qIGp9t2EEymsIjMPFHI/uuMrhm25blEsmdq8hl8EVza7qnN+2QKpLO
         xdHLKSNOHRuOW9t+2ZST7PgUi6pQ7UXFN2Ad3uts1LnogDWrCzTy945aA7Jfv8k/SB28
         DWKA==
X-Forwarded-Encrypted: i=1; AJvYcCVxEIXxNRSbeuPBf0kZaGBkUfqoumdZFTjM2esKVXvCdnK2u9yR5Ohgrj/r6fUSk556/gxKgceWBC6g@vger.kernel.org
X-Gm-Message-State: AOJu0YwtbGZwQ/O8bXbpcQPzHlVc+qulddXr6j+u2Pisl/+nDOmS/Kxs
	QlXf72rM1iKtUk67/XywtIxFE3B+7mxyEv2GLqsvSLEp9rpPgn+UYB9e3wU3bNY=
X-Gm-Gg: ASbGnct8KCe+dVOprW64zOQAUF6VKTa0ztQBgrPnZDqqLW6WSA5DBrX45P2zeyHK4pT
	wT310z7cKjb+7n2fVWBVvDU9Mp6Ls3m7aHPxpKNF71cXn/CElzsz8+1dNl5MSPegfSxNVQcuZna
	GyJxqTe50eRtqFPNbvuIHSZy4Yduoh6E5CE5LnurdjySNXlLFPlcuCcPXNcnrhHDYW1DB64bCn+
	uvcwpAyF9BosQo0dfTzp3QksmsHBsxkkZMoHX3AjWGyojEIxFr1wJJEaedzzULddxAjvBp7O1Ku
	cq3zuOBBtNWEL4awkF+nNU5Vaz9Pa0lpGFsd
X-Google-Smtp-Source: AGHT+IGCw7YI0VwXUaJOhTTXhq+5CUpVc3QK44ok/pfRUUn5/8pAwoa3rui6IEJI1Cs8q8CQFCS0QA==
X-Received: by 2002:a05:600c:4f53:b0:434:fa73:a906 with SMTP id 5b1f17b1804b1-438918c5d0fmr25212915e9.4.1737123542424;
        Fri, 17 Jan 2025 06:19:02 -0800 (PST)
Received: from ta2.c.googlers.com (169.178.77.34.bc.googleusercontent.com. [34.77.178.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74995f6sm96764195e9.1.2025.01.17.06.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 06:19:01 -0800 (PST)
From: Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH v2 0/4] soc: qcom: ice: fix dev reference leaked through
 of_qcom_ice_get
Date: Fri, 17 Jan 2025 14:18:49 +0000
Message-Id: <20250117-qcom-ice-fix-dev-leak-v2-0-1ffa5b6884cb@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMlmimcC/3WNzQ6CMBCEX4Xs2TUt//XkexgOBbawEVttTaMhv
 LuVxKPHbybzzQqBPFOAU7aCp8iBnU2QHzIYZm0nQh4TQy7ySkgp8DG4G/JAaPiFI0VcSF+x742
 plFZ1aXpI27un1O/eS5d45vB0/r3fRPlNf8b6jzFKFNiWoyqaui0aJc4LW+3d0fkJum3bPqknG
 Aq7AAAA
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
 stable@vger.kernel.org, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1737123541; l=1839;
 i=tudor.ambarus@linaro.org; s=20241212; h=from:subject:message-id;
 bh=tkyMhbw6EAVau4B8wFXwelogqHkWruGf2uFflN3bC8I=;
 b=/lLm7fsT0SR1AKSSkaj19CW0ov5KzhySppO24nZixmitP8Op/49SqDHnUDiHXBOvOxuMjXMi0
 /nzTVHwW/L+B0WxB2dCQKvfduMq2dYwJA3pakYRHSjND5TK9rqCeu7L
X-Developer-Key: i=tudor.ambarus@linaro.org; a=ed25519;
 pk=uQzE0NXo3dIjeowMTOPCpIiPHEz12IA/MbyzrZVh9WI=

Hi!

Recently I've been pointed to this driver for an example on how consumers
can get a pointer to the supplier's driver data and I noticed a leak.

Callers of of_qcom_ice_get() leak the device reference taken by
of_find_device_by_node(). Introduce devm_of_qcom_ice_get().
Exporting qcom_ice_put() is not done intentionally as the consumers need
the ICE intance for the entire life of their device. Update the consumers
to use the devm variant and make of_qcom_ice_get() static afterwards.

This set touches mmc and scsi subsystems. Since the fix is trivial for
them, I'd suggest taking everything through the SoC tree with Acked-by
tags if people consider this fine. Note that the mmc and scsi patches
depend on the first patch that introduces devm_of_qcom_ice_get().

Thanks!

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
Changes in v2:
- add kernel doc for newly introduced devm_of_qcom_ice_get().
- update cover letter and commit message of first patch.
- collect R-b and A-b tags.
- Link to v1: https://lore.kernel.org/r/20250116-qcom-ice-fix-dev-leak-v1-0-84d937683790@linaro.org

---
Tudor Ambarus (4):
      soc: qcom: ice: introduce devm_of_qcom_ice_get
      mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get
      scsi: ufs: qcom: fix dev reference leaked through of_qcom_ice_get
      soc: qcom: ice: make of_qcom_ice_get() static

 drivers/mmc/host/sdhci-msm.c |  2 +-
 drivers/soc/qcom/ice.c       | 51 ++++++++++++++++++++++++++++++++++++++++++--
 drivers/ufs/host/ufs-qcom.c  |  2 +-
 include/soc/qcom/ice.h       |  3 ++-
 4 files changed, 53 insertions(+), 5 deletions(-)
---
base-commit: b323d8e7bc03d27dec646bfdccb7d1a92411f189
change-id: 20250110-qcom-ice-fix-dev-leak-bbff59a964fb

Best regards,
-- 
Tudor Ambarus <tudor.ambarus@linaro.org>


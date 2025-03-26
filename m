Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFE0145B25
	for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2025 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742978199; cv=none; b=ams26VJOy91b7kHWPZmbAZmdzFkw3EvbdaREysPJbG4Jlam+aAXD9jT7HM+prtyek260cAZ8QFuQGGQb1PM8bf/BgBHUr7jgGFKXluot5s9RYSnI/fd7VrhmjZN3l4WEgJZdLlJ/U2UnNfwu00ae8+/QOasxUoQatAm1Hfb1RSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742978199; c=relaxed/simple;
	bh=qW0MfqD72uuYHhfTPBfmoh9IPsaychLi7eXpoJZr+B8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=bxu7Nbt4TmPUAFrBBJd5XBlxvmXJldUC8V7I9JCTd/hMrhJpz9V8QLGUITmZ5EbtklLGQ66wJ/iCvYN9RMzpQ/c2Vx3ANnwyWPHJY8F7nrTLvIUqqL9JwYpOOqqKg+BRZer9q12bpG833/F7ywTci1p4/2D8uQ39JVn3btbZIOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pCrSJ57l; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pCrSJ57l"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso41769665e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 26 Mar 2025 01:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742978195; x=1743582995; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iy2+7jXA7YG4CzY9gHuiVJnNuIcRimh4miDrVOlcZkc=;
        b=pCrSJ57l389XgX5DbMJjTqU8YwxTptSsnyC67pJGxt0haub74t6UXNyhxkNLi2SQuU
         +eyBFd1pVgoWmffXXW+1bf/1RnpDBQhFsa3PEwb4eWnjm1HyX2jaiZN75PaFYPtM6R4s
         uZ00npU57I/PbLDJux1gxbcKSns6j+aNtDI2k+a6i6oqoloMeiQjCcQMHbdbXT/bro9L
         bATqRiSdtH06f3E+0tGe6oU/AZsPkTKdVE8U9EumcxcwOXLyqpUGD5UIcqhM9mVzCX03
         ueI3J54krlk2ge3ApQDiT5j+tzvZBU4CpW3//FY3zK9m41dOC6wYtS9/ig8RusD39Usw
         KWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742978195; x=1743582995;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iy2+7jXA7YG4CzY9gHuiVJnNuIcRimh4miDrVOlcZkc=;
        b=vrnQw+n34Hxp0CQTzzTpbe18MioJI32Zx8fC0v2364PEXvXljS4lhgfo5LZutA5r1g
         KB1sDkrk73+Q3LMUg6VuEx+VSbN8sC2xnvO/MRJR/PJH7TqJx1psU71RMpxT1I8Z5rhz
         bT57LcRJngjOz9qgyZK/GnWVpNsuAZtLqEAuIuV6LfA2Iz5FXRJMSl+SEJ52nNApxHw8
         BwtjwCTxXOupQ/e5I3Q0baSjO2r/YddP5f29Kj1DSTtUWcgRjapq/T0ZfwFtly4Yz7B+
         XfhiDMmzRy/AhcZhy7VaQvqCPZuGnWNUbDJ1uhRu5VKVHMJOz4Cj+u4QfJlHZwiTJWD4
         G2LA==
X-Forwarded-Encrypted: i=1; AJvYcCW7kJ7xCg34qZjHeaQsPKUOz00TyF2Dg0WmkPjqAeFw63JhyTMyuQv6yQjqVgQ5tYEmJDPQICBnIO6f@vger.kernel.org
X-Gm-Message-State: AOJu0YwJgKe35AHJaGrmqc2qYGiHdYnHiPcecA0b6dLGw4tMrXVrNYLT
	XhyUtWsM+P+RjiVkwnlbwOOGCCktoNOwuvqnX52ujO2kUlSo7wcoPe9TpeEoqB8=
X-Gm-Gg: ASbGncvRyWj6FbWYOWJw8LsVHG4cH6ov55A/2laUvQBGOFBdrHOmVZqAD8KjNFoHFBE
	SquHNwTv7ilPWT8LJECbGII2LDNklrKo56OiiPxZV6rkVdWuBcMkQ7sAWcyOAeTAGMOQcBhWyOV
	BfZqg4Lwzi7gcNZXsfTLQ9eYJHMEULnEhXk7d2GX5XpQgefTWxynuFqUpmAjImzUBbNiIaiL+bz
	c4Wodbzqh1mrkcqTpP3iCfmSi9MD/0e186K/gPhZ5XpHYHckg7yZmdeZ7n/FMRUsJjM0wr10g4f
	SM4eNIdLie3X/q2jkOThzArPhdOu90fS4/aAFHiCjVXcINLRyTjeWkQWpWOOtPosVg==
X-Google-Smtp-Source: AGHT+IEkBse8k5+iznvBOzE/fliiY0CgZWEA0SCOidqUwsYgoXLyby4x3PPNA12r5TjnBrbnSRw6GA==
X-Received: by 2002:a05:600c:1d95:b0:43c:fd72:f028 with SMTP id 5b1f17b1804b1-43d50a4b226mr208496955e9.29.1742978194763;
        Wed, 26 Mar 2025 01:36:34 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:3d9:2080:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fcea400sm176823365e9.2.2025.03.26.01.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 01:36:34 -0700 (PDT)
From: Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH RFC v2 0/2] ufs: core: cleanup and threaded irq handler
Date: Wed, 26 Mar 2025 09:36:31 +0100
Message-Id: <20250326-topic-ufs-use-threaded-irq-v2-0-7b3e8a5037e6@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI+842cC/42NTQrCMBBGr1Jm7UiTGv9WguAB3EoXsZm0A5LUS
 VuU0rsbegKX733wvhkSCVOCczGD0MSJY8igNwU0nQ0tIbvMoEttykorHGLPDY4+4ZgIh07IOnL
 I8kZTWV+VXht98pADvZDnzxp/wP12hTrLjtMQ5bseTmqd/mlPChUerDFHtbe7p3KXFwcrcRulh
 XpZlh8NXryzygAAAA==
X-Change-ID: 20250321-topic-ufs-use-threaded-irq-53af30f2529f
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1611;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=qW0MfqD72uuYHhfTPBfmoh9IPsaychLi7eXpoJZr+B8=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBn47yQ5tVslE7udxPuo53IuZ9MtxZuvWreizAWupAA
 kPf5xM+JAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZ+O8kAAKCRB33NvayMhJ0ZkuD/
 42Y2CuSduot1byRoMmGnoX1TTktw6Ci1kYJGdd/PtNduNDHxrRJ3+5h2zrb0fxSDqBwUB1/Mxugrkv
 5m+cmF++9mDyBxwz6shfeX3swxJs/L+S1pqtvFte+PUr0uO7CsOuGTfr/oZAi98XETH3hzSG9doc3L
 FxSTI1A4bM0wlt9AhYV4V7CiNhFY35VdFfVjjYu5XD8g2O+PbUdjfQF9iSpsu+TS0dBu29MmUhriof
 1E9hNI3o/YCj6KI4QOhFOQ4rS3nw38TCm8cEARnxwkVqa+828hoCbcBO0rj+knBy2b02Kcgux1ILxi
 TkJKoxCDJm0yQsX5BS1g+UgOExq9VpZtt0bR+C6Lvvw2HK7SVHgXLOZKZzxaiMhrl4lbSfFAHPoema
 8Dn8l1c3DIS8h7Aqp+LUsV+KRJQfWnSuzi7S6+xQeC0IHdJwDIcjRhpJhuSU/I+C5ux203NvRzGzAw
 kRhGLsVawzx23hRC84xl+iEYd0psLbiYhAl+hKWEWJJjYApjG2B1kfd5/5Rmd0W2JyjlQWR9B3TjXT
 akr/mjFz9CUsOAJb21vLH8UuIBvLxUziSsoyYw8fk5oewF+al5B7NWuNeBIL1ICKcAmdP23fAbUXna
 bd0CtVeFBmg1IZwggM71Wqsw0hU+0NLXSP3Po9mRweslQefC+prZOLZSeEgQ==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE

On systems with a large number request slots and unavailable MCQ,
the current design of the interrupt handler can delay handling of
other subsystems interrupts causing display artifacts, GPU stalls
or system firmware requests timeouts.

Example of errors reported on a loaded system:
 [drm:dpu_encoder_frame_done_timeout:2706] [dpu error]enc32 frame done timeout
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1: hangcheck detected gpu lockup rb 2!
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1:     completed fence: 74285
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1:     submitted fence: 74286
 Error sending AMC RPMH requests (-110)

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
Changes in v2:
- Removed last_intr_status/last_intr_ts stats
- Handle irq in prinmary handler for MCQ case
- Stop touching REG_INTERRUPT_ENABLE register
- Link to v1: https://lore.kernel.org/r/20250321-topic-ufs-use-threaded-irq-v1-1-7a55816a4b1d@linaro.org

---
Neil Armstrong (2):
      ufs: core: drop last_intr_status/ts stats
      ufs: core: delegate the interrupt service routine to a threaded irq handler

 drivers/ufs/core/ufshcd.c | 45 ++++++++++++++++++++++++++++++++++-----------
 include/ufs/ufshcd.h      |  5 -----
 2 files changed, 34 insertions(+), 16 deletions(-)
---
base-commit: ff7f9b199e3f4cc7d61df5a9a26a7cbb5c1492e6
change-id: 20250321-topic-ufs-use-threaded-irq-53af30f2529f

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>


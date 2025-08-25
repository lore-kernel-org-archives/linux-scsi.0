Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EAC19D081;
	Mon, 25 Aug 2025 18:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756147277; cv=none; b=KBTfuTHGk/AWREcPM5YGeC6Uc8W2FLfsEtcskGT1rLFfXF+FOh3FvcUTJT0Yn/Pzbks/wz+YDx3QYn8uWvlZ5dUvlUorcE2TexR4WXP1Q7wCOLBnazYrg4eCTit+3qTSpM3hvnKzF4w6cdJXdgKKzy6R72ZhILUSndhjCHgcFgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756147277; c=relaxed/simple;
	bh=R+hnRo6vqHPwh1NzmvZP3vz3Qa3DIKd1T9XAuzIt6T0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dfeLAY9m4YS5gySi7PDnGXo8B8vXguFapDz4uLWw1NAVxCF52wFpok/rORH/jiwXFhaU30WuUMFkqh2HNkI4PywkHPRnhSw8DZX7eYfhn4/r8Yrvi7tY5P/A/iPNtC3MwX7KpnO/+tYi5lJbu0GQkq6lcp5mk7gGayRPR8g1Bic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N1+5gbEX; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1+5gbEX"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-325393d0ddaso2082421a91.3;
        Mon, 25 Aug 2025 11:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756147276; x=1756752076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GfxD7FsdTZBtjvRUIXNfBgoLkEqGJVu5BF6NG9G4Rp8=;
        b=N1+5gbEXVPYH1K0j3eBbVo6L7OjZNgVrnwDRwi2BomcCZJScwgP1eLVuxL4wKTW+Y4
         fzbtz6mTHzh9mSCi1iqhvXjMgx44ubRaBHkQA/KRyOUh+Pwwd+R5DMP9JWzFXpZel1nh
         HXbbJCzAwgkk3J3dAjs7nk7KWxKZggiSD8R3Pp6zovIJPnQoicDtsIjSt2W/6j/lnH3L
         D2U7n58NqQR/iS7hw4nVW5Au2pigP+evam/R2LxIkjVsdaxGtc6G+uUT0j19ANGxM7j/
         eZQyHRRilO3q15bf9U7hBz8lS0GkYjWS6I+A3ezl4saQ7O2L8cJ48sCUiR4Z/gga3Iul
         rVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756147276; x=1756752076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GfxD7FsdTZBtjvRUIXNfBgoLkEqGJVu5BF6NG9G4Rp8=;
        b=M4X1Euq1ysSvK6Kfy4+tw+gG8AITIw41/G20V55GoXzMlL8WRGMt1NvIiE/LHLBZyw
         ymvSDpOhyZ7v9FTyuQ2bswNxA3FjURBHe4v6WbORMmoXevkeJ18UeQC5M4IjUX57UBPl
         jWJF9YSFgDcaQH87+uWKUiA0yLNsLrOLpsid+80UgNSCybxgarAueL0By2OjykMH++KZ
         mmD8Mo/TdxQHBuyhvI/Z5SLKEC+ukyRsZ3qnOG7z1FbVz8Qf6mw3iAOVilaRE3zXSq4P
         wxzdTVpX1xmNSrHuGP40xEMFFCZ9sSiXOMaTsk57H0F+97ojr/6GjNFUZZL1qMy3MjuE
         2PoA==
X-Forwarded-Encrypted: i=1; AJvYcCWGAtdLD762D8nWdS+BeQUIOZN4ot0mujhshjmL7+yBv47ahLTY9jckuFxbe8SulScARcpSbVoqkvGeJnU=@vger.kernel.org, AJvYcCWOBB7Jor6ZUvv57XV29w0OKh5/PpxCJUDKrOkB/6UTdEfqnXeBQoIy6ZjwX15WvxAtH5NKyKeFvwnIHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtooG3d6pIC9a8g7EmS6gvJ/c2mt9lzMRYj4avndb3Ph7J17O7
	1R8rd8wMlPPWgvFnqQZ8JzrSboVhaebOvX6kMosQ+ioF0cqE774hslpw
X-Gm-Gg: ASbGncsw7q3vqaS2fVtuoBtveJ0uQojWlQr3WqciQbMfMHGIP/kW0jBNo8H30eKQJ82
	Bv4DXKjiFR6wQ88cRb40aRNVOsd8kI+aPRfQp5PmxrqrmQtZhQfa4gaTbbH5UmAF/8Yu81mvFHf
	dpsTNVs9tGJ3qooJQe2q4gXEGy2kkLgbfvYPgKSvOGrE8LP5hMOB3M+KbFxCBtiN7t/+3dJV4TW
	YucOglLWfhMkn56L/r2JqN3nYp1cUSmcTUM1SW9KPQdV0T1zPlpfnvKwtXgS4Hb0JodrsxZ8IAY
	idH1Si0yS60lVF4led0GyXp3ecqxiA1clVklZUQhzhdpOjvdxaD3tivm08Q9jZSCVAAzgHv6BwH
	tR46s7L/Z+iMWPH04mxiG4Nxh/43nItAntVF1bEhOJV1pez883uShPD9Z
X-Google-Smtp-Source: AGHT+IHBHR74v0GCDgx0UUm53HK/WUflxLL9nhAuFa8HO+gag1KeMoJmS12OjdcfbhXOGANZD1Lm5A==
X-Received: by 2002:a17:90b:388b:b0:325:40a8:56e0 with SMTP id 98e67ed59e1d1-32540a8583amr11414029a91.30.1756147275718;
        Mon, 25 Aug 2025 11:41:15 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040249e37sm8155142b3a.105.2025.08.25.11.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 11:41:15 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v10 0/3] scsi: sd: Cleanups and warning fixes in sd_revalidate_disk()
Date: Tue, 26 Aug 2025 00:09:37 +0530
Message-ID: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Hi all,

This v10 series addresses a build warning and does minor cleanups in
sd_revalidate_disk().

Changes since v9:
  - Moved the build warning fix to patch 1/3 so that it can be
    easily backported.
  - Added "Fixes:" and "Cc: stable" tags to patch 1/3 as suggested
    by Damien.
  - Moved the redundant printk removal to patch 2/3, since it is
    not a backport candidate and also removed "fixes:" tag from it as 
    it is not a bug.
  - Incorporated Reviewed-by tags from  Damien.
  - Updated changelogs accordingly.

Summary of changes:
  1. Fix excessive stack usage warning in sd_revalidate_disk() by
     replacing a large local struct with a kmalloc() allocation.
  2. Remove a redundant "out of memory" printk after kmalloc()
     failure. The page allocator already reports allocation failures.
  3. Make sd_revalidate_disk() return void, since its return value
     is unused by all callers.

Thanks for the reviews and guidance.

Abinash

Abinash Singh (3):
  scsi: sd: Fix build warning in sd_revalidate_disk()
  scsi: sd: Remove redundant printk after kmalloc failure
  scsi: sd: make sd_revalidate_disk() return void

 drivers/scsi/sd.c | 58 ++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

-- 
2.43.0


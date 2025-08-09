Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72954279;
	Sat,  9 Aug 2025 09:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754732066; cv=none; b=TZUfb5wLJysWLbpsSMGF5V5XihYcz+Hffh5w1vh11nS5zDe8WxQPGi5v0kXMwMderJy6FEHFKS3uf2YDKSJ/6mpbtuUUraM/d4WF1aNks0OQRhI7iuLG8gyfQO6m6eyu8K8H9VHNOZ5wBYqsZWc8mHW7EhHtACfFBe90/TM7pMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754732066; c=relaxed/simple;
	bh=9kFH3IbpdDiWi0KcPfRY/uynAW9w4+nIJYuXmNn5C6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p1DG6LO65EMTW4RdXNMFJ0rY8of1zTfe6vlBvRceA1bjFDMLCMn6Q4FV0PXEFo8MpSYrugnjqJWczZbUjTLl2yDSTogxhqauPt03+75lVy62cACG5lhdoq+Z5DvcYVxiZbZNvuiM/I0bCExgXrV7/3IsCj41dbncR3QTjpiVkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Udwbhb08; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Udwbhb08"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76c18568e5eso3189459b3a.1;
        Sat, 09 Aug 2025 02:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754732065; x=1755336865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h30n2QnGq+LUcM2n+2uQ8ZZxtd7mZCxFXJa+M3jXHx0=;
        b=Udwbhb08gwLnEFc90RE9gx8U9966lzzuPqxbITM2xPCXbNc9r/QB4HBvfso2sxiHO0
         3sp4+6ll+MMBG9rltbSBl3BCfA40AKzTV0GxBaeppiTZSCrT7R5Xpg1E1zwLkp6EjKcY
         72yvHWlzfYVOvjAYeCoEfHCoRm7I6fp4ViGjaD7CJmt7kafGv77/5Rsa50l19tS70zub
         GwJrJ80+PH/A4Ul0FAPrh+6t/Q1L2drYnIsx8ujFlasDMjPCe7euDVNl0RU047puh/3Y
         mcAbg0YTEzvcxFqJ+NqELyqttfAJ5nWQK75bIfwj5enK/dgXde1ir3MqNxUAvs48P4Ia
         3RsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754732065; x=1755336865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h30n2QnGq+LUcM2n+2uQ8ZZxtd7mZCxFXJa+M3jXHx0=;
        b=PDtjPRYKQrhHN55ZyBTfQjH60/6PXzZ+pyA9HqT+Xx3FMVWm/pJHkCIjyATm1a8wwL
         1FHR30luSVy0EPD+BfxnJlfZYx0IrbYms6PGHN1nvHgrEOTyix9e2E4wWTkaabldMe7Y
         kVGt7p2xaox3+ScEN8fDeWDr4oq4EzK9LDFnm/ko4y9unm2OPkhz5oFvGQdWrnk2nHfF
         +P18/2IdrF5jWbSpolH49iIpDSvxz3vN22mpqkLpyiblBFZ+aAFGPvojXxZKyhY7eGJp
         rF4ZwwWCF/7TWmbl7JhrHMNuDdtv8CkEAPbccF5StQUGVpciuISdFnKq3rKq6HhYExul
         1r5g==
X-Forwarded-Encrypted: i=1; AJvYcCWuH2xnYD4W92/blYD/F8Ky3jNo6uo1UDKPqrIpLMZ9iOtL3HA3vR0ZCm33T9ek+UkTj4/cYltkhaTHgXQ=@vger.kernel.org, AJvYcCXMiOZ16MuZsnDLXW9mQiNORC3K0UCEnemQ4Jn6HX/c8d53FZ81MHp/lW3gna8LCWILy5ttuPo+ahZe+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJN23qLXOD2X9uZKfdYBFi/jR+MKK3D6ri4jO5KC+/KcnIY6eN
	CZnrTfy5L5TAycFn0ZJCGMLkb1bOafPApecJL3fDtSUpZt6KGiCCgwWu
X-Gm-Gg: ASbGncsWOl7dClFJyIe8l6vd17qqiietaEaplTsViVe982fcy/UZki/3CnEPWZnrpxT
	S1cogg7JlPgcUUtiXGfGqtdE57uerXFpxPWCb3j45hDouGYPybvpTCUdCcIAen1tvBozpG0Jx22
	/cdYiS4YdpI+AlWnwEjup5FEuUMmqyjNXRUGG5GwiuaGBdgyzXukdGsyMVfdkHKLUxdngwNNpr+
	ds3EhULyXUElbA8b4uiR5VVg5OHTQYcNtAQdawnmvVtzoWELy7utza5v+DbCmaS36KKhN/L2uWR
	z3PuJz/Dvr+nSQK4YDNK9zYwxWeu+LgRUpevZm9SjTrY2ML38oG/C4AoCqQFOhxfUaJ2g5rfYgQ
	scuKPwPfwRiU3jTICfNwb96HctP9Aw6on
X-Google-Smtp-Source: AGHT+IFOj/dihK1qyItgxwSupNeccLmvTHv1JmJ0R2zZLZTK3Iu9p4jtKGnCeYYEEkwuLJ7AfPLlSQ==
X-Received: by 2002:a05:6a20:9146:b0:240:413:bda6 with SMTP id adf61e73a8af0-24054ffc1ebmr9749292637.9.1754732064575;
        Sat, 09 Aug 2025 02:34:24 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32161259329sm9823438a91.17.2025.08.09.02.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 02:34:24 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: abinashsinghlalotra@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v6 0/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sat,  9 Aug 2025 15:05:05 +0530
Message-ID: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This v6 series follows up on v5 of the "scsi: sd: Fix build warning in
sd_revalidate_disk()" patches.
In v5, the change was split into two
patches: the first patch refactors sd_revalidate_disk() to return void,
and the second patch addresses excessive stack usage by allocating
certain structures dynamically.

Apologies for the oversight in v5 — although I built and tested the
kernel locally with the correct changes, I mistakenly sent an older
version of patch 2/2 that still had `size(*lim)` instead of
`sizeof(*lim)`. This caused a build error reported by the kernel test
robot when building with clang.

Changes in v6:
 - Replace `size(*lim)` with `sizeof(*lim)` in patch 2/2


Now there are no build errors.
I am very sorry for that .

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202508091640.gvFPjI6O-lkp@intel.com/


Abinash Singh (2):
  scsi: sd: make sd_revalidate_disk() return void
  scsi: sd: Fix build warning in sd_revalidate_disk()

 drivers/scsi/sd.c | 54 +++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

-- 
2.50.1


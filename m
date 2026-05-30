Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CB72E7384
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 00:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100440; cv=none; b=DsNzTGT65DCRRPWNpUrTyYZWHAf2DqgEgrHWNajvJT+FwlW3jiwxnBoF6IDNW0Gkmn3JUmAgBhT2+l5rmwKKqDu92yf4BdlNBtIaXRPEXORRNtfsQGhwu7rbhI2IJyGrz28SR4swaOtI2Eoh+TORSHqwzmpIUO4NyvHQpYS4fLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100440; c=relaxed/simple;
	bh=eJ+uucw5bIpeK/tp8BJOH4QNUYevWylHEnu2k3Fypew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=er5ccCOTzZLm3Ii+p36syOMjK971434T1EwegBwSCklW452FIOZDedIOiMiSXxWhTWpxIQMySXe2n6+R9lcsnNZKw4yVPqNKsTk6xrFLO/rkVaK9bPIk6te8vPcwgoz3CDUfKsCHuizFubg+GEie0QNOBFfZFEfLCknztb5eU0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JU+0Gcnj; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JU+0Gcnj"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-137d464c47eso240805c88.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 17:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780100438; x=1780705238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1o5Rm22yo0qsNymLIksrx5uoOUGctGMeo3s3MdOJIc=;
        b=JU+0Gcnjh8sv21LtorYbMuXjcSxUT41S3w8/UV43RZBN75sAyFkedBN70sR+1tLPAy
         /UsBflETdbC+KHBSQgpBOBfDl0Uz2jA2SquYYlkmWhheUu6SJqyZbqWChpo6BWuCLQQ6
         3UbMuhBF9ZVqfrD3c0h9LOMtPSrsTu2ZjKN2/LKPm2/A8rq5hTSZFUNl0CotM5IM1ZGo
         NA93FQ0MOBvynz1gzjLilN6eUtuVyQgp5KBzwH29t+ew8MJ2CDg9XAVxsoe0lBIQSVah
         J003+Y7cls6XzFY353aO057FfsVPt1+Ua3g/57mYsMYMsA+9NGQ7FdcI3zlq2v4Qhmsv
         Q2uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100438; x=1780705238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T1o5Rm22yo0qsNymLIksrx5uoOUGctGMeo3s3MdOJIc=;
        b=QuIuVqVfIf4yudknuWWP+fbVnj8xAxgVT71WSZ05h7kHFewlzwsNVgcUK6EHjzIk9L
         AqPfGjIEXu3UVUGvRP/5kAXq7bj7BTlNzymyqq3sNtKX3jRLigM6YKDZeoFLmEUZvrhB
         NF5zVya5o3H2FTS/zoHfpnRbc9c6d+GXgjFM6c1TzQBsT5XC2gHysgWAwCvqHdNZDrcK
         W9q30kcNW3Vs626tgxJDv5Ah+8BVk7KPRsLzVlHU5aWIWp4Dqto5gLDArqKKC88asuYG
         xRdK+rIaf0sDUKjEWByl+G00ZH4HN/zl3rbjbNIsdpgCWKRKoD4KpExGHl4Q05p+vMve
         EaYQ==
X-Gm-Message-State: AOJu0YwTK5t9E+nDQjfz5s1CtIPoudz0NnSYWK5rUTx8G8FJRjO2KRZr
	leT3PLVk8G5w4WTdmrc7RRmH2p2aG0CxburJ1vVe5BP5Ddo6d+wtnm/b6setlJbGUcflsENNHc2
	9rJEKJL+JZuBoaKg7M0MNq5bITP+uaNg2EarwvQsQ4dl12fGQVrdi2LAblgmy3TOrh+hLGICDjO
	ZGnO/1A1iP0G8GgojuxcT5jzJsYtAQ1uPg+AB/7vf7nUvnXH97Hw==
X-Gm-Gg: Acq92OE5Mpjy/17X1WXvHvafZQyufG/pNczrhuJWmDYFSxFZMEW1ENjB5HoEQ4WaF+Q
	WLDeoFPszS05wSYrdJDg0afnn/OiFdA8fb1Biui59BH6O9iC5WtZR68Z+Fx3qq2MXm6ZvKoY1wd
	ZYPaeRXC8P77ivLhsbA/dLDlIfJqUUIGtwP5Ni5WtT9lzXSlkpblPGGkRSqcSWZmH3O9oNT9GcG
	bPkkNiOOSpjLL0iDv04D/vFsuyOZZpXlmQDB74pYkEr881q6QpcwHBkdsp+JGi5bZ3GaOd1+Alp
	jQpGk0DK/rBZT6uC+VM09lObco/8qX1pyy0cILHdNF6mKTyZIA6Z9jtMs71Rr6cogZGSUs84Y6Q
	I3IZOazCvi91FuBxbVKht4I+WcIwUAWO89Jh+aS2XUFk4/ry5lIaFmLI+08ugoiFPA7tsDm0uQn
	nqKOYR9qmY4ohtqaUL1mVy5X4QsstbeoSsz+x62gKNWVpY3U8wWImHFN/Ii8TZDDOZwIjmZe5sj
	Op41iG83gt4r3D1+ZfyaRUCeQf/YWgIDlkUanqG2Zl6wbzT9uuwF1ljwRqpLuUT7CEjQnirdiZQ
	LfvH+OrrFJr6B6lKhGio4g6sB6KDi10DhLXF3Np+m/uGSA==
X-Received: by 2002:a05:7022:521:b0:137:1b05:3bd9 with SMTP id a92af1059eb24-137d441b950mr602508c88.10.1780100437892;
        Fri, 29 May 2026 17:20:37 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm2027163c88.15.2026.05.29.17.20.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 17:20:37 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hare@suse.de,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v4 0/5] scsi: Refresh INQUIRY data and reprobe on rescan
Date: Fri, 29 May 2026 17:20:14 -0700
Message-ID: <20260530002019.47109-1-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260429224939.77082-1-brian@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series teaches the SCSI rescan path to refetch standard INQUIRY data
and reprobe the device when the response has changed.  The motivating
case is an ALUA target that transitions through the "unavailable" state
and afterwards reports a different peripheral device type / qualifier;
today the kernel keeps the stale INQUIRY data and the device's sysfs
attributes diverge from what the target reports.

After v1 Bart Van Assche contributed a patch that added named INQUIRY
field constants and a Convert INQUIRY information refactor directly to
mkp's 7.2/scsi-staging tree (commits b1968f46509e, 28ff38b9d8e1, and
20fd1648f353).  This series drops the equivalent preparatory patch from
v1 and builds on top of those commits instead.

  1/5 serializes the INQUIRY-derived sysfs attributes (vendor/model/rev/
      type/scsi_level/cdl_supported) under sdev->inquiry_mutex so that a
      concurrent reprobe cannot tear the read.
  2/5 adds scsi_update_inquiry_data() as the single point that copies a
      freshly-fetched INQUIRY buffer into sdev and updates the derived
      fields, and reports whether device-identity fields changed.
  3/5 refactors scsi_add_lun() to use scsi_update_inquiry_data() so the
      initial-probe and reprobe paths share one implementation.
  4/5 teaches scsi_rescan_device() to refetch INQUIRY and reprobe the
      device when scsi_update_inquiry_data() reports a change.
  5/5 wires the same path into scsi_probe_and_add_lun() so existing
      devices encountered during a SCAN_LUNS pass get refreshed.

Changes since v3 (patch 1/5 only):
  - Use sysfs_emit() instead of snprintf() in the new show functions.
  - Use guard(mutex)() for scoped lock acquisition and drop the local
    ret variable.

Changes since v2 (patch 1/5 only):
  - Protect all INQUIRY-derived fields (type, scsi_level, cdl_supported),
    not just the string fields (vendor, model, rev) and binary inquiry
    attribute.  If we accept that INQUIRY data can change, we cannot
    assume which fields will change.
  - Replace the sdev_rd_attr macro with sdev_rd_inquiry_attr_int and
    sdev_rd_inquiry_attr_str helpers to avoid duplicating the lock/unlock
    boilerplate across each show function.

Changes since v1 (full series):
  - Drop patch 1/6 (INQUIRY field definitions and helpers); equivalent
    work now in mkp/7.2/scsi-staging.
  - Simplify inquiry buffer allocation in scsi_update_inquiry_data():
    the inq_len < 36 guard guarantees inq_len >= 36 at the allocation
    site, so max_t(size_t, inq_len, 36) was redundant.  Use
    kmemdup(inq_result, inq_len, ...) directly.

v3 cover-letter Message-ID: <20260429224939.77082-1-brian@purestorage.com>
v2 cover-letter Message-ID: <20260429012733.40855-1-brian@purestorage.com>
v1 cover-letter Message-ID: <20260424215324.99045-1-brian@purestorage.com>

Brian Bunker (5):
  scsi: core: Protect INQUIRY sysfs attributes with mutex
  scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
  scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
  scsi: core: Add device reprobe support to scsi_rescan_device()
  scsi: core: Handle reprobe for existing devices during SCSI scan

 drivers/scsi/scsi.c        | 191 +++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 339 ++++++++++++++++++++++++-------------
 drivers/scsi/scsi_sysfs.c  |  28 ++-
 include/scsi/scsi_device.h |  13 ++
 4 files changed, 445 insertions(+), 126 deletions(-)


base-commit: 20fd1648f35399f114351b67c14ff8d3233a30e2
-- 
2.54.0


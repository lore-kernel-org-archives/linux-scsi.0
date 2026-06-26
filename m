Received: from mail-ua1-f100.google.com (mail-ua1-f100.google.com [209.85.222.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75FA2EDD6C
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474505; cv=none; b=L1Uu14Vl1ncHjcHf3gUQ77SjEyzgUAGBtFtnces5euraN8XorokwAtLTjyulXVvk3oXKznV8erE0fG9D1rX44yjR13yamthHdBBflzl7eIKyRk/BnAViR+ifd55GF4FN9lY1IDkEn4LyPgOp8AjZm0cncjuEKh5e8Sm45N2M2+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474505; c=relaxed/simple;
	bh=5aXTJAQu7mAXOySqJx03dgBCHAqvKr+deQJqbxLHEYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hNUpOihgvT9tO0Tzc4WsFSnsW53u01FeWJAWgB67LSkYkYlVZqDrw6xphhaGqncTXuZ902DOXuuUnfTjNFTeAlfNyoTw9OVFJXtJl9/eRDFO2K6PiOKBwWj9+IPi5zSKklyxMV74UlFM5boG4xPWuzLPm0Ai1c9fefKa3Giaar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=gq8TEGq6; arc=none smtp.client-ip=209.85.222.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="gq8TEGq6"
Received: by mail-ua1-f100.google.com with SMTP id a1e0cc1a2514c-9673385b1efso378152241.2
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474503; x=1783079303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jhfISzBSp/kI02YNAB1t9kMqfUWdoRksqO9YkL9i4Ks=;
        b=G9hqSrqIeDGcEvJl7/1v4oa63l5AbkDN8YQVdlbNZHbNlto4qO7eJuEIAIuZujV6C+
         oRiXOJT+vdP29hYA9xf/tmNDqRMOhSVKwM80lECRtSgUID6MPfwKAWsRTiTzf6vNXn7f
         j52V607s2H20+z0R2dG6xstpyGaynSW2ytPzvrwqtvsirZwbfJMn+w8nHW+uWizIaiNy
         gsaeEBSYBNiJ3y0AlSdUH62mTc+prtXU2Ox+xND13NzXMzZIiU7BzPvWqGXu94inI52M
         6CYgzLWSynnsnfpLSDXt3lv4n6Vf8MkNXs6jYBMWcmzvWaBdhRqDA5/FUE8mXvU3vfkq
         kw6A==
X-Gm-Message-State: AOJu0YyMc1J3xWuzcsjv8h2dBz98Cs0PjOcEuAfchdUYCZo9R6jhw5ap
	aUgdXiBurrtDOU1/xPbadN0lcwMQqm7PfzO2WWKGe97AJTCreQYd3D8VScswi37noZg3lqU8VXJ
	TeZl+xaq1kKrLTiIF7g5Jz/LVfhy9SOcD5BMJfWlPL8H2jnZnfttTwXAHVEBOs588oaYicioREi
	+F7tRMVRGYiOZtNoL8+ooykvR02w8nTQ54iwfoSKj1DtkXJ3JLimHzL1qBz4nmzerhXyb37ZQmQ
	VM6EtCixyyL51LU
X-Gm-Gg: AfdE7cnuCRX7OEonMQHnOaP9Z995t/uv5EQiF9rK42JbuYjF2gTZ5sQl2Js6TlyRTuk
	ZEbzjFZ3RAGmcKW+2rtKIwyM7/lyFt3MH/EWfuekXD2ZVh1NgHHiEvOfr+FhXrIyRgGLucJWBz9
	k6f6eqUQzIOLR5PmklNs+8xFmKp8fyb04iESKQxClJOuh1a1/Zxwlr46kUBLMp73g51PIsclWfe
	SIA4/F3ukKuexe5cXhbDThsj2wXCkoCqH1GqXPNq6SyUbKsm8muavBGYFd9uUpObI8iy00AHZMM
	3SKAC/CwMnSacqKdMAl4aL0PxPkghZ927+aHTx2pH7SZ61p2u7OT4R8oBXLC4MGjF+TiPdSyqpP
	ye4GPm5wrzaYEEI1iX4CjYkRN4KogXE/JPJGnIs3rSHIEht+Ag39szSXp6QfKQRYyVIbUpVUlZt
	5o/IY3BaBnI4c1HK/QohYDr+u42V4ObrsAAvv/yE/vBM+jOOJK
X-Received: by 2002:a05:6102:570b:b0:6ef:db57:ed3f with SMTP id ada2fe7eead31-7343700a3e6mr2691432137.29.1782474502682;
        Fri, 26 Jun 2026 04:48:22 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id ada2fe7eead31-735668a011bsm201533137.1.2026.06.26.04.48.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:22 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c95b0e22aso2483333eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474501; x=1783079301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jhfISzBSp/kI02YNAB1t9kMqfUWdoRksqO9YkL9i4Ks=;
        b=gq8TEGq6I8UwihEKGePZOqGfgHFkLXMyoRt0H1rFr1u0NcN4SylK0NMgQlD0+QWyDA
         OFZh81CwzXOhP8AA1JnIrsyvZOvA+eJ7UiJn+YpH9URc0pUoGqmVvCBCspF7iFHxxXe9
         l6Rf0AGGJGVWvVtDxau0Ripof9n+LZgpDlDio=
X-Received: by 2002:a05:7301:37c4:b0:304:ab8:f899 with SMTP id 5a478bee46e88-30c84bcdac4mr6683256eec.8.1782474501547;
        Fri, 26 Jun 2026 04:48:21 -0700 (PDT)
X-Received: by 2002:a05:7301:37c4:b0:304:ab8:f899 with SMTP id 5a478bee46e88-30c84bcdac4mr6683223eec.8.1782474500851;
        Fri, 26 Jun 2026 04:48:20 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:20 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 00/10] mpi3mr: Few Enhancements and minor fixes
Date: Fri, 26 Jun 2026 17:10:59 +0530
Message-ID: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Few Enhancements and minor fixes of mpi3mr driver.

Ranjan Kumar (10):
  mpi3mr: Skip device shutdown during unload per controller
    configuration
  mpi3mr: Update MPI Headers to revision 41
  mpi3mr: Add early timestamp synchronization after driver load
  mpi3mr: Fix NVMe page size caching for non-operational devices
  mpi3mr: Fix performance regression caused by extended IRQ poll sleep
  mpi3mr: Fix memory leak on operational queue creation failure
  mpi3mr: Fix firmware event reference leak during cleanup
  mpi3mr: Fix SAS port allocation and registration error handling
  mpi3mr: Fix SAS PHY cleanup in host addition error paths
  mpi3mr: Driver version update to 8.18.0.8.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      | 77 +++++++++++++++++++++--
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  7 ++-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 15 +++--
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h |  2 +-
 drivers/scsi/mpi3mr/mpi3mr.h              | 12 +++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 66 ++++++++++++++-----
 drivers/scsi/mpi3mr/mpi3mr_os.c           |  7 ++-
 drivers/scsi/mpi3mr/mpi3mr_transport.c    | 34 +++++++---
 8 files changed, 176 insertions(+), 44 deletions(-)

-- 
2.47.3


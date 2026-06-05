Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4823A38F636
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2026 17:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780681492; cv=none; b=Ii3X7y0/vniv7OQG9OJHXTS23K0vw1Rlq+zgwGTlZcaecit3JLR7U3sWIXvHkUrqDclmZIuaLEIFkIGQMLA+Rbt8OU8lug/xM8iHnToyoZqjH+Cw3zNP45Y3e/OSPb/t/G/Ky8awGVeHYBJYCUk8+3wB71YnEINu+FG0IBqskrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780681492; c=relaxed/simple;
	bh=gbD4FCJy0BQ4W1zXJKiTk9oj2celhkKljTujiWAVRVs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VZbUwG4tZEbzdGLp45zXTQTPas71k42WExPbrJVZYJdwNeFnPrM9q/BVN/kHCMseX1xUknKuw4DDCDITdHHTMTY2GLa51UU4Yj9Pr6I29YmEPGvQOl80UkNrobs+mALDl0p8aZ5W8U2UA1zci1UeT+4vcmB2QENIvBrZ8NT8auA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YBz/UsI4; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YBz/UsI4"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-517907feed0so15441451cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2026 10:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681487; x=1781286287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=o1nKnoCKwwPu7b7Objh9jn1z5sqhtLDS46+7PHLh/Ds=;
        b=YBz/UsI4b/P1hmKUmEq8UkAexP+8Qnr65gKLVFbsohDoehX0wB6JwNq7qW1GUSGPmd
         LEGnXbWGltSHRCHVDcrsIuaOMhAESWVAkabeQ/0tZLIgtWg40/JGYPBs1+Zj0oCXX4on
         VZEdwZZBP54opTiZeRHLW/5uwB4Tm/7F6wZWSf1IQoRW3unoGfDiiN24Swai9CAtRGID
         hez5tg32jgTbp9YJleCzy63MP49NKCWvuJqddQZ1L5PvMbpdx4prjv0C8SEOOFf+s/ga
         198RJQf53twcsXRc/zMKpXzaGMZAP7JFcgzK8HjcCWXHYHiJlWCMz4j54CLdDPfFOTUh
         vfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681487; x=1781286287;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1nKnoCKwwPu7b7Objh9jn1z5sqhtLDS46+7PHLh/Ds=;
        b=OXWYFwF6ZrXO+7EuKkybOxXvExvBnT3X4UdqjyIHSt+M4N4C6G6ZcwzRaWkNIUmSrx
         wlzTCkRSu7o75L4sReufbDvQ5DgcC9L79NneUYthYayEzVo3+yrITtvwlpXN/X6KU7nG
         Oey7iiUNYrWDJNDWF7Q744Jpj3JOjjiEQ6Gxm42QChhXyQdQ3sZP8zRolRQU+ZW4bU+A
         6sKZQEdSsLWlxkkEfgrUmu9//y9CbaiCprayRzppJgU/rQ+ubapVXiXYxphCEHM0vVZD
         6aPk5rHAkCTYv8tNVS3x3vPyjutpJLCKbr+jYs3hgyF9tw4Nq8nX8e2XpAfo9x9ZKo5E
         bYsw==
X-Gm-Message-State: AOJu0YzxqT/TL/igtfbuDbWH2Y/j794cioNRy2PSx0ZEEXRDBGwQWLaU
	3l8uiWZ3zK9mJ+RXv40KwReDPuohCRFGk5bJdQ6WzM/Lk2ZWVWLUqCgEynwW+iF9
X-Gm-Gg: Acq92OEYd/xSdPuUlOKJ1f5vt/FXGPvkI1iAzYVVLpgRNY63WhQDRBuWYzO6Ax3hVpV
	z9yMG5d4GxLgM2gUv0jE4X1TtHkPH/i5zMvk/eV1cSpwu9OWV2gbQ9tTrC4zWoDW63c2pescu/i
	1rYo7DkAyunN5yAZpnBGdw/m4aJBnyk6WkOb4zZ6yOJJDSt3WKkG2c2vKFLUcL/f8IO5sceHZn6
	6xx4HcR0Gw9Z09DUhxu40Oyrw3qz0YuLL88xBdDlSkThuqZH3i6n8P2sTbgCTwa/q6F4nplM+uG
	npePpbQlPEMENurDDfNeE6EVC1tkWjf+N9Cl2VPG7B9ZsVgo2HQM350TEI5OXyz4iSV36mbrclZ
	C+khW/gPzQ7lb+WprgolrMmrk0pdD/Q5CUj61foY8SK8tUavVmSm6bJhmhnXEUq5p7sjEVj9dIa
	ki77VJdlNbgksRQtV1GvJLEWl2Qa6IUz6mRphP+kWHW+rDGEAsHrYw3FypcBq7BbF5yVRS6NUEB
	S9QgCUT2HFUtX5DopuG4ivdAy6sLyHFEjmfnYCRzDDu+7DotP8ZQg==
X-Received: by 2002:a05:622a:1f8d:b0:50b:2542:e16f with SMTP id d75a77b69052e-517987a918fmr47974111cf.15.1780681487223;
        Fri, 05 Jun 2026 10:44:47 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51789407da8sm53376171cf.19.2026.06.05.10.44.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:44:46 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 00/14] Update lpfc to revision 15.0.0.1
Date: Fri,  5 Jun 2026 11:23:22 -0700
Message-Id: <20260605182336.134919-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 15.0.0.1

This patch set contains bug fixes related to cleanup handling in both
normal and error paths, discovery rework for large SAN configurations, and
refactoring of duplicate code.

The patches were cut against Martin's 7.2/scsi-queue tree.

Justin Tee (14):
  lpfc: Fix use-after-free in lpfc_cmpl_ct_cmd_vmid
  lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not
    set
  lpfc: Fix kernel oops when unmapping scsi dma buffers for an aborted
    cmd
  lpfc: Check fc4_xpt_flags before decrementing ndlp kref on FDISC error
  lpfc: Add handling for when PLOGI or PRLI is dropped during link
    failure
  lpfc: Fix ndlp use-after-free during repeated RSCN and rediscovery
    sequence
  lpfc: Rework I/O flush ordering when unloading driver
  lpfc: Improve PLOGI retry handling for large SAN configurations
  lpfc: Send inhibited ABORT_WQE when PLOGI CQE SEQUENCE_TMO is received
  lpfc: Remove slowpath cqe process limiter in slow ring event handler
  lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL
    unavailable
  lpfc: Update ELS ACC logging for diagnostic troubleshooting
  lpfc: Refactor calls on fc_disctmo to lpfc_set_disctmo in RSCN handler
  lpfc: Update lpfc version to 15.0.0.1

 drivers/scsi/lpfc/lpfc_bsg.c       |   5 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |  12 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  19 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 427 +++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 100 +++----
 drivers/scsi/lpfc/lpfc_init.c      |  16 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  86 +++++-
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 246 ++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.h       |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 13 files changed, 707 insertions(+), 216 deletions(-)

-- 
2.38.0


Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E01073F2A
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638335; cv=none; b=BzpldP2LIzEQ/w5I7IUq7s1c7orLy3XIG4iuAkcL+RrDsIb6MVj+p/E5+sv90yNHleAL4w9RXgGpy2k+TPtUljKj+qejqHoddQvGfcMFc1TU2+Nw0wuPNesMAkmymQ1AP2ftADyyykpaNSVqOBD1kTjphea6PD5EzUf5TgNsw0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638335; c=relaxed/simple;
	bh=pNWJ0N/oU811ln6XjE6ccGcxB0xHSmz/H8UfazqF9Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xf3TtmKQECvqD6HMF3AnhlU8XvX7w7iPi3N2tJkSOjVDgzGTWtaZD4dGjeICgMwhEhi7MZV5vowUFr2gZEy/I2N9z/JJ82tyd+z0coXzvUw728QZYpLKI2r49WCtvZ+m4sHAxLHNCqft3t72QqFlZQFukU0akmIYS7YE0vull1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e471caaa71so98398b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638333; x=1709243133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vpSpyC7JgtmkB5qVO34atZ81+aHvh6w/pNdfi44Gk/E=;
        b=m2Epsp7QRywYIr46I7B1plo7CAdmqQwoKXi6y8wcswdN0YNy68H/syiOX3DH/daBcO
         ME3JkAD/9lhidhYAFcEumeeikFV8c7NGiXT7mEbSOTSXV/vLYdgKMbryzqJChVR3Ro9C
         LQKkW0VYUK/V5WhNrnPlXBs6D4+9zQFLzL8brAalMBcdQqGkRwyTub7slmRmxnEYwlGK
         oKTtLV+axb8aU9RbtYf9fWNjNVD6kZwD5jb9826rlrAcxTBhN2TYvMvX2dDKAPMELHGj
         eQzaH+orQnO516ROtnFBNTW2TJx0XuYg03ax29JSFkKh+zc/PZUAeWgcE2ztwYhX8Wjb
         LSjg==
X-Gm-Message-State: AOJu0YyZXqmfCDHv9HtLYo85/8yNMQrypKf0cEnQa7QozqgJ8KN3DFwr
	ipDO3jaRskO6velkftF7Iklxn+bTN7onl2cAwoqPvydkVGMN2x+F
X-Google-Smtp-Source: AGHT+IFpBG1drC6nKF77p8x6er02GQu0RNwUI/aCKlv831Ycw0AZDevrI7ZZgflo/GmQYlGjEUA7cg==
X-Received: by 2002:a05:6a00:22ca:b0:6e1:399b:fac3 with SMTP id f10-20020a056a0022ca00b006e1399bfac3mr167260pfj.25.1708638333247;
        Thu, 22 Feb 2024 13:45:33 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:32 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v10 00/11] Pass data lifetime information to SCSI disk devices
Date: Thu, 22 Feb 2024 13:44:48 -0800
Message-ID: <20240222214508.1630719-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

UFS vendors need the data lifetime information to achieve good performance.
Providing data lifetime information to UFS devices can result in up to 40%
lower write amplification. Hence this patch series that adds support in F2FS
and also in the block layer for data lifetime information. The SCSI disk (sd)
driver is modified such that it passes write hint information to SCSI devices
via the GROUP NUMBER field.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v9:
 - Rebased the patch series on top of Christian's vfs/vfs.rw branch
   (tag vfs-6.9.rw_hint).
 - Instead of checking in sd_setup_read_write_cmnd() whether rq->write_hint
   != 0, set use_10_for_rw if permanent streams are supported.

Changes compared to v8:
 - Removed the .apply_whint() function pointer member from struct
   file_operations.
 - Made this patch series compatible with 'sparse' via the following change:
+/* Sparse ignores __packed annotations on enums, hence the #ifndef below. */
+#ifndef __CHECKER__
 static_assert(sizeof(enum rw_hint) == 1);
+#endif

Changes compared to v7:
 - As requested by Dave Chinner, changed one occurrence of
   file_inode(dio->iocb->ki_filp)->i_write_hint into inode->i_write_hint.
 - Modified the description of patch 03/19 since the patch that restores
   F_[GS]ET_FILE_RW_HINT has been removed.
 - Added Reviewed-by tags from v6 of this patch series and that were missing
   when v7 was posted.

Changes compared to v6:
 - Dropped patch "fs: Restore F_[GS]ET_FILE_RW_HINT support".

Changes compared to v5:
 - Added compile-time tests that compare the WRITE_LIFE_* and RWH_* constants.
 - Split the F_[GS]ET_RW_HINT handlers.
 - Removed the structure member kiocb.ki_hint again. Instead, copy the data
   lifetime information directly from struct file into a bio.
 - Together with Doug Gilbert, fixed multiple bugs in the scsi_debug patches.
   Added Doug's Tested-by.
 - Changed the type of "rscs:1" from bool into unsigned.
 - Added unit tests for the new SCSI protocol data structures.
 - Improved multiple patch descriptions.
 
Changes compared to v4:
 - Dropped the patch that renames the WRITE_LIFE_* constants.
 - Added a fix for an argument check in fcntl_rw_hint().
 - Reordered the patches that restore data lifetime support.
 - Included a fix for data lifetime support for buffered I/O to raw block
   devices.

Changes compared to v3:
 - Renamed the data lifetime constants (WRITE_LIFE_*).
 - Fixed a checkpatch complaint by changing "unsigned" into "unsigned int".
 - Rebased this patch series on top of kernel v6.7-rc1.
 
Changes compared to v2:
 - Instead of storing data lifetime information in bi_ioprio, introduce the
   new struct bio member bi_lifetime and also the struct request member
   'lifetime'.
 - Removed the bio_set_data_lifetime() and bio_get_data_lifetime() functions
   and replaced these with direct assignments.
 - Dropped all changes related to I/O priority.
 - Improved patch descriptions.

Changes compared to v1:
 - Use six bits from the ioprio field for data lifetime information. The
   bio->bi_write_hint / req->write_hint / iocb->ki_hint members that were
   introduced in v1 have been removed again.
 - The F_GET_FILE_RW_HINT and F_SET_FILE_RW_HINT fcntls have been removed.
 - In the SCSI disk (sd) driver, query the stream status and check the PERM bit.
 - The GET STREAM STATUS command has been implemented in the scsi_debug driver.

Bart Van Assche (11):
  scsi: core: Query the Block Limits Extension VPD page
  scsi: scsi_proto: Add structures and constants related to I/O groups
    and streams
  scsi: sd: Translate data lifetime information
  scsi: scsi_debug: Reduce code duplication
  scsi: scsi_debug: Support the block limits extension VPD page
  scsi: scsi_debug: Rework page code error handling
  scsi: scsi_debug: Rework subpage code error handling
  scsi: scsi_debug: Allocate the MODE SENSE response from the heap
  scsi: scsi_debug: Implement the IO Advice Hints Grouping mode page
  scsi: scsi_debug: Implement GET STREAM STATUS
  scsi: scsi_debug: Maintain write statistics per group number

 drivers/scsi/Kconfig           |   5 +
 drivers/scsi/Makefile          |   2 +
 drivers/scsi/scsi.c            |   2 +
 drivers/scsi/scsi_debug.c      | 293 +++++++++++++++++++++++++--------
 drivers/scsi/scsi_proto_test.c |  56 +++++++
 drivers/scsi/scsi_sysfs.c      |  10 ++
 drivers/scsi/sd.c              | 117 ++++++++++++-
 drivers/scsi/sd.h              |   3 +
 include/scsi/scsi_device.h     |   1 +
 include/scsi/scsi_proto.h      |  78 +++++++++
 10 files changed, 497 insertions(+), 70 deletions(-)
 create mode 100644 drivers/scsi/scsi_proto_test.c


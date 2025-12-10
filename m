Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0851FCFEF
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 01:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765330955; cv=none; b=UYUZrVIWoNpVNS/DvLNEuU+fhiLxAMrLODYzdgLn6fbNf6Pxxb4Xh9vDkPi8Lo1Lmn14CW4ejp0x9v2MNQv3QRLVSLwI/QMxp/Wul8dUjhMZezmnJ9EU04b51Ahrr1Rpp8p+MD2lq+hiyIyfT1jFcommUMcIhOGwYF0FlqhqXI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765330955; c=relaxed/simple;
	bh=T9Cq8aIyNZREDh0tPYDT2Pf4p9IsmY+P8k1Dth1dqkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fUOmw4ZKAo4rgU0lNkrno9mngnT0gGahBepnTr0XRoeTrX8yFmDwzaSx0WM///ES73pR4e/grOnmadA+D10V7P3L9wG2zDfkbeGsj4sJgLI4E5K83Gwko33aYfVyy68eZdJXoly/iulyP1MsaL3VZ29NvX5n+AQBeAQLnzLq8Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jimz5vCr; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jimz5vCr"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-295548467c7so80823695ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 17:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765330953; x=1765935753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTOj8mtvz7bMiDNO/pkswPuq5T3Do7BAnSCOIfTK70g=;
        b=Jimz5vCr3Ds4Iuo/T2OfJV5WAiZqgvGMF42OdIPBlyGQWdVE0TVNv9f53jO0tgCGJg
         N628glt4P5Muh+8cFpblRGTHszKRQQovrI+hySRg06O55G0Y/qeZWD7WS+yUJBXFsioX
         tz7hQohPniSH/KtQb8hnZTKgaOcoTOKFx96I2WORgyh596HHa9Ow9IvaLZYSJr/dKkma
         KPTUFrqwgOhDSxtOxqbIWwr0Ww0lvIKd0GKvMTv70/W3Ew7wi9mDbeltasgYNvofbqKz
         M93j4Dv7imkbPxrQ5GuN3p1uipr2ImghBTy3m0FeKgS7D/IiMX5j+JpzkL9q22seVEei
         DWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765330953; x=1765935753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTOj8mtvz7bMiDNO/pkswPuq5T3Do7BAnSCOIfTK70g=;
        b=iMBHqVO/NVS7PN/hjJAzCdGL3EDlnNABza2NwYn4hS3XczC0Mti5yTdmus+doF8AZd
         xq/r0F6cvSR0dGlE5yGN4Ju8i6sbG3Z+9qVTbNOMhE2PjWRk8gZ9AaxnLqBQyJg9N0XZ
         DtDzf7WicqTXhPO0qe9L0V6hmJNF6jxeI7FTKdzqfppLOloklgqlgIXIksltsRgOeGdS
         AMPIpZTsBrQdgcfforx/ECq6liePrDYKMqVehNXRUFIIcrZIt6hxMFMkFofvevEbRxw2
         Xud3+hQJryqts4kqPCur9UK0rMPlc8RNQ68bIpg8d9yFYnwfYeKE3uU2OvMQBJU3plB9
         0RFA==
X-Forwarded-Encrypted: i=1; AJvYcCWxh7RioDGwQYegb+mAKJCcT+/3/RyC4UJRc7RCrLtdA+8YUH2oT8OZgQsOTJn8Zgi9M7WTVOobQTnR@vger.kernel.org
X-Gm-Message-State: AOJu0YwY4FfL8Ku1kfIhuxhwhxI3C2bZefLg9B1wjBR+c163zlxi96Xa
	pUvKtyhViItYfhC9Gz1wK7qDokOXLYHfuRvA6PuxHLv77TZeKE6EHUEo
X-Gm-Gg: ASbGncvSkIqowKxeB+At6Hhuwpm0USUUuRWT643mYqCpjQ2SF61HuEgTy2Z1sqf9miV
	YaxFS35ph7rqAUAsHPcgueFNEEDAGMwpXcDyj5cIvluuyIQN8Mvak0UPUZ60uWJZwqTzIrRxGtT
	yiKaG0564I8d6s8WmJaWeoXUiZAfgOLVTr6DoUEtxRBHP9lg0OEvkwWMGUj64vfr+CkX03LAzcr
	gSjTQX2KHUpb6EvOoK7Qcc2+xJPXS71XXVOWtT8/WAWWVVwrLaR3fipaOmNrD8u8McEIFTefo0H
	0U+PIhusaBHHXRq5Z8D4cQSKpydTfpGKDKFjGrXMlkXezWhQ8C6k6eOw+IgJi008JGKijGd7SjV
	QmUIRxHgmDLkWEmG/WJ8ThHVBDB+AU7HMK7alJqWdzBw99502M0ptW7SRzKaJN2kQblJ7L0KBS/
	EmSEcSrcJlGEP7ICh6whRxLPuJWHFNxp4=
X-Google-Smtp-Source: AGHT+IEdUNw2zNQhZ/I2Qr+XBs/n7tKIMF5djW7gIs2sFqNkyOiwmZ90hxdyuKZt0RmU/52skct44A==
X-Received: by 2002:a05:7022:fc07:b0:11d:f441:6c9b with SMTP id a92af1059eb24-11f2966ff55mr540711c88.22.1765330952646;
        Tue, 09 Dec 2025 17:42:32 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm80274777c88.6.2025.12.09.17.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:42:32 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>
Subject: [v1 0/2] enable sector size > PAGE_SIZE for scsi
Date: Wed, 10 Dec 2025 01:41:34 +0000
Message-ID: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Hi All,

This is non RFC v1 series sent based on the feedback received on RFC
v2 [1] and RFC v1 [2]. This patchset enables sector sizes > PAGE_SIZE for
sd driver and scsi_debug driver since block layer can support block
size > PAGE_SIZE. There was one issue with write_same16 and write_same10
command, which is fixed as a part of the series.

Motivation:
 - While enabling LBS on ZoneFS, zonefs-tools tests were being skipped
   for conventional zones when tested on nvme block device emulated using
   QEMU. Hence there was a need to enable scsi with higher sector sizes
   to run zonefs tests for conventional zones as well.

Changes since RFC v2:
 - Replaced open coded check for enabling sdebug_sector_size > PAGE_SIZE
   with blk_validate_block_size() in scsi_debug.
 - Replaced open coded check for enabling sector_size > PAGE_SIZE
   with blk_validate_block_size() in sd driver.
 - Replaced 'struct request *rq' argument in  'sd_set_special_bvec()' to
   'struct scsi_cmnd *cmnd' and used that to get SCSI device pointer
   'struct scsi_device *sdp'.
 - Slightly modified the commit title for scsi sd driver fix patch.
 - Added "Cc: stable@vger.kernel.org" tag to scsi sd driver fix patch.

Changes since RFC v1:
 - Re organized the patch series into one patch for scsi_debug driver
   and one patch for sd driver.
 - Updated commit title and description to accommodate the above
   re organization on commit titled - scsi: sd: fix write_same(16/10)
   to enable sector size > PAGE_SIZE.
 - Updated commit title and description to reflect the re organization
   on commit titled - scsi: scsi_debug: enable sdebug_sector_size
   > PAGE_SIZE.

Thanks to Bart for feedback on the RFC v1 and v2 series.

Testing:
 -Test suite: xfs and generic from fstest + QEMU emulated block
    device(scsi and nvme)
  - fstest Config for patched xfs 16k block size [xfs_reflink_16k_scsi]
    TEST_DEV=/dev/sda
    SCRATCH_DEV_POOL="/dev/sdb"
    MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=16384,
    -s size=16384'
  - Generic test results
    Baseline: 6.18.0-rc7 kernel + nvme 16k logical block size
    Patched: 6.18 kernel + scsi 16k logical block size
    5 failures seen on generic tests and the same seen on baseline
    No regressions introduced by the patch.
  - XFS tests results
    Baseline: 6.18.0-rc7 kernel + nvme16k logical block size
    Patched: 6.18 kernel + sci 16k logical block size
    30 failures seen on patched and baseline
    No regressions introduced by the patch
  - Blktests results
    scis and block layer tests with 16k and 32k logical block size.
    config used:
    TEST_DEVS=(/dev/sda)
    EXCLUDE=(block/010 block/011) # these didn't run on baseline(nvme 16k)
    All tests passed.

Link to RFC v2: https://lore.kernel.org/all/20251203230546.1275683-2-sw.prabhu6@gmail.com/ [1]
Link to RFC v1: https://lore.kernel.org/all/20251202021522.188419-1-sw.prabhu6@gmail.com/ [2]

Swarna Prabhu (2):
  scsi: sd: fix write_same(16/10) to enable sector size > PAGE_SIZE
  scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE

 drivers/scsi/scsi_debug.c |  8 +-------
 drivers/scsi/sd.c         | 27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 17 deletions(-)

-- 
2.51.0


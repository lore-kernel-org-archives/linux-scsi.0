Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52A82C0F84
	for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2026 01:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770774694; cv=none; b=BJI3W2j/FMGNkIy9JsmC5s4OREzo32HFP6Ofz0abveBSiGYTx5uzsD+u/fsZ5PL8Ysu+yfVGRuETlN68fj4ryCvgu/34H/59YjVEwgqyHAAtKuk2NntgdhlR6m/eWoYBxqrhepSuCtzSVh9nt/bog56vdfzpqSYvIqfxsk5s5CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770774694; c=relaxed/simple;
	bh=AJC7/avwgZkB36uW0Zh7FL/B62CinLrLkNs/HRdp1lc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hvfRpgXo2+TJX4rh7LCRJ8BjvIzNpwJ+TCV/hGBBGEss7wDghQc1Fegim3emTzSjeC3H7wEwE+eOLJfnbu8MxDcmlQc+Ic5omKtcxoNnAdz6k/6PZUqeeOj4Wrk8V+RzIRsD/no7d0aIBnl+/W3R6hwm++0WT2irLx7rjJTUwcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDiqVwoo; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDiqVwoo"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-794fe16d032so13868827b3.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 17:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770774691; x=1771379491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OtIpv1xCCZ1JbN1gUW+Em+tjJTGPkxKDccdb78CDPok=;
        b=YDiqVwooK12d4exrPP1lHf7xK18kByNRd8ooAbDMS1Jo5ax6C7H6Y8mHZlb6/+pkGh
         opuyLVXcVJdxtqCQn5PvEH+mUyaryl8aAJ5Eny7gRvTO3d7kNwFy8UeEmOeUmovi5Ofk
         j+9aLmwTzKe/VayhadUcVj/DF07nur+AdrDklsW1k9t4gwZOwGeDBjG0rhR5KCObcgd+
         7PFgHtoei7rLNS3EtxXiCVmOhXUvjoSHCtALUAYsgDNN/3PhmVtmvMjkgKds4XW6X7Ww
         yH2Ala+B/b1f3wLMLUY+z9A1kmDie/YrjYyORvQftdyNLvYVynBKW300GfXeQxX8RvZf
         SwWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770774691; x=1771379491;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OtIpv1xCCZ1JbN1gUW+Em+tjJTGPkxKDccdb78CDPok=;
        b=T0+wUNUkzkWfTrg+0k0t7D+rhV2NUzmJQzYDcyHckQMxSsJssyrCrwHZYMAgKw5JuP
         u6nRE29HA7KAMN/wCqrnJAwBBfKUM32iEYipBOpIsL8/YEfk43EzlSvjIkjmBomJZZQi
         oOq3y8zodwVEI2L2fHc5w9PoF001w/F85212+sMd1m3dS3cjOKOnSDEBM5DXCCr3z98x
         Tmezdzw3Nc9faQxE5L7VEGTuA2xjGMwylKg/KT8Hl+wyjKB18UyWvP97ELvrExttqosq
         QLufeThSho+FWRCo3eV75GMrWv6GcIyDaX4+m9Rvpxkpfid6QFY4gXBQdifbv8kg3+5l
         DaSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgAiID0H+E/dsPzLGvM87aRR4Npp2fQenK0qNFOoijYE9GuXuXFu0aH0NF+ZTtlw9QCu8NYrirVRDm@vger.kernel.org
X-Gm-Message-State: AOJu0YxNSEa+LA2gE9/ooEWyNwK1nbVsbsghli3tYdwVAnecUC5d5iv7
	eHrI+n+8guKVBiElFVjU53WzFduEiph49o7TYXNt5M62kMWuoqIbfyxq
X-Gm-Gg: AZuq6aL03/4jGItGCDBDunQ8uHg5wMsD8dS/tCJG6aBEtwIITlMOB8nwd+noGBUsyjy
	JV0ESL/mcZv2o1IWQsLCg5ihdnm3F0/1ICM0AC4wfzvkZRi1quSIQx3RufXSqD2+NbeZff8kLR8
	GwUU53gB0VyyGKEUMpQ18vddQuTCgKEI7c80UFA568CE6qY+3h9ojV7rsCmOiPpsO6Z7l2pbaVA
	bUKSmIyiDLt1mPAxFuej8D3Hpas2YWRL/l1otRTWIpkNtq5JbiESHXJ7Mz4d2Mt1WsANo3Dqjwf
	NAskGmnmZOQdtJ74vkOCa8NAS9KjEwb4PJVr2DLJncn6IJXc7KPlJfIjvw4+XANyzJvFxwajBJQ
	FsxOMKgDDnzykTd3bRPbSKAHYlqYYEGT0WxnXqXr8zRFKNo15Y+Gtmipj3gYMMtJQbWVW+487BE
	hjSgX5km+4l2Tpm4xU3Rwefd+96GJYM2uurs+6/Orjv32t6T0=
X-Received: by 2002:a05:690c:dc7:b0:794:cea5:2ce with SMTP id 00721157ae682-7952aa56c7cmr165178427b3.5.1770774690917;
        Tue, 10 Feb 2026 17:51:30 -0800 (PST)
Received: from 5163NRD-SPRABHU.ssi.samsung.com ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c16e7c6sm3751557b3.1.2026.02.10.17.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 17:51:30 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	pankaj.raghav@linux.dev,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>
Subject: [PATCH v2 0/2] enable sector size > PAGE_SIZE for scsi
Date: Tue, 10 Feb 2026 17:50:41 -0800
Message-Id: <20260211015043.2608866-1-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Hi All,

This is v2 series sent based on the feedback received on v1 [1] and RFC
series. This patchset enables sector sizes > PAGE_SIZE for
sd driver and scsi_debug driver since block layer can support block
size > PAGE_SIZE. There was one issue with write_same16 and write_same10
command, which is fixed as a part of the series.

Changes since v1:
 - Retain the single page mempool for the regular devices.
 - Initialize a large page mempool at 'sd_probe' when the first device with
   sector size > 4k is detected for sd driver with ensuring atomicity.
 - Safe destruction of the large page mempool in 'sd_probe' if the device
   fails at probe after the mempool is successfully created.
 - Safe destruction of the large page mempool in 'sd_remove' when the last
   device with sector size > PAGE_SIZE is detached from the system.
 - Added a check in 'sd_set_special_bvec' to use the correct mempool for
   allocation based on the sector size of the device.
 - Added a check in 'sd_uninit_command' to use the correct mempool for
   freeing based on the sector size of the device.
 - Added check to destroy large page mempool if it exists while exiting
   sd driver.
 - Slightly modified the git commit message to update the above changes
   for scsi sd driver fix patch.

Thanks to Damien for feedback on the v1 series.

Testing:
 -Test suite: xfs and generic from fstest + QEMU emulated block
    device(scsi and nvme)
  - fstest Config for patched xfs 16k block size [xfs_reflink_16k_scsi]
    TEST_DEV=/dev/sda
    SCRATCH_DEV_POOL="/dev/sdb"
    MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=16384,
    -s size=16384'
  - Generic test results
    Baseline: 6.19-rc8 kernel + nvme 16k logical block size
    Patched: 6.19-rc8 kernel + scsi 16k logical block size
    No regressions introduced by the patch.
  - XFS tests results
    Baseline: 6.19-rc8 kernel + nvme 16k logical block size
    Patched: 6.19-rc8 kernel + scsi 16k logical block size
    No regressions introduced by the patch
  - Blktests results
    scsi and block layer tests with 16k logical block size.
    Baseline: vanilla kernel + scsi 4k
    No regressions seen by the patch.

Link to v1: https://lore.kernel.org/all/20251210014136.2549405-1-sw.prabhu6@gmail.com/ [1]

Swarna Prabhu (2):
  scsi: sd: fix write_same(16/10) to enable sector size > PAGE_SIZE
  scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE

 drivers/scsi/scsi_debug.c |  8 +---
 drivers/scsi/sd.c         | 79 +++++++++++++++++++++++++++++++++------
 2 files changed, 68 insertions(+), 19 deletions(-)

-- 
2.39.5


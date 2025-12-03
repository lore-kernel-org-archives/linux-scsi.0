Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E0E2D6E53
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 22:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764802757; cv=none; b=tSG3FLbpwi6VkfDFd58KpI2BmJg8GRaSE1r2EcPadDVJZohnp8Ke29iE5mjjJEKeqCtkWuaBg3MItHki9txQN339IpornIWfUXOPCuj3et7lGmzo4Vit6IDHs4Qa6DP/qDgpLJBJiYxzc6ax1HeTFkc2f69oOnvAoNn+v64DT40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764802757; c=relaxed/simple;
	bh=AiT0DsFAzDbCQ2fDAPYpO1ae38WWUV4y3ULe8+raXTw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hn0fs8NYWdS5Yl1/IvWaFvojcwMYbIXXSXJ3WgWxvEJ9Id95uTl9X37WYaDdAy4AMoVX5Na9UM50DsdCMf9Ri+7kNtm1t4+oS2Kkg1sIOXKHojpRH1AAFcINV5RqUDNNcFOskOHPafCSspIJT2DDAioK/VPOJbJvjczwyb0lhbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHb7VcX1; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHb7VcX1"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2984dfae043so3054455ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 14:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764802756; x=1765407556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=StjFP4Y78P0tll00GH7VVLh4F2dk0BSHeE9CSSXVLq8=;
        b=dHb7VcX1FP1HlSxlIv60Ylo9pgek2q3lN4gMSN21CYN/N5zbpAFHPbUi7wqjQcRxua
         jzennloi5LbsDjiCqdBqAFDA0+lGpNC5r7M3ZeCIZgqTSDgSYl9qRjZHLuvCpAca51pH
         y17MPu/Yo+eNz9I7tI9au+wRPaRPljtXX9bUNX9k2dHVc8zh4RcZWrwzJdDb8oBp7K6B
         LFgS1eYib6I4uWaa+kkZFi5olcsJa/IkGrYJxqgnhXvQL3pB/p/zlG4LuETsvxQIYJpJ
         epiWBA144XBbEdTr68QP0YXmnTtuZIu16M60c5U/bdmJ1lMJ4AmnBIC1iZBFTXomucwK
         /Vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764802756; x=1765407556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StjFP4Y78P0tll00GH7VVLh4F2dk0BSHeE9CSSXVLq8=;
        b=JZ3yBc6V51rQzubQh+dPu1rxfht1ILuwzIzmx8BQja/wylGcW792JLbANCfiVd79jK
         Xbvz19WPIc2calTGXH/bqe2y0yXrbF47kPlzfqIzvF25GMYfSnVNzI1aG8dEvwYdjLwv
         p/C04m2mChFtnJ4AneRxwV1oFWHTPVL4K4DJKB/eIpRTFMZS6lRiZPI0qzsuZWFwk6b0
         J6ysMjqKkQcetWeyYMps7s8eK2OT+dH7o7I3o40kxls0APNnqORgKx87isGA6Li9raD2
         NiVi8Tm19tE6sDdMt+SSupU1zBzhpBZ/6P7GycQQGH/lIww8VBSNASwvMGwD7Vbp0lLJ
         +SBA==
X-Forwarded-Encrypted: i=1; AJvYcCVCUq9tlOStT3ZZiv3MlAmeLoc8ghoFpzp2hq377liySTmRGtTZVq02QjAJIOX2lvinuwhgWxs4KeCa@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1K3sC/+cAGv5x7+cmZHYBuh5rsF1WI2iKOFjAlhC1+Ra3o4m+
	Do21fL5rkwsl6Nhy+lOCHHshLQTW5UBDYMaezY5+04eI4hq8vDiR+DML
X-Gm-Gg: ASbGncvmnFpSRnpXWl2yoO6rITY1Dwbn05SJn+WgCPWd/FoT2mK3OfFO4gN1yTZEhRT
	hQS5wW4NXZShsGaj0AtNSysGin94qPAXeJ9ep7g2Fuq4RmvBxfebKM18jfnMCI468LuzEGSLiGq
	lLwIFcf6hmFdusUUVi+OQ1v+rFMmUldH5FthaBC6rVAZQLANUy8Ii+FYgxsQwlbfq2BiCoYBAT3
	b47RIl3kRV8dACxb148WdflWMwKmEQzNgwiL7im5cwPWnPlPvIOrdycr/zeKQNWLX3dG/LYT8u/
	3kbmXAbEYO8HRF5tg+VxyWxTI9uxQe05Ss1ew5DJw7LkFWSjLfvGcsR2GuNXkMYmB3liBDd7T5F
	/cHsHH9k5Q7pZPnHOEae8QXucRPvB5l+yZAJxwK+JYGe+hMSJ5cuF15V1xYp4OL/6MaRk+H0Qb4
	Ep0sKc5ilMNNoapXd01S+0s2sxMeJkQvU+qbQ4XsnzZw==
X-Google-Smtp-Source: AGHT+IE4WcTXgTakgYyG3k2I/bWIDoVLKE/1Yel/jKjUcQvVI0FEih7rPaGKnnbxb5llg7/B9cyvkg==
X-Received: by 2002:a05:7023:b86:b0:11b:9386:8257 with SMTP id a92af1059eb24-11df0c4a067mr3136115c88.44.1764802755403;
        Wed, 03 Dec 2025 14:59:15 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaee660asm98255225c88.3.2025.12.03.14.59.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 14:59:15 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	bvanassche@acm.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>
Subject: [RFC v2 0/2] enable sector size > PAGE_SIZE for scsi
Date: Wed,  3 Dec 2025 22:57:25 +0000
Message-ID: <20251203225727.1273081-1-sw.prabhu6@gmail.com>
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

This is RFC V2 of the patch series V1 sent on Dec 2nd [1].

The purpose of this v2 series remains the same as v1:
Now that block layer can support block size > PAGE_SIZE, enable the
same for scsi devices. There was one issue with write_same16 and
write_same10 command, which is fixed as a part of the series.

Changes since RFC V1:
 - Re organized the patch series into one patch for scsi_debug driver
   and one patch for sd driver.
 - Slightly modified commit title and description to accommodate the above
   re organization on commit titled - scsi: sd: fix write_same16 and
   write_same10 for sector size > PAGE_SIZE.
 - Updated commit title and description to reflect the re organization
   on commit titled - scsi: scsi_debug: enable sdebug_sector_size
   > PAGE_SIZE.
 - No functional or code changes.
 - Test results unchanged as mentioned in v1 cover letter.

Testing:
  1. Test suite: xfs and generic from fstest + QEMU emulated block
    device(scsi and nvme)
  - fstest Config for patched xfs 16k block size [xfs_reflink_16k_scsi]
    TEST_DEV=/dev/sda
    SCRATCH_DEV_POOL="/dev/sdb"
    MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=16384,
    -s size=16384'
  - Generic test results
    Baseline: 6.18-rc5 kernel + nvme 16k logical block size
    Patched: 6.18-rc5 kernel + scsi 16k logical block size
    6 failures seen on generic tests and the same seen on baseline
    No regressions.
  - XFS tests results
    Baseline: 6.18-rc6 kernel + nvme16k logical block size
    Patched: 6.18-rc6 kernel + sci 16k logical block size
    198 failures seen on patched and baseline
    No regressions.
  - Tests similar to above was run on 32k logical block size
    No regressions seen on xfs tests.
    Generic/778 (add sudden shutdown tests for multi block atomic writes
    )test is failing on scsi 32k block size due to atomic write taking
    too long to start, but is passing on the nvme 32k block size setup.
    Since sysfs shows atomic write granularity not enforced for scsi device
    it seems that XFS issues atomic writes slower. Upon increasing the
    wait timeout from 10s to 40s for the first atomic write in
    'start_atomic_write_and_shutdown' generic/778 seems to pass for
    32k scsi sector size.

 2. blktests: scsi and block layer sub tests
    Baseline: tests with scsi 4k block size
    Patched:  tests with patched kernel + 16k scsi block size
  - scsi tests - no regressions.
  - block tests - Disabled block/010 and block/011
    Hard to reproduce(sporadic) kernel hang seen while running
    block layer tests ie at block/003 due to fio task being blocked
    by a mutex held by udev event. Not seen while running it
    individually.
    Rootcause - block/001 stress the scsi debug devices by adding,
    tearing, removing the devices in parallel that triggers udevs.
    This races with fio task triggered by block/003.
    Added udevadm settle and small delay between block/001 and
    block/003 fixes this and using this as a temporary fix, while
    we continue to evaluate. Note: block/002 being skipped.

Comments and feedbacks are welcome.

Link to v1: https://lore.kernel.org/all/20251202021522.188419-1-sw.prabhu6@gmail.com/ [1]

Swarna Prabhu (2):
  scsi: sd: fix write_same16 and write_same10 for sector size >
    PAGE_SIZE
  scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE

 drivers/scsi/scsi_debug.c |  9 ++-------
 drivers/scsi/sd.c         | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 13 deletions(-)

--
2.51.0


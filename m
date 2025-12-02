Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396DC15278E
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 02:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764641802; cv=none; b=Fz7SCOKF6paLUo8xhoVfDLJkfnjm8oFxQeasyHmxE2nOIpvnpIGfTUBhrHPJ2dkxGOn/acTrfKw2nhi3nMoApC1IMpj7jTavb9H8+AHkaLiMZv+DvS+wTejCSw2QQQh7zhujYoI23RCMXT3w+J8NDR3G6AJJjM0FVfFTaakPNSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764641802; c=relaxed/simple;
	bh=asha8f3f/iwQoU/SSTzIxVJaiZT9LHCAMPHmDx9eD5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gatbzf0SPRFwQ13Aa4oPT32p9m/4yj0cjIksmlek9kyhI8dyuxeAjRvebnFPRjpd7izr47sjQt8trNaRrYjRYWA24RIJN+vaQw5BE33KRZMN+VHqL3rOAy8vncTdi9849Zii4NAsPQz4mT/KX8mCsClzyKGl8GvVMaNLP+PHWiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a8AxSBlm; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a8AxSBlm"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b6ce6d1d3dcso4336025a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2025 18:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764641800; x=1765246600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XEKA7gYqeZanE05nqsBwYg9d2GGV62F2IdYvY3T+vow=;
        b=a8AxSBlm0AH4wIH5OLEbfvOqaONN6lzn6hhS06dZUA0cT8oxehJjkYsBaev4dAQ+ha
         aA3qnFE93HW1FWSw1Fm/YijofA7tCpKnn0PYs6kQuFhWiZfxN5aR8/+xu0zJHYO7iOjb
         /e7iWxK3zNReQolM+SdKC4z9oLSy/r958AIYKB8RT29PIs3dA/TrpoYrC0xfFeqJpYCZ
         v485PbBDx8fTkB2gmZF7JfQD75O6miM+QNBcfPlp531/HW2WRHFdHiVEfK/qn1xItNsT
         FEyPbVwmsXC/kYBH51jIjur1I6eZpV+GF8CZ1wjLDFMRc2y6MTO6mNsABMwFwdH0EWhV
         ypZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764641800; x=1765246600;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEKA7gYqeZanE05nqsBwYg9d2GGV62F2IdYvY3T+vow=;
        b=GV7ou+uKNBRphbVcx9hKUwAkYr+AZNZZVwCebVbjI4sHssS/NIXSWT62dvqdk+oqAw
         GWgRUoniMAkSgwAp/OiUnsa1gUTiMDQl9RuE0csuqWbtLdWb9kwbN4G3c83LN+5Vi87A
         S40MB7vNVqT6sqgDXc9FcLZghOoqUFI+/B5K3QZJIk+tHiLdi3/LqRAey2mxltDq21A3
         Qtdj9Z8syAX59Au6eMui9nhqjqOmCzTWOqGoFMqdJG8th0EM2nxIF60qcYt2H2jL+U7o
         Y45upa6wK3QRP6LXl5Z2FgO1xb3yPdKvQG3xy793V8bcssAnsHGYluL8QNA64KwzGgJ5
         +6Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWaatlnswwuxZepzpXydUpg511X4X206AqXBmL6qDONAcRQ1MWCVbxCRX5Id0nUjUojF5m2COuN3xax@vger.kernel.org
X-Gm-Message-State: AOJu0YyKKRSyJeKqI01iGSe02q9r/xaiLHx/O4OYzGrrGjZXFYK81vcf
	wIj6WNCatnXZW/XLZKv/uQYxdbn0VZj+luhWd/b2uncanwmaHko8iWXKFxuKww==
X-Gm-Gg: ASbGnctZdMUHwasrmJ2byZVg2p5mMx1HcJoxHig6g7u+4YXM5en0IewKX/s/FWnAm1h
	BzBxml+/DL2q8bx4YW8qSHIE6UpSTaHyAhaREg/jb6UEZ7tIUrnIvz7cJAanh+z6sh3uLhZFkY8
	mE62+JZp/dLFYkBJkmBul2MSOAsaD/8GcU1JKai8+XCGDX29pjPxmIRrGgSoNAg7VhIt7axorao
	HQrNI/+TNLBrWG2y2XyoRmcZcqQldJtK3mfb2zXzHOdT7HPiLNzEeOSU6K9dyB6V41Km7S8FG4P
	HaTvioPNwNFNXOb4Kbwahyb0Ikp6OrwdZ+n8R8084dkq+KnF+MHP+/cafZBIF6FFg0XTTHTnzA5
	QQK0AkK+udjoU598hMncZBrL3G4hWtKkshHpF27e2J1pFV8cSTX0TdpDXDT3dJ1VJ9JA+PBTpyE
	a/blht9uPVoOu7eya025AgYikbzkdon+Y=
X-Google-Smtp-Source: AGHT+IFzuDejqs0Oqa0oHbPMMT/9jCnTJ41UHM2UdHmB5xOxumY/jr6D86rSvIv5RnqwRdTXgBxdkg==
X-Received: by 2002:a05:7301:1caa:b0:2a7:1863:b162 with SMTP id 5a478bee46e88-2a7192b8b3amr20680755eec.28.1764641800298;
        Mon, 01 Dec 2025 18:16:40 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a9655ceb04sm49089945eec.1.2025.12.01.18.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:16:39 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	Swarna Prabhu <sw.prabhu6@gmail.com>
Subject: [RFC PATCH 0/2] enable sector size > PAGE_SIZE for scsi
Date: Tue,  2 Dec 2025 02:15:20 +0000
Message-ID: <20251202021522.188419-1-sw.prabhu6@gmail.com>
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

Now that block layer can support block size > PAGE_SIZE, enable the
same for scsi devices. There was one issue with write_same16 and
write_same10 command, which is fixed as a part of the series.

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
    No regressions 
  - XFS tests results 
    Baseline: 6.18-rc6 kernel + nvme16k logical block size
    Patched: 6.18-rc6 kernel + sci 16k logical block size
    198 failures seen on patched and baseline
    No regressions 
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

Swarna Prabhu (2):
  scsi: fix write_same16 and write_same10 for sector size > PAGE_SIZE
  scsi: enable sector_size > PAGE_SIZE

 drivers/scsi/scsi_debug.c |  9 ++-------
 drivers/scsi/sd.c         | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.51.0


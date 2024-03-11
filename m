Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E38110FA
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 06:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710140077; cv=none; b=kUgJZtEBt+70NA7aSv0vQRi8JzyWvhNF58aGv2iT3KYtmBiBAn/DbotlPRotIwFKORMvrc/7Is7iCRnx69Qj+AgqwaGocSQtvaY7D4CjHtCJUqZkFi4TxF7/R/DRTcVrFEw1A28JcC3cmgNXB1B6W4Lct55cYwdUSxZJLLEteVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710140077; c=relaxed/simple;
	bh=sFd4n4HachYGv1YT7DWo8m3BNQL9cqEdluNkh5Nqe/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QVq23r016zXaFvaFArLTICWBmKVLDL2hTzRAyOyKYxL8lBPdajI1t+5lYC0dHoB2fTTwwJ1M0kRrsVRaGfoip0xvqr6ZgTOgfPhw6wvrf1Gci44BgofThvSCx1Jej+X/Qk+URYgRYS67PFN6OpMX5meyOfAnJ2gCbiJKbGHne4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gaWHsUjq; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gaWHsUjq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710140075; x=1741676075;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sFd4n4HachYGv1YT7DWo8m3BNQL9cqEdluNkh5Nqe/Q=;
  b=gaWHsUjqvU1cVa/EkDSvzBzcGeJBBoAmXTfuNMA0NsiO/JcikD9uxvpu
   8Q80McrodZ9vUsI/ieq8b9GuuQTZAvc3UeSmc6gTzNELj3jv1brpD3B4s
   MX6JCSMPxQhUsm1g4xbQ8LGbBzn3QnH3GQtrobC5tZP+0L5r1BN6/Eu10
   TNPX4uKi9lk2rpT8KaVp3oY1aT/OLrDZZpCBZ2WxGgBIakvrWNwk/nMzl
   GvntNR+sRggbUpUefvIyVDhM0RJK+U/9PjeKoBUTgTdU12pb/RqAJV3QB
   tKBz4hnEgjTfnAGU7Wp3/ydX76/DnQRGtK61NG238KRfApHKDC9MaLF66
   w==;
X-CSE-ConnectionGUID: dhjHTNl2RKav2B2kyiX+dw==
X-CSE-MsgGUID: JRAml5uOQKGtkIyQF6yK4A==
X-IronPort-AV: E=Sophos;i="6.07,115,1708358400"; 
   d="scan'208";a="11270701"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2024 14:54:28 +0800
IronPort-SDR: lY9lVT4jgEvH1sIKBSE3poyv4t4DQRCPYfsc46yfcrsAO7sDEVCuH4SG+QWjCjnYzyGff1ZCa+
 UbRjsbv6MoBQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2024 22:57:51 -0700
IronPort-SDR: +/7+4XnqWmU0Lv6EvaSOBKdRlZ+ZicPXUQvNszSdhCn6/eS9LUbHCudHcfz9t5Nf+pKacejfMD
 kAw82Kkjb/6g==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2024 23:54:27 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH RFC 0/2] scsi: scsi_debug: Allow parameter changes through sysfs
Date: Mon, 11 Mar 2024 15:54:25 +0900
Message-ID: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some of the blktests users run tests using kernels with built-in modules to run
tests easier and quicker. For that reason, it is desirable to run tests with the
built-in scsi_debug [1]. However, some of the scsi_debug parameters can be
modified only at module load, as module parameters. They are visible as sysfs
attribute files, but they are read-only and not writable. There are ten,
read-only scsi_debug parameters used in blktests [2]. Because of these
parameters, eight test cases are skipped when scsi_debug is built-in [3].

The values of those parameters are kept as global variables and referred to in
many places. Changes in the parameter values affect live scsi_debug hosts and
cause various troubles. That is why the parameters are read-only. I once tried
to make the parameters non-global and unique to each host, but found this
approach will need large code changes in scsi_debug.

To minimize the code changes for such parameter changes, I propose to allow the
parameter changes "only when scsi_debug has no hosts." Users need to remove all
hosts before changing the parameters. With this restriction, users can run tests
with any, desired parameter values using the built-in scsi_debug.

This series shows how the code will change with this approach. I chose
dev_size_mb as the example parameter, which is referred to in multiple blktests
test cases. The first patch in the series is preparation. The second patch makes
dev_size_mb writable through sysfs only when there is no host. This change will
allow the test case block/032 to run with the built-in scsi_debug. Corresponding
blktests side changes are available on github [4].

The work for the other listed parameters is in progress. While the work is on
going, I would like to ask for comments on this approach. Is this approach
acceptable? Is there any other better way?

[1] https://lore.kernel.org/linux-block/20220530130811.3006554-1-hch@lst.de/

[2] Parameters used in blktests which have read-only sysfs attribute files

  dev_size_mb
  sector_size
  lbpws
  lbpws10
  dix
  dif
  zbc
  zone_cap_mb
  zone_size_mb
  zone_nr_conv

[3] Test cases skipped with built-in scsi_debug

  block/009
  block/025
  block/028
  block/032
  loop/004
  zbd/008
  zbd/009
  zbd/010

[4] https://github.com/kawasaki/blktests/tree/scsi_debug

Shin'ichiro Kawasaki (2):
  scsi: scsi_debug: Factor out initialization of size parameters
  scsi: scsi_debug: Allow dev_size_mb changes through sysfs

 drivers/scsi/scsi_debug.c | 91 ++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 21 deletions(-)

-- 
2.43.0


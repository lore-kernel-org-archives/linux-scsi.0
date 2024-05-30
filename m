Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BE4186E59;
	Thu, 30 May 2024 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079124; cv=none; b=krUw0QsJNtvvBiHQLAZzX0TbkTvUmCOeeDHlzjialw1zRMYGbsYr32ZfpxhgEPrT9yYnH6rlEWtD/9KhFVqm4jG9Jzz6a+LVI5GC3Gin9kPzJ8ozae4MSJ9TFBGdMlv3q9mRHdg19iorikH2dy7+pOzHSmf2LPPqe1CKz7Q7AK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079124; c=relaxed/simple;
	bh=lI93q7XNVx+d7jqN8ZADdFt2wY3bkSBhba8PZ5lEbdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Td7qpvRCmwLlXpm62o37fnnzZB7bIfPjoeW34HbVPMGRvpPOGHaHXRIL+E5IlFKW52PvF1LNuEXWqe1IphO93CRYG3Zd3G1YtV0MeVciBWj0Ek3t7bZLnBqTWN4vUrtSYa/k2+NSobfGWKfZm/DNDsvSyB3b97FN9BuEsjSekVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=DXUjjBvd; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="DXUjjBvd"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717079121; x=1748615121;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lI93q7XNVx+d7jqN8ZADdFt2wY3bkSBhba8PZ5lEbdI=;
  b=DXUjjBvdx2VKd4TZe0eaiJIZ6klx/Bd7DG0yDRV9YEajAQQThiONQgrt
   xh/LgSeD/1p/iWqUiMzYXeBpVIVYQxjArUPvdhrY7vWKMekqABoXby6BH
   Ve8dfJcyXQtpiBJe+BxuNXN7+5FO8llEpGjD4gm9j46d2zl4MUegDWiwc
   S561hNHZH3lXfmaLFkHfGcEUeC8h1Jkc3nN5LaNt4QN/D0TdWbrAs+xhP
   uM7MEY/CiLaWUwGvgmI6C6Vitwp2UhSazF7nzJ1NFwXV2RgtIbjMjxDaG
   SQKIbMmH8tLBvpzFbrwtlxx8ocL+4B61+Ps/0ACX0CjqdpjM9BvNzW/kF
   A==;
X-CSE-ConnectionGUID: Dugq8QkmTZC5jZwOoUtRuA==
X-CSE-MsgGUID: 8xoCSTJQRLiRzgrFQztK+Q==
X-IronPort-AV: E=Sophos;i="6.08,201,1712592000"; 
   d="scan'208";a="17740314"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2024 22:25:15 +0800
IronPort-SDR: 66587ea5_3Z2Kl8XGDs9fQ2b9UQTG94faoSRyLE4vBTSyLxh9pkgCGEV
 HYiR1EVbTE5eq0qxvAR9gyG2yEoFGm4zAjAxupQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2024 06:27:02 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 May 2024 07:25:14 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 0/3] scsi: ufs: Allow RTT negotiation
Date: Thu, 30 May 2024 17:25:06 +0300
Message-ID: <20240530142510.734-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rtt-upiu packets precede any data-out upiu packets, thus
synchronizing the data input to the device: this mostly applies to write
operations, but there are other operations that requires rtt as well.

There are several rules binding this rtt - data-out dialog, specifically
There can be at most outstanding bMaxNumOfRTT such packets.  This might
have an effect on write performance (sequential write in particular), as
each data-out upiu must wait for its rtt sibling.

UFSHCI expects bMaxNumOfRTT to be min(bDeviceRTTCap, NORTT). However,
as of today, there does not appear to be no-one who sets it: not the
host controller nor the driver.  It wasn't an issue up to now:
bMaxNumOfRTT is set to 2 after manufacturing, and wasn't limiting the
write performance.

UFS4.0, and specifically gear 5 changes this, and requires the device to
be more attentive.  This doesn't come free - the device has to allocate
more resources to that end, but the sequential write performance
improvement is significant. Early measurements shows 25% gain when
moving from rtt 2 to 9. Therefore, set bMaxNumOfRTT to be
min(bDeviceRTTCap, NORTT) as UFSHCI expects.

v6 -> v7:
Some more comments to patches 2 & 3 (Bart)

v5 -> v6:
Use blk_mq_<un>freeze_queue to drain the queues (Bart)
Replace the rtt_set() vop by a max_num_rtt constant (Cristoph/Bart)

v4 -> v5:
Quiesce the queues before writing bMaxNumOfRTT (Bart)
Make bDeviceRTTCap available in ufshcd_device_params_init() (Bart)

v3 -> v4:
Allow bMaxNumOfRTT to be configured via sysfs (Bart)

v2 -> v3:
Allow platform vendors to take precedence having their own rtt
negotiation mechanism (Peter)

v1 -> v2:
bMaxNumOfRTT is a Persistent attribute - do not override if it was
written (Bean)

Avri Altman (3):
  scsi: ufs: Allow RTT negotiation
  scsi: ufs: Maximum RTT supported by the host driver
  scsi: ufs: sysfs: Make max_number_of_rtt read-write

 Documentation/ABI/testing/sysfs-driver-ufs | 14 +++--
 drivers/ufs/core/ufs-sysfs.c               | 73 +++++++++++++++++++++-
 drivers/ufs/core/ufshcd.c                  | 41 ++++++++++++
 drivers/ufs/host/ufs-mediatek.c            |  1 +
 drivers/ufs/host/ufs-mediatek.h            |  3 +
 include/ufs/ufs.h                          |  2 +
 include/ufs/ufshcd.h                       |  4 ++
 include/ufs/ufshci.h                       |  1 +
 8 files changed, 132 insertions(+), 7 deletions(-)

-- 
2.34.1


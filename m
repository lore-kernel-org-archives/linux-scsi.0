Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E488BEE;
	Sun, 26 May 2024 08:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716711418; cv=none; b=reAm+Rbr4wLO49lPpv9n1jBmNmZXyYjADg6NRD6ysAx7VldvJ7LtUbghVMjl2iDc22mdA/1Jr3cJGXviQNgyhVTbpAwrlNjCiOpSM8eazECRW1T0QzK2Kh9JzMUGxobdIGvq64VnGe/7q/stUX15jRJ9espS0f5P7ARMkg/+SRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716711418; c=relaxed/simple;
	bh=wPjkuqy7/TUpStWC5aJK0tThAfQUMWuS92Pd6h5bFhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UFls5fAYjWdrg8PiV7txZ51s/iFkqpOS0eTqHRsdN9vPHv6e45Gd16ChHH6zooLWQz1pO/pS/9n1X15iRyHO6fdK2U9njJyPKuLXKZ8sMdlLwZHqRVy1pFTFDDdxlwS7P343egcT5AAH+uVkGTPZpG0BTy/HCsiAtxS4dz+Qw5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Q1yboHmL; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Q1yboHmL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716711416; x=1748247416;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wPjkuqy7/TUpStWC5aJK0tThAfQUMWuS92Pd6h5bFhw=;
  b=Q1yboHmLzqX5C+5ThqfA/qCfiElV2Vq0bslxqSPQ7BTchO5eXvJ8Dud+
   Tlb5mOXfKyZ/QtH3Z+aiGkgWCFHjPPMAhcz11j3YnYb+oycYKDeLxsMlK
   e5b5U4KVuGs82xXPeuGpMhPCb/47DSIoio+Sx35ZNxGKfmfsxcydTKG14
   jESAuBDJ08vss/GwL/hNSk0RzC0Rmi5G1w5qdWMrZklwikX4PbXy4zF7w
   RCPEkDUhM2tIj/UTLxqoj628yPQxuRjvQfXbQJML6dyuxp4TiKswhDTSz
   PlfCUK03Swu2oHAg88xy1EdPLJkgl6rKkpBlFkiq1WRz+PKgupWqcY9LL
   w==;
X-CSE-ConnectionGUID: MNofxBkFQ/unrkNmKI04zA==
X-CSE-MsgGUID: SA+y0A8VTdOe7seORAbdQw==
X-IronPort-AV: E=Sophos;i="6.08,190,1712592000"; 
   d="scan'208";a="17270699"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 May 2024 16:16:49 +0800
IronPort-SDR: 6652e3a5_FmK3oc4I5P2r9a80TXUjnofXB3YBpeYX5wkDncMsZfznXFT
 0U5GMImndRQhi2gwlCDBPSGFf48qXBzcWZ0Xygw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 May 2024 00:24:22 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 May 2024 01:16:47 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v6 0/3] scsi: ufs: Allow RTT negotiation
Date: Sun, 26 May 2024 11:16:33 +0300
Message-ID: <20240526081636.2064-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufs-sysfs.c               | 68 +++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h             | 24 ++++++++
 drivers/ufs/core/ufshcd.c                  | 42 +++++++++++++
 drivers/ufs/host/ufs-mediatek.c            |  1 +
 drivers/ufs/host/ufs-mediatek.h            |  3 +
 include/ufs/ufs.h                          |  2 +
 include/ufs/ufshcd.h                       |  4 ++
 include/ufs/ufshci.h                       |  1 +
 9 files changed, 152 insertions(+), 7 deletions(-)

-- 
2.34.1


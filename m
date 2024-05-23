Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED598174C;
	Thu, 23 May 2024 12:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469122; cv=none; b=rj3Z2ohpF+5N+wDSoxD01t0b0Cu/o4HCw69PFmlmh77r1buDJpBeDy7JwRU9x4cXJqJZq21aMyTZ4LKobCcZTLhnNYGtyGZAkyDrx4sv5Pe339HY7hkcbiz9jtfN5aAH6JNJBugccVZ1mvL+3my1boBcGQhDmZfnDdYF2LZHZzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469122; c=relaxed/simple;
	bh=oV2ZFplCblWKmN/I2j0dD142TAdaLRkSzUlqV4hF1yw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UVHOGJYw4BNsK2XFMA4H0XmPITH1HGxtfspuebeeBo4cLmBNLEMmsI2YQ/RvNVvfKN+xecVxukP17FuHrXnRF511aLxPJIiozviBwOhJ572ad1z+gQQK8D4p3J9y8VDUEUILaY71KLG17YZwpkn45TxJ+cqEEvmVkegKP78y1zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Mkd3Bh4L; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mkd3Bh4L"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1716469120; x=1748005120;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oV2ZFplCblWKmN/I2j0dD142TAdaLRkSzUlqV4hF1yw=;
  b=Mkd3Bh4L9L4QcsfG96chEZ1gX7gfq0IvK4RMLWJ+LIyw5nYlYkLoLByc
   oolW+pbEayY/91spqDHckmLYDZa9jStsW7Zs11uIlA13ZJOh6uwBEUiIK
   M4DJOecVD14nhMUxP3OlHG5ZN0sJ0oYl5QVJJwQkY0eSKD0EqaKLNFaaJ
   TfKzGqn3+3thnDgObg0NQNnDvALzg8Eymm+QzH4+kk1kCf3YjUh8NojIJ
   foDvKRxPjtYz/U54vEBQaKpQ86bJGV4IC6VlfklM2C1H4EPsgzK233XQc
   eNl/eVhFYeWLB0tE90vCqrFbI97KXFoyulhG1ToKOH6XVKqniUoTNrgd+
   A==;
X-CSE-ConnectionGUID: B1vBICsYTTuwkvbP7gcZhQ==
X-CSE-MsgGUID: K+g1x1t8Rg+4LYSgjzX96w==
X-IronPort-AV: E=Sophos;i="6.08,182,1712592000"; 
   d="scan'208";a="17062539"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2024 20:58:39 +0800
IronPort-SDR: 664f3136_ZssmQlMpJAR0S2alNUERHDIT1Ml7xFl4ZRQpOX5+WaltTJS
 0WIQvBy2mg1Myl1BL6ika/A38lJZM7LsO8ZFa7g==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 May 2024 05:06:14 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 May 2024 05:58:38 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 0/3] scsi: ufs: Allow RTT negotiation
Date: Thu, 23 May 2024 15:58:23 +0300
Message-ID: <20240523125827.818-1-avri.altman@wdc.com>
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
  scsi: ufs: Allow platform vendors to set rtt
  scsi: ufs: sysfs: Make max_number_of_rtt read-write

 Documentation/ABI/testing/sysfs-driver-ufs | 14 +++--
 drivers/ufs/core/ufs-sysfs.c               | 72 +++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h             | 12 ++++
 drivers/ufs/core/ufshcd.c                  | 53 ++++++++++++----
 include/ufs/ufs.h                          |  2 +
 include/ufs/ufshcd.h                       |  4 ++
 include/ufs/ufshci.h                       |  1 +
 7 files changed, 139 insertions(+), 19 deletions(-)

-- 
2.34.1


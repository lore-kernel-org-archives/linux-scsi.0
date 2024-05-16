Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06486FB2;
	Thu, 16 May 2024 05:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715838700; cv=none; b=mXwhuwmJhFhxIhYu/0iqY8gWzS7AXExTsj7BOaJhopniOFPuuVA3RqCTUsK36vHzpwyMrqfaqjCKh/dYOz2mehMhKku8cMgVfTe3AmLpvrMBBpptwfbNALAGQXfshC1MrmjvKQpyhbxkEEcQT7wpdqSKlgzDgFhcBYTwdGCR7mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715838700; c=relaxed/simple;
	bh=cpWaJ+eMi0gVI6L9oDTMwrfL74E04TY3aha+fAqLIJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I5oAJsUTneIbG29t+WTZW0P0rM136cidbopYVU/AYno8546IKr42A9Dg9IwJu3IxF0hBTmuf4B7sIEsf4Kgptmi//gm9PBCHO5Zws7NZSps9ipGlqIFKxd8bwYMJnqPUpWKacBhUoYikUCMtfAmhVDYXnufVL0dom9xNtRBm8sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=hxxZIqjm; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hxxZIqjm"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1715838698; x=1747374698;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cpWaJ+eMi0gVI6L9oDTMwrfL74E04TY3aha+fAqLIJ8=;
  b=hxxZIqjmFr113gL5Fd4ykjI/Mrs5xgX0FhMXHfdPriuOVrBqMGkfrWzQ
   sgRW/RIM+MbZfP8JqAK17R/S9kaX/rXKjLXsTvNPOBGlN7KArjbtAWMKY
   qrAdbMp6UoAxtAlDuB829zCXSpaHFO6YDRO6TmpwZDqqhJ2XcQaOCCXhk
   rXhqcwZEBgueiDq/WnTb/y39vj2Vb+wG0kcJ3TKt+w6R9rwtdf0l/9H6k
   5Tll9x3QT0M8WKVZ8lEQit+Vt8y/XkZUdlx0EQBQuZ/GWvsS/lQ2kY0Xb
   pFdv1IUncJhsTDbvtUGLrgge4cmXRN4PuCv8zer+V47/21p+gIzxFM9xI
   g==;
X-CSE-ConnectionGUID: vZPcrZdnSTKFYaYAf06t3w==
X-CSE-MsgGUID: /m9cWilmS9SVdAFjl6pTUw==
X-IronPort-AV: E=Sophos;i="6.08,163,1712592000"; 
   d="scan'208";a="17296230"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 May 2024 13:51:31 +0800
IronPort-SDR: 664592a3_wG3DMHgPrDTGd1ZDwI7tApJ2LAEXTdmvpATu7l7mfoDNzkM
 kHQb0x7onvlHrfdAVevXL+mmlqXC5LAdRDMAhnA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 May 2024 21:59:15 -0700
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.45.31.229])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 May 2024 22:51:29 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 0/3] scsi: ufs: Allow RTT negotiation
Date: Thu, 16 May 2024 08:51:21 +0300
Message-ID: <20240516055124.24490-1-avri.altman@wdc.com>
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
as of today, there does not appears to be no-one who sets it: not the
host controller nor the driver.  It wasn't an issue up to now:
bMaxNumOfRTT is set to 2 after manufacturing, and wasn't limiting the
write performance.

UFS4.0, and specifically gear 5 changes this, and requires the device to
be more attentive.  This doesn't come free - the device has to allocate
more resources to that end, but the sequential write performance
improvement is significant. Early measurements shows 25% gain when
moving from rtt 2 to 9. Therefore, set bMaxNumOfRTT to be
min(bDeviceRTTCap, NORTT) as UFSHCI expects.

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

 Documentation/ABI/testing/sysfs-driver-ufs | 14 +++---
 drivers/ufs/core/ufs-sysfs.c               | 58 +++++++++++++++++++++-
 drivers/ufs/core/ufshcd.c                  | 39 +++++++++++++++
 include/ufs/ufshcd.h                       |  4 ++
 include/ufs/ufshci.h                       |  1 +
 5 files changed, 109 insertions(+), 7 deletions(-)

-- 
2.34.1


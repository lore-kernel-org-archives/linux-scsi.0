Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5804E209F50;
	Mon,  3 Feb 2025 15:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738596700; cv=none; b=u4V0ogp4A2rtOdLDBSApkcjNtQLYz6fLOIM7GM0B4sqWzzXhGCECIYNxRsTI0JhSAJAS1BieGsPKIXClGI4lYck+Rwe9KImy5KJG+89NbwvJZktGEdmKltLuGcHIVCxOJ77Pu1YtHf9BbqpR5NxAnH6I1nxUJnT41MX+tZVcdE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738596700; c=relaxed/simple;
	bh=sItThnSsLUDr/pY3czUV9T87GFqKvM9V5bgQySx2170=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SxfBzKI9O4ufY8Q18FT+6xiQJFK4Fs0tUrmteRoPEQ8UdqzOvx/rWtLl3sBGfxkaZys0A/FyqfjCG3Dw8oZLJUiR0vBgUWcaGNvxylWqtnBGwvyOEYx4Rhb5HDfuY29hqKoccI1b9V7OXp/wySYWGKi7BpaMko1v7Af82ba2+pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VjPryIrJ; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VjPryIrJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738596699; x=1770132699;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sItThnSsLUDr/pY3czUV9T87GFqKvM9V5bgQySx2170=;
  b=VjPryIrJ6Yq9hMxMoguwqkByfeUx0Nb7QrQyKX55y/dpoT9KRBttPJTK
   7/UURU4ynh43DqLqfoVaKIWwg/HpH9z1TXXgduSlbI1V/D7ULx178Zefi
   GracfEJj05uuxObHO6TuaKeyZvT+R9aTryOc3E3HixxpTUQxbg5fF3lXy
   JQoag6vuPHUvcj1ElS6CxepsXAd7VexE/hWIDFyyOTkxDW0nRWzpZH+3t
   dJWADzJKKAFtxurq4UhpR1wmKnS0fJfoLgSoInMm1pArZylkvS0w6FA9K
   J+H67pegf5FGmsLXmzlDThNz0Cy8tznARR+9yTe3hjxCBVM+Zhs5i4zAt
   Q==;
X-CSE-ConnectionGUID: Az2flcF5QEW10xsknGO0TA==
X-CSE-MsgGUID: Nu2pkca3TheTvSYHSmZSeQ==
X-IronPort-AV: E=Sophos;i="6.13,256,1732550400"; 
   d="scan'208";a="38686178"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2025 23:30:30 +0800
IronPort-SDR: 67a0d370_gRTJO95q/w26+yOXvrEWOSLqvd4v45r2Wq+GC/vuj8sP7M+
 oBm7Xac0CO6P10KlwolKRAXZVN0KQjwGoj81PSA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Feb 2025 06:32:16 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Feb 2025 07:30:29 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/2] scsi: ufs: critical health condition
Date: Mon,  3 Feb 2025 17:27:33 +0200
Message-Id: <20250203152735.825010-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin hi,
The UFS4.1 standard, released on January 8 2025, is adding several new
features. Among them a new exception event: HEALTH_CRITICAL, which
notify the host of a device's critical health condition. This
notification implies that the device is approaching to the end of its
life time based on the amount of performed program/erase cycles.

We use the hw monitor subsystem to proliferate this info via the chip
alarm channel.

Please consider this for the next merge window.

Thanks,
Avri

Avri Altman (2):
  scsi: ufs: hwmon: Prepare for more hwmon notifications
  scsi: ufs: Add support for critical health notification

 drivers/ufs/core/Kconfig       |  2 +-
 drivers/ufs/core/ufs-hwmon.c   | 12 ++++++++----
 drivers/ufs/core/ufshcd-priv.h |  8 ++++----
 drivers/ufs/core/ufshcd.c      | 31 ++++++++++++++++++++++++++-----
 include/ufs/ufs.h              |  1 +
 5 files changed, 40 insertions(+), 14 deletions(-)

-- 
2.25.1


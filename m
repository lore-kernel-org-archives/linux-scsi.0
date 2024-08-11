Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9741CAAF;
	Sun, 11 Aug 2024 14:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723387195; cv=none; b=CmTw2mpJZyA5qemZTH0DRM//XhXvNdJwjRDRpgmMCFFXgoFVz7HovfvGchUk5meMn9UTbcaFNJIxT6ojKIP+DrDxOKejzd38utoXBS/0pGmqXZctHowfh8jnUh5T2e5T4LJlmqzkTg362bVyWHr2h1nCJK7ss0XIXywVElgCups=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723387195; c=relaxed/simple;
	bh=zDe6TCZvfmT4KJ1ML8sdFIw8paUDsxuJZeDRaItjiDg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kLxmJ9X7VaMIc0qCzJ54PHbgqP3jbJW7aEhsn+ZPAqFcnenrq9MS8jGn6Pf4FcSNsmlZ2WgNtT2TbBYfuVp2HCsaCcV6japmqU365wRM3yebtYAUsQ/BYAf3oNpQucYcyKqZKlRwmQXvkeEegISxz4wYPvtsJ6+OfEOTW8ThOWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=FtY/yKJF; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="FtY/yKJF"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723387193; x=1754923193;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zDe6TCZvfmT4KJ1ML8sdFIw8paUDsxuJZeDRaItjiDg=;
  b=FtY/yKJFg1+3GuXcvzoYnXQ6DXrmxVpvEvxNxSVfGImqOyLsfohXxp5v
   8XR/j2WQCWru62mw7+eed2ItaioTuBSK5xsnfzPvJ29r7Qkr+QjiY4wNM
   h/EhmeISqceeHgw3OcAQpYdFrz57/lmG7YXKjchex5FPqd1jlrWVUT6rD
   iVA9IfVaj1HvJeWrdcO9i9mgIpYONAdGfuGU/rjCH9lDczLTFEpw13ewf
   WtZ3skDZDrvOHIfDXywuKeKKJj+Aq8srOnW/WjNiYYUruQlIsl1b5h7+c
   3bRbhO7kQd4awFcG/nA1VWSgq6xdoSna3xAZEE6wgbMDQbKz85nNuJ0bd
   g==;
X-CSE-ConnectionGUID: c7ZmLXCxQsGVSEpS7Sfz0A==
X-CSE-MsgGUID: 1/MuZAhHSBSImhyUHYqE8g==
X-IronPort-AV: E=Sophos;i="6.09,281,1716220800"; 
   d="scan'208";a="24305725"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2024 22:39:46 +0800
IronPort-SDR: 66b8bf33_TU/gX4w6oxjBy5jvk+u7EMoPByyQsi+gdZKj6jquJY5QVMC
 anngoYa9krDtn8saTi6+gJHUTUep70eadlNCAfA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2024 06:40:04 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Aug 2024 07:39:45 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 0/2] scsi: ufs: Add host capabilities sysfs group
Date: Sun, 11 Aug 2024 17:37:55 +0300
Message-Id: <20240811143757.2538212-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Martin,

This patch series add sysfs entries for the host capabilities registers.
This platform info is otherwise not available. Please consider this
patch series for the next merge window.

Thanks,
Avri

---

Changes in v4:
 - Drop less useful entries
 - Ameliorate the description

Changes in v3:
 - Fix path in sysfs doc
 - Fix spelling mistake

Changes in v2:
 - Add sysfs doc
 - replace the pm_runtime_xx by ufshcd_rpm_xx for hci register read

---

Avri Altman (2):
  scsi: ufs: Prepare to add HCI capabilities sysfs
  scsi: ufs: Add HCI capabilities sysfs group

 Documentation/ABI/testing/sysfs-driver-ufs | 27 +++++++
 drivers/ufs/core/ufs-sysfs.c               | 91 ++++++++++++++++++----
 include/ufs/ufshci.h                       |  5 +-
 3 files changed, 105 insertions(+), 18 deletions(-)

-- 
2.25.1


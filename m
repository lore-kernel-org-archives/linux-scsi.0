Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075811B010F;
	Wed, 31 Jul 2024 12:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722428539; cv=none; b=BEDxQ96IYAz+pj3xz5ZN8PeknySmdZfFqL1rPAvxMyAUTN548lKQEyZ6pYEonh7SM33Uc8MwUzaowkoXsCojWA6j/MzybJIY4l40mBqe8RIBR3g0BX+8dqzdNWysqF7fBxzDNImHbTwRD2FqZ4vnHHdwq30axOOWNcgCikne+Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722428539; c=relaxed/simple;
	bh=4yuvfKZ6cp3hKJFFzF2BYevjS8UMdpgIvAIaNuIkt/Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rqc7DBuOlt+nchZO7RH+Ju5Bs/PmyFLWTjNDQLQDah14QydmuwcASQ6gBczOAifvhoYy72yDXKThE+b7FC+jrvAl+kIrP58ybjTO7bTi+mMm7YlMHgH1F+YM1W/ovfReFo+xLmjv5tjIzUvNWLOGWsRZdsAg/QB9KWbWcrt3P/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gzCDVr9X; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gzCDVr9X"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722428537; x=1753964537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4yuvfKZ6cp3hKJFFzF2BYevjS8UMdpgIvAIaNuIkt/Q=;
  b=gzCDVr9XqgolARn5hj3mjNMp3VpX2VkiRaOdyg097pgJzJPr039JXs1j
   GFN7p4z+o45NOmvv5br8je+pe5QuGgQvoncnOoQ+s/v7jKbJTzB3b5+lr
   0e2yNqcD+XAmIfmMog8wWD1OkhDG0odPUtpujHhlJVkfDCnvivZwFg5BZ
   5NRg511dMrDeh3Gftajn4D0/BeLXGxNu2266lJEjbEn/1BW8gq8iaJNGk
   T6TnUrmPNeokMrpNmlhtH5UfX99jbNZL1IJynwL3MAJ5OS9GeRUF1nXBG
   0uLxV/5l2f0uJNI5vP8ljAIVqzwbF/cd3z7orm/8UYJoYZDTjnkicz4a7
   Q==;
X-CSE-ConnectionGUID: DYKRoukjT1yrD5Q3+F5MEA==
X-CSE-MsgGUID: 97sYSfJGRHWt9/Z0HVewVA==
X-IronPort-AV: E=Sophos;i="6.09,251,1716220800"; 
   d="scan'208";a="24150835"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jul 2024 20:22:10 +0800
IronPort-SDR: 66aa1e80_1/wTarfHpY4oxZ5UiGCPGAbHkHzBxsPdUV32drmYB/xu0TM
 uLR7vRe0V+/v/0QJ1UHhWddkI+2aMaXPAOBC12w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 04:22:40 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 Jul 2024 05:22:09 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 0/2] scsi: ufs: Add host capabilities sysfs group
Date: Wed, 31 Jul 2024 15:20:49 +0300
Message-Id: <20240731122051.2058406-1-avri.altman@wdc.com>
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

Avri Altman (2):
  scsi: ufs: Prepare to add HCI capabilities sysfs
  scsi: ufs: Add HCI capabilities sysfs group

 drivers/ufs/core/ufs-sysfs.c | 133 ++++++++++++++++++++++++++++++-----
 include/ufs/ufshci.h         |   5 +-
 2 files changed, 120 insertions(+), 18 deletions(-)

-- 
2.25.1


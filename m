Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7CC42A80;
	Fri,  9 Aug 2024 07:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723188312; cv=none; b=VYOlgIjbyM0n0HSN1dYamYm2Ll7OseQreGV+v6SgT7HM2H5PDnKcaO2bW2PrO04hharTVqWaYGxfWqTJa6HZai+wv7H1MUBq4EJL0+rliJi5STv1qGrgyTN9f6W/9YdgBRjr4h7jS7R6mFHro246eOD0Jo3f97Gg4xD7vwNKvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723188312; c=relaxed/simple;
	bh=zKZrjtPKCk5SOx2MfuypY0l49jS7dkkv1bMHPoJA5u8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KxS52kXX9puGDKY3KFLRIVewDgzOfeJC6b2C2lh+cV/RG65nqVfkDKldTpOJBKkT+EYbd3XgUK06SsUt0Lb28p2EBnGfBil+0qqW7PmU1ES/mrEL9+N6b2hDD1GmaRoRwprwVOjIvKpg/a2+Z7UMog1L/wOw/HUSQTE/tJRN8Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=I8iqVlLo; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="I8iqVlLo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1723188311; x=1754724311;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zKZrjtPKCk5SOx2MfuypY0l49jS7dkkv1bMHPoJA5u8=;
  b=I8iqVlLoAyA/aOUVvrWmnoAzzxyZ4QHa9tVKrQHzv3Bxl3zDX+pjl0Os
   kA77QRIn8SyWa5/Bx21Vz9FKdm4xiAAqtWyJHW7kftqySxutP1nFjJAHW
   Hn3t0BQOUSmxAMZNsOUcJOQnMinU+FwuWCeUBipJRenjjWm49jTD71d6O
   hiT2yjj+dqaWzSRFleRV8YALILe4gSQhc/4nZnKU8a4cyGqGBvgXGaOJT
   sS4/1WR5jZTHkSbUfDk0mh/FLY8DEP79e08oPpaLOGK6lLHiDVhD6f0ae
   DtYqOJNGbjN+EAvBypnpXAJi1LvrvBWO3m8ecje3KRDa9CMevQD5xgZ9u
   A==;
X-CSE-ConnectionGUID: WUcXVfzdTFGGuUU7JFIhyg==
X-CSE-MsgGUID: tXqNiQD4Rna+XBCd9Mc6cQ==
X-IronPort-AV: E=Sophos;i="6.09,275,1716220800"; 
   d="scan'208";a="23232716"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2024 15:25:04 +0800
IronPort-SDR: 66b5b7a7_LYL0L7mHPu+ZTbWTKh/qRuI/F+YCgCSU3kvKPt38xw1XVil
 iDQpPtYVCoWURywqngpfVfVl6eG78UmD6Bfr9Bw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Aug 2024 23:31:04 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Aug 2024 00:25:02 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Keoseong Park <keosung.park@samsung.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/2] scsi: ufs: Add host capabilities sysfs group
Date: Fri,  9 Aug 2024 10:23:29 +0300
Message-Id: <20240809072331.2483196-1-avri.altman@wdc.com>
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

 Documentation/ABI/testing/sysfs-driver-ufs |  42 +++++++
 drivers/ufs/core/ufs-sysfs.c               | 133 ++++++++++++++++++---
 include/ufs/ufshci.h                       |   5 +-
 3 files changed, 162 insertions(+), 18 deletions(-)

-- 
2.25.1


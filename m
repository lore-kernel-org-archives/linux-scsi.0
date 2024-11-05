Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCC1D47BD;
	Tue,  5 Nov 2024 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806042; cv=none; b=EOj2WeqEg0kVaSUmUOVHQJv0+u3eRMY1YBQXdt8DRItCK1v7+SPqIqHmFRmDT85VEpBUPgTF2BxmaOq0GLaK6R/l+cf+WizEsQSpz1ZqfEDHnlFH57CsBCsVkIt4gzYASQN1XbVKydqv3Ukn9Iwv4co13Oj8A0gZY6L2a/guA6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806042; c=relaxed/simple;
	bh=VWSBYO83zQJzZ6UaOvQdluf5OkKaoloZK3ZxtmVjY2Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oFWytHIUbYYgiqnNxmvIliw3ybLsE8dGBpkQLLwT7T2cPNNbKbI3Rtv73JKmKvSbn40mCo/8J8OAnDVrC9qU3GU5HzQ1hftFYrg4uUho6Fq8le5ZgidG+893zfqfXyjBCjDjZV+Vp9aqglpvjvO0pDlGbhQweKcuVJGDWBLGAjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=iy+iyzan; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="iy+iyzan"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730806040; x=1762342040;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VWSBYO83zQJzZ6UaOvQdluf5OkKaoloZK3ZxtmVjY2Q=;
  b=iy+iyzannve9sWcHNl6rnXN8PSlI6p0sXadVbzc4XMfZHEowAWsd5/1e
   TZhrNXtheFpOVA2ej+nGe35niU6BI2oaL4R5t2ykOodQ332Oxx2yhcAb7
   89p8BtEXWe79KniRjH8o2gb67wSBDEuC7SU7kNsGHF56XOXSb8id9PnG+
   ZmbqOth8TjZBUXOzI8gtczesIe+zbFcicSOHX8Tws/xSa+arZ2naDd97V
   KrgfUmFJw6IqEhltM5DRQ6ymDmz/LuJ+XMs/DIFClqylSEQG3q3EqcB7G
   bI9du87OQ5pU5w1tboFEfnlAvlUcqVTHTxN+m4o70s2Da3kqbSF6U68YA
   g==;
X-CSE-ConnectionGUID: 5gZgIYMqTy6enetvfmx1nQ==
X-CSE-MsgGUID: dp4firN+T/urUxQeV9+oGw==
X-IronPort-AV: E=Sophos;i="6.11,260,1725292800"; 
   d="scan'208";a="30658783"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2024 19:27:14 +0800
IronPort-SDR: 6729f291_mXwyL4jxc+EKT/7JHefDv/fw4gZ6VKPPQR5RBZ7zekwyKeO
 ACjCKrOJRM7egYMMA7Q6lehGwwyuZxATPIrHMug==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2024 02:25:22 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Nov 2024 03:27:14 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 0/2] Untie the host lock entanglement - part 2
Date: Tue,  5 Nov 2024 13:25:00 +0200
Message-Id: <20241105112502.710427-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here is the 2nd part in the sequel, watering down the scsi host lock
usage in the ufs driver. This work is motivated by a comment made by
Bart [1], of the abuse of the scsi host lock in the ufs driver.  Its
Precursor [2] removed the host lock around some of the host register
accesses.

This part replaces the scsi host lock by dedicated locks serializing
access to the clock gating and clock scaling members.

Changes compared to v2:
 - Use clang-format to fix formating (Bart)
 - Use guard() in ufshcd_clkgate_enable_store (Bart)
 - Elaborate commit log (Bart)

Changes compared to v1:
 - use the guard() & scoped_guard() macros (Bart)
 - re-order struct ufs_clk_scaling and struct ufs_clk_gating (Bart)

[1] https://lore.kernel.org/linux-scsi/0b031b8f-c07c-42ef-af93-7336439d3c37@acm.org/
[2] https://lore.kernel.org/linux-scsi/20241024075033.562562-1-avri.altman@wdc.com/

Avri Altman (2):
  scsi: ufs: core: Introduce a new clock_gating lock
  scsi: ufs: core: Introduce a new clock_scaling lock

 drivers/ufs/core/ufshcd.c | 219 +++++++++++++++++---------------------
 include/ufs/ufshcd.h      |  24 +++--
 2 files changed, 111 insertions(+), 132 deletions(-)

-- 
2.25.1


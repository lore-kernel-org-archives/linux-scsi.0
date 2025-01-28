Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F291A7044;
	Tue, 28 Jan 2025 07:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738048507; cv=none; b=D/HbXJaJQWGxh/pT+3GbRnjjUPExl5EbMPX/k1iMqGX0IiKEMAmTL/CbgcOYqbdYYQ/JLDosAZqQAla9pD7Qh56So/0NEffyucmXKZj0wmMY6itpEA/yZy4XcmMK03xHMTpkKJYyPnMlE/ds+eZzgBBBF4lLSGfDQT7zwZEhjf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738048507; c=relaxed/simple;
	bh=ARGs8WQ9+1gZ74ogiqJpKLcnjFxRrjTbltzMymRmbtA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FipecUVcyRhj/i6BrqPsmLVYFAgcp2HV1d8ShHvnh/2M5ngxC6N6EKP0P2kviPGqPBuGMSe1a3iCpOI4OgcVfk9ZVI9rWigORBwJBD7iB7CB9LBOJh/8XM8M2NSw09GBiC6mRyQBXRTBhvLchK8+XLONJQXYi996bBrF8oko5cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MOs49nYt; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MOs49nYt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1738048506; x=1769584506;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ARGs8WQ9+1gZ74ogiqJpKLcnjFxRrjTbltzMymRmbtA=;
  b=MOs49nYtLcp9zn0EKYYQzxDG2UTw1/tTjZ0Jv/gK6yR39TSW7NnnjMrZ
   C/RMVKXY1IUTk6QHlfSBaFh33IYHbQ5A57jmmWg/Sbn/8epFXoMhjkj3e
   bjS6esgeH2I6eXMzMsW1ppIoWM2XUhK3J7E1esFGNioDUJYTnM6qTZn1U
   sRCpVpDikLqpL6MZyDX22aG1MA1cDZH1UZiEwA5A+SdWGTBVMQRnCN0Gl
   UECQ/57GS5eyjc3qqvXxuqbkSOUB62djEfNf+Jebqi4gmxCbBsuBKC54t
   BVKJHbBs8rOxhAEJoXSF70bsZcvp3mvVxwZ7b/vRu5I3Gysk2Wld485Az
   w==;
X-CSE-ConnectionGUID: 19s36kU0R9WdKryhRrDa6g==
X-CSE-MsgGUID: Gl9SZAVwSEuH4aeBTnESww==
X-IronPort-AV: E=Sophos;i="6.13,240,1732550400"; 
   d="scan'208";a="36961616"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2025 15:14:59 +0800
IronPort-SDR: 67987654_w1tY/QRx+UJStKf6jS0GAEJ/tDeiQcMI1YOOU6jeqxDe8xL
 HWPYj3vEoym1uAmhZKHFYiJutbshII0UH9VJu0A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 22:16:53 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Jan 2025 23:14:57 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 0/2] Fixes for UFS clock gating initialization
Date: Tue, 28 Jan 2025 09:12:05 +0200
Message-Id: <20250128071207.75494-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Martin hi,

This patch series addresses two issues related to the UFS clock gating
mechanism. The first patch ensures that the `clk_gating.lock` is used
only after it has been properly initialized.

The second patch fixes an issue where `clk_gating.state` is toggled even
if clock gating is not allowed, which can lead to crashes.


Changes since v3:
 - rephrase commit log patch #2 (Geert)
 - Add Tested-by tag (Geert)

Changes since v2:
 - Add patch #2 (Geert)
 - Initialize clk_gating.lock unconditionally (Bart)

Changes since v1:
 - move the spin_lock_init(&hba->clk_gating.lock) call from
   ufshcd_init_clk_gating() just before the ufshcd_hba_init() call in
   ufshcd_init() (Bart)


Avri Altman (2):
  scsi: ufs: core: Ensure clk_gating.lock is used only after
    initialization
  scsi: ufs: Fix toggling of clk_gating.state when clock gating is not
    allowed

 drivers/ufs/core/ufshcd.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.25.1


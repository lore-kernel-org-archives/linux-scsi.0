Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706B41547C0;
	Tue, 22 Oct 2024 07:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583151; cv=none; b=f/lZy0VjUOHLRfX849XTkY2OrZXzSDzNfkwAyi1xdTc5c7wxdEU7iaX0SUMb/HhstWbd4eHLAH/FSkcz8XZDVH9j3+kS4DLv4rkeoRcoBx0dcYHITAFAHQ2Qvn/eJp7thTRLoTkqB146wT3fx2S04Xcp2EUjgTmISFv1vYz5HtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583151; c=relaxed/simple;
	bh=4ULmdBK/TnzmFDAmE0RfGEK1+83dXek4IBvihsRxxdM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KQ+YXL/UguNsxEAd5KVSKbdUdI1uKdQLRQYdqKtntn4J2jShmKfg2KsTH19ZLP4ywbH0puFMX1saI2PcC2IT2Oi0Wd4KntyGVl7Wj37sdfXix+5svab2kNLf3svx1baQw19qX71htISiqK2Ow4KiwdGj+1Mn83J8HSCfMYJSJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SGMrlucA; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SGMrlucA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729583150; x=1761119150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4ULmdBK/TnzmFDAmE0RfGEK1+83dXek4IBvihsRxxdM=;
  b=SGMrlucAj+hDEvG1P4WdIFJZKJkD/Dd85QSu9ZmwGIK2yIV+I04GJLyD
   ZFyAm81A5XJ9fzp8EE+8UWRAQtXfXNpgA7lNmf2+Eze9MRX5gRACKXjFt
   Fbs5Ti04ssLMQ5f+QjrnGygqMVl2KfJilF1mTtKfN8OY84WGEomc68pDE
   n+fruUN12iP970OtHGwlC0HHJULTw4qkLCd1G11WN9v5dlMymqwzQOKkg
   iJQdV+Hp+1QSywIFKutk5yRgmkoSlX5d9XWHeqt6M7YR+xDTjH1mRGcbx
   ndLWmJwu2QlUssVoIyWVM000TaWG7BN1iR8z5K+0WIXb3cwN3h8ATfi64
   g==;
X-CSE-ConnectionGUID: d0xFrv30SvGXoMtGudjZXA==
X-CSE-MsgGUID: CFFVpHvoRgCaILJKFBxRqA==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="29679851"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 15:45:46 +0800
IronPort-SDR: 671749ba_jEV0qG8mVWXtoocC6tYbXCgd/PCUAQ9LibRAFREEFyQiaon
 wPiLRYmVAFjfRixazLjUnpioHjqCp6c+8yjoDIA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 23:44:11 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2024 00:45:44 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 3/3] scsi: ufs: core: Remove redundant host_lock calls around UTRLCLR.
Date: Tue, 22 Oct 2024 10:43:19 +0300
Message-Id: <20241022074319.512127-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241022074319.512127-1-avri.altman@wdc.com>
References: <20241022074319.512127-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to serialize single read/write calls to the host
controller registers. Remove the redundant host_lock calls that protect
access to the request list cLear register: UTRLCLR.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca6b6df797fd..d9b547d8f958 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3076,7 +3076,6 @@ bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd)
 static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 {
 	u32 mask;
-	unsigned long flags;
 	int err;
 
 	if (hba->mcq_enabled) {
@@ -3096,9 +3095,7 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 	mask = 1U << task_tag;
 
 	/* clear outstanding transaction before retry */
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_utrl_clear(hba, mask);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/*
 	 * wait for h/w to clear corresponding bit in door-bell.
-- 
2.25.1


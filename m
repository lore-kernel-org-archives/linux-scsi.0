Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CD71B0F2F;
	Thu, 24 Oct 2024 07:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756373; cv=none; b=lv8011UuKCPi6d1KIDsMbeOKzSX89RGa0V1H2o03YL6JXo8NhsIoXPoyLCZZKvxrraSlVk6h9SCdy0+D5JTlJ/M0HJzkJkzZrYy4W+7jgmBqHFU7TJ9/v+ppkpwkf6MgNVQYOF7IDvmwWNHHG6VVNFC5q5y90YJBQjOejdzp6I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756373; c=relaxed/simple;
	bh=g7K9uanHsVcasrKeC/Dgo7ppPr+wFiIxH1t04wElT6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SDOGkytMjk6k7b9+/6pvALcAcu7MuP9cljvld0QMgOp8oY+IQm9zvxmvNxKWaJdwOPRBtqOfKR24mVCgfpvRBK/O/MNIjo+n5vGiecXUm1RuR87y/ilQbIU2/XOzSRYJ9pZyTfovG6+yuj92/qn6eKd3QU3RjFbeL6+F2eZku4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=NvlqQ6Bo; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NvlqQ6Bo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729756371; x=1761292371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g7K9uanHsVcasrKeC/Dgo7ppPr+wFiIxH1t04wElT6Y=;
  b=NvlqQ6BoCNFMKzRuSZI++lFLxTDBMRhpWUR10dMaJzOTSoPFwwq9wpk1
   +th+VoeDyaWSc8a7Hw7sSBio1mR6uvv9xVoTuNoBXtODKPxM3YUnW8Iac
   ukpUnj8SmSmWlFArFg20dyRlqcjHmY1zrBlljcBC/uuht6E/uLAzH73GM
   L0H3AYpZ7NoU0ZHDJIH5rfWH+N3Rq4svsJwG08rM+lb3ZNkhk0VzEoQF9
   IZjgV1DJvpDQffjVyteEcYgmqdNMk/98ITHPwZKwU1BaHLtQCQsdper1p
   0eSDceeGmtPKs8qEf9PVMw1CSs5rDS8es8kJrW0Fxz16QrijjepqQ8PdJ
   w==;
X-CSE-ConnectionGUID: tcBMAQ6rTFieVJ/ymzWs/Q==
X-CSE-MsgGUID: wc7P8TlzQYy0cZ8mRLAQ1g==
X-IronPort-AV: E=Sophos;i="6.11,228,1725292800"; 
   d="scan'208";a="29156120"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2024 15:52:51 +0800
IronPort-SDR: 6719ee61_djwrYq02H8dM03cc8YiVmWJgQNhr+sBFfqYlAbRdCgjhz5c
 Pk6PP8OYEyyHkhWaAd22bzCTCnxF/jIP2laGv1Q==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2024 23:51:13 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Oct 2024 00:52:49 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 3/3] scsi: ufs: core: Remove redundant host_lock calls around UTRLCLR.
Date: Thu, 24 Oct 2024 10:50:33 +0300
Message-Id: <20241024075033.562562-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241024075033.562562-1-avri.altman@wdc.com>
References: <20241024075033.562562-1-avri.altman@wdc.com>
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

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c2f44834062e..5eefdc02d62b 100644
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


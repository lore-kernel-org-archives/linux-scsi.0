Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949BC1EBA02;
	Mon, 21 Oct 2024 12:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512354; cv=none; b=VjCvHejSd5MN3QhRs5Y+8rVy3BZHfxKoerQdGUL7h9KE7HdYRapPAE9E3RCAlCbLpsEXqgkfFP3JjuD3nOzymQYm8hTKutEbaVA9H6vXA7tg3YkWJ5C/ZyoDMTF+62MgViG1tHxfiWhZN/IJMFU+Gwa65Rbq9dbcmjN+wXOfaSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512354; c=relaxed/simple;
	bh=0uson7Hox7ug5bpH3JgjPms2CLtivTWWc8czSztV92M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a8OoViRFu4bitYNJ1+jNQXGefCg/LIH1cSegNbywL7yKRuY7qDdB0Wx2qgw+DTDodU7dFJcR7k7qsm82X+pqPZJnrX4ivGk7aPUPSLvPGfDj5OgmGQFxDf22FusRWRBrOCpFOjqZNNDsdc0BdIBz/hGBHlzNOwV7z0tsbxt3Nkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dcZehJES; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dcZehJES"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729512352; x=1761048352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0uson7Hox7ug5bpH3JgjPms2CLtivTWWc8czSztV92M=;
  b=dcZehJESJYZ8q6cYWB/KeQitOkchDgVibVornqSIYd1MkqL7H/9bW3lN
   zU3qSDpDOXSUhFeoqTlsQUncLcMfQ0MUDHbYaJQ2jCwdHHMe8H4BwIX55
   aMAMTFqeInSgVdsNPIPX3bcWDWhEcEGRi1JQQx7g+mg1DniQSFnfoQSso
   3B9fABMDYqL6n5gahtOHJuhSnoT5q4YpkSv5j5M7D71yyIstIzBVPj6JC
   14WuDdZxg4rdCh/JSAnJkeEvNcu8Q6bSgYJH+kI8nFL6oxWda7YsifL5u
   Cort1cnenazHldcAzXmwbCdoV3ZiowdxzVleAas8WAfOV2Ct5f5EYKyBh
   g==;
X-CSE-ConnectionGUID: 7h27xvM9Qhiwhh1wmsALvQ==
X-CSE-MsgGUID: +qvsrR9OQv2cMfNbaOQJgw==
X-IronPort-AV: E=Sophos;i="6.11,220,1725292800"; 
   d="scan'208";a="30593008"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2024 20:05:47 +0800
IronPort-SDR: 6716352d_um++icHfYsUAFecsViU8lpK3qtkA8xzOVOM9zBk1Ky95Eb6
 4U60fcAQa3P3/s2ozun5JzNua3UdmzHycPtpKhg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 04:04:13 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 05:05:46 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 3/4] scsi: ufs: core: Use reg_lock to protect UTRLCLR
Date: Mon, 21 Oct 2024 15:03:12 +0300
Message-Id: <20241021120313.493371-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241021120313.493371-1-avri.altman@wdc.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the host register lock to serialize access to the UTRLCLR as well,
instead of the host_lock.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 081cbf7174da..4eee737a4fd5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3100,9 +3100,9 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 	mask = 1U << task_tag;
 
 	/* clear outstanding transaction before retry */
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->reg_lock, flags);
 	ufshcd_utrl_clear(hba, mask);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->reg_lock, flags);
 
 	/*
 	 * wait for h/w to clear corresponding bit in door-bell.
-- 
2.25.1


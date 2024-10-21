Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B105019408B;
	Mon, 21 Oct 2024 12:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512352; cv=none; b=ueMd6whPsl8YNmJiKlPC4DLHoSG6dZEUqo/oGZfcpRkb3ebJm3iBF6cSNNRPFuQoEbytPLFZGX7CmfWVskcvOY1P3OZT3rChUKUHak6Siv7oTAUbWeV8eMauO9l4RCRG/mLIwzi1oEYLF33uLAameWm4A/evKvm8DzybkG9tt8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512352; c=relaxed/simple;
	bh=j5Qs7WR8VhrqTksXZSy6omcXRi+br0ulhTbzygwYwW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jzj0N5iH7n4wwaSZPbM87hd7NaCZhF0wcULO4yv+bFbtWQbVWdUGdQPK9mE5hYqwzeAbBIXMwOwNtsLc92Z+DvnGQpqTIam5KZCn2D+KXg++Xj1jQ6CMa2KMrOuiWKw8lvR3vTlYs1fUQ+dgog10ya0pd7plpCUyk6YBmup5oUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=bsyzt8eu; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bsyzt8eu"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729512350; x=1761048350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j5Qs7WR8VhrqTksXZSy6omcXRi+br0ulhTbzygwYwW8=;
  b=bsyzt8euVyGCsdLaoRl4PZ4WIFwmBIBzBIagJXq9UwAz3U+ypwPgzyPP
   AXXxgyes6tPfB4Acs3pc9DjHY/sutMxairtoAu5M6vw3G9Gyyv4tJ0BHX
   yDF5x3Vk19kU7tV/U1Mcnq6cMAWr0UHS8oKHNRKaSA1cuozzPswWilJAx
   yc29iCZE+2cir5Ox+uHa3US0ptWfFoetY1P7Rq7fDOWSVww88CnESShpj
   cig9I2nWJi+6Kfegfz8RUrJAkEt6R5P8ZuQx8E1oN5Xg/EnvoPSs4vnjs
   mK0HxDqf7aBja1ACqUjdm15BaM/hkuyEl7JrMgFFJ9lAqNy3pa2xS0y+z
   w==;
X-CSE-ConnectionGUID: 2i4N+r9FS7W+Di1JM3bm+A==
X-CSE-MsgGUID: 13DfJHh/TOe+j6dJqvJeHA==
X-IronPort-AV: E=Sophos;i="6.11,220,1725292800"; 
   d="scan'208";a="30592998"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2024 20:05:44 +0800
IronPort-SDR: 67163529_6JBe8mUyJmRNTtw1oDMhj1CNlPA07p4ZLvxh9pto49PbHU0
 SuhN9EcBpxY5hb1B6QDHb3Xo7AY3sYZeHeTNYLQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 04:04:10 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 05:05:43 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/4] scsi: ufs: core: Use reg_lock to protect UTMRLCLR
Date: Mon, 21 Oct 2024 15:03:11 +0300
Message-Id: <20241021120313.493371-3-avri.altman@wdc.com>
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

Use the host register lock to serialize access to the UTMRLCLR as well,
instead of the host_lock.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 21eda055fb7d..081cbf7174da 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7025,9 +7025,9 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 	if (!test_bit(tag, &hba->outstanding_tasks))
 		goto out;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->reg_lock, flags);
 	ufshcd_utmrl_clear(hba, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->reg_lock, flags);
 
 	/* poll for max. 1 sec to clear door bell register by h/w */
 	err = ufshcd_wait_for_register(hba,
-- 
2.25.1


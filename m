Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D44DF9E6
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 06:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710140079; cv=none; b=A6sND4MBLFC2/sbElL6UCKx3OS3TS35/UDi4pBQC0k3uQ7IASFp8a6PZur/dqrreG2owi65HTZ3QmfhEyhz7I5a5XnLycitx0iBz+bGv25nH/lcrDf9c5I+zbnXCOjwJdpQPOBZLvHE2q/YKdFx6ZSPm9WDOjbOfTAC9fnFDztw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710140079; c=relaxed/simple;
	bh=QCZWHaANBKlOqeuMbEIjICI8g1U1Joera6riSwqXOAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVxR0IuVda43IWvp5zwK9RraWYTbJf37eNWomU67jiTUvloknuBqhy/CZSHkWd6jUvGRWSawZuvLohumAjwl72yRoXkl8PkB8gDtscoPYQUArecelYegfsb+THeyVKmk8p6SpB7uNuSjKxcRVUMyGwg/L4sWPA94C+iaLwpbpIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SG1q/1dA; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SG1q/1dA"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1710140077; x=1741676077;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QCZWHaANBKlOqeuMbEIjICI8g1U1Joera6riSwqXOAc=;
  b=SG1q/1dAjXQiNa+kwfUOKBeGnLQGkW1V5WY0KQJ25EL/o1gjP8UKVPM1
   Qs6Y7Rk0S2oXQznNnRaqs3IQX4qcZUpfkuFeHIXkSRhPUfQ0hxnBtdL3B
   hMTuYGzGyJ6Ev0v8nTnZS3CeIt5DYYNs/XNlqJiMKQEYU8+7/R1ISRGBL
   MK4j4Y1z4GaMQjP4l6914GzXly7KbTT8LzSKmB2RRPGVWtqRMLf54JUc8
   CKaIyEFbxVFghgtiftFz7kCfAOm1EndDFrBNsib020pp5q7uwVjArCxXs
   wH5nqFVU1WQWGlW9TXu+6qiQshgR9m07h1JuOpWsrdvrroknUYdJ30Gxj
   w==;
X-CSE-ConnectionGUID: kTCiBSvTQE2/KZZXZ0nv0Q==
X-CSE-MsgGUID: SWDiGzHpQMmeXFqsjXiJtA==
X-IronPort-AV: E=Sophos;i="6.07,115,1708358400"; 
   d="scan'208";a="11270703"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2024 14:54:29 +0800
IronPort-SDR: ZnuJVKPNEo6hwZID1Y+fPc9+vPrLqeASn6dwjQ+6e7reGsTuBvGFePtEbMyCIfc/+mhOoMEZX+
 8geKhIE8NdQw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Mar 2024 22:57:52 -0700
IronPort-SDR: 57eoHWs2ykfy3EnEj9xVNmHXQGCK/bYyUkmqQK7ePjS6qrp04C81GdIxv6a8IUK8XsUix/phzv
 s2afTayzHfPA==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2024 23:54:28 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH RFC 1/2] scsi: scsi_debug: Factor out initialization of size parameters
Date: Mon, 11 Mar 2024 15:54:26 +0900
Message-ID: <20240311065427.3006023-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
References: <20240311065427.3006023-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the preparation for the dev_size_mb parameter changes through sysfs,
factor out the initialization of parameters affected by the dev_size_mb
changes.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/scsi_debug.c | 52 ++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d03d66f11493..c6b32f07a82c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7234,10 +7234,39 @@ ATTRIBUTE_GROUPS(sdebug_drv);
 
 static struct device *pseudo_primary;
 
+/*
+ * Calculate size related parameters from sdebug_dev_zize_mb and
+ * sdebug_sector_size.
+ */
+static void scsi_debug_init_size_parameters(void)
+{
+	unsigned long sz;
+
+	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
+	sdebug_store_sectors = sz / sdebug_sector_size;
+	sdebug_capacity = get_sdebug_capacity();
+
+	/* play around with geometry, don't waste too much on track 0 */
+	sdebug_heads = 8;
+	sdebug_sectors_per = 32;
+	if (sdebug_dev_size_mb >= 256)
+		sdebug_heads = 64;
+	else if (sdebug_dev_size_mb >= 16)
+		sdebug_heads = 32;
+	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
+		(sdebug_sectors_per * sdebug_heads);
+	if (sdebug_cylinders_per >= 1024) {
+		/* other LLDs do this; implies >= 1GB ram disk ... */
+		sdebug_heads = 255;
+		sdebug_sectors_per = 63;
+		sdebug_cylinders_per = (unsigned long)sdebug_capacity /
+			(sdebug_sectors_per * sdebug_heads);
+	}
+}
+
 static int __init scsi_debug_init(void)
 {
 	bool want_store = (sdebug_fake_rw == 0);
-	unsigned long sz;
 	int k, ret, hosts_to_add;
 	int idx = -1;
 
@@ -7369,26 +7398,9 @@ static int __init scsi_debug_init(void)
 		sdebug_dev_size_mb = DEF_DEV_SIZE_MB;
 	if (sdebug_dev_size_mb < 1)
 		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
-	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
-	sdebug_store_sectors = sz / sdebug_sector_size;
-	sdebug_capacity = get_sdebug_capacity();
 
-	/* play around with geometry, don't waste too much on track 0 */
-	sdebug_heads = 8;
-	sdebug_sectors_per = 32;
-	if (sdebug_dev_size_mb >= 256)
-		sdebug_heads = 64;
-	else if (sdebug_dev_size_mb >= 16)
-		sdebug_heads = 32;
-	sdebug_cylinders_per = (unsigned long)sdebug_capacity /
-			       (sdebug_sectors_per * sdebug_heads);
-	if (sdebug_cylinders_per >= 1024) {
-		/* other LLDs do this; implies >= 1GB ram disk ... */
-		sdebug_heads = 255;
-		sdebug_sectors_per = 63;
-		sdebug_cylinders_per = (unsigned long)sdebug_capacity /
-			       (sdebug_sectors_per * sdebug_heads);
-	}
+	scsi_debug_init_size_parameters();
+
 	if (scsi_debug_lbp()) {
 		sdebug_unmap_max_blocks =
 			clamp(sdebug_unmap_max_blocks, 0U, 0xffffffffU);
-- 
2.43.0


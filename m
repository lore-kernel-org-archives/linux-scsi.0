Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3668A19995D;
	Thu, 19 Sep 2024 11:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726745267; cv=none; b=LJ0Ery2E+5nw0dHqJsO5psT/Rur3dXfAiPsRLPA4J5yApx8NjCJP1nw1YGLJKag3wMRrbMnRqPB534gwfSMpJ6EfJ3WwaWY+tBSFNRuM/dzxaW60XdhLw4lpKKxfblmxdeL6026/oIHaAWhJRmxbg0b8GXMk2ydue7Nwv0OvrnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726745267; c=relaxed/simple;
	bh=DDH/DI2Jt9ccazDdm9IeMlRwDdSX7Mww3EN7pjQqztw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LQIrSLATGVzD0huV9XNzP2qzKT0kwUhFfBW18cAdYTwPRga4C2+TveKgeZZKZ4ODpQB//4XuaUgMvPayIFvg3UtTRxmZu/T6yqf0+JBXcs67Am4xl93KyS+Yefbcgg3NijWBJD3B1VXyg5BKGE+mxN53G5Od5nz7aSOxIlzttoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=parP+bag; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="parP+bag"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726745265; x=1758281265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DDH/DI2Jt9ccazDdm9IeMlRwDdSX7Mww3EN7pjQqztw=;
  b=parP+bagyokKQ1pfghCwKa9O3lBPe6IaTmTGn+aHE/a5EAVGi7IwQOQV
   UKI6U7XMmzXVX4n5guafjhox8XBAzZ2OF2VCs5pzs59SXroBNdFT8H8YG
   YT8keWIWjGeJFVRx1IxSFXOj47HhVoGR/gcDxdwQveQUpmm9SmTywnHXT
   DMNbltiJQXnix4dhnJ0bLdok9/9TeVGomPNnDQVZ7nymrz4u0AIlLnjc+
   j8s1yzLMjIDIs94bXS2V0MbliKFkCvwmhR4DukYiOikuMbuVg+k0/l6Wa
   j0cAYa0S/VltqLOFL89vGzpRQMjYeeyRP1aXHsftM746zufjcoze3+QIx
   g==;
X-CSE-ConnectionGUID: xm+01op2SLiQ/Oa5/DTylg==
X-CSE-MsgGUID: HRYGNOdgTd2PsrNGONqphQ==
X-IronPort-AV: E=Sophos;i="6.10,241,1719849600"; 
   d="scan'208";a="27917707"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2024 19:26:42 +0800
IronPort-SDR: 66ebfc43_Mvjnij0wQp/Cv611QBdtx42VKY7PEyFVGOnYkSW/1Z6mAy3
 KNTbO037SgVzSLCbzMCQUbrmq4BOPtRNlCvQbmA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2024 03:26:12 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Sep 2024 04:26:41 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH] scsi: ufs: Do not open code read_poll_timeout
Date: Thu, 19 Sep 2024 14:24:42 +0300
Message-Id: <20240919112442.48491-1-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ufshcd_wait_for_register practically does just that - replace with
read_poll_timeout.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ea5a82503a9..e9d06fab5f45 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -739,25 +739,15 @@ EXPORT_SYMBOL_GPL(ufshcd_delay_us);
  * Return: -ETIMEDOUT on error, zero on success.
  */
 static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
-				u32 val, unsigned long interval_us,
-				unsigned long timeout_ms)
+				    u32 val, unsigned long interval_us,
+				    unsigned long timeout_ms)
 {
-	int err = 0;
-	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
-
-	/* ignore bits that we don't intend to wait on */
-	val = val & mask;
+	u32 v;
 
-	while ((ufshcd_readl(hba, reg) & mask) != val) {
-		usleep_range(interval_us, interval_us + 50);
-		if (time_after(jiffies, timeout)) {
-			if ((ufshcd_readl(hba, reg) & mask) != val)
-				err = -ETIMEDOUT;
-			break;
-		}
-	}
+	val &= mask; /* ignore bits that we don't intend to wait on */
 
-	return err;
+	return read_poll_timeout(ufshcd_readl, v, (v & mask) == val,
+				 interval_us, timeout_ms * 1000, false, hba, reg);
 }
 
 /**
-- 
2.25.1


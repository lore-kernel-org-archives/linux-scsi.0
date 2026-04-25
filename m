Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAF32288CB;
	Sat, 25 Apr 2026 06:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777097101; cv=none; b=IqSMvaSfqS9FnrHkaJqRYqCs1YedfQiAAHUJDOiSl0k1zenOZrUkqfoGdobJGXdSUWFvvwWTdLHQPCMmB2yAkvy3aySudVawWAlU5xpiM87ShKOXNI+lk3vR1KLh+++rMSyw/IaCNRpXvSAy9Yhu4brE9Uv/tJIXS/eDwnSF0VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777097101; c=relaxed/simple;
	bh=GRQpsoTzXQTllzYjUYJAaXxOsyttrFLUC64Cen8qh94=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JO6wr6icIdAGh1dmqChrUEnxM5okTboRTw9x1yzT4Inn4B+YO8mPuma0KhC34Zzxzeu7D2MLzOYQgTqx4QtC+lu21nv0v7AGBIQCWX4uQXmF/aSA5jmy14FMW4LgB5jALHrZzXit4NkdVjeWPQ4maYav6GxyLUtpx/y65539D7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=bWQ3V/xl; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="bWQ3V/xl"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Edk7I3lUpnY18BK/NsPaVybYI9OMyZcVEo7PTfj8RNM=;
	b=bWQ3V/xl8W/E0SbURe8yGHozhWmvpDz96Y/I7nlYp/9I81RmOctUM8MaKZeSCiLRjNOsouxKE
	DInJfoi/iXLzTgSkJxSNbHPaiuBZS+bQk5FhMCOqvPGC+TXheMoOgg70u+jb37I0Rvgt0o7k8Dp
	+1k+pWc3QRBU4mt6uOFN5ME=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4g2fJW1D10zpSvH;
	Sat, 25 Apr 2026 13:58:19 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id C9B2E4048F;
	Sat, 25 Apr 2026 14:04:48 +0800 (CST)
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Sat, 25 Apr 2026 14:04:48 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <dlemoal@kernel.org>, <cassel@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangxingui@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH] ata: libata-sata: retry hardreset when device detected but PHY not established
Date: Sat, 25 Apr 2026 14:04:47 +0800
Message-ID: <20260425060447.1312763-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100018.china.huawei.com (7.202.194.12)

When sata_link_hardreset() detects that the link is offline, it currently
returns immediately without distinguishing the reason. According to SATA
specification, the SStatus register's det filed (bits 0-3) indicates:
  - 0x0: No device detected, PHY not communicating
  - 0x1: Device detected but PHY communication not established
  - 0x3: Device detected and PHY communication established

This patch helps improve device detection reliability and adds a check
when the link is offline but det filed shows 0x1, return -EAGAIN to
trigger retry, rather than giving up immediately.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/ata/libata-sata.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
index b9d635088f5f..e5bb92c38e38 100644
--- a/drivers/ata/libata-sata.c
+++ b/drivers/ata/libata-sata.c
@@ -667,8 +667,18 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
 	if (rc)
 		goto out;
 	/* if link is offline nothing more to do */
-	if (ata_phys_link_offline(link))
+	if (ata_phys_link_offline(link)) {
+		u32 sstatus;
+
+		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
+		    (sstatus & 0xf) == 0x1) {
+			ata_link_warn(link, "device detected but PHY not ready (SStatus %X), retrying\n",
+				      sstatus);
+			rc = -EAGAIN;
+		}
+
 		goto out;
+	}
 
 	/* Link is online.  From this point, -ENODEV too is an error. */
 	if (online)
-- 
2.33.0


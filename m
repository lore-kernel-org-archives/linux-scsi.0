Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B9B2EBB86;
	Thu,  5 Mar 2026 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772693231; cv=none; b=r8HMPT8sDjcIjIlUCZJkx1S7tsySN2/oT3Bu0eDHScEzicxvn6gc5hCZncJIKoDfm3kvCIhG0St9D3DB02C21voyaIX+CZWGWX3SkXGbzexortQ6ijqk82jRaLYjq0NzxbVqbu30arSU7CV2d1aWSkBdStd5XbGXU6b9vZdw1NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772693231; c=relaxed/simple;
	bh=tjz8DYTFLILaLPZ2POqqGVLbbtO83RpCWW9MF1wDxnA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P0yPsHndgDdqHFYoVzPgW7TkLOoJeIBqI50iYOJNMLqqPtoUp9QkV5Dmq93YN8QvTJcT1qtizymCjDiIS4IpkvMCUj7NOlFVfqmYXRWSKf7z7qkUAJWm0Tu/nyxmsn0u8UI1eyI+GModjB6j9BIjervt/Ej35PvKq+1fuAbJLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=VAMv6CGV; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="VAMv6CGV"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iBOVi96Sh49dtoTfm+FbmO+TG0+HTIsqRUXIifZb570=;
	b=VAMv6CGV1oPRE1T62SqdTnfWCyUc6XQp4pSZeb4ruQDt2OxWrDEIYrCt5bwyy/mMh/ik6eYo/
	GvZRfsz/yRiSD9s6TvY311k3W5QgErXjRUdfhTvQSv330PqqiUkamh7LKk0ZbKLTYfG3MdWKz0j
	An3vP7tLqh+GPeBpQEymYY8=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fRKhf3y9rz1cyp9;
	Thu,  5 Mar 2026 14:42:10 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id EB9AD40568;
	Thu,  5 Mar 2026 14:47:01 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Mar 2026 14:47:01 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangxingui@h-partners.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<liyihang9@h-partners.com>, <liuyonglong@huawei.com>
Subject: [RESEND PATCH 2/2] scsi: hisi_sas: Fixed the risk of overflow in bitwise logical operations
Date: Thu, 5 Mar 2026 14:47:00 +0800
Message-ID: <20260305064700.116033-3-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260305064700.116033-1-liyihang9@huawei.com>
References: <20260305064700.116033-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemh200005.china.huawei.com (7.202.181.112)

Fixed a few constants defined via macros that had overflow risks.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 6a841d53bb10..ba9d6877483a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -432,7 +432,7 @@
 #define CMPLT_HDR_IPTT_OFF		0
 #define CMPLT_HDR_IPTT_MSK		(0xffff << CMPLT_HDR_IPTT_OFF)
 #define CMPLT_HDR_DEV_ID_OFF		16
-#define CMPLT_HDR_DEV_ID_MSK		(0xffff << CMPLT_HDR_DEV_ID_OFF)
+#define CMPLT_HDR_DEV_ID_MSK		(0xffffU << CMPLT_HDR_DEV_ID_OFF)
 /* dw3 */
 #define SATA_DISK_IN_ERROR_STATUS_OFF	8
 #define SATA_DISK_IN_ERROR_STATUS_MSK	(0x1 << SATA_DISK_IN_ERROR_STATUS_OFF)
@@ -444,7 +444,7 @@
 #define FIS_ATA_STATUS_ERR_OFF		18
 #define FIS_ATA_STATUS_ERR_MSK		(0x1 << FIS_ATA_STATUS_ERR_OFF)
 #define FIS_TYPE_SDB_OFF		31
-#define FIS_TYPE_SDB_MSK		(0x1 << FIS_TYPE_SDB_OFF)
+#define FIS_TYPE_SDB_MSK		(0x1U << FIS_TYPE_SDB_OFF)
 
 /* ITCT header */
 /* qw0 */
-- 
2.33.0


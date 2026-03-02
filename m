Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28EE37FF5A;
	Mon,  2 Mar 2026 06:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434316; cv=none; b=lBHDRbLu1kVtfxbYdEiQmqttoNl3trcUak765k0lPhPVkKO7rgApszfMc3x0gsFCucswCGAu8PIHbai3Uv4eBm7ZEkRs0KBJkP2tyWZfaMse9fyHQPbN6V/2tXBquRVQSuAX7liiXzzkwD1gNwwIr8yAOP9j3WV00pUDzQx4jus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434316; c=relaxed/simple;
	bh=gOOUmEidWugFLrAOFqpFlVsAFFE67AjmXaoJeKiLGto=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tpiSJWRBGkHU5tWHvwSoyOxmBPBGWYnzgJJHFaAwpTXj2DYTtL3fQthkK98nQlPXUYCBIaUssczz0Ju1UXp/E6RpYxPRpMbC/xRtAZxuJZld4HgEvWbsgvZz6GG3HEGq+1Wwt+GlbpaxnwfAOGoxTT/gkcmm9npboWhRKzbNL60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=WM/DmGAu; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="WM/DmGAu"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x96wp+U8AgQxI7Ntyo5v9hm0QtD55MbMieSRSZ4rJ0o=;
	b=WM/DmGAulW8eqjUr7m3SFab1RS1knOGSAE8B1TUfKdq0Vv7Pn4kazeNDT8Cbs/m7qit//9RYn
	q5/nuk278hIwHTgMbF7RPlZwpkRxmH9IGZgQSQ+iez9ajRfAVK5ZZAwiHOjl3fvb5UdDAGXRqnM
	MzJeJiqWB1rdqqlNfOIQack=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fPTxn2Ds7znTW0;
	Mon,  2 Mar 2026 14:47:09 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 30E6640562;
	Mon,  2 Mar 2026 14:51:47 +0800 (CST)
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 2 Mar 2026 14:51:46 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangxingui@huawei.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<liyihang9@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH 2/2] scsi: hisi_sas: Fixed the risk of overflow in bitwise logical operations
Date: Mon, 2 Mar 2026 14:51:35 +0800
Message-ID: <20260302065135.841653-3-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260302065135.841653-1-yangxingui@huawei.com>
References: <20260302065135.841653-1-yangxingui@huawei.com>
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

From: Yihang Li <liyihang9@huawei.com>

Fixed a few constants defined via macros that had overflow risks.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
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


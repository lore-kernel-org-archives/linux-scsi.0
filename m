Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E32135677E;
	Thu,  8 Oct 2026 03:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429979; cv=none; b=EJIrqj2xPR7vYa4yfDabPDKVL3K0h2UlUDYoLQ9Tj/fUugsq1i0ar6JlUWj8dpivb7PBRtCoGvYg8NNaL0UJqCK9N6TnrdmBV597UjtEjnLl1S++s6lxzZn8VLmJMRLA4MI4Y7qWTUZ5dfbbCGaywwzkuKRwOcXvQlvAunaP5cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429979; c=relaxed/simple;
	bh=YGBMYM1z2o/Q5w9jEH6xIY6TbDDsbogSpgPbTr+m/RY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYpqmA6M7Uzoq0T5/XqIxrux8VAQVg54C5kD96YZJ2lzFNigGPBFQvRnWLfs0xVfhX9bcJTEQlocKxdA4H92Uo+7fa/+U+vegmA/IC4Lrx129OQtTssn+TaQ1yoGqW5qfsJ05lcnLVvORl2aqvZ6Zh0K3Sl4UtIw8kWOyHcoGuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=hnGxfHJv; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="hnGxfHJv"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x3rsevz+xlK1p56nF15nSzSuA7KlVfVMFR+K/1Lrv8c=;
	b=hnGxfHJvpUVBJbj8Dj2XVjLuluFHLljMuFunLE/rnzT9qP7FPruFLuNuf5QijArknCJdCbVDc
	/6IjnCaaNV3TucKUtJOIzdz18Ze6GP1EA9tjct8h2+CV1B4Df8KsmUacOxBgpae74BblL+fVDhT
	hcy933dHO8xyiO187j5sjCw=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4j0ZqN5B6Dz1cyV9;
	Thu,  8 Oct 2026 11:14:56 +0800 (CST)
Received: from kwepemp200007.china.huawei.com (unknown [7.202.195.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D5DE40563;
	Thu,  8 Oct 2026 11:26:08 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp200007.china.huawei.com (7.202.195.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:26:07 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 8 Oct 2026 11:26:07 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH v2 1/4] scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()
Date: Thu, 8 Oct 2026 11:26:02 +0800
Message-ID: <20261008032605.2853026-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008032605.2853026-1-yangxingui@huawei.com>
References: <20261008032605.2853026-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemp500015.china.huawei.com (7.202.195.9)

The min_t(int, ...) clamp of the device-provided sense_data_len
turns negative for values >= 0x80000000 and is then used as the
memcpy() length, reading and writing out of bounds. Compare as u32
instead. Well-formed responses are unaffected.

Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
Cc: stable@vger.kernel.org
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index e9d291007817..2080e5836179 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -25,7 +25,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	case SAS_DATAPRES_SENSE_DATA:
 		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-			min_t(int, SAS_STATUS_BUF_SIZE,
+			min_t(u32, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-- 
2.43.0


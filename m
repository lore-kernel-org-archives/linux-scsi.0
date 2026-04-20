Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6989E2E8B83;
	Mon, 20 Apr 2026 02:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776651056; cv=none; b=ZMuLda4thRRG4BKVLi4dNjyPfKe828TY6qo+1qDGrN3HwkzInUiqoNsNpTbStkneFzkcprzvjFMDRpKiCsoyJSi5Af1Do21X/o8pIlRM4ouFpDSAP7STwXUpJmaZWvrThWxsnlwxYRw+nO5SaMn0u/v6p5p1h/VBpWgfBCKujaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776651056; c=relaxed/simple;
	bh=lWR7MhGYSatBSCNUGiSEFHjUOepwuNKPCoOVXjYxDtM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZRatjHDd6zmCxqzFk7QOrg4gOwiPpZjPQ5+esaJGEQUXuM0AImhg+5aFsySudX2O/3AtYDHB/e7+NIyJM1cnqsXqC33WN8MoWTwamp0bVVt1OjrT0emI2klYLjesmmUs2O7jiwu4/DgmR72HOr9yRnbKh1OgpM87mS3UsPcb0fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=hAC/Yv10; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="hAC/Yv10"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HApIE9xxp+eWMtVr1WfRulU8JowWx5rfKr8q6ihbo1Y=;
	b=hAC/Yv10fZFjpN1ZxSD612+Z7xjbw4qvSiEUp5dAvpvSeQXG8d/qURQvLa8MdaYGY5WpnAyUC
	D9/N3piDw6DEgCSv05eOu6z3NajEOcx4V0lVuNwc1g7Rr9U742Zdq4icj0pW4MFuDltMeoMdnfr
	F/lp20ToEdPRTNfV9ZNMIeA=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fzTM16bPbznTWD;
	Mon, 20 Apr 2026 10:04:29 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E24640571;
	Mon, 20 Apr 2026 10:10:45 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Apr 2026 10:10:44 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: Fix sparse warnings in prep_ata_v3_hw()
Date: Mon, 20 Apr 2026 10:10:44 +0800
Message-ID: <20260420021044.3339459-1-liyihang9@huawei.com>
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
 kwepemh200005.china.huawei.com (7.202.181.112)

In prep_ata_v3_hw(), add cpu_to_le32() to fix warning:
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1448:26: sparse: sparse: invalid assignment: |=
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1448:26: sparse:    left side has type restricted __le32
drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:1448:26: sparse:    right side has type unsigned int

Fixes: 8aa580cd9284 ("scsi: hisi_sas: Enable force phy when SATA disk directly connected")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202604191850.IVYPTaML-lkp@intel.com/
Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f69efc6494b8..1b180d05a7fa 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1491,7 +1491,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 		phy_id = device->phy->identify.phy_identifier;
 		hdr->dw0 |= cpu_to_le32((1U << phy_id)
 				<< CMD_HDR_PHY_ID_OFF);
-		hdr->dw0 |= CMD_HDR_FORCE_PHY_MSK;
+		hdr->dw0 |= cpu_to_le32(CMD_HDR_FORCE_PHY_MSK);
 		hdr->dw0 |= cpu_to_le32(4U << CMD_HDR_CMD_OFF);
 	}
 
-- 
2.33.0


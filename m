Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB61CD02
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353913; cv=none; b=BYfiZw1bR9mSoiCa4A0lAsxqDSUpIpklyP4vsk9FSoZN4HofdH62FH3hRB+vo9r7CcfW8gL3ea37BsMcuZBELu6ljF63JTA0jnYYbDhPDdKrMPO6IDVVbIIW4pNVTnKIbSVTGOqSUX7t9IlL6o4nf+QKGv6T4yDu4dvviHPdX2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353913; c=relaxed/simple;
	bh=xTjgmxjUQOrAgGbUGWkMw4i3mA4aIVZJF0wCWu4HPHA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZ+ypstaA2MhMBCLPibBGXNbT8s3RRVLs1AGgWAevCy7li/VKQ6CppLVRsQ17EGOJpSZpARo9J5ebFsLe3vcS5+I8LkT8u8eejmHiHbvKYRVOcjbBbYdq1yCWljaRNxiDfqBHoj5q4gT2EjtYhwdyFAUGtNpDVzaQynXCBRFTMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XN05x3qVcz2DdBZ;
	Tue,  8 Oct 2024 10:17:25 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 158081401F1;
	Tue,  8 Oct 2024 10:18:29 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:28 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 10/13] scsi: hisi_sas: Add time interval between two H2D FIS following soft reset spec
Date: Tue, 8 Oct 2024 10:18:19 +0800
Message-ID: <20241008021822.2617339-11-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemf100013.china.huawei.com (7.185.36.179)

From: Xingui Yang <yangxingui@huawei.com>

Spec says at least 5us between two H2D FIS when do soft reset, but be
generous and sleep for about 1ms.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 93f9f13084fd..53cb15f6714b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1321,6 +1321,7 @@ static int hisi_sas_softreset_ata_disk(struct domain_device *device)
 	}
 
 	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		usleep_range(900, 1000);
 		ata_for_each_link(link, ap, EDGE) {
 			int pmp = sata_srst_pmp(link);
 
-- 
2.33.0


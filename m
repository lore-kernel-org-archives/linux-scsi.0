Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F34C120;
	Thu, 15 May 2025 01:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747272916; cv=none; b=kMLyL/6KvjsIyEEx9ags0ZFbXLz0Y1Zg61ZL8c/sn3a9AWaRNQPa+3fP7CGEMXtpAyhu/ImX4QdEXppwqBjAj9gir5UUgFtzqn3h/SHgkJRdT4/4u6MKyCZAF0dezTNdZ8rO4gNSaKH9sRy6hMWnDbO/+XlGmG4qjvigvLww1fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747272916; c=relaxed/simple;
	bh=LlpPGyBl+GCm/7I8MrIrcNdTHLEJpltCkDT8u6enguo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u78rIiRvP0ay9lzMo9dJvLShYl7D3EfDVE5xr+8AbrYkxAo1hsvD0eZrjNUo9n5VayUmw9pAbZjDuiIO4tqrR7evJnZcK1Q8+y9ZdtK4Dzek7+fZIR6oe0WNieAgmX9uULV5nVvfDAF5sZKnOac9qLWdVlcAX7R9zTJmXV1IDUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZyXmL0K6hz1DKfX;
	Thu, 15 May 2025 09:33:38 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id EE33B140109;
	Thu, 15 May 2025 09:35:04 +0800 (CST)
Received: from localhost.localdomain (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 May 2025 09:35:04 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@huawei.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: Fix warning detected by sparse
Date: Thu, 15 May 2025 09:35:04 +0800
Message-ID: <20250515013504.3234016-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf100013.china.huawei.com (7.185.36.179)

LKP reports below warning when building for RISC-V with randconfig
configuration.

drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4554:25: sparse:
sparse: incorrect type in argument 4 (different base types)
@@     expected restricted __le32 [usertype] *[assigned] ptr
@@     got unsigned int * @@

Type cast to fix this warning.

Fixes: 4ca7fe99fc84 ("scsi: hisi_sas: Use macro instead of magic number")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505150705.k9ZzMxf1-lkp@intel.com/
Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d7f45a2eb200..bc5d5356dd00 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4558,7 +4558,7 @@ static int debugfs_fifo_data_v3_hw_show(struct seq_file *s, void *p)
 
 	debugfs_show_row_32_v3_hw(s, 0,
 			HISI_SAS_FIFO_DATA_DW_SIZE * HISI_SAS_REG_MEM_SIZE,
-			phy->fifo.rd_data);
+			(__le32 *)phy->fifo.rd_data);
 
 	return 0;
 }
-- 
2.33.0


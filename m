Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EE51E868
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353912; cv=none; b=qJzrRQ9f+hrN6jRd59hT6wehEruRjkLijNGSksrZsbnoAXLKGq6QLRgSkKZdZ5pG9UshcJ/OBP3h7HWA2A6BZHrwfqZJWZnAlA+ebuzAAoI5EOXeszt3l4i9Hyrg9aO1wQ0I+8/0widgLc1WbubC24H4ruXMRTh1VvkmmKkgrFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353912; c=relaxed/simple;
	bh=XxysoIL/DqlH/+8Jvs7Sw+K4akm488Qhpu05ZMjN0Fs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k7EY4pcVrJ50k45yJDvZwgi5GkIK6KJs+CUjysmQHqyU24Xj/e5NPDkUSJmvL/mDkmVDijH2IJ53MA5dW/yRDJacn2zi26lLiqu+rY5x8oevdScIWq2pggkdbLsMrWFRt65EM34z22KDS+bnrtDFEyDDPXzSI0H12Va06/4Y9wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XN05j0KWYzySwh;
	Tue,  8 Oct 2024 10:17:13 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id DB309180106;
	Tue,  8 Oct 2024 10:18:27 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:27 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 02/13] scsi: hisi_sas: Create trigger_dump at the end of the debugfs initialization
Date: Tue, 8 Oct 2024 10:18:11 +0800
Message-ID: <20241008021822.2617339-3-liyihang9@huawei.com>
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

In the current debugfs initialization process, the interface trigger_dump
is created first, and then the dump directory is created to store the
register dump information.

The issue is that after the trigger_dump interface is created, users can
access the interface to trigger dump and call debugfs_create_files_v3_hw().
In debugfs_create_files_v3_hw(), if .debugfs_dump_dentry is NULL, the file
for storing dump information is created under /sys/kernel/debug, and the
memory and information cannot be released after the driver is uninstalled.

Therefore, the creation of the trigger_dump interface is placed at the end
of debugfs initialization.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 63a7255d2994..980f28d7b87f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4755,11 +4755,6 @@ static void debugfs_init_v3_hw(struct hisi_hba *hisi_hba)
 
 	hisi_hba->debugfs_dir = debugfs_create_dir(dev_name(dev),
 						   hisi_sas_debugfs_dir);
-	debugfs_create_file("trigger_dump", 0200,
-			    hisi_hba->debugfs_dir,
-			    hisi_hba,
-			    &debugfs_trigger_dump_v3_hw_fops);
-
 	/* create bist structures */
 	debugfs_bist_init_v3_hw(hisi_hba);
 
@@ -4768,6 +4763,10 @@ static void debugfs_init_v3_hw(struct hisi_hba *hisi_hba)
 
 	debugfs_phy_down_cnt_init_v3_hw(hisi_hba);
 	debugfs_fifo_init_v3_hw(hisi_hba);
+	debugfs_create_file("trigger_dump", 0200,
+			    hisi_hba->debugfs_dir,
+			    hisi_hba,
+			    &debugfs_trigger_dump_v3_hw_fops);
 }
 
 static int
-- 
2.33.0


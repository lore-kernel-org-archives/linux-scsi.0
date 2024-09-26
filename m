Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605D21741C9
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=d4qDpoxK+RKrIOe5qid6IpXMl+36M1PIXRU2qySuq9i8sW4fqv66sBz+SiKIiuqJs08YP27oeBq6JlS1PJ2nPlQabMf3nujx5pTLwyCnwIa8xN8kwXMXPRiw3uobBU+K9biyhEwR0HWvRRSyO9btsn/kwsfl3Ek05zPVpsRXylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=q2AKoGhnIiBcdT7XxtJcWugGDNOtlbDnK/simK7d+ho=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1IJfN3TIhCiTmbV12gSvjG/seBfLRUKocSIIry26LaCA63NYJqEAUBwKrCXodOP3RSWiqUmt1busTqycGbOrMhI1BL6Ce6/1uYBV6RlyZRLP4ZrhPDXL99OibGDAN/YmcrVTgoWX0VTv70r1AmofDSu2dL6f/J6osHx9k3xLJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XDbvT4vYFz1SBnl;
	Thu, 26 Sep 2024 09:42:45 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C6721400D5;
	Thu, 26 Sep 2024 09:43:34 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:34 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 09/13] scsi: hisi_sas: Update disk locked timeout to 7 seconds
Date: Thu, 26 Sep 2024 09:43:28 +0800
Message-ID: <20240926014332.3905399-10-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

From: Xingui Yang <yangxingui@huawei.com>

The sata disk will be locked after the disk sends the DMA Setup frame until
all data frame transmission is completed. The CFG_ICT_TIMER_STEP_TRSH
register is used for sata disk to configure the step size of the timer
which records the time when the disk is locked. The unit is 1us and the
default step size is 150ms. If the disk is locked for more than 7 timer
steps, the io to be sent to the disk will end abnormally.

The current timeout is only about 1 second, it is easy to trigger IO
abnormal end when the SATA hard disk returns data slowly. Adjust the
timeout to 7 seconds based on ERC time of most disks.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 310c782b4926..5c97c4463032 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -43,6 +43,7 @@
 #define CQ_INT_CONVERGE_EN		0xb0
 #define CFG_AGING_TIME			0xbc
 #define HGC_DFX_CFG2			0xc0
+#define CFG_ICT_TIMER_STEP_TRSH		0xc8
 #define CFG_ABT_SET_QUERY_IPTT	0xd4
 #define CFG_SET_ABORTED_IPTT_OFF	0
 #define CFG_SET_ABORTED_IPTT_MSK	(0xfff << CFG_SET_ABORTED_IPTT_OFF)
@@ -638,6 +639,7 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_sas_write32(hisi_hba, TRANS_LOCK_ICT_TIME, 0x4A817C80);
 	hisi_sas_write32(hisi_hba, HGC_SAS_TXFAIL_RETRY_CTRL, 0x108);
 	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, 0x1);
+	hisi_sas_write32(hisi_hba, CFG_ICT_TIMER_STEP_TRSH, 0xf4240);
 	hisi_sas_write32(hisi_hba, INT_COAL_EN, 0x3);
 	/* configure the interrupt coalescing timeout period 10us */
 	hisi_sas_write32(hisi_hba, OQ_INT_COAL_TIME, 0xa);
-- 
2.33.0


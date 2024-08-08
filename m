Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B5C65C;
	Thu,  8 Aug 2024 03:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723088786; cv=none; b=DW+QHLvZZEE4sB6XE3uXLr1fPR82zPqvgz8pssOPcKmGsFHQUcXHG+GCRf4BHsfVNnZGqtrLHRhnXoD2TSjMtallrrYgVr9TJvx1GDDez0gkBPi44jncjlYz+Skl6wGqa/CAzT6yYb7W1p+ywc9kVhNqIZrF69nHnjtVe6mq2dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723088786; c=relaxed/simple;
	bh=m4ukHZmmcsm2qm41Fw89zpcQXKD5d3wYIwKnMK/ZjoM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dvzkMV7tEEjGGqFu2E43aEkT0zPKFb9XUti+xuNN6anfyw+fBn8cwWeSXlL4QvfGlyftxzwuiH+1HkjAxNuh/atbBNADG6IhIFAadfd5wlhRocUKQQi/JxIPigGxTTbrPBW6rG1dYeKI7yFzTbTRHPe/FXYXJQAVjDdKUqoVpOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WfXyG5jp6z1T6lX;
	Thu,  8 Aug 2024 11:45:58 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 426AF180AE3;
	Thu,  8 Aug 2024 11:46:20 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Aug 2024 11:46:20 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<prime.zeng@huawei.com>, <liyihang9@huawei.com>, <linuxarm@huawei.com>
Subject: [PATCH] scsi: sd: Have scsi-ml retry START_STOP errors
Date: Thu, 8 Aug 2024 11:46:19 +0800
Message-ID: <20240808034619.768289-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
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

When sending START_STOP commands to resume scsi_device, it may be
interrupted by exception operations such as host reset or PCI FLR. Once
the command of START_STOP is failed, the runtime_status of scsi device
will be error and it is difficult for user to recover it.

So try more retries to increase robustness as the process of command
START_STOP.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/sd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5cd88a8eea73..29f30407d713 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4088,9 +4088,20 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 {
 	unsigned char cmd[6] = { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] = {
+		{
+			.allowed = 3,
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
 		.req_flags = BLK_MQ_REQ_PM,
+		.failures = &failures,
 	};
 	struct scsi_device *sdp = sdkp->device;
 	int res;
-- 
2.33.0


Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1BEBE5D;
	Thu,  8 Aug 2024 02:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723083454; cv=none; b=CHB+Utp0Y7N183lLt7gPUYPrANQUGV4kgij6B2dG4DRYEBdtP7d5B+0yWZd3ibEx4z9GgLkE1FOfOHwtM1oF+h5XUxuE8cw41oJe+1sxG7r3q7o9akP475g5QsmNzWwhkGxeyEtp75dOJZzOBBqx7ouIMIRI2P8FhokIyElqtNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723083454; c=relaxed/simple;
	bh=JsZxuDfeWogIrkpZ/4c+H9JTXiU+Z2DiRK7CT5Wo7A0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UB312Hzsqq/AIWjc1sGLjE47MGe9jTaKppesANlEm8YmBIe1Etbl0W/A8qZzAheWUyVtAQoqUrMyqQz6UOaKi58SWssPGCSDqwC4lRZZJCHcJft19I2X9yRe23+ptLFtAsDUzyVGuiZl+KtSBYEEPx7C6vaEgi2SAPt4SYAY7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WfVzb5Pwfz1T6q5;
	Thu,  8 Aug 2024 10:16:59 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 230CF14041A;
	Thu,  8 Aug 2024 10:17:21 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 8 Aug 2024 10:17:20 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<prime.zeng@huawei.com>, <liyihang9@huawei.com>, <linuxarm@huawei.com>
Subject: [PATCH] scsi: sd: retry command SYNC CACHE if format in progress
Date: Thu, 8 Aug 2024 10:17:19 +0800
Message-ID: <20240808021719.4167352-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100013.china.huawei.com (7.185.36.179)

If formatting a suspended disk (such as formatting with different DIF
type), the SYNC CACHE command will fail because the disk is in the
formatting process, which will cause the runtime_status of the disk to
error and it is difficult for user to recover it.

To solve the issue, retry the command until format command is finished.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
---
 drivers/scsi/sd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adeaa8ab9951..5cd88a8eea73 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1823,6 +1823,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
+			/* retry if format in progress */
+			if (sshdr.asc == 0x4 && sshdr.ascq == 0x4)
+				return -EBUSY;
+
 			/*
 			 * This drive doesn't support sync and there's not much
 			 * we can do because this is called during shutdown
-- 
2.33.0


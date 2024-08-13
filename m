Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA16AB641;
	Tue, 13 Aug 2024 01:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723511873; cv=none; b=I1dONFtdUx33JdOUP4lVAblNg8VN/VuTyv29n47uyGE8vziW0ZqoHkI0h5zC4GQxenng56jQtuexPHubyaDmiErN9pQT8CBmK9VuOHJv27dNzOZ3SMeaqIWS2EZTr4BBQHwlnUI16Jrm4DfFNcpylZPzIbaiTog8/7zb3Go5VAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723511873; c=relaxed/simple;
	bh=+Bl/QFyvHPkQk4wR6IGsctn9HArd4F291XCIrwwb21E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=m7rrWwW5NQmsmuTyRQwN52gOd0ySiFUPqvlWOu4mxKip3laIASxzGweKRAD3Lebgy7rfmlGCdNLhgfT3JWCU0Zl2zxMlC1TvSN4qwIklYBq72jNe1tv/BByzhyNuEzDJGkZ0F70HenVZmRkMjDbelnC+GWekSB5ZQR8rqAcUBHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WjYKl475dz20lTQ;
	Tue, 13 Aug 2024 09:13:15 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 068BF1A016C;
	Tue, 13 Aug 2024 09:17:48 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 13 Aug 2024 09:17:47 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bvanassche@acm.org>, <liyihang9@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v3] scsi: sd: retry command SYNC CACHE if format in progress
Date: Tue, 13 Aug 2024 09:17:47 +0800
Message-ID: <20240813011747.3643577-1-liyihang9@huawei.com>
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

If formatting a suspended disk (such as formatting with different DIF
type), the disk will be resuming first, and then the format command will
submit to the disk through SG_IO ioctl.

When the disk is processing the format command, the system does not submit
other commands to the disk. Therefore, the system attempts to suspend the
disk again and sends the SYNC CACHE command. However, the SYNC CACHE
command will fail because the disk is in the formatting process, which
will cause the runtime_status of the disk to error and it is difficult
for user to recover it. Error info like:

[  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
[  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
[  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
[  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4

To solve the issue, retry the command until format command is finished.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
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


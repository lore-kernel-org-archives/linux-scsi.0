Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F9D624;
	Sat, 10 Aug 2024 01:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723255160; cv=none; b=LyaRrzPQHLthgT2W2UU/POmTvO7p9ImfvaAeML5+mZfKscyBqUa2FGVEoARfv+Gedh3uaTRkZzJPgEhdL0cJ+1PquU48UsgPIwnThE38WhGtXGw/IGMoM3MPx84NrAzkZtKQyrwq7DBEjuwoHGY7GaFl7cg50aNEdhRrWcswTzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723255160; c=relaxed/simple;
	bh=e8NzsslWTIbCv+cUJVSB3myVpG22fEa+NUnCy99JIxA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WUJCxt3+bvqqPn4p699+P4tTa+YySfjOs467/TrHQa79QRoVXtoNGm2Nf7bJ6kPVmiEumYDVTTMLzhC0ibatDxo4csxwYJ1x86rsaQ0qoPfInBDWa0/BVn4d9DYafyErdL6Pms0E/4NTkMScL5ZFOA+OxV5LCR0FJEL7M+bmVnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WgkQj3llkz20lKl;
	Sat, 10 Aug 2024 09:56:13 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BF8214022D;
	Sat, 10 Aug 2024 09:59:13 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Aug 2024 09:59:12 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liyihang9@huawei.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>
Subject: [PATCH v2] scsi: sd: retry command SYNC CACHE if format in progress
Date: Sat, 10 Aug 2024 09:59:12 +0800
Message-ID: <20240810015912.856223-1-liyihang9@huawei.com>
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
---
Changes since v1:
- Updated and added error information to the patch description.

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


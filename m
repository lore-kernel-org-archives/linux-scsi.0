Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4605E148FE0;
	Mon, 19 Aug 2024 09:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724058583; cv=none; b=h8HAMLSfTt+2vkBIL8o13Yn4az4ANYzbskd1vQ3W+heO77GmhSlQftqgYVQN/avhX5Ly6RxVfSscBqmZx7ecmRMIV8oxnwDQr+FXsNztC2u+zuxiNqRdpY3yMyD5JJ1oMF5GHnbFqNLlmHWCOPI45y3YZhgvGQhOybUwAisxCaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724058583; c=relaxed/simple;
	bh=LtEilVAKm3QCrkGSgVEhT2aH+SwOWcf5TsJ6Mx1E2Ak=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KibKGR/oKeiHfk0TLsNz/LkC1x7L0Let137NLCkCpYptFaNdPEBdvGG8smCAnLyKcn8XF1mQDRUGvzpWVgxS5tHYwT2rhujPC+mOFQJaAoXumzqqkCn56uCQ5fkN0X1rmLtEAU2j7L+3UsVZcm4Mtkvuva0nZQGjrqkyh8lNUfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WnRVt0FH4z1j6ff;
	Mon, 19 Aug 2024 17:04:38 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 3458B1A016C;
	Mon, 19 Aug 2024 17:09:36 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 Aug 2024 17:09:35 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bvanassche@acm.org>, <dlemoal@kernel.org>, <liyihang9@huawei.com>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in progress
Date: Mon, 19 Aug 2024 17:09:34 +0800
Message-ID: <20240819090934.2130592-1-liyihang9@huawei.com>
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

To solve the issue, ignore the error and return success/0 when formatting
in progress.

Cc: stable@vger.kernel.org
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
Changes since v4:
- Rename the commit title.
- Ignore the SYNC command error during formatting as suggested by Damien.

Changes since v3:
- Add Cc tag for kernel stable.

Changes since v2:
- Add Reviewed-by for Bart.

Changes since v1:
- Updated and added error information to the patch description.

---
 drivers/scsi/sd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index adeaa8ab9951..2d7240a24b52 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1823,13 +1823,15 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+
 			/*
-			 * This drive doesn't support sync and there's not much
-			 * we can do because this is called during shutdown
-			 * or suspend so just return success so those operations
-			 * can proceed.
+			 * If a format is in progress or if the drive does not
+			 * support sync, there is not much we can do because
+			 * this is called during shutdown or suspend so just
+			 * return success so those operations can proceed.
 			 */
-			if (sshdr.sense_key == ILLEGAL_REQUEST)
+			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
+			    sshdr.sense_key == ILLEGAL_REQUEST)
 				return 0;
 		}
 
-- 
2.33.0


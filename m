Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB8CE7464;
	Sat, 17 Aug 2024 01:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723859426; cv=none; b=izOJJqfZWI9wGeRgPNmQre+98+V/7+3s0E/SMg4l+NqqSXu6TMA8J3iiccQA8cn9bGU2ben53ztCep8094YnNF6xs2AjsbvbuWmVSuXSS3affEEw4hbXmIzZ3xr8Hu66hgCMDPR7MhCrfkTxUQV/oXQAaVApL/Vp7e4ZGy94iHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723859426; c=relaxed/simple;
	bh=4RLfXEz98KK3x0nXEGtYwk91Bn1R7H16pzJ8e42DkfY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SvfjJT2rep2mrSHLLaibLKp9X+oQlt0NL/3BaJOLe+D3cT4b7n+M8v+oE7+sHTu8I32353Ut/boEv7VvSJlEIu7aIoLLk6kOPUPiikqkgofec51/iDloZ3tUwZfD2n0sh2wDaY4SV+g6poOAuNUPGqNqNJMJECXWFyE+fuS1gb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wm1x354SdzpSwX;
	Sat, 17 Aug 2024 09:48:55 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 739351401F2;
	Sat, 17 Aug 2024 09:50:20 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Aug 2024 09:50:20 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<bvanassche@acm.org>, <liyihang9@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v4] scsi: sd: retry command SYNC CACHE if format in progress
Date: Sat, 17 Aug 2024 09:50:19 +0800
Message-ID: <20240817015019.3467765-1-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

Cc: stable@vger.kernel.org
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
Changes since v3:
- Add Cc tag for kernel stable.

Changes since v2:
- Add Reviewed-by for Bart.

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


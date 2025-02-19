Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0438DDF42;
	Wed, 19 Feb 2025 07:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950625; cv=none; b=cUKLrZADvO8p3GY6kkpIW8kE5II+alBiZ6S7MMo2AWP8MQwiYlBLh3fv1bmmlVPLV3rdELpRviRc902FCTxJ0cXLm2LwEO0Iu/vy2WVmxiZsGf6FKiQJA82WhL10g1LQV7H3pJzLHf4w5iwHi+wlcAm1ybdESavFQUGS+6K0RUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950625; c=relaxed/simple;
	bh=Zelml0koJq2/JmuMepQyucU39402Cnj9yWoggcBMct8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=elfza7wGXPG56ImhUWembuKRV/yqlam5nQAOYjZwHzLUfXFF/7SMZtgDXSBJwujY6LPOeDXvtAw/wptqQ4TrkZ4MmrS5MCKNvhA4+7Soao9fUAH6lQUlDdseblCvq7DOgP7F0MVQvlH0t53i2lWafqbhYTqBWN8yxzSrssWrHFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=b8qPXQjA; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="b8qPXQjA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=xdkDq
	LjR5Z+dYInLH0e7CH51P78c+EQ+kVf0T1lavAM=; b=b8qPXQjAKYNztz1Sy6Eq4
	/PLDwCZB7Equy/HvYSD/E9OkK1lILtEnYlTOl2M1q6DQKRQwJ46R6TG96kXHpNlN
	EkxOl+8hnO2C2kF7gJ4tPwDFXVPAK+aF8SP345oTED0EJOm0jpvKccYQ17OPcnsN
	EV7NSbBggBf8GH5HEt2sls=
Received: from icess-ProLiant-DL380-Gen10.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnj8oDirVnUyGpMg--.50010S4;
	Wed, 19 Feb 2025 15:36:36 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: esas2r: Add check for alloc_ordered_workqueue()
Date: Wed, 19 Feb 2025 15:36:33 +0800
Message-Id: <20250219073633.2604697-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnj8oDirVnUyGpMg--.50010S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr18GF13Gw1fJr1xCFyUWrg_yoWkGwc_ur
	ZFvr12yrsrCF48K348JFyavrWvvr48Zr4F9F4Yyas3A3yfWr1Yqrs3ZrnxZwsrC34UuFWD
	Cw4YqrW8Ar17ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRGXdbUUUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbB0h34bme1hDXAswAAsJ

Add check for the return value of alloc_ordered_workqueue()
in esas2r_init_adapter() to catch potential exception.

Fixes: 4cb1b41a5ee4 ("scsi: esas2r: Simplify an alloc_ordered_workqueue() invocation")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/esas2r/esas2r_init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 0cea5f3d1a08..48bb8aaf9df4 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -314,6 +314,11 @@ int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
 	a->fw_event_q =
 		alloc_ordered_workqueue("esas2r/%d", WQ_MEM_RECLAIM, a->index);
 
+	if (!a->fw_event_q) {
+		esas2r_log(ESAS2R_LOG_CRIT, "failed to create work queue\n");
+		esas2r_kill_adapter(index);
+		return 0;
+	}
 	init_waitqueue_head(&a->buffered_ioctl_waiter);
 	init_waitqueue_head(&a->nvram_waiter);
 	init_waitqueue_head(&a->fm_api_waiter);
-- 
2.25.1


Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B281F1F3BAC;
	Thu, 23 Apr 2026 01:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776909592; cv=none; b=o43oebO5jS2xXAd/Bx/Ll6u1K+qcMO1sSf6odoeAJ1V185kE5qOUNTpTajH1QI67ddjLjbvFcN338enaCNnfjuGFfJlWonXmlhEejQvpdiJwYtPnPLJrQKRe1qX74mjVHvt7eTKkmUm8pq5evK8leyYENtuvhNJZHuekUL5rLbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776909592; c=relaxed/simple;
	bh=VFmGpUPmh9OYjTMU4n7gYZIQQkluKgk79b3UKW3Jfjc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Axrc3zPnFi7V3nanPgYgXTCBTOmq4Fk+CR9W9Pwdf17mEpkFqgxtOCa8dci0WrYD+pBneC5eWbjd12ls/ayA7rmjou7M6OPQNYUJPF1FOYiaVlwy47E2LLZahKZg1pgWIRA0oufh0j9zQ8sh3fzTWtUnA4Zu7P0gOT88/Gu54kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=JTpuCtii; arc=none smtp.client-ip=115.124.30.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="JTpuCtii"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776909582; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=azuJkXPDYaZdznMwEC+2XnQx/p8QiHrstZaCDw1IfJo=;
	b=JTpuCtiiinM026wb99ywTo4WmvfLGBhrrQfBDISIyUqY09fFUnDIY4uJj5Fqw5dS8Fyz2NjSAUQ3mQCvZhKt76voC0u1PVtJ+8fEc9wwps1ToWvBNfZGTrUzf8+dgwn+f3EXmcA1IT688Rvph8b1op6lA+jwufakTlZxQjNEr40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X1Y5Zjf_1776909577;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0X1Y5Zjf_1776909577 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 23 Apr 2026 09:59:41 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kees Cook <kees@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Xunlei Pang <xlpang@linux.alibaba.com>,
	oliver.yang@linux.alibaba.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH INNER] scsi: target: tcm_loop: Fix NULL ptr dereference
Date: Thu, 23 Apr 2026 09:59:37 +0800
Message-Id: <20260423015937.85317-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TCM_LOOP LUN creation process calls device_register() to create the
device, which in turn invokes tcm_loop_driver_probe() registered with
the TCM_LOOP bus to create and register the scsi_host.
However, if the scsi_host memory allocation fails or scsi_add_host()
fails, the device_register() process still returns success.
Subsequently, when the user binds the LUN to a specific backend device,
it accesses the NULL or freed scsi_host.

Crash Call Trace:
  RIP: 0010:scsi_is_host_device+0x7/0x20
  scsi_alloc_target+0x32/0x2c0
  __scsi_add_device+0x41/0xf0
  scsi_add_device+0xd/0x30
  tcm_loop_port_link+0x25/0x50 [tcm_loop]
  target_fabric_port_link+0x9c/0xb0 [target_core_mod]
  ...

This issue is fixed by:
  1. Setting the tcm_loop_hba's scsi_host to NULL, if
     scsi_add_host() fails.
  2. Checking the tcm_loop_hba's scsi_host after device_register().

Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
 drivers/target/loopback/tcm_loop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 528883d989b8..79ea34960199 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -393,6 +393,7 @@ static int tcm_loop_driver_probe(struct device *dev)
 	if (error) {
 		pr_err("%s: scsi_add_host failed\n", __func__);
 		scsi_host_put(sh);
+		tl_hba->sh = NULL;
 		return -ENODEV;
 	}
 	return 0;
@@ -436,6 +437,9 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 		return -ENODEV;
 	}
 
+	if (!tl_hba->sh)
+		return -ENODEV;
+
 	return 0;
 }
 
-- 
2.32.0.3.g01195cf9f


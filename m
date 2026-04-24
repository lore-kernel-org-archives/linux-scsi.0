Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E411D86FF;
	Fri, 24 Apr 2026 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776994780; cv=none; b=bt3Gi80lvKdEWNjfBAUCDYAqslCK1qjpMAGUqBg/jeWmJBruXqfD0fykt4KWZda9Tcmj3pZ0kr41o86n5vHGkMKbgR9i+Y7iFHcQYtv6Teqpv3Q7XMbIzx8NRL8lDhkQ/yrWxfB9opT8mFdFwZPQAZWwIKUbCTIQzGdsQ+V6uGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776994780; c=relaxed/simple;
	bh=lAwrru+bN8B/n84+Pam5Hg33zqrFonydCetJR/SMyQw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CjOkhxFQw8tu8P8oif8y5gIsArUP/nbuJeRziBSswra7ZHUb/q8f+l5TXRQVazNLf+9egezL+h+CiS4nl6jjBfXxom5zMszlMCmMChkgTAY84S1vJSfNTZ9hy3UDdzpGEiepfacGNEFxhu2GmBYBnXOU+Xm7sBW4d26b+PMUKTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=LcdSYZhW; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="LcdSYZhW"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776994769; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=thd4MIdW7ugGGNi7/jm6GNfBr0FaQxiWv6pQFtORQGc=;
	b=LcdSYZhWGuBUY5fDezH4InJn8wXlKy+I5KANtXLOl9PkIV9UifG/urgkfa3J8z6WdEsRrzXqtBquFwTjujF/vQ0IKUh2mFUvdJdEmH3iMJ1FJ5JOMZrxSoPYRO+l1rzNI2uz6A1j69MQvSeyLfhfsn/xMX4lfuRqHrG6var/5eY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R821e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0X1b-nbN_1776994763;
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0X1b-nbN_1776994763 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Apr 2026 09:39:28 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Kees Cook <kees@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	James Bottomley <James.Bottomley@suse.de>,
	Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	oliver.yang@linux.alibaba.com
Subject: [PATCH v2] scsi: target: tcm_loop: Fix NULL ptr dereference
Date: Fri, 24 Apr 2026 09:39:23 +0800
Message-Id: <20260424013923.25998-1-kanie@linux.alibaba.com>
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
  3. Checking the tcm_loop_hba's scsi_host in tcm_loop_driver_remove().

Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
---
v1 -> v2:
1. Unregister the device if scsi_host is NULL.
2. Check NULL in tcm_loop_driver_remove().
 drivers/target/loopback/tcm_loop.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 528883d989b8..757158094198 100644
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
@@ -406,8 +407,10 @@ static void tcm_loop_driver_remove(struct device *dev)
 	tl_hba = to_tcm_loop_hba(dev);
 	sh = tl_hba->sh;
 
-	scsi_remove_host(sh);
-	scsi_host_put(sh);
+	if (sh) {
+		scsi_remove_host(sh);
+		scsi_host_put(sh);
+	}
 }
 
 static void tcm_loop_release_adapter(struct device *dev)
@@ -436,6 +439,11 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 		return -ENODEV;
 	}
 
+	if (!tl_hba->sh) {
+		device_unregister(&tl_hba->dev);
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
-- 
2.32.0.3.g01195cf9f


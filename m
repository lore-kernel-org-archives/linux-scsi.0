Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D1F19307F;
	Fri, 14 Mar 2025 01:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914629; cv=none; b=ETFo9VnZURXxVhP0u0NIAR+MLBSmyjAFA6j4kkaqARd+VivP/2i3xIZfKYrU92pzn+fReLfB+bUg0Ea/52AS5K2PWCbsJ/DGyBn/bpfXRSRiZZQ5uVxd3AE0LfwFPCVW3+g4yhUMaGyA799O+9vnpq1qWubtTV/7lWOLw3kQ6s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914629; c=relaxed/simple;
	bh=PYuQvxkgQXGECHwGA2MVuDhfRPY04++PpqHyo5ilvPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sTfpROldjqy9CDJJAGIv3V7R/QRr5HlHVZHXuBCWnicfIOhaeJyaj3MmwgJcLwuSGJlSmewAqg1pO1zC3WiF94b2CDP+yyw32fTSnxEVTg4Lu5gPG9N3AAVK42XcBZNZceCNGDUAgN/cfyFhAhE+o8nB0NsMYbh7xR/qbTFNd5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZDR5b2gLyzvWpl;
	Fri, 14 Mar 2025 09:06:27 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id AAA82140393;
	Fri, 14 Mar 2025 09:10:18 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:18 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 13/19] scsi: scsi_debug: Add param to control target based error handle
Date: Fri, 14 Mar 2025 09:29:21 +0800
Message-ID: <20250314012927.150860-14-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250314012927.150860-1-jiangjianjun3@huawei.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500016.china.huawei.com (7.185.36.197)

From: Wenchao Hao <haowenchao2@huawei.com>

Add new module param target_eh to control if enable target based error
handler, and param target_eh_fallback to control if fallback to further
recover when target recovery can not recover all error commands.
This is used to test the target based error handle.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_debug.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 162728cca99d..5c0c2529b865 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -886,6 +886,8 @@ static bool sdebug_wp;
 static bool sdebug_allow_restart;
 static bool sdebug_lun_eh;
 static bool sdebug_lun_eh_fallback;
+static bool sdebug_target_eh;
+static bool sdebug_target_eh_fallback;
 static enum {
 	BLK_ZONED_NONE	= 0,
 	BLK_ZONED_HA	= 1,
@@ -1195,6 +1197,9 @@ static int sdebug_target_alloc(struct scsi_target *starget)
 
 	starget->hostdata = targetip;
 
+	if (sdebug_target_eh)
+		return scsi_target_setup_eh(starget, sdebug_target_eh_fallback);
+
 	return 0;
 }
 
@@ -1210,6 +1215,9 @@ static void sdebug_target_destroy(struct scsi_target *starget)
 {
 	struct sdebug_target_info *targetip;
 
+	if (sdebug_target_eh)
+		scsi_target_clear_eh(starget);
+
 	targetip = (struct sdebug_target_info *)starget->hostdata;
 	if (targetip) {
 		starget->hostdata = NULL;
@@ -6654,6 +6662,8 @@ module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
 module_param_named(allow_restart, sdebug_allow_restart, bool, S_IRUGO | S_IWUSR);
 module_param_named(lun_eh, sdebug_lun_eh, bool, S_IRUGO);
 module_param_named(lun_eh_fallback, sdebug_lun_eh_fallback, bool, S_IRUGO);
+module_param_named(target_eh, sdebug_target_eh, bool, S_IRUGO);
+module_param_named(target_eh_fallback, sdebug_target_eh_fallback, bool, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -6735,6 +6745,8 @@ MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
 MODULE_PARM_DESC(allow_restart, "Set scsi_device's allow_restart flag(def=0)");
 MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
 MODULE_PARM_DESC(lun_eh_fallback, "Fallback to further recovery if LUN recovery failed (def=0)");
+MODULE_PARM_DESC(target_eh, "target based error handle (def=0)");
+MODULE_PARM_DESC(target_eh_fallback, "Fallback to further recovery if target recovery failed (def=0)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.33.0


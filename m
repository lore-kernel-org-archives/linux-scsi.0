Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780A1A2390;
	Fri, 14 Mar 2025 01:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914633; cv=none; b=NkO5FTjbiGT+MgY53W9GEsKpDUUQaWkOPPJ7tlDWYAbUOx8lH5MBhdcjwk7l9zk101wu6fC9+O+k9vsHDsmzA29A17v4LntOND4v3bHB6Jdsa9CFJecop5ebhRoRcxdRsU/rVFHG96aYHxSZN0YxpH6k3aHhiLaKfS3ES2zY6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914633; c=relaxed/simple;
	bh=J0hYHKj4MYP/FclISPNyiqtAvRygCCjd6NqZuvwhwgw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HuCZi7dOfbvKicDtZIi2qBL+HtqnQH2rbV1/EyHMh5vOmAE0xFjOYDkUVTAw8lO1PGQn+65Iqq7da7tKFNTC3MCYl25TYdAztsBMkv3Ru/RYJCRxTBnR9dagPOC6QrurLl4vFopZpVzH7jYMtglqNMmx9YLfgmft0h6LdKH5Prc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZDRBl6pBLz27gDV;
	Fri, 14 Mar 2025 09:10:55 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id A55CA14011D;
	Fri, 14 Mar 2025 09:10:20 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:20 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 17/19] scsi: megaraid_sas: Add param to control target based error handle
Date: Fri, 14 Mar 2025 09:29:25 +0800
Message-ID: <20250314012927.150860-18-jiangjianjun3@huawei.com>
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

Add new param target_eh to control if enable target based error
handler, since megaraid_sas did not define callback eh_device_reset,
so only target based error handler is enabled; and megaraid_sas
defined eh_host_reset, so make it fallback to further recover
when target based recovery can not recover all error commands.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d85f990aec88..4ea4b754b090 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -44,6 +44,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_eh.h>
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"
 
@@ -126,6 +127,10 @@ int host_tagset_enable = 1;
 module_param(host_tagset_enable, int, 0444);
 MODULE_PARM_DESC(host_tagset_enable, "Shared host tagset enable/disable Default: enable(1)");
 
+static bool target_eh;
+module_param(target_eh, bool, 0444);
+MODULE_PARM_DESC(target_eh, "target based error handle (def=0)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
@@ -2176,6 +2181,19 @@ static void megasas_sdev_destroy(struct scsi_device *sdev)
 	sdev->hostdata = NULL;
 }
 
+static int megasas_target_alloc(struct scsi_target *starget)
+{
+	if (target_eh)
+		return scsi_target_setup_eh(starget, 1);
+	return 0;
+}
+
+static void megasas_target_destroy(struct scsi_target *starget)
+{
+	if (target_eh)
+		scsi_target_clear_eh(starget);
+}
+
 /*
 * megasas_complete_outstanding_ioctls - Complete outstanding ioctls after a
 *                                       kill adapter
@@ -3524,6 +3542,8 @@ static const struct scsi_host_template megasas_template = {
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
 	.cmd_size = sizeof(struct megasas_cmd_priv),
+	.target_alloc = megasas_target_alloc,
+	.target_destroy = megasas_target_destroy,
 };
 
 /**
-- 
2.33.0


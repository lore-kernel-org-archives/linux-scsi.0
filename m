Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829D143736;
	Fri, 14 Mar 2025 01:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914623; cv=none; b=slJt8GXe7Yba1UWe8Unp5LWKRsOXcnp+bxvBFKCjV7VSqVyZ0HfOyYc6z3RwQNbF/LxbStv9Wx65Scdq3n7T4N33+ku0g+qKcsUVUQj0GMZY9AivdXABcahJNIY5HoKP7N5tfVcA6Qdb0XX4CN2tpAN2DnngBoEXuW3CQyLjEWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914623; c=relaxed/simple;
	bh=UVuBdIHacnnNzdvXQxtCQVcu9luVYIGcFcL3UkcSp2M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6B4haIJawZUqlpAxTY3AGJorhDy970oHa3Hr7Q2l/dDHcXr4eE5aCHseMGuXSb9jIxzPWtGDQzguOmadL8O/P9chaCZssu1di4cia/YKOh5u8EwE7xSBfTZB2tCiA3ZyeuLAuoJn427+dNmVj0UiKz4Rt7D5ww36AHFsBbBcxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZDR842b8tz1R5tK;
	Fri, 14 Mar 2025 09:08:36 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B13E14011D;
	Fri, 14 Mar 2025 09:10:18 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:17 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 12/19] scsi: scsi_debug: Add param to control LUN bassed error handler
Date: Fri, 14 Mar 2025 09:29:20 +0800
Message-ID: <20250314012927.150860-13-jiangjianjun3@huawei.com>
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

Add new module param lun_eh to control if enable LUN based
error handle, and param lun_eh_fallback to control if fallback
to further recover when LUN recovery can not recover all
error commands. This is used to test the LUN based error handle.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_debug.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5ceaa4665e5d..162728cca99d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -884,6 +884,8 @@ static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 static bool sdebug_wp;
 static bool sdebug_allow_restart;
+static bool sdebug_lun_eh;
+static bool sdebug_lun_eh_fallback;
 static enum {
 	BLK_ZONED_NONE	= 0,
 	BLK_ZONED_HA	= 1,
@@ -5885,6 +5887,9 @@ static int scsi_debug_sdev_init(struct scsi_device *sdp)
 		pr_info("sdev_init <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
 
+	if (sdebug_lun_eh)
+		return scsi_device_setup_eh(sdp, sdebug_lun_eh_fallback);
+
 	return 0;
 }
 
@@ -5953,6 +5958,9 @@ static void scsi_debug_sdev_destroy(struct scsi_device *sdp)
 	/* make this slot available for re-use */
 	devip->used = false;
 	sdp->hostdata = NULL;
+
+	if (sdebug_lun_eh)
+		scsi_device_clear_eh(sdp);
 }
 
 /* Returns true if we require the queued memory to be freed by the caller. */
@@ -6644,6 +6652,8 @@ module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
 module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
 module_param_named(allow_restart, sdebug_allow_restart, bool, S_IRUGO | S_IWUSR);
+module_param_named(lun_eh, sdebug_lun_eh, bool, S_IRUGO);
+module_param_named(lun_eh_fallback, sdebug_lun_eh_fallback, bool, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -6723,6 +6733,8 @@ MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
 MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
 MODULE_PARM_DESC(allow_restart, "Set scsi_device's allow_restart flag(def=0)");
+MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
+MODULE_PARM_DESC(lun_eh_fallback, "Fallback to further recovery if LUN recovery failed (def=0)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.33.0


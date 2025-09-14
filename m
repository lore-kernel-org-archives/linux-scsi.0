Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BEC2566E2;
	Sun, 14 Sep 2025 10:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844691; cv=none; b=dYy4+dNQTBYqdnTeVuDvFKovcvLeQsldvDCd5Vvq+NiZ7M15eeyh4jJY8eJVe1dGM+NuAnWsWAw9UBHkT9Ej9AjdJ6nM9y9s+7rJp4TUGAmHgpy4Ju8ne12eelNvqVdVMYqJEWvBp4VZCk4syP5uTBo25NoMj2K9Kc1lKdQrOp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844691; c=relaxed/simple;
	bh=BTc67/T1k3an/APq68H/wXDOjvF0wFUOsuG67udJTaQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHz/buAL6+bbcbbk/fx9U2FMrL7NYeBQI7CaE/4oVUXcxIg0m3wkvWXr+4+JTBBKjuLd9M5rXUWc8mhbw7gU90KJRLHmwCUP5MQc5dV4CrYMqnmjQcIjI5mIixvnjqZzUVztw0Ume0Si2tEiLKM5rMMJUbWUHa9JI8AdDXyT/Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cPkN73LCdzdcDr;
	Sun, 14 Sep 2025 18:06:47 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id B4EFE1402DA;
	Sun, 14 Sep 2025 18:11:21 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:20 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 9/9] scsi: scsi_debug: Add params for configuring the error handler
Date: Sun, 14 Sep 2025 18:41:45 +0800
Message-ID: <20250914104145.2239901-10-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250914104145.2239901-1-jiangjianjun3@huawei.com>
References: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
 <20250914104145.2239901-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk500001.china.huawei.com (7.202.194.86)

Add a new module parameter to configure error handlers based on
LUN and toggle the enable/disable fallback functionality.

Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_debug.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..f221ad31b44d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -961,6 +961,8 @@ static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 static bool sdebug_wp;
 static bool sdebug_allow_restart;
+static bool sdebug_lun_eh;
+static bool sdebug_lun_eh_fallback;
 static enum {
 	BLK_ZONED_NONE	= 0,
 	BLK_ZONED_HA	= 1,
@@ -7385,6 +7387,8 @@ module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
 module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
 module_param_named(allow_restart, sdebug_allow_restart, bool, S_IRUGO | S_IWUSR);
+module_param_named(lun_eh, sdebug_lun_eh, bool, 0444);
+module_param_named(lun_eh_fallback, sdebug_lun_eh_fallback, bool, 0444);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -7464,6 +7468,8 @@ MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
 MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
 MODULE_PARM_DESC(allow_restart, "Set scsi_device's allow_restart flag(def=0)");
+MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
+MODULE_PARM_DESC(lun_eh_fallback, "Fallback to further recovery if LUN recovery failed (def=0)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
@@ -8450,6 +8456,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 ATTRIBUTE_GROUPS(sdebug_drv);
 
 static struct device *pseudo_primary;
+static struct scsi_host_template sdebug_driver_template;
 
 static int __init scsi_debug_init(void)
 {
@@ -8458,6 +8465,12 @@ static int __init scsi_debug_init(void)
 	int k, ret, hosts_to_add;
 	int idx = -1;
 
+	if (sdebug_lun_eh) {
+		sdebug_driver_template.sdev_setup_eh = scsi_device_setup_eh;
+		sdebug_driver_template.sdev_clear_eh = scsi_device_clear_eh;
+		sdebug_driver_template.sdev_eh_fallback = sdebug_lun_eh_fallback;
+	}
+
 	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
 		pr_warn("ndelay must be less than 1 second, ignored\n");
 		sdebug_ndelay = 0;
@@ -9435,7 +9448,7 @@ static int sdebug_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 	return 0;
 }
 
-static const struct scsi_host_template sdebug_driver_template = {
+static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
 	.proc_name =		sdebug_proc_name,
-- 
2.33.0


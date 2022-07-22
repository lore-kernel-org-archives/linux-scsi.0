Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6D4C19F29
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Aug 2022 16:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbiHCQbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Aug 2022 12:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238503AbiHCQaN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2022 12:30:13 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E13546DBF;
        Wed,  3 Aug 2022 09:30:00 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 01748412DF;
        Wed,  3 Aug 2022 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1659544197; x=1661358598; bh=sHfzJDUjyjPG265rFr5KNrfhE
        yAfHiDS/o9/OVtTYSQ=; b=ucmJx7pvsk1R2IZCwJVCyAaXwskIEse+pGPiyOUgd
        HeJ8QFaNw7yQi7C3IMSCZQJv/SFgzDYZJBz1GxmMvdQ6M4v2KSF6pGNeWWCgoqTE
        SQ57rsgC7c8uBi+gX7Hc2x5i/IIkwsf2TioRlOM2X/61UPffM34mc1aWSEqtrmf5
        Bg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oFtY2cZC2oNM; Wed,  3 Aug 2022 19:29:57 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id E873C412F7;
        Wed,  3 Aug 2022 19:29:22 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Wed, 3 Aug 2022 19:29:23 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Wed, 3 Aug 2022 19:29:22 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [RFC PATCH 37/48] target: cluster: introduce dlm cluster
Date:   Fri, 22 Jul 2022 17:59:09 +0300
Message-ID: <20220803162857.27770-38-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803162857.27770-1-d.bogdanov@yadro.com>
References: <20220803162857.27770-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce DLM Cluster implementation of cluster ops of backstore
devices.

Use one DLM lockspace per device. The device is idenitfied by
concatenation of T10 model and T10 unit_serial.

Use DLM CKV lock for Compare And Write in cluster mode. One lock for
one LBA. That allows a parallell execution of CAW commands.

User should set configfs/target/cluster/dlm/cluster_name identical to
configfs/dlm/cluster/cluster_name.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/Makefile             |   1 +
 drivers/target/target_cluster_dlm.c | 175 ++++++++++++++++++++++++++++
 2 files changed, 176 insertions(+)
 create mode 100644 drivers/target/target_cluster_dlm.c

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index be4d1bfcf79a..16b625108eec 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -33,3 +33,4 @@ obj-$(CONFIG_SBP_TARGET)	+= sbp/
 obj-$(CONFIG_REMOTE_TARGET)	+= tcm_remote/
 
 obj-$(CONFIG_DLM_CKV)			+= dlm_ckv.o
+obj-$(CONFIG_DLM_CKV)			+= target_cluster_dlm.o
diff --git a/drivers/target/target_cluster_dlm.c b/drivers/target/target_cluster_dlm.c
new file mode 100644
index 000000000000..2edae188811d
--- /dev/null
+++ b/drivers/target/target_cluster_dlm.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/dlm.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/configfs.h>
+#include <target/target_core_base.h>
+
+#include "dlm_ckv.h"
+
+struct target_cluster_data {
+	struct dlm_ckv_bucket *bucket;
+	u32 local_nodeid;
+};
+
+struct target_lksb {
+	struct dlm_lksb lksb;
+	struct completion compl;
+};
+
+struct target_cluster_config {
+	struct config_group cg_group;
+	char cluster_name[DLM_LOCKSPACE_LEN];
+};
+
+static struct target_cluster_config *to_cfg(struct config_item *i)
+{
+	return i ? container_of(to_config_group(i), struct target_cluster_config, cg_group) : NULL;
+}
+
+static ssize_t target_cluster_cluster_name_show(struct config_item *item, char *buf)
+{
+	return sprintf(buf, "%s\n", to_cfg(item)->cluster_name);
+}
+
+static ssize_t target_cluster_cluster_name_store(struct config_item *item,
+						 const char *page,
+						 size_t len)
+{
+	struct target_cluster_config *cfg = to_cfg(item);
+
+	strscpy(cfg->cluster_name, page, DLM_LOCKSPACE_LEN);
+	if (cfg->cluster_name[strlen(cfg->cluster_name) - 1] == '\n')
+		cfg->cluster_name[strlen(cfg->cluster_name) - 1] = 0;
+
+	return len;
+}
+
+CONFIGFS_ATTR(target_cluster_, cluster_name);
+
+static struct configfs_attribute *cluster_attrs[] = {
+	&target_cluster_attr_cluster_name,
+	NULL,
+};
+
+static const struct config_item_type ci_cluster_config = {
+	.ct_item_ops = NULL,
+	.ct_attrs = cluster_attrs,
+	.ct_owner = THIS_MODULE,
+};
+
+static struct target_cluster_config cluster_cfg;
+
+static int target_init_dlm(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data;
+	char ls_name[INQUIRY_MODEL_LEN + INQUIRY_VPD_SERIAL_LEN + 1];
+	int err = 0;
+
+	BUG_ON(dev->cluster_data);
+
+	snprintf(ls_name, sizeof(ls_name), "%s%s",
+			       dev->t10_wwn.model, dev->t10_wwn.unit_serial);
+
+	cluster_data = kzalloc(sizeof(*cluster_data), GFP_KERNEL);
+	if (!cluster_data)
+		return -ENOMEM;
+
+	cluster_data->bucket = dlm_ckv_open_bucket(ls_name,
+						cluster_cfg.cluster_name,
+						dev);
+	if (!cluster_data->bucket) {
+		err = -EIO;
+		kfree(cluster_data);
+		dev->cluster_data = NULL;
+		return err;
+	}
+	dev->cluster_data = cluster_data;
+
+	return err;
+}
+
+static int target_cleanup_dlm(struct se_device *dev)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	int res;
+
+	res = dlm_ckv_close_bucket(cluster_data->bucket);
+	if (res)
+		pr_err("TARGET_CORE[%d]:  closing bucket failed: %d\n",
+		       dev->dev_index, res);
+
+	kfree(dev->cluster_data);
+	dev->cluster_data = NULL;
+
+	return 0;
+}
+
+static void *target_caw_lock_dlm(struct se_device *dev, u64 lba)
+{
+	struct target_cluster_data *cluster_data = dev->cluster_data;
+	struct dlm_ckv_lock *caw_lock;
+	char name[DLM_RESNAME_MAXLEN];
+	int res = -ENOMEM;
+
+	snprintf(name, sizeof(name) - 1, "caw_lba_%llx", lba);
+
+	caw_lock = dlm_ckv_create_lock(cluster_data->bucket, name);
+	if (!caw_lock)
+		goto done;
+
+	res = dlm_ckv_lock_get(caw_lock);
+	if (res) {
+		dlm_ckv_free_lock(caw_lock);
+		caw_lock = NULL;
+		pr_warn("target_dlm_lock_wait failed with %d\n", res);
+	}
+
+done:
+	return caw_lock;
+}
+
+static int target_caw_unlock_dlm(struct se_device *dev, void *lock)
+{
+	struct dlm_ckv_lock *caw_lock = lock;
+	int res;
+
+	res = dlm_ckv_lock_release(caw_lock);
+
+	dlm_ckv_free_lock(caw_lock);
+
+	return res;
+}
+
+struct target_cluster_ops dlm_cluster_ops = {
+	.name = "dlm",
+	.owner = THIS_MODULE,
+	.cg_group = &cluster_cfg.cg_group,
+
+	.init = target_init_dlm,
+	.cleanup = target_cleanup_dlm,
+	.caw_lock = target_caw_lock_dlm,
+	.caw_unlock = target_caw_unlock_dlm,
+};
+
+static int __init target_cluster_dlm_module_init(void)
+{
+	config_group_init_type_name(&cluster_cfg.cg_group,
+				    dlm_cluster_ops.name,
+				    &ci_cluster_config);
+
+	return target_cluster_impl_register(&dlm_cluster_ops);
+}
+
+static void __exit target_cluster_dlm_module_exit(void)
+{
+	target_cluster_impl_unregister(&dlm_cluster_ops);
+}
+
+MODULE_DESCRIPTION("TCM Cluster implementation over DLM");
+MODULE_AUTHOR("Dmitry Bogdanov <d.bogdanov@yadro.com>");
+MODULE_LICENSE("GPL");
+
+module_init(target_cluster_dlm_module_init);
+module_exit(target_cluster_dlm_module_exit);
-- 
2.25.1


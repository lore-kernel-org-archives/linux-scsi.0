From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 1/4] tcmu: Support emulate_write_cache
Date: Fri, 26 May 2017 09:27:20 -0500
Message-ID: <1495808843-40222-2-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35391 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755466AbdEZO1q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 May 2017 10:27:46 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4QEODuF133360
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 10:27:45 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2apjnfj1w7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2017 10:27:45 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Fri, 26 May 2017 10:27:44 -0400
In-Reply-To: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This will enable the toggling of write_cache in tcmu through targetcli-fb

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Reviewed-By: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index beb5f09..0c797cc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1290,6 +1290,8 @@ static int tcmu_configure_device(struct se_device *dev)
 	/* Other attributes can be configured in userspace */
 	if (!dev->dev_attrib.hw_max_sectors)
 		dev->dev_attrib.hw_max_sectors = 128;
+	if (!dev->dev_attrib.emulate_write_cache)
+		dev->dev_attrib.emulate_write_cache = 0;
 	dev->dev_attrib.hw_queue_depth = 128;
 
 	/*
@@ -1546,6 +1548,32 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 }
 CONFIGFS_ATTR(tcmu_, cmd_time_out);
 
+static ssize_t tcmu_emulate_write_cache_show(struct config_item *item,
+					     char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+
+	return snprintf(page, PAGE_SIZE, "%i\n", da->emulate_write_cache);
+}
+
+static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
+					      const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	int val;
+	int ret;
+
+	ret = kstrtouint(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	da->emulate_write_cache = val;
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, emulate_write_cache);
+
 static struct configfs_attribute **tcmu_attrs;
 
 static struct target_backend_ops tcmu_ops = {
@@ -1682,6 +1710,8 @@ static int __init tcmu_module_init(void)
 		tcmu_attrs[i] = passthrough_attrib_attrs[i];
 	}
 	tcmu_attrs[i] = &tcmu_attr_cmd_time_out;
+	i++;
+	tcmu_attrs[i] = &tcmu_attr_emulate_write_cache;
 	tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
 
 	ret = transport_backend_register(&tcmu_ops);
-- 
2.5.4 (Apple Git-61)

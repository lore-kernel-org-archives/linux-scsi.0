From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 01/19] qla2xxx: Remove sysfs node fw_dump_template.
Date: Wed, 6 Jul 2016 11:14:17 -0400
Message-ID: <1467818075-15246-2-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:14823 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbcGFP7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:20 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 89 -----------------------------------------
 drivers/scsi/qla2xxx/qla_dbg.c  |  1 +
 2 files changed, 1 insertion(+), 89 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 4dc06a13..c9bcd82 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -147,92 +147,6 @@ static struct bin_attribute sysfs_fw_dump_attr = {
 };
 
 static ssize_t
-qla2x00_sysfs_read_fw_dump_template(struct file *filp, struct kobject *kobj,
-			   struct bin_attribute *bin_attr,
-			   char *buf, loff_t off, size_t count)
-{
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!ha->fw_dump_template || !ha->fw_dump_template_len)
-		return 0;
-
-	ql_dbg(ql_dbg_user, vha, 0x70e2,
-	    "chunk <- off=%llx count=%zx\n", off, count);
-	return memory_read_from_buffer(buf, count, &off,
-	    ha->fw_dump_template, ha->fw_dump_template_len);
-}
-
-static ssize_t
-qla2x00_sysfs_write_fw_dump_template(struct file *filp, struct kobject *kobj,
-			    struct bin_attribute *bin_attr,
-			    char *buf, loff_t off, size_t count)
-{
-	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
-	    struct device, kobj)));
-	struct qla_hw_data *ha = vha->hw;
-	uint32_t size;
-
-	if (off == 0) {
-		if (ha->fw_dump)
-			vfree(ha->fw_dump);
-		if (ha->fw_dump_template)
-			vfree(ha->fw_dump_template);
-
-		ha->fw_dump = NULL;
-		ha->fw_dump_len = 0;
-		ha->fw_dump_template = NULL;
-		ha->fw_dump_template_len = 0;
-
-		size = qla27xx_fwdt_template_size(buf);
-		ql_dbg(ql_dbg_user, vha, 0x70d1,
-		    "-> allocating fwdt (%x bytes)...\n", size);
-		ha->fw_dump_template = vmalloc(size);
-		if (!ha->fw_dump_template) {
-			ql_log(ql_log_warn, vha, 0x70d2,
-			    "Failed allocate fwdt (%x bytes).\n", size);
-			return -ENOMEM;
-		}
-		ha->fw_dump_template_len = size;
-	}
-
-	if (off + count > ha->fw_dump_template_len) {
-		count = ha->fw_dump_template_len - off;
-		ql_dbg(ql_dbg_user, vha, 0x70d3,
-		    "chunk -> truncating to %zx bytes.\n", count);
-	}
-
-	ql_dbg(ql_dbg_user, vha, 0x70d4,
-	    "chunk -> off=%llx count=%zx\n", off, count);
-	memcpy(ha->fw_dump_template + off, buf, count);
-
-	if (off + count == ha->fw_dump_template_len) {
-		size = qla27xx_fwdt_calculate_dump_size(vha);
-		ql_dbg(ql_dbg_user, vha, 0x70d5,
-		    "-> allocating fwdump (%x bytes)...\n", size);
-		ha->fw_dump = vmalloc(size);
-		if (!ha->fw_dump) {
-			ql_log(ql_log_warn, vha, 0x70d6,
-			    "Failed allocate fwdump (%x bytes).\n", size);
-			return -ENOMEM;
-		}
-		ha->fw_dump_len = size;
-	}
-
-	return count;
-}
-static struct bin_attribute sysfs_fw_dump_template_attr = {
-	.attr = {
-		.name = "fw_dump_template",
-		.mode = S_IRUSR | S_IWUSR,
-	},
-	.size = 0,
-	.read = qla2x00_sysfs_read_fw_dump_template,
-	.write = qla2x00_sysfs_write_fw_dump_template,
-};
-
-static ssize_t
 qla2x00_sysfs_read_nvram(struct file *filp, struct kobject *kobj,
 			 struct bin_attribute *bin_attr,
 			 char *buf, loff_t off, size_t count)
@@ -973,7 +887,6 @@ static struct sysfs_entry {
 	int is4GBp_only;
 } bin_file_entries[] = {
 	{ "fw_dump", &sysfs_fw_dump_attr, },
-	{ "fw_dump_template", &sysfs_fw_dump_template_attr, 0x27 },
 	{ "nvram", &sysfs_nvram_attr, },
 	{ "optrom", &sysfs_optrom_attr, },
 	{ "optrom_ctl", &sysfs_optrom_ctl_attr, },
@@ -1000,8 +913,6 @@ qla2x00_alloc_sysfs_attr(scsi_qla_host_t *vha)
 			continue;
 		if (iter->is4GBp_only == 3 && !(IS_CNA_CAPABLE(vha->hw)))
 			continue;
-		if (iter->is4GBp_only == 0x27 && !IS_QLA27XX(vha->hw))
-			continue;
 
 		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
 		    iter->attr);
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index b64c504..b985fcb 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -39,6 +39,7 @@
  * |                              |                    | 0x70a5-0x70a6  |
  * |                              |                    | 0x70a8,0x70ab  |
  * |                              |                    | 0x70ad-0x70ae  |
+ * |                              |                    | 0x70d0-0x70d6	|
  * |                              |                    | 0x70d7-0x70db  |
  * |                              |                    | 0x70de-0x70df  |
  * | Task Management              |       0x803d       | 0x8000,0x800b  |
-- 
2.7.2


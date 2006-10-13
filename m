From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/4] qla2xxx: Check return value of sysfs_create_bin_file() usage.
Date: Fri, 13 Oct 2006 09:33:37 -0700
Message-ID: <11607572202930-git-send-email-andrew.vasquez@qlogic.com>
References: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:64991 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751721AbWJMQdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:33:41 -0400
In-Reply-To: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   51 ++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ee75a71..285c8e8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -379,21 +379,37 @@ static struct bin_attribute sysfs_sfp_at
 	.read = qla2x00_sysfs_read_sfp,
 };
 
+static struct sysfs_entry {
+	char *name;
+	struct bin_attribute *attr;
+	int is4GBp_only;
+} bin_file_entries[] = {
+	{ "fw_dump", &sysfs_fw_dump_attr, },
+	{ "nvram", &sysfs_nvram_attr, },
+	{ "optrom", &sysfs_optrom_attr, },
+	{ "optrom_ctl", &sysfs_optrom_ctl_attr, },
+	{ "vpd", &sysfs_vpd_attr, 1 },
+	{ "sfp", &sysfs_sfp_attr, 1 },
+	{ 0 },
+};
+
 void
 qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
 {
 	struct Scsi_Host *host = ha->host;
+	struct sysfs_entry *iter;
+	int ret;
 
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj,
-	    &sysfs_optrom_ctl_attr);
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
-		sysfs_create_bin_file(&host->shost_gendev.kobj,
-		    &sysfs_vpd_attr);
-		sysfs_create_bin_file(&host->shost_gendev.kobj,
-		    &sysfs_sfp_attr);
+	for (iter = bin_file_entries; iter->name; iter++) {
+		if (iter->is4GBp_only && (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)))
+			continue;
+
+		ret = sysfs_create_bin_file(&host->shost_gendev.kobj,
+		    iter->attr);
+		if (ret)
+			qla_printk(KERN_INFO, ha,
+			    "Unable to create sysfs %s binary attribute "
+			    "(%d).\n", iter->name, ret);
 	}
 }
 
@@ -401,17 +417,14 @@ void
 qla2x00_free_sysfs_attr(scsi_qla_host_t *ha)
 {
 	struct Scsi_Host *host = ha->host;
+	struct sysfs_entry *iter;
+
+	for (iter = bin_file_entries; iter->name; iter++) {
+		if (iter->is4GBp_only && (!IS_QLA24XX(ha) && !IS_QLA54XX(ha)))
+			continue;
 
-	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
-	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
-	sysfs_remove_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
-	sysfs_remove_bin_file(&host->shost_gendev.kobj,
-	    &sysfs_optrom_ctl_attr);
-	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
-		sysfs_remove_bin_file(&host->shost_gendev.kobj,
-		    &sysfs_vpd_attr);
 		sysfs_remove_bin_file(&host->shost_gendev.kobj,
-		    &sysfs_sfp_attr);
+		    iter->attr);
 	}
 
 	if (ha->beacon_blink_led == 1)
-- 
1.4.3.rc2.g23bed


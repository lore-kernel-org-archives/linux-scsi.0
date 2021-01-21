Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0F2C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 384C8206ED
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbhAUG0r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 01:26:47 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:54301 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727108AbhAUG0n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 01:26:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UMOvXFQ_1611210339;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMOvXFQ_1611210339)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 21 Jan 2021 14:25:44 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     njavali@marvell.com
Cc:     mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH v3] scsi/qla4xxx: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Thu, 21 Jan 2021 14:25:37 +0800
Message-Id: <1611210337-92686-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/qla4xxx/ql4_attr.c: WARNING: use scnprintf or
sprintf

Reported-by: Abaci Robot<abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
Changes in v3:
  - convert sysfs_emit_at to sysfs_emit.

 drivers/scsi/qla4xxx/ql4_attr.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_attr.c b/drivers/scsi/qla4xxx/ql4_attr.c
index ec43528..dc94622 100644
--- a/drivers/scsi/qla4xxx/ql4_attr.c
+++ b/drivers/scsi/qla4xxx/ql4_attr.c
@@ -156,11 +156,11 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 
 	if (is_qla80XX(ha))
-		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d (%x)\n",
+		return sysfs_emit(buf, "%d.%02d.%02d (%x)\n",
 				ha->fw_info.fw_major, ha->fw_info.fw_minor,
 				ha->fw_info.fw_patch, ha->fw_info.fw_build);
 	else
-		return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
+		return sysfs_emit(buf, "%d.%02d.%02d.%02d\n",
 				ha->fw_info.fw_major, ha->fw_info.fw_minor,
 				ha->fw_info.fw_patch, ha->fw_info.fw_build);
 }
@@ -170,7 +170,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 			char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->serial_number);
+	return sysfs_emit(buf, "%s\n", ha->serial_number);
 }
 
 static ssize_t
@@ -178,7 +178,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 			   char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%d.%02d\n", ha->fw_info.iscsi_major,
+	return sysfs_emit(buf, "%d.%02d\n", ha->fw_info.iscsi_major,
 			ha->fw_info.iscsi_minor);
 }
 
@@ -187,7 +187,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 			    char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%d.%02d.%02d.%02d\n",
+	return sysfs_emit(buf, "%d.%02d.%02d.%02d\n",
 			ha->fw_info.bootload_major, ha->fw_info.bootload_minor,
 			ha->fw_info.bootload_patch, ha->fw_info.bootload_build);
 }
@@ -197,7 +197,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 		      char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "0x%08X\n", ha->board_id);
+	return sysfs_emit(buf, "0x%08X\n", ha->board_id);
 }
 
 static ssize_t
@@ -207,7 +207,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 
 	qla4xxx_get_firmware_state(ha);
-	return snprintf(buf, PAGE_SIZE, "0x%08X%8X\n", ha->firmware_state,
+	return sysfs_emit(buf, "0x%08X%8X\n", ha->firmware_state,
 			ha->addl_fw_state);
 }
 
@@ -220,7 +220,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 	if (is_qla40XX(ha))
 		return -ENOSYS;
 
-	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->phy_port_cnt);
+	return sysfs_emit(buf, "0x%04X\n", ha->phy_port_cnt);
 }
 
 static ssize_t
@@ -232,7 +232,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 	if (is_qla40XX(ha))
 		return -ENOSYS;
 
-	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->phy_port_num);
+	return sysfs_emit(buf, "0x%04X\n", ha->phy_port_num);
 }
 
 static ssize_t
@@ -244,7 +244,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 	if (is_qla40XX(ha))
 		return -ENOSYS;
 
-	return snprintf(buf, PAGE_SIZE, "0x%04X\n", ha->iscsi_pci_func_cnt);
+	return sysfs_emit(buf, "0x%04X\n", ha->iscsi_pci_func_cnt);
 }
 
 static ssize_t
@@ -253,7 +253,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->model_name);
+	return sysfs_emit(buf, "%s\n", ha->model_name);
 }
 
 static ssize_t
@@ -261,7 +261,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 			  char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s %s\n", ha->fw_info.fw_build_date,
+	return sysfs_emit(buf, "%s %s\n", ha->fw_info.fw_build_date,
 			ha->fw_info.fw_build_time);
 }
 
@@ -270,7 +270,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 			   char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->fw_info.fw_build_user);
+	return sysfs_emit(buf, "%s\n", ha->fw_info.fw_build_user);
 }
 
 static ssize_t
@@ -278,7 +278,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 			      char *buf)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
-	return snprintf(buf, PAGE_SIZE, "%s\n", ha->fw_info.extended_timestamp);
+	return sysfs_emit(buf, "%s\n", ha->fw_info.extended_timestamp);
 }
 
 static ssize_t
@@ -300,7 +300,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 		break;
 	}
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", load_src);
+	return sysfs_emit(buf, "%s\n", load_src);
 }
 
 static ssize_t
@@ -309,7 +309,7 @@ void qla4_8xxx_free_sysfs_attr(struct scsi_qla_host *ha)
 {
 	struct scsi_qla_host *ha = to_qla_host(class_to_shost(dev));
 	qla4xxx_about_firmware(ha);
-	return snprintf(buf, PAGE_SIZE, "%u.%u secs\n", ha->fw_uptime_secs,
+	return sysfs_emit(buf, "%u.%u secs\n", ha->fw_uptime_secs,
 			ha->fw_uptime_msecs);
 }
 
-- 
1.8.3.1


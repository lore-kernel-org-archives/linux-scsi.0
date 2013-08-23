From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 2/4] qla4xxx: Fix the minidump data collection check in for loop
Date: Fri, 23 Aug 2013 03:40:19 -0400
Message-ID: <1377243621-32107-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:45309 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755005Ab3HWIJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 04:09:30 -0400
In-Reply-To: <1377243621-32107-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Santosh Vernekar <santosh.vernekar@qlogic.com>

From: Santosh Vernekar <santosh.vernekar@qlogic.com>

Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index c41362c..53c759f 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2628,7 +2628,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 
 	/* Walk through the entry headers - validate/perform required action */
 	for (i = 0; i < num_entry_hdr; i++) {
-		if (data_collected >= ha->fw_dump_size) {
+		if (data_collected > ha->fw_dump_size) {
 			ql4_printk(KERN_INFO, ha,
 				   "Data collected: [0x%x], Total Dump size: [0x%x]\n",
 				   data_collected, ha->fw_dump_size);
@@ -2753,9 +2753,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 			break;
 		}
 
-		data_collected = (uint8_t *)data_ptr -
-				 ((uint8_t *)((uint8_t *)ha->fw_dump +
-						ha->fw_dump_tmplt_size));
+		data_collected = (uint8_t *)data_ptr - (uint8_t *)ha->fw_dump;
 skip_nxt_entry:
 		/*  next entry in the template */
 		entry_hdr = (struct qla8xxx_minidump_entry_hdr *)
@@ -2763,7 +2761,7 @@ skip_nxt_entry:
 				 entry_hdr->entry_size);
 	}
 
-	if ((data_collected + ha->fw_dump_tmplt_size) != ha->fw_dump_size) {
+	if (data_collected != ha->fw_dump_size) {
 		ql4_printk(KERN_INFO, ha,
 			   "Dump data mismatch: Data collected: [0x%x], total_data_size:[0x%x]\n",
 			   data_collected, ha->fw_dump_size);
-- 
1.8.2.GIT


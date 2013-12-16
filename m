From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 14/24] qla4xxx: Driver not able to collect minidump for ISP84xx
Date: Mon, 16 Dec 2013 06:49:44 -0500
Message-ID: <1387194594-29817-15-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:62673 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab3LPMXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:38 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Issue:
minidump data collection fails as driver reports data mismatch

Fix:
When the driver encounters a new entry type that it cannot process,
it should just skip the entry and adjust the total buffer size by
subtracting the skipped bytes from it. This is to ensure that there
is no data mismatch because of the new entries.

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h | 1 +
 drivers/scsi/qla4xxx/ql4_nx.c  | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index c2deaa0..73a5022 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -769,6 +769,7 @@ struct scsi_qla_host {
 	uint32_t fw_dump_capture_mask;
 	void *fw_dump_tmplt_hdr;
 	uint32_t fw_dump_tmplt_size;
+	uint32_t fw_dump_skip_size;
 
 	struct completion mbx_intr_comp;
 
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index bcf3e43..d2040b4 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2383,6 +2383,11 @@ static void qla4_8xxx_mark_entry_skipped(struct scsi_qla_host *ha,
 			  "scsi(%ld): Skipping entry[%d]: ETYPE[0x%x]-ELEVEL[0x%x]\n",
 			  ha->host_no, index, entry_hdr->entry_type,
 			  entry_hdr->d_ctrl.entry_capture_mask));
+	/* If driver encounters a new entry type that it cannot process,
+	 * it should just skip the entry and adjust the total buffer size by
+	 * from subtracting the skipped bytes from it
+	 */
+	ha->fw_dump_skip_size += entry_hdr->entry_capture_size;
 }
 
 /* ISP83xx functions to process new minidump entries... */
@@ -2590,6 +2595,7 @@ static int qla4_8xxx_collect_md_data(struct scsi_qla_host *ha)
 	uint64_t now;
 	uint32_t timestamp;
 
+	ha->fw_dump_skip_size = 0;
 	if (!ha->fw_dump) {
 		ql4_printk(KERN_INFO, ha, "%s(%ld) No buffer to dump\n",
 			   __func__, ha->host_no);
@@ -2761,7 +2767,7 @@ skip_nxt_entry:
 				 entry_hdr->entry_size);
 	}
 
-	if (data_collected != ha->fw_dump_size) {
+	if ((data_collected + ha->fw_dump_skip_size) != ha->fw_dump_size) {
 		ql4_printk(KERN_INFO, ha,
 			   "Dump data mismatch: Data collected: [0x%x], total_data_size:[0x%x]\n",
 			   data_collected, ha->fw_dump_size);
-- 
1.8.2.GIT


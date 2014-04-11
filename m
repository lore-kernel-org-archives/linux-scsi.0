From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 09/42] qla2xxx: Allow the next firmware dump if the previous dump capture fails for ISP8044.
Date: Fri, 11 Apr 2014 16:54:14 -0400
Message-ID: <1397249687-32666-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:19218 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbaDKVb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:31:58 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malvali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_nx.c  |   12 ++++++------
 drivers/scsi/qla2xxx/qla_nx2.c |    3 +++
 drivers/scsi/qla2xxx/qla_os.c  |    1 +
 4 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 89bece7..bab1cf1 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3141,6 +3141,7 @@ struct qla_hw_data {
 	uint32_t	fw_dump_len;
 	int		fw_dumped;
 	int		fw_dump_reading;
+	int		prev_minidump_failed;
 	dma_addr_t	eft_dma;
 	void		*eft;
 /* Current size of mctp dump is 0x086064 bytes */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 81388e9..3c5819a 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3142,18 +3142,18 @@ qla82xx_check_md_needed(scsi_qla_host_t *vha)
 
 	if (ql2xmdenable) {
 		if (!ha->fw_dumped) {
-			if (fw_major_version != ha->fw_major_version ||
+			if ((fw_major_version != ha->fw_major_version ||
 			    fw_minor_version != ha->fw_minor_version ||
-			    fw_subminor_version != ha->fw_subminor_version) {
+			    fw_subminor_version != ha->fw_subminor_version) ||
+			    (ha->prev_minidump_failed)) {
 				ql_dbg(ql_dbg_p3p, vha, 0xb02d,
-				    "Firmware version differs "
-				    "Previous version: %d:%d:%d - "
-				    "New version: %d:%d:%d\n",
+				    "Firmware version differs Previous version: %d:%d:%d - New version: %d:%d:%d, prev_minidump_failed: %d.\n",
 				    fw_major_version, fw_minor_version,
 				    fw_subminor_version,
 				    ha->fw_major_version,
 				    ha->fw_minor_version,
-				    ha->fw_subminor_version);
+				    ha->fw_subminor_version,
+				    ha->prev_minidump_failed);
 				/* Release MiniDump resources */
 				qla82xx_md_free(vha);
 				/* ALlocate MiniDump resources */
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index e381835..d36a623 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -3125,6 +3125,7 @@ skip_nxt_entry:
 		    "Dump data mismatch: Data collected: "
 		    "[0x%x], total_data_size:[0x%x]\n",
 		    data_collected, ha->md_dump_size);
+		rval = QLA_FUNCTION_FAILED;
 		goto md_failed;
 	}
 
@@ -3149,10 +3150,12 @@ qla8044_get_minidump(struct scsi_qla_host *vha)
 
 	if (!qla8044_collect_md_data(vha)) {
 		ha->fw_dumped = 1;
+		ha->prev_minidump_failed = 0;
 	} else {
 		ql_log(ql_log_fatal, vha, 0xb0db,
 		    "%s: Unable to collect minidump\n",
 		    __func__);
+		ha->prev_minidump_failed = 1;
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1b1cd75..0114ea4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2885,6 +2885,7 @@ skip_dpc:
 
 	base_vha->flags.init_done = 1;
 	base_vha->flags.online = 1;
+	ha->prev_minidump_failed = 0;
 
 	ql_dbg(ql_dbg_init, base_vha, 0x00f2,
 	    "Init done and hba is online.\n");
-- 
1.7.7


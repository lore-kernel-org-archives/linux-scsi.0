From: vikas.chaudhary@qlogic.com
Subject: [PATCH 1/4] qla4xxx: Added missing check for ISP83XX in CHAP related functions
Date: Fri, 22 Mar 2013 07:08:31 -0400
Message-ID: <1363950514-15483-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:14446 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932749Ab3CVLbQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Mar 2013 07:31:16 -0400
In-Reply-To: <1363950514-15483-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 446511d..ce46545 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1531,7 +1531,7 @@ int qla4xxx_get_chap_index(struct scsi_qla_host *ha, char *username,
 	int max_chap_entries = 0;
 	struct ql4_chap_table *chap_table;
 
-	if (is_qla8022(ha))
+	if (is_qla80XX(ha))
 		max_chap_entries = (ha->hw.flt_chap_size / 2) /
 						sizeof(struct ql4_chap_table);
 	else
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a6ce04d..18f857a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -391,7 +391,7 @@ static int qla4xxx_get_chap_list(struct Scsi_Host *shost, uint16_t chap_tbl_idx,
 	int valid_chap_entries = 0;
 	int ret = 0, i;
 
-	if (is_qla8022(ha))
+	if (is_qla80XX(ha))
 		max_chap_entries = (ha->hw.flt_chap_size / 2) /
 					sizeof(struct ql4_chap_table);
 	else
@@ -495,7 +495,7 @@ static int qla4xxx_delete_chap(struct Scsi_Host *shost, uint16_t chap_tbl_idx)
 
 	memset(chap_table, 0, sizeof(struct ql4_chap_table));
 
-	if (is_qla8022(ha))
+	if (is_qla80XX(ha))
 		max_chap_entries = (ha->hw.flt_chap_size / 2) /
 				   sizeof(struct ql4_chap_table);
 	else
@@ -4087,7 +4087,7 @@ static int qla4xxx_get_bidi_chap(struct scsi_qla_host *ha, char *username,
 	int max_chap_entries = 0;
 	struct ql4_chap_table *chap_table;
 
-	if (is_qla8022(ha))
+	if (is_qla80XX(ha))
 		max_chap_entries = (ha->hw.flt_chap_size / 2) /
 						sizeof(struct ql4_chap_table);
 	else
-- 
1.8.2.GIT


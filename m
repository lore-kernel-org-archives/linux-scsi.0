From: vikas.chaudhary@qlogic.com
Subject: [PATCH 02/11] qla4xxx: Fix un-necessary delay on invalid DDB
Date: Mon, 13 Feb 2012 18:30:41 +0530
Message-ID: <1329138050-1042-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:47426
	"HELO magana.localdomain" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1756620Ab2BMNJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Feb 2012 08:09:54 -0500
In-Reply-To: <1329138050-1042-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, ravi.anand@qlogic.com, lalit.chandivade@qlogic.com, vikas.chaudhary@qlogic.com

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Fix the un-necessary wait for completion of a sendtarget on an
invalid DDB entry. The state of an invalid DDB entry is 0 (unassigned)

This will also avoid the delays during system boot.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    2 ++
 drivers/scsi/qla4xxx/ql4_os.c  |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index e1e66a4..eaf2185 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -661,6 +661,8 @@ int qla4xxx_get_fwddb_entry(struct scsi_qla_host *ha,
 	}
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+	if (fw_ddb_entry)
+		memset(fw_ddb_entry, 0, sizeof(struct dev_db_entry));
 
 	mbox_cmd[0] = MBOX_CMD_GET_DATABASE_ENTRY;
 	mbox_cmd[1] = (uint32_t) fw_ddb_index;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c1189e5..089443a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4090,6 +4090,10 @@ static void qla4xxx_build_st_list(struct scsi_qla_host *ha,
 		if (ret == QLA_ERROR)
 			break;
 
+		/* Ignore DDB if invalid state (unassigned) */
+		if (state == DDB_DS_UNASSIGNED)
+			goto continue_next_st;
+
 		/* Check if ST, add to the list_st */
 		if (strlen((char *) fw_ddb_entry->iscsi_name) != 0)
 			goto continue_next_st;
-- 
1.7.8.247.g10f4e


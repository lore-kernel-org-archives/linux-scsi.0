From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 4/7] qla4xxx: discovery_parent_idx can be shown without any check.
Date: Mon, 8 Jul 2013 08:33:08 -0400
Message-ID: <1373286791-29659-5-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:11225
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752213Ab3GHNAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:47 -0400
Received: from mail3-co9 (localhost [127.0.0.1])	by mail3-co9-R.bigfish.com
 (Postfix) with ESMTP id 7673840175	for <linux-scsi@vger.kernel.org>; Mon,  8
 Jul 2013 13:00:46 +0000 (UTC)
Received: from CO9EHSMHS017.bigfish.com (unknown [10.236.132.248])	by
 mail3-co9.bigfish.com (Postfix) with ESMTP id 7731DAC0076	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:44 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 85762f7..a6e4d51 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -6235,7 +6235,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 	struct iscsi_bus_flash_conn *fnode_conn;
 	struct ql4_chap_table chap_tbl;
 	struct device *dev;
-	int parent_type, parent_index = 0xffff;
+	int parent_type;
 	int rc = 0;
 
 	dev = iscsi_find_flashnode_conn(fnode_sess);
@@ -6401,10 +6401,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 			rc = sprintf(buf, "\n");
 		break;
 	case ISCSI_FLASHNODE_DISCOVERY_PARENT_IDX:
-		if (fnode_sess->discovery_parent_idx < MAX_DDB_ENTRIES)
-			parent_index = fnode_sess->discovery_parent_idx;
-
-		rc = sprintf(buf, "%u\n", parent_index);
+		rc = sprintf(buf, "%u\n", fnode_sess->discovery_parent_idx);
 		break;
 	case ISCSI_FLASHNODE_DISCOVERY_PARENT_TYPE:
 		if (fnode_sess->discovery_parent_type == DDB_ISNS)
-- 
1.7.1



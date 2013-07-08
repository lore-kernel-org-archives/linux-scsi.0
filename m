From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH 2/7] qla4xxx: Use discovery_parent_idx instead of discovery_parent_type
Date: Mon, 8 Jul 2013 08:33:06 -0400
Message-ID: <1373286791-29659-3-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:34163
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752217Ab3GHNAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jul 2013 09:00:49 -0400
Received: from mail133-co9 (localhost [127.0.0.1])	by
 mail133-co9-R.bigfish.com (Postfix) with ESMTP id B6617DA010F	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:48 +0000 (UTC)
Received: from CO9EHSMHS005.bigfish.com (unknown [10.236.132.249])	by
 mail133-co9.bigfish.com (Postfix) with ESMTP id 545839C0064	for
 <linux-scsi@vger.kernel.org>; Mon,  8 Jul 2013 13:00:45 +0000 (UTC)
In-Reply-To: <1373286791-29659-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

While setting the values for DDB, discovery_parent_idx needs to be used
instead of discovery_parent_type.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ee2f903..9b25b8c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2262,7 +2262,7 @@ static int qla4xxx_copy_to_fwddb_param(struct iscsi_bus_flash_session *sess,
 	fw_ddb_entry->lcl_port = cpu_to_le16(conn->local_port);
 	fw_ddb_entry->stat_sn = cpu_to_le32(conn->statsn);
 	fw_ddb_entry->exp_stat_sn = cpu_to_le32(conn->exp_statsn);
-	fw_ddb_entry->ddb_link = cpu_to_le16(sess->discovery_parent_type);
+	fw_ddb_entry->ddb_link = cpu_to_le16(sess->discovery_parent_idx);
 	fw_ddb_entry->chap_tbl_idx = cpu_to_le16(sess->chap_out_idx);
 	fw_ddb_entry->tsid = cpu_to_le16(sess->tsid);
 	fw_ddb_entry->port = cpu_to_le16(conn->port);
@@ -6654,8 +6654,8 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
 			memcpy(fnode_conn->link_local_ipv6_addr,
 			       fnode_param->value, IPv6_ADDR_LEN);
 			break;
-		case ISCSI_FLASHNODE_DISCOVERY_PARENT_TYPE:
-			fnode_sess->discovery_parent_type =
+		case ISCSI_FLASHNODE_DISCOVERY_PARENT_IDX:
+			fnode_sess->discovery_parent_idx =
 						*(uint16_t *)fnode_param->value;
 			break;
 		case ISCSI_FLASHNODE_TCP_XMIT_WSF:
-- 
1.7.1



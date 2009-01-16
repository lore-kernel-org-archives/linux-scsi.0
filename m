From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] qla4xxx: do not reuse session when connecting to different target port
Date: Fri, 16 Jan 2009 12:36:52 -0600
Message-ID: <1232131015394-git-send-email-michaelc@cs.wisc.edu>
References: <12321310122973-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48690 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759972AbZAPShB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 13:37:01 -0500
In-Reply-To: <12321310122973-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

qla4xxx does not check the I_T nexus values correctly
so it ends up creating one session to the target. If
a portal should disappear or they should be reported
in different order the driver will think it is already
logged in when it could now be speaking to a different
target portal or accessing it through a different
initiator port (iscsi initiator port is not tied to
hardware and is just the initiator name plus isid
so you could end up with multiple ports through one
host).

This patch has the driver check the iscsi scsi port
values when matching sessions (we do not check
the initiator name because that is static). It results
in a portal from each target portal group getting
logged into instead of just one per target. In the future
the firmware should hopefully send us notification of other
sessions that are created to other portals within the
same tpgt and the sessions should have different isids.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_init.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index d6be076..b586f27 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -244,6 +244,7 @@ struct ddb_entry {
 	uint8_t ip_addr[ISCSI_IPADDR_SIZE];
 	uint8_t iscsi_name[ISCSI_NAME_SIZE];	/* 72 x48 */
 	uint8_t iscsi_alias[0x20];
+	uint8_t isid[6];
 };
 
 /*
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 109c5f5..af8c323 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -342,8 +342,12 @@ static struct ddb_entry* qla4xxx_get_ddb_entry(struct scsi_qla_host *ha,
 	DEBUG2(printk("scsi%ld: %s: Looking for ddb[%d]\n", ha->host_no,
 		      __func__, fw_ddb_index));
 	list_for_each_entry(ddb_entry, &ha->ddb_list, list) {
-		if (memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsi_name,
-			   ISCSI_NAME_SIZE) == 0) {
+		if ((memcmp(ddb_entry->iscsi_name, fw_ddb_entry->iscsi_name,
+			   ISCSI_NAME_SIZE) == 0) &&
+			(ddb_entry->tpgt ==
+				le32_to_cpu(fw_ddb_entry->tgt_portal_grp)) &&
+			(memcmp(ddb_entry->isid, fw_ddb_entry->isid,
+				sizeof(ddb_entry->isid)) == 0)) {
 			found++;
 			break;
 		}
@@ -430,6 +434,8 @@ static int qla4xxx_update_ddb_entry(struct scsi_qla_host *ha,
 
 	ddb_entry->port = le16_to_cpu(fw_ddb_entry->port);
 	ddb_entry->tpgt = le32_to_cpu(fw_ddb_entry->tgt_portal_grp);
+	memcpy(ddb_entry->isid, fw_ddb_entry->isid, sizeof(ddb_entry->isid));
+
 	memcpy(&ddb_entry->iscsi_name[0], &fw_ddb_entry->iscsi_name[0],
 	       min(sizeof(ddb_entry->iscsi_name),
 		   sizeof(fw_ddb_entry->iscsi_name)));
-- 
1.6.0.4


From: michaelc@cs.wisc.edu
Subject: [PATCH] qla4xxx: do not reuse session when connecting to different target port
Date: Wed, 10 Dec 2008 18:34:51 -0600
Message-ID: <1228955691-1537-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:44332 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYLKAez (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Dec 2008 19:34:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch was made over scsi-misc and is for
2.6.29.

This is the exact same code I sent before, but the
subject and description better describes what it
fixes. Because of a bug in the firmware we cannot
currently log into all the portals, so the previous
description was wrong.

qla4xxx does not check the I_T nexus values correctly
so it ends up creating one session to the target. If
a portal should disappear or they should be reported
in different order the driver will think it is already
logged in when it could now be speaking to a different
target portal or accessing it through a different
initiatir port (iscsi initiator port is not tied to
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
same tpgt and the sessions should have differnt isids.

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
1.5.6.5


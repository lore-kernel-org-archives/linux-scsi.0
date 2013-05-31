From: James Smart <james.smart@emulex.com>
Subject: [PATCH 12/17] lpfc 8.3.40: Fixed FCoE connection list vlan
 identifier and add FCF list debug
Date: Fri, 31 May 2013 17:05:08 -0400
Message-ID: <1370034308.17258.34.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5803 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3EaVLm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:11:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed FCoE connection list vlan identifier and add FCF list debug


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |   36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-05-03 09:24:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-05-31 10:58:25.153057799 -0400
@@ -6158,12 +6158,44 @@ lpfc_read_fcf_conn_tbl(struct lpfc_hba *
 		memcpy(&conn_entry->conn_rec, &conn_rec[i],
 			sizeof(struct lpfc_fcf_conn_rec));
 		conn_entry->conn_rec.vlan_tag =
-			le16_to_cpu(conn_entry->conn_rec.vlan_tag) & 0xFFF;
+			conn_entry->conn_rec.vlan_tag;
 		conn_entry->conn_rec.flags =
-			le16_to_cpu(conn_entry->conn_rec.flags);
+			conn_entry->conn_rec.flags;
 		list_add_tail(&conn_entry->list,
 			&phba->fcf_conn_rec_list);
 	}
+
+	if (!list_empty(&phba->fcf_conn_rec_list)) {
+		i = 0;
+		list_for_each_entry(conn_entry, &phba->fcf_conn_rec_list,
+				    list) {
+			conn_rec = &conn_entry->conn_rec;
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"3345 FCF connection list rec[%02d]: "
+					"flags:x%04x, vtag:x%04x, "
+					"fabric_name:x%02x:%02x:%02x:%02x:"
+					"%02x:%02x:%02x:%02x, "
+					"switch_name:x%02x:%02x:%02x:%02x:"
+					"%02x:%02x:%02x:%02x\n", i++,
+					conn_rec->flags, conn_rec->vlan_tag,
+					conn_rec->fabric_name[0],
+					conn_rec->fabric_name[1],
+					conn_rec->fabric_name[2],
+					conn_rec->fabric_name[3],
+					conn_rec->fabric_name[4],
+					conn_rec->fabric_name[5],
+					conn_rec->fabric_name[6],
+					conn_rec->fabric_name[7],
+					conn_rec->switch_name[0],
+					conn_rec->switch_name[1],
+					conn_rec->switch_name[2],
+					conn_rec->switch_name[3],
+					conn_rec->switch_name[4],
+					conn_rec->switch_name[5],
+					conn_rec->switch_name[6],
+					conn_rec->switch_name[7]);
+		}
+	}
 }
 
 /**




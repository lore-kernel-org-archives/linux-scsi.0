From: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>
Subject: [PATCH 1/1] scsi: qla4xxx: change some variables to hexadecimal string via %pm, %pmR and %pM  formats
Date: Sat,  6 Jul 2013 09:40:04 +0300
Message-ID: <1373092804-1380-1-git-send-email-Oleksandr.Khoshaba@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:55521 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3GFGkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jul 2013 02:40:14 -0400
Received: by mail-ea0-f170.google.com with SMTP id h10so1847740eaj.29
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jul 2013 23:40:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>

The patch modifies some variables using the formats '%pm', '%pmR', '%pM' and prints them as a hexadecimal string with the '' and ':'  separators.

Signed-off-by: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |    6 ++----
 drivers/scsi/qla4xxx/ql4_nx.c  |    8 ++------
 drivers/scsi/qla4xxx/ql4_os.c  |   15 ++++-----------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a501bea..004ada6 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1837,10 +1837,8 @@ int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
 	ptid = (uint16_t *)&fw_ddb_entry->isid[1];
 	*ptid = cpu_to_le16((uint16_t)ddb_entry->sess->target_id);
 
-	DEBUG2(ql4_printk(KERN_INFO, ha, "ISID [%02x%02x%02x%02x%02x%02x]\n",
-			  fw_ddb_entry->isid[5], fw_ddb_entry->isid[4],
-			  fw_ddb_entry->isid[3], fw_ddb_entry->isid[2],
-			  fw_ddb_entry->isid[1], fw_ddb_entry->isid[0]));
+	DEBUG2(ql4_printk(KERN_INFO, ha, "ISID [%pmR]\n",
+			  fw_ddb_entry->isid));
 
 	iscsi_opts = le16_to_cpu(fw_ddb_entry->iscsi_options);
 	memset(fw_ddb_entry->iscsi_alias, 0, sizeof(fw_ddb_entry->iscsi_alias));
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index eaf00c1..2bc1046 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -3455,12 +3455,8 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 	ha->phy_port_num = sys_info->port_num;
 	ha->iscsi_pci_func_cnt = sys_info->iscsi_pci_func_cnt;
 
-	DEBUG2(printk("scsi%ld: %s: "
-	    "mac %02x:%02x:%02x:%02x:%02x:%02x "
-	    "serial %s\n", ha->host_no, __func__,
-	    ha->my_mac[0], ha->my_mac[1], ha->my_mac[2],
-	    ha->my_mac[3], ha->my_mac[4], ha->my_mac[5],
-	    ha->serial_number));
+	DEBUG2(printk("scsi%ld: %s: mac %pM serial %s\n", ha->host_no,
+	    __func__, ha->my_mac, ha->serial_number));
 
 	status = QLA_SUCCESS;
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b246b3c..2797b8f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4786,13 +4786,9 @@ static int qla4xxx_compare_tuple_ddb(struct scsi_qla_host *ha,
 	 * ISID would not match firmware generated ISID.
 	 */
 	if (is_isid_compare) {
-		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: old ISID [%02x%02x%02x"
-			"%02x%02x%02x] New ISID [%02x%02x%02x%02x%02x%02x]\n",
-			__func__, old_tddb->isid[5], old_tddb->isid[4],
-			old_tddb->isid[3], old_tddb->isid[2], old_tddb->isid[1],
-			old_tddb->isid[0], new_tddb->isid[5], new_tddb->isid[4],
-			new_tddb->isid[3], new_tddb->isid[2], new_tddb->isid[1],
-			new_tddb->isid[0]));
+		DEBUG2(ql4_printk(KERN_INFO, ha,
+			"%s: old ISID [%pmR] New ISID [%pmR]\n",
+			__func__, old_tddb->isid, new_tddb->isid));
 
 		if (memcmp(&old_tddb->isid[0], &new_tddb->isid[0],
 			   sizeof(old_tddb->isid)))
@@ -6211,10 +6207,7 @@ qla4xxx_sysfs_ddb_get_param(struct iscsi_bus_flash_session *fnode_sess,
 		rc = sprintf(buf, "%u\n", fnode_conn->keepalive_timeout);
 		break;
 	case ISCSI_FLASHNODE_ISID:
-		rc = sprintf(buf, "%02x%02x%02x%02x%02x%02x\n",
-			     fnode_sess->isid[0], fnode_sess->isid[1],
-			     fnode_sess->isid[2], fnode_sess->isid[3],
-			     fnode_sess->isid[4], fnode_sess->isid[5]);
+		rc = sprintf(buf, "%pm\n", fnode_sess->isid);
 		break;
 	case ISCSI_FLASHNODE_TSID:
 		rc = sprintf(buf, "%u\n", fnode_sess->tsid);
-- 
1.7.9.5


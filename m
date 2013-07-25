From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 3/3] scsi: qla4xxx: print MAC and SID via %p[mM][R]
Date: Thu, 25 Jul 2013 12:10:25 +0300
Message-ID: <1374743425-13828-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1374743425-13828-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab3GYJKj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 05:10:39 -0400
In-Reply-To: <1374743425-13828-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>, Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>

From: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>

In the kernel we have nice specifier to print MAC by given pointer to the
address in binary form.

Signed-off-by: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>
Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c |  5 +----
 drivers/scsi/qla4xxx/ql4_nx.c  |  8 ++------
 drivers/scsi/qla4xxx/ql4_os.c  | 15 ++++-----------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index a501bea..f01b8ae 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1837,10 +1837,7 @@ int qla4xxx_set_param_ddbentry(struct scsi_qla_host *ha,
 	ptid = (uint16_t *)&fw_ddb_entry->isid[1];
 	*ptid = cpu_to_le16((uint16_t)ddb_entry->sess->target_id);
 
-	DEBUG2(ql4_printk(KERN_INFO, ha, "ISID [%02x%02x%02x%02x%02x%02x]\n",
-			  fw_ddb_entry->isid[5], fw_ddb_entry->isid[4],
-			  fw_ddb_entry->isid[3], fw_ddb_entry->isid[2],
-			  fw_ddb_entry->isid[1], fw_ddb_entry->isid[0]));
+	DEBUG2(ql4_printk(KERN_INFO, ha, "ISID [%pmR]\n", fw_ddb_entry->isid));
 
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
1.8.3.2


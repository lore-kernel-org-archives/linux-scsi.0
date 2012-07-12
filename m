From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] scsi: use kernel's '%pM' format option to print MAC
Date: Thu, 12 Jul 2012 10:51:29 +0300
Message-ID: <1342079490-20191-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758425Ab2GLHvy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2012 03:51:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, iscsi-driver@qlogic.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/scsi/fnic/vnic_dev.c  |   10 ++--------
 drivers/scsi/qla4xxx/ql4_nx.c |    8 ++------
 2 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index b576be7..0cb8ad0 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -499,10 +499,7 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		printk(KERN_ERR "Can't add addr [%pM], %d\n", addr, err);
 }
 
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
@@ -517,10 +514,7 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 
 	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
 	if (err)
-		printk(KERN_ERR
-			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-			addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-			err);
+		printk(KERN_ERR "Can't del addr [%pM], %d\n", addr, err);
 }
 
 int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 228b670..c163767 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2964,12 +2964,8 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 	ha->phy_port_num = sys_info->port_num;
 	ha->iscsi_pci_func_cnt = sys_info->iscsi_pci_func_cnt;
 
-	DEBUG2(printk("scsi%ld: %s: "
-	    "mac %02x:%02x:%02x:%02x:%02x:%02x "
-	    "serial %s\n", ha->host_no, __func__,
-	    ha->my_mac[0], ha->my_mac[1], ha->my_mac[2],
-	    ha->my_mac[3], ha->my_mac[4], ha->my_mac[5],
-	    ha->serial_number));
+	DEBUG2(printk("scsi%ld: %s: mac %pM serial %s\n", ha->host_no, __func__,
+		ha->my_mac, ha->serial_number));
 
 	status = QLA_SUCCESS;
 
-- 
1.7.10.4


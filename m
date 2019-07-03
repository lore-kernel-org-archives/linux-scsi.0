From: Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 24/35] scsi/qla4xxx: Use kmemdup rather than duplicating its implementation
Date: Thu,  4 Jul 2019 00:30:33 +0800
Message-ID: <20190703163033.456-1-huangfq.daxian@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: QLogic-Storage-Upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Fuqian Huang <huangfq.daxian@gmail.com>
List-Id: linux-scsi@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

 drivers/scsi/qla4xxx/ql4_os.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 8c674eca09f1..8f8c64e5f02d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3559,21 +3559,18 @@ static int qla4xxx_copy_from_fwddb_param(struct iscsi_bus_flash_session *sess,
 	conn->port = le16_to_cpu(fw_ddb_entry->port);
 
 	options = le16_to_cpu(fw_ddb_entry->options);
-	conn->ipaddress = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
+	conn->ipaddress = kmemdup(fw_ddb_entry->ip_addr, IPv6_ADDR_LEN, GFP_KERNEL);
 	if (!conn->ipaddress) {
 		rc = -ENOMEM;
 		goto exit_copy;
 	}
 
-	conn->redirect_ipaddr = kzalloc(IPv6_ADDR_LEN, GFP_KERNEL);
+	conn->redirect_ipaddr = kmemdup(fw_ddb_entry->tgt_addr, IPv6_ADDR_LEN, GFP_KERNEL);
 	if (!conn->redirect_ipaddr) {
 		rc = -ENOMEM;
 		goto exit_copy;
 	}
 
-	memcpy(conn->ipaddress, fw_ddb_entry->ip_addr, IPv6_ADDR_LEN);
-	memcpy(conn->redirect_ipaddr, fw_ddb_entry->tgt_addr, IPv6_ADDR_LEN);
-
 	if (test_bit(OPT_IPV6_DEVICE, &options)) {
 		conn->ipv6_traffic_class = fw_ddb_entry->ipv4_tos;
 
-- 
2.11.0

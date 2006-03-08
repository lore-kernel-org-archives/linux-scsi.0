From: ravi.anand@qlogic.com
Subject: [PATCH 07/11] Fixed logic to skip device discovery if IP Addr and Subnet Mask is Zero.
Date: Tue, 7 Mar 2006 16:35:48 -0800
Message-ID: <11417781434067-git-send-email-ravi.anand@qlogic.com>
References: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:41969 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S964855AbWCHAfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:35:51 -0500
In-Reply-To: <11417781172980-git-send-email-ravi.anand@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, arjan@infradead.org
Cc: ravi.anand@qlogic.com

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>


---

 drivers/scsi/qla4xxx/ql4_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

54a41b8be941564bb4fd2dd3bb8551cca7d79ee6
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 004782c..7fffcd4 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1218,6 +1218,7 @@ int
 qla4xxx_initialize_adapter(scsi_qla_host_t * ha, uint8_t renew_ddb_list)
 {
 	int status = QLA_ERROR;
+	int8_t ip_address[IP_ADDR_LEN] = {0} ;
 
 	ha->eeprom_cmd_data = 0;
 
@@ -1248,8 +1249,8 @@ qla4xxx_initialize_adapter(scsi_qla_host
 		return status;
 
 	/* Skip device discovery if ip and subnet is zero */
-	if (memcmp(ha->ip_address, 0, IP_ADDR_LEN) ||
-	    memcmp(ha->subnet_mask, 0, IP_ADDR_LEN))
+        if (memcmp(ha->ip_address, ip_address, IP_ADDR_LEN) == 0 ||
+            memcmp(ha->subnet_mask, ip_address, IP_ADDR_LEN) == 0)
 		return status;
 
 	if (renew_ddb_list == PRESERVE_DDB_LIST) {
-- 
1.2.4.g9201-dirty



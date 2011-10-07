From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH v2 13/14] qla4xxx: updated device id check for BFS.
Date: Fri, 7 Oct 2011 16:55:51 -0700
Message-ID: <1318031752-3836-14-git-send-email-vikas.chaudhary@qlogic.com>
References: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:34005
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754837Ab1JHAHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2011 20:07:30 -0400
In-Reply-To: <1318031752-3836-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

JIRA Key: UPSISCSI-75

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fca3d2b..d39205c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2782,12 +2782,10 @@ static int get_fw_boot_info(struct scsi_qla_host *ha, uint16_t ddb_index[])
 
 	func_num = PCI_FUNC(ha->pdev->devfn);
 
-	DEBUG2(ql4_printk(KERN_INFO, ha,
-			  "%s: Get FW  boot info for 0x%x func %d\n", __func__,
-			  (is_qla4032(ha) ? PCI_DEVICE_ID_QLOGIC_ISP4032 :
-			   PCI_DEVICE_ID_QLOGIC_ISP8022), func_num));
+	ql4_printk(KERN_INFO, ha, "%s: Get FW boot info for 0x%x func %d\n",
+		   __func__, ha->pdev->device, func_num);
 
-	if (is_qla4032(ha)) {
+	if (is_qla40XX(ha)) {
 		if (func_num == 1) {
 			addr = NVRAM_PORT0_BOOT_MODE;
 			pri_addr = NVRAM_PORT0_BOOT_PRI_TGT;
-- 
1.7.6



From: madhu.iyengar@qlogic.com
Subject: [PATCH 15/18] qla2xxx: Limit the logs in case device state does not change for ISP82xx.
Date: Wed, 30 Mar 2011 11:46:30 -0700
Message-ID: <1301510793-2492-16-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45811 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756056Ab1C3SvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:18 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index d540b73..f64e126 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3543,15 +3543,18 @@ int
 qla82xx_device_state_handler(scsi_qla_host_t *vha)
 {
 	uint32_t dev_state;
+	uint32_t old_dev_state;
 	int rval = QLA_SUCCESS;
 	unsigned long dev_init_timeout;
 	struct qla_hw_data *ha = vha->hw;
+	int loopcount = 0;
 
 	qla82xx_idc_lock(ha);
 	if (!vha->flags.init_done)
 		qla82xx_set_drv_active(vha);
 
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	old_dev_state = dev_state;
 	qla_printk(KERN_INFO, ha, "1:Device state is 0x%x = %s\n", dev_state,
 		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
 
@@ -3568,10 +3571,16 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			break;
 		}
 		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-		qla_printk(KERN_INFO, ha,
-			"2:Device state is 0x%x = %s\n", dev_state,
-			dev_state < MAX_STATES ?
-			qdev_state[dev_state] : "Unknown");
+		if (old_dev_state != dev_state) {
+			loopcount = 0;
+			old_dev_state = dev_state;
+		}
+		if (loopcount < 5) {
+			qla_printk(KERN_INFO, ha,
+			    "2:Device state is 0x%x = %s\n", dev_state,
+			    dev_state < MAX_STATES ?
+			    qdev_state[dev_state] : "Unknown");
+		}
 
 		switch (dev_state) {
 		case QLA82XX_DEV_READY:
@@ -3620,6 +3629,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			msleep(1000);
 			qla82xx_idc_lock(ha);
 		}
+		loopcount++;
 	}
 exit:
 	qla82xx_idc_unlock(ha);
-- 
1.6.0.2


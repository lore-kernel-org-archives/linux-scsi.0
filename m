From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 23/35] qla2xxx: Enable diagnostic port using NVRAM parameters.
Date: Thu, 25 Sep 2014 05:16:54 -0400
Message-ID: <1411636626-7566-24-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:58299 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbaIYJvW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:22 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c161d60..c29f465 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3136,6 +3136,7 @@ struct qla_hw_data {
 #define IS_ATIO_MSIX_CAPABLE(ha) (IS_QLA83XX(ha))
 #define IS_TGT_MODE_CAPABLE(ha)	(ha->tgt.atio_q_length)
 #define IS_SHADOW_REG_CAPABLE(ha)  (IS_QLA27XX(ha))
+#define IS_DPORT_CAPABLE(ha)  (IS_QLA83XX(ha) || IS_QLA27XX(ha))
 
 	/* HBA serial number */
 	uint8_t		serial0;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ab22ccf..1b91771 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2196,6 +2196,10 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 		mid_init_cb->init_cb.execution_throttle =
 		    cpu_to_le16(ha->fw_xcb_count);
+		/* D-Port Status */
+		if (IS_DPORT_CAPABLE(ha))
+			mid_init_cb->init_cb.firmware_options_1 |=
+			    cpu_to_le16(BIT_7);
 	}
 
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
-- 
1.7.7


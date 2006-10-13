From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/4] qla2xxx: Workaround D3 power-management issues.
Date: Fri, 13 Oct 2006 09:33:38 -0700
Message-ID: <1160757220864-git-send-email-andrew.vasquez@qlogic.com>
References: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:44256 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751724AbWJMQdx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:33:53 -0400
In-Reply-To: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Early ISP2432 parts have a known hardware issue when coming
out of a D3 hot state.  This issue can result in a hung PCIe
link.  Recent firmwares contain a workaround whereby the
stop-firmware mailbox command prevents the ISP from entering
the D3 hot state.

In order to ensure that the workaround succeeded the driver
must verify that the stop-firmware mailbox command completes
successfully.  In the event of a failure, the driver
attempts a shutdown-retry after resetting the ISP and
re-executing firmware.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   21 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    6 +++---
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b51ce8f..ca2f660 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -48,6 +48,7 @@ extern void qla2x00_update_fcport(scsi_q
 extern void qla2x00_reg_remote_port(scsi_qla_host_t *, fc_port_t *);
 
 extern void qla2x00_alloc_fw_dump(scsi_qla_host_t *);
+extern void qla2x00_try_to_stop_firmware(scsi_qla_host_t *);
 
 /*
  * Global Data in qla_os.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d5e0a12..08cb5e3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3948,3 +3948,24 @@ qla24xx_load_risc(scsi_qla_host_t *ha, u
 fail_fw_integrity:
 	return QLA_FUNCTION_FAILED;
 }
+
+void
+qla2x00_try_to_stop_firmware(scsi_qla_host_t *ha)
+{
+	int ret, retries;
+
+	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
+		return;
+
+	ret = qla2x00_stop_firmware(ha);
+	for (retries = 5; ret != QLA_SUCCESS && retries ; retries--) {
+		qla2x00_reset_chip(ha);
+		if (qla2x00_chip_diag(ha) != QLA_SUCCESS)
+			continue;
+		if (qla2x00_setup_chip(ha) != QLA_SUCCESS)
+			continue;
+		qla_printk(KERN_INFO, ha,
+		    "Attempting retry of stop-firmware command...\n");
+		ret = qla2x00_stop_firmware(ha);
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 34b6eb7..54f561d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1712,8 +1712,10 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	if (ha->eft)
 		qla2x00_trace_control(ha, TC_DISABLE, 0, 0);
 
+	ha->flags.online = 0;
+
 	/* Stop currently executing firmware. */
-	qla2x00_stop_firmware(ha);
+	qla2x00_try_to_stop_firmware(ha);
 
 	/* turn-off interrupts on the card */
 	if (ha->interrupts_on)
@@ -1721,8 +1723,6 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 
 	qla2x00_mem_free(ha);
 
-	ha->flags.online = 0;
-
 	/* Detach interrupts */
 	if (ha->host->irq)
 		free_irq(ha->host->irq, ha);
-- 
1.4.3.rc2.g23bed


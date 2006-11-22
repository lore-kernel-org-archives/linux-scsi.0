From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/2] Defer topology discovery to DPC thread during initialization.
Date: Wed, 22 Nov 2006 08:22:19 -0800
Message-ID: <20061122162219.GD1538@andrew-vasquezs-computer.local>
References: <20061113152605.GZ16952@parisc-linux.org> <20061120192140.GE11420@andrew-vasquezs-computer.local> <20061120201143.GN18567@parisc-linux.org> <20061122161926.GC1538@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:49580 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1755328AbWKVQWW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Nov 2006 11:22:22 -0500
Content-Disposition: inline
In-Reply-To: <20061122161926.GC1538@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com

Modify intialization semantics:

- perform basic hardware configuration only (as usual)
  - allocate resources
  - load and execute firmware

- defer link (transport) negotiations to the DPC thread
  - again the code in qla2x00_initialize_adapter() to stall probe()
    completion was needed for legacy-style scanning.
  - DPC thread stalls until probe() complete.

- before probe() completes, set DPC flags to perform loop-resync logic
  (similar to what's done during cable-insertion/removal).

Benefits: user does not have to wait 20+ seconds in case the FC cable
is unplugged during driver load, code consolidation (removal of
redundant link negotiation logic during initialize_adaoter()), and
finilly, the driver no longer needs to defer the fc_remote_port_add()
calls to hold off lun-scanning prior to returning from the probe()
function.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_init.c |   94 ++++-----------------------------------
 drivers/scsi/qla2xxx/qla_os.c   |   29 +++---------
 2 files changed, 16 insertions(+), 107 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 08cb5e3..a823f0b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -59,9 +59,6 @@ int
 qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 {
 	int	rval;
-	uint8_t	restart_risc = 0;
-	uint8_t	retry;
-	uint32_t wait_time;
 
 	/* Clear adapter flags. */
 	ha->flags.online = 0;
@@ -104,87 +101,15 @@ qla2x00_initialize_adapter(scsi_qla_host
 
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
-	retry = 10;
-	/*
-	 * Try to configure the loop.
-	 */
-	do {
-		restart_risc = 0;
-
-		/* If firmware needs to be loaded */
-		if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
-			if ((rval = ha->isp_ops.chip_diag(ha)) == QLA_SUCCESS) {
-				rval = qla2x00_setup_chip(ha);
-			}
-		}
-
-		if (rval == QLA_SUCCESS &&
-		    (rval = qla2x00_init_rings(ha)) == QLA_SUCCESS) {
-check_fw_ready_again:
-			/*
-			 * Wait for a successful LIP up to a maximum
-			 * of (in seconds): RISC login timeout value,
-			 * RISC retry count value, and port down retry
-			 * value OR a minimum of 4 seconds OR If no
-			 * cable, only 5 seconds.
-			 */
-			rval = qla2x00_fw_ready(ha);
-			if (rval == QLA_SUCCESS) {
-				clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-
-				/* Issue a marker after FW becomes ready. */
-				qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
-
-				/*
-				 * Wait at most MAX_TARGET RSCNs for a stable
-				 * link.
-				 */
-				wait_time = 256;
-				do {
-					clear_bit(LOOP_RESYNC_NEEDED,
-					    &ha->dpc_flags);
-					rval = qla2x00_configure_loop(ha);
-
-					if (test_and_clear_bit(ISP_ABORT_NEEDED,
-					    &ha->dpc_flags)) {
-						restart_risc = 1;
-						break;
-					}
-
-					/*
-					 * If loop state change while we were
-					 * discoverying devices then wait for
-					 * LIP to complete
-					 */
-
-					if (atomic_read(&ha->loop_state) !=
-					    LOOP_READY && retry--) {
-						goto check_fw_ready_again;
-					}
-					wait_time--;
-				} while (!atomic_read(&ha->loop_down_timer) &&
-				    retry &&
-				    wait_time &&
-				    (test_bit(LOOP_RESYNC_NEEDED,
-					&ha->dpc_flags)));
-
-				if (wait_time == 0)
-					rval = QLA_FUNCTION_FAILED;
-			} else if (ha->device_flags & DFLG_NO_CABLE)
-				/* If no cable, then all is good. */
-				rval = QLA_SUCCESS;
-		}
-	} while (restart_risc && retry--);
-
-	if (rval == QLA_SUCCESS) {
-		clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
-		qla2x00_marker(ha, 0, 0, MK_SYNC_ALL);
-		ha->marker_needed = 0;
-
-		ha->flags.online = 1;
-	} else {
-		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
+	if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
+		rval = ha->isp_ops.chip_diag(ha);
+		if (rval)
+			return (rval);
+		rval = qla2x00_setup_chip(ha);
+		if (rval)
+			return (rval);
 	}
+	rval = qla2x00_init_rings(ha);
 
 	return (rval);
 }
@@ -2208,8 +2133,7 @@ qla2x00_update_fcport(scsi_qla_host_t *h
 
 	atomic_set(&fcport->state, FCS_ONLINE);
 
-	if (ha->flags.init_done)
-		qla2x00_reg_remote_port(ha, fcport);
+	qla2x00_reg_remote_port(ha, fcport);
 }
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 208607b..47868b0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1377,10 +1377,8 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	struct Scsi_Host *host;
 	scsi_qla_host_t *ha;
 	unsigned long	flags = 0;
-	unsigned long	wait_switch = 0;
 	char pci_info[20];
 	char fw_str[30];
-	fc_port_t *fcport;
 	struct scsi_host_template *sht;
 
 	if (pci_enable_device(pdev))
@@ -1631,24 +1629,15 @@ qla2x00_probe_one(struct pci_dev *pdev,
 
 	ha->isp_ops.enable_intrs(ha);
 
-	/* v2.19.5b6 */
-	/*
-	 * Wait around max loop_reset_delay secs for the devices to come
-	 * on-line. We don't want Linux scanning before we are ready.
-	 *
-	 */
-	for (wait_switch = jiffies + (ha->loop_reset_delay * HZ);
-	    time_before(jiffies,wait_switch) &&
-	     !(ha->device_flags & (DFLG_NO_CABLE | DFLG_FABRIC_DEVICES))
-	     && (ha->device_flags & SWITCH_FOUND) ;) {
-
-		qla2x00_check_fabric_devices(ha);
-
-		msleep(10);
-	}
-
 	pci_set_drvdata(pdev, ha);
+
+	/* Start link scan. */
+	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
+	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+	set_bit(RSCN_UPDATE, &ha->dpc_flags);
 	ha->flags.init_done = 1;
+	ha->flags.online = 1;
+
 	num_hosts++;
 
 	ret = scsi_add_host(host, &pdev->dev);
@@ -1669,10 +1658,6 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
 	    ha->isp_ops.fw_version_str(ha, fw_str));
 
-	/* Go with fc_rport registration. */
-	list_for_each_entry(fcport, &ha->fcports, list)
-		qla2x00_reg_remote_port(ha, fcport);
-
 	return 0;
 
 probe_failed:
-- 
1.4.4.gef06


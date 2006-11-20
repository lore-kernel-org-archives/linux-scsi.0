From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] Asynchronous scanning for FC/SAS version 3
Date: Mon, 20 Nov 2006 11:21:41 -0800
Message-ID: <20061120192140.GE11420@andrew-vasquezs-computer.local>
References: <20061113152605.GZ16952@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:61491 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S966462AbWKTTVm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 14:21:42 -0500
Content-Disposition: inline
In-Reply-To: <20061113152605.GZ16952@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, james.smart@emulex.com

On Mon, 13 Nov 2006, Matthew Wilcox wrote:

> This is the third version of this patch.  Earlier versions can be found at
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116136002113903&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116311295814181&w=2
> http://marc.theaimsgroup.com/?l=linux-scsi&m=116316322719160&w=2
> 
> This patch, relative to scsi-misc, adds infrastructure to support
> asynchronous scanning for drivers which call scsi_scan_target, and
> changes the aic94xx, lpfc and qla2xxx drivers to use it.
> 
> It's a fairly radical restructuring for lpfc and qla2xxx and I may
> well have broken some error handling cases during initialisation.
> I'd appreciate review from the respective maintainers.

The main reason the qla2xxx driver delayed initialization until a
'steady' link-state was acheived, was to insure that devices would be
discovered during the first(/only)-pass scsi_scan_host().  This though
is all legacy-style scanning as FC transport aware drivers initiate
lun scannning indirectly via an fc_remote_port_add() call.

Perhaps as an alternative, I'd propose the following change to qla2xxx
intialization semantics:

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

Regards,
Andrew Vasquez

---

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
index 208607b..ef2c18b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1648,7 +1648,14 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	}
 
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
@@ -1669,10 +1676,6 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	    ha->flags.enable_64bit_addressing ? '+': '-', ha->host_no,
 	    ha->isp_ops.fw_version_str(ha, fw_str));
 
-	/* Go with fc_rport registration. */
-	list_for_each_entry(fcport, &ha->fcports, list)
-		qla2x00_reg_remote_port(ha, fcport);
-
 	return 0;
 
 probe_failed:

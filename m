From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [8/15]  qla2xxx: Volatile topology fixes
Date: Thu, 6 May 2004 22:54:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055445.GA4929@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:3313 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263188AbUEGFxB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:53:01 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1929 04/04/30 13:15:14 andrew.vasquez@apc.qlogic.com +2 -0
  Fix problem where during ISP initialization in a volatile topology
  (i.e. fabric environment with large number of streaming RSCNs) the
  driver would loop indefinitely or hang due to termination of an 
  invalid thread pid.

 drivers/scsi/qla2xxx/qla_init.c |  142 ++++++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_os.c   |    1 
 2 files changed, 60 insertions(+), 83 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:15:01 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:15:01 2004
@@ -102,9 +102,9 @@
 qla2x00_initialize_adapter(scsi_qla_host_t *ha)
 {
 	int	rval;
-	uint8_t	isp_init = 0;
 	uint8_t	restart_risc = 0;
 	uint8_t	retry;
+	uint32_t wait_time;
 
 	/* Clear adapter flags. */
 	ha->flags.online = FALSE;
@@ -136,8 +136,6 @@
 	qla_printk(KERN_INFO, ha, "Configure NVRAM parameters...\n");
 	qla2x00_nvram_config(ha);
 
-	ha->retry_count = ql2xretrycount;
-
 	qla_printk(KERN_INFO, ha, "Verifying loaded RISC code...\n");
 
 #if 0
@@ -158,7 +156,6 @@
 	 */
 	do {
 		restart_risc = 0;
-		isp_init = 0;
 
 		/* If firmware needs to be loaded */
 		if (qla2x00_isp_firmware(ha) != QLA_SUCCESS) {
@@ -177,21 +174,22 @@
 			 * value OR a minimum of 4 seconds OR If no 
 			 * cable, only 5 seconds.
 			 */
-			if (!qla2x00_fw_ready(ha)) {
+			rval = qla2x00_fw_ready(ha);
+			if (rval == QLA_SUCCESS) {
 				clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 
 				/*
-				 * Go setup flash database devices with proper
-				 * Loop ID's.
+				 * Wait at most MAX_TARGET RSCNs for a stable
+				 * link.
 				 */
+				wait_time = 256;
 				do {
 					clear_bit(LOOP_RESYNC_NEEDED,
 					    &ha->dpc_flags);
 					rval = qla2x00_configure_loop(ha);
 
-					if (test_bit(ISP_ABORT_NEEDED,
+					if (test_and_clear_bit(ISP_ABORT_NEEDED,
 					    &ha->dpc_flags)) {
-
 						restart_risc = 1;
 						break;
 					}
@@ -206,20 +204,22 @@
 					    LOOP_DOWN && retry--) {
 						goto check_fw_ready_again;
 					}
+					wait_time--;
 				} while (!atomic_read(&ha->loop_down_timer) &&
 				    retry &&
-				    (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
-			}
-
-			if (ha->mem_err) {
-				restart_risc = 1;
+				    wait_time &&
+				    (test_bit(LOOP_RESYNC_NEEDED,
+					&ha->dpc_flags)));
+
+				if (wait_time == 0)
+					rval = QLA_FUNCTION_FAILED;
+				if (ha->mem_err)
+					restart_risc = 1;
 			}
-			isp_init = 1;
-
 		}
 	} while (restart_risc && retry--);
 
-	if (isp_init) {
+	if (rval == QLA_SUCCESS) {
 		/* Retrieve firmware information */
 		qla2x00_get_fw_version(ha, &ha->fw_major_version,
 		    &ha->fw_minor_version, &ha->fw_subminor_version,
@@ -231,9 +231,7 @@
 		ha->marker_needed = 0;
 
 		ha->flags.online = TRUE;
-	}
-
-	if (rval) {
+	} else {
 		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
 	}
 
@@ -1515,24 +1513,24 @@
 qla2x00_configure_loop(scsi_qla_host_t *ha) 
 {
 	int  rval;
-	uint8_t  rval1 = 0;
 	unsigned long flags, save_flags;
 
 	rval = QLA_SUCCESS;
 
 	/* Get Initiator ID */
-	if (qla2x00_configure_hba(ha)) {
-		DEBUG(printk("scsi(%ld): Unable to configure HBA.\n",
-		    ha->host_no));
-		return (QLA_FUNCTION_FAILED);
+	if (test_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags)) {
+		rval = qla2x00_configure_hba(ha);
+		if (rval != QLA_SUCCESS) {
+			DEBUG(printk("scsi(%ld): Unable to configure HBA.\n",
+			    ha->host_no));
+			return (rval);
+		}
 	}
 
 	save_flags = flags = ha->dpc_flags;
 	DEBUG(printk("scsi(%ld): Configure loop -- dpc flags =0x%lx\n",
 	    ha->host_no, flags));
 
-	/* dg 02/26/02 ha->dpc_flags &= ~(LOCAL_LOOP_UPDATE | RSCN_UPDATE); */
-
 	/*
 	 * If we have both an RSCN and PORT UPDATE pending then handle them
 	 * both at the same time.
@@ -1563,50 +1561,32 @@
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	}
 
-	do {
-		if (test_bit(LOCAL_LOOP_UPDATE, &flags)) {
-			rval = rval | qla2x00_configure_local_loop(ha);
-		}
-
-		if (test_bit(RSCN_UPDATE, &flags)) {
-			rval1 = qla2x00_configure_fabric(ha);
-			if ((rval1 & BIT_0) && ha->sns_retry_cnt < 8) {
-				ha->sns_retry_cnt++;
-				set_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags);
-			}
+	if (test_bit(LOCAL_LOOP_UPDATE, &flags)) {
+		if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+			rval = QLA_FUNCTION_FAILED;
+		} else {
+			rval = qla2x00_configure_local_loop(ha);
 		}
+	}
 
-		/* Isolate error status. */
-		if (rval & BIT_0) {
-			rval = 1;
+	if (rval == QLA_SUCCESS && test_bit(RSCN_UPDATE, &flags)) {
+		if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+			rval = QLA_FUNCTION_FAILED;
 		} else {
-			rval = QLA_SUCCESS;
+			rval = qla2x00_configure_fabric(ha);
 		}
+	}
 
-	} while (rval != QLA_SUCCESS);
-
-	if (!atomic_read(&ha->loop_down_timer) &&
-	    !(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))) {
-
-		qla2x00_config_os(ha);
-
-		/* If we found all devices then go ready */
-		if (!(test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags))) {
+	if (rval == QLA_SUCCESS) {
+		if (atomic_read(&ha->loop_down_timer) ||
+		    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+			rval = QLA_FUNCTION_FAILED;
+		} else {
+			qla2x00_config_os(ha);
 			atomic_set(&ha->loop_state, LOOP_READY);
 
 			DEBUG(printk("scsi(%ld): LOOP READY\n", ha->host_no));
-		} else {
-			if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
-				set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-			if (test_bit(RSCN_UPDATE, &save_flags))
-				set_bit(RSCN_UPDATE, &ha->dpc_flags);
 		}
-	} else {
-		DEBUG(printk("scsi(%ld): Loop down counter running= %d or "
-		    "Resync needed- dpc flags= %ld\n",
-		    ha->host_no,
-		    atomic_read(&ha->loop_down_timer), ha->dpc_flags));
-		/* ???? dg 02/26/02  rval = 1; */
 	}
 
 	if (rval) {
@@ -1638,7 +1618,6 @@
  *
  * Returns:
  *	0 = success.
- *	BIT_0 = error.
  */
 static int
 qla2x00_configure_local_loop(scsi_qla_host_t *ha) 
@@ -1663,19 +1642,9 @@
 	uint16_t	loop_id;
 	uint8_t		domain, area, al_pa;
 
-	rval = QLA_SUCCESS;
 	found_devs = 0;
 	new_fcport = NULL;
 
-	/*
-	 * No point in continuing if the loop is in a volatile state -- 
-	 * reschedule LOCAL_LOOP_UPDATE for later processing
-	 */
-	if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
-		set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
-		return (rval);
-	}
-
 	entries = MAX_FIBRE_DEVICES;
 	id_list = pci_alloc_consistent(ha->pdev, MAX_ID_LIST_SIZE,
 	    &id_list_dma);
@@ -1687,7 +1656,7 @@
 		    "Memory Allocation failed - port_list");
 
 		ha->mem_err++;
-		return (BIT_0);
+		return (QLA_MEMORY_ALLOC_FAILED);
 	}
 	memset(id_list, 0, MAX_ID_LIST_SIZE);
 
@@ -1696,8 +1665,7 @@
 
 	/* Get list of logged in devices. */
 	rval = qla2x00_get_id_list(ha, id_list, id_list_dma, &entries);
-	if (rval) {
-		rval = BIT_0;
+	if (rval != QLA_SUCCESS) {
 		goto cleanup_allocation;
 	}
 
@@ -1709,7 +1677,7 @@
 	/* Allocate temporary fcport for any new fcports discovered. */
 	new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
 	if (new_fcport == NULL) {
-		rval = BIT_0;
+		rval = QLA_MEMORY_ALLOC_FAILED;
 		goto cleanup_allocation;
 	}
 	new_fcport->flags &= ~FCF_FABRIC_DEVICE;
@@ -1802,7 +1770,7 @@
 			fcport = new_fcport;
 			new_fcport = qla2x00_alloc_fcport(ha, GFP_KERNEL);
 			if (new_fcport == NULL) {
-				rval = BIT_0;
+				rval = QLA_MEMORY_ALLOC_FAILED;
 				goto cleanup_allocation;
 			}
 			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
@@ -1819,7 +1787,7 @@
 	if (new_fcport)
 		kfree(new_fcport);
 
-	if (rval & BIT_0) {
+	if (rval != QLA_SUCCESS) {
 		DEBUG2(printk("scsi(%ld): Configure local loop error exit: "
 		    "rval=%x\n", ha->host_no, rval));
 	}
@@ -2358,7 +2326,7 @@
 	/* Mark devices that need re-synchronization. */
 	rval2 = qla2x00_device_resync(ha);
 	if (rval2 == QLA_RSCNS_HANDLED) {
-		/* No, point doing the scan, just continue. */
+		/* No point doing the scan, just continue. */
 		return (QLA_SUCCESS);
 	}
 	do {
@@ -2508,7 +2476,6 @@
  *
  * Returns:
  *	0 = success.
- *	BIT_0 = error.
  *
  * Context:
  *	Kernel context.
@@ -3101,6 +3068,7 @@
 qla2x00_loop_resync(scsi_qla_host_t *ha) 
 {
 	int   rval;
+	uint32_t wait_time;
 
 	rval = QLA_SUCCESS;
 
@@ -3109,6 +3077,8 @@
 	clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 	if (ha->flags.online) {
 		if (!(rval = qla2x00_fw_ready(ha))) {
+			/* Wait at most MAX_TARGET RSCNs for a stable link. */
+			wait_time = 256;
 			do {
 				/* v2.19.05b6 */
 				atomic_set(&ha->loop_state, LOOP_UPDATE);
@@ -3123,12 +3093,13 @@
 				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 
 				qla2x00_configure_loop(ha);
-
+				wait_time--;
 			} while (!atomic_read(&ha->loop_down_timer) &&
 				!(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) &&
+				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
-		qla2x00_restart_queues(ha,TRUE);
+		qla2x00_restart_queues(ha, TRUE);
 	}
 
 	if (test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
@@ -4260,6 +4231,7 @@
 	uint8_t		status = 0;
 	device_reg_t	*reg;
 	unsigned long	flags = 0;
+	uint32_t wait_time;
 
 	/* If firmware needs to be loaded */
 	if (qla2x00_isp_firmware(ha)) {
@@ -4303,11 +4275,15 @@
 					__func__,
 					status);)
 			ha->flags.online = TRUE;
+			/* Wait at most MAX_TARGET RSCNs for a stable link. */
+			wait_time = 256;
 			do {
 				clear_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 				qla2x00_configure_loop(ha);
+				wait_time--;
 			} while (!atomic_read(&ha->loop_down_timer) &&
 				!(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) &&
+				wait_time &&
 				(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)));
 		}
 
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:15:01 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:15:01 2004
@@ -2024,6 +2024,7 @@
 	spin_lock_init(&ha->mbx_reg_lock);
 	spin_lock_init(&ha->list_lock);
 
+	ha->dpc_pid = -1;
 	init_completion(&ha->dpc_inited);
 	init_completion(&ha->dpc_exited);
 

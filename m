From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [4/8]  qla2xxx: Small fixes
Date: Mon, 6 Sep 2004 21:28:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042804.GA29603@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:27054 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267575AbUIGE34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:29:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1874 04/09/06 11:47:07 andrew.vasquez@qlogic.com +4 -0
  Misc. small fixes:
  
          o Always set an TCQ modifier for each command submitted.
          o Always (re)-initialize NVRAM during execution.
          o Add pci_disable_device() calls to proper locations during
            pci-probe failure and pci-remove.
          o Do not begin processing until the DPC has been marked
            'active'.
          o Fix off-by-one error while copying sense-data.
          o Fix bus-reset issue during back-door execution.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c |    7 +++----
 drivers/scsi/qla2xxx/qla_iocb.c |    5 +----
 drivers/scsi/qla2xxx/qla_isr.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c   |   23 ++++++++++++-----------
 4 files changed, 18 insertions(+), 21 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:07:36 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-09-06 12:07:36 -07:00
@@ -217,7 +217,9 @@
 					rval = QLA_FUNCTION_FAILED;
 				if (ha->mem_err)
 					restart_risc = 1;
-			}
+			} else if (ha->device_flags & DFLG_NO_CABLE)
+				/* If no cable, then all is good. */
+				rval = QLA_SUCCESS;
 		}
 	} while (restart_risc && retry--);
 
@@ -1202,9 +1204,6 @@
 	uint8_t  timer_mode;
 
 	rval = QLA_SUCCESS;
-
-	if (ha->flags.init_done)
-		return (rval);
 
 	/* Determine NVRAM starting address. */
 	ha->nvram_base = 0;
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-09-06 12:07:36 -07:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-09-06 12:07:36 -07:00
@@ -418,12 +418,9 @@
 	cmd_pkt->lun = cpu_to_le16(fclun->lun);
 
 	/* Update tagged queuing modifier */
+	cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 	if (scsi_populate_tag_msg(cmd, tag)) {
 		switch (tag[0]) {
-		case MSG_SIMPLE_TAG:
-			cmd_pkt->control_flags =
-			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
-			break;
 		case MSG_HEAD_TAG:
 			cmd_pkt->control_flags =
 			    __constant_cpu_to_le16(CF_HEAD_TAG);
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 12:07:36 -07:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 12:07:36 -07:00
@@ -969,7 +969,7 @@
 		    sizeof(cp->sense_buffer))
 			sense_sz = le16_to_cpu(pkt->req_sense_length);
 		else
-			sense_sz = sizeof(cp->sense_buffer) - 1;
+			sense_sz = sizeof(cp->sense_buffer);
 
 		CMD_ACTUAL_SNSLEN(cp) = sense_sz;
 		sp->request_sense_length = sense_sz;
@@ -1039,7 +1039,7 @@
 			    sizeof(cp->sense_buffer))
 				sense_sz = le16_to_cpu(pkt->req_sense_length);
 			else
-				sense_sz = sizeof(cp->sense_buffer) - 1;
+				sense_sz = sizeof(cp->sense_buffer);
 
 			CMD_ACTUAL_SNSLEN(cp) = sense_sz;
 			sp->request_sense_length = sense_sz;
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:36 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:07:36 -07:00
@@ -1583,14 +1583,10 @@
 	if (rval == FAILED)
 		goto out;
 
-	/*
-	 * Blocking Call. It goes to sleep waiting for cmd to get to done q
-	 *
-	 * XXX(hch): really?  We're under host_lock here..
-	 */
 	/* Waiting for our command in done_queue to be returned to OS.*/
-	if (!qla2x00_eh_wait_for_pending_commands(ha))
-		rval = FAILED;
+	if (cmd->device->host->eh_active)
+		if (!qla2x00_eh_wait_for_pending_commands(ha))
+			rval = FAILED;
 
  out:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
@@ -1933,7 +1929,7 @@
 	if (host == NULL) {
 		printk(KERN_WARNING
 		    "qla2xxx: Couldn't allocate host from scsi layer!\n");
-		return -1;
+		goto probe_disable_device;
 	}
 
 	/* Clear our data area */
@@ -2157,6 +2153,9 @@
 
 	scsi_host_put(host);
 
+probe_disable_device:
+	pci_disable_device(pdev);
+
 	return -1;
 }
 EXPORT_SYMBOL_GPL(qla2x00_probe_one);
@@ -2225,6 +2224,8 @@
 	/* release io space registers  */
 	pci_release_regions(ha->pdev);
 
+	pci_disable_device(ha->pdev);
+
 #if MEMORY_MAPPED_IO
 	if (ha->mmio_address)
 		iounmap(ha->mmio_address);
@@ -3243,9 +3244,6 @@
 		if (ha->dpc_should_die)
 			break;
 
-		if (!list_empty(&ha->done_queue))
-			qla2x00_done(ha);
-
 		DEBUG3(printk("qla2x00: DPC handler waking up\n"));
 
 		/* Initialization not yet finished. Don't do anything yet. */
@@ -3255,6 +3253,9 @@
 		DEBUG3(printk("scsi(%ld): DPC handler\n", ha->host_no));
 
 		ha->dpc_active = 1;
+
+		if (!list_empty(&ha->done_queue))
+			qla2x00_done(ha);
 
 		/* Process commands in retry queue */
 		if (test_and_clear_bit(PORT_RESTART_NEEDED, &ha->dpc_flags)) {

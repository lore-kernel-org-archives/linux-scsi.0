From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/11]   qla2xxx: Small fixes
Date: Wed, 8 Dec 2004 23:36:38 -0800
Message-ID: <20041209073638.GA22095@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:4255 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261477AbULIHgo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:36:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2239 04/12/08 14:57:28 andrew.vasquez@qlogic.com +1 -0
  Small fixes:
  
     o Issue a big-hammer to recover if the driver is unable
       retrieve the host's loop-id.
     o Correct failure to not add an fc_lun_t object for lun
       0.
     o Interrogate only the relevant bits (peripheral
       qualifier and device-type) of INQUIRY data.
     o Correct issue where driver would incorrectly fail-out
       of initializing an ISP if an device-discovery SNS scan
       failed.
     o Correct issue where the qla2x00_fabric_login() would
       return an incorrect error status during mailbox
       command execution.  

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-12-08 22:14:27 -08:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-12-08 22:14:27 -08:00
@@ -1099,6 +1099,7 @@
 	if (rval != QLA_SUCCESS) {
 		qla_printk(KERN_WARNING, ha,
 		    "ERROR -- Unable to get host loop ID.\n");
+		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		return (rval);
 	}
 
@@ -1953,6 +1954,9 @@
 		return;
 	}
 
+	/* Always add a fc_lun_t structure for lun 0 -- mid-layer requirement */
+	qla2x00_add_lun(fcport, 0);
+
 	/* If report LUN works, exit. */
 	if (qla2x00_rpt_lun_discovery(ha, fcport, inq, inq_dma) !=
 	    QLA_SUCCESS) {
@@ -1998,9 +2002,6 @@
 	if (rval != QLA_SUCCESS)
 		return (rval);
 
-	/* Always add a fc_lun_t structure for lun 0 -- mid-layer requirement */
-	qla2x00_add_lun(fcport, 0);
-
 	/* Configure LUN list. */
 	len = be32_to_cpu(ha->rlc_rsp->list.hdr.len);
 	len /= 8;
@@ -2136,6 +2137,7 @@
     inq_cmd_rsp_t *inq, dma_addr_t inq_dma) 
 {
 	fc_lun_t *fclun;
+	uint8_t	  device_type;
 
 	/* Bypass LUNs that failed. */
 	if (qla2x00_inquiry(ha, fcport, lun, inq, inq_dma) != QLA_SUCCESS) {
@@ -2144,8 +2146,8 @@
 
 		return (NULL);
 	}
-
-	switch (inq->inq[0]) {
+	device_type = (inq->inq[0] & 0x1f);
+	switch (device_type) {
 	case TYPE_DISK:
 	case TYPE_PROCESSOR:
 	case TYPE_WORM:
@@ -2163,11 +2165,11 @@
 	default:
 		DEBUG2(printk("scsi(%ld): Unsupported lun type -- "
 		    "loop id=0x%04x lun=%d type=%x\n",
-		    ha->host_no, fcport->loop_id, lun, inq->inq[0]));
+		    ha->host_no, fcport->loop_id, lun, device_type));
 		return (NULL);
 	}
 
-	fcport->device_type = inq->inq[0];
+	fcport->device_type = device_type;
 	fclun = qla2x00_add_lun(fcport, lun);
 
 	if (fclun != NULL) {
@@ -2526,7 +2528,7 @@
 {
 	int		rval;
 	uint16_t	loop_id;
-	fc_port_t	*fcport, *new_fcport;
+	fc_port_t	*fcport, *new_fcport, *fcptemp;
 	int		found;
 
 	sw_info_t	*swl;
@@ -2600,6 +2602,15 @@
 			/* Send GA_NXT to the switch */
 			rval = qla2x00_ga_nxt(ha, new_fcport);
 			if (rval != QLA_SUCCESS) {
+				qla_printk(KERN_WARNING, ha,
+				    "SNS scan failed -- assuming zero-entry "
+				    "result...\n");
+				list_for_each_entry_safe(fcport, fcptemp,
+				    new_fcports, list) {
+					list_del(&fcport->list);
+					kfree(fcport);
+				}
+				rval = QLA_SUCCESS;
 				break;
 			}
 		}
@@ -3030,9 +3041,9 @@
 			 */
 			*next_loopid = fcport->loop_id;
 			qla2x00_fabric_logout(ha, fcport->loop_id);
-			fcport->loop_id = FC_NO_LOOP_ID;
+			qla2x00_mark_device_lost(ha, fcport, 1);
 
-			rval = 3;
+			rval = 1;
 			break;
 		} else {
 			/*
@@ -3049,7 +3060,7 @@
 			fcport->loop_id = FC_NO_LOOP_ID;
 			atomic_set(&fcport->state, FCS_DEVICE_DEAD);
 
-			rval = 1;
+			rval = 3;
 			break;
 		}
 	}

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [7/11]   qla2xxx: Code scrubbing
Date: Wed, 8 Dec 2004 23:38:39 -0800
Message-ID: <20041209073839.GA22130@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:48512 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S261469AbULIHin (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 02:38:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

ChangeSet
  1.2241 04/12/08 16:00:35 andrew.vasquez@qlogic.com +5 -0
  Misc. driver-code scrubbing:
  
     o Correct qla2300 module description.
     o Resync with latest firmware structure definitions.
     o White-space cleanup.
     o Add additional display of driver internals when debug
       is enabled.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/ql2300.c   |    2 +-
 drivers/scsi/qla2xxx/qla_def.h  |   17 +++++++++++------
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c  |    9 +++++----
 drivers/scsi/qla2xxx/qla_os.c   |   20 ++++++++++----------
 5 files changed, 28 insertions(+), 22 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/ql2300.c b/drivers/scsi/qla2xxx/ql2300.c
--- a/drivers/scsi/qla2xxx/ql2300.c	2004-12-08 22:15:37 -08:00
+++ b/drivers/scsi/qla2xxx/ql2300.c	2004-12-08 22:15:37 -08:00
@@ -98,6 +98,6 @@
 module_exit(qla2300_exit);
 
 MODULE_AUTHOR("QLogic Corporation");
-MODULE_DESCRIPTION("QLogic ISP2300 FC-SCSI Host Bus Adapter driver");
+MODULE_DESCRIPTION("QLogic ISP23xx FC-SCSI Host Bus Adapter driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(QLA2XXX_VERSION);
diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:15:37 -08:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-12-08 22:15:37 -08:00
@@ -1103,13 +1103,13 @@
 	uint8_t alternate_node_name[WWN_SIZE];
 
 	/*
-	 * BIT 0 = Boot Zoning
+	 * BIT 0 = Selective Login
 	 * BIT 1 = Alt-Boot Enable
-	 * BIT 2 = Report SCSI Path
-	 * BIT 3 = unused
-	 * BIT 4 = unused
-	 * BIT 5 = unused
-	 * BIT 6 = unused
+	 * BIT 2 =
+	 * BIT 3 = Boot Order List
+	 * BIT 4 =
+	 * BIT 5 = Selective LUN
+	 * BIT 6 =
 	 * BIT 7 = unused
 	 */
 	uint8_t efi_parameters;
@@ -1379,6 +1379,7 @@
 /*
  * Status entry status flags
  */
+#define SF_ABTS_TERMINATED	BIT_10
 #define SF_LOGOUT_SENT		BIT_13
 
 /*
@@ -1637,6 +1638,7 @@
     	spinlock_t q_lock;		/* Lun Lock */
 
 	unsigned long q_flag;
+#define LUN_MPIO_RESET_CNTS	1	/* Lun */
 #define LUN_MPIO_BUSY		2	/* Lun is changing paths  */
 #define LUN_EXEC_DELAYED	7	/* Lun execution is delayed */
 
@@ -1759,6 +1761,8 @@
 #define FCF_MSA_PORT_ACTIVE	BIT_20
 #define FCF_FAILBACK_DISABLE	BIT_21
 #define FCF_FAILOVER_DISABLE	BIT_22
+#define FCF_DSXXX_DEVICE	BIT_23
+#define FCF_AA_EVA_DEVICE	BIT_24
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -2126,6 +2130,7 @@
 #define FCPORT_RESCAN_NEEDED	21      /* IO descriptor processing needed */
 #define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
 #define IOCTL_ERROR_RECOVERY	23      
+#define LOOP_RESET_NEEDED	24
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-12-08 22:15:37 -08:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-12-08 22:15:37 -08:00
@@ -3596,7 +3596,7 @@
 			DEBUG2(printk("scsi(%ld): Alloc Lun %d @ tgt %d.\n",
 			    ha->host_no, lun, tgt));
 
-			memset(lq, 0, sizeof (os_lun_t));
+			memset(lq, 0, sizeof(os_lun_t));
 			LUN_Q(ha, tgt, lun) = lq;
 
 			/*
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-12-08 22:15:37 -08:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-12-08 22:15:37 -08:00
@@ -568,8 +568,8 @@
 			rscn_fcport = qla2x00_alloc_rscn_fcport(ha, GFP_ATOMIC);
 			if (rscn_fcport) {
 				DEBUG14(printk("scsi(%ld): Port Update -- "
-				    "creating RSCN fcport %p for login.\n",
-				    ha->host_no, rscn_fcport));
+				    "creating RSCN fcport %p for %x/%x.\n",
+				    ha->host_no, rscn_fcport, mb[1], mb[2]));
 
 				rscn_fcport->loop_id = mb[1];
 				rscn_fcport->d_id.b24 = INVALID_PORT_ID;
@@ -1204,8 +1204,9 @@
 
 	case CS_TIMEOUT:
 		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld:%d:%d:%d): TIMEOUT status detected 0x%x-0x%x.\n",
-		    ha->host_no, b, t, l, comp_status, scsi_status));
+		    "scsi(%ld:%d:%d:%d): TIMEOUT status detected 0x%x-0x%x "
+		    "sflags=%x.\n", ha->host_no, b, t, l, comp_status,
+		    scsi_status, le16_to_cpu(pkt->status_flags)));
 
 		cp->result = DID_BUS_BUSY << 16;
 
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:15:37 -08:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:15:37 -08:00
@@ -751,7 +751,7 @@
 	cmd->host_scribble = (unsigned char *)handle;
 
 	/* Bookkeeping information */
-	sp->r_start = jiffies;       /* time the request was received */
+	sp->r_start = jiffies;		/* Time the request was recieved. */
 	sp->u_start = 0;
 
 	/* Setup device queue pointers. */
@@ -832,6 +832,7 @@
 		spin_lock_irq(ha->host->host_lock);
 		return (0);
 	}
+
 	if (tq && test_bit(TQF_SUSPENDED, &tq->flags) &&
 	    (sp->flags & SRB_TAPE) == 0) {
 		/* If target suspended put incoming I/O in retry_q. */
@@ -3905,9 +3906,9 @@
 	if (sp->state == SRB_PENDING_STATE) {
 		__del_from_pending_queue(vis_ha, sp);
 		DEBUG2(printk("scsi(%ld): Found in Pending queue pid %ld, "
-		    "State = %x., fcport state=%d jiffies=%lx\n",
+		    "State = %x., fcport state=%d sjiffs=%lx njiffs=%lx\n",
 		    vis_ha->host_no, cmd->serial_number, sp->state,
-		    atomic_read(&fcport->state), jiffies));
+		    atomic_read(&fcport->state), sp->r_start, jiffies));
 
 		/*
 		 * If FC_DEVICE is marked as dead return the cmd with
@@ -4139,13 +4140,13 @@
 
 			default:
 				DEBUG2(printk("scsi(%ld:%d:%d) %s: did_error "
-				    "= %d, comp-scsi= 0x%x-0x%x.\n",
+				    "= %d, comp-scsi= 0x%x-0x%x pid=%ld.\n",
 				    vis_ha->host_no,
 				    cmd->device->id, cmd->device->lun,
 				    __func__,
 				    host_byte(cmd->result),
 				    CMD_COMPL_STATUS(cmd),
-				    CMD_SCSI_STATUS(cmd)));
+				    CMD_SCSI_STATUS(cmd), cmd->serial_number));
 				break;
 		}
 
@@ -4266,11 +4267,10 @@
 			test_bit(ABORT_ISP_ACTIVE, &dest_ha->dpc_flags) ||
 			atomic_read(&dest_ha->loop_state) != LOOP_READY)) {
 
-			DEBUG3(printk("scsi(%ld): port=(0x%x) retry_q(%d) "
-			    "loop state = %d, loop counter = 0x%x dpc flags "
-			    "= 0x%lx\n",
-			    dest_ha->host_no,
-			    fcport->loop_id,
+			DEBUG3(printk("scsi(%ld): pid=%ld port=0x%x state=%d "
+			    "loop state=%d, loop counter=0x%x "
+			    "dpc_flags=0x%lx\n", sp->cmd->serial_number,
+			    dest_ha->host_no, fcport->loop_id,
 			    atomic_read(&fcport->state),
 			    atomic_read(&dest_ha->loop_state),
 			    atomic_read(&dest_ha->loop_down_timer),

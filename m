From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [6/8]  qla2xxx: Small enhancements
Date: Mon, 6 Sep 2004 21:29:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907042904.GA29651@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:11659 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S267584AbUIGEaw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 00:30:52 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

ChangeSet
  1.1876 04/09/06 11:57:40 andrew.vasquez@qlogic.com +4 -0
  Misc. small enhancements:
  
          o Add 're-scan' and 'initiate lip' support via /proc
            similar to the 7.x series drivers.
          o Add module parameter ql2xprocessnotready, to selectively
            enable/disable the driver's internal NOT_READY check-
            condition handling.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h |    1 
 drivers/scsi/qla2xxx/qla_gbl.h |    1 
 drivers/scsi/qla2xxx/qla_isr.c |    6 +++++
 drivers/scsi/qla2xxx/qla_os.c  |   44 ++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 51 insertions(+), 1 deletion(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-09-06 12:08:09 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-09-06 12:08:09 -07:00
@@ -2105,6 +2105,7 @@
 #define FCPORT_RESCAN_NEEDED	21      /* IO descriptor processing needed */
 #define IODESC_PROCESS_NEEDED	22      /* IO descriptor processing needed */
 #define IOCTL_ERROR_RECOVERY	23      
+#define LOOP_RESET_NEEDED	24
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
diff -Nru a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h	2004-09-06 12:08:09 -07:00
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2004-09-06 12:08:09 -07:00
@@ -69,6 +69,7 @@
 extern int ql2xenablezio;
 extern int ql2xintrdelaytimer;
 extern int ql2xloginretrycount;
+extern int ql2xprocessnotready;
 
 extern int ConfigRequired;
 
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 12:08:09 -07:00
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2004-09-06 12:08:09 -07:00
@@ -1427,6 +1427,12 @@
 		break;
 
 	case NOT_READY:
+		if (!ql2xprocessnotready) {
+			DEBUG2(printk("%s : Disabled NOT_READY handling...\n",
+			    __func__));		
+			break;
+		}
+
 		fcport = lq->fclun->fcport;
 
 		/*
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:08:09 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-09-06 12:08:09 -07:00
@@ -129,6 +129,13 @@
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
+int ql2xprocessnotready = 1;
+module_param(ql2xprocessnotready, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xprocessnotready,
+		"Option to disable handling of NOT-READY in the driver."
+		" Default is 1 - Handled by the driver."
+		" Set to 0 - Disable the handling inside the driver");
+
 /*
  * Proc structures and functions
  */
@@ -431,7 +438,31 @@
 int
 qla2x00_set_info(char *buffer, int length, struct Scsi_Host *shost)
 {
-	return (-ENOSYS);  /* Currently this is a no-op */
+	scsi_qla_host_t *ha;
+	fc_port_t *fcport;
+
+	if (length < 12 || strncmp("scsi-qla", buffer, 8))
+		goto out;
+
+	ha = (scsi_qla_host_t *) shost->hostdata;
+
+	if (!strncmp("scan", buffer + 8, 4)) {
+		qla_printk(KERN_INFO, ha,
+		    "Scheduling rescan for new luns...\n");
+
+		list_for_each_entry(fcport, &ha->fcports, list)
+			if (fcport->port_type == FCT_TARGET)
+				fcport->flags |= FCF_RESCAN_NEEDED;
+
+		set_bit(FCPORT_RESCAN_NEEDED, &ha->dpc_flags);
+	} else if (!strncmp("lip", buffer + 8, 3)) {
+		qla_printk(KERN_INFO, ha, "Scheduling LIP...\n");
+
+		set_bit(LOOP_RESET_NEEDED, &ha->dpc_flags);
+	}
+
+out:
+	return (length);
 }
 
 /* -------------------------------------------------------------------------- */
@@ -3415,6 +3446,14 @@
 			    ha->host_no));
 		}
 
+		if (test_and_clear_bit(LOOP_RESET_NEEDED, &ha->dpc_flags)) {
+
+			DEBUG(printk("scsi(%ld): dpc: sched loop_reset()\n",
+			    ha->host_no));
+
+			qla2x00_loop_reset(ha);
+		}
+
 		if (test_and_clear_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &ha->dpc_flags)))) {
 
@@ -3847,6 +3886,9 @@
 	    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) ||
 	    start_dpc ||
 	    test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags) ||
+	    test_bit(RESET_MARKER_NEEDED, &ha->dpc_flags) ||
+	    test_bit(FCPORT_RESCAN_NEEDED, &ha->dpc_flags) ||
+	    test_bit(LOOP_RESET_NEEDED, &ha->dpc_flags) ||
 	    test_bit(RELOGIN_NEEDED, &ha->dpc_flags)) &&
 	    ha->dpc_wait && !ha->dpc_active) {
 

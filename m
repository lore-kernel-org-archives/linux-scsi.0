From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [12/15] qla2xxx: Restore update state during resync
Date: Sun, 14 Mar 2004 00:25:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082555.GA3465@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:63900 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263325AbUCNIX0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:23:26 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1668 04/03/02 07:13:34 andrew.vasquez@apc.qlogic.com +2 -0
  Restore the UPDATE state of the HA if a resync event occurs during
  a device (re)discovery.  

 drivers/scsi/qla2xxx/qla_init.c |   25 ++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |    1 +
 2 files changed, 25 insertions(+), 1 deletion(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/21_restore_update_state.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:09:24 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Fri Mar 12 17:09:24 2004
@@ -1497,7 +1497,7 @@
 {
 	int  rval;
 	uint8_t  rval1 = 0;
-	static unsigned long  flags, save_flags;
+	unsigned long flags, save_flags;
 
 	rval = QLA_SUCCESS;
 
@@ -1597,6 +1597,14 @@
 		DEBUG3(printk("%s: exiting normally\n", __func__));
 	}
 
+	/* Restore state if a resync event occured during processing */
+	if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+		if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
+			set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+		if (test_bit(RSCN_UPDATE, &save_flags))
+			set_bit(RSCN_UPDATE, &ha->dpc_flags);
+	}
+
 	return (rval);
 }
 
@@ -1805,6 +1813,20 @@
 	return (rval);
 }
 
+static void
+qla2x00_probe_for_all_luns(scsi_qla_host_t *ha) 
+{
+	fc_port_t	*fcport;
+
+	qla2x00_mark_all_devices_lost(ha); 
+ 	list_for_each_entry(fcport, &ha->fcports, list) {
+		if (fcport->port_type != FCT_TARGET)
+			continue;
+
+		qla2x00_update_fcport(ha, fcport); 
+	}
+}
+
 /*
  * qla2x00_update_fcport
  *	Updates device on list.
@@ -3194,6 +3216,7 @@
 
 		rescan_done = 1;
 	}
+	qla2x00_probe_for_all_luns(ha); 
 
 	/* Update OS target and lun structures if necessary. */
 	if (rescan_done) {
diff -Nru a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
--- a/drivers/scsi/qla2xxx/qla_isr.c	Fri Mar 12 17:09:24 2004
+++ b/drivers/scsi/qla2xxx/qla_isr.c	Fri Mar 12 17:09:24 2004
@@ -452,6 +452,7 @@
 		if (atomic_read(&ha->loop_state) != LOOP_DOWN) {
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
+			ha->device_flags |= DFLG_NO_CABLE;
 			qla2x00_mark_all_devices_lost(ha);
 		}
 

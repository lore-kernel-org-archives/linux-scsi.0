From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/15]  qla2xxx: Debug messages during ISP abort
Date: Thu, 6 May 2004 22:52:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055230.GA4908@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:37366 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263174AbUEGFuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:50:46 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1926 04/04/30 11:07:02 andrew.vasquez@apc.qlogic.com +3 -0
  Issue a kernel warning message before initiating an ISP abort (big
  hammer) -- additional debugging mechanism in case of event.

 drivers/scsi/qla2xxx/qla_mbx.c  |    9 +++++++++
 drivers/scsi/qla2xxx/qla_os.c   |    2 ++
 drivers/scsi/qla2xxx/qla_rscn.c |    2 ++
 3 files changed, 13 insertions(+)

diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	Mon May  3 15:14:05 2004
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	Mon May  3 15:14:05 2004
@@ -279,6 +279,9 @@
 			DEBUG2_3_11(printk("qla2x00_mailbox_command(%ld): "
 			    "timeout schedule isp_abort_needed.\n",
 			    ha->host_no);)
+			qla_printk(KERN_WARNING, ha,
+			    "Mailbox command timeout occured. Scheduling ISP "
+			    "abort.\n");
 			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			if (ha->dpc_wait && !ha->dpc_active) 
 				up(ha->dpc_wait);
@@ -290,6 +293,9 @@
 			    "calling abort_isp\n", ha->host_no);)
 			DEBUG2_3_11(printk("qla2x00_mailbox_command(%ld): "
 			    "timeout calling abort_isp\n", ha->host_no);)
+			qla_printk(KERN_WARNING, ha,
+			    "Mailbox command timeout occured. Issuing ISP "
+			    "abort.\n");
 
 			set_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags);
 			clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
@@ -1062,6 +1068,9 @@
 	qla2x00_marker(ha, loop_id, lun, MK_SYNC_ID_LUN);
 
 	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed Abort Device Mailbox command. Scheduling ISP "
+		    "abort.\n");
 		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 		if (ha->dpc_wait && !ha->dpc_active) 
 			up(ha->dpc_wait);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:14:05 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:14:05 2004
@@ -3856,6 +3856,8 @@
 				DEBUG(printk("scsi(%ld): Loop down - "
 				    "aborting ISP.\n",
 				    ha->host_no));
+				qla_printk(KERN_WARNING, ha,
+				    "Loop down - aborting ISP.\n");
 
 				set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
 			}
diff -Nru a/drivers/scsi/qla2xxx/qla_rscn.c b/drivers/scsi/qla2xxx/qla_rscn.c
--- a/drivers/scsi/qla2xxx/qla_rscn.c	Mon May  3 15:14:05 2004
+++ b/drivers/scsi/qla2xxx/qla_rscn.c	Mon May  3 15:14:05 2004
@@ -283,6 +283,8 @@
 
 	qla2x00_free_iodesc(iodesc);
 
+	qla_printk(KERN_WARNING, iodesc->ha,
+	    "IO descriptor timeout. Scheduling ISP abort.\n");
 	set_bit(ISP_ABORT_NEEDED, &iodesc->ha->dpc_flags);
 }
 

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [13/15] qla2xxx: Misc. code scrubbing
Date: Thu, 6 May 2004 22:58:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507055830.GA5007@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:35979 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263205AbUEGF4y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 01:56:54 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1934 04/04/30 15:31:33 andrew.vasquez@apc.qlogic.com +3 -0
  Misc. driver scrubbing:
  
  	o Use kernel #define for PCI command register bit.
  
  	o Fix rate-limiting check the queue-depth module
  	  parameter.
  
  	o Clean-up comments.

 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    1 -
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:16:34 2004
+++ b/drivers/scsi/qla2xxx/qla_init.c	Mon May  3 15:16:34 2004
@@ -285,7 +285,7 @@
 		/* PCI Specification Revision 2.3 changes */
 		if (IS_QLA2322(ha) || IS_QLA6322(ha))
 			/* Command Register - Reset Interrupt Disable. */
-			w &= ~BIT_10;
+			w &= ~PCI_COMMAND_INTX_DISABLE;
 
 		/*
 		 * If this is a 2300 card and not 2312, reset the
diff -Nru a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c	Mon May  3 15:16:34 2004
+++ b/drivers/scsi/qla2xxx/qla_mbx.c	Mon May  3 15:16:34 2004
@@ -987,7 +987,6 @@
 
 	if (atomic_read(&ha->loop_state) == LOOP_DOWN ||
 	    atomic_read(&fcport->state) == FCS_DEVICE_LOST) {
-		/* v2.19.8 Ignore abort request if port is down */
 		return 1;
 	}
 
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:16:34 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon May  3 15:16:34 2004
@@ -810,7 +810,7 @@
 	    atomic_read(&ha2->loop_state) == LOOP_DEAD) {
 		/*
 		 * Add the command to the done-queue for later failover
-		 * processing
+		 * processing.
 		 */
 		cmd->result = DID_NO_CONNECT << 16;
 		if (atomic_read(&ha2->loop_state) == LOOP_DOWN) 
@@ -1786,10 +1786,9 @@
 		queue_depth = 32;
 
 	if (sdev->tagged_supported) {
-#if defined(MODULE)
-		if (!(ql2xmaxqdepth == 0 || ql2xmaxqdepth > 256))
+		if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
 			queue_depth = ql2xmaxqdepth;
-#endif 
+
 		ql2xmaxqdepth = queue_depth;
 
 		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);

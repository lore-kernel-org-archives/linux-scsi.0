From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [8/15] qla2xxx:  Use proper HA references
Date: Sun, 14 Mar 2004 00:25:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040314082515.GA3437@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:15285 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S263320AbUCNIWp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 03:22:45 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

ChangeSet
  1.1664 04/03/01 14:26:47 andrew.vasquez@apc.qlogic.com +1 -0
  Fix issue where the driver would reference the incorrect HA
  during loop state check.
  
  Note: This could only occur during failover mode.

 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.00.00b11k/17_fix_ha_reference.patch

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:08:15 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Fri Mar 12 17:08:15 2004
@@ -795,7 +795,7 @@
 	 *	Either PORT_DOWN_TIMER OR LINK_DOWN_TIMER Expired.
 	 */
 	if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-	    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+	    atomic_read(&ha2->loop_state) == LOOP_DEAD) {
 		/*
 		 * Add the command to the done-queue for later failover
 		 * processing
@@ -3209,7 +3209,7 @@
 
 				if (atomic_read(&fcport->state) ==
 				    FCS_DEVICE_DEAD ||
-				    atomic_read(&ha->loop_state) == LOOP_DEAD) {
+				    atomic_read(&fcport->ha->loop_state) == LOOP_DEAD) {
 
 					__del_from_retry_queue(ha, sp);
 					sp->cmd->result = DID_NO_CONNECT << 16;
@@ -3900,7 +3900,7 @@
 		 * DID_BUS_BUSY to let the OS  retry this cmd.
 		 */
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
-		    atomic_read(&vis_ha->loop_state) == LOOP_DEAD) {
+		    atomic_read(&fcport->ha->loop_state) == LOOP_DEAD) {
 			cmd->result = DID_NO_CONNECT << 16;
 			if (atomic_read(&fcport->ha->loop_state) == LOOP_DOWN) 
 				sp->err_id = SRB_ERR_LOOP;

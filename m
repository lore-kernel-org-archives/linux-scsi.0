From: akpm@osdl.org
Subject: [patch 24/28] scsi: seagate Scsi_Cmnd conversion
Date: Mon, 25 Sep 2006 16:59:10 -0700
Message-ID: <200609252359.k8PNxA5l003535@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:44987 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751772AbWIYX7R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, henne@nachtwindheim.de

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Changes the obsolete typedef'd Scsi_Cmnd to struct scsi_cmnd.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/seagate.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/seagate.c~scsi-seagate-scsi_cmnd-conversion drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c~scsi-seagate-scsi_cmnd-conversion
+++ a/drivers/scsi/seagate.c
@@ -321,7 +321,7 @@ static Signature __initdata signatures[]
 static int hostno = -1;
 static void seagate_reconnect_intr (int, void *, struct pt_regs *);
 static irqreturn_t do_seagate_reconnect_intr (int, void *, struct pt_regs *);
-static int seagate_st0x_bus_reset(Scsi_Cmnd *);
+static int seagate_st0x_bus_reset(struct scsi_cmnd *);
 
 #ifdef FAST
 static int fast = 1;
@@ -585,8 +585,8 @@ static int linked_connected = 0;
 static unsigned char linked_target, linked_lun;
 #endif
 
-static void (*done_fn) (Scsi_Cmnd *) = NULL;
-static Scsi_Cmnd *SCint = NULL;
+static void (*done_fn) (struct scsi_cmnd *) = NULL;
+static struct scsi_cmnd *SCint = NULL;
 
 /*
  * These control whether or not disconnect / reconnect will be attempted,
@@ -633,7 +633,7 @@ static irqreturn_t do_seagate_reconnect_
 static void seagate_reconnect_intr (int irq, void *dev_id, struct pt_regs *regs)
 {
 	int temp;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 
 	DPRINTK (PHASE_RESELECT, "scsi%d : seagate_reconnect_intr() called\n", hostno);
 
@@ -675,10 +675,11 @@ static void seagate_reconnect_intr (int 
 
 static int recursion_depth = 0;
 
-static int seagate_st0x_queue_command (Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int seagate_st0x_queue_command(struct scsi_cmnd * SCpnt,
+				      void (*done) (struct scsi_cmnd *))
 {
 	int result, reconnect;
-	Scsi_Cmnd *SCtmp;
+	struct scsi_cmnd *SCtmp;
 
 	DANY ("seagate: que_command");
 	done_fn = done;
@@ -1609,7 +1610,7 @@ connect_loop:
 	return retcode (st0x_aborted);
 }				/* end of internal_command */
 
-static int seagate_st0x_abort (Scsi_Cmnd * SCpnt)
+static int seagate_st0x_abort(struct scsi_cmnd * SCpnt)
 {
 	st0x_aborted = DID_ABORT;
 	return SUCCESS;
@@ -1624,7 +1625,7 @@ static int seagate_st0x_abort (Scsi_Cmnd
  * May be called with SCpnt = NULL
  */
 
-static int seagate_st0x_bus_reset(Scsi_Cmnd * SCpnt)
+static int seagate_st0x_bus_reset(struct scsi_cmnd * SCpnt)
 {
 	/* No timeouts - this command is going to fail because it was reset. */
 	DANY ("scsi%d: Reseting bus... ", hostno);
_

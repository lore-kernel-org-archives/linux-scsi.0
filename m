From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.18-rc6-mm1] ieee1394: sbp2: slightly reorder sbp2scsi_abort
Date: Mon, 11 Sep 2006 20:17:14 +0200 (CEST)
Message-ID: <tkrat.0508329ebccd5c6f@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Put the target's fetch agent into reset state before the underlying ORB
DMA is unmapped and the ->done handler is called.  It is highly unlikely
but the target could access that ORB right before sbp2 sends the reset
request.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c	2006-09-08 20:07:44.000000000 +0200
+++ linux/drivers/ieee1394/sbp2.c	2006-09-11 20:00:24.000000000 +0200
@@ -2560,11 +2560,9 @@ static int sbp2scsi_abort(struct scsi_cm
 	scsi_print_command(SCpnt);
 
 	if (sbp2util_node_is_available(scsi_id)) {
+		sbp2_agent_reset(scsi_id, 1);
 
-		/*
-		 * Right now, just return any matching command structures
-		 * to the free pool.
-		 */
+		/* Return a matching command structure to the free pool. */
 		spin_lock_irqsave(&scsi_id->sbp2_command_orb_lock, flags);
 		command = sbp2util_find_command_for_SCpnt(scsi_id, SCpnt);
 		if (command) {
@@ -2585,10 +2583,6 @@ static int sbp2scsi_abort(struct scsi_cm
 		}
 		spin_unlock_irqrestore(&scsi_id->sbp2_command_orb_lock, flags);
 
-		/*
-		 * Initiate a fetch agent reset.
-		 */
-		sbp2_agent_reset(scsi_id, 1);
 		sbp2scsi_complete_all_commands(scsi_id, DID_BUS_BUSY);
 	}
 



-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642

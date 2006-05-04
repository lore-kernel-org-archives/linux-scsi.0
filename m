From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] scsi_wq (fc transport) thread hang
Date: Thu, 04 May 2006 11:18:51 -0500
Message-ID: <445A296B.3060501@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050208030705000406080508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:10196 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932346AbWEDQU5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2006 12:20:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Michael Reed <mdr@sgi.com>, Gary Hagensen <gwh@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, James.Smart@Emulex.Com

This is a multi-part message in MIME format.
--------------050208030705000406080508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I was testing changes to the LSI fc driver and managed to wedge the
fc transport's scsi_wq thread.  Here's what caused it.

reset board via lsiutil command

	(While I may not be 100% correct in the actual sequence
	of resetting the board, I'd say I'm close enough to
	accurately describe the problem.)

	reset function 0
		fc_remote_port_delete() of all ports on
		both functions (board just works that way)

	board sends rescan event after reset completes
	which causes
		fc_remote_port_add() / fc_remote_port_rolechg()
		of all targets on both functions

	reset function 1
		fc_remote_port_delete() of all ports on
		both functions

		a scan was in progress for the recently added
		rports.  the delete blocks the target(s).
		One of the scans was issuing scsi commands
		at the time of the block.

	board sends rescan event after reset completes
	for second function which causes
		fc_remote_port_add() / fc_remote_port_rolechg()
		of all targets on both functions, again.

		rolechg again queues the scan work for the
		target which was blocked while a scan was in
		progress.

		scsi_target_unblock() is part of the
		scan work and hence isn't called.

		nothing unblocks the target so the scan hangs.

After turning on debug output and adding a strategically placed
printk, this output shows that an rport is being deleted while
a scan is in progress/scheduled.  As there is nothing which will
unblock the target which has scan work in progress once the resets
complete, the scan (and the thread) hang.

I've attached a patch which corrects the in my test config.  This
patch has been previously forwarded to James Smart, but as he's been
unable to respond (my patience is sometimes lacking) I decided to
post to linux-scsi to make others aware of the problem.  (I know,
I should have done this in parallel with the email to James....)


May  3 13:17:45 duck kernel: mptbase: ioc3: Sending Config request type 5, page 1 and action 0
May  3 13:17:45 duck kernel: mptbase: ioc3: config_complete (mf=e00000b005e1ac00,mr=e00000b005e00050)
May  3 13:17:45 duck kernel:   IOCStatus=0000h, IOCLogInfo=00000000h
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd9, 20000011c61e3afb / 21000011c61e3afb, tid 1, rport tid 1, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad9, 20000011c61e3af8 / 21000011c61e3af8, tid 3, rport tid 3, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd6, 20000011c61e3adb / 21000011c61e3adb, tid 5, rport tid 5, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ace, 20000011c61e3ad9 / 21000011c61e3ad9, tid 7, rport tid 7, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad5, 20000011c61e3ad5 / 21000011c61e3ad5, tid 9, rport tid 9, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd5, 20000011c61e3a2d / 21000011c61e3a2d, tid 11, rport tid 11, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad4, 20000011c61e39f9 / 21000011c61e39f9, tid 13, rport tid 13, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad1, 20000011c61e39d1 / 21000011c61e39d1, tid 15, rport tid 15, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd3, 20000011c61e1a41 / 21000011c61e1a41, tid 17, rport tid 17, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad2, 20000011c61dec10 / 21000011c61dec10, tid 19, rport tid 19, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd1, 20000011c61de9fa / 21000011c61de9fa, tid 21, rport tid 21, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd4, 20000011c61de980 / 21000011c61de980, tid 23, rport tid 23, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad3, 20000011c61de970 / 21000011c61de970, tid 25, rport tid 25, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_qcmd.4: 1:0, mptscsih_qcmd returns non-zero, (1055).
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bce, 20000011c61dd86c / 21000011c61dd86c, tid 27, rport tid 27, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130bd2, 20000011c61dd851 / 21000011c61dd851, tid 29, rport tid 29, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130ad6, 20000011c61dd831 / 21000011c61dd831, tid 31, rport tid 31, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130c00, 200700a0b81130aa / 204700a0b81130aa, tid 32, rport tid 32, tmo 60
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_reg_dev.4: 130d00, 200700a0b81130aa / 202700a0b81130aa, tid 34, rport tid 34, tmo 60
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd9 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e3afb deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad9 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e3af8 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd6 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e3adb deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ace with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e3ad9 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad5 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e3ad5 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd5 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e3a2d deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad4 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e39f9 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad1 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e39d1 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd3 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61e1a41 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad2 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61dec10 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd1 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61de9fa deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd4 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61de980 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad3 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61de970 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bce with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61dd86c deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130bd2 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61dd851 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130ad6 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 21000011c61dd831 deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130c00 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 204700a0b81130aa deleted
May  3 13:17:45 duck kernel: fc_remote_port_delete.4: blocking rport 130d00 with scan pending
May  3 13:17:45 duck kernel: mptfc: ioc2: mptfc_setup_reset.4: 202700a0b81130aa deleted
May  3 13:17:45 duck kernel: mptbase: ioc3: Sending Config request type 5, page 1 and action 1
May  3 13:17:45 duck kernel: mptbase: ioc3: config_complete (mf=e00000b005e1ae80,mr=e00000b005e000a0)
May  3 13:17:45 duck kernel:   IOCStatus=0000h, IOCLogInfo=00000000h
May  3 13:17:45 duck kernel: mptbase: ioc3: Sending Config request type 5, page 1 and action 0
May  3 13:17:45 duck kernel: mptbase: ioc3: config_complete (mf=e00000b005e1af80,mr=e00000b005e000f0)
May  3 13:17:45 duck kernel:   IOCStatus=0000h, IOCLogInfo=00000000h
May  3 13:17:45 duck kernel: mptbase: ioc3: Sending Config request type 5, page 1 and action 2
May  3 13:17:45 duck kernel: mptbase: ioc3: config_complete (mf=e00000b005e1b080,mr=e00000b005e00140)
May  3 13:17:45 duck kernel:   IOCStatus=0000h, IOCLogInfo=00000000h


Mike

		


--------------050208030705000406080508
Content-Type: text/x-patch;
 name="fc_transport_unblock_scan_work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fc_transport_unblock_scan_work.patch"

It is possible for a transport initiated scan of a target to be in progress
with scsi commands outstanding when the lldd calls the transport to (again)
delete the device via fc_remote_port_delete().  The transport will then (again)
block the target.  When the lldd later calls fc_remote_port_add() for the
blocked target, the scan work is requeued but nothing unblocks the target
so that the active can complete.  (The unblock is integrated within the
scan work.)

This patch tests the pending flag and will either unblock the target if a
scan is already in progress or will initiate a scan which will unblock
the target when the work executes.

Signed-off-by: Michale Reed <mdr@sgi.com>



--- rc3u/drivers/scsi/scsi_transport_fc.c	2006-04-27 12:32:06.000000000 -0500
+++ rc3/drivers/scsi/scsi_transport_fc.c	2006-05-04 10:35:51.276537641 -0500
@@ -1625,6 +1625,7 @@
 	struct fc_rport *rport;
 	unsigned long flags;
 	int match = 0;
+	int unblock = 0;
 
 	/* ensure any stgt delete functions are done */
 	fc_flush_work(shost);
@@ -1702,10 +1703,15 @@
 				rport->flags &= ~FC_RPORT_DEVLOSS_PENDING;
 
 				/* initiate a scan of the target */
-				rport->flags |= FC_RPORT_SCAN_PENDING;
-				scsi_queue_work(shost, &rport->scan_work);
-
+				if (rport->flags & FC_RPORT_SCAN_PENDING)
+					unblock = 1;
+				else {
+					rport->flags |= FC_RPORT_SCAN_PENDING;
+					scsi_queue_work(shost, &rport->scan_work);
+				}
 				spin_unlock_irqrestore(shost->host_lock, flags);
+				if (unblock)
+					scsi_target_unblock(&rport->dev);
 
 				return rport;
 			}
@@ -1760,11 +1766,17 @@
 
 			if (rport->roles & FC_RPORT_ROLE_FCP_TARGET) {
 				/* initiate a scan of the target */
-				rport->flags |= FC_RPORT_SCAN_PENDING;
-				scsi_queue_work(shost, &rport->scan_work);
+				if (rport->flags & FC_RPORT_SCAN_PENDING)
+					unblock = 1;
+				else {
+					rport->flags |= FC_RPORT_SCAN_PENDING;
+					scsi_queue_work(shost, &rport->scan_work);
+				}
 			}
 
 			spin_unlock_irqrestore(shost->host_lock, flags);
+			if (unblock)
+				scsi_target_unblock(&rport->dev);
 
 			return rport;
 		}
@@ -1859,7 +1871,6 @@
 	rport->port_state = FC_PORTSTATE_BLOCKED;
 
 	rport->flags |= FC_RPORT_DEVLOSS_PENDING;
-
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	scsi_target_block(&rport->dev);
@@ -1896,6 +1907,7 @@
 	struct fc_host_attrs *fc_host = shost_to_fc_host(shost);
 	unsigned long flags;
 	int create = 0;
+	int unblock = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (roles & FC_RPORT_ROLE_FCP_TARGET) {
@@ -1935,9 +1947,15 @@
 
 		/* initiate a scan of the target */
 		spin_lock_irqsave(shost->host_lock, flags);
-		rport->flags |= FC_RPORT_SCAN_PENDING;
-		scsi_queue_work(shost, &rport->scan_work);
+		if (rport->flags & FC_RPORT_SCAN_PENDING)
+			unblock = 1;
+		else {
+			rport->flags |= FC_RPORT_SCAN_PENDING;
+			scsi_queue_work(shost, &rport->scan_work);
+		}
 		spin_unlock_irqrestore(shost->host_lock, flags);
+		if (unblock)
+			scsi_target_unblock(&rport->dev);
 	}
 }
 EXPORT_SYMBOL(fc_remote_port_rolechg);

--------------050208030705000406080508--

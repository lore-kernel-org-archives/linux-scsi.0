From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 09:46:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209241346.g8ODkER09516@localhost.localdomain>
References: <rmk@arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-8913126120"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA25494
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2002 06:46:31 -0700
In-Reply-To: Message from Russell King <rmk@arm.linux.org.uk>
   of "Tue, 24 Sep 2002 12:35:08 BST." <20020924123508.A24521@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

This is a multipart MIME message.

--==_Exmh_-8913126120
Content-Type: text/plain; charset=us-ascii

rmk@arm.linux.org.uk said:
> I'm getting the impression that the door lock handling code is
> misplaced, and is probably the cause of these problems.  I'm going to
> try disabling that code, and reverting my previous change to
> scsi_restart_operations(). 

Unfortunately, if we want to ensure the medium is locked in place, the lock 
has to occur that low down (since error recovery can unlock the door and a 
retry doesn't currently trouble the upper layers).

I think it's method of operation is misplaced.  What it should probably be 
doing is simply adding a doorlock to the head of the queue and then go back 
around.  Since we know the doorlock now preceeds the command that instigated 
the issue the door should be locked before anything else happens.  It should 
simply loop around and process the door lock request so it doesn't have to 
wait for anything else to occur (any commands which come down in the interim 
should go on the queue tail).

However, for your case does simply moving the queue empty check to the top 
cause the problems to go away? (That would be hiding the problem not fixing 
it, but still...)

James


--==_Exmh_-8913126120
Content-Type: text/plain ; name="tmp.diffs"; charset=us-ascii
Content-Description: tmp.diffs
Content-Disposition: attachment; filename="tmp.diffs"

===== scsi_lib.c 1.15 vs edited =====
--- 1.15/drivers/scsi/scsi_lib.c	Tue Aug 13 09:35:17 2002
+++ edited/scsi_lib.c	Tue Sep 24 09:45:16 2002
@@ -868,6 +868,15 @@
 		if (SDpnt->device_blocked) {
 			break;
 		}
+
+		/*
+		 * If we couldn't find a request that could be queued, then we
+		 * can also quit.
+		 */
+
+		if (list_empty(&q->queue_head))
+			break;
+
 		if ((SHpnt->can_queue > 0 && (SHpnt->host_busy >= SHpnt->can_queue))
 		    || (SHpnt->host_blocked) 
 		    || (SHpnt->host_self_blocked)) {
@@ -914,13 +923,6 @@
 				continue;
 			}
 		}
-
-		/*
-		 * If we couldn't find a request that could be queued, then we
-		 * can also quit.
-		 */
-		if (list_empty(&q->queue_head))
-			break;
 
 		/*
 		 * Loop through all of the requests in this queue, and find

--==_Exmh_-8913126120--



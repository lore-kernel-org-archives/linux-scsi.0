From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 12:08:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020924190809.GB1330@beaverton.ibm.com>
References: <rmk@arm.linux.org.uk> <200209241346.g8ODkER09516@localhost.localdomain> <20020924145852.A28042@flint.arm.linux.org.uk> <20020924111847.A4151@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020924111847.A4151@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Russell King <rmk@arm.linux.org.uk>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield [patmans@us.ibm.com] wrote:
> The problem is that we try to send a command via scsi_request_fn() to
> a device that has no command blocks allocated - it's initializatin
> is incomplete.
> 
> Moving the empty check up sounds like good and simple fix for 2.4, or
> check if queue_depth == 0. Anything else would be difficult to get right.

Since error handling running during scan is kinda casuing the problem a
a patch like the one below to  scsi_restart_operations sould also work. 

-andmike
--
Michael Anderson
andmike@us.ibm.com

--- linux-2.4/drivers/scsi/scsi_error.c	Thu Sep 19 09:08:50 2002
+++ linux-2.4-test/drivers/scsi/scsi_error.c	Tue Sep 24 12:03:03 2002
@@ -1264,8 +1264,10 @@
 		    || (SDpnt->device_blocked)) {
 			break;
 		}
-		q = &SDpnt->request_queue;
-		q->request_fn(q);
+		if (SDpnt->has_cmdblocks) {
+			q = &SDpnt->request_queue;
+			q->request_fn(q);
+		}
 	}
 	spin_unlock_irqrestore(&io_request_lock, flags);
 }


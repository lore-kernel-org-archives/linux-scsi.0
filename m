From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [RFC PATCH] consolidate SCSI-2 command lun setting
Date: Tue, 15 Oct 2002 13:29:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210152029.g9FKTxD03950@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id NAA09414
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 13:30:02 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id NAA09325
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 13:30:00 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g9FKTxD03950
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 13:29:59 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Tue, 15 Oct 2002 09:55:02 PDT." <20021015095502.A25647@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This all looks OK, except here:

+++ b/drivers/scsi/scsi_lib.c	Tue Oct 15 09:46:06 2002
@@ -972,6 +972,14 @@
 				continue;
 			}
 		}
+		/* 
+		 * If SCSI-2 or lower, store the LUN value in cmnd.
+		 */
+		if (SDpnt->scsi_level <= SCSI_2)
+			SCpnt->cmnd[1] = (SCpnt->cmnd[1] & 0x1f) |
+				(SCpnt->lun << 5 & 0xe0);
+
+
 		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.

Shouldn't this code go early in scsi_dispatch_io instead? (with something 
similar in scsi_send_eh_cmnd)

James



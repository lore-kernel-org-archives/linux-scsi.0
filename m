From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_reset_provider() in scsi_error.c lk2.5.52
Date: Tue, 24 Dec 2002 10:34:10 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E079D72.1010909@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030106080700000608010103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-32.triode.net.au [202.147.125.32])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gBNNW8i18806
	for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2002 10:32:09 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030106080700000608010103
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

While testing Willem's last ide-scsi "rev1" patch
with sg_reset I found that scsi_reset_provider()
attempts to delete a timer that has not been set.

A crude patch is attached that stops the kernel noise.
Hopefully James can improve on it.

Doug Gilbert

--------------030106080700000608010103
Content-Type: text/plain;
 name="scsi_error_2552_reset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_error_2552_reset.diff"

--- linux/drivers/scsi/scsi_error.c	2002-12-22 16:19:53.000000000 +1100
+++ linux/drivers/scsi/scsi_error.c2552res	2002-12-24 10:16:32.000000000 +1100
@@ -1811,6 +1811,10 @@
 	 */
 	SCpnt->pid			= 0;
 
+	/* Code expects a timer to be set, so set one for 120 seconds */
+	init_timer(&SCpnt->eh_timeout);
+	scsi_add_timer(SCpnt, 120 * HZ, scsi_eh_times_out);
+
 	rtn = scsi_new_reset(SCpnt, flag);
 
 	scsi_delete_timer(SCpnt);

--------------030106080700000608010103--


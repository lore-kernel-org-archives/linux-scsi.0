From: James Bottomley <James.Bottomley@steeleye.com>
Subject: scsi_mid_low_api.txt update to clarify queuecommand return values
Date: 01 Feb 2004 10:46:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075650384.1817.9.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:42144 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265336AbUBAPq1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 10:46:27 -0500
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The only documentation about the MLQUEUE returns is in the code, it
should also be in here.  I'll add this if no-one objects.

James

===== scsi_mid_low_api.txt 1.15 vs edited =====
--- 1.15/Documentation/scsi/scsi_mid_low_api.txt	Fri Sep 26 20:07:12 2003
+++ edited/scsi_mid_low_api.txt	Sun Feb  1 10:45:23 2004
@@ -1091,14 +1091,44 @@
  *      @scp: pointer to scsi command object
  *      @done: function pointer to be invoked on completion
  *
- *      Returns 0 on success and 1 if the LLD or the HBA is busy (i.e. run
- *      out of resources to queue further commands). Other types of errors
- *      that are detected immediately are flagged by setting scp->result 
- *      to an appropriate value, invoking the 'done' callback, and then
- *      returning 0 from this function. If the command is not performed
- *      immediately (and the LLD is starting (or will start) the given
- *      command) then this function should place 0 in scp->result and
- *      return 0.
+ *      Returns 0 on success.
+ *
+ *	If there's a failure, return either:
+ *
+ *	SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
+ *	SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
+ *
+ *	On both of these returns, the mid-layer will requeue the I/O
+ *
+ *	- if the return is SCSI_MLQUEUE_DEVICE_BUSY, only that particular
+ *	device will be paused, and it will be unpaused when a command to
+ *	the device returns (or after a brief delay if there are no more
+ *	outstanding commands to it).  Commands to other devices continue
+ *	to be processed normally.
+ *
+ *	- if the return is SCSI_MLQUEUE_HOST_BUSY, all I/O to the host
+ *	is paused and will be unpaused when any command returns from
+ *	the host (or after a brief delay if there are no outstanding
+ *	commands to the host).
+ *
+ *	For compatibility with earlier versions of queuecommand, any
+ *	other return value is treated the same as
+ *	SCSI_MLQUEUE_HOST_BUSY.
+ *
+ *	Other types of errors that are detected immediately may be
+ *	flagged by setting scp->result to an appropriate value,
+ *	invoking the 'done' callback, and then returning 0 from this
+ *	function. If the command is not performed immediately (and the
+ *	LLD is starting (or will start) the given command) then this
+ *	function should place 0 in scp->result and return 0.
+ *
+ *	Command ownership.  If the driver returns zero, it owns the
+ *	command and must take responsibility for ensuring the 'done'
+ *	callback is executed.  Note: the driver may call done before
+ *	returning zero, but after it has called done, it may not
+ *	return any value other than zero.  If the driver makes a
+ *	non-zero return, it must not execute the command's done
+ *	callback at any time.
  *
  *      Locks: struct Scsi_Host::host_lock held on entry (with "irqsave")
  *             and is expected to be held on return.


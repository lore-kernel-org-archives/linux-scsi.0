From: "Andreas Herrmann" <AHERRMAN@de.ibm.com>
Subject: [Patch] dont block device on QUEUE_FULL for last command
Date: Mon, 4 Aug 2003 17:42:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF122C5E1B.D9D616EB-ONC1256D78.0050C1BC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate.de.ibm.com ([194.196.100.234]:28619 "EHLO
	d12lmsgate.de.ibm.com") by vger.kernel.org with ESMTP
	id S271818AbTHDPmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Aug 2003 11:42:55 -0400
Received: from d12relay01.megacenter.de.ibm.com (d12relay01.megacenter.de.ibm.com [9.149.165.180])
	by d12lmsgate.de.ibm.com (8.12.9/8.12.8) with ESMTP id h74FgqNG190358
	for <linux-scsi@vger.kernel.org>; Mon, 4 Aug 2003 17:42:52 +0200
Received: from d12ml033.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay01.megacenter.de.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h74FgqDR120700
	for <linux-scsi@vger.kernel.org>; Mon, 4 Aug 2003 17:42:52 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I observed the following problem:
A device was marked as blocked after a QUEUE_FULL status code
was returned for the last scsi command for a device.
And there's a snag to it -- because no further commands are pending
for that device, the device is not set unblocked anymore.

Solution is:
Do not block the device/adapter if getting QUEUE_FULL status code
for the last pending command of that device/adapter, but retry
the command.


Regards,

Andreas


Here is a patch for drivers/scsi/scsi_queue.c

--- scsi_queue.c        Mon Aug  4 16:22:16 2003
+++ scsi_queue.c.new    Mon Aug  4 16:23:49 2003
@@ -103,7 +103,7 @@
                 * If a host is inactive and cannot queue any commands, I 
don't see
                 * how things could possibly work anyways.
                 */
-               if (host->host_busy == 0) {
+               if (host->host_busy == 1) {
                        if (scsi_retry_command(cmd) == 0) {
                                return 0;
                        }
@@ -118,7 +118,7 @@
                 * If a host is inactive and cannot queue any commands, I 
don't see
                 * how things could possibly work anyways.
                 */
-               if (cmd->device->device_busy == 0) {
+               if (cmd->device->device_busy == 1) {
                        if (scsi_retry_command(cmd) == 0) {
                                return 0;
                        }


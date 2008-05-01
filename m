From: Pontus Lidman <pontus@lysator.liu.se>
Subject: Hack to not step on vendor commands for some devices
Date: 01 May 2008 14:54:36 +0200
Message-ID: <n61w4m9oc3.fsf@sellafield.lysator.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:60531 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYEAN1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 09:27:44 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.lysator.liu.se (Postfix) with ESMTP id 760C3200A1C3
	for <linux-scsi@vger.kernel.org>; Thu,  1 May 2008 14:54:37 +0200 (CEST)
Received: from mail.lysator.liu.se ([127.0.0.1])
	by localhost (lenin.lysator.liu.se [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 03239-01-17 for <linux-scsi@vger.kernel.org>;
	Thu, 1 May 2008 14:54:37 +0200 (CEST)
Received: from sellafield.lysator.liu.se (sellafield.lysator.liu.se [130.236.254.103])
	by mail.lysator.liu.se (Postfix) with ESMTP id DEE71200A1E5
	for <linux-scsi@vger.kernel.org>; Thu,  1 May 2008 14:54:36 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

I'm trying to support an usb-storage device that uses vendor-specific
SCSI commands for some functions; I'm using the sg interface from user
space.

The problem is, the linux kernel will replace some bits in the
vendor-specific command with the LUN number, making it unintelligible
to the device. I wrote the included patch that works around this
problem.

cmd->device->scsi_level is SCSI_2 for this device.

Is there any other user-space solution to this problem? If not, what
are the next steps to have a solution appear in the mainline kernel?

Best Regards,

Pontus

-- 
Pontus Lidman, pontus@lysator.liu.se, Software Engineer

diff --recursive -u linux-2.6.24.5/drivers/scsi/scsi.c linux-2.6.24.5.pl/drivers/scsi/scsi.c
--- linux-2.6.24.5/drivers/scsi/scsi.c	2008-04-19 03:53:39.000000000 +0200
+++ linux-2.6.24.5.pl/drivers/scsi/scsi.c	2008-04-27 17:17:35.000000000 +0200
@@ -501,9 +501,12 @@
 
 	/* 
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
+	 * However, don't modify the contents of vendor specific
+	 * commands (0xf0-0xff).
 	 */
 	if (cmd->device->scsi_level <= SCSI_2 &&
-	    cmd->device->scsi_level != SCSI_UNKNOWN) {
+	    cmd->device->scsi_level != SCSI_UNKNOWN &&
+	    cmd->cmnd[0] < 0xf0) {
 		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
 			       (cmd->device->lun << 5 & 0xe0);
 	}



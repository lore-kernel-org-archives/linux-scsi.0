From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 62811] New: Don't Modify the scsi subcmd as LUN value when
 using VENDOR cmd
Date: Thu, 10 Oct 2013 17:22:11 +0000
Message-ID: <bug-62811-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:53164 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab3JJRWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Oct 2013 13:22:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 9E52220318
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2013 17:22:13 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 9EED02030D
	for <linux-scsi@vger.kernel.org>; Thu, 10 Oct 2013 17:22:11 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=62811

            Bug ID: 62811
           Summary: Don't Modify the scsi subcmd as LUN value when using
                    VENDOR cmd
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.12rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: yilikernel@gmail.com
        Regression: No

Using the VENDOR scsi cmd, We should not to modify the cmd->cmnd [1] as lun
value. it is useful as a subcmd for USB device, such as STEC usb device.

 Signed-off-by: Yi Li <yilikernel@gmail.com>

--- linux/drivers/scsi/scsi.c_orig 2013-09-12 01:51:45.000000000 -0400
+++ linux/drivers/scsi/scsi.c 2013-09-12 01:59:24.000000000 -0400
@@ -83,6 +83,9 @@ static void scsi_done(struct scsi_cmnd *
 /* Do not call reset on error if we just did a reset within 15 sec. */
 #define MIN_RESET_PERIOD (15*HZ)

+/* Define a SCSI command VENDOR to get device info For STEC USB devcie */
+#define STECUSB_VENDOR_CMD_CODE 0xD8
+
 /*
 * Note - the initial logging level can be set here to log events at boot time.
 * After the system is up, you may enable logging via the /proc interface.
@@ -700,8 +703,13 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 */
 if (cmd->device->scsi_level <= SCSI_2 &&
 cmd->device->scsi_level != SCSI_UNKNOWN) {
 - cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
- (cmd->device->lun << 5 & 0xe0);
+ /*
+ * Don't Modify the cmnd[1] as LUN value when it is a VENDOR CMD
+ * for STEC disk.
 + */
+ if (STECUSB_VENDOR_CMD_CODE != cmd->cmnd[0])
+ cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
+ (cmd->device->lun << 5 & 0xe0);
 }

 /*

-- 
You are receiving this mail because:
You are watching the assignee of the bug.

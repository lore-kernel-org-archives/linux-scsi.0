From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] Change scsi send/completion logging back to terser output
Date: Tue, 25 Jan 2005 13:51:27 -0800
Message-ID: <20050125215127.GA7937@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:20428 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262165AbVAYVv5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 16:51:57 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0PLpuul012762
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2005 16:51:56 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0PLpuBp310152
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2005 14:51:56 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0PLptE6018775
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2005 14:51:55 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patch against latest scsi rc fixes.

Change scsi send/completion logging back to terser output:

print_command was renamed __scsi_print_command, but two print_command
calls were renamed to scsi_print_command rather than __scsi_print_command.

__scsi_print_command at one time did not print KERN_INFO prefix, change it
back to not print it.

Signed off by: Patrick Mansfield <patmans@us.ibm.com>

diff -uprN -X /home/patman/dontdiff scsi-rc-fix-2.6.11-rc2/drivers/scsi/constants.c terser-cmd/drivers/scsi/constants.c
--- scsi-rc-fix-2.6.11-rc2/drivers/scsi/constants.c	Tue Jan 25 12:26:21 2005
+++ terser-cmd/drivers/scsi/constants.c	Tue Jan 25 12:27:38 2005
@@ -342,7 +342,7 @@ void __scsi_print_command(unsigned char 
 {
 	int k, len;
 
-	print_opcode_name(command, 0, 1);
+	print_opcode_name(command, 0, 0);
 	if (VARIABLE_LENGTH_CMD == command[0])
 		len = command[7] + 8;
 	else
diff -uprN -X /home/patman/dontdiff scsi-rc-fix-2.6.11-rc2/drivers/scsi/scsi.c terser-cmd/drivers/scsi/scsi.c
--- scsi-rc-fix-2.6.11-rc2/drivers/scsi/scsi.c	Tue Jan 25 11:08:54 2005
+++ terser-cmd/drivers/scsi/scsi.c	Tue Jan 25 11:11:31 2005
@@ -424,7 +424,7 @@ void scsi_log_send(struct scsi_cmnd *cmd
 			 * output in scsi_log_completion.
 			 */
 			printk("                 ");
-			scsi_print_command(cmd);
+			__scsi_print_command(cmd);
 			if (level > 3) {
 				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
 				       " done = 0x%p, queuecommand 0x%p\n",
@@ -492,7 +492,7 @@ void scsi_log_completion(struct scsi_cmn
 				printk("UNKNOWN");
 			}
 			printk(" %8x ", cmd->result);
-			scsi_print_command(cmd);
+			__scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION) {
 				/*
 				 * XXX The print_sense formatting/prefix

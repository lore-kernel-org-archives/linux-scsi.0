From: Alan Stern <stern@rowland.harvard.edu>
Subject: Patch: change the serial_number for error-handler commands
Date: Tue, 20 May 2003 10:11:49 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305191433280.1042-100000@ida.rowland.org>
References: <20030516222900.GA3236@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4356 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263789AbTETN6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2003 09:58:50 -0400
In-Reply-To: <20030516222900.GA3236@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike:

Do you, or does anybody else, object to the patch below?  And if not, 
could you please ask Linus to apply it?  It would improve error recovery 
for certain types of USB storage drives.

Alan Stern


===== scsi_error.c 1.27 vs edited =====
--- 1.27/drivers/scsi/scsi_error.c	Sun May  4 12:50:44 2003
+++ edited/drivers/scsi/scsi_error.c	Mon May 19 14:17:04 2003
@@ -753,6 +753,8 @@
 	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
 	scmd->underflow = 0;
 	scmd->sc_data_direction = SCSI_DATA_NONE;
+	if ((scmd->serial_number -= 999999) == 0)
+		scmd->serial_number -= 999999;
 
 	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);
 



From: Andries.Brouwer@cwi.nl
Subject: [patch] NCR5380.c fix
Date: Fri, 16 May 2003 00:45:10 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200305152245.h4FMjAj26766.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:51105 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S264041AbTEOWcW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2003 18:32:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: torvalds@transmeta.com

Several SCSI drivers confuse CHECK_CONDITION and CHECK_CONDITION << 1.
One of them is NCR5380.c. Below a patch adding status_byte() twice.

(On the other hand, sun3_NCR5380.c does this right, and generally
looks better. Maybe they can be merged eventually.)

Andries

(This was for 2.5.68. I think 2.5.69 will differ by 1 line.)

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c	Wed Mar  5 04:29:03 2003
+++ b/drivers/scsi/NCR5380.c	Fri May 16 01:42:51 2003
@@ -2466,11 +2466,11 @@
 
 					if (cmd->cmnd[0] != REQUEST_SENSE)
 						cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					else if (cmd->SCp.Status != GOOD)
+					else if (status_byte(cmd->SCp.Status) != GOOD)
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
 #ifdef AUTOSENSE
-					if ((cmd->cmnd[0] != REQUEST_SENSE) && (cmd->SCp.Status == CHECK_CONDITION)) {
+					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
 						dprintk(NDEBUG_AUTOSENSE, ("scsi%d : performing request sense\n", instance->host_no));
 						cmd->cmnd[0] = REQUEST_SENSE;
 						cmd->cmnd[1] &= 0xe0;

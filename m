From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 3/4] stex: fix reset recovery for console device
Date: Wed, 9 May 2007 20:50:40 -0800
Message-ID: <NONAMEBPke3fzk76oJD00001143@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:49282 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754883AbXEJDsj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 23:48:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>


After reset completed, the scsi error handler sends out TEST_UNIT_READY
to the device. For 'normal' devices the command will be handled by firmware.
However, because the RAID console only interfaces to scsi mid layer, the
firmware will not process the command for it. This will make the console to
be offlined right after reset. Add the handling in driver to fix this problem.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 81dd3b7..47c2ef9 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -612,6 +612,13 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			return 0;
 		}
 		break;
+	case TEST_UNIT_READY:
+		if (id == host->max_id - 1) {
+			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			done(cmd);
+			return 0;
+		}
+		break;
 	case INQUIRY:
 		if (id != host->max_id - 1)
 			break;



From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
Date: Fri, 30 Mar 2007 15:21:38 -0700
Message-ID: <NONAMEB98KtdhQYZkxO000005d5@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:2362 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933058AbXC3XLi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 19:11:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

After reset completed, the scsi error handler sends out START_STOP
and TEST_UNIT_READY to the device. For 'normal' devices these
commands will be handled by firmware. However, because the RAID
console only interfaces to scsi mid layer, the firmware will not process
these commands for it. This will make the console to be offlined right
after reset. Add the handling in driver to fix this problem.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1e8d7ac..9465f35 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -605,6 +605,14 @@ stex_queuecommand(struct scsi_cmnd *cmd,
 			stex_invalid_field(cmd, done);
 		return 0;
 	}
+	case TEST_UNIT_READY:
+	case START_STOP:
+		if (id == ST_MAX_ARRAY_SUPPORTED) {
+			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+			done(cmd);
+			return 0;
+		}
+		break;
 	case INQUIRY:
 		if (id != ST_MAX_ARRAY_SUPPORTED)
 			break;



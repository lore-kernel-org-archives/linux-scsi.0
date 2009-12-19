From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH] stex: fix scan of nonexistent lun
Date: Fri, 18 Dec 2009 17:34:51 -0800
Message-ID: <200912181734501077465@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:35133 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755499AbZLSBfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2009 20:35:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>


During a manual scan, a user can send command to a nonexistent
lun, precisely at the point of max_lun. Normally it's possible
(but not required) that the firmware has the knowledge that it
is an invalid lun. In the particular case when max_lun is 256,
however, the nonexistent lun 256 will be confused with lun 0,
because the lun member in a request message is only u8, and 256
will become 0. So we need to fix the problem, at least, at the
driver level.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 3058bb1..fd7b15b 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -623,6 +623,11 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		}
 		break;
 	case INQUIRY:
+		if (lun >= host->max_lun) {
+			cmd->result = DID_NO_CONNECT << 16;
+			done(cmd);
+			return 0;
+		}
 		if (id != host->max_id - 1)
 			break;
 		if (!lun && !cmd->device->channel &&



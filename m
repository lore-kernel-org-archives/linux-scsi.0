From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/5] qla2xxx: Return a FAILED status when abort mailbox-command fails.
Date: Fri, 24 Oct 2008 15:13:47 -0700
Message-ID: <1224886428-31799-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:14169 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbYJXWNu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 18:13:50 -0400
In-Reply-To: <1224886428-31799-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Michael Reed <mdr@sgi.com>

From: Michael Reed <mdr@sgi.com>

Mike Reed noted
(https://bugzilla.novell.com/show_bug.cgi?id=421330) that the
driver was incorrectly returning a SUCCESS status if the driver's
request to the firmware to abort a command failed.  By doing so,
the mid-layer believed, incorrectly, that the command has
completed and has been returned (ultimately clearing
scsi_cmnd.request_buffer) yet the driver still has the command.
What should correctly happen is a mid-layer escalation
(device-reset, etc.) of recovery during which the driver will
eventually return the outstanding commands to the mid-layer.

Cc: Stable Tree <stable@kernel.org>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 21dd182..3556720 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -728,6 +728,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		if (ha->isp_ops->abort_command(ha, sp)) {
 			DEBUG2(printk("%s(%ld): abort_command "
 			    "mbx failed.\n", __func__, ha->host_no));
+			ret = FAILED;
 		} else {
 			DEBUG3(printk("%s(%ld): abort_command "
 			    "mbx success.\n", __func__, ha->host_no));
-- 
1.6.0.2.526.g5c283


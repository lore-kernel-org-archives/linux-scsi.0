From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: Fix cmd check in qla4xxx_cmd_wait
Date: Tue, 26 Oct 2010 05:45:30 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871295C277A@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:40944 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab0JZMpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 08:45:34 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Nilesh Javali <nilesh.javali@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

From: Mike Christie <michaelc@cs.wisc.edu>

If the command has timedout then the block layer has called
blk_mark_rq_complete. If qla4xxx_cmd_wait is then called
from qla4xxx_eh_host_reset, we will always fail, because if
the driver calls scsi_done then the the block layer will fail
at blk_complete_request's blk_mark_rq_complete call instead of
calling the normal completion path including the function,
blk_queue_end_tag, which releases the tag.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f1c58eb..7ff69d6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -881,7 +881,13 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *ha)
 		/* Find a command that hasn't completed. */
 		for (index = 0; index < ha->host->can_queue; index++) {
 			cmd = scsi_host_find_tag(ha->host, index);
-			if (cmd != NULL)
+			/*
+			 * We cannot just check if the index is valid,
+			 * becase if we are run from the scsi eh, then
+			 * the scsi/block layer is going to prevent
+			 * the tag from being released.
+			 */ 
+			if (cmd != NULL && CMD_SP(cmd))
 				break;
 		}
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-- 
1.6.6


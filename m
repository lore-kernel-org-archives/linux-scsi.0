From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 14/15] qla4xxx: grab hardware_lock in eh_abort before
 accessing srb
Date: Wed, 6 Oct 2010 22:51:17 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406792@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:39146 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0JGFv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:51:26 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Mike Christie <michaelc@cs.wisc.edu>

grab hardware_lock in eh_abort before accessing srb to avoid
race between command completion and get refcount on srb.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4b6cdb6..f1c58eb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2006,6 +2006,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	unsigned int id = cmd->device->id;
 	unsigned int lun = cmd->device->lun;
 	unsigned long serial = cmd->serial_number;
+	unsigned long flags;
 	struct srb *srb = NULL;
 	int ret = SUCCESS;
 	int wait = 0;
@@ -2014,12 +2015,14 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	    "scsi%ld:%d:%d: Abort command issued cmd=%p, pid=%ld\n",
 	    ha->host_no, id, lun, cmd, serial);
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	srb = (struct srb *) CMD_SP(cmd);
-
-	if (!srb)
+	if (!srb) {
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		return SUCCESS;
-
+	}
 	kref_get(&srb->srb_ref);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (qla4xxx_abort_task(ha, srb) != QLA_SUCCESS) {
 		DEBUG3(printk("scsi%ld:%d:%d: Abort_task mbx failed.\n",
-- 
1.6.6


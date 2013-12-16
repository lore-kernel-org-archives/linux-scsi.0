From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 20/24] qla4xxx: Update print statements in func qla4xxx_eh_abort()
Date: Mon, 16 Dec 2013 06:49:50 -0500
Message-ID: <1387194594-29817-21-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:19537 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320Ab3LPMXi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:38 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d0a8695..410fe02 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9230,14 +9230,15 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
 	int ret = SUCCESS;
 	int wait = 0;
 
-	ql4_printk(KERN_INFO, ha,
-	    "scsi%ld:%d:%d: Abort command issued cmd=%p\n",
-	    ha->host_no, id, lun, cmd);
+	ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d: Abort command issued cmd=%p, cdb=0x%x\n",
+		   ha->host_no, id, lun, cmd, cmd->cmnd[0]);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	srb = (struct srb *) CMD_SP(cmd);
 	if (!srb) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%d: Specified command has already completed.\n",
+			   ha->host_no, id, lun);
 		return SUCCESS;
 	}
 	kref_get(&srb->srb_ref);
-- 
1.8.2.GIT


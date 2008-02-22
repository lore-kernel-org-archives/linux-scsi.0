From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: aic94xx: fix sequencer hang on error recovery
Date: Fri, 22 Feb 2008 17:01:59 -0600
Message-ID: <1203721319.6206.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56509 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759227AbYBVXCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 18:02:05 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 6DDDF8254
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2008 17:02:02 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xhEVAXhAeNm0 for <linux-scsi@vger.kernel.org>;
	Fri, 22 Feb 2008 17:02:01 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 5CF9C83F0
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2008 17:02:00 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The clear nexus I_T and clear nexus I_T_L functions in the aic94xx
specify the SUSPEND_TX flag which causes the sequencer to be suspended
until it receives a RESUME_TX.  Unfortunately, nothing ever sends the
resume, so the sequencer on the link is stopped forever, leading to
eventual timeouts and I/O errors.

Since clear nexus commands are only executed as part of error recovery,
it's perfectly fine to keep the sequencer running on the link ... as
soon as the recovery function is completed, we'll send it the commands
to retry.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index b52124f..144f5ad 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -151,8 +151,6 @@ static int asd_clear_nexus_I_T(struct domain_device *dev)
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_I_T;
 	scb->clear_nexus.flags = SEND_Q | EXEC_Q | NOTINQ;
-	if (dev->tproto)
-		scb->clear_nexus.flags |= SUSPEND_TX;
 	scb->clear_nexus.conn_handle = cpu_to_le16((u16)(unsigned long)
 						   dev->lldd_dev);
 	CLEAR_NEXUS_POST;
@@ -169,8 +167,6 @@ static int asd_clear_nexus_I_T_L(struct domain_device *dev, u8 *lun)
 	CLEAR_NEXUS_PRE;
 	scb->clear_nexus.nexus = NEXUS_I_T_L;
 	scb->clear_nexus.flags = SEND_Q | EXEC_Q | NOTINQ;
-	if (dev->tproto)
-		scb->clear_nexus.flags |= SUSPEND_TX;
 	memcpy(scb->clear_nexus.ssp_task.lun, lun, 8);
 	scb->clear_nexus.conn_handle = cpu_to_le16((u16)(unsigned long)
 						   dev->lldd_dev);



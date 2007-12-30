From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libsas: don't use made up error codes
Date: Sun, 30 Dec 2007 12:37:31 -0600
Message-ID: <1199039851.5380.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56305 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751212AbXL3Shf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Dec 2007 13:37:35 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 73BCD870A
	for <linux-scsi@vger.kernel.org>; Sun, 30 Dec 2007 12:37:33 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.il.steeleye.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WQGEg77FCygA for <linux-scsi@vger.kernel.org>;
	Sun, 30 Dec 2007 12:37:32 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id EC40F80E2
	for <linux-scsi@vger.kernel.org>; Sun, 30 Dec 2007 12:37:31 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is bad for two reasons:

     1. If they're returned to outside applications, no-one knows what
        they mean.
     2. Eventually they'll clash with the ever expanding standard error
        codes.

The problem error code in question is ETASK.  I've replaced this by
ECOMM (communications error on send) a network error code that seems to
most closely relay what ETASK meant.

James

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0829b55..adc47d4 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -500,7 +500,7 @@ static int sas_execute_task(struct sas_task *task, void *buffer, int size,
 			goto ex_err;
 		}
 		wait_for_completion(&task->completion);
-		res = -ETASK;
+		res = -ECOMM;
 		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 			int res2;
 			SAS_DPRINTK("task aborted, flags:0x%x\n",
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 8aeaad9..aefd865 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -96,7 +96,7 @@ static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
 		}
 
 		wait_for_completion(&task->completion);
-		res = -ETASK;
+		res = -ECOMM;
 		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 			SAS_DPRINTK("smp task timed out or aborted\n");
 			i->dft->lldd_abort_task(task);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 93248cd..a075f13 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -91,8 +91,6 @@ enum discover_event {
 
 /* ---------- Expander Devices ---------- */
 
-#define ETASK 0xFA
-
 #define to_dom_device(_obj) container_of(_obj, struct domain_device, dev_obj)
 #define to_dev_attr(_attr)  container_of(_attr, struct domain_dev_attribute,\
                                          attr)



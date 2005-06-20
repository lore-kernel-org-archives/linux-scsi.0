From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: Interrupt mitigation
Date: Mon, 20 Jun 2005 15:41:43 -0700
Message-ID: <1119307303.21986.37.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23713 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261397AbVFTWlr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 18:41:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn from Adaptec:

If more than two commands are outstanding to the controller, there is no
need to notify the adapter via a PCI bus transaction of additional
commands added into the queue; it will get to them when it works through
the produce/consumer indexes.

This reduced the PCI traffic in the driver to submit a command to the
queue to near zero allowing a significant number of commands to be
turned around with no need to block for the PCI bridge to flush the
notify request to the adapter.

Interrupt mitigation has always been present in the driver; it was
turned off because of a bug that prevented one from realizing the
usefulness of the feature. This bug is fixed in this patch.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>

diff -ru a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c	Mon Jun 20 13:59:27 2005
+++ b/drivers/scsi/aacraid/comminit.c	Mon Jun 20 14:03:35 2005
@@ -44,7 +44,9 @@
 
 #include "aacraid.h"
 
-struct aac_common aac_config;
+struct aac_common aac_config = {
+	.irq_mod = 1
+};
 
 static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long commsize, unsigned long commalign)
 {
diff -ru a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	Mon Jun 20 13:59:27 2005
+++ b/drivers/scsi/aacraid/commsup.c	Mon Jun 20 14:08:22 2005
@@ -254,6 +254,7 @@
 static int aac_get_entry (struct aac_dev * dev, u32 qid, struct aac_entry **entry, u32 * index, unsigned long *nonotify)
 {
 	struct aac_queue * q;
+	unsigned long idx;
 
 	/*
 	 *	All of the queues wrap when they reach the end, so we check
@@ -263,10 +264,23 @@
 	 */
 
 	q = &dev->queues->queue[qid];
-	
-	*index = le32_to_cpu(*(q->headers.producer));
-	if ((*index - 2) == le32_to_cpu(*(q->headers.consumer)))
+
+	idx = *index = le32_to_cpu(*(q->headers.producer));
+	/* Interrupt Moderation, only interrupt for first two entries */
+	if (idx != le32_to_cpu(*(q->headers.consumer))) {
+		if (--idx == 0) {
+			if (qid == AdapHighCmdQueue)
+				idx = ADAP_HIGH_CMD_ENTRIES;
+			else if (qid == AdapNormCmdQueue)
+				idx = ADAP_NORM_CMD_ENTRIES;
+			else if (qid == AdapHighRespQueue) 
+	        		idx = ADAP_HIGH_RESP_ENTRIES;
+			else if (qid == AdapNormRespQueue) 
+				idx = ADAP_NORM_RESP_ENTRIES;
+		}
+		if (idx != le32_to_cpu(*(q->headers.consumer)))
 			*nonotify = 1; 
+	}
 
 	if (qid == AdapHighCmdQueue) {
 	        if (*index >= ADAP_HIGH_CMD_ENTRIES)

-- 
Mark Haverkamp <markh@osdl.org>


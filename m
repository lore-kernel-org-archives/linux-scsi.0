From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ibmvfc: Fix double completion on abort timeout
Date: Fri, 24 Aug 2012 16:50:59 -0500
Message-ID: <201208242151.q7OLp0Ib013123@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36038 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758819Ab2HXVvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Aug 2012 17:51:16 -0400
Received: from /spool/local
	by e6.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 24 Aug 2012 17:51:14 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 2906DC9003C
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:02 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7OLp1eN34144258
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:01 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7OLp1h6013176
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcj@linux.vnet.ibm.com, stimmer@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


If an abort request times out to the virtual fibre channel adapter,
the ibmvfc driver will kick off a reset of the adapter. This
patch ensures we wait for the both the abort request and the
request being aborted to be completed prior to exiting the
eh_abort handler. This fixes a bug where the ibmvfc driver
was erroneously returning success to the eh_abort handler
then later sending back a response to the same command.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_timeout_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_timeout_fix	2012-08-24 16:37:47.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2012-08-24 16:37:47.000000000 -0500
@@ -2242,6 +2242,21 @@ static int ibmvfc_match_key(struct ibmvf
 }
 
 /**
+ * ibmvfc_match_evt - Match function for specified event
+ * @evt:	ibmvfc event struct
+ * @match:	event to match
+ *
+ * Returns:
+ *	1 if event matches key / 0 if event does not match key
+ **/
+static int ibmvfc_match_evt(struct ibmvfc_event *evt, void *match)
+{
+	if (evt == match)
+		return 1;
+	return 0;
+}
+
+/**
  * ibmvfc_abort_task_set - Abort outstanding commands to the device
  * @sdev:	scsi device to abort commands
  *
@@ -2322,7 +2337,20 @@ static int ibmvfc_abort_task_set(struct
 		if (rc) {
 			sdev_printk(KERN_INFO, sdev, "Cancel failed, resetting host\n");
 			ibmvfc_reset_host(vhost);
-			rsp_rc = 0;
+			rsp_rc = -EIO;
+			rc = ibmvfc_wait_for_ops(vhost, sdev->hostdata, ibmvfc_match_key);
+
+			if (rc == SUCCESS)
+				rsp_rc = 0;
+
+			rc = ibmvfc_wait_for_ops(vhost, evt, ibmvfc_match_evt);
+			if (rc != SUCCESS) {
+				spin_lock_irqsave(vhost->host->host_lock, flags);
+				ibmvfc_hard_reset_host(vhost);
+				spin_unlock_irqrestore(vhost->host->host_lock, flags);
+				rsp_rc = 0;
+			}
+
 			goto out;
 		}
 	}
_


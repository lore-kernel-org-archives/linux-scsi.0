From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [PATCH] ibmvscsi kexec fix
Date: Tue, 15 Nov 2005 09:53:00 -0600
Message-ID: <20051115155300.GA26724@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.202]:16102 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S1751425AbVKOPxF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 10:53:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>

James, this is a 2.6.15 candidate...it makes ibmvscsi work
correctly with the recent set of kexec patches that went in.
This is based on work by Michael Ellerman, who chased this
initially.  He validated that it works during kexec.

Handle kexec correctly in ibmvscsi.   During kexec the adapter
will not get cleaned up correctly, so we may need to reset it
to make it sane again.

Signed-off-by: Dave Boutcher <sleddog@us.ibm.com>

--- linux-2.6.15-rc1-orig/drivers/scsi/ibmvscsi/ibmvscsi.h	2005-11-14 14:55:32.000000000 -0600
+++ linux-2.6.15-rc1/drivers/scsi/ibmvscsi/ibmvscsi.h	2005-11-14 21:13:52.000000000 -0600
@@ -100,7 +100,7 @@
 void ibmvscsi_release_crq_queue(struct crq_queue *queue,
 				struct ibmvscsi_host_data *hostdata,
 				int max_requests);
-void ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
 			      struct ibmvscsi_host_data *hostdata);
 
 void ibmvscsi_handle_crq(struct viosrp_crq *crq,
--- linux-2.6.15-rc1-orig/drivers/scsi/ibmvscsi/rpa_vscsi.c	2005-11-14 14:55:32.000000000 -0600
+++ linux-2.6.15-rc1/drivers/scsi/ibmvscsi/rpa_vscsi.c	2005-11-14 21:13:51.000000000 -0600
@@ -230,6 +230,11 @@
 	rc = plpar_hcall_norets(H_REG_CRQ,
 				vdev->unit_address,
 				queue->msg_token, PAGE_SIZE);
+	if (rc == H_Resource) 
+		/* maybe kexecing and resource is busy. try a reset */
+		rc = ibmvscsi_reset_crq_queue(queue,
+					      hostdata);
+
 	if (rc == 2) {
 		/* Adapter is good, but other end is not ready */
 		printk(KERN_WARNING "ibmvscsi: Partner adapter not ready\n");
@@ -281,7 +286,7 @@
  * @hostdata:	ibmvscsi_host_data of host
  *
  */
-void ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
 			      struct ibmvscsi_host_data *hostdata)
 {
 	int rc;
@@ -309,4 +314,5 @@
 		printk(KERN_WARNING
 		       "ibmvscsi: couldn't register crq--rc 0x%x\n", rc);
 	}
+	return rc;
 }
--- linux-2.6.15-rc1-orig/drivers/scsi/ibmvscsi/iseries_vscsi.c	2005-11-14 14:56:47.000000000 -0600
+++ linux-2.6.15-rc1/drivers/scsi/ibmvscsi/iseries_vscsi.c	2005-11-14 21:13:53.000000000 -0600
@@ -117,9 +117,10 @@
  *
  * no-op for iSeries
  */
-void ibmvscsi_reset_crq_queue(struct crq_queue *queue,
+int ibmvscsi_reset_crq_queue(struct crq_queue *queue,
 			      struct ibmvscsi_host_data *hostdata)
 {
+	return 0;
 }
 
 /**
-- 
Dave Boutcher

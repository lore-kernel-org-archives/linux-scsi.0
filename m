From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ibmvfc: Fixup TMF response handling
Date: Mon, 19 Oct 2009 14:19:43 -0500
Message-ID: <200910191919.n9JJJhxV018480@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38408 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbZJSTTj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2009 15:19:39 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e7.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JJGcpR023860
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:16:38 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JJJifD253508
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:19:44 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9JJJhT8018494
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 15:19:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


When processing the response to either a LUN reset,
target reset, or an abort task set, the ibmvfc driver needs to
treat as success receiving a response with a non-zero
status in the response IU along with a general transport
error with the FCP response code being zero. The VIOS
currently guarantees this cannot happen, but a future version
of VIOS may allow this to be returned, so ensure we handle
this response combination correctly for TMFs, as we already
do for SCSI commands.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_tmf_rsp_fixup drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_tmf_rsp_fixup	2009-10-02 10:39:48.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-10-05 10:03:00.000000000 -0500
@@ -1731,7 +1731,10 @@ static int ibmvfc_reset_device(struct sc
 	sdev_printk(KERN_INFO, sdev, "Resetting %s\n", desc);
 	wait_for_completion(&evt->comp);
 
-	if (rsp_iu.cmd.status) {
+	if (rsp_iu.cmd.status)
+		rsp_code = ibmvfc_get_err_result(&rsp_iu.cmd);
+
+	if (rsp_code) {
 		if (fc_rsp->flags & FCP_RSP_LEN_VALID)
 			rsp_code = fc_rsp->data.info.rsp_code;
 
@@ -1820,7 +1823,10 @@ static int ibmvfc_abort_task_set(struct
 	sdev_printk(KERN_INFO, sdev, "Aborting outstanding commands\n");
 	wait_for_completion(&evt->comp);
 
-	if (rsp_iu.cmd.status) {
+	if (rsp_iu.cmd.status)
+		rsp_code = ibmvfc_get_err_result(&rsp_iu.cmd);
+
+	if (rsp_code) {
 		if (fc_rsp->flags & FCP_RSP_LEN_VALID)
 			rsp_code = fc_rsp->data.info.rsp_code;
 
_

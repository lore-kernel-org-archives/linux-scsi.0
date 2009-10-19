From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 1/6] ibmvfc: Fixup TMF response handling
Date: Mon, 19 Oct 2009 15:07:47 -0500
Message-ID: <200910192007.n9JK7mnW018206@d03av05.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:60737 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbZJSUH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Oct 2009 16:07:56 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e37.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9JK6r9t018852
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:06:53 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9JK7r3d159894
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:07:53 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9JK7mkS018232
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2009 14:07:48 -0600
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

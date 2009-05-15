From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/9] zfcp: Make queue_depth adjustable
Date: Fri, 15 May 2009 13:18:16 +0200
Message-ID: <20090515112221.632495000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:38847 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=702-zfcp-queue-depth.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp did always set the queue_depth for SCSI devices to 32, not
allowing to change this. Introduce a kernel parameter zfcp.queue_depth
and the change_queue_depth callback to allow changing the queue_depth
when it is required.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-05-15 12:56:13.000000000 +0200
@@ -12,6 +12,10 @@
 #include "zfcp_ext.h"
 #include <asm/atomic.h>
 
+static unsigned int default_depth = 32;
+module_param_named(queue_depth, default_depth, uint, 0600);
+MODULE_PARM_DESC(queue_depth, "Default queue depth for new SCSI devices");
+
 /* Find start of Sense Information in FCP response unit*/
 char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *fcp_rsp_iu)
 {
@@ -24,6 +28,12 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
 	return fcp_sns_info_ptr;
 }
 
+static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth)
+{
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+	return sdev->queue_depth;
+}
+
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
@@ -34,7 +44,7 @@ static void zfcp_scsi_slave_destroy(stru
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
 {
 	if (sdp->tagged_supported)
-		scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, 32);
+		scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, default_depth);
 	else
 		scsi_adjust_queue_depth(sdp, 0, 1);
 	return 0;
@@ -662,6 +672,7 @@ struct zfcp_data zfcp_data = {
 		.name			 = "zfcp",
 		.module			 = THIS_MODULE,
 		.proc_name		 = "zfcp",
+		.change_queue_depth	 = zfcp_scsi_change_queue_depth,
 		.slave_alloc		 = zfcp_scsi_slave_alloc,
 		.slave_configure	 = zfcp_scsi_slave_configure,
 		.slave_destroy		 = zfcp_scsi_slave_destroy,


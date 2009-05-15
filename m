From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/9] zfcp: Remove unnecessary default case and assignments
Date: Fri, 15 May 2009 13:18:17 +0200
Message-ID: <20090515112221.762099000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:62794 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=703-zfcp-dead-code.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

enum dma_data_direction only has the 4 values DMA_BIDIRECTIONAL,
DMA_TO_DEVICE, DMA_FROM_DEVICE and DMA_NONE. No need to have the
default case. While changing this, setup sbtype in one place to make
sparse happy.

The default value of retval is already -EIO, so remove the
additional assignment for these two cases.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:15.000000000 +0200
@@ -2314,7 +2314,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 {
 	struct zfcp_fsf_req *req;
 	struct fcp_cmnd_iu *fcp_cmnd_iu;
-	unsigned int sbtype;
+	unsigned int sbtype = SBAL_FLAGS0_TYPE_READ;
 	int real_bytes, retval = -EIO;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
@@ -2356,11 +2356,9 @@ int zfcp_fsf_send_fcp_command_task(struc
 	switch (scsi_cmnd->sc_data_direction) {
 	case DMA_NONE:
 		req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
-		sbtype = SBAL_FLAGS0_TYPE_READ;
 		break;
 	case DMA_FROM_DEVICE:
 		req->qtcb->bottom.io.data_direction = FSF_DATADIR_READ;
-		sbtype = SBAL_FLAGS0_TYPE_READ;
 		fcp_cmnd_iu->rddata = 1;
 		break;
 	case DMA_TO_DEVICE:
@@ -2369,8 +2367,6 @@ int zfcp_fsf_send_fcp_command_task(struc
 		fcp_cmnd_iu->wddata = 1;
 		break;
 	case DMA_BIDIRECTIONAL:
-	default:
-		retval = -EIO;
 		goto failed_scsi_cmnd;
 	}
 
@@ -2394,9 +2390,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 					     scsi_sglist(scsi_cmnd),
 					     FSF_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
-		if (req->sbal_number < FSF_MAX_SBALS_PER_REQ)
-			retval = -EIO;
-		else {
+		if (req->sbal_number >= FSF_MAX_SBALS_PER_REQ) {
 			dev_err(&adapter->ccw_device->dev,
 				"Oversize data package, unit 0x%016Lx "
 				"on port 0x%016Lx closed\n",


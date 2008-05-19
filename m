From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Non SCSI error status fixup
Date: Mon, 19 May 2008 10:27:56 -0500
Message-ID: <46948.4546840706$1211210961@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57656 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038AbYESP2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2008 11:28:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4JFRwGl005208
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 11:27:58 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4JFRwJk147894
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 11:27:58 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4JFRvcY021146
	for <linux-scsi@vger.kernel.org>; Mon, 19 May 2008 11:27:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, sfr@canb.auug.org.au, anton@samba.org, brking@linux.vnet.ibm.com


Some versions of the Virtual I/O Server on Power
return 0x99 in the non-SCSI error status field as success,
rather than 0. This fixes the ibmvscsi driver to treat this
response as success.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 linux-2.6-bjking1/drivers/scsi/ibmvscsi/viosrp.h   |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_non_scsi_status_workaround drivers/scsi/ibmvscsi/viosrp.h
--- linux-2.6/drivers/scsi/ibmvscsi/viosrp.h~ibmvscsi_non_scsi_status_workaround	2008-05-19 10:01:00.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/viosrp.h	2008-05-19 10:01:33.000000000 -0500
@@ -65,7 +65,8 @@ enum viosrp_crq_status {
 	VIOSRP_VIOLATES_MAX_XFER = 0x2,
 	VIOSRP_PARTNER_PANIC = 0x3,
 	VIOSRP_DEVICE_BUSY = 0x8,
-	VIOSRP_ADAPTER_FAIL = 0x10
+	VIOSRP_ADAPTER_FAIL = 0x10,
+	VIOSRP_OK2 = 0x99,
 };
 
 struct viosrp_crq {
diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_non_scsi_status_workaround drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_non_scsi_status_workaround	2008-05-19 10:01:44.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2008-05-19 10:02:24.000000000 -0500
@@ -1348,7 +1348,7 @@ void ibmvscsi_handle_crq(struct viosrp_c
 
 	del_timer(&evt_struct->timer);
 
-	if (crq->status != VIOSRP_OK && evt_struct->cmnd)
+	if ((crq->status != VIOSRP_OK && crq->status != VIOSRP_OK2) && evt_struct->cmnd)
 		evt_struct->cmnd->result = DID_ERROR << 16;
 	if (evt_struct->done)
 		evt_struct->done(evt_struct);
_

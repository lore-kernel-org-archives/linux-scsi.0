From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/5] ibmvscsi: Misc. locking fixes
Date: Wed, 13 Jun 2007 17:12:33 -0500
Message-ID: <200706132212.l5DMCX37024092@d01av01.pok.ibm.com>
References: <11817727312836-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46038 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbXFMWMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:12:36 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DMCZNG031192
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:35 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DMCYNY471908
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:34 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DMCYuw024133
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:34 -0400
In-Reply-To: <11817727312836-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@linux.vnet.ibm.com
Cc: rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fix a couple locking bugs discovered during code inspection.
ibmvscsi_send_srp_event needs to be called with the host lock
held. This patch fixes a couple paths in the code where this
wasn't true.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_fix_locking drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_fix_locking	2007-06-12 16:31:03.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-06-12 16:40:19.000000000 -0500
@@ -845,6 +845,7 @@ static void send_mad_adapter_info(struct
 {
 	struct viosrp_adapter_info *req;
 	struct srp_event_struct *evt_struct;
+	unsigned long flags;
 	dma_addr_t addr;
 
 	evt_struct = get_event_struct(&hostdata->pool);
@@ -875,6 +876,7 @@ static void send_mad_adapter_info(struct
 		return;
 	}
 	
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	if (ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2)) {
 		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
 		dma_unmap_single(hostdata->dev,
@@ -882,6 +884,7 @@ static void send_mad_adapter_info(struct
 				 sizeof(hostdata->madapter_info),
 				 DMA_BIDIRECTIONAL);
 	}
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 };
 
 /**
@@ -1357,6 +1360,7 @@ static int ibmvscsi_do_host_config(struc
 {
 	struct viosrp_host_config *host_config;
 	struct srp_event_struct *evt_struct;
+	unsigned long flags;
 	dma_addr_t addr;
 	int rc;
 
@@ -1388,7 +1392,9 @@ static int ibmvscsi_do_host_config(struc
 	}
 
 	init_completion(&evt_struct->comp);
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rc == 0)
 		wait_for_completion(&evt_struct->comp);
 	dma_unmap_single(hostdata->dev, addr, length, DMA_BIDIRECTIONAL);
_

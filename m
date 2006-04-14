From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ibmvscsi: fix leak when failing to send srp event
Date: Fri, 14 Apr 2006 13:52:18 +0900
Message-ID: <20060414135218Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:10881 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965064AbWDNEwN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 00:52:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: linux-scsi@vger.kernel.org


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

7896c57e024078c85cd5bfa3d7ed3d8f8d99d287
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 0a8ad37..2e9be83 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -739,7 +739,8 @@ static void send_mad_adapter_info(struct
 {
 	struct viosrp_adapter_info *req;
 	struct srp_event_struct *evt_struct;
-	
+	dma_addr_t addr;
+
 	evt_struct = get_event_struct(&hostdata->pool);
 	if (!evt_struct) {
 		printk(KERN_ERR "ibmvscsi: couldn't allocate an event "
@@ -757,10 +758,10 @@ static void send_mad_adapter_info(struct
 	
 	req->common.type = VIOSRP_ADAPTER_INFO_TYPE;
 	req->common.length = sizeof(hostdata->madapter_info);
-	req->buffer = dma_map_single(hostdata->dev,
-				     &hostdata->madapter_info,
-				     sizeof(hostdata->madapter_info),
-				     DMA_BIDIRECTIONAL);
+	req->buffer = addr = dma_map_single(hostdata->dev,
+					    &hostdata->madapter_info,
+					    sizeof(hostdata->madapter_info),
+					    DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(req->buffer)) {
 		printk(KERN_ERR
@@ -770,8 +771,13 @@ static void send_mad_adapter_info(struct
 		return;
 	}
 	
-	if (ibmvscsi_send_srp_event(evt_struct, hostdata))
+	if (ibmvscsi_send_srp_event(evt_struct, hostdata)) {
 		printk(KERN_ERR "ibmvscsi: couldn't send ADAPTER_INFO_REQ!\n");
+		dma_unmap_single(hostdata->dev,
+				 addr,
+				 sizeof(hostdata->madapter_info),
+				 DMA_BIDIRECTIONAL);
+	}
 };
 
 /**
@@ -1259,6 +1265,7 @@ static int ibmvscsi_do_host_config(struc
 {
 	struct viosrp_host_config *host_config;
 	struct srp_event_struct *evt_struct;
+	dma_addr_t addr;
 	int rc;
 
 	evt_struct = get_event_struct(&hostdata->pool);
@@ -1279,8 +1286,9 @@ static int ibmvscsi_do_host_config(struc
 	memset(host_config, 0x00, sizeof(*host_config));
 	host_config->common.type = VIOSRP_HOST_CONFIG_TYPE;
 	host_config->common.length = length;
-	host_config->buffer = dma_map_single(hostdata->dev, buffer, length,
-					    DMA_BIDIRECTIONAL);
+	host_config->buffer = addr = dma_map_single(hostdata->dev, buffer,
+						    length,
+						    DMA_BIDIRECTIONAL);
 
 	if (dma_mapping_error(host_config->buffer)) {
 		printk(KERN_ERR
@@ -1291,11 +1299,9 @@ static int ibmvscsi_do_host_config(struc
 
 	init_completion(&evt_struct->comp);
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata);
-	if (rc == 0) {
+	if (rc == 0)
 		wait_for_completion(&evt_struct->comp);
-		dma_unmap_single(hostdata->dev, host_config->buffer,
-				 length, DMA_BIDIRECTIONAL);
-	}
+	dma_unmap_single(hostdata->dev, addr, length, DMA_BIDIRECTIONAL);
 
 	return rc;
 }
-- 
1.1.3

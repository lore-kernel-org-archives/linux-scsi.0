From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/7] zfcp: Move qdio setup from erp to zfcp_qdio.c
Date: Thu, 02 Dec 2010 15:16:17 +0100
Message-ID: <20101202141919.572287350@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57259 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0LBOTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:22 -0500
Content-Disposition: inline; filename=707-zfcp-qdio-setup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Initialization of the qdio waitqueue should happen when the qdio data
is initialized and the QDIOUP flag should be handled in the qdio code
as well. Adjust the code accordingly and remove the superfluos 
function zfcp_erp_adapter_strategy_open_qdio.

Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c  |   13 +------------
 drivers/s390/scsi/zfcp_qdio.c |    2 ++
 2 files changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -644,17 +644,6 @@ static void zfcp_erp_wakeup(struct zfcp_
 	read_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
-static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *act)
-{
-	struct zfcp_qdio *qdio = act->adapter->qdio;
-
-	if (zfcp_qdio_open(qdio))
-		return ZFCP_ERP_FAILED;
-	init_waitqueue_head(&qdio->req_q_wq);
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &act->adapter->status);
-	return ZFCP_ERP_SUCCEEDED;
-}
-
 static void zfcp_erp_enqueue_ptp_port(struct zfcp_adapter *adapter)
 {
 	struct zfcp_port *port;
@@ -778,7 +767,7 @@ static int zfcp_erp_adapter_strategy_ope
 {
 	struct zfcp_adapter *adapter = act->adapter;
 
-	if (zfcp_erp_adapter_strategy_open_qdio(act)) {
+	if (zfcp_qdio_open(adapter->qdio)) {
 		atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
 				  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
 				  &adapter->status);
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -307,6 +307,7 @@ static int zfcp_qdio_allocate(struct zfc
 		return -ENOMEM;
 
 	zfcp_qdio_setup_init_data(&init_data, qdio);
+	init_waitqueue_head(&qdio->req_q_wq);
 
 	return qdio_allocate(&init_data);
 }
@@ -391,6 +392,7 @@ int zfcp_qdio_open(struct zfcp_qdio *qdi
 	/* set index of first avalable SBALS / number of available SBALS */
 	qdio->req_q_idx = 0;
 	atomic_set(&qdio->req_q_free, QDIO_MAX_BUFFERS_PER_Q);
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 
 	return 0;
 


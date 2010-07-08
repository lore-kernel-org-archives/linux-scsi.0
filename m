From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/9] zfcp: Update status read mempool
Date: Thu, 08 Jul 2010 09:53:04 +0200
Message-ID: <20100708080110.196777000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:44296 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab0GHIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:12 -0400
Content-Disposition: inline; filename=703-zfcp-status-mempool.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Commit 64deb6efdc5504ce97b5c1c6f281fffbc150bd93 changed the way status
read buffers are handled but forgot to adjust the mempool to the new
size. Add the call to resize the mempool after the exchange config
data. Also use the define instead of the hard coded number in the fsf
callback for consistency.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    8 ++++++++
 drivers/s390/scsi/zfcp_fsf.c |    3 ++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2010-06-21 09:37:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2010-06-21 09:37:46.000000000 +0200
@@ -714,6 +714,14 @@ static int zfcp_erp_adapter_strategy_ope
 	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
+	if (mempool_resize(act->adapter->pool.status_read_data,
+			   act->adapter->stat_read_buf_num, GFP_KERNEL))
+		return ZFCP_ERP_FAILED;
+
+	if (mempool_resize(act->adapter->pool.status_read_req,
+			   act->adapter->stat_read_buf_num, GFP_KERNEL))
+		return ZFCP_ERP_FAILED;
+
 	atomic_set(&act->adapter->stat_miss, act->adapter->stat_read_buf_num);
 	if (zfcp_status_read_refill(act->adapter))
 		return ZFCP_ERP_FAILED;
--- a/drivers/s390/scsi/zfcp_fsf.c	2010-06-21 09:37:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-06-21 09:37:46.000000000 +0200
@@ -496,7 +496,8 @@ static int zfcp_fsf_exchange_config_eval
 
 	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval;
-	adapter->stat_read_buf_num = max(bottom->status_read_buf_num, (u16)16);
+	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
+					 (u16)FSF_STATUS_READS_RECOM);
 
 	if (fc_host_permanent_port_name(shost) == -1)
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);


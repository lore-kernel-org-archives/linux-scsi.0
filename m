From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/5] zfcp: Use status_read_buf_num provided by FCP channel
Date: Fri, 30 Apr 2010 18:09:36 +0200
Message-ID: <20100430161020.446172000@de.ibm.com>
References: <20100430160932.658896000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37092 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934254Ab0D3TTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:19:52 -0400
Content-Disposition: inline; filename=705-zfcp-status_read_buf_num.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The FCP channel provides the number of status read buffers to issue.
Use the provided number instead of the hardcoded number in zfcp.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_erp.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |    1 +
 drivers/s390/scsi/zfcp_fsf.h |    2 +-
 5 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2010-04-30 16:00:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2010-04-30 16:00:52.000000000 +0200
@@ -425,7 +425,8 @@ int zfcp_status_read_refill(struct zfcp_
 {
 	while (atomic_read(&adapter->stat_miss) > 0)
 		if (zfcp_fsf_status_read(adapter->qdio)) {
-			if (atomic_read(&adapter->stat_miss) >= 16) {
+			if (atomic_read(&adapter->stat_miss) >=
+			    adapter->stat_read_buf_num) {
 				zfcp_erp_adapter_reopen(adapter, 0, "axsref1",
 							NULL);
 				return 1;
--- a/drivers/s390/scsi/zfcp_def.h	2010-04-30 16:00:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2010-04-30 16:00:52.000000000 +0200
@@ -164,6 +164,7 @@ struct zfcp_adapter {
 						      stack abort/command
 						      completion races */
 	atomic_t		stat_miss;	   /* # missing status reads*/
+	unsigned int		stat_read_buf_num;
 	struct work_struct	stat_work;
 	atomic_t		status;	           /* status of this adapter */
 	struct list_head	erp_ready_head;	   /* error recovery for this
--- a/drivers/s390/scsi/zfcp_erp.c	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2010-04-30 16:00:52.000000000 +0200
@@ -714,7 +714,7 @@ static int zfcp_erp_adapter_strategy_ope
 	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
-	atomic_set(&act->adapter->stat_miss, 16);
+	atomic_set(&act->adapter->stat_miss, act->adapter->stat_read_buf_num);
 	if (zfcp_status_read_refill(act->adapter))
 		return ZFCP_ERP_FAILED;
 
--- a/drivers/s390/scsi/zfcp_fsf.c	2010-04-30 16:00:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-04-30 16:00:52.000000000 +0200
@@ -496,6 +496,7 @@ static int zfcp_fsf_exchange_config_eval
 
 	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval;
+	adapter->stat_read_buf_num = max(bottom->status_read_buf_num, (u16)16);
 
 	if (fc_host_permanent_port_name(shost) == -1)
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
--- a/drivers/s390/scsi/zfcp_fsf.h	2010-04-30 16:00:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2010-04-30 16:00:52.000000000 +0200
@@ -366,7 +366,7 @@ struct fsf_qtcb_bottom_config {
 	u32 adapter_type;
 	u8 res0;
 	u8 peer_d_id[3];
-	u8 res1[2];
+	u16 status_read_buf_num;
 	u16 timer_interval;
 	u8 res2[9];
 	u8 s_id[3];


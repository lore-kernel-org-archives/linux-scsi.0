From: michaelc@cs.wisc.edu
Subject: [PATCH 10/14] iscsi lib: remove qdepth param from iscsi host allocation
Date: Thu,  5 Mar 2009 14:46:04 -0600
Message-ID: <12362859771656-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
 <1236285975607-git-send-email-michaelc@cs.wisc.edu>
 <12362859763502-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52829 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbZCEUqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:22 -0500
In-Reply-To: <12362859763502-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The qdepth setting was useful when we needed libiscsi to verify
the setting. Now we just need to make sure if older tools
passed in zero then we need to set some default.

So this patch just has us use the sht->cmd_per_lun or if
for LLD does a host per session then we can set it on per
host basis.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c       |    5 ++---
 drivers/scsi/iscsi_tcp.c                 |    3 ++-
 drivers/scsi/libiscsi.c                  |   11 ++++-------
 include/scsi/libiscsi.h                  |    2 +-
 5 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index a50cd53..6c61ed1 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -404,7 +404,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct Scsi_Host *shost;
 	struct iser_conn *ib_conn;
 
-	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISER_DEF_CMD_PER_LUN, 1);
+	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, 1);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index f6ed9c6..307f55e 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -170,8 +170,7 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 	int err;
 
 	shost = iscsi_host_alloc(&cxgb3i_host_template,
-				 sizeof(struct cxgb3i_hba),
-				 CXGB3I_SCSI_QDEPTH_DFLT, 1);
+				 sizeof(struct cxgb3i_hba), 1);
 	if (!shost) {
 		cxgb3i_log_info("iscsi_host_alloc failed.\n");
 		return NULL;
@@ -843,7 +842,7 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.can_queue		= CXGB3I_SCSI_QDEPTH_DFLT - 1,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xFFFF,
-	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
+	.cmd_per_lun		= CXGB3I_SCSI_QDEPTH_DFLT,
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_target_reset,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 79a706a..ad8676c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -777,10 +777,11 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		return NULL;
 	}
 
-	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht, 0, qdepth, 1);
+	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht, 0, 1);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_sw_tcp_scsi_transport;
+	shost->cmd_per_lun = qdepth;
 	shost->max_lun = iscsi_max_lun;
 	shost->max_id = 0;
 	shost->max_channel = 0;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ff89154..d12f979 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2046,6 +2046,9 @@ int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
 	if (!shost->can_queue)
 		shost->can_queue = ISCSI_DEF_XMIT_CMDS_MAX;
 
+	if (!shost->cmd_per_lun)
+		shost->cmd_per_lun = ISCSI_DEF_CMD_PER_LUN;
+
 	if (!shost->transportt->eh_timed_out)
 		shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
 	return scsi_add_host(shost, pdev);
@@ -2056,15 +2059,13 @@ EXPORT_SYMBOL_GPL(iscsi_host_add);
  * iscsi_host_alloc - allocate a host and driver data
  * @sht: scsi host template
  * @dd_data_size: driver host data size
- * @qdepth: default device queue depth
  * @xmit_can_sleep: bool indicating if LLD will queue IO from a work queue
  *
  * This should be called by partial offload and software iscsi drivers.
  * To access the driver specific memory use the iscsi_host_priv() macro.
  */
 struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
-				   int dd_data_size, uint16_t qdepth,
-				   bool xmit_can_sleep)
+				   int dd_data_size, bool xmit_can_sleep)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_host *ihost;
@@ -2072,10 +2073,6 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	shost = scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_size);
 	if (!shost)
 		return NULL;
-
-	if (qdepth == 0)
-		qdepth = ISCSI_DEF_CMD_PER_LUN;
-	shost->cmd_per_lun = qdepth;
 	ihost = shost_priv(shost);
 
 	if (xmit_can_sleep) {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b0b8a69..84eded9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -346,7 +346,7 @@ extern int iscsi_host_get_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
 extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
 extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
-					  int dd_data_size, uint16_t qdepth,
+					  int dd_data_size,
 					  bool xmit_can_sleep);
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
-- 
1.6.0.6


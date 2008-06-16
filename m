From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] libiscsi, iscsi_tcp, ib_iser: fix setting of can_queue with old tools.
Date: Mon, 16 Jun 2008 10:11:33 -0500
Message-ID: <1213629095-5078-3-git-send-email-michaelc@cs.wisc.edu>
References: <1213629095-5078-1-git-send-email-michaelc@cs.wisc.edu>
 <1213629095-5078-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbYFPPL7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 11:11:59 -0400
In-Reply-To: <1213629095-5078-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch fixes two bugs that are related.

1. Old tools did not set can_queue/cmds_max. This patch modifies
libiscsi so that when we add the host we catch this and set it
to the default.

2. iscsi_tcp thought that the scsi command that was passed to
the eh functions needed a iscsi_cmd_task allocated for it. It
only needed a mgmt task, and now it does not matter since it
all comes from the same pool and libiscsi handles this for the
drivers. ib_iser had copied iscsi_tcp's code and set can_queue
to its max - 1 to handle this. So this patch removes the max -1,
and just sets it to the max.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 -
 drivers/scsi/iscsi_tcp.c                 |    1 -
 drivers/scsi/libiscsi.c                  |    6 ++++++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index c02eabd..a56931e 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -595,7 +595,6 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
 	.sg_tablesize           = ISCSI_ISER_SG_TABLESIZE,
 	.max_sectors		= 1024,
 	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 0bd8b3d..2a2f009 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1865,7 +1865,6 @@ iscsi_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	shost->max_id = 0;
 	shost->max_channel = 0;
 	shost->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
-	shost->can_queue = cmds_max;
 
 	if (iscsi_host_add(shost, NULL))
 		goto free_host;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 8b4e412..299e075 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1857,6 +1857,9 @@ EXPORT_SYMBOL_GPL(iscsi_pool_free);
  */
 int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev)
 {
+	if (!shost->can_queue)
+		shost->can_queue = ISCSI_DEF_XMIT_CMDS_MAX;
+
 	return scsi_add_host(shost, pdev);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_add);
@@ -1942,6 +1945,9 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
 	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+
+	if (!total_cmds)
+		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
 	/*
 	 * The iscsi layer needs some tasks for nop handling and tmfs,
 	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
-- 
1.5.4.1


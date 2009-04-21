From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] cxgb3i: fix can_queue and cmd_per_lun initialization
Date: Tue, 21 Apr 2009 15:32:33 -0500
Message-ID: <12403459572541-git-send-email-michaelc@cs.wisc.edu>
References: <1240345955183-git-send-email-michaelc@cs.wisc.edu>
 <1240345956764-git-send-email-michaelc@cs.wisc.edu>
 <1240345956886-git-send-email-michaelc@cs.wisc.edu>
 <12403459572661-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35811 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbZDUUck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2009 16:32:40 -0400
In-Reply-To: <12403459572661-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

cxgb3i was setting can_queue to only 128 commands, and was
setting the can_queue and cmd_per_lun to the same value.

This sets the can_queue to 1024 commands, and sets the cmd_per_lun
to a safer default of 32.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i.h       |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index d362860..59b0958 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -34,7 +34,7 @@
 #include "cxgb3i_offload.h"
 #include "cxgb3i_ddp.h"
 
-#define CXGB3I_SCSI_QDEPTH_DFLT	128
+#define CXGB3I_SCSI_HOST_QDEPTH 1024
 #define CXGB3I_MAX_TARGET	CXGB3I_MAX_CONN
 #define CXGB3I_MAX_LUN		512
 #define ISCSI_PDU_NONPAYLOAD_MAX \
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index b3ca3a0..9212400 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -876,10 +876,10 @@ static struct scsi_host_template cxgb3i_host_template = {
 	.proc_name		= "cxgb3i",
 	.queuecommand		= iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
-	.can_queue		= CXGB3I_SCSI_QDEPTH_DFLT - 1,
+	.can_queue		= CXGB3I_SCSI_HOST_QDEPTH,
 	.sg_tablesize		= SG_ALL,
 	.max_sectors		= 0xFFFF,
-	.cmd_per_lun		= CXGB3I_SCSI_QDEPTH_DFLT,
+	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler	= iscsi_eh_abort,
 	.eh_device_reset_handler = iscsi_eh_device_reset,
 	.eh_target_reset_handler = iscsi_eh_target_reset,
-- 
1.6.0.6


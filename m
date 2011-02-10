From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] libsrp: add srp_data_length helper function
Date: Thu, 10 Feb 2011 21:21:33 +0900
Message-ID: <1297340495-13347-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:49646 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab1BJM1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Feb 2011 07:27:07 -0500
In-Reply-To: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, fujita.tomonori@lab.ntt.co.jp

srp_data_length helper function returns the data transfer length from
an SRP_CMD request.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/libsrp.c |   12 +++---------
 include/scsi/libsrp.h |   10 +++++++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index ff6a28c..01c4010 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -30,13 +30,6 @@
 #include <scsi/srp.h>
 #include <scsi/libsrp.h>
 
-enum srp_task_attributes {
-	SRP_SIMPLE_TASK = 0,
-	SRP_HEAD_TASK = 1,
-	SRP_ORDERED_TASK = 2,
-	SRP_ACA_TASK = 4
-};
-
 /* tmp - will replace with SCSI logging stuff */
 #define eprintk(fmt, args...)					\
 do {								\
@@ -363,7 +356,7 @@ int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
 }
 EXPORT_SYMBOL_GPL(srp_transfer_data);
 
-static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
+int srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 {
 	struct srp_direct_buf *md;
 	struct srp_indirect_buf *id;
@@ -394,6 +387,7 @@ static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
 	}
 	return len;
 }
+EXPORT_SYMBOL_GPL(srp_data_length);
 
 int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 		  u64 itn_id, u64 addr)
@@ -418,7 +412,7 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 	}
 
 	dir = srp_cmd_direction(cmd);
-	len = vscsis_data_length(cmd, dir);
+	len = srp_data_length(cmd, dir);
 
 	dprintk("%p %x %lx %d %d %d %llx\n", info, cmd->cdb[0],
 		cmd->lun, dir, len, tag, (unsigned long long) cmd->tag);
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
index f4105c9..f5ebdbf 100644
--- a/include/scsi/libsrp.h
+++ b/include/scsi/libsrp.h
@@ -7,6 +7,13 @@
 #include <scsi/scsi_host.h>
 #include <scsi/srp.h>
 
+enum srp_task_attributes {
+	SRP_SIMPLE_TASK = 0,
+	SRP_HEAD_TASK = 1,
+	SRP_ORDERED_TASK = 2,
+	SRP_ACA_TASK = 4
+};
+
 enum iue_flags {
 	V_DIOVER,
 	V_WRITE,
@@ -64,7 +71,6 @@ extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64)
 extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
 			     srp_rdma_t, int, int);
 
-
 static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
 {
 	return (struct srp_target *) host->hostdata;
@@ -75,4 +81,6 @@ static inline int srp_cmd_direction(struct srp_cmd *cmd)
 	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 }
 
+extern int srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir);
+
 #endif
-- 
1.7.2.3


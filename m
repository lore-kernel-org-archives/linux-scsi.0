From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/12] libfc,
 tcm_fc: add ddp_targ() to libfc function template to supprot FCoE DDP
 in target mode
Date: Mon, 20 Jun 2011 16:30:23 -0700
Message-ID: <20110620233023.31635.10039.stgit@localhost6.localdomain6>
References: <20110620233007.31635.60206.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53850 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab1FTXaY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:30:24 -0400
In-Reply-To: <20110620233007.31635.60206.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

The fcoe driver can implement ddp_targ() similarly to ddp_setup() when fcoe
stack works with existing target frame, e.g., tcm, where the ddp_targ() would
eventually point to the underlying hardware driver's implementation of
ndo_fcoe_ddp_targ() through net_device_ops. This new API sets up DDP context
for target appropriately by setting required bits for DDP context.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |    5 +++--
 include/scsi/libfc.h            |    8 ++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index c056a11..1625b48 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -289,8 +289,9 @@ int ft_write_pending(struct se_cmd *se_cmd)
 				cmd->sg_cnt =
 					T_TASK(se_cmd)->t_tasks_sg_chained_no;
 			}
-			if (cmd->sg && lport->tt.ddp_setup(lport, ep->xid,
-						    cmd->sg, cmd->sg_cnt))
+			if (cmd->sg && lport->tt.ddp_target(lport, ep->xid,
+							    cmd->sg,
+							    cmd->sg_cnt))
 				cmd->was_ddp_setup = 1;
 		}
 	}
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index a3cbda4..7d96829 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -511,6 +511,14 @@ struct libfc_function_template {
 	 */
 	int (*ddp_done)(struct fc_lport *, u16);
 	/*
+	 * Sets up the DDP context for a given exchange id on the given
+	 * scatterlist if LLD supports DDP for FCoE target.
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	int (*ddp_target)(struct fc_lport *, u16, struct scatterlist *,
+			  unsigned int);
+	/*
 	 * Allow LLD to fill its own Link Error Status Block
 	 *
 	 * STATUS: OPTIONAL


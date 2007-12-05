From: michaelc@cs.wisc.edu
Subject: [PATCH 20/23] iscsi_tcp: enable sg chaining
Date: Tue,  4 Dec 2007 18:42:34 -0600
Message-ID: <11968153883385-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
 <11968153831244-git-send-email-michaelc@cs.wisc.edu>
 <11968153842186-git-send-email-michaelc@cs.wisc.edu>
 <11968153853971-git-send-email-michaelc@cs.wisc.edu>
 <1196815386656-git-send-email-michaelc@cs.wisc.edu>
 <11968153873372-git-send-email-michaelc@cs.wisc.edu>
 <11968153871693-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbXLEAnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:13 -0500
In-Reply-To: <11968153871693-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The previous patches converted iscsi_tcp to support sg chaining.
This patch sets the proper flags and sets sg_table size to
4096. This allows fs io to be capped at max_sectors, but passthrough
IO to be limited by some other part of the kernel.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |    5 +++--
 drivers/scsi/iscsi_tcp.h |    3 ---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 65df908..84c4a50 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1928,13 +1928,14 @@ static struct scsi_host_template iscsi_sht = {
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
-	.sg_tablesize		= ISCSI_SG_TABLESIZE,
+	.sg_tablesize		= 4096,
 	.max_sectors		= 0xFFFF,
 	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
 	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
+	.use_sg_chaining	= ENABLE_SG_CHAINING,
 	.slave_configure        = iscsi_tcp_slave_configure,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
@@ -1974,7 +1975,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
-	.max_cmd_len		= ISCSI_TCP_MAX_CMD_LEN,
+	.max_cmd_len		= 16,
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index 893cd2e..ed0b991 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -24,9 +24,6 @@
 
 #include <scsi/libiscsi.h>
 
-#define ISCSI_SG_TABLESIZE		SG_ALL
-#define ISCSI_TCP_MAX_CMD_LEN		16
-
 struct crypto_hash;
 struct socket;
 struct iscsi_tcp_conn;
-- 
1.5.1.2


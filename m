From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 1/2] target: Avoid DataIN transfers for non-GOOD SAM status
Date: Sat,  5 Mar 2016 07:07:13 +0000
Message-ID: <1457161634-15756-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35486 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcCEHLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2016 02:11:19 -0500
Received: by mail-ob0-f178.google.com with SMTP id xx9so68525029obc.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Mar 2016 23:11:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch modifies existing transport_complete_*() code
to avoid invoking target_core_fabric_ops->queue_data_in()
driver callbacks for I/O READs with non-GOOD SAM status.

Some initiators expect GOOD status when a DATA-IN payload
transfer is involved, so to be safe go ahead and always
invoke target_core_fabric_ops->queue_status() to generate
fabric responses instead.

Note this is a prerequisite for IBLOCK supporting retriable
status, so SAM_STAT_BUSY + SAM_STAT_TASK_SET_FULL always
generates fabric driver responses instead of initiating
DataIN payload transfer when non-GOOD status is present

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f5ad9e0..784dd22 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1997,6 +1997,9 @@ static void transport_complete_qf(struct se_cmd *cmd)
 
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
+		if (cmd->scsi_status)
+			goto queue_status;
+
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_data_in(cmd);
 		break;
@@ -2007,6 +2010,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		}
 		/* Fall through for DMA_TO_DEVICE */
 	case DMA_NONE:
+queue_status:
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
 		break;
@@ -2128,6 +2132,9 @@ static void target_complete_ok_work(struct work_struct *work)
 queue_rsp:
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
+		if (cmd->scsi_status)
+			goto queue_status;
+
 		atomic_long_add(cmd->data_length,
 				&cmd->se_lun->lun_stats.tx_data_octets);
 		/*
@@ -2167,6 +2174,7 @@ queue_rsp:
 		}
 		/* Fall through for DMA_TO_DEVICE */
 	case DMA_NONE:
+queue_status:
 		trace_target_cmd_complete(cmd);
 		ret = cmd->se_tfo->queue_status(cmd);
 		if (ret == -EAGAIN || ret == -ENOMEM)
-- 
1.9.1


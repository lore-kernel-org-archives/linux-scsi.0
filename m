From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/3] target: simplify cmd to task mapping
Date: Wed, 17 Nov 2010 16:41:52 -0800
Message-ID: <1290040912.31890.93.camel@haakon2.linux-iscsi.org>
References: <20101117213857.GB26557@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37249 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab0KRArP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 19:47:15 -0500
In-Reply-To: <20101117213857.GB26557@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-11-17 at 16:38 -0500, Christoph Hellwig wrote:
> The cmd to task mapping is almost the same for all control CDBs,
> except for calling different backend methods to do the backed-specific
> mapping.  Merge the code performing the mapping into a single
> new transport_map_control_cmd_to_task helper, and kill the
> transport_map_task callback by simplify calling the backend methods
> directly for the single task for a control CDB, and hardcoding
> ->map_task_SG for data CDBs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: lio-core/drivers/target/target_core_transport.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_transport.c	2010-11-16 18:55:26.414004751 +0100
> +++ lio-core/drivers/target/target_core_transport.c	2010-11-16 18:55:30.075004681 +0100

>  
> +static int
> +transport_map_control_cmd_to_task(struct se_cmd *cmd,
> +		struct se_transform_info *ti)
> +{
> +	struct se_device *dev = SE_DEV(cmd);
> +	unsigned char *cdb;
> +	struct se_task *task;
> +	int ret;
> +
> +	task = transport_generic_get_task(ti, cmd, ti->se_obj_ptr,
> +				  cmd->data_direction);
> +	if (!task)
> +		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +
> +	cdb = TRANSPORT(dev)->get_cdb(task);
> +	if (cdb)
> +		memcpy(cdb, cmd->t_task->t_task_cdb,
> +			scsi_command_size(cmd->t_task->t_task_cdb));
> +
> +	task->task_size = cmd->data_length;
> +	task->task_sg_num =
> +		(cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) ? 1 : 0;
> +
> +	atomic_inc(&cmd->t_task->t_fe_count);
> +	atomic_inc(&cmd->t_task->t_se_count);
> +
> +	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
> +		struct se_mem *se_mem, *se_mem_lout = NULL;
> +		u32 se_mem_cnt = 0, task_offset = 0;
> +
> +		BUG_ON(list_empty(cmd->t_task->t_mem_list));
> +
> +		ret = transport_do_se_mem_map(dev, task,
> +				cmd->t_task->t_mem_list, NULL, se_mem,
> +				&se_mem_lout, &se_mem_cnt, &task_offset);
> +		if (ret < 0)
> +			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +
> +		if (dev->transport->map_task_SG)
> +			return dev->transport->map_task_SG(task);
> +		return 0;
> +	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
> +		if (dev->transport->map_task_non_SG(task))

While testing this code I ran into this bogus conditional check here..

> +			return dev->transport->map_task_non_SG(task);
> +		return 0;
> +	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
> +		if (dev->transport->cdb_none(task))

and again here..

> +			return dev->transport->cdb_none(task);
> +		return 0;
> +	} else {
> +		BUG();
> +		return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
> +	}
> +}
> +

Committed as the following patch and pushed to lio-core-2.6.git.

>From a342e38f5a3fa8a4c796cd1d96d8ee5074cdf945 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 17 Nov 2010 16:28:21 -0800
Subject: [PATCH] target: Fix up function pointer conditionals in transport_map_control_cmd_to_task()

This patch fixes up a cut and past bug that was added with commit f71d81ec15 where
*task where being incorrectly passed into dev->transport->map_task_non_SG
and dev->transport->cdb_none during the preceeding function pointer conditional.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1d9209a..b50b75e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5762,7 +5762,7 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd,
        atomic_inc(&cmd->t_task->t_se_count);

        if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
-               struct se_mem *se_mem, *se_mem_lout = NULL;
+               struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
                u32 se_mem_cnt = 0, task_offset = 0;

                BUG_ON(list_empty(cmd->t_task->t_mem_list));
@@ -5777,11 +5777,11 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd,
                        return dev->transport->map_task_SG(task);
                return 0;
        } else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-               if (dev->transport->map_task_non_SG(task))
+               if (dev->transport->map_task_non_SG)
                        return dev->transport->map_task_non_SG(task);
                return 0;
        } else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
-               if (dev->transport->cdb_none(task))
+               if (dev->transport->cdb_none)
                        return dev->transport->cdb_none(task);
                return 0;
        } else {
-- 
1.5.6.5



From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 030/103] target: Remove unneeded casts to void*
Date: Thu, 21 Jul 2011 00:05:06 -0700
Message-ID: <1311231979-6631-31-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:40279 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752380Ab1GUHH1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:27 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |   12 ++++++------
 drivers/target/target_core_configfs.c  |    4 ++--
 drivers/target/target_core_file.c      |    2 +-
 drivers/target/target_core_iblock.c    |    6 +++---
 drivers/target/target_core_pscsi.c     |   10 +++++-----
 drivers/target/target_core_rd.c        |    4 ++--
 drivers/target/target_core_transport.c |    8 ++++----
 drivers/target/tcm_fc/tfc_conf.c       |    2 +-
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 1f1695a..e1d17b9 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -171,7 +171,7 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 	 */
 	if (scsi_sg_count(sc)) {
 		se_cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM;
-		mem_ptr = (void *)scsi_sglist(sc);
+		mem_ptr = scsi_sglist(sc);
 		/*
 		 * For BIDI commands, pass in the extra READ buffer
 		 * to transport_generic_map_mem_to_cmd() below..
@@ -179,7 +179,7 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 		if (se_cmd->t_task->t_tasks_bidi) {
 			struct scsi_data_buffer *sdb = scsi_in(sc);
 
-			mem_bidi_ptr = (void *)sdb->table.sgl;
+			mem_bidi_ptr = sdb->table.sgl;
 			sg_no_bidi = sdb->table.nents;
 		}
 	} else {
@@ -384,7 +384,7 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	/*
 	 * Allocate the LUN_RESET TMR
 	 */
-	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, (void *)tl_tmr,
+	se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd, tl_tmr,
 				TMR_LUN_RESET);
 	if (IS_ERR(se_cmd->se_tmr_req))
 		goto release;
@@ -904,7 +904,7 @@ static int tcm_loop_queue_status(struct se_cmd *se_cmd)
 	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
 	    (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
 
-		memcpy((void *)sc->sense_buffer, (void *)se_cmd->sense_buffer,
+		memcpy(sc->sense_buffer, se_cmd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE);
 		sc->result = SAM_STAT_CHECK_CONDITION;
 		set_driver_byte(sc, DRIVER_SENSE);
@@ -1054,7 +1054,7 @@ static int tcm_loop_make_nexus(
 	 * transport_register_session()
 	 */
 	__transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
-			tl_nexus->se_sess, (void *)tl_nexus);
+			tl_nexus->se_sess, tl_nexus);
 	tl_tpg->tl_hba->tl_nexus = tl_nexus;
 	printk(KERN_INFO "TCM_Loop_ConfigFS: Established I_T Nexus to emulated"
 		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
@@ -1242,7 +1242,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
 	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
 	 */
 	ret = core_tpg_register(&tcm_loop_fabric_configfs->tf_ops,
-			wwn, &tl_tpg->tl_se_tpg, (void *)tl_tpg,
+			wwn, &tl_tpg->tl_se_tpg, tl_tpg,
 			TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 64418ef..ac7f765 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2037,7 +2037,7 @@ static ssize_t target_core_dev_show(struct config_item *item,
 	if (!(tc_attr->show))
 		return -EINVAL;
 
-	return tc_attr->show((void *)se_dev, page);
+	return tc_attr->show(se_dev, page);
 }
 
 static ssize_t target_core_dev_store(struct config_item *item,
@@ -2053,7 +2053,7 @@ static ssize_t target_core_dev_store(struct config_item *item,
 	if (!(tc_attr->store))
 		return -EINVAL;
 
-	return tc_attr->store((void *)se_dev, page, count);
+	return tc_attr->store(se_dev, page, count);
 }
 
 static struct configfs_item_operations target_core_dev_item_ops = {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 0c44bc0..46825ce 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -223,7 +223,7 @@ static struct se_device *fd_create_virtdevice(
 	dev_limits.queue_depth = FD_DEVICE_QUEUE_DEPTH;
 
 	dev = transport_add_device_to_core_hba(hba, &fileio_template,
-				se_dev, dev_flags, (void *)fd_dev,
+				se_dev, dev_flags, fd_dev,
 				&dev_limits, "FILEIO", FD_VERSION);
 	if (!(dev))
 		goto fail;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index fb15987..b0bafe4 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -74,7 +74,7 @@ static int iblock_attach_hba(struct se_hba *hba, u32 host_id)
 
 	ib_host->iblock_host_id = host_id;
 
-	hba->hba_ptr = (void *) ib_host;
+	hba->hba_ptr = ib_host;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM iBlock HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
@@ -172,7 +172,7 @@ static struct se_device *iblock_create_virtdevice(
 	ib_dev->ibd_bd = bd;
 
 	dev = transport_add_device_to_core_hba(hba,
-			&iblock_template, se_dev, dev_flags, (void *)ib_dev,
+			&iblock_template, se_dev, dev_flags, ib_dev,
 			&dev_limits, "IBLOCK", IBLOCK_VERSION);
 	if (!(dev))
 		goto failed;
@@ -593,7 +593,7 @@ static struct bio *iblock_get_bio(
 	DEBUG_IBLOCK("Allocated bio: %p task_size: %u\n", bio, task->task_size);
 
 	bio->bi_bdev = ib_dev->ibd_bd;
-	bio->bi_private = (void *) task;
+	bio->bi_private = task;
 	bio->bi_destructor = iblock_bio_destructor;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_sector = lba;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 44a79a5..823da67 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -72,7 +72,7 @@ static int pscsi_attach_hba(struct se_hba *hba, u32 host_id)
 	phv->phv_host_id = host_id;
 	phv->phv_mode = PHV_VIRUTAL_HOST_ID;
 
-	hba->hba_ptr = (void *)phv;
+	hba->hba_ptr = phv;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM SCSI HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
@@ -355,7 +355,7 @@ static struct se_device *pscsi_add_device_to_list(
 	pdv->pdv_sd = sd;
 
 	dev = transport_add_device_to_core_hba(hba, &pscsi_template,
-				se_dev, dev_flags, (void *)pdv,
+				se_dev, dev_flags, pdv,
 				&dev_limits, NULL, NULL);
 	if (!(dev)) {
 		pdv->pdv_sd = NULL;
@@ -394,7 +394,7 @@ static void *pscsi_allocate_virtdevice(struct se_hba *hba, const char *name)
 	pdv->pdv_se_hba = hba;
 
 	printk(KERN_INFO "PSCSI: Allocated pdv: %p for %s\n", pdv, name);
-	return (void *)pdv;
+	return pdv;
 }
 
 /*
@@ -812,7 +812,7 @@ static inline void pscsi_blk_init_request(
 	 * also set the end_io_data pointer.to struct se_task.
 	 */
 	req->end_io = pscsi_req_done;
-	req->end_io_data = (void *)task;
+	req->end_io_data = task;
 	/*
 	 * Load the referenced struct se_task's SCSI CDB into
 	 * include/linux/blkdev.h:struct request->cmd
@@ -822,7 +822,7 @@ static inline void pscsi_blk_init_request(
 	/*
 	 * Setup pointer for outgoing sense data.
 	 */
-	req->sense = (void *)&pt->pscsi_sense[0];
+	req->sense = &pt->pscsi_sense[0];
 	req->sense_len = 0;
 }
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index fbf06c3..63cd5a7 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -66,7 +66,7 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 
 	rd_host->rd_host_id = host_id;
 
-	hba->hba_ptr = (void *) rd_host;
+	hba->hba_ptr = rd_host;
 
 	printk(KERN_INFO "CORE_HBA[%d] - TCM Ramdisk HBA Driver %s on"
 		" Generic Target Core Stack %s\n", hba->hba_id,
@@ -271,7 +271,7 @@ static struct se_device *rd_create_virtdevice(
 
 	dev = transport_add_device_to_core_hba(hba,
 			(rd_dev->rd_direct) ? &rd_dr_template :
-			&rd_mcp_template, se_dev, dev_flags, (void *)rd_dev,
+			&rd_mcp_template, se_dev, dev_flags, rd_dev,
 			&dev_limits, prod, rev);
 	if (!(dev))
 		goto fail;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6f5d4df..6198a7e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -201,7 +201,7 @@ struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 typedef int (*map_func_t)(struct se_task *, u32);
 
 static int transport_generic_write_pending(struct se_cmd *);
-static int transport_processing_thread(void *);
+static int transport_processing_thread(void *param);
 static int __transport_execute_tasks(struct se_device *dev);
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_direct_request_timeout(struct se_cmd *cmd);
@@ -1548,7 +1548,7 @@ struct se_device *transport_add_device_to_core_hba(
 	transport_init_queue_obj(&dev->dev_queue_obj);
 	dev->dev_flags		= device_flags;
 	dev->dev_status		|= TRANSPORT_DEVICE_DEACTIVATED;
-	dev->dev_ptr		= (void *) transport_dev;
+	dev->dev_ptr		= transport_dev;
 	dev->se_hba		= hba;
 	dev->se_sub_dev		= se_dev;
 	dev->transport		= transport;
@@ -2908,7 +2908,7 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 		offset = cmd->se_tfo->set_fabric_sense_len(cmd,
 				TRANSPORT_SENSE_BUFFER);
 
-		memcpy((void *)&buffer[offset], (void *)sense_buffer,
+		memcpy(&buffer[offset], sense_buffer,
 				TRANSPORT_SENSE_BUFFER);
 		cmd->scsi_status = task->task_scsi_status;
 		/* Automatically padded */
@@ -5379,7 +5379,7 @@ int transport_clear_lun_from_sessions(struct se_lun *lun)
 {
 	struct task_struct *kt;
 
-	kt = kthread_run(transport_clear_lun_thread, (void *)lun,
+	kt = kthread_run(transport_clear_lun_thread, lun,
 			"tcm_cl_%u", lun->unpacked_lun);
 	if (IS_ERR(kt)) {
 		printk(KERN_ERR "Unable to start clear_lun thread\n");
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 8c5067c..58e4745 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -331,7 +331,7 @@ static struct se_portal_group *ft_add_tpg(
 	transport_init_queue_obj(&tpg->qobj);
 
 	ret = core_tpg_register(&ft_configfs->tf_ops, wwn, &tpg->se_tpg,
-				(void *)tpg, TRANSPORT_TPG_TYPE_NORMAL);
+				tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
-- 
1.7.6


From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Push down iovec allocation into iSCSI target code
Date: Wed, 17 Nov 2010 16:47:46 -0800
Message-ID: <1290041266-5017-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm25.bullet.mail.ac4.yahoo.com ([98.139.52.222]:36782 "HELO
	nm25.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753210Ab0KRArx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 19:47:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves se_cmd->[iov_data,iov_data_count,orig_iov_data_count]
to iscsi_cmd_t, and adds a iscsi_allocate_iovecs_for_cmd() use by
struct target_core_fabric_ops->alloc_iovecs_for_cmd() that setup
the iovecs following existing code.

This patch also changes reference in a number of locations in iscsi_target.c
and iscsi_target_util.c code, and adds the kfree(cmd->iov_data) in
iscsi_release_cmd_direct() and __iscsi_release_cmd_to_pool().

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target.c          |   31 +++++++-------
 drivers/target/lio-target/iscsi_target_configfs.c |    6 ++-
 drivers/target/lio-target/iscsi_target_core.h     |    5 ++
 drivers/target/lio-target/iscsi_target_util.c     |   28 ++++++++++--
 drivers/target/lio-target/iscsi_target_util.h     |    1 +
 drivers/target/target_core_device.c               |    1 -
 drivers/target/target_core_transport.c            |   47 ---------------------
 include/target/target_core_base.h                 |    6 ---
 include/target/target_core_transport.h            |    1 -
 9 files changed, 49 insertions(+), 77 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target.c b/drivers/target/lio-target/iscsi_target.c
index b7e5897..dec614c 100644
--- a/drivers/target/lio-target/iscsi_target.c
+++ b/drivers/target/lio-target/iscsi_target.c
@@ -1652,6 +1652,7 @@ static int iscsi_set_iovec_ptrs(
 	u32 orig_map_length = map_sg->data_length;
 #endif
 	struct se_cmd *cmd = map_sg->se_cmd;
+	struct iscsi_cmd *i_cmd = container_of(cmd, struct iscsi_cmd, se_cmd);
 	struct se_offset_map *lmap = &unmap_sg->lmap;
 	struct iovec *iov = map_sg->iov;
 
@@ -1693,9 +1694,9 @@ static int iscsi_set_iovec_ptrs(
 	lmap->map_se_mem = lmap->map_orig_se_mem;
 
 	DEBUG_IOVEC_SCATTERLISTS("OS_IOVEC: Total map_sg->data_length: %d,"
-		" lmap->iscsi_offset: %d, cmd->orig_iov_data_count: %d\n",
+		" lmap->iscsi_offset: %d, i_cmd->orig_iov_data_count: %d\n",
 		map_sg->data_length, lmap->iscsi_offset,
-		cmd->orig_iov_data_count);
+		i_cmd->orig_iov_data_count);
 
 	while (map_sg->data_length) {
 		/*
@@ -1732,10 +1733,10 @@ static int iscsi_set_iovec_ptrs(
 			map_sg->data_length + iov[i].iov_len,
 			map_sg->data_length);
 
-		if ((++i + 1) > cmd->orig_iov_data_count) {
+		if ((++i + 1) > i_cmd->orig_iov_data_count) {
 			printk(KERN_ERR "Current iovec count %u is greater than"
 				" struct se_cmd->orig_data_iov_count %u, cannot"
-				" continue.\n", i+1, cmd->orig_iov_data_count);
+				" continue.\n", i+1, i_cmd->orig_iov_data_count);
 			return -1;
 		}
 
@@ -2362,7 +2363,7 @@ static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsigned char *
 		return -1;
 
 	rx_size += hdr->length;
-	iov = &SE_CMD(cmd)->iov_data[0];
+	iov = &cmd->iov_data[0];
 
 	memset((void *)&map_sg, 0, sizeof(struct se_map_sg));
 	memset((void *)&unmap_sg, 0, sizeof(struct se_unmap_sg));
@@ -2397,7 +2398,7 @@ static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsigned char *
 
 	iscsi_map_SG_segments(&unmap_sg);
 
-	rx_got = rx_data(conn, &SE_CMD(cmd)->iov_data[0], iov_count, rx_size);
+	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
 
 	iscsi_unmap_SG_segments(&unmap_sg);
 
@@ -2406,7 +2407,7 @@ static inline int iscsi_handle_data_out(struct iscsi_conn *conn, unsigned char *
 
 	if (CONN_OPS(conn)->DataDigest) {
 		__u32 counter = hdr->length, data_crc = 0;
-		struct iovec *iov_ptr = &SE_CMD(cmd)->iov_data[0];
+		struct iovec *iov_ptr = &cmd->iov_data[0];
 		struct scatterlist sg;
 		/*
 		 * Thanks to the IP stack shitting on passed iovecs,  we have to
@@ -3395,7 +3396,7 @@ static int iscsi_handle_immediate_data(
 	map_sg.fabric_cmd = (void *)cmd;
 	map_sg.se_cmd = SE_CMD(cmd);
 	map_sg.sg_kmap_active = 1;
-	map_sg.iov = &SE_CMD(cmd)->iov_data[0];
+	map_sg.iov = &cmd->iov_data[0];
 	map_sg.data_length = length;
 	map_sg.data_offset = cmd->write_data_done;
 	unmap_sg.fabric_cmd = (void *)cmd;
@@ -3407,7 +3408,7 @@ static int iscsi_handle_immediate_data(
 
 	rx_size = length;
 	iov_count = iov_ret;
-	iov = &SE_CMD(cmd)->iov_data[0];
+	iov = &cmd->iov_data[0];
 
 	padding = ((-length) & 3);
 	if (padding != 0) {
@@ -3424,7 +3425,7 @@ static int iscsi_handle_immediate_data(
 
 	iscsi_map_SG_segments(&unmap_sg);
 
-	rx_got = rx_data(conn, &SE_CMD(cmd)->iov_data[0], iov_count, rx_size);
+	rx_got = rx_data(conn, &cmd->iov_data[0], iov_count, rx_size);
 
 	iscsi_unmap_SG_segments(&unmap_sg);
 
@@ -3435,7 +3436,7 @@ static int iscsi_handle_immediate_data(
 
 	if (CONN_OPS(conn)->DataDigest) {
 		__u32 counter = length, data_crc;
-		struct iovec *iov_ptr = &SE_CMD(cmd)->iov_data[0];
+		struct iovec *iov_ptr = &cmd->iov_data[0];
 		struct scatterlist sg;
 		/*
 		 * Thanks to the IP stack shitting on passed iovecs,  we have to
@@ -3854,7 +3855,7 @@ static inline int iscsi_send_data_in(
 	hdr->data_sn		= cpu_to_be32(datain.data_sn);
 	hdr->offset		= cpu_to_be32(datain.offset);
 
-	iov = &SE_CMD(cmd)->iov_data[0];
+	iov = &cmd->iov_data[0];
 	iov[iov_count].iov_base	= cmd->pdu;
 	iov[iov_count++].iov_len	= ISCSI_HDR_LEN;
 	tx_size += ISCSI_HDR_LEN;
@@ -3879,7 +3880,7 @@ static inline int iscsi_send_data_in(
 	map_sg.fabric_cmd = (void *)cmd;
 	map_sg.se_cmd = SE_CMD(cmd);
 	map_sg.sg_kmap_active = 1;
-	map_sg.iov = &SE_CMD(cmd)->iov_data[1];
+	map_sg.iov = &cmd->iov_data[1];
 	map_sg.data_length = datain.length;
 	map_sg.data_offset = datain.offset;
 
@@ -3909,7 +3910,7 @@ static inline int iscsi_send_data_in(
 	}
 	if (CONN_OPS(conn)->DataDigest) {
 		__u32 counter = (datain.length + unmap_sg->padding);
-		struct iovec *iov_ptr = &SE_CMD(cmd)->iov_data[1];
+		struct iovec *iov_ptr = &cmd->iov_data[1];
 
 		crypto_hash_init(&conn->conn_tx_hash);
 
@@ -3936,7 +3937,7 @@ static inline int iscsi_send_data_in(
 			cmd->data_crc);
 	}
 
-	SE_CMD(cmd)->iov_data_count = iov_count;
+	cmd->iov_data_count = iov_count;
 	cmd->tx_size = tx_size;
 
 	TRACE(TRACE_ISCSI, "Built DataIN ITT: 0x%08x, StatSN: 0x%08x,"
diff --git a/drivers/target/lio-target/iscsi_target_configfs.c b/drivers/target/lio-target/iscsi_target_configfs.c
index 5eb04b4..76ee4fc 100644
--- a/drivers/target/lio-target/iscsi_target_configfs.c
+++ b/drivers/target/lio-target/iscsi_target_configfs.c
@@ -1458,9 +1458,11 @@ int iscsi_target_register_configfs(void)
 	fabric->tf_ops.tpg_release_fabric_acl = &lio_tpg_release_fabric_acl;
 	fabric->tf_ops.tpg_get_inst_index = &lio_tpg_get_inst_index;
 	/*
-	 * Use transport_generic_allocate_iovecs from target_core_mod
+	 * Use our local iscsi_allocate_iovecs_for_cmd() for the extra
+	 * callback in transport_generic_new_cmd() to allocate
+	 * iscsi_cmd->iov_data[] for Linux/Net kernel sockets operations.
 	 */
-	fabric->tf_ops.alloc_cmd_iovecs = &transport_generic_allocate_iovecs;
+	fabric->tf_ops.alloc_cmd_iovecs = &iscsi_allocate_iovecs_for_cmd;
 	fabric->tf_ops.release_cmd_to_pool = &lio_release_cmd_to_pool;
 	fabric->tf_ops.release_cmd_direct = &lio_release_cmd_direct;
 	fabric->tf_ops.shutdown_session = &lio_tpg_shutdown_session;
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 859f17b..f004d24 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -401,6 +401,9 @@ struct iscsi_cmd {
 	u32			outstanding_r2ts;
 	/* Next R2T Offset when DataSequenceInOrder=Yes */
 	u32			r2t_offset;
+	/* Iovec current and orig count for iscsi_cmd->iov_data */
+	u32			iov_data_count;
+	u32			orig_iov_data_count;
 	/* Number of miscellaneous iovecs used for IP stack calls */
 	u32			iov_misc_count;
 	/* Bytes used for 32-bit word padding */
@@ -459,6 +462,8 @@ struct iscsi_cmd {
 	struct semaphore	unsolicited_data_sem;
 	/* Timer for DataOUT */
 	struct timer_list	dataout_timer;
+	/* Iovecs for SCSI data payload RX/TX w/ kernel level sockets */
+	struct iovec		*iov_data;
 	/* Iovecs for miscellaneous purposes */
 	struct iovec		iov_misc[ISCSI_MISC_IOVECS];
 	/* Array of struct iscsi_pdu used for DataPDUInOrder=No */
diff --git a/drivers/target/lio-target/iscsi_target_util.c b/drivers/target/lio-target/iscsi_target_util.c
index c9b3742..5a43f70 100644
--- a/drivers/target/lio-target/iscsi_target_util.c
+++ b/drivers/target/lio-target/iscsi_target_util.c
@@ -1018,6 +1018,7 @@ void iscsi_release_cmd_direct(struct iscsi_cmd *cmd)
 	kfree(cmd->pdu_list);
 	kfree(cmd->seq_list);
 	kfree(cmd->tmr_req);
+	kfree(cmd->iov_data);
 
 	kmem_cache_free(lio_cmd_cache, cmd);
 }
@@ -1044,6 +1045,7 @@ void __iscsi_release_cmd_to_pool(struct iscsi_cmd *cmd, struct iscsi_session *se
 	kfree(cmd->pdu_list);
 	kfree(cmd->seq_list);
 	kfree(cmd->tmr_req);
+	kfree(cmd->iov_data);
 
 	if (conn)
 		iscsi_remove_cmd_from_tx_queues(cmd, conn);
@@ -2041,6 +2043,22 @@ void iscsi_stop_nopin_timer(struct iscsi_conn *conn)
 	spin_unlock_bh(&conn->nopin_timer_lock);
 }
 
+int iscsi_allocate_iovecs_for_cmd(struct se_cmd *se_cmd)
+{
+	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
+	u32 iov_count = (T_TASK(se_cmd)->t_tasks_se_num == 0) ? 1 :
+				T_TASK(se_cmd)->t_tasks_se_num;
+	
+	iov_count += TRANSPORT_IOV_DATA_BUFFER;
+
+	cmd->iov_data = kzalloc(iov_count * sizeof(struct iovec), GFP_KERNEL);
+	if (!(cmd->iov_data))
+		return -ENOMEM;
+	
+	cmd->orig_iov_data_count = iov_count;
+	return 0;
+}
+
 /*	iscsi_send_tx_data():
  *
  *
@@ -2058,8 +2076,8 @@ send_data:
 	tx_size = cmd->tx_size;
 
 	if (!use_misc) {
-		iov = &SE_CMD(cmd)->iov_data[0];
-		iov_count = SE_CMD(cmd)->iov_data_count;
+		iov = &cmd->iov_data[0];
+		iov_count = cmd->iov_data_count;
 	} else {
 		iov = &cmd->iov_misc[0];
 		iov_count = cmd->iov_misc_count;
@@ -2086,7 +2104,7 @@ int iscsi_fe_sendpage_sg(
 	struct iscsi_cmd *cmd = (struct iscsi_cmd *)u_sg->fabric_cmd;
 	struct se_cmd *se_cmd = SE_CMD(cmd);
 	u32 len = cmd->tx_size, pg_len, se_len, se_off, tx_size;
-	struct iovec *iov = &se_cmd->iov_data[0];
+	struct iovec *iov = &cmd->iov_data[0];
 	struct page *page;
 	struct se_mem *se_mem = u_sg->cur_se_mem;
 
@@ -2196,7 +2214,7 @@ send_pg:
 send_padding:
 	if (u_sg->padding) {
 		struct iovec *iov_p =
-			&se_cmd->iov_data[se_cmd->iov_data_count-2];
+			&cmd->iov_data[cmd->iov_data_count-2];
 
 		tx_sent = tx_data(conn, iov_p, 1, u_sg->padding);
 		if (u_sg->padding != tx_sent) {
@@ -2211,7 +2229,7 @@ send_padding:
 send_datacrc:
 	if (CONN_OPS(conn)->DataDigest) {
 		struct iovec *iov_d =
-			&se_cmd->iov_data[se_cmd->iov_data_count-1];
+			&cmd->iov_data[cmd->iov_data_count-1];
 
 		tx_sent = tx_data(conn, iov_d, 1, CRC_LEN);
 		if (CRC_LEN != tx_sent) {
diff --git a/drivers/target/lio-target/iscsi_target_util.h b/drivers/target/lio-target/iscsi_target_util.h
index 13f81e7..672a96d 100644
--- a/drivers/target/lio-target/iscsi_target_util.h
+++ b/drivers/target/lio-target/iscsi_target_util.h
@@ -102,6 +102,7 @@ extern void iscsi_stop_nopin_response_timer(struct iscsi_conn *);
 extern void __iscsi_start_nopin_timer(struct iscsi_conn *);
 extern void iscsi_start_nopin_timer(struct iscsi_conn *);
 extern void iscsi_stop_nopin_timer(struct iscsi_conn *);
+extern int iscsi_allocate_iovecs_for_cmd(struct se_cmd *);
 extern int iscsi_send_tx_data(struct iscsi_cmd *, struct iscsi_conn *, int);
 extern int iscsi_fe_sendpage_sg(struct se_unmap_sg *, struct iscsi_conn *);
 extern int iscsi_tx_login_rsp(struct iscsi_conn *, __u8, __u8);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 73c9b05..8d3a859 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1647,7 +1647,6 @@ int core_dev_setup_virtual_lun0(void)
 	se_dev->t10_wwn.t10_sub_dev = se_dev;
 	se_dev->t10_alua.t10_sub_dev = se_dev;
 	se_dev->se_dev_attrib.da_sub_dev = se_dev;
-
 	se_dev->se_dev_hba = hba;
 
 	se_dev->se_dev_su_ptr = t->allocate_virtdevice(hba, "virt_lun0");
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b50b75e..82f059c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2112,48 +2112,6 @@ out:
 }
 EXPORT_SYMBOL(transport_add_device_to_core_hba);
 
-static inline int transport_allocate_iovecs_for_cmd(
-	struct se_cmd *cmd,
-	u32 iov_count)
-{
-	cmd->iov_data = kzalloc(iov_count * sizeof(struct iovec), GFP_KERNEL);
-	if (!(cmd->iov_data)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-			" iscsi_cmd_t->iov_data.\n");
-		return -1;
-	}
-	cmd->orig_iov_data_count = iov_count;
-
-	return 0;
-}
-
-/*	transport_generic_allocate_iovecs():
- *
- *	Attached to struct target_core_fabric_ops->alloc_cmd_iovecs()
- *	for TCM fabric modules using Linux/NET with a struct iovec array.
- *
- *	Called by TCM fabric module in transport_generic_new_cmd() in
- *	transport processing thread context.
- */
-int transport_generic_allocate_iovecs(
-	struct se_cmd *cmd)
-{
-	u32 iov_count;
-
-	iov_count = T_TASK(cmd)->t_tasks_se_num;
-	if (!(iov_count))
-		iov_count = 1;
-#if 0
-	printk(KERN_INFO "Allocated %d iovecs for ITT: 0x%08x t_tasks_se_num:"
-		" %u\n", iov_count, CMD_TFO(cmd)->get_task_tag(cmd),
-		T_TASK(cmd)->t_tasks_se_num);
-#endif
-	iov_count += TRANSPORT_IOV_DATA_BUFFER;
-
-	return transport_allocate_iovecs_for_cmd(cmd, iov_count);
-}
-EXPORT_SYMBOL(transport_generic_allocate_iovecs);
-
 /*	transport_generic_prepare_cdb():
  *
  *	Since the Initiator sees iSCSI devices as LUNs,  the SCSI CDB will
@@ -2340,11 +2298,6 @@ void transport_free_se_cmd(
 	if (T_TASK(se_cmd)->t_task_cdb != T_TASK(se_cmd)->__t_task_cdb)
 		kfree(T_TASK(se_cmd)->t_task_cdb);
 	/*
-	 * Release any optional TCM fabric dependent iovecs allocated by
-	 * transport_allocate_iovecs_for_cmd()
-	 */
-	kfree(se_cmd->iov_data);
-	/*
 	 * Only release the sense_buffer, t_task, and remaining se_cmd memory
 	 * if this descriptor was allocated with transport_alloc_se_cmd()
 	 */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index cdbf5ea..4875db3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -546,17 +546,11 @@ struct se_cmd {
 	u32			cmd_spdtl;
 	u32			residual_count;
 	u32			orig_fe_lun;
-	/* Number of iovecs iovecs used for IP stack calls */
-	u32			iov_data_count;
-	/* Number of iovecs allocated for iscsi_cmd_t->iov_data */
-	u32			orig_iov_data_count;
 	/* Persistent Reservation key */
 	u64			pr_res_key;
 	atomic_t                transport_sent;
 	/* Used for sense data */
 	void			*sense_buffer;
-	/* Used with sockets based fabric plugins */
-	struct iovec		*iov_data;
 	struct list_head	se_delayed_list;
 	struct list_head	se_ordered_list;
 	struct list_head	se_lun_list;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 7d4978e..3dcd5dd 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -167,7 +167,6 @@ extern struct se_device *transport_add_device_to_core_hba(struct se_hba *,
 					struct se_subsystem_dev *, u32,
 					void *, struct se_dev_limits *,
 					const char *, const char *);
-extern int transport_generic_allocate_iovecs(struct se_cmd *);
 extern void transport_device_setup_cmd(struct se_cmd *);
 extern void transport_init_se_cmd(struct se_cmd *,
 					struct target_core_fabric_ops *,
-- 
1.5.6.5


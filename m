From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 03/20] target: Make all control CDBs scatter-gather
Date: Thu,  7 Jul 2011 15:33:14 -0700
Message-ID: <1310078011-15504-4-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1GGWdm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:42 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Previously, some control CDBs did not allocate memory in pages for their
data buffer, but just did a kmalloc. This patch makes all cdbs allocate
pages.

This has the benefit of streamlining some paths that had to behave
differently when we used two allocation methods. The downside is that
all accesses to the data buffer need to kmap it before use, and need to
handle data in page-sized chunks if more than a page is needed for a given
command's data buffer.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c           |    7 -
 drivers/scsi/qla2xxx/qla_target.c               |    3 -
 drivers/target/iscsi/iscsi_target.c             |   74 ++---------
 drivers/target/iscsi/iscsi_target_core.h        |    1 -
 drivers/target/iscsi/iscsi_target_util.c        |   11 +-
 drivers/target/target_core_alua.c               |   24 +++-
 drivers/target/target_core_cdb.c                |   49 ++++++-
 drivers/target/target_core_device.c             |    5 +-
 drivers/target/target_core_pr.c                 |   53 +++++++-
 drivers/target/target_core_pscsi.c              |   32 +----
 drivers/target/target_core_transport.c          |  158 ++++++++---------------
 drivers/target/tcm_fc/tfc_cmd.c                 |    4 +-
 drivers/target/tcm_fc/tfc_io.c                  |   61 +++-------
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c |   21 ---
 include/target/target_core_base.h               |    4 +-
 include/target/target_core_transport.h          |    6 +-
 16 files changed, 207 insertions(+), 306 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b64b653..60415e1 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1131,13 +1131,6 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 		transport_do_task_sg_chain(cmd);
 		sg = sg_orig = cmd->t_tasks_sg_chained;
 		sg_cnt = cmd->t_tasks_sg_chained_no;
-	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		/* Use task->t_tasks_sg_bounce for control CDBs. */
-		sg_init_table(&cmd->t_tasks_sg_bounce, 1);
-		sg_set_buf(&cmd->t_tasks_sg_bounce, cmd->t_task_buf,
-			   cmd->data_length);
-		sg = sg_orig = &cmd->t_tasks_sg_bounce;
-		sg_cnt = 1;
 	} else {
 		pr_debug("?? sg == NULL\n");
 		ioctx->mapped_sg_count = 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4d54872..360abab 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3890,9 +3890,6 @@ restart:
 		    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
 			cmd->sg_cnt = se_cmd->t_tasks_sg_chained_no;
 			cmd->sg = se_cmd->t_tasks_sg_chained;
-		} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-			cmd->sg_cnt = 1;
-			cmd->sg = &se_cmd->t_tasks_sg_bounce;
 		}
 
 		DEBUG22(qla_printk(KERN_INFO, ha, "SRR cmd %p (se_cmd %p, tag %d, op %x), "
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 588c5dd..425caef 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -780,7 +780,6 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 {
 	struct scatterlist *sgl;
-	void *buf, *cur;
 	u32 length = cmd->se_cmd.data_length;
 	int nents = DIV_ROUND_UP(length, PAGE_SIZE);
 	int i = 0, ret;
@@ -790,72 +789,25 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 	 */
 	if (!length)
 		return iscsit_allocate_iovecs(cmd);
-	/*
-	 * Allocate from slab if nonsg, but sgl should point
-	 * to the malloced mem.
-	 * We know we have to kfree it if t_mem is set.
-	 * Alloc pages if sg.
-	 */
-	if (cmd->se_cmd.se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		int pg_off = 0, buf_size;
 
-		buf = kmalloc(length, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-		/*
-		 * Allocate extra SGL for offset_in_page exceeding DIV_ROUND_UP
-		 */
-		pg_off = offset_in_page(buf);
-		if ((pg_off + length) > (PAGE_SIZE * nents))
-			nents++;
-
-		sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
-		if (!sgl)
-			return -ENOMEM;
-		sg_init_table(sgl, nents);
-
-		cur = buf;
-		while (length) {
-			if (pg_off != 0) {
-				buf_size = min_t(int, PAGE_SIZE - pg_off, length);
-				pg_off = 0;
-			} else
-				buf_size = min_t(int, length, PAGE_SIZE);
-					
-			sg_set_buf(&sgl[i], cur, buf_size);
-
-			if (sgl[i].length < 0) {
-				printk("sg_set_buf: page: %p, len: %d, offset: %d\n",
-					sg_page(&sgl[i]), sgl[i].length, sgl[i].offset);
-				BUG();
-			}
-			length -= buf_size;
-			cur += buf_size;
-			i++;
-		}
-		cmd->se_cmd.t_task_buf = buf;
-		cmd->t_mem = buf;
-
-	} else {
-		sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
-		if (!sgl)
-			return -ENOMEM;
+	sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
+	if (!sgl)
+		return -ENOMEM;
 
-		sg_init_table(sgl, nents);
+	sg_init_table(sgl, nents);
 
-		while (length) {
-			int buf_size = min_t(int, length, PAGE_SIZE);
-			struct page *page;
+	while (length) {
+		int buf_size = min_t(int, length, PAGE_SIZE);
+		struct page *page;
 
-			page = alloc_page(GFP_KERNEL);
-			if (!page)
-				goto page_alloc_failed;
+		page = alloc_page(GFP_KERNEL);
+		if (!page)
+			goto page_alloc_failed;
 
-			sg_set_page(&sgl[i], page, buf_size, 0);
+		sg_set_page(&sgl[i], page, buf_size, 0);
 
-			length -= buf_size;
-			i++;
-		}
+		length -= buf_size;
+		i++;
 	}
 
 	cmd->t_mem_sg = sgl;
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 5bf2f7a..c66a259 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -470,7 +470,6 @@ struct iscsi_cmd {
 #define ISCSI_SENSE_BUFFER_LEN          (TRANSPORT_SENSE_BUFFER + 2)
 	unsigned char		sense_buffer[ISCSI_SENSE_BUFFER_LEN];
 
-	void			*t_mem;
 	struct scatterlist	*t_mem_sg;
 	u32			t_mem_sg_nents;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index e677fa0..4260888 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -801,6 +801,7 @@ void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *conn)
 void iscsit_release_cmd(struct iscsi_cmd *cmd)
 {
 	struct iscsi_conn *conn = cmd->conn;
+	int i;
 
 	iscsit_free_r2ts_from_list(cmd);
 	iscsit_free_all_datain_reqs(cmd);
@@ -811,15 +812,9 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	kfree(cmd->tmr_req);
 	kfree(cmd->iov_data);
 
-	/* see iscsit_alloc_buffs */
-	if (cmd->t_mem) {
-		kfree(cmd->t_mem);
-	} else {
-		int i;
+	for (i = 0; i < cmd->t_mem_sg_nents; i++)
+		__free_page(sg_page(&cmd->t_mem_sg[i]));
 
-		for (i = 0; i < cmd->t_mem_sg_nents; i++)
-			__free_page(sg_page(&cmd->t_mem_sg[i]));
-	}
 	kfree(cmd->t_mem_sg);
 
 	if (conn) {
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 2dca8d7..3f307dd 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -65,10 +65,12 @@ int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	u32 rd_len = 0, off = 4; /* Skip over RESERVED area to first
 				    Target port group descriptor */
 
+	buf = transport_kmap_first_data_page(cmd);
+
 	spin_lock(&su_dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &su_dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
@@ -141,6 +143,8 @@ int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 	buf[2] = ((rd_len >> 8) & 0xff);
 	buf[3] = (rd_len & 0xff);
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -157,8 +161,8 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	struct se_node_acl *nacl = cmd->se_sess->se_node_acl;
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *l_tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem, *l_tg_pt_gp_mem;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
-	unsigned char *ptr = &buf[4]; /* Skip over RESERVED area in header */
+	unsigned char *buf;
+	unsigned char *ptr;
 	u32 len = 4; /* Skip over RESERVED area in header */
 	int alua_access_state, primary = 0, rc;
 	u16 tg_pt_id, rtpi;
@@ -190,6 +194,9 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
 
+	buf = transport_kmap_first_data_page(cmd);
+	ptr = &buf[4]; /* Skip over RESERVED area in header */
+
 	while (len < cmd->data_length) {
 		alua_access_state = (ptr[0] & 0x0f);
 		/*
@@ -209,6 +216,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * REQUEST, and the additional sense code set to INVALID
 			 * FIELD IN PARAMETER LIST.
 			 */
+			transport_kunmap_first_data_page(cmd);
 			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 		}
 		rc = -1;
@@ -260,8 +268,10 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * If not matching target port group ID can be located
 			 * throw an exception with ASCQ: INVALID_PARAMETER_LIST
 			 */
-			if (rc != 0)
+			if (rc != 0) {
+				transport_kunmap_first_data_page(cmd);
 				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			}
 		} else {
 			/*
 			 * Extact the RELATIVE TARGET PORT IDENTIFIER to identify
@@ -295,14 +305,18 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * be located, throw an exception with ASCQ:
 			 * INVALID_PARAMETER_LIST
 			 */
-			if (rc != 0)
+			if (rc != 0) {
+				transport_kunmap_first_data_page(cmd);
 				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			}
 		}
 
 		ptr += 4;
 		len += 4;
 	}
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 09ef3f8..6c9e53f 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -66,7 +66,7 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 {
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task_buf;
+	unsigned char *buf;
 
 	/*
 	 * Make sure we at least have 6 bytes of INQUIRY response
@@ -78,6 +78,8 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 		return -EINVAL;
 	}
 
+	buf = transport_kmap_first_data_page(cmd);
+
 	buf[0] = dev->transport->get_device_type(dev);
 	if (buf[0] == TYPE_TAPE)
 		buf[1] = 0x80;
@@ -111,6 +113,9 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 	snprintf((unsigned char *)&buf[32], 4, "%s",
 		 &dev->se_sub_dev->t10_wwn.revision[0]);
 	buf[4] = 31; /* Set additional length to 31 */
+
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -621,7 +626,7 @@ static int
 target_emulate_inquiry(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task_buf;
+	unsigned char *buf;
 	unsigned char *cdb = cmd->t_task_cdb;
 
 	if (!(cdb[1] & 0x1))
@@ -639,6 +644,9 @@ target_emulate_inquiry(struct se_cmd *cmd)
 			" too small for EVPD=1\n", cmd->data_length);
 		return -EINVAL;
 	}
+
+	buf = transport_kmap_first_data_page(cmd);
+
 	buf[0] = dev->transport->get_device_type(dev);
 
 	switch (cdb[2]) {
@@ -656,9 +664,12 @@ target_emulate_inquiry(struct se_cmd *cmd)
 		return target_emulate_evpd_b2(cmd, buf);
 	default:
 		printk(KERN_ERR "Unknown VPD Code: 0x%02x\n", cdb[2]);
+		transport_kunmap_first_data_page(cmd);
 		return -EINVAL;
 	}
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -666,7 +677,7 @@ static int
 target_emulate_readcapacity(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task_buf;
+	unsigned char *buf;
 	unsigned long long blocks_long = dev->transport->get_blocks(dev);
 	u32 blocks;
 
@@ -675,6 +686,8 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 	else
 		blocks = (u32)blocks_long;
 
+	buf = transport_kmap_first_data_page(cmd);
+
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;
 	buf[2] = (blocks >> 8) & 0xff;
@@ -689,6 +702,8 @@ target_emulate_readcapacity(struct se_cmd *cmd)
 	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu || dev->se_sub_dev->se_dev_attrib.emulate_tpws)
 		put_unaligned_be32(0xFFFFFFFF, &buf[0]);
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -696,9 +711,11 @@ static int
 target_emulate_readcapacity_16(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task_buf;
+	unsigned char *buf;
 	unsigned long long blocks = dev->transport->get_blocks(dev);
 
+	buf = transport_kmap_first_data_page(cmd);
+
 	buf[0] = (blocks >> 56) & 0xff;
 	buf[1] = (blocks >> 48) & 0xff;
 	buf[2] = (blocks >> 40) & 0xff;
@@ -718,6 +735,8 @@ target_emulate_readcapacity_16(struct se_cmd *cmd)
 	if (dev->se_sub_dev->se_dev_attrib.emulate_tpu || dev->se_sub_dev->se_dev_attrib.emulate_tpws)
 		buf[14] = 0x80;
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -832,7 +851,7 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 {
 	struct se_device *dev = cmd->se_dev;
 	char *cdb = cmd->t_task_cdb;
-	unsigned char *rbuf = cmd->t_task_buf;
+	unsigned char *rbuf;
 	int type = dev->transport->get_device_type(dev);
 	int offset = (ten) ? 8 : 4;
 	int length = 0;
@@ -895,7 +914,10 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 		if ((offset + 1) > cmd->data_length)
 			offset = cmd->data_length;
 	}
+
+	rbuf = transport_kmap_first_data_page(cmd);
 	memcpy(rbuf, buf, offset);
+	transport_kunmap_first_data_page(cmd);
 
 	return 0;
 }
@@ -904,7 +926,7 @@ static int
 target_emulate_request_sense(struct se_cmd *cmd)
 {
 	unsigned char *cdb = cmd->t_task_cdb;
-	unsigned char *buf = cmd->t_task_buf;
+	unsigned char *buf;
 	u8 ua_asc = 0, ua_ascq = 0;
 
 	if (cdb[1] & 0x01) {
@@ -912,6 +934,9 @@ target_emulate_request_sense(struct se_cmd *cmd)
 			" supported\n");
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
+
+	buf = transport_kmap_first_data_page(cmd);
+
 	if (!(core_scsi3_ua_clear_for_request_sense(cmd, &ua_asc, &ua_ascq))) {
 		/*
 		 * CURRENT ERROR, UNIT ATTENTION
@@ -924,6 +949,7 @@ target_emulate_request_sense(struct se_cmd *cmd)
 		 */
 		if (cmd->data_length <= 18) {
 			buf[7] = 0x00;
+			transport_kunmap_first_data_page(cmd);
 			return 0;
 		}
 		/*
@@ -944,6 +970,7 @@ target_emulate_request_sense(struct se_cmd *cmd)
 		 */
 		if (cmd->data_length <= 18) {
 			buf[7] = 0x00;
+			transport_kunmap_first_data_page(cmd);
 			return 0;
 		}
 		/*
@@ -953,6 +980,8 @@ target_emulate_request_sense(struct se_cmd *cmd)
 		buf[7] = 0x0A;
 	}
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -965,7 +994,7 @@ target_emulate_unmap(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task_buf, *ptr = NULL;
+	unsigned char *buf, *ptr = NULL;
 	unsigned char *cdb = &cmd->t_task_cdb[0];
 	sector_t lba;
 	unsigned int size = cmd->data_length, range;
@@ -977,6 +1006,9 @@ target_emulate_unmap(struct se_task *task)
 	size -= 8;
 	dl = get_unaligned_be16(&cdb[0]);
 	bd_dl = get_unaligned_be16(&cdb[2]);
+
+	buf = transport_kmap_first_data_page(cmd);
+
 	ptr = &buf[offset];
 	printk(KERN_INFO "UNMAP: Sub: %s Using dl: %hu bd_dl: %hu size: %hu"
 		" ptr: %p\n", dev->transport->name, dl, bd_dl, size, ptr);
@@ -991,6 +1023,7 @@ target_emulate_unmap(struct se_task *task)
 		if (ret < 0) {
 			printk(KERN_ERR "blkdev_issue_discard() failed: %d\n",
 					ret);
+			transport_kunmap_first_data_page(cmd);
 			return ret;
 		}
 
@@ -998,6 +1031,8 @@ target_emulate_unmap(struct se_task *task)
 		size -= 16;
 	}
 
+	transport_kunmap_first_data_page(cmd);
+
 	task->task_scsi_status = GOOD;
 	transport_complete_task(task, 1);
 	return 0;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ebf05db..fcd312b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -658,7 +658,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	struct se_lun *se_lun;
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_task *se_task;
-	unsigned char *buf = se_cmd->t_task_buf;
+	unsigned char *buf;
 	u32 cdb_offset = 0, lun_count = 0, offset = 8, i;
 
 	list_for_each_entry(se_task, &se_cmd->t_task_list, t_list)
@@ -669,6 +669,8 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 	}
 
+	buf = transport_kmap_first_data_page(se_cmd);
+
 	/*
 	 * If no struct se_session pointer is present, this struct se_cmd is
 	 * coming via a target_core_mod PASSTHROUGH op, and not through
@@ -705,6 +707,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	 * See SPC3 r07, page 159.
 	 */
 done:
+	transport_kunmap_first_data_page(se_cmd);
 	lun_count *= 8;
 	buf[0] = ((lun_count >> 24) & 0xff);
 	buf[1] = ((lun_count >> 16) & 0xff);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4fdede8..81e50a5 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1482,7 +1482,7 @@ static int core_scsi3_decode_spec_i_port(
 	struct list_head tid_dest_list;
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	struct target_core_fabric_ops *tmp_tf_ops;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	unsigned char *ptr, *i_str = NULL, proto_ident, tmp_proto_ident;
 	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tpdl, tid_len = 0;
@@ -1524,6 +1524,8 @@ static int core_scsi3_decode_spec_i_port(
 	 */
 	tidh_new->dest_local_nexus = 1;
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
+
+	buf = transport_kmap_first_data_page(cmd);
 	/*
 	 * For a PERSISTENT RESERVE OUT specify initiator ports payload,
 	 * first extract TransportID Parameter Data Length, and make sure
@@ -1760,6 +1762,9 @@ static int core_scsi3_decode_spec_i_port(
 		tid_len = 0;
 
 	}
+
+	transport_kunmap_first_data_page(cmd);
+
 	/*
 	 * Go ahead and create a registrations from tid_dest_list for the
 	 * SPEC_I_PT provided TransportID for the *tidh referenced dest_node_acl
@@ -1806,6 +1811,7 @@ static int core_scsi3_decode_spec_i_port(
 
 	return 0;
 out:
+	transport_kunmap_first_data_page(cmd);
 	/*
 	 * For the failure case, release everything from tid_dest_list
 	 * including *dest_pr_reg and the configfs dependances..
@@ -3307,7 +3313,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	struct target_core_fabric_ops *dest_tf_ops = NULL, *tf_ops;
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
 	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	unsigned char *initiator_str;
 	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tid_len, tmp_tid_len;
@@ -3357,17 +3363,21 @@ static int core_scsi3_emulate_pro_register_and_move(
 		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
+
 	/*
 	 * Determine the Relative Target Port Identifier where the reservation
 	 * will be moved to for the TransportID containing SCSI initiator WWN
 	 * information.
 	 */
+	buf = transport_kmap_first_data_page(cmd);
 	rtpi = (buf[18] & 0xff) << 8;
 	rtpi |= buf[19] & 0xff;
 	tid_len = (buf[20] & 0xff) << 24;
 	tid_len |= (buf[21] & 0xff) << 16;
 	tid_len |= (buf[22] & 0xff) << 8;
 	tid_len |= buf[23] & 0xff;
+	transport_kunmap_first_data_page(cmd);
+	buf = NULL;
 
 	if ((tid_len + 24) != cmd->data_length) {
 		printk(KERN_ERR "SPC-3 PR: Illegal tid_len: %u + 24 byte header"
@@ -3414,6 +3424,8 @@ static int core_scsi3_emulate_pro_register_and_move(
 		core_scsi3_put_pr_reg(pr_reg);
 		return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
 	}
+
+	buf = transport_kmap_first_data_page(cmd);
 	proto_ident = (buf[24] & 0x0f);
 #if 0
 	printk("SPC-3 PR REGISTER_AND_MOVE: Extracted Protocol Identifier:"
@@ -3444,6 +3456,9 @@ static int core_scsi3_emulate_pro_register_and_move(
 		goto out;
 	}
 
+	transport_kunmap_first_data_page(cmd);
+	buf = NULL;
+
 	printk(KERN_INFO "SPC-3 PR [%s] Extracted initiator %s identifier: %s"
 		" %s\n", dest_tf_ops->get_fabric_name(), (iport_ptr != NULL) ?
 		"port" : "device", initiator_str, (iport_ptr != NULL) ?
@@ -3696,9 +3711,13 @@ after_iport_check:
 					" REGISTER_AND_MOVE\n");
 	}
 
+	transport_kunmap_first_data_page(cmd);
+
 	core_scsi3_put_pr_reg(dest_pr_reg);
 	return 0;
 out:
+	if (buf)
+		transport_kunmap_first_data_page(cmd);
 	if (dest_se_deve)
 		core_scsi3_lunacl_undepend_item(dest_se_deve);
 	if (dest_node_acl)
@@ -3723,7 +3742,7 @@ static unsigned long long core_scsi3_extract_reservation_key(unsigned char *cdb)
  */
 static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 {
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	u64 res_key, sa_res_key;
 	int sa, scope, type, aptpl;
 	int spec_i_pt = 0, all_tg_pt = 0, unreg = 0;
@@ -3745,6 +3764,8 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 	sa = (cdb[1] & 0x1f);
 	scope = (cdb[2] & 0xf0);
 	type = (cdb[2] & 0x0f);
+
+	buf = transport_kmap_first_data_page(cmd);
 	/*
 	 * From PERSISTENT_RESERVE_OUT parameter list (payload)
 	 */
@@ -3762,6 +3783,9 @@ static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 		aptpl = (buf[17] & 0x01);
 		unreg = (buf[17] & 0x02);
 	}
+	transport_kunmap_first_data_page(cmd);
+	buf = NULL;
+
 	/*
 	 * SPEC_I_PT=1 is only valid for Service action: REGISTER
 	 */
@@ -3830,7 +3854,7 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	struct se_device *se_dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
@@ -3839,6 +3863,7 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
+	buf = transport_kmap_first_data_page(cmd);
 	buf[0] = ((su_dev->t10_pr.pr_generation >> 24) & 0xff);
 	buf[1] = ((su_dev->t10_pr.pr_generation >> 16) & 0xff);
 	buf[2] = ((su_dev->t10_pr.pr_generation >> 8) & 0xff);
@@ -3872,6 +3897,8 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	buf[6] = ((add_len >> 8) & 0xff);
 	buf[7] = (add_len & 0xff);
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -3885,7 +3912,7 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	struct se_device *se_dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	u64 pr_res_key;
 	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
 
@@ -3895,6 +3922,7 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
+	buf = transport_kmap_first_data_page(cmd);
 	buf[0] = ((su_dev->t10_pr.pr_generation >> 24) & 0xff);
 	buf[1] = ((su_dev->t10_pr.pr_generation >> 16) & 0xff);
 	buf[2] = ((su_dev->t10_pr.pr_generation >> 8) & 0xff);
@@ -3913,6 +3941,7 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 
 		if (cmd->data_length < 22) {
 			spin_unlock(&se_dev->dev_reservation_lock);
+			transport_kunmap_first_data_page(cmd);
 			return 0;
 		}
 		/*
@@ -3953,6 +3982,8 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	}
 	spin_unlock(&se_dev->dev_reservation_lock);
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -3965,7 +3996,7 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
@@ -3974,6 +4005,8 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
+	buf = transport_kmap_first_data_page(cmd);
+
 	buf[0] = ((add_len << 8) & 0xff);
 	buf[1] = (add_len & 0xff);
 	buf[2] |= 0x10; /* CRH: Compatible Reservation Hanlding bit. */
@@ -4004,6 +4037,8 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 	buf[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
 	buf[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
@@ -4020,7 +4055,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &se_dev->se_sub_dev->t10_pr;
-	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
+	unsigned char *buf;
 	u32 add_desc_len = 0, add_len = 0, desc_len, exp_desc_len;
 	u32 off = 8; /* off into first Full Status descriptor */
 	int format_code = 0;
@@ -4031,6 +4066,8 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 		return PYX_TRANSPORT_INVALID_CDB_FIELD;
 	}
 
+	buf = transport_kmap_first_data_page(cmd);
+
 	buf[0] = ((su_dev->t10_pr.pr_generation >> 24) & 0xff);
 	buf[1] = ((su_dev->t10_pr.pr_generation >> 16) & 0xff);
 	buf[2] = ((su_dev->t10_pr.pr_generation >> 8) & 0xff);
@@ -4150,6 +4187,8 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	buf[6] = ((add_len >> 8) & 0xff);
 	buf[7] = (add_len & 0xff);
 
+	transport_kunmap_first_data_page(cmd);
+
 	return 0;
 }
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 3574c52..d956924 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -695,7 +695,7 @@ static int pscsi_transport_complete(struct se_task *task)
 
 		if (task->task_se_cmd->se_deve->lun_flags &
 				TRANSPORT_LUNFLAGS_READ_ONLY) {
-			unsigned char *buf = task->task_se_cmd->t_task_buf;
+			unsigned char *buf = transport_kmap_first_data_page(task->task_se_cmd);
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
@@ -704,6 +704,8 @@ static int pscsi_transport_complete(struct se_task *task)
 				if (!(buf[2] & 0x80))
 					buf[2] |= 0x80;
 			}
+
+			transport_kunmap_first_data_page(task->task_se_cmd);
 		}
 	}
 after_mode_sense:
@@ -1246,33 +1248,6 @@ static int pscsi_map_task_SG(struct se_task *task)
 	return 0;
 }
 
-/*	pscsi_map_task_non_SG():
- *
- *
- */
-static int pscsi_map_task_non_SG(struct se_task *task)
-{
-	struct se_cmd *cmd = task->task_se_cmd;
-	struct pscsi_plugin_task *pt = PSCSI_TASK(task);
-	struct pscsi_dev_virt *pdv = task->se_dev->dev_ptr;
-	int ret = 0;
-
-	if (pscsi_blk_get_request(task) < 0)
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-
-	if (!task->task_size)
-		return 0;
-
-	ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
-			pt->pscsi_req, cmd->t_task_buf,
-			task->task_size, GFP_KERNEL);
-	if (ret < 0) {
-		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
-		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	}
-	return 0;
-}
-
 static int pscsi_CDB_none(struct se_task *task)
 {
 	return pscsi_blk_get_request(task);
@@ -1392,7 +1367,6 @@ static struct se_subsystem_api pscsi_template = {
 	.owner			= THIS_MODULE,
 	.transport_type		= TRANSPORT_PLUGIN_PHBA_PDEV,
 	.cdb_none		= pscsi_CDB_none,
-	.map_task_non_SG	= pscsi_map_task_non_SG,
 	.map_task_SG		= pscsi_map_task_SG,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b98f6ff..e2887c3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -214,7 +214,7 @@ static u32 transport_allocate_tasks(struct se_cmd *cmd,
 		unsigned long long starting_lba, u32 sectors,
 		enum dma_data_direction data_direction,
 		struct list_head *mem_list, int set_counts);
-static int transport_generic_get_mem(struct se_cmd *cmd, u32 length);
+static int transport_generic_get_mem(struct se_cmd *cmd);
 static int transport_generic_remove(struct se_cmd *cmd,
 		int session_reinstatement);
 static int transport_cmd_get_valid_sectors(struct se_cmd *cmd);
@@ -2238,23 +2238,6 @@ static void transport_generic_request_timeout(struct se_cmd *cmd)
 	transport_generic_remove(cmd, 0);
 }
 
-static int
-transport_generic_allocate_buf(struct se_cmd *cmd, u32 data_length)
-{
-	unsigned char *buf;
-
-	buf = kzalloc(data_length, GFP_KERNEL);
-	if (!(buf)) {
-		printk(KERN_ERR "Unable to allocate memory for buffer\n");
-		return -ENOMEM;
-	}
-
-	cmd->t_tasks_se_num = 0;
-	cmd->t_task_buf = buf;
-
-	return 0;
-}
-
 static inline u32 transport_lba_21(unsigned char *cdb)
 {
 	return ((cdb[1] & 0x1f) << 16) | (cdb[2] << 8) | cdb[3];
@@ -2972,19 +2955,6 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 	return -1;
 }
 
-static int transport_allocate_resources(struct se_cmd *cmd)
-{
-	u32 length = cmd->data_length;
-
-	if ((cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
-	    (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB))
-		return transport_generic_get_mem(cmd, length);
-	else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB)
-		return transport_generic_allocate_buf(cmd, length);
-	else
-		return 0;
-}
-
 static int
 transport_handle_reservation_conflict(struct se_cmd *cmd)
 {
@@ -3271,7 +3241,7 @@ static int transport_generic_cmd_sequencer(
 			/* GPCMD_SEND_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case MODE_SELECT:
 		size = cdb[4];
@@ -3283,7 +3253,7 @@ static int transport_generic_cmd_sequencer(
 		break;
 	case MODE_SENSE:
 		size = cdb[4];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case MODE_SENSE_10:
 	case GPCMD_READ_BUFFER_CAPACITY:
@@ -3291,11 +3261,11 @@ static int transport_generic_cmd_sequencer(
 	case LOG_SELECT:
 	case LOG_SENSE:
 		size = (cdb[7] << 8) + cdb[8];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case READ_BLOCK_LIMITS:
 		size = READ_BLOCK_LEN;
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case GPCMD_GET_CONFIGURATION:
 	case GPCMD_READ_FORMAT_CAPACITIES:
@@ -3311,7 +3281,7 @@ static int transport_generic_cmd_sequencer(
 			 SPC3_PERSISTENT_RESERVATIONS) ?
 			core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case GPCMD_MECHANISM_STATUS:
 	case GPCMD_READ_DVD_STRUCTURE:
@@ -3320,7 +3290,7 @@ static int transport_generic_cmd_sequencer(
 		break;
 	case READ_POSITION:
 		size = READ_POSITION_LEN;
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case MAINTENANCE_OUT:
 		if (dev->transport->get_device_type(dev) != TYPE_ROM) {
@@ -3342,7 +3312,7 @@ static int transport_generic_cmd_sequencer(
 			/* GPCMD_REPORT_KEY from multi media commands */
 			size = (cdb[8] << 8) + cdb[9];
 		}
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case INQUIRY:
 		size = (cdb[3] << 8) + cdb[4];
@@ -3352,21 +3322,21 @@ static int transport_generic_cmd_sequencer(
 		 */
 		if (cmd->se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 			cmd->sam_task_attr = MSG_HEAD_TAG;
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case READ_BUFFER:
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case READ_CAPACITY:
 		size = READ_CAP_LEN;
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case READ_MEDIA_SERIAL_NUMBER:
 	case SECURITY_PROTOCOL_IN:
 	case SECURITY_PROTOCOL_OUT:
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case SERVICE_ACTION_IN:
 	case ACCESS_CONTROL_IN:
@@ -3377,36 +3347,36 @@ static int transport_generic_cmd_sequencer(
 	case WRITE_ATTRIBUTE:
 		size = (cdb[10] << 24) | (cdb[11] << 16) |
 		       (cdb[12] << 8) | cdb[13];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
 		size = (cdb[3] << 8) | cdb[4];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 /* #warning FIXME: Figure out correct GPCMD_READ_CD blocksize. */
 #if 0
 	case GPCMD_READ_CD:
 		sectors = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
 		size = (2336 * sectors);
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 #endif
 	case READ_TOC:
 		size = cdb[8];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case REQUEST_SENSE:
 		size = cdb[4];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case READ_ELEMENT_STATUS:
 		size = 65536 * cdb[7] + 256 * cdb[8] + cdb[9];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case WRITE_BUFFER:
 		size = (cdb[6] << 16) + (cdb[7] << 8) + cdb[8];
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case RESERVE:
 	case RESERVE_10:
@@ -3486,7 +3456,7 @@ static int transport_generic_cmd_sequencer(
 		break;
 	case UNMAP:
 		size = get_unaligned_be16(&cdb[7]);
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	case WRITE_SAME_16:
 		sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
@@ -3553,7 +3523,7 @@ static int transport_generic_cmd_sequencer(
 		 */
 		if (cmd->se_dev->dev_task_attr_type == SAM_TASK_ATTR_EMULATED)
 			cmd->sam_task_attr = MSG_HEAD_TAG;
-		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
+		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 		break;
 	default:
 		printk(KERN_WARNING "TARGET_CORE[%s]: Unsupported SCSI Opcode"
@@ -3810,16 +3780,6 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 					cmd->data_length;
 		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
-		/*
-		 * If enabled by TCM fabric module pre-registered SGL
-		 * memory, perform the memcpy() from the TCM internal
-		 * contiguous buffer back to the original SGL.
-		 */
-		if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-			sg_copy_from_buffer(cmd->t_task_pt_sgl,
-					    cmd->t_task_pt_sgl_num,
-					    cmd->t_task_buf,
-					    cmd->data_length);
 
 		ret = cmd->se_tfo->queue_data_in(cmd);
 		if (ret == -EAGAIN)
@@ -3905,12 +3865,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	if (cmd->se_dev->transport->do_se_mem_map)
 		free_page = 0;
 
-	if (cmd->t_task_buf) {
-		kfree(cmd->t_task_buf);
-		cmd->t_task_buf = NULL;
-		return;
-	}
-
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
 			&cmd->t_mem_list, se_list) {
 		/*
@@ -4074,25 +4028,6 @@ int transport_generic_map_mem_to_cmd(
 			cmd->t_tasks_se_bidi_num = ret;
 		}
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
-
-	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		if (sgl_bidi || sgl_bidi_count) {
-			printk(KERN_ERR "BIDI-Commands not supported using "
-				"SCF_SCSI_CONTROL_NONSG_IO_CDB\n");
-			return -ENOSYS;
-		}
-		/*
-		 * For incoming CDBs using a contiguous buffer internal with TCM,
-		 * save the passed struct scatterlist memory.  After TCM storage object
-		 * processing has completed for this struct se_cmd, TCM core will call
-		 * transport_memcpy_[write,read]_contig() as necessary from
-		 * transport_generic_complete_ok() and transport_write_pending() in order
-		 * to copy the TCM buffer to/from the original passed *mem in SGL ->
-		 * struct scatterlist format.
-		 */
-		cmd->se_cmd_flags |= SCF_PASSTHROUGH_CONTIG_TO_SG;
-		cmd->t_task_pt_sgl = sgl;
-		cmd->t_task_pt_sgl_num = sgl_count;
 	}
 
 	return 0;
@@ -4190,10 +4125,41 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 	return 0;
 }
 
+void *transport_kmap_first_data_page(struct se_cmd *cmd)
+{
+	struct se_mem *se_mem;
+
+	BUG_ON(list_empty(&cmd->t_mem_list));
+
+	se_mem = list_first_entry(&cmd->t_mem_list, struct se_mem, se_list);
+
+	/*
+	 * 1st se_mem should point to a page, and we shouldn't need more than
+	 * that for this cmd
+	 */
+	BUG_ON(cmd->data_length > PAGE_SIZE);
+
+	return kmap(se_mem->se_page);
+}
+EXPORT_SYMBOL(transport_kmap_first_data_page);
+
+void transport_kunmap_first_data_page(struct se_cmd *cmd)
+{
+	struct se_mem *se_mem;
+
+	BUG_ON(list_empty(&cmd->t_mem_list));
+
+	se_mem = list_first_entry(&cmd->t_mem_list, struct se_mem, se_list);
+
+	kunmap(se_mem->se_page);
+}
+EXPORT_SYMBOL(transport_kunmap_first_data_page);
+
 static int
-transport_generic_get_mem(struct se_cmd *cmd, u32 length)
+transport_generic_get_mem(struct se_cmd *cmd)
 {
 	struct se_mem *se_mem;
+	int length = cmd->data_length;
 
 	/*
 	 * If the device uses memory mapping this is enough.
@@ -4856,10 +4822,6 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 		if (dev->transport->map_task_SG)
 			return dev->transport->map_task_SG(task);
 		return 0;
-	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		if (dev->transport->map_task_non_SG)
-			return dev->transport->map_task_non_SG(task);
-		return 0;
 	} else if (cmd->se_cmd_flags & SCF_SCSI_NON_DATA_CDB) {
 		if (dev->transport->cdb_none)
 			return dev->transport->cdb_none(task);
@@ -4892,7 +4854,7 @@ int transport_generic_new_cmd(struct se_cmd *cmd)
 	 * cmd->t_mem_list of struct se_mem->se_page
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
-		ret = transport_allocate_resources(cmd);
+		ret = transport_generic_get_mem(cmd);
 		if (ret < 0)
 			return ret;
 	}
@@ -4976,17 +4938,7 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 		cmd->transport_qf_callback = NULL;
 		return 0;
 	}
-	/*
-	 * For the TCM control CDBs using a contiguous buffer, do the memcpy
-	 * from the passed Linux/SCSI struct scatterlist located at
-	 * se_cmd->t_task_pt_sgl to the contiguous buffer at
-	 * se_cmd->t_task_buf.
-	 */
-	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-		sg_copy_to_buffer(cmd->t_task_pt_sgl,
-				    cmd->t_task_pt_sgl_num,
-				    cmd->t_task_buf,
-				    cmd->data_length);
+
 	/*
 	 * Clear the se_cmd for WRITE_PENDING status in order to set
 	 * cmd->t_transport_active=0 so that transport_generic_handle_data
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 1f2e9f5..1f8477f 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -71,9 +71,9 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		caller, cmd, cmd->cdb);
 	printk(KERN_INFO "%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
 
-	printk(KERN_INFO "%s: cmd %p se_num %u buf %p len %u se_cmd_flags <0x%x>\n",
+	printk(KERN_INFO "%s: cmd %p se_num %u len %u se_cmd_flags <0x%x>\n",
 	       caller, cmd, se_cmd->t_tasks_se_num,
-	       se_cmd->t_task_buf, se_cmd->data_length, se_cmd->se_cmd_flags);
+	       se_cmd->data_length, se_cmd->se_cmd_flags);
 
 	list_for_each_entry(mem, &se_cmd->t_mem_list, se_list)
 		printk(KERN_INFO "%s: cmd %p mem %p page %p "
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 10192fb..d4e8d38 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -92,19 +92,15 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 	remaining = se_cmd->data_length;
 
 	/*
-	 * Setup to use first mem list entry if any.
+	 * Setup to use first mem list entry, unless no data.
 	 */
-	if (se_cmd->t_tasks_se_num) {
+	BUG_ON(remaining && list_empty(&se_cmd->t_mem_list));
+	if (remaining) {
 		mem = list_first_entry(&se_cmd->t_mem_list,
 			 struct se_mem, se_list);
 		mem_len = mem->se_len;
 		mem_off = mem->se_off;
 		page = mem->se_page;
-	} else {
-		mem = NULL;
-		mem_len = remaining;
-		mem_off = 0;
-		page = NULL;
 	}
 
 	/* no scatter/gather in skb for odd word length due to fc_seq_send() */
@@ -145,18 +141,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 		tlen = min(mem_len, frame_len);
 
 		if (use_sg) {
-			if (!mem) {
-				BUG_ON(!se_cmd->t_task_buf);
-				page_addr = se_cmd->t_task_buf + mem_off;
-				/*
-				 * In this case, offset is 'offset_in_page' of
-				 * (t_task_buf + mem_off) instead of 'mem_off'.
-				 */
-				off_in_page = offset_in_page(page_addr);
-				page = virt_to_page(page_addr);
-				tlen = min(tlen, PAGE_SIZE - off_in_page);
-			} else
-				off_in_page = mem_off;
+			off_in_page = mem_off;
 			BUG_ON(!page);
 			get_page(page);
 			skb_fill_page_desc(fp_skb(fp),
@@ -166,7 +151,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			fp_skb(fp)->data_len += tlen;
 			fp_skb(fp)->truesize +=
 					PAGE_SIZE << compound_order(page);
-		} else if (mem) {
+		} else {
 			BUG_ON(!page);
 			from = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
 					   KM_SOFTIRQ0);
@@ -177,10 +162,6 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			memcpy(to, from, tlen);
 			kunmap_atomic(page_addr, KM_SOFTIRQ0);
 			to += tlen;
-		} else {
-			from = se_cmd->t_task_buf + mem_off;
-			memcpy(to, from, tlen);
-			to += tlen;
 		}
 
 		mem_off += tlen;
@@ -305,19 +286,15 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 		frame_len = se_cmd->data_length - rel_off;
 
 	/*
-	 * Setup to use first mem list entry if any.
+	 * Setup to use first mem list entry, unless no data.
 	 */
-	if (se_cmd->t_tasks_se_num) {
+	BUG_ON(frame_len && list_empty(&se_cmd->t_mem_list));
+	if (frame_len) {
 		mem = list_first_entry(&se_cmd->t_mem_list,
 				       struct se_mem, se_list);
 		mem_len = mem->se_len;
 		mem_off = mem->se_off;
 		page = mem->se_page;
-	} else {
-		mem = NULL;
-		page = NULL;
-		mem_off = 0;
-		mem_len = frame_len;
 	}
 
 	while (frame_len) {
@@ -340,19 +317,15 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 
 		tlen = min(mem_len, frame_len);
 
-		if (mem) {
-			to = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
-					 KM_SOFTIRQ0);
-			page_addr = to;
-			to += mem_off & ~PAGE_MASK;
-			tlen = min(tlen, (size_t)(PAGE_SIZE -
-						(mem_off & ~PAGE_MASK)));
-			memcpy(to, from, tlen);
-			kunmap_atomic(page_addr, KM_SOFTIRQ0);
-		} else {
-			to = se_cmd->t_task_buf + mem_off;
-			memcpy(to, from, tlen);
-		}
+		to = kmap_atomic(page + (mem_off >> PAGE_SHIFT),
+				 KM_SOFTIRQ0);
+		page_addr = to;
+		to += mem_off & ~PAGE_MASK;
+		tlen = min(tlen, (size_t)(PAGE_SIZE -
+					  (mem_off & ~PAGE_MASK)));
+		memcpy(to, from, tlen);
+		kunmap_atomic(page_addr, KM_SOFTIRQ0);
+
 		from += tlen;
 		frame_len -= tlen;
 		mem_off += tlen;
diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
index 1271d4e..4dacc1d 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
@@ -517,16 +517,6 @@ int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 
 		cmd->sg_cnt = se_cmd->t_tasks_sg_chained_no;
 		cmd->sg = se_cmd->t_tasks_sg_chained;
-	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		/*
-		 * Use se_cmd->t_task->t_tasks_sg_bounce for control CDBs
-		 * using a contiguous buffer
-		 */
-		sg_init_table(&se_cmd->t_tasks_sg_bounce, 1);
-		sg_set_buf(&se_cmd->t_tasks_sg_bounce,
-			se_cmd->t_task_buf, se_cmd->data_length);
-		cmd->sg_cnt = 1;
-		cmd->sg = &se_cmd->t_tasks_sg_bounce;
 	} else {
 		printk(KERN_ERR "Unknown se_cmd_flags: 0x%08x in"
 			" tcm_qla2xxx_write_pending()\n", se_cmd->se_cmd_flags);
@@ -729,17 +719,6 @@ int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 
 		cmd->sg_cnt = se_cmd->t_tasks_sg_chained_no;
 		cmd->sg = se_cmd->t_tasks_sg_chained;
-	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		/*
-		 * Use se_cmd->t_task->t_tasks_sg_bounce for control CDBs
-		 * using a contigious buffer
-		 */
-		sg_init_table(&se_cmd->t_tasks_sg_bounce, 1);
-		sg_set_buf(&se_cmd->t_tasks_sg_bounce,
-			se_cmd->t_task_buf, se_cmd->data_length);
-
-		cmd->sg_cnt = 1;
-		cmd->sg = &se_cmd->t_tasks_sg_bounce;
 	} else {
 		cmd->sg_cnt = 0;
 		cmd->sg = NULL;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 464ecd2..91a1d93 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -109,7 +109,6 @@ enum se_cmd_flags_table {
 	SCF_EMULATED_TASK_SENSE		= 0x00000004,
 	SCF_SCSI_DATA_SG_IO_CDB		= 0x00000008,
 	SCF_SCSI_CONTROL_SG_IO_CDB	= 0x00000010,
-	SCF_SCSI_CONTROL_NONSG_IO_CDB	= 0x00000020,
 	SCF_SCSI_NON_DATA_CDB		= 0x00000040,
 	SCF_SCSI_CDB_EXCEPTION		= 0x00000080,
 	SCF_SCSI_RESERVATION_CONFLICT	= 0x00000100,
@@ -516,8 +515,7 @@ struct se_cmd {
 	struct completion	transport_lun_fe_stop_comp;
 	struct completion	transport_lun_stop_comp;
 	struct scatterlist	*t_tasks_sg_chained;
-	struct scatterlist	t_tasks_sg_bounce;
-	void			*t_task_buf;
+
 	/*
 	 * Used for pre-registered fabric SGL passthrough WRITE and READ
 	 * with the special SCF_PASSTHROUGH_CONTIG_TO_SG case for TCM_Loop
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 2aae764..7d10fb5 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -163,6 +163,8 @@ extern void transport_init_se_cmd(struct se_cmd *,
 					struct target_core_fabric_ops *,
 					struct se_session *, u32, int, int,
 					unsigned char *);
+void *transport_kmap_first_data_page(struct se_cmd *cmd);
+void transport_kunmap_first_data_page(struct se_cmd *cmd);
 extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_generic_handle_cdb(struct se_cmd *);
@@ -235,10 +237,6 @@ struct se_subsystem_api {
 	 */
 	int (*cdb_none)(struct se_task *);
 	/*
-	 * For SCF_SCSI_CONTROL_NONSG_IO_CDB
-	 */
-	int (*map_task_non_SG)(struct se_task *);
-	/*
 	 * For SCF_SCSI_DATA_SG_IO_CDB and SCF_SCSI_CONTROL_SG_IO_CDB
 	 */
 	int (*map_task_SG)(struct se_task *);
-- 
1.7.1


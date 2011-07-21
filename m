From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 054/103] target: inline struct se_transport_task into struct se_cmd
Date: Thu, 21 Jul 2011 00:08:06 -0700
Message-ID: <1311232135-6653-55-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm12.access.bullet.mail.sp2.yahoo.com ([98.139.44.139]:38641
	"HELO nm12.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751720Ab1GUHE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:57 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Continuing the previous patch to make se_transport_task a member
of se_cmd, this removes the nested se_transport_task struct.
There doesn't appear to be any need for a second struct, and
combining the two may let us find redundancies between the two
that we can do without.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |    4 +-
 drivers/target/target_core_alua.c      |    4 +-
 drivers/target/target_core_cdb.c       |   39 +-
 drivers/target/target_core_device.c    |    6 +-
 drivers/target/target_core_file.c      |    8 +-
 drivers/target/target_core_iblock.c    |    4 +-
 drivers/target/target_core_pr.c        |   22 +-
 drivers/target/target_core_pscsi.c     |   10 +-
 drivers/target/target_core_rd.c        |    8 +-
 drivers/target/target_core_tmr.c       |   56 ++--
 drivers/target/target_core_transport.c |  710 ++++++++++++++++----------------
 drivers/target/target_core_ua.c        |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c        |   14 +-
 drivers/target/tcm_fc/tfc_io.c         |   21 +-
 include/target/target_core_base.h      |  106 +++---
 15 files changed, 500 insertions(+), 514 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index e0e8aaa..f6f78f1 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -118,7 +118,7 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 	 * Signal BIDI usage with T_TASK(cmd)->t_tasks_bidi
 	 */
 	if (scsi_bidi_cmnd(sc))
-		se_cmd->t_task.t_tasks_bidi = 1;
+		se_cmd->t_tasks_bidi = 1;
 	/*
 	 * Locate the struct se_lun pointer and attach it to struct se_cmd
 	 */
@@ -169,7 +169,7 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 	 * For BIDI commands, pass in the extra READ buffer
 	 * to transport_generic_map_mem_to_cmd() below..
 	 */
-	if (se_cmd->t_task.t_tasks_bidi) {
+	if (se_cmd->t_tasks_bidi) {
 		struct scsi_data_buffer *sdb = scsi_in(sc);
 
 		sgl_bidi = sdb->table.sgl;
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 76abd86..76d506f 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -65,7 +65,7 @@ int core_emulate_report_target_port_groups(struct se_cmd *cmd)
 	struct se_port *port;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	u32 rd_len = 0, off = 4; /* Skip over RESERVED area to first
 				    Target port group descriptor */
 
@@ -157,7 +157,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	struct se_node_acl *nacl = cmd->se_sess->se_node_acl;
 	struct t10_alua_tg_pt_gp *tg_pt_gp = NULL, *l_tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem, *l_tg_pt_gp_mem;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	unsigned char *ptr = &buf[4]; /* Skip over RESERVED area in header */
 	u32 len = 4; /* Skip over RESERVED area in header */
 	int alua_access_state, primary = 0, rc;
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 8d5a0fc..09ef3f8 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -66,7 +66,7 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 {
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task.t_task_buf;
+	unsigned char *buf = cmd->t_task_buf;
 
 	/*
 	 * Make sure we at least have 6 bytes of INQUIRY response
@@ -621,8 +621,8 @@ static int
 target_emulate_inquiry(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task.t_task_buf;
-	unsigned char *cdb = cmd->t_task.t_task_cdb;
+	unsigned char *buf = cmd->t_task_buf;
+	unsigned char *cdb = cmd->t_task_cdb;
 
 	if (!(cdb[1] & 0x1))
 		return target_emulate_inquiry_std(cmd);
@@ -666,7 +666,7 @@ static int
 target_emulate_readcapacity(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task.t_task_buf;
+	unsigned char *buf = cmd->t_task_buf;
 	unsigned long long blocks_long = dev->transport->get_blocks(dev);
 	u32 blocks;
 
@@ -696,7 +696,7 @@ static int
 target_emulate_readcapacity_16(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task.t_task_buf;
+	unsigned char *buf = cmd->t_task_buf;
 	unsigned long long blocks = dev->transport->get_blocks(dev);
 
 	buf[0] = (blocks >> 56) & 0xff;
@@ -831,8 +831,8 @@ static int
 target_emulate_modesense(struct se_cmd *cmd, int ten)
 {
 	struct se_device *dev = cmd->se_dev;
-	char *cdb = cmd->t_task.t_task_cdb;
-	unsigned char *rbuf = cmd->t_task.t_task_buf;
+	char *cdb = cmd->t_task_cdb;
+	unsigned char *rbuf = cmd->t_task_buf;
 	int type = dev->transport->get_device_type(dev);
 	int offset = (ten) ? 8 : 4;
 	int length = 0;
@@ -903,8 +903,8 @@ target_emulate_modesense(struct se_cmd *cmd, int ten)
 static int
 target_emulate_request_sense(struct se_cmd *cmd)
 {
-	unsigned char *cdb = cmd->t_task.t_task_cdb;
-	unsigned char *buf = cmd->t_task.t_task_buf;
+	unsigned char *cdb = cmd->t_task_cdb;
+	unsigned char *buf = cmd->t_task_buf;
 	u8 ua_asc = 0, ua_ascq = 0;
 
 	if (cdb[1] & 0x01) {
@@ -965,8 +965,8 @@ target_emulate_unmap(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
-	unsigned char *buf = cmd->t_task.t_task_buf, *ptr = NULL;
-	unsigned char *cdb = &cmd->t_task.t_task_cdb[0];
+	unsigned char *buf = cmd->t_task_buf, *ptr = NULL;
+	unsigned char *cdb = &cmd->t_task_cdb[0];
 	sector_t lba;
 	unsigned int size = cmd->data_length, range;
 	int ret, offset;
@@ -1012,7 +1012,8 @@ target_emulate_write_same(struct se_task *task, int write_same32)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
-	sector_t range, lba = cmd->t_task.t_task_lba;
+	sector_t range;
+	sector_t lba = cmd->t_task_lba;
 	unsigned int num_blocks;
 	int ret;
 	/*
@@ -1021,9 +1022,9 @@ target_emulate_write_same(struct se_task *task, int write_same32)
 	 * range based on ->get_blocks() - starting LBA.
 	 */
 	if (write_same32)
-		num_blocks = get_unaligned_be32(&cmd->t_task.t_task_cdb[28]);
+		num_blocks = get_unaligned_be32(&cmd->t_task_cdb[28]);
 	else
-		num_blocks = get_unaligned_be32(&cmd->t_task.t_task_cdb[10]);
+		num_blocks = get_unaligned_be32(&cmd->t_task_cdb[10]);
 
 	if (num_blocks != 0)
 		range = num_blocks;
@@ -1052,7 +1053,7 @@ transport_emulate_control_cdb(struct se_task *task)
 	unsigned short service_action;
 	int ret = 0;
 
-	switch (cmd->t_task.t_task_cdb[0]) {
+	switch (cmd->t_task_cdb[0]) {
 	case INQUIRY:
 		ret = target_emulate_inquiry(cmd);
 		break;
@@ -1066,13 +1067,13 @@ transport_emulate_control_cdb(struct se_task *task)
 		ret = target_emulate_modesense(cmd, 1);
 		break;
 	case SERVICE_ACTION_IN:
-		switch (cmd->t_task.t_task_cdb[1] & 0x1f) {
+		switch (cmd->t_task_cdb[1] & 0x1f) {
 		case SAI_READ_CAPACITY_16:
 			ret = target_emulate_readcapacity_16(cmd);
 			break;
 		default:
 			printk(KERN_ERR "Unsupported SA: 0x%02x\n",
-				cmd->t_task.t_task_cdb[1] & 0x1f);
+				cmd->t_task_cdb[1] & 0x1f);
 			return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
 		break;
@@ -1097,7 +1098,7 @@ transport_emulate_control_cdb(struct se_task *task)
 		break;
 	case VARIABLE_LENGTH_CMD:
 		service_action =
-			get_unaligned_be16(&cmd->t_task.t_task_cdb[8]);
+			get_unaligned_be16(&cmd->t_task_cdb[8]);
 		switch (service_action) {
 		case WRITE_SAME_32:
 			if (!dev->transport->do_discard) {
@@ -1136,7 +1137,7 @@ transport_emulate_control_cdb(struct se_task *task)
 		break;
 	default:
 		printk(KERN_ERR "Unsupported SCSI Opcode: 0x%02x for %s\n",
-			cmd->t_task.t_task_cdb[0], dev->transport->name);
+			cmd->t_task_cdb[0], dev->transport->name);
 		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 	}
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ea92f75..c674a5d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -168,7 +168,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	 */
 	spin_lock_irqsave(&se_lun->lun_cmd_lock, flags);
 	list_add_tail(&se_cmd->se_lun_node, &se_lun->lun_cmd_list);
-	atomic_set(&se_cmd->t_task.transport_lun_active, 1);
+	atomic_set(&se_cmd->transport_lun_active, 1);
 	spin_unlock_irqrestore(&se_lun->lun_cmd_lock, flags);
 
 	return 0;
@@ -656,10 +656,10 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	struct se_lun *se_lun;
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_task *se_task;
-	unsigned char *buf = se_cmd->t_task.t_task_buf;
+	unsigned char *buf = se_cmd->t_task_buf;
 	u32 cdb_offset = 0, lun_count = 0, offset = 8, i;
 
-	list_for_each_entry(se_task, &se_cmd->t_task.t_task_list, t_list)
+	list_for_each_entry(se_task, &se_cmd->t_task_list, t_list)
 		break;
 
 	if (!(se_task)) {
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2e7ea74..5c47f42 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -377,7 +377,7 @@ static void fd_emulate_sync_cache(struct se_task *task)
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct se_device *dev = cmd->se_dev;
 	struct fd_dev *fd_dev = dev->dev_ptr;
-	int immed = (cmd->t_task.t_task_cdb[1] & 0x2);
+	int immed = (cmd->t_task_cdb[1] & 0x2);
 	loff_t start, end;
 	int ret;
 
@@ -391,11 +391,11 @@ static void fd_emulate_sync_cache(struct se_task *task)
 	/*
 	 * Determine if we will be flushing the entire device.
 	 */
-	if (cmd->t_task.t_task_lba == 0 && cmd->data_length == 0) {
+	if (cmd->t_task_lba == 0 && cmd->data_length == 0) {
 		start = 0;
 		end = LLONG_MAX;
 	} else {
-		start = cmd->t_task.t_task_lba * dev->se_sub_dev->se_dev_attrib.block_size;
+		start = cmd->t_task_lba * dev->se_sub_dev->se_dev_attrib.block_size;
 		if (cmd->data_length)
 			end = start + cmd->data_length;
 		else
@@ -475,7 +475,7 @@ static int fd_do_task(struct se_task *task)
 		if (ret > 0 &&
 		    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&
 		    dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
-		    cmd->t_task.t_tasks_fua) {
+		    cmd->t_tasks_fua) {
 			/*
 			 * We might need to be a bit smarter here
 			 * and return some sense data to let the initiator
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c73baef..814a85b 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -331,7 +331,7 @@ static void iblock_emulate_sync_cache(struct se_task *task)
 {
 	struct se_cmd *cmd = task->task_se_cmd;
 	struct iblock_dev *ib_dev = cmd->se_dev->dev_ptr;
-	int immed = (cmd->t_task.t_task_cdb[1] & 0x2);
+	int immed = (cmd->t_task_cdb[1] & 0x2);
 	sector_t error_sector;
 	int ret;
 
@@ -400,7 +400,7 @@ static int iblock_do_task(struct se_task *task)
 		 */
 		if (dev->se_sub_dev->se_dev_attrib.emulate_write_cache == 0 ||
 		    (dev->se_sub_dev->se_dev_attrib.emulate_fua_write > 0 &&
-		     task->task_se_cmd->t_task.t_tasks_fua))
+		     task->task_se_cmd->t_tasks_fua))
 			rw = WRITE_FUA;
 		else
 			rw = WRITE;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 19406a3..4fdede8 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -157,8 +157,8 @@ static int core_scsi2_reservation_reserve(struct se_cmd *cmd)
 	struct se_session *sess = cmd->se_sess;
 	struct se_portal_group *tpg = sess->se_tpg;
 
-	if ((cmd->t_task.t_task_cdb[1] & 0x01) &&
-	    (cmd->t_task.t_task_cdb[1] & 0x02)) {
+	if ((cmd->t_task_cdb[1] & 0x01) &&
+	    (cmd->t_task_cdb[1] & 0x02)) {
 		printk(KERN_ERR "LongIO and Obselete Bits set, returning"
 				" ILLEGAL_REQUEST\n");
 		return PYX_TRANSPORT_ILLEGAL_REQUEST;
@@ -216,7 +216,7 @@ int core_scsi2_emulate_crh(struct se_cmd *cmd)
 	struct se_subsystem_dev *su_dev = cmd->se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
 	struct t10_reservation *pr_tmpl = &su_dev->t10_pr;
-	unsigned char *cdb = &cmd->t_task.t_task_cdb[0];
+	unsigned char *cdb = &cmd->t_task_cdb[0];
 	int crh = (su_dev->t10_pr.res_type == SPC3_PERSISTENT_RESERVATIONS);
 	int conflict = 0;
 
@@ -1482,7 +1482,7 @@ static int core_scsi3_decode_spec_i_port(
 	struct list_head tid_dest_list;
 	struct pr_transport_id_holder *tidh_new, *tidh, *tidh_tmp;
 	struct target_core_fabric_ops *tmp_tf_ops;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	unsigned char *ptr, *i_str = NULL, proto_ident, tmp_proto_ident;
 	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tpdl, tid_len = 0;
@@ -3307,7 +3307,7 @@ static int core_scsi3_emulate_pro_register_and_move(
 	struct target_core_fabric_ops *dest_tf_ops = NULL, *tf_ops;
 	struct t10_pr_registration *pr_reg, *pr_res_holder, *dest_pr_reg;
 	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	unsigned char *initiator_str;
 	char *iport_ptr = NULL, dest_iport[64], i_buf[PR_REG_ISID_ID_LEN];
 	u32 tid_len, tmp_tid_len;
@@ -3723,7 +3723,7 @@ static unsigned long long core_scsi3_extract_reservation_key(unsigned char *cdb)
  */
 static int core_scsi3_emulate_pr_out(struct se_cmd *cmd, unsigned char *cdb)
 {
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	u64 res_key, sa_res_key;
 	int sa, scope, type, aptpl;
 	int spec_i_pt = 0, all_tg_pt = 0, unreg = 0;
@@ -3830,7 +3830,7 @@ static int core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	struct se_device *se_dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	u32 add_len = 0, off = 8;
 
 	if (cmd->data_length < 8) {
@@ -3885,7 +3885,7 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 	struct se_device *se_dev = cmd->se_dev;
 	struct se_subsystem_dev *su_dev = se_dev->se_sub_dev;
 	struct t10_pr_registration *pr_reg;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	u64 pr_res_key;
 	u32 add_len = 16; /* Hardcoded to 16 when a reservation is held. */
 
@@ -3965,7 +3965,7 @@ static int core_scsi3_pri_report_capabilities(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct t10_reservation *pr_tmpl = &dev->se_sub_dev->t10_pr;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	u16 add_len = 8; /* Hardcoded to 8. */
 
 	if (cmd->data_length < 6) {
@@ -4020,7 +4020,7 @@ static int core_scsi3_pri_read_full_status(struct se_cmd *cmd)
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &se_dev->se_sub_dev->t10_pr;
-	unsigned char *buf = (unsigned char *)cmd->t_task.t_task_buf;
+	unsigned char *buf = (unsigned char *)cmd->t_task_buf;
 	u32 add_desc_len = 0, add_len = 0, desc_len, exp_desc_len;
 	u32 off = 8; /* off into first Full Status descriptor */
 	int format_code = 0;
@@ -4174,7 +4174,7 @@ static int core_scsi3_emulate_pr_in(struct se_cmd *cmd, unsigned char *cdb)
 
 int core_scsi3_emulate_pr(struct se_cmd *cmd)
 {
-	unsigned char *cdb = &cmd->t_task.t_task_cdb[0];
+	unsigned char *cdb = &cmd->t_task_cdb[0];
 	struct se_device *dev = cmd->se_dev;
 	/*
 	 * Following spc2r20 5.5.1 Reservations overview:
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index ecfe889..a62350d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -697,7 +697,7 @@ static int pscsi_transport_complete(struct se_task *task)
 
 		if (task->task_se_cmd->se_deve->lun_flags &
 				TRANSPORT_LUNFLAGS_READ_ONLY) {
-			unsigned char *buf = task->task_se_cmd->t_task.t_task_buf;
+			unsigned char *buf = task->task_se_cmd->t_task_buf;
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
@@ -763,7 +763,7 @@ static struct se_task *
 pscsi_alloc_task(struct se_cmd *cmd)
 {
 	struct pscsi_plugin_task *pt;
-	unsigned char *cdb = cmd->t_task.t_task_cdb;
+	unsigned char *cdb = cmd->t_task_cdb;
 
 	pt = kzalloc(sizeof(struct pscsi_plugin_task), GFP_KERNEL);
 	if (!pt) {
@@ -776,7 +776,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
 	 * allocate the extended CDB buffer for per struct se_task context
 	 * pt->pscsi_cdb now.
 	 */
-	if (cmd->t_task.t_task_cdb != cmd->t_task.__t_task_cdb) {
+	if (cmd->t_task_cdb != cmd->__t_task_cdb) {
 
 		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
 		if (!(pt->pscsi_cdb)) {
@@ -889,7 +889,7 @@ static void pscsi_free_task(struct se_task *task)
 	 * Release the extended CDB allocation from pscsi_alloc_task()
 	 * if one exists.
 	 */
-	if (cmd->t_task.t_task_cdb != cmd->t_task.__t_task_cdb)
+	if (cmd->t_task_cdb != cmd->__t_task_cdb)
 		kfree(pt->pscsi_cdb);
 	/*
 	 * We do not release the bio(s) here associated with this task, as
@@ -1266,7 +1266,7 @@ static int pscsi_map_task_non_SG(struct se_task *task)
 		return 0;
 
 	ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
-			pt->pscsi_req, cmd->t_task.t_task_buf,
+			pt->pscsi_req, cmd->t_task_buf,
 			task->task_size, GFP_KERNEL);
 	if (ret < 0) {
 		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 384a8e2..4f9416d 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -737,7 +737,7 @@ check_eot:
 	}
 
 out:
-	task->task_se_cmd->t_task.t_tasks_se_num += *se_mem_cnt;
+	task->task_se_cmd->t_tasks_se_num += *se_mem_cnt;
 #ifdef DEBUG_RAMDISK_DR
 	printk(KERN_INFO "RD_DR - Allocated %u struct se_mem segments for task\n",
 			*se_mem_cnt);
@@ -819,7 +819,7 @@ static int rd_DIRECT_without_offset(
 	}
 
 out:
-	task->task_se_cmd->t_task.t_tasks_se_num += *se_mem_cnt;
+	task->task_se_cmd->t_tasks_se_num += *se_mem_cnt;
 #ifdef DEBUG_RAMDISK_DR
 	printk(KERN_INFO "RD_DR - Allocated %u struct se_mem segments for task\n",
 			*se_mem_cnt);
@@ -880,14 +880,14 @@ static int rd_DIRECT_do_se_mem_map(
 	 * across multiple struct se_task->task_sg[].
 	 */
 	ret = transport_init_task_sg(task,
-			list_first_entry(&cmd->t_task.t_mem_list,
+			list_first_entry(&cmd->t_mem_list,
 				   struct se_mem, se_list),
 			task_offset);
 	if (ret <= 0)
 		return ret;
 
 	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
-			list_first_entry(&cmd->t_task.t_mem_list,
+			list_first_entry(&cmd->t_mem_list,
 				   struct se_mem, se_list),
 			out_se_mem, se_mem_cnt, task_offset_in);
 }
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index e1f99f7..4235e72 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -178,14 +178,14 @@ int core_tmr_lun_reset(
 			continue;
 		spin_unlock(&dev->se_tmr_lock);
 
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-		if (!(atomic_read(&cmd->t_task.t_transport_active))) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
+		if (!(atomic_read(&cmd->t_transport_active))) {
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 			spin_lock(&dev->se_tmr_lock);
 			continue;
 		}
 		if (cmd->t_state == TRANSPORT_ISTATE_PROCESSING) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 			spin_lock(&dev->se_tmr_lock);
 			continue;
 		}
@@ -193,7 +193,7 @@ int core_tmr_lun_reset(
 			" Response: 0x%02x, t_state: %d\n",
 			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
 			tmr_p->function, tmr_p->response, cmd->t_state);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 		transport_cmd_finish_abort_tmr(cmd);
 		spin_lock(&dev->se_tmr_lock);
@@ -247,38 +247,38 @@ int core_tmr_lun_reset(
 		atomic_set(&task->task_state_active, 0);
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
 		DEBUG_LR("LUN_RESET: %s cmd: %p task: %p"
 			" ITT/CmdSN: 0x%08x/0x%08x, i_state: %d, t_state/"
 			"def_t_state: %d/%d cdb: 0x%02x\n",
 			(preempt_and_abort_list) ? "Preempt" : "", cmd, task,
 			cmd->se_tfo->get_task_tag(cmd), 0,
 			cmd->se_tfo->get_cmd_state(cmd), cmd->t_state,
-			cmd->deferred_t_state, cmd->t_task.t_task_cdb[0]);
+			cmd->deferred_t_state, cmd->t_task_cdb[0]);
 		DEBUG_LR("LUN_RESET: ITT[0x%08x] - pr_res_key: 0x%016Lx"
 			" t_task_cdbs: %d t_task_cdbs_left: %d"
 			" t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
 			cmd->se_tfo->get_task_tag(cmd), cmd->pr_res_key,
-			cmd->t_task.t_task_cdbs,
-			atomic_read(&cmd->t_task.t_task_cdbs_left),
-			atomic_read(&cmd->t_task.t_task_cdbs_sent),
-			atomic_read(&cmd->t_task.t_transport_active),
-			atomic_read(&cmd->t_task.t_transport_stop),
-			atomic_read(&cmd->t_task.t_transport_sent));
+			cmd->t_task_cdbs,
+			atomic_read(&cmd->t_task_cdbs_left),
+			atomic_read(&cmd->t_task_cdbs_sent),
+			atomic_read(&cmd->t_transport_active),
+			atomic_read(&cmd->t_transport_stop),
+			atomic_read(&cmd->t_transport_sent));
 
 		if (atomic_read(&task->task_active)) {
 			atomic_set(&task->task_stop, 1);
 			spin_unlock_irqrestore(
-				&cmd->t_task.t_state_lock, flags);
+				&cmd->t_state_lock, flags);
 
 			DEBUG_LR("LUN_RESET: Waiting for task: %p to shutdown"
 				" for dev: %p\n", task, dev);
 			wait_for_completion(&task->task_stop_comp);
 			DEBUG_LR("LUN_RESET Completed task: %p shutdown for"
 				" dev: %p\n", task, dev);
-			spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-			atomic_dec(&cmd->t_task.t_task_cdbs_left);
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			atomic_dec(&cmd->t_task_cdbs_left);
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
@@ -288,24 +288,24 @@ int core_tmr_lun_reset(
 		}
 		__transport_stop_task_timer(task, &flags);
 
-		if (!(atomic_dec_and_test(&cmd->t_task.t_task_cdbs_ex_left))) {
+		if (!(atomic_dec_and_test(&cmd->t_task_cdbs_ex_left))) {
 			spin_unlock_irqrestore(
-					&cmd->t_task.t_state_lock, flags);
+					&cmd->t_state_lock, flags);
 			DEBUG_LR("LUN_RESET: Skipping task: %p, dev: %p for"
 				" t_task_cdbs_ex_left: %d\n", task, dev,
-				atomic_read(&cmd->t_task.t_task_cdbs_ex_left));
+				atomic_read(&cmd->t_task_cdbs_ex_left));
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
-		fe_count = atomic_read(&cmd->t_task.t_fe_count);
+		fe_count = atomic_read(&cmd->t_fe_count);
 
-		if (atomic_read(&cmd->t_task.t_transport_active)) {
+		if (atomic_read(&cmd->t_transport_active)) {
 			DEBUG_LR("LUN_RESET: got t_transport_active = 1 for"
 				" task: %p, t_fe_count: %d dev: %p\n", task,
 				fe_count, dev);
-			atomic_set(&cmd->t_task.t_transport_aborted, 1);
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+			atomic_set(&cmd->t_transport_aborted, 1);
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 						flags);
 			core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
 
@@ -314,8 +314,8 @@ int core_tmr_lun_reset(
 		}
 		DEBUG_LR("LUN_RESET: Got t_transport_active = 0 for task: %p,"
 			" t_fe_count: %d dev: %p\n", task, fe_count, dev);
-		atomic_set(&cmd->t_task.t_transport_aborted, 1);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		atomic_set(&cmd->t_transport_aborted, 1);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
 
 		spin_lock_irqsave(&dev->execute_task_lock, flags);
@@ -345,7 +345,7 @@ int core_tmr_lun_reset(
 		if (prout_cmd == cmd)
 			continue;
 
-		atomic_dec(&cmd->t_task.t_transport_queue_active);
+		atomic_dec(&cmd->t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);
 		list_del(&cmd->se_queue_node);
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
@@ -353,7 +353,7 @@ int core_tmr_lun_reset(
 		DEBUG_LR("LUN_RESET: %s from Device Queue: cmd: %p t_state:"
 			" %d t_fe_count: %d\n", (preempt_and_abort_list) ?
 			"Preempt" : "", cmd, cmd->t_state,
-			atomic_read(&cmd->t_task.t_fe_count));
+			atomic_read(&cmd->t_fe_count));
 		/*
 		 * Signal that the command has failed via cmd->se_cmd_flags,
 		 * and call TFO->new_cmd_failure() to wakeup any fabric
@@ -365,7 +365,7 @@ int core_tmr_lun_reset(
 		transport_new_cmd_failure(cmd);
 
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas,
-				atomic_read(&cmd->t_task.t_fe_count));
+				atomic_read(&cmd->t_fe_count));
 		spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ccc5319..343dfb0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -572,7 +572,7 @@ void transport_deregister_session(struct se_session *se_sess)
 EXPORT_SYMBOL(transport_deregister_session);
 
 /*
- * Called with cmd->t_task.t_state_lock held.
+ * Called with cmd->t_state_lock held.
  */
 static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 {
@@ -580,7 +580,7 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 	struct se_task *task;
 	unsigned long flags;
 
-	list_for_each_entry(task, &cmd->t_task.t_task_list, t_list) {
+	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		dev = task->se_dev;
 		if (!(dev))
 			continue;
@@ -598,7 +598,7 @@ static void transport_all_task_dev_remove_state(struct se_cmd *cmd)
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 		atomic_set(&task->task_state_active, 0);
-		atomic_dec(&cmd->t_task.t_task_cdbs_ex_left);
+		atomic_dec(&cmd->t_task_cdbs_ex_left);
 	}
 }
 
@@ -617,32 +617,32 @@ static int transport_cmd_check_stop(
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * Determine if IOCTL context caller in requesting the stopping of this
 	 * command for LUN shutdown purposes.
 	 */
-	if (atomic_read(&cmd->t_task.transport_lun_stop)) {
-		DEBUG_CS("%s:%d atomic_read(&cmd->t_task.transport_lun_stop)"
+	if (atomic_read(&cmd->transport_lun_stop)) {
+		DEBUG_CS("%s:%d atomic_read(&cmd->transport_lun_stop)"
 			" == TRUE for ITT: 0x%08x\n", __func__, __LINE__,
 			cmd->se_tfo->get_task_tag(cmd));
 
 		cmd->deferred_t_state = cmd->t_state;
 		cmd->t_state = TRANSPORT_DEFERRED_CMD;
-		atomic_set(&cmd->t_task.t_transport_active, 0);
+		atomic_set(&cmd->t_transport_active, 0);
 		if (transport_off == 2)
 			transport_all_task_dev_remove_state(cmd);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-		complete(&cmd->t_task.transport_lun_stop_comp);
+		complete(&cmd->transport_lun_stop_comp);
 		return 1;
 	}
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 */
-	if (atomic_read(&cmd->t_task.t_transport_stop)) {
-		DEBUG_CS("%s:%d atomic_read(&cmd->t_task.t_transport_stop) =="
+	if (atomic_read(&cmd->t_transport_stop)) {
+		DEBUG_CS("%s:%d atomic_read(&cmd->t_transport_stop) =="
 			" TRUE for ITT: 0x%08x\n", __func__, __LINE__,
 			cmd->se_tfo->get_task_tag(cmd));
 
@@ -657,13 +657,13 @@ static int transport_cmd_check_stop(
 		 */
 		if (transport_off == 2)
 			cmd->se_lun = NULL;
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-		complete(&cmd->t_task.t_transport_stop_comp);
+		complete(&cmd->t_transport_stop_comp);
 		return 1;
 	}
 	if (transport_off) {
-		atomic_set(&cmd->t_task.t_transport_active, 0);
+		atomic_set(&cmd->t_transport_active, 0);
 		if (transport_off == 2) {
 			transport_all_task_dev_remove_state(cmd);
 			/*
@@ -678,18 +678,18 @@ static int transport_cmd_check_stop(
 			 */
 			if (cmd->se_tfo->check_stop_free != NULL) {
 				spin_unlock_irqrestore(
-					&cmd->t_task.t_state_lock, flags);
+					&cmd->t_state_lock, flags);
 
 				cmd->se_tfo->check_stop_free(cmd);
 				return 1;
 			}
 		}
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 		return 0;
 	} else if (t_state)
 		cmd->t_state = t_state;
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return 0;
 }
@@ -707,21 +707,21 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 	if (!lun)
 		return;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (!(atomic_read(&cmd->t_task.transport_dev_active))) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (!(atomic_read(&cmd->transport_dev_active))) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto check_lun;
 	}
-	atomic_set(&cmd->t_task.transport_dev_active, 0);
+	atomic_set(&cmd->transport_dev_active, 0);
 	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 
 check_lun:
 	spin_lock_irqsave(&lun->lun_cmd_lock, flags);
-	if (atomic_read(&cmd->t_task.transport_lun_active)) {
+	if (atomic_read(&cmd->transport_lun_active)) {
 		list_del(&cmd->se_lun_node);
-		atomic_set(&cmd->t_task.transport_lun_active, 0);
+		atomic_set(&cmd->transport_lun_active, 0);
 #if 0
 		printk(KERN_INFO "Removed ITT: 0x%08x from LUN LIST[%d]\n"
 			cmd->se_tfo->get_task_tag(cmd), lun->unpacked_lun);
@@ -762,15 +762,15 @@ static void transport_add_cmd_to_queue(
 	INIT_LIST_HEAD(&cmd->se_queue_node);
 
 	if (t_state) {
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
 		cmd->t_state = t_state;
-		atomic_set(&cmd->t_task.t_transport_active, 1);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		atomic_set(&cmd->t_transport_active, 1);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 	}
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
 	list_add_tail(&cmd->se_queue_node, &qobj->qobj_list);
-	atomic_inc(&cmd->t_task.t_transport_queue_active);
+	atomic_inc(&cmd->t_transport_queue_active);
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
 	atomic_inc(&qobj->queue_cnt);
@@ -790,7 +790,7 @@ transport_get_cmd_from_queue(struct se_queue_obj *qobj)
 	}
 	cmd = list_first_entry(&qobj->qobj_list, struct se_cmd, se_queue_node);
 
-	atomic_dec(&cmd->t_task.t_transport_queue_active);
+	atomic_dec(&cmd->t_transport_queue_active);
 
 	list_del(&cmd->se_queue_node);
 	atomic_dec(&qobj->queue_cnt);
@@ -806,24 +806,24 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 	unsigned long flags;
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	if (!(atomic_read(&cmd->t_task.t_transport_queue_active))) {
+	if (!(atomic_read(&cmd->t_transport_queue_active))) {
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 		return;
 	}
 
 	list_for_each_entry(t, &qobj->qobj_list, se_queue_node)
 		if (t == cmd) {
-			atomic_dec(&cmd->t_task.t_transport_queue_active);
+			atomic_dec(&cmd->t_transport_queue_active);
 			atomic_dec(&qobj->queue_cnt);
 			list_del(&cmd->se_queue_node);
 			break;
 		}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
-	if (atomic_read(&cmd->t_task.t_transport_queue_active)) {
+	if (atomic_read(&cmd->t_transport_queue_active)) {
 		printk(KERN_ERR "ITT: 0x%08x t_transport_queue_active: %d\n",
 			cmd->se_tfo->get_task_tag(cmd),
-			atomic_read(&cmd->t_task.t_transport_queue_active));
+			atomic_read(&cmd->t_transport_queue_active));
 	}
 }
 
@@ -833,7 +833,7 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
  */
 void transport_complete_sync_cache(struct se_cmd *cmd, int good)
 {
-	struct se_task *task = list_entry(cmd->t_task.t_task_list.next,
+	struct se_task *task = list_entry(cmd->t_task_list.next,
 				struct se_task, t_list);
 
 	if (good) {
@@ -863,12 +863,12 @@ void transport_complete_task(struct se_task *task, int success)
 	unsigned long flags;
 #if 0
 	printk(KERN_INFO "task: %p CDB: 0x%02x obj_ptr: %p\n", task,
-			cmd->t_task.t_task_cdb[0], dev);
+			cmd->t_task_cdb[0], dev);
 #endif
 	if (dev)
 		atomic_inc(&dev->depth_left);
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	atomic_set(&task->task_active, 0);
 
 	/*
@@ -890,14 +890,14 @@ void transport_complete_task(struct se_task *task, int success)
 	 */
 	if (atomic_read(&task->task_stop)) {
 		/*
-		 * Decrement cmd->t_task.t_se_count if this task had
+		 * Decrement cmd->t_se_count if this task had
 		 * previously thrown its timeout exception handler.
 		 */
 		if (atomic_read(&task->task_timeout)) {
-			atomic_dec(&cmd->t_task.t_se_count);
+			atomic_dec(&cmd->t_se_count);
 			atomic_set(&task->task_timeout, 0);
 		}
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 		complete(&task->task_stop_comp);
 		return;
@@ -909,33 +909,33 @@ void transport_complete_task(struct se_task *task, int success)
 	 */
 	if (atomic_read(&task->task_timeout)) {
 		if (!(atomic_dec_and_test(
-				&cmd->t_task.t_task_cdbs_timeout_left))) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+				&cmd->t_task_cdbs_timeout_left))) {
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 				flags);
 			return;
 		}
 		t_state = TRANSPORT_COMPLETE_TIMEOUT;
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 		transport_add_cmd_to_queue(cmd, t_state);
 		return;
 	}
-	atomic_dec(&cmd->t_task.t_task_cdbs_timeout_left);
+	atomic_dec(&cmd->t_task_cdbs_timeout_left);
 
 	/*
 	 * Decrement the outstanding t_task_cdbs_left count.  The last
 	 * struct se_task from struct se_cmd will complete itself into the
 	 * device queue depending upon int success.
 	 */
-	if (!(atomic_dec_and_test(&cmd->t_task.t_task_cdbs_left))) {
+	if (!(atomic_dec_and_test(&cmd->t_task_cdbs_left))) {
 		if (!success)
-			cmd->t_task.t_tasks_failed = 1;
+			cmd->t_tasks_failed = 1;
 
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
 
-	if (!success || cmd->t_task.t_tasks_failed) {
+	if (!success || cmd->t_tasks_failed) {
 		t_state = TRANSPORT_COMPLETE_FAILURE;
 		if (!task->task_error_status) {
 			task->task_error_status =
@@ -944,10 +944,10 @@ void transport_complete_task(struct se_task *task, int success)
 				PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
 		}
 	} else {
-		atomic_set(&cmd->t_task.t_transport_complete, 1);
+		atomic_set(&cmd->t_transport_complete, 1);
 		t_state = TRANSPORT_COMPLETE_OK;
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	transport_add_cmd_to_queue(cmd, t_state);
 }
@@ -1040,8 +1040,8 @@ static void transport_add_tasks_to_state_queue(struct se_cmd *cmd)
 	struct se_task *task;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	list_for_each_entry(task, &cmd->t_task.t_task_list, t_list) {
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		dev = task->se_dev;
 
 		if (atomic_read(&task->task_state_active))
@@ -1057,7 +1057,7 @@ static void transport_add_tasks_to_state_queue(struct se_cmd *cmd)
 
 		spin_unlock(&dev->execute_task_lock);
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
 static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
@@ -1067,7 +1067,7 @@ static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	list_for_each_entry(task, &cmd->t_task.t_task_list, t_list) {
+	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		if (atomic_read(&task->task_execute_queue))
 			continue;
 		/*
@@ -1669,14 +1669,14 @@ transport_generic_get_task(struct se_cmd *cmd,
 	INIT_LIST_HEAD(&task->t_execute_list);
 	INIT_LIST_HEAD(&task->t_state_list);
 	init_completion(&task->task_stop_comp);
-	task->task_no = cmd->t_task.t_tasks_no++;
+	task->task_no = cmd->t_tasks_no++;
 	task->task_se_cmd = cmd;
 	task->se_dev = dev;
 	task->task_data_direction = data_direction;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	list_add_tail(&task->t_list, &cmd->t_task.t_task_list);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	list_add_tail(&task->t_list, &cmd->t_task_list);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return task;
 }
@@ -1700,14 +1700,14 @@ void transport_init_se_cmd(
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_ordered_node);
 
-	INIT_LIST_HEAD(&cmd->t_task.t_mem_list);
-	INIT_LIST_HEAD(&cmd->t_task.t_mem_bidi_list);
-	INIT_LIST_HEAD(&cmd->t_task.t_task_list);
-	init_completion(&cmd->t_task.transport_lun_fe_stop_comp);
-	init_completion(&cmd->t_task.transport_lun_stop_comp);
-	init_completion(&cmd->t_task.t_transport_stop_comp);
-	spin_lock_init(&cmd->t_task.t_state_lock);
-	atomic_set(&cmd->t_task.transport_dev_active, 1);
+	INIT_LIST_HEAD(&cmd->t_mem_list);
+	INIT_LIST_HEAD(&cmd->t_mem_bidi_list);
+	INIT_LIST_HEAD(&cmd->t_task_list);
+	init_completion(&cmd->transport_lun_fe_stop_comp);
+	init_completion(&cmd->transport_lun_stop_comp);
+	init_completion(&cmd->t_transport_stop_comp);
+	spin_lock_init(&cmd->t_state_lock);
+	atomic_set(&cmd->transport_dev_active, 1);
 
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
@@ -1752,8 +1752,8 @@ void transport_free_se_cmd(
 	/*
 	 * Check and free any extended CDB buffer that was allocated
 	 */
-	if (se_cmd->t_task.t_task_cdb != se_cmd->t_task.__t_task_cdb)
-		kfree(se_cmd->t_task.t_task_cdb);
+	if (se_cmd->t_task_cdb != se_cmd->__t_task_cdb)
+		kfree(se_cmd->t_task_cdb);
 }
 EXPORT_SYMBOL(transport_free_se_cmd);
 
@@ -1791,26 +1791,26 @@ int transport_generic_allocate_tasks(
 	 * allocate the additional extended CDB buffer now..  Otherwise
 	 * setup the pointer from __t_task_cdb to t_task_cdb.
 	 */
-	if (scsi_command_size(cdb) > sizeof(cmd->t_task.__t_task_cdb)) {
-		cmd->t_task.t_task_cdb = kzalloc(scsi_command_size(cdb),
+	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
+		cmd->t_task_cdb = kzalloc(scsi_command_size(cdb),
 						GFP_KERNEL);
-		if (!(cmd->t_task.t_task_cdb)) {
-			printk(KERN_ERR "Unable to allocate cmd->t_task.t_task_cdb"
-				" %u > sizeof(cmd->t_task.__t_task_cdb): %lu ops\n",
+		if (!(cmd->t_task_cdb)) {
+			printk(KERN_ERR "Unable to allocate cmd->t_task_cdb"
+				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
-				(unsigned long)sizeof(cmd->t_task.__t_task_cdb));
+				(unsigned long)sizeof(cmd->__t_task_cdb));
 			return -ENOMEM;
 		}
 	} else
-		cmd->t_task.t_task_cdb = &cmd->t_task.__t_task_cdb[0];
+		cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
-	 * Copy the original CDB into cmd->t_task.
+	 * Copy the original CDB into cmd->
 	 */
-	memcpy(cmd->t_task.t_task_cdb, cdb, scsi_command_size(cdb));
+	memcpy(cmd->t_task_cdb, cdb, scsi_command_size(cdb));
 	/*
 	 * Setup the received CDB based on SCSI defined opcodes and
 	 * perform unit attention, persistent reservations and ALUA
-	 * checks for virtual device backends.  The cmd->t_task.t_task_cdb
+	 * checks for virtual device backends.  The cmd->t_task_cdb
 	 * pointer is expected to be setup before we reach this point.
 	 */
 	ret = transport_generic_cmd_sequencer(cmd, cdb);
@@ -1935,9 +1935,9 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 	/*
 	 * No tasks remain in the execution queue
 	 */
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
-				&cmd->t_task.t_task_list, t_list) {
+				&cmd->t_task_list, t_list) {
 		DEBUG_TS("task_no[%d] - Processing task %p\n",
 				task->task_no, task);
 		/*
@@ -1946,14 +1946,14 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 		 */
 		if (!atomic_read(&task->task_sent) &&
 		    !atomic_read(&task->task_active)) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 			transport_remove_task_from_execute_queue(task,
 					task->se_dev);
 
 			DEBUG_TS("task_no[%d] - Removed from execute queue\n",
 				task->task_no);
-			spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
 			continue;
 		}
 
@@ -1963,7 +1963,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 		 */
 		if (atomic_read(&task->task_active)) {
 			atomic_set(&task->task_stop, 1);
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 
 			DEBUG_TS("task_no[%d] - Waiting to complete\n",
@@ -1972,8 +1972,8 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 			DEBUG_TS("task_no[%d] - Stopped successfully\n",
 				task->task_no);
 
-			spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-			atomic_dec(&cmd->t_task.t_task_cdbs_left);
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			atomic_dec(&cmd->t_task_cdbs_left);
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
@@ -1984,7 +1984,7 @@ static int transport_stop_tasks_for_cmd(struct se_cmd *cmd)
 
 		__transport_stop_task_timer(task, &flags);
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return ret;
 }
@@ -2000,7 +2000,7 @@ static void transport_generic_request_failure(
 {
 	DEBUG_GRF("-----[ Storage Engine Exception for cmd: %p ITT: 0x%08x"
 		" CDB: 0x%02x\n", cmd, cmd->se_tfo->get_task_tag(cmd),
-		cmd->t_task.t_task_cdb[0]);
+		cmd->t_task_cdb[0]);
 	DEBUG_GRF("-----[ i_state: %d t_state/def_t_state:"
 		" %d/%d transport_error_status: %d\n",
 		cmd->se_tfo->get_cmd_state(cmd),
@@ -2009,13 +2009,13 @@ static void transport_generic_request_failure(
 	DEBUG_GRF("-----[ t_task_cdbs: %d t_task_cdbs_left: %d"
 		" t_task_cdbs_sent: %d t_task_cdbs_ex_left: %d --"
 		" t_transport_active: %d t_transport_stop: %d"
-		" t_transport_sent: %d\n", cmd->t_task.t_task_cdbs,
-		atomic_read(&cmd->t_task.t_task_cdbs_left),
-		atomic_read(&cmd->t_task.t_task_cdbs_sent),
-		atomic_read(&cmd->t_task.t_task_cdbs_ex_left),
-		atomic_read(&cmd->t_task.t_transport_active),
-		atomic_read(&cmd->t_task.t_transport_stop),
-		atomic_read(&cmd->t_task.t_transport_sent));
+		" t_transport_sent: %d\n", cmd->t_task_cdbs,
+		atomic_read(&cmd->t_task_cdbs_left),
+		atomic_read(&cmd->t_task_cdbs_sent),
+		atomic_read(&cmd->t_task_cdbs_ex_left),
+		atomic_read(&cmd->t_transport_active),
+		atomic_read(&cmd->t_transport_stop),
+		atomic_read(&cmd->t_transport_sent));
 
 	transport_stop_all_task_timers(cmd);
 
@@ -2097,7 +2097,7 @@ static void transport_generic_request_failure(
 		break;
 	default:
 		printk(KERN_ERR "Unknown transport error for CDB 0x%02x: %d\n",
-			cmd->t_task.t_task_cdb[0],
+			cmd->t_task_cdb[0],
 			cmd->transport_error_status);
 		cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
 		break;
@@ -2118,19 +2118,19 @@ static void transport_direct_request_timeout(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (!(atomic_read(&cmd->t_task.t_transport_timeout))) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (!(atomic_read(&cmd->t_transport_timeout))) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
-	if (atomic_read(&cmd->t_task.t_task_cdbs_timeout_left)) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	if (atomic_read(&cmd->t_task_cdbs_timeout_left)) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
 
-	atomic_sub(atomic_read(&cmd->t_task.t_transport_timeout),
-		   &cmd->t_task.t_se_count);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	atomic_sub(atomic_read(&cmd->t_transport_timeout),
+		   &cmd->t_se_count);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
 static void transport_generic_request_timeout(struct se_cmd *cmd)
@@ -2138,16 +2138,16 @@ static void transport_generic_request_timeout(struct se_cmd *cmd)
 	unsigned long flags;
 
 	/*
-	 * Reset cmd->t_task.t_se_count to allow transport_generic_remove()
+	 * Reset cmd->t_se_count to allow transport_generic_remove()
 	 * to allow last call to free memory resources.
 	 */
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (atomic_read(&cmd->t_task.t_transport_timeout) > 1) {
-		int tmp = (atomic_read(&cmd->t_task.t_transport_timeout) - 1);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (atomic_read(&cmd->t_transport_timeout) > 1) {
+		int tmp = (atomic_read(&cmd->t_transport_timeout) - 1);
 
-		atomic_sub(tmp, &cmd->t_task.t_se_count);
+		atomic_sub(tmp, &cmd->t_se_count);
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	transport_generic_remove(cmd, 0, 0);
 }
@@ -2163,8 +2163,8 @@ transport_generic_allocate_buf(struct se_cmd *cmd, u32 data_length)
 		return -ENOMEM;
 	}
 
-	cmd->t_task.t_tasks_se_num = 0;
-	cmd->t_task.t_task_buf = buf;
+	cmd->t_tasks_se_num = 0;
+	cmd->t_task_buf = buf;
 
 	return 0;
 }
@@ -2206,9 +2206,9 @@ static void transport_set_supported_SAM_opcode(struct se_cmd *se_cmd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&se_cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
 	se_cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	spin_unlock_irqrestore(&se_cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
 }
 
 /*
@@ -2222,9 +2222,9 @@ static void transport_task_timeout_handler(unsigned long data)
 
 	DEBUG_TT("transport task timeout fired! task: %p cmd: %p\n", task, cmd);
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (task->task_flags & TF_STOP) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
 	task->task_flags &= ~TF_RUNNING;
@@ -2235,13 +2235,13 @@ static void transport_task_timeout_handler(unsigned long data)
 	if (!(atomic_read(&task->task_active))) {
 		DEBUG_TT("transport task: %p cmd: %p timeout task_active"
 				" == 0\n", task, cmd);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
 
-	atomic_inc(&cmd->t_task.t_se_count);
-	atomic_inc(&cmd->t_task.t_transport_timeout);
-	cmd->t_task.t_tasks_failed = 1;
+	atomic_inc(&cmd->t_se_count);
+	atomic_inc(&cmd->t_transport_timeout);
+	cmd->t_tasks_failed = 1;
 
 	atomic_set(&task->task_timeout, 1);
 	task->task_error_status = PYX_TRANSPORT_TASK_TIMEOUT;
@@ -2250,28 +2250,28 @@ static void transport_task_timeout_handler(unsigned long data)
 	if (atomic_read(&task->task_stop)) {
 		DEBUG_TT("transport task: %p cmd: %p timeout task_stop"
 				" == 1\n", task, cmd);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		complete(&task->task_stop_comp);
 		return;
 	}
 
-	if (!(atomic_dec_and_test(&cmd->t_task.t_task_cdbs_left))) {
+	if (!(atomic_dec_and_test(&cmd->t_task_cdbs_left))) {
 		DEBUG_TT("transport task: %p cmd: %p timeout non zero"
 				" t_task_cdbs_left\n", task, cmd);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
 	DEBUG_TT("transport task: %p cmd: %p timeout ZERO t_task_cdbs_left\n",
 			task, cmd);
 
 	cmd->t_state = TRANSPORT_COMPLETE_FAILURE;
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	transport_add_cmd_to_queue(cmd, TRANSPORT_COMPLETE_FAILURE);
 }
 
 /*
- * Called with cmd->t_task.t_state_lock held.
+ * Called with cmd->t_state_lock held.
  */
 static void transport_start_task_timer(struct se_task *task)
 {
@@ -2301,7 +2301,7 @@ static void transport_start_task_timer(struct se_task *task)
 }
 
 /*
- * Called with spin_lock_irq(&cmd->t_task.t_state_lock) held.
+ * Called with spin_lock_irq(&cmd->t_state_lock) held.
  */
 void __transport_stop_task_timer(struct se_task *task, unsigned long *flags)
 {
@@ -2311,11 +2311,11 @@ void __transport_stop_task_timer(struct se_task *task, unsigned long *flags)
 		return;
 
 	task->task_flags |= TF_STOP;
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, *flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, *flags);
 
 	del_timer_sync(&task->task_timer);
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, *flags);
+	spin_lock_irqsave(&cmd->t_state_lock, *flags);
 	task->task_flags &= ~TF_RUNNING;
 	task->task_flags &= ~TF_STOP;
 }
@@ -2325,11 +2325,11 @@ static void transport_stop_all_task_timers(struct se_cmd *cmd)
 	struct se_task *task = NULL, *task_tmp;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
-				&cmd->t_task.t_task_list, t_list)
+				&cmd->t_task_list, t_list)
 		__transport_stop_task_timer(task, &flags);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
 static inline int transport_tcq_window_closed(struct se_device *dev)
@@ -2364,7 +2364,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 		smp_mb__after_atomic_inc();
 		DEBUG_STA("Added HEAD_OF_QUEUE for CDB:"
 			" 0x%02x, se_ordered_id: %u\n",
-			cmd->t_task->t_task_cdb[0],
+			cmd->_task_cdb[0],
 			cmd->se_ordered_id);
 		return 1;
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
@@ -2378,7 +2378,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 
 		DEBUG_STA("Added ORDERED for CDB: 0x%02x to ordered"
 				" list, se_ordered_id: %u\n",
-				cmd->t_task.t_task_cdb[0],
+				cmd->t_task_cdb[0],
 				cmd->se_ordered_id);
 		/*
 		 * Add ORDERED command to tail of execution queue if
@@ -2412,7 +2412,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 
 		DEBUG_STA("Added CDB: 0x%02x Task Attr: 0x%02x to"
 			" delayed CMD list, se_ordered_id: %u\n",
-			cmd->t_task.t_task_cdb[0], cmd->sam_task_attr,
+			cmd->t_task_cdb[0], cmd->sam_task_attr,
 			cmd->se_ordered_id);
 		/*
 		 * Return zero to let transport_execute_tasks() know
@@ -2486,7 +2486,7 @@ static int __transport_execute_tasks(struct se_device *dev)
 
 	/*
 	 * Check if there is enough room in the device and HBA queue to send
-	 * struct se_transport_task's to the selected transport.
+	 * struct se_tasks to the selected transport.
 	 */
 check_depth:
 	if (!atomic_read(&dev->depth_left))
@@ -2510,17 +2510,17 @@ check_depth:
 
 	cmd = task->task_se_cmd;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	atomic_set(&task->task_active, 1);
 	atomic_set(&task->task_sent, 1);
-	atomic_inc(&cmd->t_task.t_task_cdbs_sent);
+	atomic_inc(&cmd->t_task_cdbs_sent);
 
-	if (atomic_read(&cmd->t_task.t_task_cdbs_sent) ==
-	    cmd->t_task.t_task_cdbs)
+	if (atomic_read(&cmd->t_task_cdbs_sent) ==
+	    cmd->t_task_cdbs)
 		atomic_set(&cmd->transport_sent, 1);
 
 	transport_start_task_timer(task);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 	/*
 	 * The struct se_cmd->transport_emulate_cdb() function pointer is used
 	 * to grab REPORT_LUNS and other CDBs we want to handle before they hit the
@@ -2585,10 +2585,10 @@ void transport_new_cmd_failure(struct se_cmd *se_cmd)
 	 * Any unsolicited data will get dumped for failed command inside of
 	 * the fabric plugin
 	 */
-	spin_lock_irqsave(&se_cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
 	se_cmd->se_cmd_flags |= SCF_SE_CMD_FAILED;
 	se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
-	spin_unlock_irqrestore(&se_cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
 
 	se_cmd->se_tfo->new_cmd_failure(se_cmd);
 }
@@ -2798,18 +2798,18 @@ static void transport_xor_callback(struct se_cmd *cmd)
 		return;
 	}
 	/*
-	 * Copy the scatterlist WRITE buffer located at cmd->t_task.t_mem_list
+	 * Copy the scatterlist WRITE buffer located at cmd->t_mem_list
 	 * into the locally allocated *buf
 	 */
-	transport_memcpy_se_mem_read_contig(buf, &cmd->t_task.t_mem_list,
+	transport_memcpy_se_mem_read_contig(buf, &cmd->t_mem_list,
 					    cmd->data_length);
 	/*
 	 * Now perform the XOR against the BIDI read memory located at
-	 * cmd->t_task.t_mem_bidi_list
+	 * cmd->t_mem_bidi_list
 	 */
 
 	offset = 0;
-	list_for_each_entry(se_mem, &cmd->t_task.t_mem_bidi_list, se_list) {
+	list_for_each_entry(se_mem, &cmd->t_mem_bidi_list, se_list) {
 		addr = (unsigned char *)kmap_atomic(se_mem->se_page, KM_USER0);
 		if (!(addr))
 			goto out;
@@ -2837,14 +2837,14 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 
 	WARN_ON(!cmd->se_lun);
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return 0;
 	}
 
 	list_for_each_entry_safe(task, task_tmp,
-				&cmd->t_task.t_task_list, t_list) {
+				&cmd->t_task_list, t_list) {
 
 		if (!task->task_sense)
 			continue;
@@ -2866,7 +2866,7 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 				cmd->se_tfo->get_task_tag(cmd), task->task_no);
 			continue;
 		}
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 		offset = cmd->se_tfo->set_fabric_sense_len(cmd,
 				TRANSPORT_SENSE_BUFFER);
@@ -2884,7 +2884,7 @@ static int transport_get_sense_data(struct se_cmd *cmd)
 				cmd->scsi_status);
 		return 0;
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return -1;
 }
@@ -2999,7 +2999,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
-		cmd->t_task.t_task_lba = transport_lba_21(cdb);
+		cmd->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case READ_10:
@@ -3008,7 +3008,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
-		cmd->t_task.t_task_lba = transport_lba_32(cdb);
+		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case READ_12:
@@ -3017,7 +3017,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
-		cmd->t_task.t_task_lba = transport_lba_32(cdb);
+		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case READ_16:
@@ -3026,7 +3026,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
-		cmd->t_task.t_task_lba = transport_lba_64(cdb);
+		cmd->t_task_lba = transport_lba_64(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_6:
@@ -3035,7 +3035,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_6;
-		cmd->t_task.t_task_lba = transport_lba_21(cdb);
+		cmd->t_task_lba = transport_lba_21(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_10:
@@ -3044,8 +3044,8 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
-		cmd->t_task.t_task_lba = transport_lba_32(cdb);
-		cmd->t_task.t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_12:
@@ -3054,8 +3054,8 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_12;
-		cmd->t_task.t_task_lba = transport_lba_32(cdb);
-		cmd->t_task.t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task_lba = transport_lba_32(cdb);
+		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case WRITE_16:
@@ -3064,20 +3064,20 @@ static int transport_generic_cmd_sequencer(
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_16;
-		cmd->t_task.t_task_lba = transport_lba_64(cdb);
-		cmd->t_task.t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_task_lba = transport_lba_64(cdb);
+		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		break;
 	case XDWRITEREAD_10:
 		if ((cmd->data_direction != DMA_TO_DEVICE) ||
-		    !(cmd->t_task.t_tasks_bidi))
+		    !(cmd->t_tasks_bidi))
 			goto out_invalid_cdb_field;
 		sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
-		cmd->t_task.t_task_lba = transport_lba_32(cdb);
+		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
@@ -3090,7 +3090,7 @@ static int transport_generic_cmd_sequencer(
 		 * Setup BIDI XOR callback to be run during transport_generic_complete_ok()
 		 */
 		cmd->transport_complete_callback = &transport_xor_callback;
-		cmd->t_task.t_tasks_fua = (cdb[1] & 0x8);
+		cmd->t_tasks_fua = (cdb[1] & 0x8);
 		break;
 	case VARIABLE_LENGTH_CMD:
 		service_action = get_unaligned_be16(&cdb[8]);
@@ -3112,7 +3112,7 @@ static int transport_generic_cmd_sequencer(
 			 * XDWRITE_READ_32 logic.
 			 */
 			cmd->transport_split_cdb = &split_cdb_XX_32;
-			cmd->t_task.t_task_lba = transport_lba_64_ext(cdb);
+			cmd->t_task_lba = transport_lba_64_ext(cdb);
 			cmd->se_cmd_flags |= SCF_SCSI_DATA_SG_IO_CDB;
 
 			/*
@@ -3126,7 +3126,7 @@ static int transport_generic_cmd_sequencer(
 			 * transport_generic_complete_ok()
 			 */
 			cmd->transport_complete_callback = &transport_xor_callback;
-			cmd->t_task.t_tasks_fua = (cdb[10] & 0x8);
+			cmd->t_tasks_fua = (cdb[10] & 0x8);
 			break;
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb, cmd, &sector_ret);
@@ -3138,7 +3138,7 @@ static int transport_generic_cmd_sequencer(
 			else
 				size = dev->se_sub_dev->se_dev_attrib.block_size;
 
-			cmd->t_task.t_task_lba = get_unaligned_be64(&cdb[12]);
+			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 			cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
 
 			/*
@@ -3373,10 +3373,10 @@ static int transport_generic_cmd_sequencer(
 		 */
 		if (cdb[0] == SYNCHRONIZE_CACHE) {
 			sectors = transport_get_sectors_10(cdb, cmd, &sector_ret);
-			cmd->t_task.t_task_lba = transport_lba_32(cdb);
+			cmd->t_task_lba = transport_lba_32(cdb);
 		} else {
 			sectors = transport_get_sectors_16(cdb, cmd, &sector_ret);
-			cmd->t_task.t_task_lba = transport_lba_64(cdb);
+			cmd->t_task_lba = transport_lba_64(cdb);
 		}
 		if (sector_ret)
 			goto out_unsupported_cdb;
@@ -3427,7 +3427,7 @@ static int transport_generic_cmd_sequencer(
 		else
 			size = dev->se_sub_dev->se_dev_attrib.block_size;
 
-		cmd->t_task.t_task_lba = get_unaligned_be64(&cdb[2]);
+		cmd->t_task_lba = get_unaligned_be16(&cdb[2]);
 		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
@@ -3683,9 +3683,9 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 		 * contiguous buffer back to the original SGL.
 		 */
 		if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-			sg_copy_from_buffer(cmd->t_task.t_task_pt_sgl,
-					    cmd->t_task.t_task_pt_sgl_num,
-					    cmd->t_task.t_task_buf,
+			sg_copy_from_buffer(cmd->t_task_pt_sgl,
+					    cmd->t_task_pt_sgl_num,
+					    cmd->t_task_buf,
 					    cmd->data_length);
 
 		cmd->se_tfo->queue_data_in(cmd);
@@ -3700,7 +3700,7 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
-		if (!list_empty(&cmd->t_task.t_mem_bidi_list)) {
+		if (!list_empty(&cmd->t_mem_bidi_list)) {
 			spin_lock(&cmd->se_lun->lun_sep_lock);
 			if (cmd->se_lun->lun_sep) {
 				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
@@ -3727,9 +3727,9 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
 	struct se_task *task, *task_tmp;
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	list_for_each_entry_safe(task, task_tmp,
-				&cmd->t_task.t_task_list, t_list) {
+				&cmd->t_task_list, t_list) {
 		if (atomic_read(&task->task_active))
 			continue;
 
@@ -3738,15 +3738,15 @@ static void transport_free_dev_tasks(struct se_cmd *cmd)
 
 		list_del(&task->t_list);
 
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		if (task->se_dev)
 			task->se_dev->transport->free_task(task);
 		else
 			printk(KERN_ERR "task[%u] - task->se_dev is NULL\n",
 				task->task_no);
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
 static inline void transport_free_pages(struct se_cmd *cmd)
@@ -3759,9 +3759,9 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	if (cmd->se_dev->transport->do_se_mem_map)
 		free_page = 0;
 
-	if (cmd->t_task.t_task_buf) {
-		kfree(cmd->t_task.t_task_buf);
-		cmd->t_task.t_task_buf = NULL;
+	if (cmd->t_task_buf) {
+		kfree(cmd->t_task_buf);
+		cmd->t_task_buf = NULL;
 		return;
 	}
 
@@ -3772,7 +3772,7 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		return;
 
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
-			&cmd->t_task.t_mem_list, se_list) {
+			&cmd->t_mem_list, se_list) {
 		/*
 		 * We only release call __free_page(struct se_mem->se_page) when
 		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
@@ -3783,10 +3783,10 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		list_del(&se_mem->se_list);
 		kmem_cache_free(se_mem_cache, se_mem);
 	}
-	cmd->t_task.t_tasks_se_num = 0;
+	cmd->t_tasks_se_num = 0;
 
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
-				 &cmd->t_task.t_mem_bidi_list, se_list) {
+				 &cmd->t_mem_bidi_list, se_list) {
 		/*
 		 * We only release call __free_page(struct se_mem->se_page) when
 		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
@@ -3797,7 +3797,7 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		list_del(&se_mem->se_list);
 		kmem_cache_free(se_mem_cache, se_mem);
 	}
-	cmd->t_task.t_tasks_se_bidi_num = 0;
+	cmd->t_tasks_se_bidi_num = 0;
 }
 
 static inline void transport_release_tasks(struct se_cmd *cmd)
@@ -3809,23 +3809,23 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (atomic_read(&cmd->t_task.t_fe_count)) {
-		if (!(atomic_dec_and_test(&cmd->t_task.t_fe_count))) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (atomic_read(&cmd->t_fe_count)) {
+		if (!(atomic_dec_and_test(&cmd->t_fe_count))) {
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 			return 1;
 		}
 	}
 
-	if (atomic_read(&cmd->t_task.t_se_count)) {
-		if (!(atomic_dec_and_test(&cmd->t_task.t_se_count))) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+	if (atomic_read(&cmd->t_se_count)) {
+		if (!(atomic_dec_and_test(&cmd->t_se_count))) {
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 			return 1;
 		}
 	}
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return 0;
 }
@@ -3837,14 +3837,14 @@ static void transport_release_fe_cmd(struct se_cmd *cmd)
 	if (transport_dec_and_check(cmd))
 		return;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (!(atomic_read(&cmd->t_task.transport_dev_active))) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (!(atomic_read(&cmd->transport_dev_active))) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto free_pages;
 	}
-	atomic_set(&cmd->t_task.transport_dev_active, 0);
+	atomic_set(&cmd->transport_dev_active, 0);
 	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	transport_release_tasks(cmd);
 free_pages:
@@ -3862,22 +3862,22 @@ static int transport_generic_remove(
 
 	if (transport_dec_and_check(cmd)) {
 		if (session_reinstatement) {
-			spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
 			transport_all_task_dev_remove_state(cmd);
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 					flags);
 		}
 		return 1;
 	}
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (!(atomic_read(&cmd->t_task.transport_dev_active))) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (!(atomic_read(&cmd->transport_dev_active))) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto free_pages;
 	}
-	atomic_set(&cmd->t_task.transport_dev_active, 0);
+	atomic_set(&cmd->transport_dev_active, 0);
 	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	transport_release_tasks(cmd);
 
@@ -3929,23 +3929,23 @@ int transport_generic_map_mem_to_cmd(
 		 * from the passed physical memory to struct se_mem->se_page here.
 		 */
 		ret = transport_map_sg_to_mem(cmd,
-			&cmd->t_task.t_mem_list, sgl, &mapped_sg_count);
+			&cmd->t_mem_list, sgl, &mapped_sg_count);
 		if (ret < 0)
 			return -ENOMEM;
 
-		cmd->t_task.t_tasks_se_num = mapped_sg_count;
+		cmd->t_tasks_se_num = mapped_sg_count;
 		/*
 		 * Setup BIDI READ list of struct se_mem elements
 		 */
 		if (sgl_bidi && sgl_bidi_count) {
 			mapped_sg_count = 0;
 			ret = transport_map_sg_to_mem(cmd,
-				&cmd->t_task.t_mem_bidi_list, sgl_bidi,
+				&cmd->t_mem_bidi_list, sgl_bidi,
 				&mapped_sg_count);
 			if (ret < 0)
 				return -ENOMEM;
 
-			cmd->t_task.t_tasks_se_bidi_num = mapped_sg_count;
+			cmd->t_tasks_se_bidi_num = mapped_sg_count;
 		}
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 
@@ -3965,8 +3965,8 @@ int transport_generic_map_mem_to_cmd(
 		 * struct scatterlist format.
 		 */
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_CONTIG_TO_SG;
-		cmd->t_task.t_task_pt_sgl = sgl;
-		cmd->t_task.t_task_pt_sgl_num = sgl_count;
+		cmd->t_task_pt_sgl = sgl;
+		cmd->t_task_pt_sgl_num = sgl_count;
 	}
 
 	return 0;
@@ -3983,19 +3983,19 @@ static int transport_get_sectors(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
-	cmd->t_task.t_tasks_sectors =
+	cmd->t_tasks_sectors =
 		(cmd->data_length / dev->se_sub_dev->se_dev_attrib.block_size);
-	if (!(cmd->t_task.t_tasks_sectors))
-		cmd->t_task.t_tasks_sectors = 1;
+	if (!(cmd->t_tasks_sectors))
+		cmd->t_tasks_sectors = 1;
 
 	if (dev->transport->get_device_type(dev) != TYPE_DISK)
 		return 0;
 
-	if ((cmd->t_task.t_task_lba + cmd->t_task.t_tasks_sectors) >
+	if ((cmd->t_task_lba + cmd->t_tasks_sectors) >
 	     transport_dev_end_lba(dev)) {
 		printk(KERN_ERR "LBA: %llu Sectors: %u exceeds"
 			" transport_dev_end_lba(): %llu\n",
-			cmd->t_task.t_task_lba, cmd->t_task.t_tasks_sectors,
+			cmd->t_task_lba, cmd->t_tasks_sectors,
 			transport_dev_end_lba(dev));
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = TCM_SECTOR_COUNT_TOO_MANY;
@@ -4013,21 +4013,21 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 
 	if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)) {
 		task_cdbs = 1;
-		cmd->t_task.t_task_cdbs = 1;
+		cmd->t_task_cdbs = 1;
 	} else {
 		int set_counts = 1;
 
 		/*
 		 * Setup any BIDI READ tasks and memory from
-		 * cmd->t_task.t_mem_bidi_list so the READ struct se_tasks
+		 * cmd->t_mem_bidi_list so the READ struct se_tasks
 		 * are queued first for the non pSCSI passthrough case.
 		 */
-		if (!list_empty(&cmd->t_task.t_mem_bidi_list) &&
+		if (!list_empty(&cmd->t_mem_bidi_list) &&
 		    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
 			rc = transport_generic_get_cdb_count(cmd,
-				cmd->t_task.t_task_lba,
-				cmd->t_task.t_tasks_sectors,
-				DMA_FROM_DEVICE, &cmd->t_task.t_mem_bidi_list,
+				cmd->t_task_lba,
+				cmd->t_tasks_sectors,
+				DMA_FROM_DEVICE, &cmd->t_mem_bidi_list,
 				set_counts);
 			if (!(rc)) {
 				cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -4038,13 +4038,13 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 			set_counts = 0;
 		}
 		/*
-		 * Setup the tasks and memory from cmd->t_task.t_mem_list
+		 * Setup the tasks and memory from cmd->t_mem_list
 		 * Note for BIDI transfers this will contain the WRITE payload
 		 */
 		task_cdbs = transport_generic_get_cdb_count(cmd,
-				cmd->t_task.t_task_lba,
-				cmd->t_task.t_tasks_sectors,
-				cmd->data_direction, &cmd->t_task.t_mem_list,
+				cmd->t_task_lba,
+				cmd->t_tasks_sectors,
+				cmd->data_direction, &cmd->t_mem_list,
 				set_counts);
 		if (!(task_cdbs)) {
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -4052,19 +4052,19 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 					TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			return PYX_TRANSPORT_LU_COMM_FAILURE;
 		}
-		cmd->t_task.t_task_cdbs = task_cdbs;
+		cmd->t_task_cdbs = task_cdbs;
 
 #if 0
 		printk(KERN_INFO "data_length: %u, LBA: %llu t_tasks_sectors:"
 			" %u, t_task_cdbs: %u\n", obj_ptr, cmd->data_length,
-			cmd->t_task.t_task_lba, cmd->t_task.t_tasks_sectors,
-			cmd->t_task.t_task_cdbs);
+			cmd->t_task_lba, cmd->t_tasks_sectors,
+			cmd->t_task_cdbs);
 #endif
 	}
 
-	atomic_set(&cmd->t_task.t_task_cdbs_left, task_cdbs);
-	atomic_set(&cmd->t_task.t_task_cdbs_ex_left, task_cdbs);
-	atomic_set(&cmd->t_task.t_task_cdbs_timeout_left, task_cdbs);
+	atomic_set(&cmd->t_task_cdbs_left, task_cdbs);
+	atomic_set(&cmd->t_task_cdbs_ex_left, task_cdbs);
+	atomic_set(&cmd->t_task_cdbs_timeout_left, task_cdbs);
 	return 0;
 }
 
@@ -4095,8 +4095,8 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length)
 
 		INIT_LIST_HEAD(&se_mem->se_list);
 		se_mem->se_len = min_t(u32, length, PAGE_SIZE);
-		list_add_tail(&se_mem->se_list, &cmd->t_task.t_mem_list);
-		cmd->t_task.t_tasks_se_num++;
+		list_add_tail(&se_mem->se_list, &cmd->t_mem_list);
+		cmd->t_tasks_se_num++;
 
 		DEBUG_MEM("Allocated struct se_mem page(%p) Length(%u)"
 			" Offset(%u)\n", se_mem->se_page, se_mem->se_len,
@@ -4106,7 +4106,7 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length)
 	}
 
 	DEBUG_MEM("Allocated total struct se_mem elements(%u)\n",
-			cmd->t_task.t_tasks_se_num);
+			cmd->t_tasks_se_num);
 
 	return 0;
 out:
@@ -4138,7 +4138,7 @@ int transport_init_task_sg(
 				sg_length = se_mem->se_len;
 
 				if (!(list_is_last(&se_mem->se_list,
-						&se_cmd->t_task.t_mem_list)))
+						&se_cmd->t_mem_list)))
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 			} else {
@@ -4158,7 +4158,7 @@ int transport_init_task_sg(
 				sg_length = (se_mem->se_len - task_offset);
 
 				if (!(list_is_last(&se_mem->se_list,
-						&se_cmd->t_task.t_mem_list)))
+						&se_cmd->t_mem_list)))
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 			}
@@ -4199,7 +4199,7 @@ next:
 	 * Setup task->task_sg_bidi for SCSI READ payload for
 	 * TCM/pSCSI passthrough if present for BIDI-COMMAND
 	 */
-	if (!list_empty(&se_cmd->t_task.t_mem_bidi_list) &&
+	if (!list_empty(&se_cmd->t_mem_bidi_list) &&
 	    (se_dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
 		task->task_sg_bidi = kzalloc(task_sg_num_padded *
 				sizeof(struct scatterlist), GFP_KERNEL);
@@ -4342,7 +4342,7 @@ int transport_map_mem_to_sg(
 				sg->length = se_mem->se_len;
 
 				if (!(list_is_last(&se_mem->se_list,
-						&se_cmd->t_task.t_mem_list))) {
+						&se_cmd->t_mem_list))) {
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 					(*se_mem_cnt)++;
@@ -4378,7 +4378,7 @@ int transport_map_mem_to_sg(
 				sg->length = (se_mem->se_len - *task_offset);
 
 				if (!(list_is_last(&se_mem->se_list,
-						&se_cmd->t_task.t_mem_list))) {
+						&se_cmd->t_mem_list))) {
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 					(*se_mem_cnt)++;
@@ -4436,7 +4436,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	 * Walk the struct se_task list and setup scatterlist chains
 	 * for each contiguosly allocated struct se_task->task_sg[].
 	 */
-	list_for_each_entry(task, &cmd->t_task.t_task_list, t_list) {
+	list_for_each_entry(task, &cmd->t_task_list, t_list) {
 		if (!(task->task_sg) || !(task->task_padded_sg))
 			continue;
 
@@ -4447,7 +4447,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 			 * Either add chain or mark end of scatterlist
 			 */
 			if (!(list_is_last(&task->t_list,
-					&cmd->t_task.t_task_list))) {
+					&cmd->t_task_list))) {
 				/*
 				 * Clear existing SGL termination bit set in
 				 * transport_init_task_sg(), see sg_mark_end()
@@ -4473,7 +4473,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 		/*
 		 * Check for single task..
 		 */
-		if (!(list_is_last(&task->t_list, &cmd->t_task.t_task_list))) {
+		if (!(list_is_last(&task->t_list, &cmd->t_task_list))) {
 			/*
 			 * Clear existing SGL termination bit set in
 			 * transport_init_task_sg(), see sg_mark_end()
@@ -4491,15 +4491,15 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	 * Setup the starting pointer and total t_tasks_sg_linked_no including
 	 * padding SGs for linking and to mark the end.
 	 */
-	cmd->t_task.t_tasks_sg_chained = sg_first;
-	cmd->t_task.t_tasks_sg_chained_no = sg_count;
+	cmd->t_tasks_sg_chained = sg_first;
+	cmd->t_tasks_sg_chained_no = sg_count;
 
-	DEBUG_CMD_M("Setup cmd: %p cmd->t_task.t_tasks_sg_chained: %p and"
-		" t_tasks_sg_chained_no: %u\n", cmd, cmd->t_task.t_tasks_sg_chained,
-		cmd->t_task.t_tasks_sg_chained_no);
+	DEBUG_CMD_M("Setup cmd: %p cmd->t_tasks_sg_chained: %p and"
+		" t_tasks_sg_chained_no: %u\n", cmd, cmd->t_tasks_sg_chained,
+		cmd->t_tasks_sg_chained_no);
 
-	for_each_sg(cmd->t_task.t_tasks_sg_chained, sg,
-			cmd->t_task.t_tasks_sg_chained_no, i) {
+	for_each_sg(cmd->t_tasks_sg_chained, sg,
+			cmd->t_tasks_sg_chained_no, i) {
 
 		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d\n",
 			i, sg, sg_page(sg), sg->length, sg->offset);
@@ -4532,7 +4532,7 @@ static int transport_do_se_mem_map(
 				in_mem, in_se_mem, out_se_mem, se_mem_cnt,
 				task_offset_in);
 		if (ret == 0)
-			task->task_se_cmd->t_task.t_tasks_se_num += *se_mem_cnt;
+			task->task_se_cmd->t_tasks_se_num += *se_mem_cnt;
 
 		return ret;
 	}
@@ -4605,9 +4605,9 @@ static u32 transport_generic_get_cdb_count(
 	 * Check for extra se_mem_bidi mapping for BIDI-COMMANDs to
 	 * struct se_task->task_sg_bidi for TCM/pSCSI passthrough operation
 	 */
-	if (!list_empty(&cmd->t_task.t_mem_bidi_list) &&
+	if (!list_empty(&cmd->t_mem_bidi_list) &&
 	    (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
-		se_mem_bidi = list_first_entry(&cmd->t_task.t_mem_bidi_list,
+		se_mem_bidi = list_first_entry(&cmd->t_mem_bidi_list,
 					struct se_mem, se_list);
 
 	while (sectors) {
@@ -4636,8 +4636,8 @@ static u32 transport_generic_get_cdb_count(
 		/* Should be part of task, can't fail */
 		BUG_ON(!cdb);
 
-		memcpy(cdb, cmd->t_task.t_task_cdb,
-		       scsi_command_size(cmd->t_task.t_task_cdb));
+		memcpy(cdb, cmd->t_task_cdb,
+		       scsi_command_size(cmd->t_task_cdb));
 
 		/* Update new cdb with updated lba/sectors */
 		cmd->transport_split_cdb(task->task_lba,
@@ -4645,7 +4645,7 @@ static u32 transport_generic_get_cdb_count(
 
 		/*
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
-		 * mapping for cmd->t_task.t_mem_list. And setup the
+		 * mapping for cmd->t_mem_list. And setup the
 		 * task->task_sg and if necessary task->task_sg_bidi
 		 */
 		ret = transport_do_se_mem_map(dev, task, mem_list,
@@ -4656,7 +4656,7 @@ static u32 transport_generic_get_cdb_count(
 
 		se_mem = se_mem_lout;
 		/*
-		 * Setup the cmd->t_task.t_mem_bidi_list -> task->task_sg_bidi
+		 * Setup the cmd->t_mem_bidi_list -> task->task_sg_bidi
 		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI
 		 *
 		 * Note that the first call to transport_do_se_mem_map() above will
@@ -4666,7 +4666,7 @@ static u32 transport_generic_get_cdb_count(
 		 */
 		if (task->task_sg_bidi != NULL) {
 			ret = transport_do_se_mem_map(dev, task,
-				&cmd->t_task.t_mem_bidi_list, NULL,
+				&cmd->t_mem_bidi_list, NULL,
 				se_mem_bidi, &se_mem_bidi_lout, &se_mem_bidi_cnt,
 				&task_offset_in);
 			if (ret < 0)
@@ -4681,8 +4681,8 @@ static u32 transport_generic_get_cdb_count(
 	}
 
 	if (set_counts) {
-		atomic_inc(&cmd->t_task.t_fe_count);
-		atomic_inc(&cmd->t_task.t_se_count);
+		atomic_inc(&cmd->t_fe_count);
+		atomic_inc(&cmd->t_se_count);
 	}
 
 	DEBUG_VOL("ITT[0x%08x] total %s cdbs(%u)\n",
@@ -4708,26 +4708,26 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 
 	cdb = dev->transport->get_cdb(task);
 	BUG_ON(!cdb);
-	memcpy(cdb, cmd->t_task.t_task_cdb,
-	       scsi_command_size(cmd->t_task.t_task_cdb));
+	memcpy(cdb, cmd->t_task_cdb,
+	       scsi_command_size(cmd->t_task_cdb));
 
 	task->task_size = cmd->data_length;
 	task->task_sg_num =
 		(cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) ? 1 : 0;
 
-	atomic_inc(&cmd->t_task.t_fe_count);
-	atomic_inc(&cmd->t_task.t_se_count);
+	atomic_inc(&cmd->t_fe_count);
+	atomic_inc(&cmd->t_se_count);
 
 	if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB) {
 		struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
 		u32 se_mem_cnt = 0, task_offset = 0;
 
-		if (!list_empty(&cmd->t_task.t_mem_list))
-			se_mem = list_first_entry(&cmd->t_task.t_mem_list,
+		if (!list_empty(&cmd->t_mem_list))
+			se_mem = list_first_entry(&cmd->t_mem_list,
 					struct se_mem, se_list);
 
 		ret = transport_do_se_mem_map(dev, task,
-				&cmd->t_task.t_mem_list, NULL, se_mem,
+				&cmd->t_mem_list, NULL, se_mem,
 				&se_mem_lout, &se_mem_cnt, &task_offset);
 		if (ret < 0)
 			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
@@ -4769,7 +4769,7 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 	 * Determine is the TCM fabric module has already allocated physical
 	 * memory, and is directly calling transport_generic_map_mem_to_cmd()
 	 * to setup beforehand the linked list of physical memory at
-	 * cmd->t_task.t_mem_list of struct se_mem->se_page
+	 * cmd->t_mem_list of struct se_mem->se_page
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
 		ret = transport_allocate_resources(cmd);
@@ -4798,7 +4798,7 @@ static int transport_generic_new_cmd(struct se_cmd *cmd)
 	}
 
 	if (cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) {
-		list_for_each_entry(task, &cmd->t_task.t_task_list, t_list) {
+		list_for_each_entry(task, &cmd->t_task_list, t_list) {
 			if (atomic_read(&task->task_sent))
 				continue;
 			if (!dev->transport->map_task_SG)
@@ -4845,9 +4845,9 @@ void transport_generic_process_write(struct se_cmd *cmd)
 	 * original EDTL
 	 */
 	if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
-		if (!cmd->t_task.t_tasks_se_num) {
+		if (!cmd->t_tasks_se_num) {
 			unsigned char *dst, *buf =
-				(unsigned char *)cmd->t_task.t_task_buf;
+				(unsigned char *)cmd->t_task_buf;
 
 			dst = kzalloc(cmd->cmd_spdtl), GFP_KERNEL);
 			if (!(dst)) {
@@ -4859,15 +4859,15 @@ void transport_generic_process_write(struct se_cmd *cmd)
 			}
 			memcpy(dst, buf, cmd->cmd_spdtl);
 
-			kfree(cmd->t_task.t_task_buf);
-			cmd->t_task.t_task_buf = dst;
+			kfree(cmd->t_task_buf);
+			cmd->t_task_buf = dst;
 		} else {
 			struct scatterlist *sg =
-				(struct scatterlist *sg)cmd->t_task.t_task_buf;
+				(struct scatterlist *sg)cmd->t_task_buf;
 			struct scatterlist *orig_sg;
 
 			orig_sg = kzalloc(sizeof(struct scatterlist) *
-					cmd->t_task.t_tasks_se_num,
+					cmd->t_tasks_se_num,
 					GFP_KERNEL))) {
 			if (!(orig_sg)) {
 				printk(KERN_ERR "Unable to allocate memory"
@@ -4877,9 +4877,9 @@ void transport_generic_process_write(struct se_cmd *cmd)
 				return;
 			}
 
-			memcpy(orig_sg, cmd->t_task.t_task_buf,
+			memcpy(orig_sg, cmd->t_task_buf,
 					sizeof(struct scatterlist) *
-					cmd->t_task.t_tasks_se_num);
+					cmd->t_tasks_se_num);
 
 			cmd->data_length = cmd->cmd_spdtl;
 			/*
@@ -4910,23 +4910,23 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	unsigned long flags;
 	int ret;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	cmd->t_state = TRANSPORT_WRITE_PENDING;
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 	/*
 	 * For the TCM control CDBs using a contiguous buffer, do the memcpy
 	 * from the passed Linux/SCSI struct scatterlist located at
-	 * se_cmd->t_task.t_task_pt_buf to the contiguous buffer at
-	 * se_cmd->t_task.t_task_buf.
+	 * se_cmd->t_task_pt_buf to the contiguous buffer at
+	 * se_cmd->t_task_buf.
 	 */
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-		sg_copy_to_buffer(cmd->t_task.t_task_pt_sgl,
-				    cmd->t_task.t_task_pt_sgl_num,
-				    cmd->t_task.t_task_buf,
+		sg_copy_to_buffer(cmd->t_task_pt_sgl,
+				    cmd->t_task_pt_sgl_num,
+				    cmd->t_task_buf,
 				    cmd->data_length);
 	/*
 	 * Clear the se_cmd for WRITE_PENDING status in order to set
-	 * cmd->t_task.t_transport_active=0 so that transport_generic_handle_data
+	 * cmd->t_transport_active=0 so that transport_generic_handle_data
 	 * can be called from HW target mode interrupt code.  This is safe
 	 * to be called with transport_off=1 before the cmd->se_tfo->write_pending
 	 * because the se_cmd->se_lun pointer is not being cleared.
@@ -5013,28 +5013,28 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 	 * If the frontend has already requested this struct se_cmd to
 	 * be stopped, we can safely ignore this struct se_cmd.
 	 */
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	if (atomic_read(&cmd->t_task.t_transport_stop)) {
-		atomic_set(&cmd->t_task.transport_lun_stop, 0);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (atomic_read(&cmd->t_transport_stop)) {
+		atomic_set(&cmd->transport_lun_stop, 0);
 		DEBUG_TRANSPORT_S("ConfigFS ITT[0x%08x] - t_transport_stop =="
 			" TRUE, skipping\n", cmd->se_tfo->get_task_tag(cmd));
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		transport_cmd_check_stop(cmd, 1, 0);
 		return -EPERM;
 	}
-	atomic_set(&cmd->t_task.transport_lun_fe_stop, 1);
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	atomic_set(&cmd->transport_lun_fe_stop, 1);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	wake_up_interruptible(&cmd->se_dev->dev_queue_obj.thread_wq);
 
 	ret = transport_stop_tasks_for_cmd(cmd);
 
 	DEBUG_TRANSPORT_S("ConfigFS: cmd: %p t_task_cdbs: %d stop tasks ret:"
-			" %d\n", cmd, cmd->t_task.t_task_cdbs, ret);
+			" %d\n", cmd, cmd->t_task_cdbs, ret);
 	if (!ret) {
 		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopping cmd....\n",
 				cmd->se_tfo->get_task_tag(cmd));
-		wait_for_completion(&cmd->t_task.transport_lun_stop_comp);
+		wait_for_completion(&cmd->transport_lun_stop_comp);
 		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopped cmd....\n",
 				cmd->se_tfo->get_task_tag(cmd));
 	}
@@ -5064,19 +5064,19 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 		       struct se_cmd, se_lun_node);
 		list_del(&cmd->se_lun_node);
 
-		atomic_set(&cmd->t_task.transport_lun_active, 0);
+		atomic_set(&cmd->transport_lun_active, 0);
 		/*
 		 * This will notify iscsi_target_transport.c:
 		 * transport_cmd_check_stop() that a LUN shutdown is in
 		 * progress for the iscsi_cmd_t.
 		 */
-		spin_lock(&cmd->t_task.t_state_lock);
-		DEBUG_CLEAR_L("SE_LUN[%d] - Setting cmd->t_task.transport"
+		spin_lock(&cmd->t_state_lock);
+		DEBUG_CLEAR_L("SE_LUN[%d] - Setting cmd->transport"
 			"_lun_stop for  ITT: 0x%08x\n",
 			cmd->se_lun->unpacked_lun,
 			cmd->se_tfo->get_task_tag(cmd));
-		atomic_set(&cmd->t_task.transport_lun_stop, 1);
-		spin_unlock(&cmd->t_task.t_state_lock);
+		atomic_set(&cmd->transport_lun_stop, 1);
+		spin_unlock(&cmd->t_state_lock);
 
 		spin_unlock_irqrestore(&lun->lun_cmd_lock, lun_flags);
 
@@ -5104,14 +5104,14 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 			cmd->se_lun->unpacked_lun,
 			cmd->se_tfo->get_task_tag(cmd));
 
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, cmd_flags);
-		if (!(atomic_read(&cmd->t_task.transport_dev_active))) {
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock, cmd_flags);
+		spin_lock_irqsave(&cmd->t_state_lock, cmd_flags);
+		if (!(atomic_read(&cmd->transport_dev_active))) {
+			spin_unlock_irqrestore(&cmd->t_state_lock, cmd_flags);
 			goto check_cond;
 		}
-		atomic_set(&cmd->t_task.transport_dev_active, 0);
+		atomic_set(&cmd->transport_dev_active, 0);
 		transport_all_task_dev_remove_state(cmd);
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, cmd_flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, cmd_flags);
 
 		transport_free_dev_tasks(cmd);
 		/*
@@ -5128,24 +5128,24 @@ check_cond:
 		 * be released, notify the waiting thread now that LU has
 		 * finished accessing it.
 		 */
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, cmd_flags);
-		if (atomic_read(&cmd->t_task.transport_lun_fe_stop)) {
+		spin_lock_irqsave(&cmd->t_state_lock, cmd_flags);
+		if (atomic_read(&cmd->transport_lun_fe_stop)) {
 			DEBUG_CLEAR_L("SE_LUN[%d] - Detected FE stop for"
 				" struct se_cmd: %p ITT: 0x%08x\n",
 				lun->unpacked_lun,
 				cmd, cmd->se_tfo->get_task_tag(cmd));
 
-			spin_unlock_irqrestore(&cmd->t_task.t_state_lock,
+			spin_unlock_irqrestore(&cmd->t_state_lock,
 					cmd_flags);
 			transport_cmd_check_stop(cmd, 1, 0);
-			complete(&cmd->t_task.transport_lun_fe_stop_comp);
+			complete(&cmd->transport_lun_fe_stop_comp);
 			spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 			continue;
 		}
 		DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x finished processing\n",
 			lun->unpacked_lun, cmd->se_tfo->get_task_tag(cmd));
 
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, cmd_flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, cmd_flags);
 		spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 	}
 	spin_unlock_irqrestore(&lun->lun_cmd_lock, lun_flags);
@@ -5191,15 +5191,15 @@ static void transport_generic_wait_for_tasks(
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) && !(cmd->se_tmr_req))
 		return;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	/*
 	 * If we are already stopped due to an external event (ie: LUN shutdown)
 	 * sleep until the connection can have the passed struct se_cmd back.
-	 * The cmd->t_task.transport_lun_stopped_sem will be upped by
+	 * The cmd->transport_lun_stopped_sem will be upped by
 	 * transport_clear_lun_from_sessions() once the ConfigFS context caller
 	 * has completed its operation on the struct se_cmd.
 	 */
-	if (atomic_read(&cmd->t_task.transport_lun_stop)) {
+	if (atomic_read(&cmd->transport_lun_stop)) {
 
 		DEBUG_TRANSPORT_S("wait_for_tasks: Stopping"
 			" wait_for_completion(&cmd->t_tasktransport_lun_fe"
@@ -5212,10 +5212,10 @@ static void transport_generic_wait_for_tasks(
 		 * We go ahead and up transport_lun_stop_comp just to be sure
 		 * here.
 		 */
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
-		complete(&cmd->t_task.transport_lun_stop_comp);
-		wait_for_completion(&cmd->t_task.transport_lun_fe_stop_comp);
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		complete(&cmd->transport_lun_stop_comp);
+		wait_for_completion(&cmd->transport_lun_fe_stop_comp);
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
 
 		transport_all_task_dev_remove_state(cmd);
 		/*
@@ -5228,13 +5228,13 @@ static void transport_generic_wait_for_tasks(
 			"stop_comp); for ITT: 0x%08x\n",
 			cmd->se_tfo->get_task_tag(cmd));
 
-		atomic_set(&cmd->t_task.transport_lun_stop, 0);
+		atomic_set(&cmd->transport_lun_stop, 0);
 	}
-	if (!atomic_read(&cmd->t_task.t_transport_active) ||
-	     atomic_read(&cmd->t_task.t_transport_aborted))
+	if (!atomic_read(&cmd->t_transport_active) ||
+	     atomic_read(&cmd->t_transport_aborted))
 		goto remove;
 
-	atomic_set(&cmd->t_task.t_transport_stop, 1);
+	atomic_set(&cmd->t_transport_stop, 1);
 
 	DEBUG_TRANSPORT_S("wait_for_tasks: Stopping %p ITT: 0x%08x"
 		" i_state: %d, t_state/def_t_state: %d/%d, t_transport_stop"
@@ -5242,21 +5242,21 @@ static void transport_generic_wait_for_tasks(
 		cmd->se_tfo->get_cmd_state(cmd), cmd->t_state,
 		cmd->deferred_t_state);
 
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	wake_up_interruptible(&cmd->se_dev->dev_queue_obj.thread_wq);
 
-	wait_for_completion(&cmd->t_task.t_transport_stop_comp);
+	wait_for_completion(&cmd->t_transport_stop_comp);
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-	atomic_set(&cmd->t_task.t_transport_active, 0);
-	atomic_set(&cmd->t_task.t_transport_stop, 0);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	atomic_set(&cmd->t_transport_active, 0);
+	atomic_set(&cmd->t_transport_stop, 0);
 
 	DEBUG_TRANSPORT_S("wait_for_tasks: Stopped wait_for_compltion("
-		"&cmd->t_task.t_transport_stop_comp) for ITT: 0x%08x\n",
+		"&cmd->t_transport_stop_comp) for ITT: 0x%08x\n",
 		cmd->se_tfo->get_task_tag(cmd));
 remove:
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 	if (!remove_cmd)
 		return;
 
@@ -5295,13 +5295,13 @@ int transport_send_check_condition_and_sense(
 	int offset;
 	u8 asc = 0, ascq = 0;
 
-	spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
-		spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return 0;
 	}
 	cmd->se_cmd_flags |= SCF_SENT_CHECK_CONDITION;
-	spin_unlock_irqrestore(&cmd->t_task.t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (!reason && from_transport)
 		goto after_reason;
@@ -5460,14 +5460,14 @@ int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
 {
 	int ret = 0;
 
-	if (atomic_read(&cmd->t_task.t_transport_aborted) != 0) {
+	if (atomic_read(&cmd->t_transport_aborted) != 0) {
 		if (!(send_status) ||
 		     (cmd->se_cmd_flags & SCF_SENT_DELAYED_TAS))
 			return 1;
 #if 0
 		printk(KERN_INFO "Sending delayed SAM_STAT_TASK_ABORTED"
 			" status for CDB: 0x%02x ITT: 0x%08x\n",
-			cmd->t_task.t_task_cdb[0],
+			cmd->t_task_cdb[0],
 			cmd->se_tfo->get_task_tag(cmd));
 #endif
 		cmd->se_cmd_flags |= SCF_SENT_DELAYED_TAS;
@@ -5488,7 +5488,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	 */
 	if (cmd->data_direction == DMA_TO_DEVICE) {
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
-			atomic_inc(&cmd->t_task.t_transport_aborted);
+			atomic_inc(&cmd->t_transport_aborted);
 			smp_mb__after_atomic_inc();
 			cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 			transport_new_cmd_failure(cmd);
@@ -5498,7 +5498,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 #if 0
 	printk(KERN_INFO "Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
-		" ITT: 0x%08x\n", cmd->t_task.t_task_cdb[0],
+		" ITT: 0x%08x\n", cmd->t_task_cdb[0],
 		cmd->se_tfo->get_task_tag(cmd));
 #endif
 	cmd->se_tfo->queue_status(cmd);
@@ -5589,7 +5589,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 
 		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
-		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
+		spin_lock_irqsave(&cmd->t_state_lock, flags);
 
 		DEBUG_DO("PT: cmd: %p task: %p ITT/CmdSN: 0x%08x/0x%08x,"
 			" i_state/def_i_state: %d/%d, t_state/def_t_state:"
@@ -5597,22 +5597,22 @@ static void transport_processing_shutdown(struct se_device *dev)
 			cmd->se_tfo->get_task_tag(cmd), cmd->cmd_sn,
 			cmd->se_tfo->get_cmd_state(cmd), cmd->deferred_i_state,
 			cmd->t_state, cmd->deferred_t_state,
-			cmd->t_task.t_task_cdb[0]);
+			cmd->t_task_cdb[0]);
 		DEBUG_DO("PT: ITT[0x%08x] - t_task_cdbs: %d t_task_cdbs_left:"
 			" %d t_task_cdbs_sent: %d -- t_transport_active: %d"
 			" t_transport_stop: %d t_transport_sent: %d\n",
 			cmd->se_tfo->get_task_tag(cmd),
-			cmd->t_task.t_task_cdbs,
-			atomic_read(&cmd->t_task.t_task_cdbs_left),
-			atomic_read(&cmd->t_task.t_task_cdbs_sent),
-			atomic_read(&cmd->t_task.t_transport_active),
-			atomic_read(&cmd->t_task.t_transport_stop),
-			atomic_read(&cmd->t_task.t_transport_sent));
+			cmd->t_task_cdbs,
+			atomic_read(&cmd->t_task_cdbs_left),
+			atomic_read(&cmd->t_task_cdbs_sent),
+			atomic_read(&cmd->t_transport_active),
+			atomic_read(&cmd->t_transport_stop),
+			atomic_read(&cmd->t_transport_sent));
 
 		if (atomic_read(&task->task_active)) {
 			atomic_set(&task->task_stop, 1);
 			spin_unlock_irqrestore(
-				&cmd->t_task.t_state_lock, flags);
+				&cmd->t_state_lock, flags);
 
 			DEBUG_DO("Waiting for task: %p to shutdown for dev:"
 				" %p\n", task, dev);
@@ -5620,8 +5620,8 @@ static void transport_processing_shutdown(struct se_device *dev)
 			DEBUG_DO("Completed task: %p shutdown for dev: %p\n",
 				task, dev);
 
-			spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
-			atomic_dec(&cmd->t_task.t_task_cdbs_left);
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			atomic_dec(&cmd->t_task_cdbs_left);
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
@@ -5631,25 +5631,25 @@ static void transport_processing_shutdown(struct se_device *dev)
 		}
 		__transport_stop_task_timer(task, &flags);
 
-		if (!(atomic_dec_and_test(&cmd->t_task.t_task_cdbs_ex_left))) {
+		if (!(atomic_dec_and_test(&cmd->t_task_cdbs_ex_left))) {
 			spin_unlock_irqrestore(
-					&cmd->t_task.t_state_lock, flags);
+					&cmd->t_state_lock, flags);
 
 			DEBUG_DO("Skipping task: %p, dev: %p for"
 				" t_task_cdbs_ex_left: %d\n", task, dev,
-				atomic_read(&cmd->t_task.t_task_cdbs_ex_left));
+				atomic_read(&cmd->t_task_cdbs_ex_left));
 
 			spin_lock_irqsave(&dev->execute_task_lock, flags);
 			continue;
 		}
 
-		if (atomic_read(&cmd->t_task.t_transport_active)) {
+		if (atomic_read(&cmd->t_transport_active)) {
 			DEBUG_DO("got t_transport_active = 1 for task: %p, dev:"
 					" %p\n", task, dev);
 
-			if (atomic_read(&cmd->t_task.t_fe_count)) {
+			if (atomic_read(&cmd->t_fe_count)) {
 				spin_unlock_irqrestore(
-					&cmd->t_task.t_state_lock, flags);
+					&cmd->t_state_lock, flags);
 				transport_send_check_condition_and_sense(
 					cmd, TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE,
 					0);
@@ -5660,7 +5660,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 				transport_cmd_check_stop(cmd, 1, 0);
 			} else {
 				spin_unlock_irqrestore(
-					&cmd->t_task.t_state_lock, flags);
+					&cmd->t_state_lock, flags);
 
 				transport_remove_cmd_from_queue(cmd,
 					&cmd->se_dev->dev_queue_obj);
@@ -5677,9 +5677,9 @@ static void transport_processing_shutdown(struct se_device *dev)
 		DEBUG_DO("Got t_transport_active = 0 for task: %p, dev: %p\n",
 				task, dev);
 
-		if (atomic_read(&cmd->t_task.t_fe_count)) {
+		if (atomic_read(&cmd->t_fe_count)) {
 			spin_unlock_irqrestore(
-				&cmd->t_task.t_state_lock, flags);
+				&cmd->t_state_lock, flags);
 			transport_send_check_condition_and_sense(cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 			transport_remove_cmd_from_queue(cmd,
@@ -5689,7 +5689,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			transport_cmd_check_stop(cmd, 1, 0);
 		} else {
 			spin_unlock_irqrestore(
-				&cmd->t_task.t_state_lock, flags);
+				&cmd->t_state_lock, flags);
 
 			transport_remove_cmd_from_queue(cmd,
 				&cmd->se_dev->dev_queue_obj);
@@ -5710,7 +5710,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 		DEBUG_DO("From Device Queue: cmd: %p t_state: %d\n",
 				cmd, cmd->t_state);
 
-		if (atomic_read(&cmd->t_task.t_fe_count)) {
+		if (atomic_read(&cmd->t_fe_count)) {
 			transport_send_check_condition_and_sense(cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 3b8b02c..d28e9c4 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -270,7 +270,7 @@ void core_scsi3_ua_for_check_condition(
 		nacl->se_tpg->se_tpg_tfo->get_fabric_name(),
 		(dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl != 0) ? "Reporting" :
 		"Releasing", dev->se_sub_dev->se_dev_attrib.emulate_ua_intlck_ctrl,
-		cmd->orig_fe_lun, cmd->t_task.t_task_cdb[0], *asc, *ascq);
+		cmd->orig_fe_lun, cmd->t_task_cdb[0], *asc, *ascq);
 }
 
 int core_scsi3_ua_clear_for_request_sense(
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 9c99402..62b1226 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -60,7 +60,6 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	struct fc_seq *sp;
 	struct se_cmd *se_cmd;
 	struct se_mem *mem;
-	struct se_transport_task *task;
 
 	if (!(ft_debug_logging & FT_DEBUG_IO))
 		return;
@@ -72,12 +71,11 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 		caller, cmd, cmd->cdb);
 	printk(KERN_INFO "%s: cmd %p lun %d\n", caller, cmd, cmd->lun);
 
-	task = &se_cmd->t_task;
-	printk(KERN_INFO "%s: cmd %p task %p se_num %u buf %p len %u se_cmd_flags <0x%x>\n",
-	       caller, cmd, task, task->t_tasks_se_num,
-	       task->t_task_buf, se_cmd->data_length, se_cmd->se_cmd_flags);
+	printk(KERN_INFO "%s: cmd %p se_num %u buf %p len %u se_cmd_flags <0x%x>\n",
+	       caller, cmd, se_cmd->t_tasks_se_num,
+	       se_cmd->t_task_buf, se_cmd->data_length, se_cmd->se_cmd_flags);
 
-	list_for_each_entry(mem, &task->t_mem_list, se_list)
+	list_for_each_entry(mem, &se_cmd->t_mem_list, se_list)
 		printk(KERN_INFO "%s: cmd %p mem %p page %p "
 		       "len 0x%x off 0x%x\n",
 		       caller, cmd, mem,
@@ -264,9 +262,9 @@ int ft_write_pending(struct se_cmd *se_cmd)
 				 * TCM/LIO target
 				 */
 				transport_do_task_sg_chain(se_cmd);
-				cmd->sg = se_cmd->t_task.t_tasks_sg_chained;
+				cmd->sg = se_cmd->t_tasks_sg_chained;
 				cmd->sg_cnt =
-					se_cmd->t_task.t_tasks_sg_chained_no;
+					se_cmd->t_tasks_sg_chained_no;
 			}
 			if (cmd->sg && lport->tt.ddp_setup(lport, ep->xid,
 						    cmd->sg, cmd->sg_cnt))
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index f18af6e..8560182 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -65,7 +65,6 @@
 int ft_queue_data_in(struct se_cmd *se_cmd)
 {
 	struct ft_cmd *cmd = container_of(se_cmd, struct ft_cmd, se_cmd);
-	struct se_transport_task *task;
 	struct fc_frame *fp = NULL;
 	struct fc_exch *ep;
 	struct fc_lport *lport;
@@ -90,14 +89,13 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 	lport = ep->lp;
 	cmd->seq = lport->tt.seq_start_next(cmd->seq);
 
-	task = &se_cmd->t_task;
 	remaining = se_cmd->data_length;
 
 	/*
 	 * Setup to use first mem list entry if any.
 	 */
-	if (task->t_tasks_se_num) {
-		mem = list_first_entry(&task->t_mem_list,
+	if (se_cmd->t_tasks_se_num) {
+		mem = list_first_entry(&se_cmd->t_mem_list,
 			 struct se_mem, se_list);
 		mem_len = mem->se_len;
 		mem_off = mem->se_off;
@@ -148,8 +146,8 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 
 		if (use_sg) {
 			if (!mem) {
-				BUG_ON(!task->t_task_buf);
-				page_addr = task->t_task_buf + mem_off;
+				BUG_ON(!se_cmd->t_task_buf);
+				page_addr = se_cmd->t_task_buf + mem_off;
 				/*
 				 * In this case, offset is 'offset_in_page' of
 				 * (t_task_buf + mem_off) instead of 'mem_off'.
@@ -180,7 +178,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			kunmap_atomic(page_addr, KM_SOFTIRQ0);
 			to += tlen;
 		} else {
-			from = task->t_task_buf + mem_off;
+			from = se_cmd->t_task_buf + mem_off;
 			memcpy(to, from, tlen);
 			to += tlen;
 		}
@@ -220,7 +218,6 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	struct fc_seq *seq = cmd->seq;
 	struct fc_exch *ep;
 	struct fc_lport *lport;
-	struct se_transport_task *task;
 	struct fc_frame_header *fh;
 	struct se_mem *mem;
 	u32 mem_off;
@@ -235,8 +232,6 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	u32 f_ctl;
 	void *buf;
 
-	task = &se_cmd->t_task;
-
 	fh = fc_frame_header_get(fp);
 	if (!(ntoh24(fh->fh_f_ctl) & FC_FC_REL_OFF))
 		goto drop;
@@ -312,8 +307,8 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	/*
 	 * Setup to use first mem list entry if any.
 	 */
-	if (task->t_tasks_se_num) {
-		mem = list_first_entry(&task->t_mem_list,
+	if (se_cmd->t_tasks_se_num) {
+		mem = list_first_entry(&se_cmd->t_mem_list,
 				       struct se_mem, se_list);
 		mem_len = mem->se_len;
 		mem_off = mem->se_off;
@@ -355,7 +350,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 			memcpy(to, from, tlen);
 			kunmap_atomic(page_addr, KM_SOFTIRQ0);
 		} else {
-			to = task->t_task_buf + mem_off;
+			to = se_cmd->t_task_buf + mem_off;
 			memcpy(to, from, tlen);
 		}
 		from += tlen;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 77f570d..58e5c17 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -403,62 +403,6 @@ struct se_queue_obj {
 	wait_queue_head_t	thread_wq;
 } ____cacheline_aligned;
 
-/*
- * Used one per struct se_cmd to hold all extra struct se_task
- * metadata.  This structure is setup and allocated in
- * drivers/target/target_core_transport.c:__transport_alloc_se_cmd()
- */
-struct se_transport_task {
-	unsigned char		*t_task_cdb;
-	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
-	unsigned long long	t_task_lba;
-	int			t_tasks_failed;
-	int			t_tasks_fua;
-	bool			t_tasks_bidi;
-	u32			t_task_cdbs;
-	u32			t_tasks_check;
-	u32			t_tasks_no;
-	u32			t_tasks_sectors;
-	u32			t_tasks_se_num;
-	u32			t_tasks_se_bidi_num;
-	u32			t_tasks_sg_chained_no;
-	atomic_t		t_fe_count;
-	atomic_t		t_se_count;
-	atomic_t		t_task_cdbs_left;
-	atomic_t		t_task_cdbs_ex_left;
-	atomic_t		t_task_cdbs_timeout_left;
-	atomic_t		t_task_cdbs_sent;
-	atomic_t		t_transport_aborted;
-	atomic_t		t_transport_active;
-	atomic_t		t_transport_complete;
-	atomic_t		t_transport_queue_active;
-	atomic_t		t_transport_sent;
-	atomic_t		t_transport_stop;
-	atomic_t		t_transport_timeout;
-	atomic_t		transport_dev_active;
-	atomic_t		transport_lun_active;
-	atomic_t		transport_lun_fe_stop;
-	atomic_t		transport_lun_stop;
-	spinlock_t		t_state_lock;
-	struct completion	t_transport_stop_comp;
-	struct completion	transport_lun_fe_stop_comp;
-	struct completion	transport_lun_stop_comp;
-	struct scatterlist	*t_tasks_sg_chained;
-	struct scatterlist	t_tasks_sg_bounce;
-	void			*t_task_buf;
-	/*
-	 * Used for pre-registered fabric SGL passthrough WRITE and READ
-	 * with the special SCF_PASSTHROUGH_CONTIG_TO_SG case for TCM_Loop
-	 * and other HW target mode fabric modules.
-	 */
-	struct scatterlist	*t_task_pt_sgl;
-	u32			t_task_pt_sgl_num;
-	struct list_head	t_mem_list;
-	/* Used for BIDI READ */
-	struct list_head	t_mem_bidi_list;
-	struct list_head	t_task_list;
-} ____cacheline_aligned;
-
 struct se_task {
 	unsigned char	task_sense;
 	struct scatterlist *task_sg;
@@ -534,13 +478,61 @@ struct se_cmd {
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
-	struct se_transport_task t_task;
 	struct list_head	se_queue_node;
 	struct target_core_fabric_ops *se_tfo;
 	int (*transport_emulate_cdb)(struct se_cmd *);
 	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
 	void (*transport_wait_for_tasks)(struct se_cmd *, int, int);
 	void (*transport_complete_callback)(struct se_cmd *);
+	unsigned char		*t_task_cdb;
+	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
+	unsigned long long	t_task_lba;
+	int			t_tasks_failed;
+	int			t_tasks_fua;
+	bool			t_tasks_bidi;
+	u32			t_task_cdbs;
+	u32			t_tasks_check;
+	u32			t_tasks_no;
+	u32			t_tasks_sectors;
+	u32			t_tasks_se_num;
+	u32			t_tasks_se_bidi_num;
+	u32			t_tasks_sg_chained_no;
+	atomic_t		t_fe_count;
+	atomic_t		t_se_count;
+	atomic_t		t_task_cdbs_left;
+	atomic_t		t_task_cdbs_ex_left;
+	atomic_t		t_task_cdbs_timeout_left;
+	atomic_t		t_task_cdbs_sent;
+	atomic_t		t_transport_aborted;
+	atomic_t		t_transport_active;
+	atomic_t		t_transport_complete;
+	atomic_t		t_transport_queue_active;
+	atomic_t		t_transport_sent;
+	atomic_t		t_transport_stop;
+	atomic_t		t_transport_timeout;
+	atomic_t		transport_dev_active;
+	atomic_t		transport_lun_active;
+	atomic_t		transport_lun_fe_stop;
+	atomic_t		transport_lun_stop;
+	spinlock_t		t_state_lock;
+	struct completion	t_transport_stop_comp;
+	struct completion	transport_lun_fe_stop_comp;
+	struct completion	transport_lun_stop_comp;
+	struct scatterlist	*t_tasks_sg_chained;
+	struct scatterlist	t_tasks_sg_bounce;
+	void			*t_task_buf;
+	/*
+	 * Used for pre-registered fabric SGL passthrough WRITE and READ
+	 * with the special SCF_PASSTHROUGH_CONTIG_TO_SG case for TCM_Loop
+	 * and other HW target mode fabric modules.
+	 */
+	struct scatterlist	*t_task_pt_sgl;
+	u32			t_task_pt_sgl_num;
+	struct list_head	t_mem_list;
+	/* Used for BIDI READ */
+	struct list_head	t_mem_bidi_list;
+	struct list_head	t_task_list;
+
 } ____cacheline_aligned;
 
 struct se_tmr_req {
-- 
1.7.6


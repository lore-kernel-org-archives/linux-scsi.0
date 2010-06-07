From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] [tgt]: Add bs_sg struct device_type_template sg_template and struct backingstore_template->bs_init()
Date: Sun,  6 Jun 2010 20:50:32 -0700
Message-ID: <1275882632-5397-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:48128 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756244Ab0FGDt2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jun 2010 23:49:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds struct device_type_template sg_template to usr/bs_sg.c used for STGT LUN
passthrough with the new bs_sg_lu_init() and bs_sg_rw() functions following usr/sbc.c code
for TYPE_DISK, but should work for any device type.

It also adds struct bs_sg_init() that is called from existing usr/target.c:tgt_device_create()
code via struct backingstore_template->bs_init() in order to setup the passthrough specific
queue and completion handlers for struct scsi_lu->cmd_perform() and ->cmd_done().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 usr/bs_sg.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/usr/bs_sg.c b/usr/bs_sg.c
index 8baa480..23676ef 100644
--- a/usr/bs_sg.c
+++ b/usr/bs_sg.c
@@ -38,9 +38,12 @@
 #include "util.h"
 #include "tgtd.h"
 #include "scsi.h"
+#include "spc.h"
+#include "tgtadm_error.h"
 
 #define BS_SG_RESVD_SZ  (512 * 1024)
 #define BS_SG_TIMEOUT	2000
+#define BS_SG_SHIFT	9
 
 static int graceful_read(int fd, void *p_read, int to_read)
 {
@@ -82,6 +85,32 @@ static int graceful_write(int fd, void *p_write, int to_write)
 	return 0;
 }
 
+static int bs_sg_rw(int host_no, struct scsi_cmd *cmd)
+{
+	int ret;
+	unsigned char key = ILLEGAL_REQUEST;
+	uint16_t asc = ASC_LUN_NOT_SUPPORTED;
+
+	cmd->scsi_cmd_done = target_cmd_io_done;
+
+	cmd->offset = (scsi_rw_offset(cmd->scb) << BS_SG_SHIFT);
+	ret = cmd->dev->bst->bs_cmd_submit(cmd);
+	if (ret) {
+		key = HARDWARE_ERROR;
+		asc = ASC_INTERNAL_TGT_FAILURE;
+	} else {
+		set_cmd_mmapio(cmd);
+		return SAM_STAT_GOOD;
+	}
+
+	cmd->offset = 0;
+	scsi_set_in_resid_by_actual(cmd, 0);
+	scsi_set_out_resid_by_actual(cmd, 0);
+
+	sense_data_build(cmd, key, asc);
+	return SAM_STAT_CHECK_CONDITION;
+}
+
 static void set_cmd_failed(struct scsi_cmd *cmd)
 {
 	int result = SAM_STAT_CHECK_CONDITION;
@@ -192,6 +221,25 @@ static int init_sg_device(int fd)
 	return 0;
 }
 
+static int bs_sg_init(struct scsi_lu *lu)
+{
+	/*
+	 * Setup struct scsi_lu->cmd_perform() passthrough pointer
+	 * (if available) for the underlying device type.
+	 */
+	lu->cmd_perform = &target_cmd_perform_passthrough;
+	if (!(lu->cmd_perform)) {
+		eprintf("Unable to locate lu->cmd_perform() for bs_sg\n");
+		return -1;
+	}
+	/*
+	 * Setup struct scsi_lu->cmd_done() passthrough pointer using
+	 * usr/target.c:__cmd_done_passthrough().
+	 */
+	lu->cmd_done = &__cmd_done_passthrough;
+	return 0;
+}
+
 static int bs_sg_open(struct scsi_lu *lu, char *path, int *fd, uint64_t *size)
 {
 	int sg_fd, err;
@@ -235,16 +283,37 @@ static int bs_sg_cmd_done(struct scsi_cmd *cmd)
 	return 0;
 }
 
+static int bs_sg_lu_init(struct scsi_lu *lu)
+{
+	if (spc_lu_init(lu))
+		return TGTADM_NOMEM;
+
+	return 0;
+}
+
 static struct backingstore_template sg_bst = {
 	.bs_name		= "sg",
 	.bs_datasize		= 0,
+	.bs_passthrough		= 1,
+	.bs_init		= bs_sg_init,
 	.bs_open		= bs_sg_open,
 	.bs_close		= bs_sg_close,
 	.bs_cmd_submit		= bs_sg_cmd_submit,
 	.bs_cmd_done		= bs_sg_cmd_done,
 };
 
+static struct device_type_template sg_template = {
+	.type			= 0,
+	.lu_init		= bs_sg_lu_init,
+	.lu_config		= spc_lu_config,
+	.lu_online		= spc_lu_online,
+	.lu_offline		= spc_lu_offline,
+	.lu_exit		= spc_lu_exit,
+	.cmd_passthrough	= bs_sg_rw,
+};
+
 __attribute__((constructor)) static void bs_sg_constructor(void)
 {
 	register_backingstore_template(&sg_bst);
+	device_type_register(&sg_template);
 }
-- 
1.5.6.5


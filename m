From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH 23/33][SCSI] megaraid: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:04:47 +0100 (MET)
Message-ID: <20080106030447.30002.36102.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53995 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbYAFDFA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:05:00 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-errors.

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 66c6520..9353472 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -359,7 +359,7 @@ mega_runpendq(adapter_t *adapter)
  * The command queuing entry point for the mid-layer.
  */
 static int
-megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
+megaraid_queue(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 {
 	adapter_t	*adapter;
 	scb_t	*scb;
@@ -411,7 +411,7 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
  * commands.
  */
 static inline scb_t *
-mega_allocate_scb(adapter_t *adapter, Scsi_Cmnd *cmd)
+mega_allocate_scb(adapter_t *adapter, struct scsi_cmnd *cmd)
 {
 	struct list_head *head = &adapter->free_list;
 	scb_t	*scb;
@@ -443,7 +443,7 @@ mega_allocate_scb(adapter_t *adapter, Scsi_Cmnd *cmd)
  * and the channel number.
  */
 static inline int
-mega_get_ldrv_num(adapter_t *adapter, Scsi_Cmnd *cmd, int channel)
+mega_get_ldrv_num(adapter_t *adapter, struct scsi_cmnd *cmd, int channel)
 {
 	int		tgt;
 	int		ldrv_num;
@@ -506,7 +506,7 @@ mega_get_ldrv_num(adapter_t *adapter, Scsi_Cmnd *cmd, int channel)
  * boot settings.
  */
 static scb_t *
-mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
+mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 {
 	mega_ext_passthru	*epthru;
 	mega_passthru	*pthru;
@@ -944,7 +944,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
  * prepare a command for the scsi physical devices.
  */
 static mega_passthru *
-mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
+mega_prepare_passthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
 		int channel, int target)
 {
 	mega_passthru *pthru;
@@ -1008,7 +1008,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
  * commands for devices which can take extended CDBs (>10 bytes)
  */
 static mega_ext_passthru *
-mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
+mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
 		int channel, int target)
 {
 	mega_ext_passthru	*epthru;
@@ -1410,7 +1410,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 {
 	mega_ext_passthru	*epthru = NULL;
 	struct scatterlist	*sgl;
-	Scsi_Cmnd	*cmd = NULL;
+	struct scsi_cmnd	*cmd = NULL;
 	mega_passthru	*pthru = NULL;
 	mbox_t	*mbox = NULL;
 	u8	c;
@@ -1662,14 +1662,14 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 static void
 mega_rundoneq (adapter_t *adapter)
 {
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	struct list_head *pos;
 
 	list_for_each(pos, &adapter->completed_list) {
 
 		struct scsi_pointer* spos = (struct scsi_pointer *)pos;
 
-		cmd = list_entry(spos, Scsi_Cmnd, SCp);
+		cmd = list_entry(spos, struct scsi_cmnd, SCp);
 		cmd->scsi_done(cmd);
 	}
 
@@ -1732,7 +1732,7 @@ static int
 mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 {
 	struct scatterlist *sg;
-	Scsi_Cmnd	*cmd;
+	struct scsi_cmnd	*cmd;
 	int	sgcnt;
 	int	idx;
 
@@ -1879,7 +1879,7 @@ megaraid_info(struct Scsi_Host *host)
  * aborted. All the commands issued to the F/W must complete.
  */
 static int
-megaraid_abort(Scsi_Cmnd *cmd)
+megaraid_abort(struct scsi_cmnd *cmd)
 {
 	adapter_t	*adapter;
 	int		rval;
@@ -1944,7 +1944,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
  * issued to the controller, abort/reset it. Otherwise return failure
  */
 static int
-megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
+megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 {
 	struct list_head	*pos, *next;
 	scb_t			*scb;
@@ -4396,7 +4396,7 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
 static int
 mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 {
-	Scsi_Cmnd	*scmd;
+	struct scsi_cmnd	*scmd;
 	struct	scsi_device *sdev;
 	scb_t	*scb;
 	int	rval;
@@ -4412,7 +4412,7 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	memset(scb, 0, sizeof(scb_t));
 
 	scmd = &adapter->int_scmd;
-	memset(scmd, 0, sizeof(Scsi_Cmnd));
+	memset(scmd, 0, sizeof(struct scsi_cmnd));
 
 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
 	scmd->device = sdev;
@@ -4466,7 +4466,7 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
  * Callback routine for internal commands.
  */
 static void
-mega_internal_done(Scsi_Cmnd *scmd)
+mega_internal_done(struct scsi_cmnd *scmd)
 {
 	adapter_t	*adapter;
 
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ee70bd4..a20a52a 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -225,7 +225,7 @@ typedef struct {
 	u32	dma_type;
 	u32	dma_direction;
 
-	Scsi_Cmnd	*cmd;
+	struct scsi_cmnd	*cmd;
 	dma_addr_t	dma_h_bulkdata;
 	dma_addr_t	dma_h_sgdata;
 
@@ -889,7 +889,7 @@ typedef struct {
 	u8	sglen;	/* f/w supported scatter-gather list length */
 
 	scb_t			int_scb;
-	Scsi_Cmnd		int_scmd;
+	struct scsi_cmnd	int_scmd;
 	struct mutex		int_mtx;	/* To synchronize the internal
 						commands */
 	struct completion	int_waitq;	/* wait queue for internal
@@ -987,8 +987,8 @@ static int mega_query_adapter(adapter_t *);
 static int issue_scb(adapter_t *, scb_t *);
 static int mega_setup_mailbox(adapter_t *);
 
-static int megaraid_queue (Scsi_Cmnd *, void (*)(Scsi_Cmnd *));
-static scb_t * mega_build_cmd(adapter_t *, Scsi_Cmnd *, int *);
+static int megaraid_queue (struct scsi_cmnd *, void (*)(struct scsi_cmnd *));
+static scb_t *mega_build_cmd(adapter_t *, struct scsi_cmnd *, int *);
 static void __mega_runpendq(adapter_t *);
 static int issue_scb_block(adapter_t *, u_char *);
 
@@ -997,9 +997,9 @@ static irqreturn_t megaraid_isr_iomapped(int, void *);
 
 static void mega_free_scb(adapter_t *, scb_t *);
 
-static int megaraid_abort(Scsi_Cmnd *);
-static int megaraid_reset(Scsi_Cmnd *);
-static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
+static int megaraid_abort(struct scsi_cmnd *);
+static int megaraid_reset(struct scsi_cmnd *);
+static int megaraid_abort_and_reset(adapter_t *, struct scsi_cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
 
@@ -1047,9 +1047,9 @@ static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
 
 static int mega_support_ext_cdb(adapter_t *);
 static mega_passthru* mega_prepare_passthru(adapter_t *, scb_t *,
-		Scsi_Cmnd *, int, int);
+		struct scsi_cmnd *, int, int);
 static mega_ext_passthru* mega_prepare_extpassthru(adapter_t *,
-		scb_t *, Scsi_Cmnd *, int, int);
+		scb_t *, struct scsi_cmnd *, int, int);
 static void mega_enum_raid_scsi(adapter_t *);
 static void mega_get_boot_drv(adapter_t *);
 static int mega_support_random_del(adapter_t *);
@@ -1057,7 +1057,7 @@ static int mega_del_logdrv(adapter_t *, int);
 static int mega_do_del_logdrv(adapter_t *, int);
 static void mega_get_max_sgl(adapter_t *);
 static int mega_internal_command(adapter_t *, megacmd_t *, mega_passthru *);
-static void mega_internal_done(Scsi_Cmnd *);
+static void mega_internal_done(struct scsi_cmnd *);
 static int mega_support_cluster(adapter_t *);
 #endif
 

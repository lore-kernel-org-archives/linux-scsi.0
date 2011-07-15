From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 05/16] SCSI: megaraid: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:19:56 -0400
Message-ID: <1310710796.3184.56.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/megaraid.c |   28 ++++++++++++++--------------
 drivers/scsi/megaraid.h |   16 ++++++++--------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 5c17764..6ace10c 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -366,7 +366,7 @@ mega_runpendq(adapter_t *adapter)
  * The command queuing entry point for the mid-layer.
  */
 static int
-megaraid_queue_lck(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
+megaraid_queue_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 {
 	adapter_t	*adapter;
 	scb_t	*scb;
@@ -420,7 +420,7 @@ static DEF_SCSI_QCMD(megaraid_queue)
  * commands.
  */
 static inline scb_t *
-mega_allocate_scb(adapter_t *adapter, Scsi_Cmnd *cmd)
+mega_allocate_scb(adapter_t *adapter, struct scsi_cmnd *cmd)
 {
 	struct list_head *head = &adapter->free_list;
 	scb_t	*scb;
@@ -452,7 +452,7 @@ mega_allocate_scb(adapter_t *adapter, Scsi_Cmnd *cmd)
  * and the channel number.
  */
 static inline int
-mega_get_ldrv_num(adapter_t *adapter, Scsi_Cmnd *cmd, int channel)
+mega_get_ldrv_num(adapter_t *adapter, struct scsi_cmnd *cmd, int channel)
 {
 	int		tgt;
 	int		ldrv_num;
@@ -515,7 +515,7 @@ mega_get_ldrv_num(adapter_t *adapter, Scsi_Cmnd *cmd, int channel)
  * boot settings.
  */
 static scb_t *
-mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
+mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 {
 	mega_ext_passthru	*epthru;
 	mega_passthru	*pthru;
@@ -953,7 +953,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
  * prepare a command for the scsi physical devices.
  */
 static mega_passthru *
-mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
+mega_prepare_passthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
 		int channel, int target)
 {
 	mega_passthru *pthru;
@@ -1017,7 +1017,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
  * commands for devices which can take extended CDBs (>10 bytes)
  */
 static mega_ext_passthru *
-mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, Scsi_Cmnd *cmd,
+mega_prepare_extpassthru(adapter_t *adapter, scb_t *scb, struct scsi_cmnd *cmd,
 		int channel, int target)
 {
 	mega_ext_passthru	*epthru;
@@ -1419,7 +1419,7 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 {
 	mega_ext_passthru	*epthru = NULL;
 	struct scatterlist	*sgl;
-	Scsi_Cmnd	*cmd = NULL;
+	struct scsi_cmnd	*cmd = NULL;
 	mega_passthru	*pthru = NULL;
 	mbox_t	*mbox = NULL;
 	u8	c;
@@ -1671,14 +1671,14 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
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
 
@@ -1741,7 +1741,7 @@ static int
 mega_build_sglist(adapter_t *adapter, scb_t *scb, u32 *buf, u32 *len)
 {
 	struct scatterlist *sg;
-	Scsi_Cmnd	*cmd;
+	struct scsi_cmnd	*cmd;
 	int	sgcnt;
 	int	idx;
 
@@ -1888,7 +1888,7 @@ megaraid_info(struct Scsi_Host *host)
  * aborted. All the commands issued to the F/W must complete.
  */
 static int
-megaraid_abort(Scsi_Cmnd *cmd)
+megaraid_abort(struct scsi_cmnd *cmd)
 {
 	adapter_t	*adapter;
 	int		rval;
@@ -1953,7 +1953,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
  * issued to the controller, abort/reset it. Otherwise return failure
  */
 static int
-megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
+megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 {
 	struct list_head	*pos, *next;
 	scb_t			*scb;
@@ -4415,7 +4415,7 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, u8 tgt,
 static int
 mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 {
-	Scsi_Cmnd	*scmd;
+	struct scsi_cmnd	*scmd;
 	struct	scsi_device *sdev;
 	scb_t	*scb;
 	int	rval;
@@ -4490,7 +4490,7 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
  * Callback routine for internal commands.
  */
 static void
-mega_internal_done(Scsi_Cmnd *scmd)
+mega_internal_done(struct scsi_cmnd *scmd)
 {
 	adapter_t	*adapter;
 
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 9a7897f..a7bc66c 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -225,7 +225,7 @@ typedef struct {
 	u32	dma_type;
 	u32	dma_direction;
 
-	Scsi_Cmnd	*cmd;
+	struct scsi_cmnd	*cmd;
 	dma_addr_t	dma_h_bulkdata;
 	dma_addr_t	dma_h_sgdata;
 
@@ -988,7 +988,7 @@ static int issue_scb(adapter_t *, scb_t *);
 static int mega_setup_mailbox(adapter_t *);
 
 static int megaraid_queue (struct Scsi_Host *, struct scsi_cmnd *);
-static scb_t * mega_build_cmd(adapter_t *, Scsi_Cmnd *, int *);
+static scb_t * mega_build_cmd(adapter_t *, struct scsi_cmnd *, int *);
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
 
@@ -1046,9 +1046,9 @@ static int mega_internal_dev_inquiry(adapter_t *, u8, u8, dma_addr_t);
 
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
@@ -1056,7 +1056,7 @@ static int mega_del_logdrv(adapter_t *, int);
 static int mega_do_del_logdrv(adapter_t *, int);
 static void mega_get_max_sgl(adapter_t *);
 static int mega_internal_command(adapter_t *, megacmd_t *, mega_passthru *);
-static void mega_internal_done(Scsi_Cmnd *);
+static void mega_internal_done(struct scsi_cmnd *);
 static int mega_support_cluster(adapter_t *);
 #endif
 
-- 
1.7.4.1

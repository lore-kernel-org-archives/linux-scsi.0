From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH  7/33][SCSI] atari_scsi: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:03:26 +0100 (MET)
Message-ID: <20080106030326.30002.86057.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53879 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYAFDDj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:03:39 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.
Cleaned up checkpatch.pl-warnings.


diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index f5732d8..a5d6ab4 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -189,9 +189,9 @@ static inline void DISABLE_IRQ(void)
 static int scsi_dma_is_ignored_buserr(unsigned char dma_stat);
 static void atari_scsi_fetch_restbytes(void);
 static long atari_scsi_dma_residual(struct Scsi_Host *instance);
-static int falcon_classify_cmd(Scsi_Cmnd *cmd);
+static int falcon_classify_cmd(struct scsi_cmnd *cmd);
 static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
-					Scsi_Cmnd *cmd, int write_flag);
+					struct scsi_cmnd *cmd, int write_flag);
 #endif
 static irqreturn_t scsi_tt_intr(int irq, void *dummy);
 static irqreturn_t scsi_falcon_intr(int irq, void *dummy);
@@ -582,7 +582,7 @@ static void falcon_get_lock(void)
  */
 
 #if 0
-int atari_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+int atari_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	/* falcon_get_lock();
 	 * ++guenther: moved to NCR5380_queue_command() to prevent
@@ -812,7 +812,7 @@ void __init atari_scsi_setup(char *str, int *ints)
 #endif
 }
 
-int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
+int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
 {
 	int rv;
 	struct NCR5380_hostdata *hostdata =
@@ -972,7 +972,7 @@ static long atari_scsi_dma_residual(struct Scsi_Host *instance)
 #define	CMD_SURELY_BYTE_MODE	1
 #define	CMD_MODE_UNKNOWN		2
 
-static int falcon_classify_cmd(Scsi_Cmnd *cmd)
+static int falcon_classify_cmd(struct scsi_cmnd *cmd)
 {
 	unsigned char opcode = cmd->cmnd[0];
 
@@ -1004,7 +1004,7 @@ static int falcon_classify_cmd(Scsi_Cmnd *cmd)
  */
 
 static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
-					Scsi_Cmnd *cmd, int write_flag)
+					struct scsi_cmnd *cmd, int write_flag)
 {
 	unsigned long	possible_len, limit;
 #ifndef CONFIG_TT_DMA_EMUL
diff --git a/drivers/scsi/atari_scsi.h b/drivers/scsi/atari_scsi.h
index efadb8d..48c1e46 100644
--- a/drivers/scsi/atari_scsi.h
+++ b/drivers/scsi/atari_scsi.h
@@ -20,7 +20,7 @@
 #ifndef ASM
 int atari_scsi_detect (struct scsi_host_template *);
 const char *atari_scsi_info (struct Scsi_Host *);
-int atari_scsi_reset (Scsi_Cmnd *, unsigned int);
+int atari_scsi_reset(struct scsi_cmnd *, unsigned int);
 int atari_scsi_release (struct Scsi_Host *);
 
 /* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary. Higher

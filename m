From: Davidlohr Bueso <dave@gnu.org>
Subject: [PATCH 07/20] scsi/atari_scsi: No longer use Scsi_Cmd typedef
Date: Sun, 08 Nov 2009 17:17:11 -0300
Message-ID: <1257711431.4759.113.camel@dbueso-pc>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755473AbZKHU01@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Roman.Hodek@informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/atari_scsi.c |   12 ++++++------
 drivers/scsi/atari_scsi.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index ad7a23a..3b8ace8 100644
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
@@ -578,7 +578,7 @@ static void falcon_get_lock(void)
  */
 
 #if 0
-int atari_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+int atari_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	/* falcon_get_lock();
 	 * ++guenther: moved to NCR5380_queue_command() to prevent
@@ -795,7 +795,7 @@ void __init atari_scsi_setup(char *str, int *ints)
 #endif
 }
 
-int atari_scsi_bus_reset(Scsi_Cmnd *cmd)
+int atari_scsi_bus_reset(struct scsi_cmnd *cmd)
 {
 	int rv;
 	struct NCR5380_hostdata *hostdata =
@@ -955,7 +955,7 @@ static long atari_scsi_dma_residual(struct Scsi_Host *instance)
 #define	CMD_SURELY_BYTE_MODE	1
 #define	CMD_MODE_UNKNOWN		2
 
-static int falcon_classify_cmd(Scsi_Cmnd *cmd)
+static int falcon_classify_cmd(struct scsi_cmnd *cmd)
 {
 	unsigned char opcode = cmd->cmnd[0];
 
@@ -987,7 +987,7 @@ static int falcon_classify_cmd(Scsi_Cmnd *cmd)
  */
 
 static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
-					Scsi_Cmnd *cmd, int write_flag)
+					struct scsi_cmnd *cmd, int write_flag)
 {
 	unsigned long	possible_len, limit;
 
diff --git a/drivers/scsi/atari_scsi.h b/drivers/scsi/atari_scsi.h
index efadb8d..48c1e46 100644
--- a/drivers/scsi/atari_scsi.h
+++ b/drivers/scsi/atari_scsi.h
@@ -20,7 +20,7 @@
 #ifndef ASM
 int atari_scsi_detect (struct scsi_host_template *);
 const char *atari_scsi_info (struct Scsi_Host *);
-int atari_scsi_reset (Scsi_Cmnd *, unsigned int);
+int atari_scsi_reset (struct scsi_cmnd *, unsigned int);
 int atari_scsi_release (struct Scsi_Host *);
 
 /* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary. Higher

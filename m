From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 05/37] ncr5380: Remove useless prototypes
Date: Wed, 12 Nov 2014 16:11:51 +1100
Message-ID: <20141112051147.705455659@telegraphics.com.au>
References: <20141112051146.525489687@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-useless-prototypes
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add missing static qualifiers and remove the now pointless prototypes. The
NCR5380_* prototypes are all declared in NCR5380.h and renamed using macros.
Further declarations are redundant (some are completely unused). Remove
them.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/atari_scsi.c |    5 -----
 drivers/scsi/dtc.h        |    7 -------
 drivers/scsi/g_NCR5380.c  |    6 +++---
 drivers/scsi/g_NCR5380.h  |    6 ------
 drivers/scsi/mac_scsi.c   |    2 --
 drivers/scsi/pas16.c      |    6 +++---
 drivers/scsi/pas16.h      |    6 ------
 drivers/scsi/sun3_scsi.c  |    4 +---
 drivers/scsi/sun3_scsi.h  |    7 -------
 drivers/scsi/t128.c       |    7 ++++---
 drivers/scsi/t128.h       |    6 ------
 11 files changed, 11 insertions(+), 51 deletions(-)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2014-11-12 16:10:51.000000000 +1100
@@ -272,7 +272,7 @@ static int __init do_DTC3181E_setup(char
  *	Locks: none
  */
 
-int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
+static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 {
 	static int current_override = 0;
 	int count;
@@ -484,7 +484,7 @@ int __init generic_NCR5380_detect(struct
  *	Report driver information for the NCR5380
  */
  	
-const char *generic_NCR5380_info(struct Scsi_Host *host)
+static const char *generic_NCR5380_info(struct Scsi_Host *host)
 {
 	static const char string[] = "Generic NCR5380/53C400 Driver";
 	return string;
@@ -499,7 +499,7 @@ const char *generic_NCR5380_info(struct
  *	Locks: none
  */
  
-int generic_NCR5380_release_resources(struct Scsi_Host *instance)
+static int generic_NCR5380_release_resources(struct Scsi_Host *instance)
 {
 	NCR5380_local_declare();
 	NCR5380_setup(instance);
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2014-11-12 16:10:51.000000000 +1100
@@ -382,7 +382,7 @@ __setup("pas16=", pas16_setup);
  *
  */
 
-int __init pas16_detect(struct scsi_host_template * tpnt)
+static int __init pas16_detect(struct scsi_host_template *tpnt)
 {
     static int current_override = 0;
     static unsigned short current_base = 0;
@@ -512,8 +512,8 @@ int __init pas16_detect(struct scsi_host
  * and matching the H_C_S coordinates to what DOS uses.
  */
 
-int pas16_biosparam(struct scsi_device *sdev, struct block_device *dev,
-		sector_t capacity, int * ip)
+static int pas16_biosparam(struct scsi_device *sdev, struct block_device *dev,
+                           sector_t capacity, int *ip)
 {
   int size = capacity;
   ip[0] = 64;
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2014-11-12 16:10:51.000000000 +1100
@@ -86,8 +86,6 @@ extern int sun3_map_test(unsigned long,
 
 
 static irqreturn_t scsi_sun3_intr(int irq, void *dummy);
-static inline unsigned char sun3scsi_read(int reg);
-static inline void sun3scsi_write(int reg, int value);
 
 static int setup_can_queue = -1;
 module_param(setup_can_queue, int, 0);
@@ -348,7 +346,7 @@ static int __init sun3scsi_detect(struct
 	return 1;
 }
 
-int sun3scsi_release (struct Scsi_Host *shpnt)
+static int sun3scsi_release(struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq != SCSI_IRQ_NONE)
 		free_irq(shpnt->irq, shpnt);
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/t128.c	2014-11-12 16:10:51.000000000 +1100
@@ -193,7 +193,8 @@ __setup("t128=", t128_setup);
  *
  */
 
-int __init t128_detect(struct scsi_host_template * tpnt){
+static int __init t128_detect(struct scsi_host_template *tpnt)
+{
     static int current_override = 0, current_base = 0;
     struct Scsi_Host *instance;
     unsigned long base;
@@ -325,8 +326,8 @@ static int t128_release(struct Scsi_Host
  * and matching the H_C_S coordinates to what DOS uses.
  */
 
-int t128_biosparam(struct scsi_device *sdev, struct block_device *bdev,
-		sector_t capacity, int * ip)
+static int t128_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+                          sector_t capacity, int *ip)
 {
   ip[0] = 64;
   ip[1] = 32;
Index: linux/drivers/scsi/dtc.h
===================================================================
--- linux.orig/drivers/scsi/dtc.h	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/dtc.h	2014-11-12 16:10:51.000000000 +1100
@@ -32,13 +32,6 @@
 #define DTCDEBUG_INIT	0x1
 #define DTCDEBUG_TRANSFER 0x2
 
-static int dtc_abort(Scsi_Cmnd *);
-static int dtc_biosparam(struct scsi_device *, struct block_device *,
-		         sector_t, int*);
-static int dtc_detect(struct scsi_host_template *);
-static int dtc_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int dtc_bus_reset(Scsi_Cmnd *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2014-11-12 16:10:51.000000000 +1100
@@ -39,12 +39,6 @@
 #endif
 
 #ifndef ASM
-static int generic_NCR5380_abort(Scsi_Cmnd *);
-static int generic_NCR5380_detect(struct scsi_host_template *);
-static int generic_NCR5380_release_resources(struct Scsi_Host *);
-static int generic_NCR5380_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
-static const char* generic_NCR5380_info(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/mac_scsi.c	2014-11-12 16:10:51.000000000 +1100
@@ -56,8 +56,6 @@
 
 #define RESET_BOOT
 
-extern void via_scsi_clear(void);
-
 #ifdef RESET_BOOT
 static void mac_scsi_reset_boot(struct Scsi_Host *instance);
 #endif
Index: linux/drivers/scsi/pas16.h
===================================================================
--- linux.orig/drivers/scsi/pas16.h	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/pas16.h	2014-11-12 16:10:51.000000000 +1100
@@ -114,12 +114,6 @@
 
 
 #ifndef ASM
-static int pas16_abort(Scsi_Cmnd *);
-static int pas16_biosparam(struct scsi_device *, struct block_device *,
-			   sector_t, int*);
-static int pas16_detect(struct scsi_host_template *);
-static int pas16_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int pas16_bus_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
Index: linux/drivers/scsi/sun3_scsi.h
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.h	2014-11-12 16:10:49.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.h	2014-11-12 16:10:51.000000000 +1100
@@ -43,13 +43,6 @@
 
 #define IOBASE_SUN3_VMESCSI 0xff200000
 
-static int sun3scsi_abort(struct scsi_cmnd *);
-static int sun3scsi_detect (struct scsi_host_template *);
-static const char *sun3scsi_info (struct Scsi_Host *);
-static int sun3scsi_bus_reset(struct scsi_cmnd *);
-static int sun3scsi_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int sun3scsi_release (struct Scsi_Host *);
-
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
 #endif
Index: linux/drivers/scsi/t128.h
===================================================================
--- linux.orig/drivers/scsi/t128.h	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/t128.h	2014-11-12 16:10:51.000000000 +1100
@@ -88,12 +88,6 @@
 #define T_DATA_REG_OFFSET	0x1e00	/* rw 512 bytes long */
 
 #ifndef ASM
-static int t128_abort(struct scsi_cmnd *);
-static int t128_biosparam(struct scsi_device *, struct block_device *,
-			  sector_t, int*);
-static int t128_detect(struct scsi_host_template *);
-static int t128_queue_command(struct Scsi_Host *, struct scsi_cmnd *);
-static int t128_bus_reset(struct scsi_cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
Index: linux/drivers/scsi/atari_scsi.c
===================================================================
--- linux.orig/drivers/scsi/atari_scsi.c	2014-11-12 16:10:43.000000000 +1100
+++ linux/drivers/scsi/atari_scsi.c	2014-11-12 16:10:51.000000000 +1100
@@ -181,12 +181,7 @@ static inline void DISABLE_IRQ(void)
 /***************************** Prototypes *****************************/
 
 #ifdef REAL_DMA
-static int scsi_dma_is_ignored_buserr(unsigned char dma_stat);
 static void atari_scsi_fetch_restbytes(void);
-static long atari_scsi_dma_residual(struct Scsi_Host *instance);
-static int falcon_classify_cmd(Scsi_Cmnd *cmd);
-static unsigned long atari_dma_xfer_len(unsigned long wanted_len,
-					Scsi_Cmnd *cmd, int write_flag);
 #endif
 static irqreturn_t scsi_tt_intr(int irq, void *dummy);
 static irqreturn_t scsi_falcon_intr(int irq, void *dummy);

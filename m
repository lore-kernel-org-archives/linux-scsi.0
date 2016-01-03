From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 02/78] ncr5380: Remove redundant static variable initializers
Date: Sun, 03 Jan 2016 16:05:03 +1100
Message-ID: <20160103050501.581779051@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-remove-redundant-static-initializers
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c   |    2 +-
 drivers/scsi/dtc.c       |    4 ++--
 drivers/scsi/g_NCR5380.c |    4 ++--
 drivers/scsi/pas16.c     |   10 +++++-----
 drivers/scsi/sun3_scsi.c |    8 ++++----
 drivers/scsi/t128.c      |    4 ++--
 6 files changed, 16 insertions(+), 16 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:02:42.000000000 +1100
@@ -534,7 +534,7 @@ static void NCR5380_set_timer(struct NCR
 }
 
 
-static int probe_irq __initdata = 0;
+static int probe_irq __initdata;
 
 /**
  *	probe_intr	-	helper for IRQ autoprobe
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-01-03 16:02:42.000000000 +1100
@@ -150,7 +150,7 @@ static const struct signature {
 
 static int __init dtc_setup(char *str)
 {
-	static int commandline_current = 0;
+	static int commandline_current;
 	int i;
 	int ints[10];
 
@@ -188,7 +188,7 @@ __setup("dtc=", dtc_setup);
 
 static int __init dtc_detect(struct scsi_host_template * tpnt)
 {
-	static int current_override = 0, current_base = 0;
+	static int current_override, current_base;
 	struct Scsi_Host *instance;
 	unsigned int addr;
 	void __iomem *base;
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:02:42.000000000 +1100
@@ -121,7 +121,7 @@ static struct override {
 
 static void __init internal_setup(int board, char *str, int *ints)
 {
-	static int commandline_current = 0;
+	static int commandline_current;
 	switch (board) {
 	case BOARD_NCR5380:
 		if (ints[0] != 2 && ints[0] != 3) {
@@ -251,7 +251,7 @@ static int __init do_DTC3181E_setup(char
 
 static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 {
-	static int current_override = 0;
+	static int current_override;
 	int count;
 	unsigned int *ports;
 #ifndef SCSI_G_NCR5380_MEM
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-01-03 16:02:42.000000000 +1100
@@ -87,8 +87,8 @@
 #include "NCR5380.h"
 
 
-static unsigned short pas16_addr = 0;
-static int pas16_irq = 0;
+static unsigned short pas16_addr;
+static int pas16_irq;
  
 
 static const int scsi_irq_translate[] =
@@ -305,7 +305,7 @@ static int __init
 
 static int __init pas16_setup(char *str)
 {
-    static int commandline_current = 0;
+	static int commandline_current;
     int i;
     int ints[10];
 
@@ -344,8 +344,8 @@ __setup("pas16=", pas16_setup);
 
 static int __init pas16_detect(struct scsi_host_template *tpnt)
 {
-    static int current_override = 0;
-    static unsigned short current_base = 0;
+	static int current_override;
+	static unsigned short current_base;
     struct Scsi_Host *instance;
     unsigned short io_port;
     int  count;
Index: linux/drivers/scsi/sun3_scsi.c
===================================================================
--- linux.orig/drivers/scsi/sun3_scsi.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/sun3_scsi.c	2016-01-03 16:02:42.000000000 +1100
@@ -100,10 +100,10 @@ static struct scsi_cmnd *sun3_dma_setup_
 static unsigned char *sun3_scsi_regp;
 static volatile struct sun3_dma_regs *dregs;
 static struct sun3_udc_regs *udc_regs;
-static unsigned char *sun3_dma_orig_addr = NULL;
-static unsigned long sun3_dma_orig_count = 0;
-static int sun3_dma_active = 0;
-static unsigned long last_residual = 0;
+static unsigned char *sun3_dma_orig_addr;
+static unsigned long sun3_dma_orig_count;
+static int sun3_dma_active;
+static unsigned long last_residual;
 static struct Scsi_Host *default_instance;
 
 /*
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-01-03 16:02:39.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-01-03 16:02:42.000000000 +1100
@@ -126,7 +126,7 @@ static struct signature {
 
 static int __init t128_setup(char *str)
 {
-    static int commandline_current = 0;
+	static int commandline_current;
     int i;
     int ints[10];
 
@@ -165,7 +165,7 @@ __setup("t128=", t128_setup);
 
 static int __init t128_detect(struct scsi_host_template *tpnt)
 {
-    static int current_override = 0, current_base = 0;
+	static int current_override, current_base;
     struct Scsi_Host *instance;
     unsigned long base;
     void __iomem *p;

From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI gdth: make some code static
Date: Mon, 15 Nov 2004 03:01:42 +0100
Message-ID: <20041115020142.GJ2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261420AbUKOCTM@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: achim_leubner@adaptec.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

the patch below makes some code without external users static.


diffstat output:
 drivers/scsi/gdth.c |   26 +++++++++++++-------------
 drivers/scsi/gdth.h |   12 ------------
 2 files changed, 13 insertions(+), 25 deletions(-)


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/gdth.h.old	2004-11-13 21:04:25.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/gdth.h	2004-11-13 21:43:29.000000000 +0100
@@ -1029,16 +1029,9 @@
 
 /* function prototyping */
 
-int gdth_detect(Scsi_Host_Template *);
-int gdth_release(struct Scsi_Host *);
-int gdth_queuecommand(Scsi_Cmnd *,void (*done)(Scsi_Cmnd *));
-const char *gdth_info(struct Scsi_Host *);
-
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-int gdth_bios_param(struct scsi_device *,struct block_device *,sector_t,int *);
 int gdth_proc_info(struct Scsi_Host *, char *,char **,off_t,int,int);
 #elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-int gdth_bios_param(Disk *,kdev_t,int *);
 int gdth_proc_info(char *,char **,off_t,int,int,int);
 #else
 int gdth_bios_param(Disk *,kdev_t,int *);
@@ -1071,9 +1064,4 @@
                use_new_eh_code: 1       /* use new error code */ }    
 #endif
 
-int gdth_eh_abort(Scsi_Cmnd *scp);
-int gdth_eh_device_reset(Scsi_Cmnd *scp);
-int gdth_eh_bus_reset(Scsi_Cmnd *scp);
-int gdth_eh_host_reset(Scsi_Cmnd *scp);
-
 #endif
--- linux-2.6.10-rc1-mm5-full/drivers/scsi/gdth.c.old	2004-11-13 21:05:12.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/gdth.c	2004-11-13 21:44:41.000000000 +0100
@@ -4331,7 +4331,7 @@
 }
 
 #ifdef GDTH_STATISTICS
-void gdth_timeout(ulong data)
+static void gdth_timeout(ulong data)
 {
     ulong32 i;
     Scsi_Cmnd *nscp;
@@ -4359,7 +4359,7 @@
 }
 #endif
 
-GDTH_INITFUNC(void, internal_setup(char *str,int *ints))
+static GDTH_INITFUNC(void, internal_setup(char *str,int *ints))
 {
     int i, argc;
     char *cur_str, *argv;
@@ -4432,7 +4432,7 @@
     }
 }
 
-GDTH_INITFUNC(int, option_setup(char *str))
+static GDTH_INITFUNC(int, option_setup(char *str))
 {
     int ints[MAXHA];
     char *cur = str;
@@ -4450,7 +4450,7 @@
     return 1;
 }
 
-GDTH_INITFUNC(int, gdth_detect(Scsi_Host_Template *shtp))
+static GDTH_INITFUNC(int, gdth_detect(Scsi_Host_Template *shtp))
 {
     struct Scsi_Host *shp;
     gdth_pci_str pcistr[MAXHA];
@@ -4985,7 +4985,7 @@
 }
 
 
-int gdth_release(struct Scsi_Host *shp)
+static int gdth_release(struct Scsi_Host *shp)
 {
     int hanum;
     gdth_ha_str *ha;
@@ -5086,7 +5086,7 @@
     return("");
 }
 
-const char *gdth_info(struct Scsi_Host *shp)
+static const char *gdth_info(struct Scsi_Host *shp)
 {
     int hanum;
     gdth_ha_str *ha;
@@ -5114,19 +5114,19 @@
 #endif
 
 /* new error handling */
-int gdth_eh_abort(Scsi_Cmnd *scp)
+static int gdth_eh_abort(Scsi_Cmnd *scp)
 {
     TRACE2(("gdth_eh_abort()\n"));
     return FAILED;
 }
 
-int gdth_eh_device_reset(Scsi_Cmnd *scp)
+static int gdth_eh_device_reset(Scsi_Cmnd *scp)
 {
     TRACE2(("gdth_eh_device_reset()\n"));
     return FAILED;
 }
 
-int gdth_eh_bus_reset(Scsi_Cmnd *scp)
+static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
     int i, hanum;
     gdth_ha_str *ha;
@@ -5188,7 +5188,7 @@
     return SUCCESS;
 }
 
-int gdth_eh_host_reset(Scsi_Cmnd *scp)
+static int gdth_eh_host_reset(Scsi_Cmnd *scp)
 {
     TRACE2(("gdth_eh_host_reset()\n"));
     return FAILED;
@@ -5196,9 +5196,9 @@
 
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
-int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
+static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
 #else
-int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
+static int gdth_bios_param(Disk *disk,kdev_t dev,int *ip)
 #endif
 {
     unchar b, t;
@@ -5236,7 +5236,7 @@
 }
 
 
-int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
+static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *))
 {
     int hanum;
     int priority;

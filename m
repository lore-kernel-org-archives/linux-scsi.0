From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] remove Scsi_Device typedef
Date: Mon, 31 Oct 2005 18:32:08 +0100
Message-ID: <20051031173208.GD14182@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:28830 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964801AbVJaRcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Oct 2005 12:32:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt	2005-10-29 19:24:21.000000000 +0200
+++ scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt	2005-10-29 19:25:26.000000000 +0200
@@ -718,7 +718,7 @@
  *
  *      Defined in: drivers/scsi/scsi.c .
  **/
-int scsi_track_queue_full(Scsi_Device *sdev, int depth)
+int scsi_track_queue_full(struct scsi_device *sdev, int depth)
 
 
 /**
Index: scsi-misc-2.6/drivers/block/acsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/block/acsi.c	2005-10-29 19:20:30.000000000 +0200
+++ scsi-misc-2.6/drivers/block/acsi.c	2005-10-29 19:25:26.000000000 +0200
@@ -58,7 +58,6 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <scsi/scsi.h> /* for SCSI_IOCTL_GET_IDLUN */
-typedef void Scsi_Device; /* hack to avoid including scsi.h */
 #include <scsi/scsi_ioctl.h>
 #include <linux/hdreg.h> /* for HDIO_GETGEO */
 #include <linux/blkpg.h>
Index: scsi-misc-2.6/drivers/scsi/NCR53C9x.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/NCR53C9x.c	2005-10-29 19:24:21.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/NCR53C9x.c	2005-10-29 19:25:26.000000000 +0200
@@ -1006,7 +1006,7 @@
 	struct ESP_regs *eregs = esp->eregs;
 	struct esp_device *esp_dev;
 	Scsi_Cmnd *SCptr;
-	Scsi_Device *SDptr;
+	struct scsi_device *SDptr;
 	volatile unchar *cmdp = esp->esp_command;
 	unsigned char the_esp_command;
 	int lun, target;
@@ -1687,7 +1687,7 @@
 static inline void esp_connect(struct NCR_ESP *esp, struct ESP_regs *eregs,
 			       Scsi_Cmnd *sp)
 {
-	Scsi_Device *dp = sp->device;
+	struct scsi_device *dp = sp->device;
 	struct esp_device *esp_dev = dp->hostdata;
 
 	if(esp->prev_soff  != esp_dev->sync_max_offset ||
@@ -3605,7 +3605,7 @@
 }
 #endif
 
-int esp_slave_alloc(Scsi_Device *SDptr)
+int esp_slave_alloc(struct scsi_device *SDptr)
 {
 	struct esp_device *esp_dev =
 		kmalloc(sizeof(struct esp_device), GFP_ATOMIC);
@@ -3617,7 +3617,7 @@
 	return 0;
 }
 
-void esp_slave_destroy(Scsi_Device *SDptr)
+void esp_slave_destroy(struct scsi_device *SDptr)
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *) SDptr->host->hostdata;
 
Index: scsi-misc-2.6/drivers/scsi/NCR53C9x.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/NCR53C9x.h	2005-10-29 19:24:21.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/NCR53C9x.h	2005-10-29 19:25:26.000000000 +0200
@@ -664,6 +664,6 @@
 extern int esp_reset(Scsi_Cmnd *);
 extern int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset, int length,
 			 int inout);
-extern int esp_slave_alloc(Scsi_Device *);
-extern void esp_slave_destroy(Scsi_Device *);
+extern int esp_slave_alloc(struct scsi_device *);
+extern void esp_slave_destroy(struct scsi_device *);
 #endif /* !(NCR53C9X_H) */
Index: scsi-misc-2.6/drivers/scsi/aic7xxx_old.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx_old.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx_old.c	2005-10-29 19:25:27.000000000 +0200
@@ -6514,7 +6514,7 @@
 static void
 aic7xxx_init_transinfo(struct aic7xxx_host *p, struct aic_dev_data *aic_dev)
 {
-  Scsi_Device *sdpnt = aic_dev->SDptr;
+  struct scsi_device *sdpnt = aic_dev->SDptr;
   unsigned char tindex;
 
   tindex = sdpnt->id | (sdpnt->channel << 3);
@@ -6581,7 +6581,7 @@
  *   Set up the initial aic_dev struct pointers
  *-F*************************************************************************/
 static int
-aic7xxx_slave_alloc(Scsi_Device *SDptr)
+aic7xxx_slave_alloc(struct scsi_device *SDptr)
 {
   struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;
@@ -6644,7 +6644,7 @@
  *   queueing to be [en|dis]abled for a specific adapter.
  *-F*************************************************************************/
 static void
-aic7xxx_device_queue_depth(struct aic7xxx_host *p, Scsi_Device *device)
+aic7xxx_device_queue_depth(struct aic7xxx_host *p, struct scsi_device *device)
 {
   int tag_enabled = FALSE;
   struct aic_dev_data *aic_dev = device->hostdata;
@@ -6734,7 +6734,7 @@
  *   prepare for this device to go away
  *-F*************************************************************************/
 static void
-aic7xxx_slave_destroy(Scsi_Device *SDptr)
+aic7xxx_slave_destroy(struct scsi_device *SDptr)
 {
   struct aic_dev_data *aic_dev = SDptr->hostdata;
 
@@ -6754,7 +6754,7 @@
  *   depths, allocate command structs, etc.
  *-F*************************************************************************/
 static int
-aic7xxx_slave_configure(Scsi_Device *SDptr)
+aic7xxx_slave_configure(struct scsi_device *SDptr)
 {
   struct aic7xxx_host *p = (struct aic7xxx_host *) SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;
Index: scsi-misc-2.6/drivers/scsi/arm/acornscsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/acornscsi.c	2005-10-29 19:25:07.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/acornscsi.c	2005-10-29 19:25:27.000000000 +0200
@@ -2862,7 +2862,7 @@
 			int length, int inout)
 {
     int pos, begin = 0, devidx;
-    Scsi_Device *scd;
+    struct scsi_device *scd;
     AS_Host *host;
     char *p = buffer;
 
Index: scsi-misc-2.6/drivers/scsi/arm/fas216.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/arm/fas216.c	2005-10-29 19:25:07.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/arm/fas216.c	2005-10-29 19:25:27.000000000 +0200
@@ -2559,7 +2559,7 @@
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 	unsigned long flags;
-	Scsi_Device *SDpnt;
+	struct scsi_device *SDpnt;
 
 	fas216_checkmagic(info);
 	fas216_log(info, LOG_ERROR, "resetting bus");
@@ -3000,7 +3000,7 @@
 int fas216_print_devices(FAS216_Info *info, char *buffer)
 {
 	struct fas216_device *dev;
-	Scsi_Device *scd;
+	struct scsi_device *scd;
 	char *p = buffer;
 
 	p += sprintf(p, "Device/Lun TaggedQ       Parity   Sync\n");
Index: scsi-misc-2.6/drivers/scsi/fcal.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fcal.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fcal.c	2005-10-29 19:25:27.000000000 +0200
@@ -70,7 +70,7 @@
 
 static int fcal_encode_addr(Scsi_Cmnd *SCpnt, u16 *addr, fc_channel *fc, fcp_cmnd *fcmd);
 
-int fcal_slave_configure(Scsi_Device *device)
+int fcal_slave_configure(struct scsi_device *device)
 {
 	int depth_to_use;
 	
@@ -244,7 +244,7 @@
 			SPRINTF ("  [AL-PA: %02x, Port WWN: %08x%08x, Node WWN: %08x%08x] Not responded to PRLI\n",
 				 alpa, u1[0], u1[1], u2[0], u2[1]);
 		} else {
-			Scsi_Device *scd;
+			struct scsi_device *scd;
 			shost_for_each_device(scd, host)
 				if (scd->id == target) {
 					SPRINTF ("  [AL-PA: %02x, Id: %02d, Port WWN: %08x%08x, Node WWN: %08x%08x]  ",
Index: scsi-misc-2.6/drivers/scsi/fcal.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/fcal.h	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/fcal.h	2005-10-29 19:25:27.000000000 +0200
@@ -22,6 +22,6 @@
 
 int fcal_detect(struct scsi_host_template *);
 int fcal_release(struct Scsi_Host *);
-int fcal_slave_configure(Scsi_Device *);
+int fcal_slave_configure(struct scsi_device *);
 
 #endif /* !(_FCAL_H) */
Index: scsi-misc-2.6/drivers/scsi/g_NCR5380.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/g_NCR5380.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/g_NCR5380.c	2005-10-29 19:25:27.000000000 +0200
@@ -798,7 +798,7 @@
 	Scsi_Cmnd *ptr;
 	struct NCR5380_hostdata *hostdata;
 #ifdef NCR5380_STATS
-	Scsi_Device *dev;
+	struct scsi_device *dev;
 	extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
 #endif
 
Index: scsi-misc-2.6/drivers/scsi/gdth.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth.c	2005-10-29 19:25:27.000000000 +0200
@@ -5562,7 +5562,7 @@
 #else
     Scsi_Cmnd       *scp;
 #endif
-    Scsi_Device     *sdev;
+    struct scsi_device     *sdev;
     char            cmnd[MAX_COMMAND_SIZE];   
     memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 
@@ -5624,10 +5624,10 @@
     gdth_cmd_str    gdtcmd;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *srp;
-    Scsi_Device     *sdev;
+    struct scsi_device     *sdev;
 #else
     Scsi_Cmnd       *scp;
-    Scsi_Device     *sdev;
+    struct scsi_device     *sdev;
 #endif
     char            cmnd[MAX_COMMAND_SIZE];   
 #endif
Index: scsi-misc-2.6/drivers/scsi/gdth.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth.h	2005-10-29 19:25:27.000000000 +0200
@@ -944,9 +944,9 @@
     ulong               dma32_cnt, dma64_cnt;   /* statistics: DMA buffer */
 #endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-    Scsi_Device         *sdev;
+    struct scsi_device         *sdev;
 #else
-    Scsi_Device         sdev;
+    struct scsi_device         sdev;
 #endif
 } gdth_ha_str;
 
Index: scsi-misc-2.6/drivers/scsi/gdth_proc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/gdth_proc.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/gdth_proc.c	2005-10-29 19:25:27.000000000 +0200
@@ -54,10 +54,10 @@
     int             ret_val = -EINVAL;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request    *scp;
-    Scsi_Device     *sdev;
+    struct scsi_device     *sdev;
 #else
     Scsi_Cmnd       *scp;
-    Scsi_Device     *sdev;
+    struct scsi_device     *sdev;
 #endif
     TRACE2(("gdth_set_info() ha %d bus %d\n",hanum,busnum));
 
@@ -232,10 +232,10 @@
     gdth_evt_str *estr;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     Scsi_Request *scp;
-    Scsi_Device *sdev; 
+    struct scsi_device *sdev;
 #else
     Scsi_Cmnd *scp;
-    Scsi_Device *sdev;
+    struct scsi_device *sdev;
 #endif
     char hrec[161];
     struct timeval tv;
@@ -275,7 +275,7 @@
     scp->cmd_len = 12;
     scp->use_sg = 0;
 #else
-    memset(&sdev,0,sizeof(Scsi_Device));
+    memset(&sdev,0,sizeof(struct scsi_device));
     memset(&scp, 0,sizeof(Scsi_Cmnd));
     sdev.host = scp.host = host;
     sdev.id = scp.target = sdev.host->this_id;
Index: scsi-misc-2.6/drivers/scsi/ide-scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ide-scsi.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ide-scsi.c	2005-10-29 19:25:27.000000000 +0200
@@ -875,7 +875,7 @@
 	struct gendisk *disk = cmd->request->rq_disk;
 
 	if (disk) {
-		struct Scsi_Device_Template **p = disk->private_data;
+		struct struct scsi_device_Template **p = disk->private_data;
 		if (strcmp((*p)->scsi_driverfs_driver.name, "sg") == 0)
 			return test_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 	}
Index: scsi-misc-2.6/drivers/scsi/ips.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ips.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ips.c	2005-10-29 19:25:27.000000000 +0200
@@ -1262,9 +1262,9 @@
 /*                                                                          */
 /****************************************************************************/
 static void
-ips_select_queue_depth(struct Scsi_Host *host, Scsi_Device * scsi_devs)
+ips_select_queue_depth(struct Scsi_Host *host, struct scsi_device * scsi_devs)
 {
-	Scsi_Device *device;
+	struct scsi_device *device;
 	ips_ha_t *ha;
 	int count = 0;
 	int min;
@@ -1307,7 +1307,7 @@
 /*                                                                          */
 /****************************************************************************/
 static int
-ips_slave_configure(Scsi_Device * SDptr)
+ips_slave_configure(struct scsi_device * SDptr)
 {
 	ips_ha_t *ha;
 	int min;
Index: scsi-misc-2.6/drivers/scsi/ips.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ips.h	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ips.h	2005-10-29 19:25:27.000000000 +0200
@@ -449,13 +449,13 @@
     */
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
    static int ips_proc24_info(char *, char **, off_t, int, int, int);
-   static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
+   static void ips_select_queue_depth(struct Scsi_Host *, struct scsi_device *);
    static int ips_biosparam(Disk *disk, kdev_t dev, int geom[]);
 #else
    static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
    static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int geom[]);
-   static int ips_slave_configure(Scsi_Device *SDptr);
+   static int ips_slave_configure(struct scsi_device *SDptr);
 #endif
 
 /*
Index: scsi-misc-2.6/drivers/scsi/pcmcia/nsp_cs.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pcmcia/nsp_cs.c	2005-10-29 19:24:22.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pcmcia/nsp_cs.c	2005-10-29 19:25:27.000000000 +0200
@@ -1717,7 +1717,7 @@
 	struct Scsi_Host *host;
 	nsp_hw_data      *data = &nsp_data_base;
 #if !(LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,74))
-	Scsi_Device	 *dev;
+	struct scsi_device	 *dev;
 	dev_node_t	**tail, *node;
 #endif
 
Index: scsi-misc-2.6/drivers/scsi/pluto.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pluto.c	2005-10-29 19:24:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pluto.c	2005-10-29 19:25:27.000000000 +0200
@@ -71,7 +71,7 @@
 		up(&fc_sem);
 }
 
-int pluto_slave_configure(Scsi_Device *device)
+int pluto_slave_configure(struct scsi_device *device)
 {
 	int depth_to_use;
 
@@ -94,7 +94,7 @@
 {
 	int i, retry, nplutos;
 	fc_channel *fc;
-	Scsi_Device dev;
+	struct scsi_device dev;
 	DEFINE_TIMER(fc_timer, pluto_detect_timeout, 0, 0);
 
 	tpnt->proc_name = "pluto";
Index: scsi-misc-2.6/drivers/scsi/pluto.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pluto.h	2005-10-29 19:24:23.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pluto.h	2005-10-29 19:25:27.000000000 +0200
@@ -41,7 +41,7 @@
 int pluto_detect(struct scsi_host_template *);
 int pluto_release(struct Scsi_Host *);
 const char * pluto_info(struct Scsi_Host *);
-int pluto_slave_configure(Scsi_Device *);
+int pluto_slave_configure(struct scsi_device *);
 
 #endif /* !(_PLUTO_H) */
 
Index: scsi-misc-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2005-10-29 19:25:27.000000000 +0200
@@ -9,7 +9,7 @@
  * global variable (boot or module load time) settings.
  *
  * A specific LUN is scanned via an INQUIRY command; if the LUN has a
- * device attached, a Scsi_Device is allocated and setup for it.
+ * device attached, a scsi_device is allocated and setup for it.
  *
  * For every id of every channel on the given host:
  *
@@ -17,7 +17,7 @@
  * 	device or storage attached to LUN 0):
  *
  * 		If LUN 0 has a device attached, allocate and setup a
- * 		Scsi_Device for it.
+ * 		scsi_device for it.
  *
  * 		If target is SCSI-3 or up, issue a REPORT LUN, and scan
  * 		all of the LUNs returned by the REPORT LUN; else,
@@ -441,7 +441,7 @@
  *
  *     If the INQUIRY is successful, zero is returned and the
  *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY length
- *     are copied to the Scsi_Device any flags value is stored in *@bflags.
+ *     are copied to the scsi_device any flags value is stored in *@bflags.
  **/
 static int scsi_probe_lun(struct scsi_device *sdev, char *inq_result,
 			  int result_len, int *bflags)
@@ -509,8 +509,8 @@
 		/*
 		 * Get any flags for this device.
 		 *
-		 * XXX add a bflags to Scsi_Device, and replace the
-		 * corresponding bit fields in Scsi_Device, so bflags
+		 * XXX add a bflags to scsi_device, and replace the
+		 * corresponding bit fields in scsi_device, so bflags
 		 * need not be passed as an argument.
 		 */
 		*bflags = scsi_get_device_flags(sdev, &inq_result[8],
@@ -592,21 +592,21 @@
 }
 
 /**
- * scsi_add_lun - allocate and fully initialze a Scsi_Device
- * @sdevscan:	holds information to be stored in the new Scsi_Device
- * @sdevnew:	store the address of the newly allocated Scsi_Device
+ * scsi_add_lun - allocate and fully initialze a scsi_device
+ * @sdevscan:	holds information to be stored in the new scsi_device
+ * @sdevnew:	store the address of the newly allocated scsi_device
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
  * @bflags:	black/white list flag
  *
  * Description:
- *     Allocate and initialize a Scsi_Device matching sdevscan. Optionally
+ *     Allocate and initialize a scsi_device matching sdevscan. Optionally
  *     set fields based on values in *@bflags. If @sdevnew is not
- *     NULL, store the address of the new Scsi_Device in *@sdevnew (needed
+ *     NULL, store the address of the new scsi_device in *@sdevnew (needed
  *     when scanning a particular LUN).
  *
  * Return:
- *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
- *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
+ *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
+ *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
@@ -674,7 +674,7 @@
 	 *
 	 * The above is vague, as it implies that we could treat 001 and
 	 * 011 the same. Stay compatible with previous code, and create a
-	 * Scsi_Device for a PQ of 1
+	 * scsi_device for a PQ of 1
 	 *
 	 * Don't set the device offline here; rather let the upper
 	 * level drivers eval the PQ to decide whether they should
@@ -784,8 +784,8 @@
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
  * @lun:	LUN of target device
- * @sdevscan:	probe the LUN corresponding to this Scsi_Device
- * @sdevnew:	store the value of any new Scsi_Device allocated
+ * @sdevscan:	probe the LUN corresponding to this scsi_device
+ * @sdevnew:	store the value of any new scsi_device allocated
  * @bflagsp:	store bflags here if not NULL
  *
  * Description:
@@ -793,10 +793,10 @@
  *     allocate and set it up by calling scsi_add_lun.
  *
  * Return:
- *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
+ *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
  *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
  *         attached at the LUN
- *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
+ *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
 				  uint lun, int *bflagsp,
@@ -1046,7 +1046,7 @@
 
 /**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
- * @sdevscan:	scan the host, channel, and id of this Scsi_Device
+ * @sdevscan:	scan the host, channel, and id of this scsi_device
  *
  * Description:
  *     If @sdevscan is for a SCSI-3 or up device, send a REPORT LUN
@@ -1472,16 +1472,16 @@
 /*
  * Function:    scsi_get_host_dev()
  *
- * Purpose:     Create a Scsi_Device that points to the host adapter itself.
+ * Purpose:     Create a scsi_device that points to the host adapter itself.
  *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ * Arguments:   SHpnt   - Host that needs a scsi_device
  *
  * Lock status: None assumed.
  *
- * Returns:     The Scsi_Device or NULL
+ * Returns:     The scsi_device or NULL
  *
  * Notes:
- *	Attach a single Scsi_Device to the Scsi_Host - this should
+ *	Attach a single scsi_device to the Scsi_Host - this should
  *	be made to look like a "pseudo-device" that points to the
  *	HA itself.
  *
@@ -1518,7 +1518,7 @@
  *
  * Purpose:     Free a scsi_device that points to the host adapter itself.
  *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ * Arguments:   SHpnt   - Host that needs a scsi_device
  *
  * Lock status: None assumed.
  *
Index: scsi-misc-2.6/drivers/scsi/scsi_typedefs.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_typedefs.h	2005-10-29 19:25:07.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_typedefs.h	2005-10-29 19:25:27.000000000 +0200
@@ -1,4 +1,3 @@
 
-typedef struct scsi_device Scsi_Device;
 typedef struct scsi_cmnd Scsi_Cmnd;
 typedef struct scsi_request Scsi_Request;
Index: scsi-misc-2.6/drivers/scsi/aacraid/commsup.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aacraid/commsup.c	2005-10-29 19:20:33.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aacraid/commsup.c	2005-10-29 19:27:04.000000000 +0200
@@ -820,7 +820,7 @@
 				break;
 
 			/*
-			 *	Find the Scsi_Device associated with the SCSI
+			 *	Find the scsi_device associated with the SCSI
 			 * address. Make sure we have the right array, and if
 			 * so set the flag to initiate a new re-config once we
 			 * see an AifEnConfigChange AIF come through.
@@ -987,7 +987,7 @@
 
 
 	/*
-	 *	Find the Scsi_Device associated with the SCSI address,
+	 *	Find the scsi_device associated with the SCSI address,
 	 * and mark it as changed, invalidating the cache. This deals
 	 * with changes to existing device IDs.
 	 */

From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] give ->proc_info a struct Scsi_Host * parameter
Date: Mon, 12 May 2003 16:03:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512160344.A11185@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:34319 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S262123AbTELNvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 09:51:05 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Yeah, I know the method is obsolete but for proper refcounting we
need to get rid of all those scsi_host_hn_get() abusers.

scsi_host_hn_get() and scsi_host_put() are not exported anymore
after this patch.


--- 1.27/drivers/acorn/scsi/acornscsi.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/acornscsi.c	Mon May 12 14:26:08 2003
@@ -2861,18 +2861,15 @@
     return string;
 }
 
-int acornscsi_proc_info(char *buffer, char **start, off_t offset,
-			int length, int host_no, int inout)
+int acornscsi_proc_info(struct Scsi_Host *instance, char *buffer, char **start, off_t offset,
+			int length, int inout)
 {
     int pos, begin = 0, devidx;
-    struct Scsi_Host *instance;
     Scsi_Device *scd;
     AS_Host *host;
     char *p = buffer;
 
-    instance = scsi_host_hn_get(host_no);
-
-    if (inout == 1 || !instance)
+    if (inout == 1)
 	return -EINVAL;
 
     host  = (AS_Host *)instance->hostdata;
===== drivers/acorn/scsi/arxescsi.c 1.17 vs edited =====
--- 1.17/drivers/acorn/scsi/arxescsi.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/arxescsi.c	Mon May 12 14:26:09 2003
@@ -235,17 +235,12 @@
  * Returns : length of data written to buffer.
  */
 static int
-arxescsi_proc_info(char *buffer, char **start, off_t offset, int length,
+arxescsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,
 		   int host_no, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host;
 	struct arxescsi_info *info;
 	Scsi_Device *scd;
-
-	host = scsi_host_hn_get(host_no);
-	if (!host)
-		return 0;
 
 	info = (struct arxescsi_info *)host->hostdata;
 	if (inout == 1)
===== drivers/acorn/scsi/cumana_1.c 1.15 vs edited =====
--- 1.15/drivers/acorn/scsi/cumana_1.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/cumana_1.c	Mon May 12 14:26:09 2003
@@ -35,9 +35,6 @@
 #define NCR5380_queue_command		cumanascsi_queue_command
 #define NCR5380_proc_info		cumanascsi_proc_info
 
-int NCR5380_proc_info(char *buffer, char **start, off_t offset,
-		      int length, int hostno, int inout);
-
 #define BOARD_NORMAL	0
 #define BOARD_NCR53C400	1
 
===== drivers/acorn/scsi/cumana_2.c 1.24 vs edited =====
--- 1.24/drivers/acorn/scsi/cumana_2.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/cumana_2.c	Mon May 12 14:26:09 2003
@@ -353,17 +353,12 @@
  *	      inout  - 0 for reading, 1 for writing.
  * Returns  : length of data written to buffer.
  */
-int cumanascsi_2_proc_info (char *buffer, char **start, off_t offset,
-			    int length, int host_no, int inout)
+int cumanascsi_2_proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			    int length, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host;
 	struct cumanascsi2_info *info;
 	Scsi_Device *scd;
-
-	host = scsi_host_hn_get(host_no);
-	if (!host)
-		return 0;
 
 	if (inout == 1)
 		return cumanascsi_2_set_proc_info(host, buffer, length);
===== drivers/acorn/scsi/ecoscsi.c 1.14 vs edited =====
--- 1.14/drivers/acorn/scsi/ecoscsi.c	Mon Nov 18 02:04:35 2002
+++ edited/drivers/acorn/scsi/ecoscsi.c	Mon May 12 14:26:09 2003
@@ -233,9 +233,6 @@
 #endif
 #undef STAT
 
-int NCR5380_proc_info(char *buffer, char **start, off_t offset,
-		      int length, int hostno, int inout);
-
 #define BOARD_NORMAL	0
 #define BOARD_NCR53C400	1
 
===== drivers/acorn/scsi/eesox.c 1.24 vs edited =====
--- 1.24/drivers/acorn/scsi/eesox.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/eesox.c	Mon May 12 14:26:09 2003
@@ -427,17 +427,12 @@
  *	      inout  - 0 for reading, 1 for writing.
  * Returns  : length of data written to buffer.
  */
-int eesoxscsi_proc_info(char *buffer, char **start, off_t offset,
-			    int length, int host_no, int inout)
+int eesoxscsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			    int length, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host;
 	struct eesoxscsi_info *info;
 	Scsi_Device *scd;
-
-	host = scsi_host_hn_get(host_no);
-	if (!host)
-		return 0;
 
 	if (inout == 1)
 		return eesoxscsi_set_proc_info(host, buffer, length);
===== drivers/acorn/scsi/oak.c 1.16 vs edited =====
--- 1.16/drivers/acorn/scsi/oak.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/oak.c	Mon May 12 14:26:09 2003
@@ -30,9 +30,6 @@
 #define NCR5380_queue_command		oakscsi_queue_command
 #define NCR5380_proc_info		oakscsi_proc_info
 
-int NCR5380_proc_info(char *buffer, char **start, off_t offset,
-		      int length, int hostno, int inout);
-
 #define NCR5380_implementation_fields	int port, ctrl
 #define NCR5380_local_declare()		struct Scsi_Host *_instance
 #define NCR5380_setup(instance)		_instance = instance
===== drivers/acorn/scsi/powertec.c 1.22 vs edited =====
--- 1.22/drivers/acorn/scsi/powertec.c	Thu May  1 19:59:24 2003
+++ edited/drivers/acorn/scsi/powertec.c	Mon May 12 14:26:09 2003
@@ -239,19 +239,14 @@
  *	      inout   - 0 for reading, 1 for writing.
  * Returns  : length of data written to buffer.
  */
-int powertecscsi_proc_info(char *buffer, char **start, off_t offset,
+int powertecscsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
 			    int length, int host_no, int inout)
 {
 	int pos, begin;
-	struct Scsi_Host *host;
 	struct powertec_info *info;
 	Scsi_Device *scd;
 
-	host = scsi_host_hn_get(host_no);
-	if (!host)
-		return 0;
-
-	if (inout == 1)
+	If (inout == 1)
 		return powertecscsi_set_proc_info(host, buffer, length);
 
 	info = (struct powertec_info *)host->hostdata;
===== drivers/block/cciss_scsi.c 1.13 vs edited =====
--- 1.13/drivers/block/cciss_scsi.c	Mon May 12 14:17:05 2003
+++ edited/drivers/block/cciss_scsi.c	Mon May 12 14:33:45 2003
@@ -54,11 +54,11 @@
 const char *cciss_scsi_info(struct Scsi_Host *sa);
 
 int cciss_scsi_proc_info(
+		struct Scsi_Host *sh,
 		char *buffer, /* data buffer */
 		char **start, 	   /* where data in buffer starts */
 		off_t offset,	   /* offset from start of imaginary file */
 		int length, 	   /* length of data in buffer */
-		int hostnum, 	   /* which host adapter (always zero for me) */
 		int func);	   /* 0 == read, 1 == write */
 
 int cciss_scsi_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *));
@@ -1121,24 +1121,19 @@
 
 
 int
-cciss_scsi_proc_info(char *buffer, /* data buffer */
+cciss_scsi_proc_info(struct Scsi_Host *sh,
+		char *buffer, /* data buffer */
 		char **start, 	   /* where data in buffer starts */
 		off_t offset,	   /* offset from start of imaginary file */
 		int length, 	   /* length of data in buffer */
-		int hostnum, 	   /* which host adapter (always zero for me) */
 		int func)	   /* 0 == read, 1 == write */
 {
 
 	int buflen, datalen;
-	struct Scsi_Host *sh;
 	ctlr_info_t *ci;
 	int cntl_num;
 
 
-	sh = scsi_host_hn_get(hostnum);
-	if (sh == NULL) /* This really shouldn't ever happen. */
-		return -EINVAL;
-
 	ci = (ctlr_info_t *) sh->hostdata[0];
 	if (ci == NULL)  /* This really shouldn't ever happen. */
 		return -EINVAL;
@@ -1146,7 +1141,7 @@
 	cntl_num = ci->ctlr;	/* Get our index into the hba[] array */
 
 	if (func == 0) {	/* User is reading from /proc/scsi/ciss*?/?*  */
-		buflen = sprintf(buffer, "hostnum=%d\n", hostnum); 	
+		buflen = sprintf(buffer, "hostnum=%d\n", sh->host_no); 	
 
 		datalen = buflen - offset;
 		if (datalen < 0) { 	/* they're reading past EOF. */
@@ -1156,7 +1151,7 @@
 			*start = buffer + offset;
 		return(datalen);
 	} else 	/* User is writing to /proc/scsi/cciss*?/?*  ... */
-		return cciss_scsi_user_command(cntl_num, hostnum,
+		return cciss_scsi_user_command(cntl_num, sh->host_no,
 			buffer, length);	
 } 
 
===== drivers/ieee1394/sbp2.c 1.30 vs edited =====
--- 1.30/drivers/ieee1394/sbp2.c	Fri May  2 15:13:14 2003
+++ edited/drivers/ieee1394/sbp2.c	Mon May 12 14:36:15 2003
@@ -2998,11 +2998,10 @@
 #define SPRINTF(args...) \
         do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
 
-static int sbp2scsi_proc_info(char *buffer, char **start, off_t offset,
-			      int length, int hostno, int inout)
+static int sbp2scsi_proc_info(struct Scsi_Host *scsi_host, char *buffer, char **start, off_t offset,
+			      int length, int inout)
 {
 	Scsi_Device *scd;
-	struct Scsi_Host *scsi_host;
 	struct hpsb_host *host;
 	char *pos = buffer;
 
@@ -3010,16 +3009,12 @@
 	if (inout)
 		return length;
 
-	scsi_host = scsi_host_hn_get(hostno);
-	if (!scsi_host)  /* if we couldn't find it, we return an error */
-		return -ESRCH;
-
 	host = hpsb_get_host_bykey(&sbp2_highlevel, (unsigned long)scsi_host);
 	if (!host) /* shouldn't happen, but... */
 		return -ESRCH;
 
-	SPRINTF("Host scsi%d             : SBP-2 IEEE-1394 (%s)\n", hostno,
-		host->driver->name);
+	SPRINTF("Host scsi%d             : SBP-2 IEEE-1394 (%s)\n",
+		scsi_host->host_no, host->driver->name);
 	SPRINTF("Driver version         : %s\n", version);
 
 	SPRINTF("\nModule options         :\n");
@@ -3052,8 +3047,6 @@
 
 	SPRINTF("\n");
 
-	/* release the reference count on this host */
-	scsi_host_put(scsi_host);
 	/* Calculate start of next buffer, and return value. */
 	*start = buffer + offset;
 
===== drivers/message/fusion/mptscsih.c 1.23 vs edited =====
--- 1.23/drivers/message/fusion/mptscsih.c	Sun May  4 11:56:42 2003
+++ edited/drivers/message/fusion/mptscsih.c	Mon May 12 14:26:09 2003
@@ -2149,8 +2149,8 @@
  * 	hostno: scsi host number
  *	func:   if write = 1; if read = 0
  */
-int mptscsih_proc_info(char *buffer, char **start, off_t offset,
-			int length, int hostno, int func)
+int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			int length, int func)
 {
 	MPT_ADAPTER	*ioc = NULL;
 	MPT_SCSI_HOST	*hd = NULL;
@@ -2161,7 +2161,7 @@
 			buffer, start, *start, offset, length));
 
 	for (ioc = mpt_adapter_find_first(); ioc != NULL; ioc = mpt_adapter_find_next(ioc)) {
-		if ((ioc->sh) && (ioc->sh->host_no == hostno)) {
+		if ((ioc->sh) && (ioc->sh == host)) {
 			hd = (MPT_SCSI_HOST *)ioc->sh->hostdata;
 			break;
 		}
===== drivers/message/fusion/mptscsih.h 1.16 vs edited =====
--- 1.16/drivers/message/fusion/mptscsih.h	Sun May  4 11:56:43 2003
+++ edited/drivers/message/fusion/mptscsih.h	Mon May 12 14:26:10 2003
@@ -199,7 +199,7 @@
 extern	int		 x_scsi_slave_alloc(Scsi_Device *);
 extern	int		 x_scsi_slave_configure(Scsi_Device *);
 extern	void		 x_scsi_slave_destroy(Scsi_Device *);
-extern	int		 x_scsi_proc_info(char *, char **, off_t, int, int, int);
+extern	int		 x_scsi_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
===== drivers/scsi/3w-xxxx.c 1.32 vs edited =====
--- 1.32/drivers/scsi/3w-xxxx.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/3w-xxxx.c	Mon May 12 15:14:01 2003
@@ -2497,7 +2497,8 @@
 } /* End tw_scsi_eh_reset() */
 
 /* This function handles input and output from /proc/scsi/3w-xxxx/x */
-int tw_scsi_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout) 
+int tw_scsi_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
+		      off_t offset, int length, int inout) 
 {
 	TW_Device_Extension *tw_dev = NULL;
 	TW_Info info;
@@ -2508,7 +2509,7 @@
 
 	/* Find the correct device extension */
 	for (i=0;i<tw_device_extension_count;i++) 
-		if (tw_device_extension_list[i]->host->host_no == hostno) 
+		if (tw_device_extension_list[i]->host->host_no == shost->host_no) 
 			tw_dev = tw_device_extension_list[i];
 	if (tw_dev == NULL) {
 		printk(KERN_WARNING "3w-xxxx: tw_scsi_proc_info(): Couldn't locate device extension.\n");
@@ -2544,7 +2545,7 @@
 		if (start) {
 			*start = buffer;
 		}
-		tw_copy_info(&info, "scsi%d: 3ware Storage Controller\n", hostno);
+		tw_copy_info(&info, "scsi%d: 3ware Storage Controller\n", shost->host_no);
 		tw_copy_info(&info, "Driver version: %s\n", tw_driver_version);
 		tw_copy_info(&info, "Current commands posted:       %3d\n", tw_dev->posted_request_count);
 		tw_copy_info(&info, "Max commands posted:           %3d\n", tw_dev->max_posted_request_count);
===== drivers/scsi/3w-xxxx.h 1.21 vs edited =====
--- 1.21/drivers/scsi/3w-xxxx.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/3w-xxxx.h	Mon May 12 14:26:10 2003
@@ -474,7 +474,6 @@
 int tw_scsi_detect(Scsi_Host_Template *tw_host);
 int tw_scsi_eh_abort(Scsi_Cmnd *SCpnt);
 int tw_scsi_eh_reset(Scsi_Cmnd *SCpnt);
-int tw_scsi_proc_info(char *buffer, char **start, off_t offset, int length, int inode, int inout);
 int tw_scsi_queue(Scsi_Cmnd *cmd, void (*done) (Scsi_Cmnd *));
 int tw_scsi_release(struct Scsi_Host *tw_host);
 int tw_scsiop_inquiry(TW_Device_Extension *tw_dev, int request_id);
===== drivers/scsi/53c700.c 1.29 vs edited =====
--- 1.29/drivers/scsi/53c700.c	Sat Apr 26 16:41:50 2003
+++ edited/drivers/scsi/53c700.c	Mon May 12 14:26:10 2003
@@ -167,7 +167,7 @@
 STATIC int NCR_700_bus_reset(Scsi_Cmnd * SCpnt);
 STATIC int NCR_700_dev_reset(Scsi_Cmnd * SCpnt);
 STATIC int NCR_700_host_reset(Scsi_Cmnd * SCpnt);
-STATIC int NCR_700_proc_directory_info(char *, char **, off_t, int, int, int);
+STATIC int NCR_700_proc_directory_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_configure(Scsi_Device *SDpnt);
@@ -1703,22 +1703,15 @@
 	return IRQ_RETVAL(handled);
 }
 
-/* FIXME: Need to put some proc information in and plumb it
- * into the scsi proc system */
 STATIC int
-NCR_700_proc_directory_info(char *proc_buf, char **startp,
-			 off_t offset, int bytes_available,
-			 int host_no, int write)
+NCR_700_proc_directory_info(struct Scsi_Host *host, char *proc_buf, char **startp,
+			 off_t offset, int bytes_available, int write)
 {
 	static char buf[4096];	/* 1 page should be sufficient */
 	int len = 0;
 	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 	Scsi_Device *SDp;
-
-	host = scsi_host_hn_get(host_no);
-	if(host == NULL)
-		return 0;
 
 	if(write) {
 		/* FIXME: Clear internal statistics here */
===== drivers/scsi/BusLogic.c 1.19 vs edited =====
--- 1.19/drivers/scsi/BusLogic.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/BusLogic.c	Mon May 12 14:26:10 2003
@@ -4327,9 +4327,9 @@
   BugLogic_ProcDirectoryInfo implements /proc/scsi/BusLogic/<N>.
 */
 
-int BusLogic_ProcDirectoryInfo(char *ProcBuffer, char **StartPointer,
+int BusLogic_ProcDirectoryInfo(struct Scsi_Host *shost, char *ProcBuffer, char **StartPointer,
 			       off_t Offset, int BytesAvailable,
-			       int HostNumber, int WriteFlag)
+			       int WriteFlag)
 {
   BusLogic_HostAdapter_T *HostAdapter;
   BusLogic_TargetStatistics_T *TargetStatistics;
@@ -4338,11 +4338,11 @@
   for (HostAdapter = BusLogic_FirstRegisteredHostAdapter;
        HostAdapter != NULL;
        HostAdapter = HostAdapter->Next)
-    if (HostAdapter->HostNumber == HostNumber) break;
+    if (HostAdapter->HostNumber == shost->host_no) break;
   if (HostAdapter == NULL)
     {
       BusLogic_Error("Cannot find Host Adapter for SCSI Host %d\n",
-		     NULL, HostNumber);
+		     NULL, shost->host_no);
       return 0;
     }
   TargetStatistics = HostAdapter->TargetStatistics;
===== drivers/scsi/BusLogic.h 1.14 vs edited =====
--- 1.14/drivers/scsi/BusLogic.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/BusLogic.h	Mon May 12 14:45:05 2003
@@ -56,7 +56,7 @@
 				 void (*CompletionRoutine)(SCSI_Command_T *));
 extern int BusLogic_BIOSDiskParameters(struct scsi_device *,
 		struct block_device *, sector_t, int *);
-extern int BusLogic_ProcDirectoryInfo(char *, char **, off_t, int, int, int);
+extern int BusLogic_ProcDirectoryInfo(struct Scsi_Host *, char *, char **, off_t, int, int);
 extern int BusLogic_SlaveConfigure(SCSI_Device_T *);
 
 #ifdef BusLogic_DriverVersion
===== drivers/scsi/NCR5380.c 1.16 vs edited =====
--- 1.16/drivers/scsi/NCR5380.c	Sat Apr 26 16:28:13 2003
+++ edited/drivers/scsi/NCR5380.c	Mon May 12 14:48:52 2003
@@ -824,7 +824,7 @@
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
 
-	len = NCR5380_proc_info(pr_bfr, &start, 0, sizeof(pr_bfr), instance->host_no, 0);
+	len = NCR5380_proc_info(instance, pr_bfr, &start, 0, sizeof(pr_bfr), 0);
 	pr_bfr[len] = 0;
 	printk("\n%s\n", pr_bfr);
 }
@@ -855,16 +855,12 @@
 #ifndef NCR5380_proc_info
 static
 #endif
-int NCR5380_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start, off_t offset, int length, int inout)
 {
 	char *pos = buffer;
-	struct Scsi_Host *instance;
 	struct NCR5380_hostdata *hostdata;
 	Scsi_Cmnd *ptr;
 
-	instance = scsi_host_hn_get(hostno);
-	if (!instance)
-		return (-ESRCH);
 	hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
 	if (inout) {		/* Has data been written to the file ? */
===== drivers/scsi/NCR5380.h 1.7 vs edited =====
--- 1.7/drivers/scsi/NCR5380.h	Sat Apr 26 16:28:14 2003
+++ edited/drivers/scsi/NCR5380.h	Mon May 12 14:58:21 2003
@@ -310,7 +310,10 @@
 static int NCR5380_host_reset(Scsi_Cmnd * cmd);
 static int NCR5380_device_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
-
+#ifdef NCR5380_proc_info
+int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
+off_t offset, int length, int inout);
+#endif
 
 static void NCR5380_reselect(struct Scsi_Host *instance);
 static int NCR5380_select(struct Scsi_Host *instance, Scsi_Cmnd * cmd, int tag);
===== drivers/scsi/NCR53C9x.c 1.22 vs edited =====
--- 1.22/drivers/scsi/NCR53C9x.c	Sat Apr 26 16:28:14 2003
+++ edited/drivers/scsi/NCR53C9x.c	Mon May 12 14:26:10 2003
@@ -890,24 +890,15 @@
 }
 
 /* ESP proc filesystem code. */
-int esp_proc_info(char *buffer, char **start, off_t offset, int length,
-		  int hostno, int inout)
+int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset, int length,
+		  int inout)
 {
-	struct NCR_ESP *esp;
+	struct NCR_ESP *esp = (struct NCR_ESP *) SCpnt->device->host->hostdata;
 
 	if(inout)
 		return -EINVAL; /* not yet */
-
-	for_each_esp(esp) {
-		if(esp->ehost->host_no == hostno)
-			break;
-	}
-	if(!esp)
-		return -EINVAL;
-
 	if(start)
 		*start = buffer;
-
 	return esp_host_info(esp, buffer, offset, length);
 }
 
===== drivers/scsi/NCR53C9x.h 1.7 vs edited =====
--- 1.7/drivers/scsi/NCR53C9x.h	Sat Apr 26 16:28:14 2003
+++ edited/drivers/scsi/NCR53C9x.h	Mon May 12 14:26:10 2003
@@ -664,6 +664,6 @@
 extern int esp_command(Scsi_Cmnd *);
 extern int esp_abort(Scsi_Cmnd *);
 extern int esp_reset(Scsi_Cmnd *);
-extern int esp_proc_info(char *buffer, char **start, off_t offset, int length,
-			 int hostno, int inout);
+extern int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset, int length,
+			 int inout);
 #endif /* !(NCR53C9X_H) */
===== drivers/scsi/advansys.c 1.33 vs edited =====
--- 1.33/drivers/scsi/advansys.c	Thu May  8 20:31:08 2003
+++ edited/drivers/scsi/advansys.c	Mon May 12 14:41:38 2003
@@ -4290,14 +4290,14 @@
  * user just won't get all the available statistics.
  */
 int
-advansys_proc_info(char *buffer, char **start, off_t offset, int length,
-                   int hostno, int inout)
+advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
+		off_t offset, int length, int inout)
 {
     struct Scsi_Host    *shp;
     asc_board_t         *boardp;
     int                 i;
     char                *cp;
-    int                 cplen;
+    int			cplen;
     int                 cnt;
     int                 totcnt;
     int                 leftlen;
@@ -4322,7 +4322,7 @@
 
     /* Find the specified board. */
     for (i = 0; i < asc_board_count; i++) {
-        if (asc_host[i]->host_no == hostno) {
+        if (asc_host[i]->host_no == shost->host_no) {
             break;
         }
     }
@@ -4767,7 +4767,7 @@
 
 	    scsi_set_device(shp, &pci_devp->dev);
 
-            /* Save a pointer to the Scsi_host of each board found. */
+            /* Save a pointer to the Scsi_Host of each board found. */
             asc_host[asc_board_count++] = shp;
 
             /* Initialize private per board data */
===== drivers/scsi/advansys.h 1.10 vs edited =====
--- 1.10/drivers/scsi/advansys.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/advansys.h	Mon May 12 14:26:10 2003
@@ -55,14 +55,6 @@
 int advansys_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int[]);
 static int advansys_slave_configure(Scsi_Device *);
-#ifdef CONFIG_PROC_FS
-#if LINUX_VERSION_CODE < ASC_LINUX_VERSION(2,3,28)
-extern struct proc_dir_entry proc_scsi_advansys;
-#endif /* version < v2.3.28 */
-int advansys_proc_info(char *, char **, off_t, int, int, int);
-#else /* !defined(CONFIG_PROC_FS) */
-#define advansys_proc_info      NULL
-#endif /* !defined(CONFIG_PROC_FS) */
 
 /* init/main.c setup function */
 void advansys_setup(char *, int *);
===== drivers/scsi/aha152x.c 1.30 vs edited =====
--- 1.30/drivers/scsi/aha152x.c	Sat Apr 26 16:28:18 2003
+++ edited/drivers/scsi/aha152x.c	Mon May 12 14:26:11 2003
@@ -3734,26 +3734,18 @@
 #define SPRINTF(args...) \
 	do { if(pos < buffer + length) pos += sprintf(pos, ## args); } while(0)
 
-static int aha152x_proc_info(char *buffer, char **start,
-		      off_t offset, int length, int hostno, int inout)
+static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start,
+		      off_t offset, int length, int inout)
 {
 	int i;
 	char *pos = buffer;
-	struct Scsi_Host *shpnt;
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
 	int thislength;
 
-	for (i = 0, shpnt = (struct Scsi_Host *) NULL; i<ARRAY_SIZE(aha152x_host); i++)
-		if (aha152x_host[i] && aha152x_host[i]->host_no == hostno)
-			shpnt = aha152x_host[i];
-
-	if (!shpnt)
-		return -ESRCH;
-
 	DPRINTK(debug_procinfo, 
 	       KERN_DEBUG "aha152x_proc_info: buffer=%p offset=%ld length=%d hostno=%d inout=%d\n",
-	       buffer, offset, length, hostno, inout);
+	       buffer, offset, length, shpnt->host_no, inout);
 
 
 	if (inout)
===== drivers/scsi/aha1740.c 1.15 vs edited =====
--- 1.15/drivers/scsi/aha1740.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/aha1740.c	Mon May 12 14:26:11 2003
@@ -76,21 +76,15 @@
 /* One for each IRQ level (9-15) */
 static struct Scsi_Host * aha_host[8] = {NULL, };
 
-static int aha1740_proc_info(char *buffer, char **start, off_t offset,
-		      int length, int hostno, int inout)
+static int aha1740_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset,
+		      int length, int inout)
 {
     int len;
-    struct Scsi_Host * shpnt;
     struct aha1740_hostdata *host;
 
     if (inout)
 	return-ENOSYS;
 
-    for (len = 0; len < 8; len++) {
-	shpnt = aha_host[len];
-	if (shpnt && shpnt->host_no == hostno)
-	    break;
-    }
     host = HOSTDATA(shpnt);
 
     len = sprintf(buffer, "aha174x at IO:%lx, IRQ %d, SLOT %d.\n"
@@ -108,7 +102,6 @@
     if (len > length)
 	len = length;
     return len;
-}
 
 
 static int aha1740_makecode(unchar *sense, unchar *status)
===== drivers/scsi/aha1740.h 1.6 vs edited =====
--- 1.6/drivers/scsi/aha1740.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/aha1740.h	Mon May 12 14:26:11 2003
@@ -156,7 +156,6 @@
 static int aha1740_command(Scsi_Cmnd *);
 static int aha1740_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 static int aha1740_biosparam(struct scsi_device *, struct block_device *, sector_t, int *);
-static int aha1740_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout);
 
 #define AHA1740_ECBS 32
 #define AHA1740_SCATTER 16
===== drivers/scsi/atari_NCR5380.c 1.12 vs edited =====
--- 1.12/drivers/scsi/atari_NCR5380.c	Thu Feb 13 16:42:37 2003
+++ edited/drivers/scsi/atari_NCR5380.c	Mon May 12 14:26:11 2003
@@ -746,11 +746,10 @@
 #ifndef NCR5380_proc_info
 static
 #endif
-int NCR5380_proc_info (char *buffer, char **start, off_t offset,
-		       int length, int hostno, int inout)
+int NCR5380_proc_info (struct Scsi_Host *instance, char *buffer, char **start, off_t offset,
+		       int length, int inout)
 {
     char *pos = buffer;
-    struct Scsi_Host *instance;
     struct NCR5380_hostdata *hostdata;
     Scsi_Cmnd *ptr;
     unsigned long flags;
@@ -763,9 +762,6 @@
 	}					\
     } while (0)
 
-    instance = scsi_host_hn_get(hostno);
-    if (!instance)
-	return(-ESRCH);
     hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
     if (inout) { /* Has data been written to the file ? */
===== drivers/scsi/atari_scsi.h 1.5 vs edited =====
--- 1.5/drivers/scsi/atari_scsi.h	Sun Feb  9 20:14:51 2003
+++ edited/drivers/scsi/atari_scsi.h	Mon May 12 14:26:11 2003
@@ -21,7 +21,6 @@
 int atari_scsi_detect (Scsi_Host_Template *);
 const char *atari_scsi_info (struct Scsi_Host *);
 int atari_scsi_reset (Scsi_Cmnd *, unsigned int);
-int atari_scsi_proc_info (char *, char **, off_t, int, int, int);
 #ifdef MODULE
 int atari_scsi_release (struct Scsi_Host *);
 #else
===== drivers/scsi/atp870u.c 1.20 vs edited =====
--- 1.20/drivers/scsi/atp870u.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/atp870u.c	Mon May 12 15:07:29 2003
@@ -2657,33 +2657,14 @@
 }
 
 #define BLS buffer + len + size
-int atp870u_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+int atp870u_proc_info(struct Scsi_Host *HBAptr, char *buffer, char **start, off_t offset, int length, int inout)
 {
-	struct Scsi_Host *HBAptr;
 	static u8 buff[512];
-	int i;
 	int size = 0;
 	int len = 0;
 	off_t begin = 0;
 	off_t pos = 0;
 
-	HBAptr = NULL;
-	for (i = 0; i < MAX_ATP; i++) {
-		if ((HBAptr = atp_host[i]) != NULL) {
-			if (HBAptr->host_no == hostno) {
-				break;
-			}
-			HBAptr = NULL;
-		}
-	}
-
-	if (HBAptr == NULL) {
-		size += sprintf(BLS, "Can't find adapter for host number %d\n", hostno);
-		len += size;
-		pos = begin + len;
-		size = 0;
-		goto stop_output;
-	}
 	if (inout == TRUE) {	/* Has data been written to the file? */
 		return (atp870u_set_info(buffer, length, HBAptr));
 	}
@@ -2701,9 +2682,7 @@
 	size += sprintf(BLS, "                   IRQ: %d\n", HBAptr->irq);
 	len += size;
 	pos = begin + len;
-	size = 0;
 
-stop_output:
 	*start = buffer + (offset - begin);	/* Start of wanted data */
 	len -= (offset - begin);	/* Start slop */
 	if (len > length) {
===== drivers/scsi/atp870u.h 1.9 vs edited =====
--- 1.9/drivers/scsi/atp870u.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/atp870u.h	Mon May 12 14:26:11 2003
@@ -35,6 +35,4 @@
 
 extern const char *atp870u_info(struct Scsi_Host *);
 
-extern int atp870u_proc_info(char *, char **, off_t, int, int, int);
-
 #endif
===== drivers/scsi/cpqfcTS.h 1.8 vs edited =====
--- 1.8/drivers/scsi/cpqfcTS.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/cpqfcTS.h	Mon May 12 14:26:11 2003
@@ -6,7 +6,7 @@
 extern int cpqfcTS_detect(Scsi_Host_Template *);
 extern int cpqfcTS_release(struct Scsi_Host *);
 extern const char * cpqfcTS_info(struct Scsi_Host *);
-extern int cpqfcTS_proc_info(char *, char **, off_t, int, int, int);
+extern int cpqfcTS_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 extern int cpqfcTS_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
 extern int cpqfcTS_abort(Scsi_Cmnd *);
 extern int cpqfcTS_reset(Scsi_Cmnd *, unsigned int);
===== drivers/scsi/cpqfcTSinit.c 1.37 vs edited =====
--- 1.37/drivers/scsi/cpqfcTSinit.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/cpqfcTSinit.c	Mon May 12 14:26:11 2003
@@ -921,10 +921,9 @@
 
 // Routine to get data for /proc RAM filesystem
 //
-int cpqfcTS_proc_info (char *buffer, char **start, off_t offset, int length, 
-		       int hostno, int inout)
+int cpqfcTS_proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, 
+		       int inout)
 {
-  struct Scsi_Host *host;
   Scsi_Cmnd DumCmnd;
   int Chan, Targ, i;
   struct info_str info;
@@ -933,11 +932,6 @@
   PFC_LOGGEDIN_PORT pLoggedInPort;
   char buf[81];
 
-  // Search the Scsi host list for our controller
-  host = scsi_host_hn_get(hostno);
-
-  if (!host) return -ESRCH;
-
   if (inout) return -EINVAL;
 
   // get the pointer to our Scsi layer HBA buffer  
@@ -969,7 +963,7 @@
     				NULL,     // DON'T search list for FC WWN
     				NULL))){   // DON'T care about end of list
 	copy_info(&info, "Host: scsi%d Channel: %02d TargetId: %02d -> WWN: ",
-			   hostno, Chan, Targ);
+			   host->host_no, Chan, Targ);
         for( i=3; i>=0; i--)        // copy the LOGIN port's WWN
           copy_info(&info, "%02X", pLoggedInPort->u.ucWWN[i]);
         for( i=7; i>3; i--)             // copy the LOGIN port's WWN
===== drivers/scsi/dc390.h 1.6 vs edited =====
--- 1.6/drivers/scsi/dc390.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/dc390.h	Mon May 12 15:06:40 2003
@@ -33,8 +33,6 @@
 # define USE_NEW_EH
 #endif
 
-#if defined(HOSTS_C) || defined(MODULE) || LINUX_VERSION_CODE > KERNEL_VERSION(2,3,99)
-
 extern int DC390_detect(Scsi_Host_Template *psht);
 extern int DC390_queue_command(Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *));
 extern int DC390_abort(Scsi_Cmnd *cmd);
@@ -47,7 +45,5 @@
 #else
 # define DC390_release NULL
 #endif
-
-extern int DC390_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout);
 
 #endif /* DC390_H */
===== drivers/scsi/dc395x.c 1.2 vs edited =====
--- 1.2/drivers/scsi/dc395x.c	Tue May  6 22:16:34 2003
+++ edited/drivers/scsi/dc395x.c	Mon May 12 15:06:10 2003
@@ -6062,12 +6062,11 @@
  else SPRINTF(" No  ")
 
 static int
-DC395x_proc_info(char *buffer, char **start, off_t offset, int length,
-		 int hostno, int inout)
+DC395x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length,
+		 int inout)
 {
 	int dev, spd, spd1;
 	char *pos = buffer;
-	struct Scsi_Host *shpnt = NULL;
 	struct AdapterCtlBlk *pACB;
 	struct DeviceCtlBlk *pDCB;
 	unsigned long flags;
@@ -6078,15 +6077,11 @@
 	pACB = DC395x_pACB_start;
 
 	while (pACB != (struct AdapterCtlBlk *) -1) {
-		shpnt = pACB->pScsiHost;
-		if (shpnt->host_no == hostno)
+		if (pACB->pScsiHost == shpnt)
 			break;
 		pACB = pACB->pNextACB;
 	}
 	if (pACB == (struct AdapterCtlBlk *) -1)
-		return -ESRCH;
-
-	if (!shpnt)
 		return -ESRCH;
 
 	if (inout)		/* Has data been written to the file ? */
===== drivers/scsi/dmx3191d.h 1.6 vs edited =====
--- 1.6/drivers/scsi/dmx3191d.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/dmx3191d.h	Mon May 12 15:01:09 2003
@@ -1,4 +1,3 @@
-
 /*
     dmx3191d.h - defines for the Domex DMX3191D SCSI card.
     Copyright (C) 2000 by Massimo Piccioni <dafastidio@libero.it>
@@ -23,7 +22,6 @@
 static int dmx3191d_abort(Scsi_Cmnd *);
 static int dmx3191d_detect(Scsi_Host_Template *);
 static const char* dmx3191d_info(struct Scsi_Host *);
-static int dmx3191d_proc_info(char *, char **, off_t, int, int, int);
 static int dmx3191d_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int dmx3191d_release_resources(struct Scsi_Host *);
 static int dmx3191d_bus_reset(Scsi_Cmnd *);
===== drivers/scsi/dpt_i2o.c 1.29 vs edited =====
--- 1.29/drivers/scsi/dpt_i2o.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/dpt_i2o.c	Mon May 12 14:26:11 2003
@@ -505,8 +505,8 @@
 	return (char *) (pHba->detail);
 }
 
-static int adpt_proc_info(char *buffer, char **start, off_t offset,
-		  int length, int hostno, int inout)
+static int adpt_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+		  int length, int inout)
 {
 	struct adpt_device* d;
 	int id;
@@ -515,7 +515,6 @@
 	int begin = 0;
 	int pos = 0;
 	adpt_hba* pHba;
-	struct Scsi_Host *host;
 	int unit;
 
 	*start = buffer;
@@ -539,7 +538,7 @@
 	// Find HBA (host bus adapter) we are looking for
 	down(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if (pHba->host->host_no == hostno) {
+		if (pHba->host == host) {
 			break;	/* found adapter */
 		}
 	}
===== drivers/scsi/dpti.h 1.9 vs edited =====
--- 1.9/drivers/scsi/dpti.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/dpti.h	Mon May 12 14:26:11 2003
@@ -37,8 +37,6 @@
  * SCSI interface function Prototypes
  */
 
-static int adpt_proc_info(char *buffer, char **start, off_t offset,
-		  int length, int inode, int inout);
 static int adpt_detect(Scsi_Host_Template * sht);
 static int adpt_queue(Scsi_Cmnd * cmd, void (*cmdcomplete) (Scsi_Cmnd *));
 static int adpt_abort(Scsi_Cmnd * cmd);
===== drivers/scsi/dtc.h 1.8 vs edited =====
--- 1.8/drivers/scsi/dtc.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/dtc.h	Mon May 12 14:26:11 2003
@@ -36,8 +36,6 @@
 static int dtc_bus_reset(Scsi_Cmnd *);
 static int dtc_device_reset(Scsi_Cmnd *);
 static int dtc_host_reset(Scsi_Cmnd *);
-static int dtc_proc_info (char *buffer, char **start, off_t offset,
-		   int length, int hostno, int inout);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
===== drivers/scsi/eata_pio.c 1.17 vs edited =====
--- 1.17/drivers/scsi/eata_pio.c	Thu May  8 20:24:14 2003
+++ edited/drivers/scsi/eata_pio.c	Mon May 12 14:26:12 2003
@@ -102,20 +102,15 @@
  * length: If inout==FALSE max number of bytes to be written into the buffer 
  *         else number of bytes in the buffer
  */
-static int eata_pio_proc_info(char *buffer, char **start, off_t offset,
-			      int length, int hostno, int rw)
+static int eata_pio_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset,
+			      int length, int rw)
 {
-    struct Scsi_Host *shost;
     static u8 buff[512];
     int size, len = 0;
     off_t begin = 0, pos = 0;
 
     if (rw)
     	return -ENOSYS;
-    shost = scsi_host_hn_get(hostno);
-    if (!shost)
-    	return -EINVAL;
-
     if (offset == 0)
 	memset(buff, 0, sizeof(buff));
 
===== drivers/scsi/esp.c 1.24 vs edited =====
--- 1.24/drivers/scsi/esp.c	Mon Apr 21 08:54:46 2003
+++ edited/drivers/scsi/esp.c	Mon May 12 14:26:12 2003
@@ -1386,8 +1386,8 @@
 }
 
 /* ESP proc filesystem code. */
-static int esp_proc_info(char *buffer, char **start, off_t offset,
-			 int length, int hostno, int inout)
+static int esp_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			 int length, int inout)
 {
 	struct esp *esp;
 
@@ -1395,7 +1395,7 @@
 		return -EINVAL; /* not yet */
 
 	for_each_esp(esp) {
-		if (esp->ehost->host_no == hostno)
+		if (esp->ehost == host)
 			break;
 	}
 	if (!esp)
===== drivers/scsi/fcal.c 1.10 vs edited =====
--- 1.10/drivers/scsi/fcal.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/fcal.c	Mon May 12 14:26:12 2003
@@ -209,17 +209,12 @@
 #undef SPRINTF
 #define SPRINTF(args...) { if (pos < (buffer + length)) pos += sprintf (pos, ## args); }
 
-int fcal_proc_info (char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+int fcal_proc_info (struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int inout)
 {
-	struct Scsi_Host *host = NULL;
 	struct fcal *fcal;
 	fc_channel *fc;
 	char *pos = buffer;
 	int i, j;
-
-	host = scsi_host_hn_get(hostno);
-
-	if (!host) return -ESRCH;
 
 	if (inout) return length;
     
===== drivers/scsi/fcal.h 1.7 vs edited =====
--- 1.7/drivers/scsi/fcal.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/fcal.h	Mon May 12 14:26:12 2003
@@ -22,7 +22,6 @@
 
 int fcal_detect(Scsi_Host_Template *);
 int fcal_release(struct Scsi_Host *);
-int fcal_proc_info (char *, char **, off_t, int, int, int);
 int fcal_slave_configure(Scsi_Device *);
 
 #endif /* !(_FCAL_H) */
===== drivers/scsi/fd_mcs.c 1.13 vs edited =====
--- 1.13/drivers/scsi/fd_mcs.c	Thu May  8 20:24:14 2003
+++ edited/drivers/scsi/fd_mcs.c	Mon May 12 14:26:12 2003
@@ -586,9 +586,8 @@
  * length: If inout==FALSE max number of bytes to be written into the buffer 
  *         else number of bytes in the buffer
  */
-static int fd_mcs_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+static int fd_mcs_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout)
 {
-	struct Scsi_Host *shpnt;
 	int len = 0;
 	int i;
 
@@ -597,20 +596,10 @@
 
 	*start = buffer + offset;
 
-	for (i = 0; hosts[i] && hosts[i]->host_no != hostno; i++);
-	shpnt = hosts[i];
-
-	if (!shpnt) {
-		return (-ENOENT);
-	} else {
-		len += sprintf(buffer + len, "Future Domain MCS-600/700 Driver %s\n", DRIVER_VERSION);
-
-		len += sprintf(buffer + len, "HOST #%d: %s\n", hostno, adapter_name);
-
-		len += sprintf(buffer + len, "FIFO Size=0x%x, FIFO Count=%d\n", FIFO_Size, FIFO_COUNT);
-
-		len += sprintf(buffer + len, "DriverCalls=%d, Interrupts=%d, BytesRead=%d, BytesWrite=%d\n\n", TOTAL_INTR, INTR_Processed, Bytes_Read, Bytes_Written);
-	}
+	len += sprintf(buffer + len, "Future Domain MCS-600/700 Driver %s\n", DRIVER_VERSION);
+	len += sprintf(buffer + len, "HOST #%d: %s\n", shpnt->host_no, adapter_name);
+	len += sprintf(buffer + len, "FIFO Size=0x%x, FIFO Count=%d\n", FIFO_Size, FIFO_COUNT);
+	len += sprintf(buffer + len, "DriverCalls=%d, Interrupts=%d, BytesRead=%d, BytesWrite=%d\n\n", TOTAL_INTR, INTR_Processed, Bytes_Read, Bytes_Written);
 
 	if ((len -= offset) <= 0)
 		return 0;
===== drivers/scsi/fd_mcs.h 1.7 vs edited =====
--- 1.7/drivers/scsi/fd_mcs.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/fd_mcs.h	Mon May 12 14:26:12 2003
@@ -32,7 +32,6 @@
 static int fd_mcs_queue(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 static int fd_mcs_biosparam(struct scsi_device *, struct block_device *,
 			    sector_t, int *);
-static int fd_mcs_proc_info(char *, char **, off_t, int, int, int);
 static const char *fd_mcs_info(struct Scsi_Host *);
 
 #endif				/* _FD_MCS_H */
===== drivers/scsi/fdomain.c 1.21 vs edited =====
--- 1.21/drivers/scsi/fdomain.c	Sat Apr 26 16:28:20 2003
+++ edited/drivers/scsi/fdomain.c	Mon May 12 14:26:12 2003
@@ -1068,45 +1068,6 @@
    return buffer;
 }
 
-				/* First pass at /proc information routine. */
-/*
- * inout : decides on the direction of the dataflow and the meaning of the 
- *         variables
- * buffer: If inout==FALSE data is being written to it else read from it
- * *start: If inout==FALSE start of the valid data in the buffer
- * offset: If inout==FALSE offset from the beginning of the imaginary file 
- *         from which we start writing into the buffer
- * length: If inout==FALSE max number of bytes to be written into the buffer 
- *         else number of bytes in the buffer
- */
-static int fdomain_16x0_proc_info( char *buffer, char **start, off_t offset,
-			    int length, int hostno, int inout )
-{
-   const char *info = fdomain_16x0_info( NULL );
-   int        len;
-   int        pos;
-   int        begin;
-
-   if (inout) return(-EINVAL);
-    
-   begin = 0;
-   strcpy( buffer, info );
-   strcat( buffer, "\n" );
-
-   pos = len = strlen( buffer );
-
-   if(pos < offset) {
-      len = 0;
-      begin = pos;
-   }
-    
-   *start = buffer + (offset - begin);   /* Start of wanted data */
-   len -= (offset - begin);
-   if(len > length) len = length;
-   
-   return(len);
-}
-   
 #if 0
 static int fdomain_arbitrate( void )
 {
@@ -1870,7 +1831,6 @@
 	.module			= THIS_MODULE,
 	.name			= "fdomain",
 	.proc_name		= "fdomain",
-	.proc_info		= fdomain_16x0_proc_info,
 	.detect			= fdomain_16x0_detect,
 	.info			= fdomain_16x0_info,
 	.command		= fdomain_16x0_command,
===== drivers/scsi/g_NCR5380.c 1.18 vs edited =====
--- 1.18/drivers/scsi/g_NCR5380.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/g_NCR5380.c	Mon May 12 14:26:12 2003
@@ -770,14 +770,13 @@
  *	Locks: global cli/lock for queue walk
  */
  
-int generic_NCR5380_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, char **start, off_t offset, int length, int inout)
 {
 	int len = 0;
 	NCR5380_local_declare();
 	unsigned long flags;
 	unsigned char status;
 	int i;
-	struct Scsi_Host *scsi_ptr;
 	Scsi_Cmnd *ptr;
 	struct NCR5380_hostdata *hostdata;
 #ifdef NCR5380_STATS
@@ -785,9 +784,6 @@
 	extern const char *const scsi_device_types[MAX_SCSI_DEVICE_CODE];
 #endif
 
-	/* For now this is constant so we may walk it */
-	scsi_ptr = scsi_host_hn_get(hostno);
-	
 	NCR5380_setup(scsi_ptr);
 	hostdata = (struct NCR5380_hostdata *) scsi_ptr->hostdata;
 
===== drivers/scsi/g_NCR5380.h 1.8 vs edited =====
--- 1.8/drivers/scsi/g_NCR5380.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/g_NCR5380.h	Mon May 12 14:26:12 2003
@@ -51,11 +51,8 @@
 static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
 static int generic_NCR5380_host_reset(Scsi_Cmnd *);
 static int generic_NCR5380_device_reset(Scsi_Cmnd *);
-static int notyet_generic_proc_info (char *buffer ,char **start, off_t offset,
-                     int length, int hostno, int inout);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
 static int generic_NCR5380_biosparam(struct scsi_device *, struct block_device *, sector_t, int *);
-static int generic_NCR5380_proc_info(char* buffer, char** start, off_t offset, int length, int hostno, int inout);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
===== drivers/scsi/gdth.h 1.12 vs edited =====
--- 1.12/drivers/scsi/gdth.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/gdth.h	Mon May 12 14:26:12 2003
@@ -978,7 +978,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020501
 int gdth_bios_param(struct scsi_device *,struct block_device *,sector_t,int *);
-int gdth_proc_info(char *,char **,off_t,int,int,int);
+int gdth_proc_info(struct Scsi_Host *, char *,char **,off_t,int,int);
 int gdth_eh_abort(Scsi_Cmnd *scp);
 int gdth_eh_device_reset(Scsi_Cmnd *scp);
 int gdth_eh_bus_reset(Scsi_Cmnd *scp);
===== drivers/scsi/gdth_proc.c 1.13 vs edited =====
--- 1.13/drivers/scsi/gdth_proc.c	Fri Apr 18 00:01:39 2003
+++ edited/drivers/scsi/gdth_proc.c	Mon May 12 15:08:27 2003
@@ -6,31 +6,24 @@
 #include <linux/completion.h>
 #endif
 
-int gdth_proc_info(char *buffer,char **start,off_t offset,int length,   
-                   int hostno,int inout)
+int gdth_proc_info(struct Scsi_Host *host, char *buffer,char **start,off_t offset,int length,   
+                   int inout)
 {
-    int hanum,busnum,i;
+    int hanum,busnum;
 
     TRACE2(("gdth_proc_info() length %d ha %d offs %d inout %d\n",
             length,hostno,(int)offset,inout));
 
-    for (i=0; i<gdth_ctr_vcount; ++i) {
-        if (gdth_ctr_vtab[i]->host_no == hostno)
-            break;
-    }
-    if (i==gdth_ctr_vcount)
-        return(-EINVAL);
-
-    hanum = NUMDATA(gdth_ctr_vtab[i])->hanum;
-    busnum= NUMDATA(gdth_ctr_vtab[i])->busnum;
+    hanum = NUMDATA(host)->hanum;
+    busnum= NUMDATA(host)->busnum;
 
     if (inout)
-        return(gdth_set_info(buffer,length,i,hanum,busnum));
+        return(gdth_set_info(buffer,length,hanum,busnum));
     else
-        return(gdth_get_info(buffer,start,offset,length,i,hanum,busnum));
+        return(gdth_get_info(buffer,start,offset,length,hanum,busnum));
 }
 
-static int gdth_set_info(char *buffer,int length,int vh,int hanum,int busnum)
+static int gdth_set_info(char *buffer,int length,int hanum,int busnum)
 {
     int             ret_val = -EINVAL;
 #if LINUX_VERSION_CODE >= 0x020503
@@ -763,7 +756,7 @@
 #endif
 
 static int gdth_get_info(char *buffer,char **start,off_t offset,
-                         int length,int vh,int hanum,int busnum)
+                         int length,int hanum,int busnum)
 {
     int size = 0,len = 0;
     off_t begin = 0,pos = 0;
===== drivers/scsi/gdth_proc.h 1.4 vs edited =====
--- 1.4/drivers/scsi/gdth_proc.h	Fri Mar  7 00:10:14 2003
+++ edited/drivers/scsi/gdth_proc.h	Mon May 12 15:13:36 2003
@@ -5,9 +5,9 @@
  * $Id: gdth_proc.h,v 1.13 2003/02/27 14:59:25 achim Exp $
  */
 
-static int gdth_set_info(char *buffer,int length,int vh,int hanum,int busnum);
+static int gdth_set_info(char *buffer,int length,int hanum,int busnum);
 static int gdth_get_info(char *buffer,char **start,off_t offset,
-                         int length,int vh,int hanum,int busnum);
+                         int length,int hanum,int busnum);
 
 #if LINUX_VERSION_CODE >= 0x020503
 static void gdth_do_req(Scsi_Request *srp, gdth_cmd_str *cmd, 
===== drivers/scsi/hosts.h 1.63 vs edited =====
--- 1.63/drivers/scsi/hosts.h	Thu May  8 20:24:14 2003
+++ edited/drivers/scsi/hosts.h	Mon May 12 14:26:12 2003
@@ -68,7 +68,7 @@
      * outside the kernel ie. userspace and it also provides an interface
      * to feed the driver with information. Check eata_dma_proc.c for reference
      */
-    int (*proc_info)(char *, char **, off_t, int, int, int);
+    int (*proc_info)(struct Scsi_Host *, char *, char **, off_t, int, int);
 
     /*
      * The name pointer is a pointer to the name of the SCSI
@@ -569,9 +569,6 @@
  */
 extern int scsi_register_host(Scsi_Host_Template *);
 extern int scsi_unregister_host(Scsi_Host_Template *);
-
-extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
-extern void scsi_host_put(struct Scsi_Host *);
 
 /**
  * scsi_find_device - find a device given the host
===== drivers/scsi/ibmmca.c 1.18 vs edited =====
--- 1.18/drivers/scsi/ibmmca.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/ibmmca.c	Mon May 12 14:26:12 2003
@@ -2384,7 +2384,7 @@
 }
 
 /* routine to display info in the proc-fs-structure (a deluxe feature) */
-static int ibmmca_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout)
 {
 	int len = 0;
 	int i, id, lun, host_index;
@@ -2392,13 +2392,13 @@
 	unsigned long flags;
 	int max_pun;
 
-	for (i = 0; hosts[i] && hosts[i]->host_no != hostno; i++);
+	for (i = 0; hosts[i] && hosts[i] != shpnt; i++);
 	
 	spin_lock_irqsave(hosts[i]->host_lock, flags);	/* Check it */
-	shpnt = hosts[i];
 	host_index = i;
 	if (!shpnt) {
-		len += sprintf(buffer + len, "\nIBM MCA SCSI: Can't find adapter for host number %d\n", hostno);
+		len += sprintf(buffer + len, "\nIBM MCA SCSI: Can't find adapter for host number %d\n",
+				shpnt->host_no);
 		return len;
 	}
 	max_pun = subsystem_maxid(host_index);
@@ -2411,7 +2411,7 @@
 #else
 	len += sprintf(buffer + len, "               Multiple LUN probing.....: No\n");
 #endif
-	len += sprintf(buffer + len, "               This Hostnumber..........: %d\n", hostno);
+	len += sprintf(buffer + len, "               This Hostnumber..........: %d\n", shpnt->host_no);
 	len += sprintf(buffer + len, "               Base I/O-Port............: 0x%x\n", (unsigned int) (IM_CMD_REG(host_index)));
 	len += sprintf(buffer + len, "               (Shared) IRQ.............: %d\n", IM_IRQ);
 	len += sprintf(buffer + len, "               Total Interrupts.........: %d\n", IBM_DS(host_index).total_interrupts);
===== drivers/scsi/ibmmca.h 1.8 vs edited =====
--- 1.8/drivers/scsi/ibmmca.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/ibmmca.h	Mon May 12 14:26:12 2003
@@ -11,7 +11,6 @@
 /* Common forward declarations for all Linux-versions: */
 
 /* Interfaces to the midlevel Linux SCSI driver */
-static int ibmmca_proc_info (char *, char **, off_t, int, int, int);
 static int ibmmca_detect (Scsi_Host_Template *);
 static int ibmmca_release (struct Scsi_Host *);
 static int ibmmca_command (Scsi_Cmnd *);
===== drivers/scsi/imm.c 1.20 vs edited =====
--- 1.20/drivers/scsi/imm.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/imm.c	Mon May 12 14:26:12 2003
@@ -253,14 +253,14 @@
     return (-EINVAL);
 }
 
-int imm_proc_info(char *buffer, char **start, off_t offset,
+int imm_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
 		  int length, int hostno, int inout)
 {
     int i;
     int len = 0;
 
     for (i = 0; i < 4; i++)
-	if (imm_hosts[i].host == hostno)
+	if (imm_hosts[i].host == host->host_no)
 	    break;
 
     if (inout)
===== drivers/scsi/imm.h 1.8 vs edited =====
--- 1.8/drivers/scsi/imm.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/imm.h	Mon May 12 14:26:13 2003
@@ -159,7 +159,6 @@
 int imm_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 int imm_abort(Scsi_Cmnd *);
 int imm_reset(Scsi_Cmnd *);
-int imm_proc_info(char *, char **, off_t, int, int, int);
 int imm_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 
===== drivers/scsi/in2000.c 1.19 vs edited =====
--- 1.19/drivers/scsi/in2000.c	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/in2000.c	Mon May 12 14:26:13 2003
@@ -2155,7 +2155,7 @@
 }
 
 
-static int in2000_proc_info(char *buf, char **start, off_t off, int len, int hn, int in)
+static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off, int len, int in)
 {
 
 #ifdef PROC_INTERFACE
@@ -2163,17 +2163,11 @@
 	char *bp;
 	char tbuf[128];
 	unsigned long flags;
-	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hd;
 	Scsi_Cmnd *cmd;
 	int x, i;
 	static int stop = 0;
 
-	instance = scsi_host_hn_get(hn);
-	if (!instance) {
-		printk("*** Hmm... Can't find host #%d!\n", hn);
-		return (-ESRCH);
-	}
 	hd = (struct IN2000_hostdata *) instance->hostdata;
 
 /* If 'in' is TRUE we need to _read_ the proc file. We accept the following
===== drivers/scsi/in2000.h 1.10 vs edited =====
--- 1.10/drivers/scsi/in2000.h	Sun May  4 11:56:43 2003
+++ edited/drivers/scsi/in2000.h	Mon May 12 14:26:13 2003
@@ -401,7 +401,6 @@
 static int in2000_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int in2000_abort(Scsi_Cmnd *);
 static void in2000_setup(char *, int *) in2000__INIT;
-static int in2000_proc_info(char *, char **, off_t, int, int, int);
 static int in2000_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 static int in2000_host_reset(Scsi_Cmnd *);
===== drivers/scsi/ips.c 1.57 vs edited =====
--- 1.57/drivers/scsi/ips.c	Tue May  6 19:19:58 2003
+++ edited/drivers/scsi/ips.c	Mon May 12 14:26:13 2003
@@ -488,7 +488,7 @@
 static void ips_scmd_buf_write(Scsi_Cmnd *scmd, void *data, unsigned int count);
 static void ips_scmd_buf_read(Scsi_Cmnd *scmd, void *data, unsigned int count);
 
-int  ips_proc_info(char *, char **, off_t, int, int, int);
+int  ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 static int ips_host_info(ips_ha_t *, char *, off_t, int);
 static void copy_mem_info(IPS_INFOSTR *, char *, int);
 static int copy_info(IPS_INFOSTR *, char *, ...);
@@ -1496,8 +1496,8 @@
 /*                                                                          */
 /****************************************************************************/
 int
-ips_proc_info(char *buffer, char **start, off_t offset,
-              int length, int hostno, int func) {
+ips_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+              int length, int func) {
    int           i;
    int           ret;
    ips_ha_t     *ha = NULL;
@@ -1507,7 +1507,7 @@
    /* Find our host structure */
    for (i = 0; i < ips_next_controller; i++) {
       if (ips_sh[i]) {
-         if (ips_sh[i]->host_no == hostno) {
+         if (ips_sh[i] == host) {
             ha = (ips_ha_t *) ips_sh[i]->hostdata;
             break;
          }
===== drivers/scsi/mac_NCR5380.c 1.8 vs edited =====
--- 1.8/drivers/scsi/mac_NCR5380.c	Wed Feb 12 18:43:38 2003
+++ edited/drivers/scsi/mac_NCR5380.c	Mon May 12 14:26:13 2003
@@ -740,7 +740,7 @@
 	printk("NCR5380_print_status: no memory for print buffer\n");
 	return;
     }
-    len = NCR5380_proc_info(pr_bfr, &start, 0, PAGE_SIZE, HOSTNO, 0);
+    len = NCR5380_proc_info(instance, pr_bfr, &start, 0, PAGE_SIZE, 0);
     pr_bfr[len] = 0;
     printk("\n%s\n", pr_bfr);
     free_page((unsigned long) pr_bfr);
@@ -771,11 +771,10 @@
 #ifndef NCR5380_proc_info
 static
 #endif
-int NCR5380_proc_info (char *buffer, char **start, off_t offset,
-		       int length, int hostno, int inout)
+int NCR5380_proc_info (struct Scsi_Host *instance, char *buffer, char **start, off_t offset,
+		       int length, int inout)
 {
     char *pos = buffer;
-    struct Scsi_Host *instance;
     struct NCR5380_hostdata *hostdata;
     Scsi_Cmnd *ptr;
     unsigned long flags;
@@ -787,13 +786,6 @@
 	    pos = buffer;			\
 	}					\
     } while (0)
-
-    for (instance = first_instance; instance && HOSTNO != hostno;
-	 instance = instance->next)
-	;
-    if (!instance)
-	return(-ESRCH);
-    hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
     if (inout) { /* Has data been written to the file ? */
 	return(-ENOSYS);  /* Currently this is a no-op */
===== drivers/scsi/mac_scsi.h 1.4 vs edited =====
--- 1.4/drivers/scsi/mac_scsi.h	Fri Dec 20 15:37:31 2002
+++ edited/drivers/scsi/mac_scsi.h	Mon May 12 14:26:13 2003
@@ -32,9 +32,6 @@
 #define MACSCSI_PUBLIC_RELEASE 2
 
 #ifndef ASM
-int macscsi_proc_info (char *buffer, char **start, off_t offset,
-			int length, int hostno, int inout);
-
 #ifndef NULL
 #define NULL 0
 #endif
===== drivers/scsi/megaraid.c 1.44 vs edited =====
--- 1.44/drivers/scsi/megaraid.c	Sun May  4 11:56:44 2003
+++ edited/drivers/scsi/megaraid.c	Mon May 12 14:26:13 2003
@@ -2392,21 +2392,6 @@
 		enquiry3->pdrv_state[i] = inquiry->pdrv_info.pdrv_state[i];
 }
 
-
-/*
- * megaraid_proc_info()
- *
- * Returns data to be displayed in /proc/scsi/megaraid/X
- */
-static int
-megaraid_proc_info(char *buffer, char **start, off_t offset, int length,
-		int host_no, int inout)
-{
-	*start = buffer;
-	return 0;
-}
-
-
 /*
  * Release the controller's resources
  */
@@ -5379,7 +5364,6 @@
 
 static Scsi_Host_Template driver_template = {
 	.name =				"MegaRAID",
-	.proc_info =			megaraid_proc_info,
 	.detect =			megaraid_detect,
 	.release =			megaraid_release,
 	.info =				megaraid_info,
===== drivers/scsi/megaraid.h 1.18 vs edited =====
--- 1.18/drivers/scsi/megaraid.h	Sun May  4 11:56:44 2003
+++ edited/drivers/scsi/megaraid.h	Mon May 12 14:26:13 2003
@@ -1007,7 +1007,6 @@
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
-static int megaraid_proc_info (char *, char **, off_t, int, int, int);
 static int mega_print_inquiry(char *, char *);
 
 static int mega_build_sglist (adapter_t *adapter, scb_t *scb,
===== drivers/scsi/ncr53c8xx.c 1.27 vs edited =====
--- 1.27/drivers/scsi/ncr53c8xx.c	Tue May  6 21:54:34 2003
+++ edited/drivers/scsi/ncr53c8xx.c	Mon May 12 14:26:14 2003
@@ -399,8 +399,8 @@
 
 static irqreturn_t ncr53c8xx_intr(int irq, void *dev_id, struct pt_regs * regs);
 static void ncr53c8xx_timeout(unsigned long np);
-static int ncr53c8xx_proc_info(char *buffer, char **start, off_t offset,
-			int length, int hostno, int func);
+static int ncr53c8xx_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			int length, int func);
 
 #define initverbose (driver_setup.verbose)
 #define bootverbose (np->verbose)
@@ -9249,21 +9249,17 @@
 **	- func = 1 means write (parse user control command)
 */
 
-static int ncr53c8xx_proc_info(char *buffer, char **start, off_t offset,
-			int length, int hostno, int func)
+static int ncr53c8xx_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			int length, int func)
 {
-	struct Scsi_Host *host;
 	struct host_data *host_data;
 	ncb_p ncb = 0;
 	int retv;
 
 #ifdef DEBUG_PROC_INFO
-printk("ncr53c8xx_proc_info: hostno=%d, func=%d\n", hostno, func);
+printk("ncr53c8xx_proc_info: hostno=%d, func=%d\n", host->host_no, func);
 #endif
 
-	if((host = scsi_host_hn_get(hostno))==NULL)
-		return -EINVAL;
-		
 	host_data = (struct host_data *) host->hostdata;
 	ncb = host_data->ncb;
 
===== drivers/scsi/nsp32.c 1.11 vs edited =====
--- 1.11/drivers/scsi/nsp32.c	Thu May  8 20:24:14 2003
+++ edited/drivers/scsi/nsp32.c	Mon May 12 14:26:14 2003
@@ -286,7 +286,7 @@
 static int nsp32_eh_host_reset(Scsi_Cmnd *);
 static int nsp32_reset(Scsi_Cmnd *, unsigned int);
 static int nsp32_release(struct Scsi_Host *);
-static int nsp32_proc_info(char *, char **, off_t, int, int, int);
+static int nsp32_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 static int __devinit nsp32_probe(struct pci_dev *, const struct pci_device_id *);
 static void __devexit nsp32_remove(struct pci_dev *);
 static int __init init_nsp32(void);
@@ -1555,18 +1555,16 @@
 #undef SPRINTF
 #define SPRINTF(args...) \
         do { if(pos < buffer + length) pos += sprintf(pos, ## args); } while(0)
-static int nsp32_proc_info(char  *buffer,
+static int nsp32_proc_info(struct Scsi_Host *host, char  *buffer,
 			   char **start,
 			   off_t  offset,
 			   int    length,
-			   int    hostno,
 			   int    inout)
 {
 	char *pos = buffer;
 	int thislength;
 	unsigned long flags;
 	nsp32_hw_data *data;
-	struct Scsi_Host *host = NULL;
 	unsigned int base;
 	unsigned char mode_reg;
 
@@ -1575,19 +1573,12 @@
 		return -EINVAL;
 	}
 
-	/* search this HBA host */
-	
-	host = scsi_host_hn_get(hostno);
-	
-	if (host == NULL) {
-		return -ESRCH;
-	}
 	data = (nsp32_hw_data *)host->hostdata;
 	base = host->io_port;
 
 	SPRINTF("NinjaSCSI-32 status\n\n");
 	SPRINTF("Driver version:        %s\n",		nsp32_release_version);
-	SPRINTF("SCSI host No.:         %d\n",		hostno);
+	SPRINTF("SCSI host No.:         %d\n",		host->host_no);
 	SPRINTF("IRQ:                   %d\n",		host->irq);
 	SPRINTF("IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
 	SPRINTF("MMIO(virtual address): 0x%lx\n",	host->base);
===== drivers/scsi/pas16.h 1.7 vs edited =====
--- 1.7/drivers/scsi/pas16.h	Sun May  4 11:56:44 2003
+++ edited/drivers/scsi/pas16.h	Mon May 12 14:26:14 2003
@@ -122,8 +122,6 @@
 static int pas16_bus_reset(Scsi_Cmnd *);
 static int pas16_host_reset(Scsi_Cmnd *);
 static int pas16_device_reset(Scsi_Cmnd *);
-static int pas16_proc_info (char *buffer ,char **start, off_t offset,
-		     int length, int hostno, int inout);
 
 #ifndef NULL
 #define NULL 0
===== drivers/scsi/ppa.c 1.21 vs edited =====
--- 1.21/drivers/scsi/ppa.c	Sun May  4 11:56:44 2003
+++ edited/drivers/scsi/ppa.c	Mon May 12 14:26:14 2003
@@ -270,14 +270,14 @@
     return (-EINVAL);
 }
 
-int ppa_proc_info(char *buffer, char **start, off_t offset,
-		  int length, int hostno, int inout)
+int ppa_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+		  int length, int inout)
 {
     int i;
     int len = 0;
 
     for (i = 0; i < 4; i++)
-	if (ppa_hosts[i].host == hostno)
+	if (ppa_hosts[i] == host)
 	    break;
 
     if (inout)
===== drivers/scsi/ppa.h 1.8 vs edited =====
--- 1.8/drivers/scsi/ppa.h	Sun May  4 11:56:44 2003
+++ edited/drivers/scsi/ppa.h	Mon May 12 14:26:14 2003
@@ -167,7 +167,7 @@
 int ppa_queuecommand(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
 int ppa_abort(Scsi_Cmnd *);
 int ppa_reset(Scsi_Cmnd *);
-int ppa_proc_info(char *, char **, off_t, int, int, int);
+int ppa_proc_info(struct Scsi_Host *host, char *, char **, off_t, int, int);
 int ppa_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 
===== drivers/scsi/qla1280.c 1.33 vs edited =====
--- 1.33/drivers/scsi/qla1280.c	Sun May  4 11:56:45 2003
+++ edited/drivers/scsi/qla1280.c	Mon May 12 14:26:14 2003
@@ -623,11 +623,10 @@
 #define	PROC_BUF	&qla1280_buffer[len]
 
 int
-qla1280_proc_info(char *buffer, char **start, off_t offset, int length,
-		  int hostno, int inout)
+qla1280_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,
+		  int inout)
 {
 #if QLA1280_PROFILE
-	struct Scsi_Host *host;
 	struct scsi_qla_host *ha;
 	int size = 0;
 	scsi_lu_t *up;
@@ -637,21 +636,8 @@
 	host = NULL;
 
 	/* Find the host that was specified */
-	for (ha = qla1280_hostlist; (ha != NULL) && ha->host->host_no != hostno;
+	for (ha = qla1280_hostlist; (ha != NULL) && ha->host != host;
 	     ha = ha->next) ;
-
-	/* if host wasn't found then exit */
-	if (!ha) {
-		size =  sprintf(buffer, "Can't find adapter for host "
-				"number %d\n", hostno);
-		if (size > length) {
-			return size;
-		} else {
-			return 0;
-		}
-	}
-
-	host = ha->host;
 
 	if (inout == TRUE) {	/* Has data been written to the file? */
 		printk(KERN_INFO
===== drivers/scsi/qla1280.h 1.15 vs edited =====
--- 1.15/drivers/scsi/qla1280.h	Sun May  4 11:56:45 2003
+++ edited/drivers/scsi/qla1280.h	Mon May 12 14:26:14 2003
@@ -1306,7 +1306,6 @@
 /*
  *  Linux - SCSI Driver Interface Function Prototypes.
  */
-int qla1280_proc_info(char *, char **, off_t, int, int, int);
 const char *qla1280_info(struct Scsi_Host *host);
 int qla1280_detect(Scsi_Host_Template *);
 int qla1280_release(struct Scsi_Host *);
===== drivers/scsi/scsi_debug.c 1.37 vs edited =====
--- 1.37/drivers/scsi/scsi_debug.c	Fri May  9 00:46:47 2003
+++ edited/drivers/scsi/scsi_debug.c	Mon May 12 14:26:14 2003
@@ -1259,8 +1259,8 @@
 /* scsi_debug_proc_info
  * Used if the driver currently has no own support for /proc/scsi
  */
-static int scsi_debug_proc_info(char *buffer, char **start, off_t offset,
-				int length, int inode, int inout)
+static int scsi_debug_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+				int length, int inout)
 {
 	int len, pos, begin;
 	int orig_length;
===== drivers/scsi/scsi_debug.h 1.15 vs edited =====
--- 1.15/drivers/scsi/scsi_debug.h	Fri May  9 00:46:47 2003
+++ edited/drivers/scsi/scsi_debug.h	Mon May 12 14:26:14 2003
@@ -14,7 +14,7 @@
 static int scsi_debug_bus_reset(struct scsi_cmnd *);
 static int scsi_debug_device_reset(struct scsi_cmnd *);
 static int scsi_debug_host_reset(struct scsi_cmnd *);
-static int scsi_debug_proc_info(char *, char **, off_t, int, int, int);
+static int scsi_debug_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 static const char * scsi_debug_info(struct Scsi_Host *);
 
 /*
===== drivers/scsi/scsi_priv.h 1.5 vs edited =====
--- 1.5/drivers/scsi/scsi_priv.h	Thu May  8 21:14:53 2003
+++ edited/drivers/scsi/scsi_priv.h	Mon May 12 14:26:15 2003
@@ -59,6 +59,8 @@
 extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
 extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
 extern struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *);
+extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
+extern void scsi_host_put(struct Scsi_Host *);
 extern void scsi_host_init(void);
 
 /* scsi.c */
===== drivers/scsi/scsi_proc.c 1.22 vs edited =====
--- 1.22/drivers/scsi/scsi_proc.c	Thu May  8 20:24:15 2003
+++ edited/drivers/scsi/scsi_proc.c	Mon May 12 14:26:15 2003
@@ -79,8 +79,8 @@
 		n = generic_proc_info(buffer, start, offset, length,
 				      shost->hostt->info, shost);
 	else
-		n = (shost->hostt->proc_info(buffer, start, offset,
-					   length, shost->host_no, 0));
+		n = shost->hostt->proc_info(shost, buffer, start, offset,
+					   length, 0);
 
 	*eof = (n < length);
 	return n;
@@ -104,8 +104,7 @@
 		ret = -EFAULT;
 		if (copy_from_user(page, buf, count))
 			goto out;
-		ret = shost->hostt->proc_info(page, &start, 0, count,
-					      shost->host_no, 1);
+		ret = shost->hostt->proc_info(shost, page, &start, 0, count, 1);
 	}
 out:
 	free_page((unsigned long)page);
===== drivers/scsi/scsi_syms.c 1.36 vs edited =====
--- 1.36/drivers/scsi/scsi_syms.c	Thu May  8 20:24:15 2003
+++ edited/drivers/scsi/scsi_syms.c	Mon May 12 14:26:15 2003
@@ -89,11 +89,6 @@
  */
 EXPORT_SYMBOL(scsi_reset_provider);
 
-/*
- * These are here only while I debug the rest of the scsi stuff.
- */
-EXPORT_SYMBOL(scsi_host_hn_get);
-EXPORT_SYMBOL(scsi_host_put);
 EXPORT_SYMBOL(scsi_device_types);
 
 /*
===== drivers/scsi/sun3_NCR5380.c 1.15 vs edited =====
--- 1.15/drivers/scsi/sun3_NCR5380.c	Tue Oct  8 00:21:40 2002
+++ edited/drivers/scsi/sun3_NCR5380.c	Mon May 12 14:26:15 2003
@@ -726,7 +726,7 @@
 	printk("NCR5380_print_status: no memory for print buffer\n");
 	return;
     }
-    len = NCR5380_proc_info(pr_bfr, &start, 0, PAGE_SIZE, HOSTNO, 0);
+    len = NCR5380_proc_info(instance, pr_bfr, &start, 0, PAGE_SIZE, 0);
     pr_bfr[len] = 0;
     printk("\n%s\n", pr_bfr);
     free_page((unsigned long) pr_bfr);
@@ -754,11 +754,10 @@
 static
 char *lprint_Scsi_Cmnd (Scsi_Cmnd *cmd, char *pos, char *buffer, int length);
 
-static int NCR5380_proc_info (char *buffer, char **start, off_t offset,
-			      int length, int hostno, int inout)
+static int NCR5380_proc_info (struct Scsi_Host *instance, char *buffer, char **start, off_t offset,
+			      int length, int inout)
 {
     char *pos = buffer;
-    struct Scsi_Host *instance;
     struct NCR5380_hostdata *hostdata;
     Scsi_Cmnd *ptr;
     unsigned long flags;
@@ -771,9 +770,6 @@
 	}					\
     } while (0)
 
-    instance = scsi_host_hn_get(hostno);
-    if (!instance)
-	return(-ESRCH);
     hostdata = (struct NCR5380_hostdata *)instance->hostdata;
 
     if (inout) { /* Has data been written to the file ? */
===== drivers/scsi/sun3_scsi.h 1.6 vs edited =====
--- 1.6/drivers/scsi/sun3_scsi.h	Fri Feb  7 23:02:17 2003
+++ edited/drivers/scsi/sun3_scsi.h	Mon May 12 14:26:15 2003
@@ -57,8 +57,6 @@
 static const char *sun3scsi_info (struct Scsi_Host *);
 static int sun3scsi_bus_reset(Scsi_Cmnd *);
 static int sun3scsi_queue_command (Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int sun3scsi_proc_info (char *buffer, char **start, off_t offset,
-			int length, int hostno, int inout);
 #ifdef MODULE
 static int sun3scsi_release (struct Scsi_Host *);
 #else
===== drivers/scsi/sym53c8xx.c 1.34 vs edited =====
--- 1.34/drivers/scsi/sym53c8xx.c	Sun May  4 11:56:46 2003
+++ edited/drivers/scsi/sym53c8xx.c	Mon May 12 14:26:15 2003
@@ -1288,8 +1288,8 @@
 };
 #endif
 #ifdef SCSI_NCR_PROC_INFO_SUPPORT
-static int sym53c8xx_proc_info(char *buffer, char **start, off_t offset,
-			int length, int hostno, int func);
+static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			int length, int func);
 #endif
 
 /*
@@ -14226,22 +14226,17 @@
 **	- func = 1 means write (parse user control command)
 */
 
-static int sym53c8xx_proc_info(char *buffer, char **start, off_t offset,
-			int length, int hostno, int func)
+static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			int length, int func)
 {
-	struct Scsi_Host *host;
 	struct host_data *host_data;
 	ncb_p ncb = 0;
 	int retv;
 
 #ifdef DEBUG_PROC_INFO
-printk("sym53c8xx_proc_info: hostno=%d, func=%d\n", hostno, func);
+printk("sym53c8xx_proc_info: hostno=%d, func=%d\n", host->host_no, func);
 #endif
 
-	host = scsi_host_hn_get(hostno);
-	if (!host)
-		return -EINVAL;
-
 	host_data = (struct host_data *) host->hostdata;
 	ncb = host_data->ncb;
 	retv = -EINVAL;
@@ -14261,7 +14256,6 @@
 	}
 
 out:
-	scsi_host_put(host);
 	return retv;
 }
 
===== drivers/scsi/t128.h 1.7 vs edited =====
--- 1.7/drivers/scsi/t128.h	Sun May  4 11:56:46 2003
+++ edited/drivers/scsi/t128.h	Mon May 12 14:26:16 2003
@@ -99,8 +99,6 @@
 static int t128_host_reset(Scsi_Cmnd *);
 static int t128_bus_reset(Scsi_Cmnd *);
 static int t128_device_reset(Scsi_Cmnd *);
-static int t128_proc_info (char *buffer, char **start, off_t offset,
-		   int length, int hostno, int inout);
 
 #ifndef NULL
 #define NULL 0
===== drivers/scsi/tmscsim.c 1.19 vs edited =====
--- 1.19/drivers/scsi/tmscsim.c	Sun May  4 11:56:46 2003
+++ edited/drivers/scsi/tmscsim.c	Mon May 12 14:26:16 2003
@@ -2855,12 +2855,11 @@
  else SPRINTF(" No  ")
 
 
-int DC390_proc_info (char *buffer, char **start,
-		     off_t offset, int length, int hostno, int inout)
+int DC390_proc_info (struct Scsi_Host *shpnt, char *buffer, char **start,
+		     off_t offset, int length, int inout)
 {
   int dev, spd, spd1;
   char *pos = buffer;
-  PSH shpnt = 0;
   PACB pACB;
   PDCB pDCB;
   PSCSICMD pcmd;
@@ -2870,13 +2869,12 @@
 
   while(pACB != (PACB)-1)
      {
-	shpnt = pACB->pScsiHost;
-	if (shpnt->host_no == hostno) break;
+	if (shpnt == pACB->pScsiHost)
+		break;
 	pACB = pACB->pNextACB;
      }
 
   if (pACB == (PACB)-1) return(-ESRCH);
-  if(!shpnt) return(-ESRCH);
 
   if(inout) /* Has data been written to the file ? */
       return dc390_set_info(buffer, length, pACB);
===== drivers/scsi/wd33c93.c 1.13 vs edited =====
--- 1.13/drivers/scsi/wd33c93.c	Sun Mar 23 03:30:53 2003
+++ edited/drivers/scsi/wd33c93.c	Mon May 12 14:26:16 2003
@@ -1913,7 +1913,7 @@
 }
 
 int
-wd33c93_proc_info(char *buf, char **start, off_t off, int len, int hn, int in)
+wd33c93_proc_info(struct Scsi_Host *instance, char *buf, char **start, off_t off, int len, int in)
 {
 
 #ifdef PROC_INTERFACE
@@ -1921,16 +1921,10 @@
 	char *bp;
 	char tbuf[128];
 	struct Scsi_Host *instance;
-	struct WD33C93_hostdata *hd;
 	Scsi_Cmnd *cmd;
 	int x, i;
 	static int stop = 0;
 
-	instance = scsi_host_hn_get(hn);
-	if (!instance) {
-		printk("*** Hmm... Can't find host #%d!\n", hn);
-		return (-ESRCH);
-	}
 	hd = (struct WD33C93_hostdata *) instance->hostdata;
 
 /* If 'in' is TRUE we need to _read_ the proc file. We accept the following
===== drivers/scsi/wd33c93.h 1.5 vs edited =====
--- 1.5/drivers/scsi/wd33c93.h	Thu Mar 13 06:38:15 2003
+++ edited/drivers/scsi/wd33c93.h	Mon May 12 14:26:16 2003
@@ -338,7 +338,7 @@
 int wd33c93_abort (Scsi_Cmnd *cmd);
 int wd33c93_queuecommand (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *));
 void wd33c93_intr (struct Scsi_Host *instance);
-int wd33c93_proc_info(char *, char **, off_t, int, int, int);
+int wd33c93_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 int wd33c93_host_reset (Scsi_Cmnd *);
 void wd33c93_release(void);
 
===== drivers/scsi/wd7000.c 1.24 vs edited =====
--- 1.24/drivers/scsi/wd7000.c	Thu May  8 20:24:15 2003
+++ edited/drivers/scsi/wd7000.c	Mon May 12 15:12:55 2003
@@ -1372,45 +1372,24 @@
 }
 
 
-static int wd7000_proc_info(char *buffer, char **start, off_t offset, int length, int hostno, int inout)
+static int wd7000_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,  int inout)
 {
-	struct Scsi_Host *host = NULL;
-	Adapter *adapter;
+	Adapter *adapter = (Adapter *)host->hostdata;
 	unsigned long flags;
 	char *pos = buffer;
-	short i;
-
 #ifdef WD7000_DEBUG
 	Mailbox *ogmbs, *icmbs;
 	short count;
 #endif
 
 	/*
-	 * Find the specified host board.
-	 */
-	for (i = 0; i < UNITS; i++)
-		if (wd7000_host[i] && (wd7000_host[i]->host_no == hostno)) {
-			host = wd7000_host[i];
-
-			break;
-		}
-
-	/*
-	 * Host not found!
-	 */
-	if (!host)
-		return (-ESRCH);
-
-	/*
 	 * Has data been written to the file ?
 	 */
 	if (inout)
 		return (wd7000_set_info(buffer, length, host));
 
-	adapter = (Adapter *) host->hostdata;
-
 	spin_lock_irqsave(host->host_lock, flags);
-	SPRINTF("Host scsi%d: Western Digital WD-7000 (rev %d.%d)\n", hostno, adapter->rev1, adapter->rev2);
+	SPRINTF("Host scsi%d: Western Digital WD-7000 (rev %d.%d)\n", host->host_no, adapter->rev1, adapter->rev2);
 	SPRINTF("  IO base:      0x%x\n", adapter->iobase);
 	SPRINTF("  IRQ:          %d\n", adapter->irq);
 	SPRINTF("  DMA channel:  %d\n", adapter->dma);
===== drivers/scsi/aacraid/linit.c 1.18 vs edited =====
--- 1.18/drivers/scsi/aacraid/linit.c	Thu May  8 20:24:16 2003
+++ edited/drivers/scsi/aacraid/linit.c	Mon May 12 15:14:20 2003
@@ -137,7 +137,6 @@
 static int aac_queuecommand(Scsi_Cmnd *, void (*CompletionRoutine)(Scsi_Cmnd *));
 static int aac_biosparm(struct scsi_device *, struct block_device *,
 			sector_t, int *);
-static int aac_procinfo(char *, char **, off_t, int, int, int);
 static int aac_ioctl(Scsi_Device *, int, void *);
 static int aac_eh_abort(Scsi_Cmnd * cmd);
 static int aac_eh_device_reset(Scsi_Cmnd* cmd);
@@ -616,7 +615,6 @@
 static Scsi_Host_Template driver_template = {
 	.module				= THIS_MODULE,
 	.name           		= "AAC",
-	.proc_info      		= aac_procinfo,
 	.detect         		= aac_detect,
 	.release        		= aac_release,
 	.info           		= aac_driverinfo,
@@ -682,35 +680,3 @@
 
 
 #include "scsi_module.c"
-
-/**
- *	aac_procinfo	-	Implement /proc/scsi/<drivername>/<n>
- *	@proc_buffer: memory buffer for I/O
- *	@start_ptr: pointer to first valid data
- *	@offset: offset into file
- *	@bytes_available: space left
- *	@host_no: scsi host ident
- *	@write: direction of I/O
- *
- *	Used to export driver statistics and other infos to the world outside 
- *	the kernel using the proc file system. Also provides an interface to
- *	feed the driver with information.
- *
- *		For reads
- *			- if offset > 0 return 0
- *			- if offset == 0 write data to proc_buffer and set the start_ptr to
- *			beginning of proc_buffer, return the number of characters written.
- *		For writes
- *			- writes currently not supported, return 0
- *
- *	Bugs:	Only offset zero is handled
- */
-
-static int aac_procinfo(char *proc_buffer, char **start_ptr,off_t offset,
-			int bytes_available, int host_no, int write)
-{
-	if(write || offset > 0)
-		return 0;
-	*start_ptr = proc_buffer;
-	return sprintf(proc_buffer, "%s  %d\n", "Raid Controller, scsi hba number", host_no);
-}
===== drivers/scsi/aic7xxx/aic79xx_osm.h 1.28 vs edited =====
--- 1.28/drivers/scsi/aic7xxx/aic79xx_osm.h	Thu May  1 19:00:20 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_osm.h	Mon May 12 15:14:36 2003
@@ -1006,7 +1006,7 @@
 	(((dev_softc)->dma_mask = mask) && 0)
 #endif
 /**************************** Proc FS Support *********************************/
-int	ahd_linux_proc_info(char *, char **, off_t, int, int, int);
+int	ahd_linux_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 
 /*************************** Domain Validation ********************************/
 #define AHD_DV_CMD(cmd) ((cmd)->scsi_done == ahd_linux_dv_complete)
===== drivers/scsi/aic7xxx/aic79xx_proc.c 1.9 vs edited =====
--- 1.9/drivers/scsi/aic7xxx/aic79xx_proc.c	Thu Apr 24 23:10:07 2003
+++ edited/drivers/scsi/aic7xxx/aic79xx_proc.c	Mon May 12 15:30:19 2003
@@ -278,8 +278,8 @@
  * Return information to handle /proc support for the driver.
  */
 int
-ahd_linux_proc_info(char *buffer, char **start, off_t offset,
-		  int length, int hostno, int inout)
+ahd_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset,
+		  int length, int inout)
 {
 	struct	ahd_softc *ahd;
 	struct	info_str info;
@@ -292,7 +292,7 @@
 	retval = -EINVAL;
 	ahd_list_lock(&l);
 	TAILQ_FOREACH(ahd, &ahd_tailq, links) {
-		if (ahd->platform_data->host->host_no == hostno)
+		if (ahd->platform_data->host == shost)
 			break;
 	}
 
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.43 vs edited =====
--- 1.43/drivers/scsi/aic7xxx/aic7xxx_osm.h	Tue May  6 20:27:53 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	Mon May 12 15:29:00 2003
@@ -963,7 +963,7 @@
 	(((dev_softc)->dma_mask = mask) && 0)
 #endif
 /**************************** Proc FS Support *********************************/
-int	ahc_linux_proc_info(char *, char **, off_t, int, int, int);
+int	ahc_linux_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 
 /*************************** Domain Validation ********************************/
 #define AHC_DV_CMD(cmd) ((cmd)->scsi_done == ahc_linux_dv_complete)
===== drivers/scsi/aic7xxx/aic7xxx_proc.c 1.10 vs edited =====
--- 1.10/drivers/scsi/aic7xxx/aic7xxx_proc.c	Thu Apr 24 23:10:07 2003
+++ edited/drivers/scsi/aic7xxx/aic7xxx_proc.c	Mon May 12 15:30:15 2003
@@ -289,8 +289,8 @@
  * Return information to handle /proc support for the driver.
  */
 int
-ahc_linux_proc_info(char *buffer, char **start, off_t offset,
-		  int length, int hostno, int inout)
+ahc_linux_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset,
+		  int length, int inout)
 {
 	struct	ahc_softc *ahc;
 	struct	info_str info;
@@ -303,7 +303,7 @@
 	retval = -EINVAL;
 	ahc_list_lock(&s);
 	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-		if (ahc->platform_data->host->host_no == hostno)
+		if (ahc->platform_data->host == shost)
 			break;
 	}
 
===== drivers/scsi/aic7xxx_old/aic7xxx_proc.c 1.8 vs edited =====
--- 1.8/drivers/scsi/aic7xxx_old/aic7xxx_proc.c	Tue Feb  4 20:14:05 2003
+++ edited/drivers/scsi/aic7xxx_old/aic7xxx_proc.c	Mon May 12 14:40:10 2003
@@ -80,10 +80,9 @@
  *   Return information to handle /proc support for the driver.
  *-F*************************************************************************/
 int
-aic7xxx_proc_info ( char *buffer, char **start, off_t offset, int length, 
-                    int hostno, int inout)
+aic7xxx_proc_info ( struct Scsi_Host *HBAptr, char *buffer, char **start, off_t offset, int length, 
+                    int inout)
 {
-  struct Scsi_Host *HBAptr;
   struct aic7xxx_host *p;
   struct aic_dev_data *aic_dev;
   struct scsi_device *sdptr;
@@ -93,12 +92,12 @@
 
   HBAptr = NULL;
 
-  for(p=first_aic7xxx; p->host->host_no != hostno; p=p->next)
+  for(p=first_aic7xxx; p->host != HBAptr; p=p->next)
     ;
 
   if (!p)
   {
-    size += sprintf(buffer, "Can't find adapter for host number %d\n", hostno);
+    size += sprintf(buffer, "Can't find adapter for host number %d\n", HBAptr->host_no);
     if (size > length)
     {
       return (size);
@@ -108,8 +107,6 @@
       return (length);
     }
   }
-
-  HBAptr = p->host;
 
   if (inout == TRUE) /* Has data been written to the file? */ 
   {
===== drivers/scsi/pcmcia/nsp_cs.c 1.21 vs edited =====
--- 1.21/drivers/scsi/pcmcia/nsp_cs.c	Thu May  1 18:44:53 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.c	Mon May 12 15:14:55 2003
@@ -1291,11 +1291,10 @@
 #undef SPRINTF
 #define SPRINTF(args...) \
         do { if(pos < buffer + length) pos += sprintf(pos, ## args); } while(0)
-static int nsp_proc_info(char  *buffer,
+static int nsp_proc_info(struct Scsi_Host *host, char  *buffer,
 			 char **start,
 			 off_t  offset,
 			 int    length,
-			 int    hostno,
 			 int    inout)
 {
 	int id;
@@ -1304,29 +1303,14 @@
 	int speed;
 	unsigned long flags;
 	nsp_hw_data *data = &nsp_data;
-	struct Scsi_Host *host = NULL;
 
 	if (inout) {
 		return -EINVAL;
 	}
 
-	/* search this HBA host */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,45))
-	host = scsi_host_hn_get(hostno);
-#else
-	for (host=scsi_hostlist; host; host=host->next) {
-                if (host->host_no == hostno) {
-                        break;
-                }
-        }
-#endif
-	if (host == NULL) {
-		return -ESRCH;
-	}
-
 	SPRINTF("NinjaSCSI status\n\n");
 	SPRINTF("Driver version:        $Revision: 1.5 $\n");
-	SPRINTF("SCSI host No.:         %d\n",          hostno);
+	SPRINTF("SCSI host No.:         %d\n",          host->host_no);
 	SPRINTF("IRQ:                   %d\n",          host->irq);
 	SPRINTF("IO:                    0x%lx-0x%lx\n", host->io_port, host->io_port + host->n_io_port - 1);
 	SPRINTF("MMIO(virtual address): 0x%lx\n",       host->base);
===== drivers/scsi/pcmcia/nsp_cs.h 1.9 vs edited =====
--- 1.9/drivers/scsi/pcmcia/nsp_cs.h	Mon Mar  3 08:32:33 2003
+++ edited/drivers/scsi/pcmcia/nsp_cs.h	Mon May 12 14:26:17 2003
@@ -281,8 +281,8 @@
 static void nsp_start_timer(Scsi_Cmnd *SCpnt, nsp_hw_data *data, int time);
 
 static const char *nsp_info(struct Scsi_Host *shpnt);
-static int nsp_proc_info(char *buffer, char **start, off_t offset,
-			 int length, int hostno, int inout);
+static int nsp_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			 int length, int inout);
 static int nsp_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
 
 /*static int nsp_eh_abort(Scsi_Cmnd * SCpnt);*/
===== drivers/scsi/sym53c8xx_2/sym_glue.c 1.20 vs edited =====
--- 1.20/drivers/scsi/sym53c8xx_2/sym_glue.c	Sun May  4 11:56:46 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon May 12 14:26:17 2003
@@ -1787,18 +1787,13 @@
  *  - func = 0 means read  (returns adapter infos)
  *  - func = 1 means write (not yet merget from sym53c8xx)
  */
-static int sym53c8xx_proc_info(char *buffer, char **start, off_t offset,
-			int length, int hostno, int func)
+static int sym53c8xx_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
+			int length, int func)
 {
-	struct Scsi_Host *host;
 	struct host_data *host_data;
 	hcb_p np = 0;
 	int retv;
 
-	host = scsi_host_hn_get(hostno);
-	if (!host)
-		return -EINVAL;
-
 	host_data = (struct host_data *) host->hostdata;
 	np = host_data->ncb;
 	if (!np)
@@ -1821,7 +1816,6 @@
 #endif
 	}
 
-	scsi_host_put(host);
 	return retv;
 }
 #endif /* SYM_LINUX_PROC_INFO_SUPPORT */
===== drivers/usb/storage/scsiglue.c 1.42 vs edited =====
--- 1.42/drivers/usb/storage/scsiglue.c	Sun Apr  6 13:58:42 2003
+++ edited/drivers/usb/storage/scsiglue.c	Mon May 12 15:21:06 2003
@@ -264,33 +264,21 @@
 #define SPRINTF(args...) \
 	do { if (pos < buffer+length) pos += sprintf(pos, ## args); } while (0)
 
-static int usb_storage_proc_info (char *buffer, char **start, off_t offset,
-		int length, int hostno, int inout)
+static int usb_storage_proc_info (struct Scsi_Host *hostptr, char *buffer, char **start, off_t offset,
+		int length, int inout)
 {
 	struct us_data *us;
 	char *pos = buffer;
-	struct Scsi_Host *hostptr;
 	unsigned long f;
 
 	/* if someone is sending us data, just throw it away */
 	if (inout)
 		return length;
 
-	/* find our data from the given hostno */
-	hostptr = scsi_host_hn_get(hostno);
-	if (!hostptr) {	 /* if we couldn't find it, we return an error */
-		return -ESRCH;
-	}
 	us = (struct us_data*)hostptr->hostdata[0];
 
-	/* if we couldn't find it, we return an error */
-	if (!us) {
-		scsi_host_put(hostptr);
-		return -ESRCH;
-	}
-
 	/* print the controller name */
-	SPRINTF("   Host scsi%d: usb-storage\n", hostno);
+	SPRINTF("   Host scsi%d: usb-storage\n", hostptr->host_no);
 
 	/* print product, vendor, and serial number strings */
 	SPRINTF("       Vendor: %s\n", us->vendor);
@@ -318,9 +306,6 @@
 
 		*(pos++) = '\n';
 		}
-
-	/* release the reference count on this host */
-	scsi_host_put(hostptr);
 
 	/*
 	 * Calculate start of next buffer, and return value.

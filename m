From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move scsi debugging helpers and give them sane names
Date: Wed, 19 May 2004 22:35:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519203559.GC10507@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:10652 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264542AbUESUgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 16:36:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - give the constants.c prettyprinting helpers proper scsi_ prefixed
   names (and keep compat versions for 2.6.x)
 - move them to include/scsi/scsi_dbg.h so now really only legacy stuff
   is left in drivers/scsi/scsi.h


--- 1.15/drivers/scsi/constants.c	Wed Feb 25 12:40:04 2004
+++ edited/drivers/scsi/constants.c	Wed May 19 17:46:14 2004
@@ -152,7 +152,7 @@
 }
 #endif  
 
-void print_command (unsigned char *command) {
+void __scsi_print_command (unsigned char *command) {
     int i,s;
     print_opcode(command[0]);
     for ( i = 1, s = COMMAND_SIZE(command[0]); i < s; ++i) 
@@ -171,7 +171,7 @@
  *	(e.g. "0x2" for Check Condition).
  **/
 void
-print_status(unsigned char scsi_status) {
+scsi_print_status(unsigned char scsi_status) {
 #if (CONSTANTS & CONST_STATUS)
 	const char * ccp;
 
@@ -1012,12 +1012,12 @@
 #endif
 }
 
-void print_sense(const char *devclass, struct scsi_cmnd *cmd)
+void scsi_print_sense(const char *devclass, struct scsi_cmnd *cmd)
 {
 	print_sense_internal(devclass, cmd->sense_buffer, cmd->request);
 }
 
-void print_req_sense(const char *devclass, struct scsi_request *sreq)
+void scsi_print_req_sense(const char *devclass, struct scsi_request *sreq)
 {
 	print_sense_internal(devclass, sreq->sr_sense_buffer, sreq->sr_request);
 }
@@ -1049,7 +1049,7 @@
 #define NO_EXTENDED_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
 #endif /* (CONSTANTS & CONST_MSG) */
 
-int print_msg (const unsigned char *msg) {
+int scsi_print_msg (const unsigned char *msg) {
     int len = 0, i;
     if (msg[0] == EXTENDED_MESSAGE) {
 	len = 3 + msg[1];
@@ -1122,13 +1122,13 @@
     return len;
 }
 
-void print_Scsi_Cmnd(struct scsi_cmnd *cmd) {
+void scsi_print_command(struct scsi_cmnd *cmd) {
     printk("scsi%d : destination target %d, lun %d\n", 
 	   cmd->device->host->host_no, 
 	   cmd->device->id, 
 	   cmd->device->lun);
     printk("        command = ");
-    print_command(cmd->cmnd);
+    __scsi_print_command(cmd->cmnd);
 }
 
 #if (CONSTANTS & CONST_HOST)
@@ -1137,7 +1137,7 @@
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
 "DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", NULL};
 
-void print_hostbyte(int scsiresult)
+void scsi_print_hostbyte(int scsiresult)
 {   static int maxcode=0;
     int i;
    
@@ -1153,7 +1153,7 @@
     printk("(%s) ",hostbyte_table[host_byte(scsiresult)]);
 }
 #else
-void print_hostbyte(int scsiresult)
+void scsi_print_hostbyte(int scsiresult)
 {   printk("Hostbyte=0x%02x ",host_byte(scsiresult));
 }
 #endif
@@ -1168,7 +1168,7 @@
 unknown,unknown,unknown, "SUGGEST_SENSE",NULL};
 
 
-void print_driverbyte(int scsiresult)
+void scsi_print_driverbyte(int scsiresult)
 {   static int driver_max=0,suggest_max=0;
     int i,dr=driver_byte(scsiresult)&DRIVER_MASK, 
 	su=(driver_byte(scsiresult)&SUGGEST_MASK)>>4;
@@ -1185,7 +1185,7 @@
 	su<suggest_max ? driversuggest_table[su]:"invalid");
 }
 #else
-void print_driverbyte(int scsiresult)
+void scsi_print_driverbyte(int scsiresult)
 {   printk("Driverbyte=0x%02x ",driver_byte(scsiresult));
 }
 #endif
--- 1.92/drivers/scsi/scsi.h	Wed Feb 11 08:50:03 2004
+++ edited/drivers/scsi/scsi.h	Wed May 19 17:46:14 2004
@@ -11,6 +11,11 @@
  *       add scatter-gather, multiple outstanding request, and other
  *       enhancements.
  */
+/*
+ * NOTE:  this file only contains compatibility glue for old drivers.  All
+ * these wrappers will be removed sooner or later.  For new code please use
+ * the interfaces declared in the headers in include/scsi/
+ */
 
 #ifndef _SCSI_H
 #define _SCSI_H
@@ -18,6 +23,7 @@
 #include <linux/config.h>	    /* for CONFIG_SCSI_LOGGING */
 
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_request.h>
@@ -47,21 +53,6 @@
 struct scatterlist;
 
 /*
- * Prototypes for functions in constants.c
- * Some of these used to live in constants.h
- */
-extern void print_Scsi_Cmnd(struct scsi_cmnd *);
-extern void print_command(unsigned char *);
-extern void print_sense(const char *, struct scsi_cmnd *);
-extern void print_req_sense(const char *, struct scsi_request *);
-extern void print_driverbyte(int scsiresult);
-extern void print_hostbyte(int scsiresult);
-extern void print_status(unsigned char status);
-extern int print_msg(const unsigned char *);
-extern const char *scsi_sense_key_string(unsigned char);
-extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
-
-/*
  * Legacy dma direction interfaces.
  *
  * This assumes the pci/sbus dma mapping flags have the same numercial
@@ -75,6 +66,42 @@
 
 #define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
 #define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
+
+/*
+ * Old names for debug prettyprinting functions.
+ */
+static inline void print_Scsi_Cmnd(struct scsi_cmnd *cmd)
+{
+	return scsi_print_command(cmd);
+}
+static inline void print_command(unsigned char *cdb)
+{
+	return __scsi_print_command(cdb);
+}
+static inline void print_sense(const char *devclass, struct scsi_cmnd *cmd)
+{
+	return scsi_print_sense(devclass, cmd);
+}
+static inline void print_req_sense(const char *devclass, struct scsi_request *req)
+{
+	return scsi_print_req_sense(devclass, req);
+}
+static inline void print_driverbyte(int scsiresult)
+{
+	return scsi_print_driverbyte(scsiresult);
+}
+static inline void print_hostbyte(int scsiresult)
+{
+	return scsi_print_hostbyte(scsiresult);
+}
+static inline void print_status(unsigned char status)
+{
+	return scsi_print_status(status);
+}
+static inline int print_msg(const unsigned char *msg)
+{
+	return scsi_print_msg(msg);
+}
 
 /*
  * This is the crap from the old error handling code.  We have it in a special
--- 1.46/drivers/scsi/scsi_syms.c	Wed Nov 12 15:15:46 2003
+++ edited/drivers/scsi/scsi_syms.c	Wed May 19 17:46:14 2004
@@ -46,15 +46,15 @@
 EXPORT_SYMBOL(scsi_partsize);
 EXPORT_SYMBOL(scsi_bios_ptable);
 EXPORT_SYMBOL(scsi_ioctl);
-EXPORT_SYMBOL(print_command);
-EXPORT_SYMBOL(print_sense);
-EXPORT_SYMBOL(print_req_sense);
-EXPORT_SYMBOL(print_msg);
-EXPORT_SYMBOL(print_status);
+EXPORT_SYMBOL(scsi_print_command);
+EXPORT_SYMBOL(__scsi_print_command);
+EXPORT_SYMBOL(scsi_print_sense);
+EXPORT_SYMBOL(scsi_print_req_sense);
+EXPORT_SYMBOL(scsi_print_msg);
+EXPORT_SYMBOL(scsi_print_status);
 EXPORT_SYMBOL(scsi_sense_key_string);
 EXPORT_SYMBOL(scsi_extd_sense_format);
 EXPORT_SYMBOL(kernel_scsi_ioctl);
-EXPORT_SYMBOL(print_Scsi_Cmnd);
 EXPORT_SYMBOL(scsi_block_when_processing_errors);
 EXPORT_SYMBOL(scsi_ioctl_send_command);
 EXPORT_SYMBOL(scsi_set_medium_removal);
--- /dev/null	2004-04-27 22:04:56.000000000 +0200
+++ edited/include/scsi/scsi_dbg.h	2004-05-13 10:45:25.000000000 +0200
@@ -0,0 +1,18 @@
+#ifndef _SCSI_SCSI_DBG_H
+#define _SCSI_SCSI_DBG_H
+
+struct scsi_cmnd;
+struct scsi_request;
+
+extern void scsi_print_command(struct scsi_cmnd *);
+extern void __scsi_print_command(unsigned char *);
+extern void scsi_print_sense(const char *, struct scsi_cmnd *);
+extern void scsi_print_req_sense(const char *, struct scsi_request *);
+extern void scsi_print_driverbyte(int);
+extern void scsi_print_hostbyte(int);
+extern void scsi_print_status(unsigned char);
+extern int scsi_print_msg(const unsigned char *);
+extern const char *scsi_sense_key_string(unsigned char);
+extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
+
+#endif /* _SCSI_SCSI_DBG_H */

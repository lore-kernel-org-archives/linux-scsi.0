From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove outdated print_* functions
Date: Tue, 29 Mar 2005 19:24:06 +0200
Message-ID: <20050329172406.GB2430@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:43410 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261253AbVC2RYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 12:24:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

We have the scsi_print_* functions in the proper namespace for a long
time now and there weren't a lot users left.


--- 1.22/drivers/scsi/53c7xx.c	2004-05-12 17:46:19 +02:00
+++ edited/drivers/scsi/53c7xx.c	2005-03-29 17:32:18 +02:00
@@ -280,6 +280,7 @@
 #endif
 
 #include "scsi.h"
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include "53c7xx.h"
 #include <linux/stat.h>
@@ -1721,9 +1722,9 @@
 		printk ("scsi%d : test 2 INQUIRY to target %d, lun 0 : %s\n",
 		    host->host_no, i, data + 8);
 		printk ("scsi%d : status ", host->host_no);
-		print_status (status);
+		scsi_print_status (status);
 		printk ("\nscsi%d : message ", host->host_no);
-		print_msg (&msg);
+		scsi_print_msg (&msg);
 		printk ("\n");
 	    } else if (hostdata->test_completed == 3) {
 		printk("scsi%d : test 2 no connection with target %d\n",
@@ -2312,7 +2313,7 @@
 	    printk ("scsi%d : received message", host->host_no);
 	    if (c) 
 	    	printk (" from target %d lun %d ", c->device->id, c->device->lun);
-	    print_msg ((unsigned char *) hostdata->msg_buf);
+	    scsi_print_msg ((unsigned char *) hostdata->msg_buf);
 	    printk("\n");
 	}
 	
@@ -3204,7 +3205,7 @@
     case WRITE_10:
 #if 0
 	printk("scsi%d : command is ", host->host_no);
-	print_command(cmd->cmnd);
+	__scsi_print_command(cmd->cmnd);
 #endif
 #if 0
 	printk ("scsi%d : %d scatter/gather segments\n", host->host_no,
@@ -3232,7 +3233,7 @@
      */
     default:
 	printk("scsi%d : datain+dataout for command ", host->host_no);
-	print_command(cmd->cmnd);
+	__scsi_print_command(cmd->cmnd);
 	datain = dataout = 2 * (cmd->use_sg ? cmd->use_sg : 1) + 3;
     }
 
@@ -3938,7 +3939,7 @@
     	    if (cmd) {
     	    	printk("scsi%d : target %d, lun %d, command ",
 		    host->host_no, cmd->cmd->device->id, cmd->cmd->device->lun);
-    	    	print_command (cmd->cmd->cmnd);
+    	    	__scsi_print_command (cmd->cmd->cmnd);
 		printk("scsi%d : dsp = 0x%x (virt 0x%p)\n", host->host_no,
 		    NCR53c7x0_read32(DSP_REG),
 		    bus_to_virt(NCR53c7x0_read32(DSP_REG)));
@@ -4208,7 +4209,7 @@
 	if (hostdata->options & OPTION_DEBUG_INTR) {
 	    printk ("scsi%d : command complete : pid %lu, id %d,lun %d result 0x%x ", 
 		  host->host_no, tmp->pid, tmp->device->id, tmp->device->lun, tmp->result);
-	    print_command (tmp->cmnd);
+	    __scsi_print_command (tmp->cmnd);
 	}
 
 	tmp->scsi_done(tmp);
@@ -4297,7 +4298,7 @@
 		printk("scsi%d : interrupt for pid %lu, id %d, lun %d ", 
 		    host->host_no, cmd->cmd->pid, (int) cmd->cmd->device->id,
 		    (int) cmd->cmd->device->lun);
-		print_command (cmd->cmd->cmnd);
+		__scsi_print_command (cmd->cmd->cmnd);
 	    } else {
 		printk("scsi%d : no active command\n", host->host_no);
 	    }
@@ -5539,7 +5540,7 @@
 	    i > 0 && !check_address ((unsigned long) ptr, 1);
 	    ptr += len, i -= len) {
 	    printk("               ");
-	    len = print_msg (ptr);
+	    len = scsi_print_msg (ptr);
 	    printk("\n");
 	    if (!len)
 		break;
@@ -5554,7 +5555,7 @@
     if (cmd) {
 	printk("               result = 0x%x, target = %d, lun = %d, cmd = ",
 	    cmd->result, cmd->device->id, cmd->device->lun);
-	print_command(cmd->cmnd);
+	__scsi_print_command(cmd->cmnd);
     } else
 	printk("\n");
     printk("        + %d : dsa_next = 0x%x\n", hostdata->dsa_next,
@@ -6028,7 +6029,7 @@
 		    virt_to_bus(event.dsa), event.dsa);
 	    if (event.pid != -1) {
 		printk ("         event for pid %ld ", event.pid);
-		print_command (event.cmnd);
+		__scsi_print_command (event.cmnd);
 	    }
 	}
     }
===== drivers/scsi/NCR5380.c 1.29 vs edited =====
--- 1.29/drivers/scsi/NCR5380.c	2005-02-25 00:17:28 +01:00
+++ edited/drivers/scsi/NCR5380.c	2005-03-29 17:28:01 +02:00
@@ -86,6 +86,7 @@
  * 5.  Test linked command handling code after Eric is ready with 
  *      the high level code.
  */
+#include <scsi/scsi_dbg.h>
 
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x,y) {printk("LINE:%d   Adding %p to %p\n", __LINE__, (void*)(x), (void*)(y)); if ((x)==(y)) udelay(5); }
@@ -2371,7 +2372,7 @@
  * 3..length+1  arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since print_msg() wants the whole thing.  
+ * byte, since scsi_print_msg() wants the whole thing.  
  */
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
@@ -2418,7 +2419,7 @@
 				default:
 					if (!tmp) {
 						printk("scsi%d: rejecting message ", instance->host_no);
-						print_msg(extended_msg);
+						scsi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
 						printk("scsi%d: rejecting unknown message %02x from target %d, lun %d\n", instance->host_no, tmp, cmd->device->id, cmd->device->lun);
@@ -2552,7 +2553,7 @@
 
 	if (!(msg[0] & 0x80)) {
 		printk(KERN_ERR "scsi%d : expecting IDENTIFY message, got ", instance->host_no);
-		print_msg(msg);
+		scsi_print_msg(msg);
 		abort = 1;
 	} else {
 		/* Accept message by clearing ACK */
@@ -2677,7 +2678,7 @@
 	Scsi_Cmnd *tmp, **prev;
 	
 	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
-	print_Scsi_Cmnd(cmd);
+	scsi_print_command(cmd);
 
 	NCR5380_print_status(instance);
 
===== drivers/scsi/aha152x.c 1.50 vs edited =====
--- 1.50/drivers/scsi/aha152x.c	2005-01-08 06:44:22 +01:00
+++ edited/drivers/scsi/aha152x.c	2005-03-29 17:31:57 +02:00
@@ -257,6 +257,7 @@
 #include <scsi/scsicam.h>
 
 #include "scsi.h"
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include "aha152x.h"
 
@@ -986,7 +987,7 @@
 	if (HOSTDATA(shpnt)->debug & debug_queue) {
 		printk(INFO_LEAD "queue: %p; cmd_len=%d pieces=%d size=%u cmnd=",
 		       CMDINFO(SCpnt), SCpnt, SCpnt->cmd_len, SCpnt->use_sg, SCpnt->request_bufflen);
-		print_command(SCpnt->cmnd);
+		__scsi_print_command(SCpnt->cmnd);
 	}
 #endif
 
@@ -1560,7 +1561,7 @@
 #if 0
 			if(HOSTDATA(shpnt)->debug & debug_eh) {
 				printk(ERR_LEAD "received sense: ", CMDINFO(DONE_SC));
-				print_sense("bh", DONE_SC);
+				scsi_print_sense("bh", DONE_SC);
 			}
 #endif
 
@@ -1846,7 +1847,7 @@
 #if defined(AHA152X_DEBUG)
 		if (HOSTDATA(shpnt)->debug & debug_msgi) {
 			printk(INFO_LEAD "inbound message %02x ", CMDINFO(CURRENT_SC), MSGI(0));
-			print_msg(&MSGI(0));
+			scsi_print_msg(&MSGI(0));
 			printk("\n");
 		}
 #endif
@@ -1934,7 +1935,7 @@
 						break;
 
 					printk(INFO_LEAD, CMDINFO(CURRENT_SC));
-					print_msg(&MSGI(0));
+					scsi_print_msg(&MSGI(0));
 					printk("\n");
 
 					ticks = (MSGI(3) * 4 + 49) / 50;
@@ -2032,7 +2033,7 @@
 		int i;
 
 		printk(DEBUG_LEAD "messages( ", CMDINFO(CURRENT_SC));
-		for (i=0; i<MSGOLEN; i+=print_msg(&MSGO(i)), printk(" "))
+		for (i=0; i<MSGOLEN; i+=scsi_print_msg(&MSGO(i)), printk(" "))
 			;
 		printk(")\n");
 	}
@@ -2104,7 +2105,7 @@
 #if defined(AHA152X_DEBUG)
 	if (HOSTDATA(shpnt)->debug & debug_cmd) {
 		printk(DEBUG_LEAD "cmd_init: ", CMDINFO(CURRENT_SC));
-		print_command(CURRENT_SC->cmnd);
+		__scsi_print_command(CURRENT_SC->cmnd);
 	}
 #endif
 
@@ -2158,7 +2159,7 @@
 #if defined(AHA152X_DEBUG)
 	if (HOSTDATA(shpnt)->debug & debug_status) {
 		printk(DEBUG_LEAD "inbound status %02x ", CMDINFO(CURRENT_SC), CURRENT_SC->SCp.Status);
-		print_status(CURRENT_SC->SCp.Status);
+		scsi_print_status(CURRENT_SC->SCp.Status);
 		printk("\n");
 	}
 #endif
@@ -2925,7 +2926,7 @@
 	printk(KERN_DEBUG "0x%08x: target=%d; lun=%d; cmnd=(",
 	       (unsigned int) ptr, ptr->device->id, ptr->device->lun);
 
-	print_command(ptr->cmnd);
+	__scsi_print_command(ptr->cmnd);
 
 	printk(KERN_DEBUG "); request_bufflen=%d; resid=%d; phase |",
 	       ptr->request_bufflen, ptr->resid);
===== drivers/scsi/atari_NCR5380.c 1.16 vs edited =====
--- 1.16/drivers/scsi/atari_NCR5380.c	2004-04-12 19:55:30 +02:00
+++ edited/drivers/scsi/atari_NCR5380.c	2005-03-29 17:28:13 +02:00
@@ -73,6 +73,7 @@
  * 1.  Test linked command handling code after Eric is ready with 
  *     the high level code.
  */
+#include <scsi/scsi_dbg.h>
 
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x,y) \
@@ -2354,7 +2355,7 @@
  * 3..length+1	arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since print_msg() wants the whole thing.  
+ * byte, since scsi_print_msg() wants the whole thing.  
  */
 		    extended_msg[0] = EXTENDED_MESSAGE;
 		    /* Accept first byte by clearing ACK */
@@ -2407,7 +2408,7 @@
 		default:
 		    if (!tmp) {
 			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			print_msg (extended_msg);
+			scsi_print_msg (extended_msg);
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
@@ -2540,7 +2541,7 @@
 
     if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
-	print_msg(msg);
+	scsi_print_msg(msg);
 	do_abort(instance);
 	return;
     }
@@ -2646,7 +2647,7 @@
     unsigned long flags;
 
     printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
-    print_Scsi_Cmnd (cmd);
+    scsi_print_command(cmd);
 
     NCR5380_print_status (instance);
 
===== drivers/scsi/constants.c 1.22 vs edited =====
--- 1.22/drivers/scsi/constants.c	2005-01-05 12:25:05 +01:00
+++ edited/drivers/scsi/constants.c	2005-03-29 17:21:01 +02:00
@@ -372,7 +372,7 @@
 
 /**
  *
- *	print_status - print scsi status description
+ *	scsi_print_status - print scsi status description
  *	@scsi_status: scsi status value
  *
  *	If the status is recognized, the description is printed.
===== drivers/scsi/scsi.c 1.157 vs edited =====
--- 1.157/drivers/scsi/scsi.c	2005-03-03 09:22:17 +01:00
+++ edited/drivers/scsi/scsi.c	2005-03-29 17:26:17 +02:00
@@ -489,7 +489,7 @@
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION) {
 				/*
-				 * XXX The print_sense formatting/prefix
+				 * XXX The scsi_print_sense formatting/prefix
 				 * doesn't match this function.
 				 */
 				scsi_print_sense("", cmd);
===== drivers/scsi/scsi.h 1.94 vs edited =====
--- 1.94/drivers/scsi/scsi.h	2004-06-06 13:17:31 +02:00
+++ edited/drivers/scsi/scsi.h	2005-03-29 19:28:04 +02:00
@@ -23,7 +23,6 @@
 #include <linux/config.h>	    /* for CONFIG_SCSI_LOGGING */
 
 #include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_request.h>
@@ -60,42 +59,6 @@
 
 #define scsi_to_pci_dma_dir(scsi_dir)	((int)(scsi_dir))
 #define scsi_to_sbus_dma_dir(scsi_dir)	((int)(scsi_dir))
-
-/*
- * Old names for debug prettyprinting functions.
- */
-static inline void print_Scsi_Cmnd(struct scsi_cmnd *cmd)
-{
-	return scsi_print_command(cmd);
-}
-static inline void print_command(unsigned char *cdb)
-{
-	return __scsi_print_command(cdb);
-}
-static inline void print_sense(const char *devclass, struct scsi_cmnd *cmd)
-{
-	return scsi_print_sense(devclass, cmd);
-}
-static inline void print_req_sense(const char *devclass, struct scsi_request *req)
-{
-	return scsi_print_req_sense(devclass, req);
-}
-static inline void print_driverbyte(int scsiresult)
-{
-	return scsi_print_driverbyte(scsiresult);
-}
-static inline void print_hostbyte(int scsiresult)
-{
-	return scsi_print_hostbyte(scsiresult);
-}
-static inline void print_status(unsigned char status)
-{
-	return scsi_print_status(status);
-}
-static inline int print_msg(const unsigned char *msg)
-{
-	return scsi_print_msg(msg);
-}
 
 /*
  * This is the crap from the old error handling code.  We have it in a special
--- 1.25/drivers/scsi/seagate.c	2004-11-28 03:30:40 +01:00
+++ edited/drivers/scsi/seagate.c	2005-03-29 17:34:50 +02:00
@@ -103,6 +103,7 @@
 #include <asm/uaccess.h>
 
 #include "scsi.h"
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include "seagate.h"
 
@@ -746,7 +747,7 @@
 
 #if (DEBUG & PRINT_COMMAND)
 	printk("scsi%d : target = %d, command = ", hostno, target);
-	print_command((unsigned char *) cmnd);
+	__scsi_print_command((unsigned char *) cmnd);
 #endif
 
 #if (DEBUG & PHASE_RESELECT)
@@ -1553,7 +1554,7 @@
 	printk("\n");
 #endif
 	printk("scsi%d : status = ", hostno);
-	print_status(status);
+	scsi_print_status(status);
 	printk(" message = %02x\n", message);
 #endif
 
===== drivers/scsi/sg.c 1.107 vs edited =====
--- 1.107/drivers/scsi/sg.c	2005-03-15 16:27:33 +01:00
+++ edited/drivers/scsi/sg.c	2005-03-29 17:34:48 +02:00
@@ -51,6 +51,7 @@
 #include <linux/delay.h>
 
 #include "scsi.h"
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_ioctl.h>
@@ -1311,7 +1312,7 @@
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			print_req_sense("sg_cmd_done", SRpnt);
+			scsi_print_req_sense("sg_cmd_done", SRpnt);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
 		if (driver_byte(SRpnt->sr_result) != 0
===== drivers/scsi/sun3_NCR5380.c 1.19 vs edited =====
--- 1.19/drivers/scsi/sun3_NCR5380.c	2003-08-21 10:36:23 +02:00
+++ edited/drivers/scsi/sun3_NCR5380.c	2005-03-29 17:28:23 +02:00
@@ -69,6 +69,7 @@
  *   finally replaced that by the *_PRINTK() macros.
  *
  */
+#include <scsi/scsi_dbg.h>
 
 /*
  * Further development / testing that should be done : 
@@ -2377,7 +2378,7 @@
  * 3..length+1	arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since print_msg() wants the whole thing.  
+ * byte, since scsi_print_msg() wants the whole thing.  
  */
 		    extended_msg[0] = EXTENDED_MESSAGE;
 		    /* Accept first byte by clearing ACK */
@@ -2430,7 +2431,7 @@
 		default:
 		    if (!tmp) {
 			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			print_msg (extended_msg);
+			scsi_print_msg (extended_msg);
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
@@ -2565,7 +2566,7 @@
 
     if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
-	print_msg(msg);
+	scsi_print_msg(msg);
 	do_abort(instance);
 	return;
     }
@@ -2691,7 +2692,7 @@
     unsigned long flags;
 
     printk(KERN_NOTICE "scsi%d: aborting command\n", HOSTNO);
-    print_Scsi_Cmnd (cmd);
+    scsi_print_command(cmd);
 
     NCR5380_print_status (instance);
 
===== drivers/scsi/arm/acornscsi.c 1.39 vs edited =====
--- 1.39/drivers/scsi/arm/acornscsi.c	2004-10-20 10:37:15 +02:00
+++ edited/drivers/scsi/arm/acornscsi.c	2005-03-29 17:34:19 +02:00
@@ -150,6 +150,7 @@
 #include <asm/ecard.h>
 
 #include "../scsi.h"
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include "acornscsi.h"
 #include "msgqueue.h"
@@ -866,7 +867,7 @@
 		    default:
 			printk(KERN_ERR "scsi%d.H: incomplete data transfer detected: result=%08X command=",
 				host->host->host_no, SCpnt->result);
-			print_command(SCpnt->cmnd);
+			__scsi_print_command(SCpnt->cmnd);
 			acornscsi_dumpdma(host, "done");
 		 	acornscsi_dumplog(host, SCpnt->device->id);
 			SCpnt->result &= 0xffff;
@@ -1369,7 +1370,7 @@
 
 	host->scsi.last_message = msg->msg[0];
 #if (DEBUG & DEBUG_MESSAGES)
-	print_msg(msg->msg);
+	scsi_print_msg(msg->msg);
 #endif
 	break;
 
@@ -1391,7 +1392,7 @@
 	while ((msg = msgqueue_getmsg(&host->scsi.msgs, msgnr++)) != NULL) {
 	    unsigned int i;
 #if (DEBUG & DEBUG_MESSAGES)
-	    print_msg(msg);
+	    scsi_print_msg(msg);
 #endif
 	    i = 0;
 	    if (acornscsi_write_pio(host, msg->msg, &i, msg->length, 1000000))
@@ -1487,7 +1488,7 @@
 #if (DEBUG & DEBUG_MESSAGES)
     printk("scsi%d.%c: message in: ",
 	    host->host->host_no, acornscsi_target(host));
-    print_msg(message);
+    scsi_print_msg(message);
     printk("\n");
 #endif
 
===== drivers/scsi/arm/fas216.c 1.32 vs edited =====
--- 1.32/drivers/scsi/arm/fas216.c	2005-03-02 20:11:57 +01:00
+++ edited/drivers/scsi/arm/fas216.c	2005-03-29 17:34:11 +02:00
@@ -52,6 +52,7 @@
 #include <asm/ecard.h>
 
 #include "../scsi.h"
+#include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
 #include "fas216.h"
 #include "scsi.h"
@@ -309,7 +310,7 @@
 	va_end(args);
 
 	printk(" CDB: ");
-	print_command(SCpnt->cmnd);
+	__scsi_print_command(SCpnt->cmnd);
 }
 
 static void
@@ -2081,7 +2082,7 @@
 				info->host->host_no, '0' + SCpnt->device->id,
 				SCpnt->result, info->scsi.SCp.ptr,
 				info->scsi.SCp.this_residual);
-			print_command(SCpnt->cmnd);
+			__scsi_print_command(SCpnt->cmnd);
 			SCpnt->result &= ~(255 << 16);
 			SCpnt->result |= DID_BAD_TARGET << 16;
 			goto request_sense;
@@ -2170,7 +2171,7 @@
 		       info->host->host_no, '0' + SCpnt->device->id,
 		       info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
 		info->scsi.SCp.ptr = NULL;
-		print_command(SCpnt->cmnd);
+		__scsi_print_command(SCpnt->cmnd);
 	}
 
 	/*
@@ -2426,7 +2427,7 @@
 	info->stats.aborts += 1;
 
 	printk(KERN_WARNING "scsi%d: abort command ", info->host->host_no);
-	print_command(SCpnt->data_cmnd);
+	__scsi_print_command(SCpnt->data_cmnd);
 
 	print_debug_list();
 	fas216_dumpstate(info);
===== drivers/scsi/arm/scsi.h 1.7 vs edited =====
--- 1.7/drivers/scsi/arm/scsi.h	2003-08-16 20:46:50 +02:00
+++ edited/drivers/scsi/arm/scsi.h	2005-03-29 17:31:26 +02:00
@@ -108,7 +108,7 @@
 #if 0 //def BELT_AND_BRACES
 		printk(KERN_WARNING "scsi%d.%c: zero length buffer passed for "
 		       "command ", SCpnt->host->host_no, '0' + SCpnt->target);
-		print_command(SCpnt->cmnd);
+		__scsi_print_command(SCpnt->cmnd);
 #endif
 		SCpnt->SCp.ptr = NULL;
 	}

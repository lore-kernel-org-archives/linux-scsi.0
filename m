From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/5] [SCSI] Rename scsi_print_msg to spi_print_msg
Date: Thu, 15 Dec 2005 16:22:01 -0500
Message-ID: <1134681721444-git-send-email-matthew@wil.cx>
References: <20051215205856.GA2361@parisc-linux.org>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:25535 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1751097AbVLOVWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 16:22:04 -0500
In-Reply-To: <20051215205856.GA2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Rename scsi_print_msg to spi_print_msg and move its prototype from
scsi_dbg.h to scsi_transport_spi.h

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/53c700.c               |    6 +++---
 drivers/scsi/53c7xx.c               |    7 ++++---
 drivers/scsi/NCR5380.c              |    7 ++++---
 drivers/scsi/aha152x.c              |    7 ++++---
 drivers/scsi/arm/acornscsi.c        |    7 ++++---
 drivers/scsi/atari_NCR5380.c        |    7 ++++---
 drivers/scsi/scsi_transport_spi.c   |    8 ++++----
 drivers/scsi/sun3_NCR5380.c         |    7 ++++---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    4 ++--
 include/scsi/scsi_dbg.h             |    1 -
 include/scsi/scsi_transport_spi.h   |    1 +
 11 files changed, 34 insertions(+), 28 deletions(-)

967aaca5d5dd9e8a5d85f0fd79aa86340b149df8
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index e7ad269..4ce7438 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -857,7 +857,7 @@ process_extended_message(struct Scsi_Hos
 		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
 		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
-		scsi_print_msg(hostdata->msgin);
+		spi_print_msg(hostdata->msgin);
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
@@ -887,7 +887,7 @@ process_message(struct Scsi_Host *host,	
 #ifdef NCR_700_DEBUG
 	printk("scsi%d (%d:%d): message %s: ", host->host_no, pun, lun,
 	       NCR_700_phase[(dsps & 0xf00) >> 8]);
-	scsi_print_msg(hostdata->msgin);
+	spi_print_msg(hostdata->msgin);
 	printk("\n");
 #endif
 
@@ -939,7 +939,7 @@ process_message(struct Scsi_Host *host,	
 		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 
-		scsi_print_msg(hostdata->msgin);
+		spi_print_msg(hostdata->msgin);
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
diff --git a/drivers/scsi/53c7xx.c b/drivers/scsi/53c7xx.c
index 9cb5dd4..7894b8e 100644
--- a/drivers/scsi/53c7xx.c
+++ b/drivers/scsi/53c7xx.c
@@ -282,6 +282,7 @@
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 #include "53c7xx.h"
 #include <linux/stat.h>
 #include <linux/stddef.h>
@@ -1724,7 +1725,7 @@ NCR53c7xx_run_tests (struct Scsi_Host *h
 		printk ("scsi%d : status ", host->host_no);
 		scsi_print_status (status);
 		printk ("\nscsi%d : message ", host->host_no);
-		scsi_print_msg (&msg);
+		spi_print_msg(&msg);
 		printk ("\n");
 	    } else if (hostdata->test_completed == 3) {
 		printk("scsi%d : test 2 no connection with target %d\n",
@@ -2313,7 +2314,7 @@ NCR53c7x0_dstat_sir_intr (struct Scsi_Ho
 	    printk ("scsi%d : received message", host->host_no);
 	    if (c) 
 	    	printk (" from target %d lun %d ", c->device->id, c->device->lun);
-	    scsi_print_msg ((unsigned char *) hostdata->msg_buf);
+	    spi_print_msg((unsigned char *) hostdata->msg_buf);
 	    printk("\n");
 	}
 	
@@ -5540,7 +5541,7 @@ print_dsa (struct Scsi_Host *host, u32 *
 	    i > 0 && !check_address ((unsigned long) ptr, 1);
 	    ptr += len, i -= len) {
 	    printk("               ");
-	    len = scsi_print_msg (ptr);
+	    len = spi_print_msg(ptr);
 	    printk("\n");
 	    if (!len)
 		break;
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cba9655..9f0ddbe 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -87,6 +87,7 @@
  *      the high level code.
  */
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
 #ifndef NDEBUG
 #define NDEBUG 0
@@ -2377,7 +2378,7 @@ static void NCR5380_information_transfer
  * 3..length+1  arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since scsi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.  
  */
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
@@ -2424,7 +2425,7 @@ static void NCR5380_information_transfer
 				default:
 					if (!tmp) {
 						printk("scsi%d: rejecting message ", instance->host_no);
-						scsi_print_msg(extended_msg);
+						spi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
 						scmd_printk(KERN_INFO, cmd,
@@ -2560,7 +2561,7 @@ static void NCR5380_reselect(struct Scsi
 
 	if (!(msg[0] & 0x80)) {
 		printk(KERN_ERR "scsi%d : expecting IDENTIFY message, got ", instance->host_no);
-		scsi_print_msg(msg);
+		spi_print_msg(msg);
 		abort = 1;
 	} else {
 		/* Accept message by clearing ACK */
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 9df23b6..cb2ee25 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -259,6 +259,7 @@
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 #include "aha152x.h"
 
 
@@ -1845,7 +1846,7 @@ static void msgi_run(struct Scsi_Host *s
 #if defined(AHA152X_DEBUG)
 		if (HOSTDATA(shpnt)->debug & debug_msgi) {
 			printk(INFO_LEAD "inbound message %02x ", CMDINFO(CURRENT_SC), MSGI(0));
-			scsi_print_msg(&MSGI(0));
+			spi_print_msg(&MSGI(0));
 			printk("\n");
 		}
 #endif
@@ -1933,7 +1934,7 @@ static void msgi_run(struct Scsi_Host *s
 						break;
 
 					printk(INFO_LEAD, CMDINFO(CURRENT_SC));
-					scsi_print_msg(&MSGI(0));
+					spi_print_msg(&MSGI(0));
 					printk("\n");
 
 					ticks = (MSGI(3) * 4 + 49) / 50;
@@ -2031,7 +2032,7 @@ static void msgo_init(struct Scsi_Host *
 		int i;
 
 		printk(DEBUG_LEAD "messages( ", CMDINFO(CURRENT_SC));
-		for (i=0; i<MSGOLEN; i+=scsi_print_msg(&MSGO(i)), printk(" "))
+		for (i=0; i<MSGOLEN; i+=spi_print_msg(&MSGO(i)), printk(" "))
 			;
 		printk(")\n");
 	}
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index b7b20c6..09ed057 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -152,6 +152,7 @@
 #include "../scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 #include "acornscsi.h"
 #include "msgqueue.h"
 #include "scsi.h"
@@ -1370,7 +1371,7 @@ void acornscsi_sendmessage(AS_Host *host
 
 	host->scsi.last_message = msg->msg[0];
 #if (DEBUG & DEBUG_MESSAGES)
-	scsi_print_msg(msg->msg);
+	spi_print_msg(msg->msg);
 #endif
 	break;
 
@@ -1392,7 +1393,7 @@ void acornscsi_sendmessage(AS_Host *host
 	while ((msg = msgqueue_getmsg(&host->scsi.msgs, msgnr++)) != NULL) {
 	    unsigned int i;
 #if (DEBUG & DEBUG_MESSAGES)
-	    scsi_print_msg(msg);
+	    spi_print_msg(msg);
 #endif
 	    i = 0;
 	    if (acornscsi_write_pio(host, msg->msg, &i, msg->length, 1000000))
@@ -1488,7 +1489,7 @@ void acornscsi_message(AS_Host *host)
 #if (DEBUG & DEBUG_MESSAGES)
     printk("scsi%d.%c: message in: ",
 	    host->host->host_no, acornscsi_target(host));
-    scsi_print_msg(message);
+    spi_print_msg(message);
     printk("\n");
 #endif
 
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 2ae31ce..57295bc 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -74,6 +74,7 @@
  *     the high level code.
  */
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x,y) \
@@ -2355,7 +2356,7 @@ static void NCR5380_information_transfer
  * 3..length+1	arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since scsi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.  
  */
 		    extended_msg[0] = EXTENDED_MESSAGE;
 		    /* Accept first byte by clearing ACK */
@@ -2408,7 +2409,7 @@ static void NCR5380_information_transfer
 		default:
 		    if (!tmp) {
 			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			scsi_print_msg (extended_msg);
+			spi_print_msg(extended_msg);
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
@@ -2541,7 +2542,7 @@ static void NCR5380_reselect (struct Scs
 
     if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	do_abort(instance);
 	return;
     }
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 00a73fc..59fb69b 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1072,7 +1072,7 @@ static const char * const extended_msgs[
 #define NO_EXTENDED_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
 
 
-int scsi_print_msg (const unsigned char *msg)
+int spi_print_msg(const unsigned char *msg)
 {
 	int len = 0, i;
 	if (msg[0] == EXTENDED_MESSAGE) {
@@ -1125,11 +1125,11 @@ int scsi_print_msg (const unsigned char 
 		printk("reserved");
 	return len;
 }
-EXPORT_SYMBOL(scsi_print_msg);
+EXPORT_SYMBOL(spi_print_msg);
 
 #else  /* ifndef CONFIG_SCSI_CONSTANTS */
 
-int scsi_print_msg (const unsigned char *msg)
+int spi_print_msg(const unsigned char *msg)
 {
 	int len = 0, i;
 
@@ -1153,7 +1153,7 @@ int scsi_print_msg (const unsigned char 
 		printk("%02x ", msg[0]);
 	return len;
 }
-EXPORT_SYMBOL(scsi_print_msg);
+EXPORT_SYMBOL(spi_print_msg);
 #endif /* ! CONFIG_SCSI_CONSTANTS */
 
 #define SETUP_ATTRIBUTE(field)						\
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index c041bfd..25cced9 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -70,6 +70,7 @@
  *
  */
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
 /*
  * Further development / testing that should be done : 
@@ -2378,7 +2379,7 @@ static void NCR5380_information_transfer
  * 3..length+1	arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since scsi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.  
  */
 		    extended_msg[0] = EXTENDED_MESSAGE;
 		    /* Accept first byte by clearing ACK */
@@ -2431,7 +2432,7 @@ static void NCR5380_information_transfer
 		default:
 		    if (!tmp) {
 			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			scsi_print_msg (extended_msg);
+			spi_print_msg(extended_msg);
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
@@ -2566,7 +2567,7 @@ static void NCR5380_reselect (struct Scs
 
     if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	do_abort(instance);
 	return;
     }
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 7a3c807..912c376 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -75,7 +75,7 @@ static void sym_print_msg(struct sym_ccb
 {
 	sym_print_addr(cp->cmd, "%s: ", label);
 
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	printf("\n");
 }
 
@@ -84,7 +84,7 @@ static void sym_print_nego_msg(struct sy
 	struct sym_tcb *tp = &np->target[target];
 	dev_info(&tp->starget->dev, "%s: ", label);
 
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	printf("\n");
 }
 
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index b090a11..4d69dee 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -16,7 +16,6 @@ extern void __scsi_print_sense(const cha
 extern void scsi_print_driverbyte(int);
 extern void scsi_print_hostbyte(int);
 extern void scsi_print_status(unsigned char);
-extern int scsi_print_msg(const unsigned char *);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
 
diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
index 5c9b2e5..54a8961 100644
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -146,5 +146,6 @@ void spi_release_transport(struct scsi_t
 void spi_schedule_dv_device(struct scsi_device *);
 void spi_dv_device(struct scsi_device *);
 void spi_display_xfer_agreement(struct scsi_target *);
+int spi_print_msg(const unsigned char *);
 
 #endif /* SCSI_TRANSPORT_SPI_H */
-- 
0.99.9.GIT



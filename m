From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH 1/3]DC395: Debugging cleanup
Date: Tue, 27 May 2003 22:36:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200305272236.06151.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.kontent.de ([81.88.34.36]:16335 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S264057AbTE0U0p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 16:26:45 -0400
Received: from pD9E4D453.dip.t-dialin.net (pD9E4D453.dip.t-dialin.net [217.228.212.83])
	by Mail1.KONTENT.De (Postfix) with ESMTP id 8E5C213C362
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2003 22:40:08 +0200 (CEST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

this is a major cleanup of debugging macros in the DC395 driver.

	Regards
		Oliver


diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Tue May 27 13:14:28 2003
+++ b/drivers/scsi/dc395x.c	Tue May 27 13:14:28 2003
@@ -46,7 +46,6 @@
  *
  ************************************************************************
  */
-
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
@@ -60,109 +59,147 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 
-/* Debugging */
-/*#define DC395x_DEBUG_KG */
-/*#define DC395x_DEBUG0*/
-/*#define DC395x_DEBUG1*/
-/*#define DC395x_DEBUGDCB*/
-#define DC395x_DEBUGTRACE
-/*#define DC395x_DEBUGTRACEALL*/
-/*#define DC395x_DEBUGPARSE*/
-/*#define DC395x_SGPARANOIA*/
-/*#define DC395x_DEBUGFIFO*/
-/*#define DC395x_DEBUGRECURSION*/
-/*#define DC395x_DEBUGPIO*/
-/*#define DC395x_DEBUGMALLOC*/
-
-/* DISable features */
+/*---------------------------------------------------------------------------
+                                  Features
+ ---------------------------------------------------------------------------*/
+/*
+ * Set to disable parts of the driver
+ */
 /*#define DC395x_NO_DISCONNECT*/
 /*#define DC395x_NO_TAGQ*/
 /*#define DC395x_NO_SYNC*/
 /*#define DC395x_NO_WIDE*/

-#ifdef DC395x_DEBUG0
-# define DEBUG0(x) x
-#else
-# define DEBUG0(x)
-#endif
+/*---------------------------------------------------------------------------
+                                  Debugging
+ ---------------------------------------------------------------------------*/
+/*
+ * Types of debugging that can be enabled and disabled
+ */
+#define DBG_KG		0x0001
+#define DBG_0		0x0002
+#define DBG_1		0x0004
+#define DBG_DCB		0x0008
+#define DBG_PARSE	0x0010		/* debug command line parsing */
+#define DBG_SGPARANOIA	0x0020
+#define DBG_FIFO	0x0040
+#define DBG_PIO		0x0080
+#define DBG_RECURSION	0x0100		/* check for excessive recursion */
+#define DBG_MALLOC	0x0200		/* report on memory allocations */
+#define DBG_TRACE	0x0400
+#define DBG_TRACEALL	0x0800
 
-#ifdef DC395x_DEBUG1
-# define DEBUG1(x) x
-#else
-# define DEBUG1(x)
-#endif
 
-#ifdef DC395x_DEBUGDCB
-# define DCBDEBUG(x) x
-#else
-# define DCBDEBUG(x)
-#endif
+/*
+ * Set set of things to output debugging for.
+ * Undefine to remove all debugging
+ */
+/*#define DEBUG_MASK (DBG_0|DBG_1|DBG_DCB|DBG_PARSE|DBG_SGPARANOIA|DBG_FIFO|DBG_PIO|DBG_TRACE|DBG_TRACEALL)*/
+/*#define  DEBUG_MASK	DBG_0*/
+
+
+/*
+ * Output a kernel mesage at the specified level and append the
+ * driver name and a ": " to the start of the message
+ */
+#define dprintkl(level, format, arg...)  \
+    printk(level DC395X_NAME ": " format , ## arg)
+
+
+#ifdef DEBUG_MASK
+/*
+ * print a debug message - this is formated with KERN_DEBUG, then the
+ * driver name followed by a ": " and then the message is output.
+ * This also checks that the specified debug level is enabled before
+ * outputing the message
+ */
+#define dprintkdbg(type, format, arg...) \
+	do { \
+		if ((type) & (DEBUG_MASK)) \
+			dprintkl(KERN_DEBUG , format , ## arg); \
+	} while (0)
+
+/*
+ * Check if the specified type of debugging is enabled
+ */
+#define debug_enabled(type)	((DEBUG_MASK) & (type))

-#ifdef DC395x_DEBUGPARSE
-# define PARSEDEBUG(x) x
 #else
-# define PARSEDEBUG(x)
+/*
+ * No debugging. Do nothing
+ */
+#define dprintkdbg(type, format, arg...) \
+	do {} while (0)
+#define debug_enabled(type)	(0)
+
 #endif
 
-#ifdef DC395x_DEBUGRECURSION
-# define DEBUGRECURSION(x) x
-#else
-# define DEBUGRECURSION(x)
+
+/*
+ * The recursion debugging just counts entries into the driver and
+ * prints out a messge if it exceeds a certain limit. This variable
+ * hold the count.
+ */
+#if debug_enabled(DBG_RECURSION)
+static int dbg_in_driver = 0;
 #endif
 
-#ifdef DC395x_DEBUGPIO
-# define DEBUGPIO(x) x
+
+/*
+ * Memory allocation debugging
+ * Just reports when memory is allocated and/or released.
+ */
+#if debug_enabled(DBG_MALLOC)
+inline void *dc395x_kmalloc(size_t sz, int fl)
+{
+	void *ptr = kmalloc(sz, fl);
+	dprintkl(KERN_DEBUG, "Alloc %i bytes @ %p w/ fl %08x\n", sz, ptr, fl);
+	return ptr;
+}
+inline void dc395x_kfree(const void *adr)
+{
+	dprintkl(KERN_DEBUG, "Free mem @ %p\n", adr);
+	kfree(adr);
+}
 #else
-# define DEBUGPIO(x)
+#define dc395x_kmalloc(sz, fl)	kmalloc(sz, fl)
+#define dc395x_kfree(adr) kfree(adr)
 #endif

-/* Here comes the joker of all debugging facilities! */
-#ifdef DC395x_DEBUGTRACEALL
-# ifndef DC395x_DEBUGTRACE
-#  define DC395x_DEBUGTRACE
-# endif
+
+/*
+ * Debug/trace stuff
+ */
+#if debug_enabled(DBG_TRACEALL)
 # define TRACEOUTALL(x...) printk ( x)
 #else
 # define TRACEOUTALL(x...) do {} while (0)
 #endif
-#ifdef DC395x_DEBUGTRACE
+
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 # define DEBUGTRACEBUFSZ 512
 char DC395x_tracebuf[64];
 char DC395x_traceoverflow[8] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 # define TRACEPRINTF(x...) \
-do { int ln = sprintf (DC395x_tracebuf, x); \
-     if (pSRB->debugpos + ln >= DEBUGTRACEBUFSZ) \
-     { pSRB->debugtrace[pSRB->debugpos] = 0; pSRB->debugpos = DEBUGTRACEBUFSZ/5; pSRB->debugtrace[pSRB->debugpos++] = '>'; }; \
-     sprintf (pSRB->debugtrace + pSRB->debugpos, "%s", DC395x_tracebuf); \
-     pSRB->debugpos += ln - 1; \
-   } while (0)
-# define TRACEOUT(x...) printk ( x)
+	do { \
+		int ln = sprintf(DC395x_tracebuf, x); \
+		if (pSRB->debugpos + ln >= DEBUGTRACEBUFSZ) { \
+			pSRB->debugtrace[pSRB->debugpos] = 0; \
+			pSRB->debugpos = DEBUGTRACEBUFSZ/5; \
+			pSRB->debugtrace[pSRB->debugpos++] = '>'; \
+		} \
+		sprintf(pSRB->debugtrace + pSRB->debugpos, "%s", DC395x_tracebuf); \
+		pSRB->debugpos += ln - 1; \
+	} while (0)
+# define TRACEOUT(x...) printk (x)
 #else
 # define TRACEPRINTF(x...) do {} while (0)
 # define TRACEOUT(x...) do {} while (0)
 #endif

 
-#ifdef DC395x_DEBUGMALLOC
-inline void *dc395x_kmalloc(size_t sz, int fl)
-{
-	void *ptr = kmalloc(sz, fl);
-	printk(KERN_DEBUG DC395X_NAME ": Alloc %i bytes @ %p w/ fl %08x\n",
-	       sz, ptr, fl);
-	return ptr;
-}
-inline void dc395x_kfree(const void *adr)
-{
-	printk(KERN_DEBUG DC395X_NAME ": Free mem @ %p\n", adr);
-	kfree(adr);
-}
-
-# define KMALLOC(sz,fl) dc395x_kmalloc(sz,fl)
-# define KFREE(adr) dc395x_kfree(adr)
-#else
-# define KMALLOC(sz,fl) kmalloc(sz,fl)
-# define KFREE(adr) kfree(adr)
-#endif
+/*---------------------------------------------------------------------------
+ ---------------------------------------------------------------------------*/

 
 #ifndef PCI_VENDOR_ID_TEKRAM
@@ -284,7 +321,7 @@
 	u8 padding;
 	u16 debugpos;
 	/* Offset 0x58/0x40 */
-#ifdef DC395x_DEBUGTRACE
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	char *debugtrace;
 	/* Offset 0x60/0x44 */
 #endif
@@ -519,8 +556,6 @@
 static u16 DC395x_adapterCnt = 0;
 static u16 DC395x_CurrSyncOffset = 0;
 
-DEBUGRECURSION(static char in_driver = 0;
-    )
 static char DC395x_monitor_next_IRQ = 0;
 
 /*
@@ -603,7 +638,7 @@
 /* Convert EEprom value to seconds */
 static void __init DC395x_interpret_delay(struct NvRamType *eeprom)
 {
-	/*printk (DC395X_NAME ": Debug: Delay: %i\n", eeprom->NvramDelayTime); */
+	/*printk (DC395X_NAME, "Debug: Delay: %i\n", eeprom->NvramDelayTime); */
 	eeprom->NvramDelayTime = DC395x_interpd[eeprom->NvramDelayTime];
 }

@@ -627,7 +662,7 @@
 		dc395x_trm[3] = 0x0f;
 		dc395x_trm[4] = 2;
 		dc395x_trm[5] = 10;
-		printk(KERN_INFO DC395X_NAME ": Using safe settings.\n");
+		dprintkl(KERN_INFO, "Using safe settings.\n");
 	}
 }

@@ -647,13 +682,10 @@
 static void __init DC395x_fill_with_defaults(void)
 {
 	int i;
-	PARSEDEBUG(printk
-		   (KERN_INFO DC395X_NAME
-		    ": setup %08x %08x %08x %08x %08x %08x\n",
+	dprintkdbg(DBG_PARSE, "setup %08x %08x %08x %08x %08x %08x\n",
 		    dc395x_trm[0], dc395x_trm[1], dc395x_trm[2],
 		    dc395x_trm[3], dc395x_trm[4], dc395x_trm[5]);
-	    )
-	    for (i = 0; i < 6; i++) {
+	for (i = 0; i < 6; i++) {
 		if (dc395x_trm[i] < 0 || dc395x_trm[i] > 255)
 			dc395x_trm[i] = dc395x_def[i];
 	}
@@ -679,7 +711,7 @@
 	(void) get_options(str, ARRAY_SIZE(ints), ints);
 	im = ints[0];
 	if (im > 6) {
-		printk(KERN_NOTICE DC395X_NAME ": ignore extra params!\n");
+		dprintkl(KERN_NOTICE, "ignore extra params!\n");
 		im = 6;
 	}
 	for (i = 0; i < im; i++)
@@ -763,10 +795,9 @@
 static void
 DC395x_Query_append(Scsi_Cmnd * cmd, struct AdapterCtlBlk *pACB)
 {
-	DEBUG0(printk(DC395X_NAME ": Append cmd %li to Query\n", cmd->pid);
-	    )
+	dprintkdbg(DBG_0, "Append cmd %li to Query\n", cmd->pid);
 
-	    cmd->host_scribble = NULL;
+	cmd->host_scribble = NULL;

 	if (!pACB->QueryCnt)
 		pACB->pQueryHead = cmd;
@@ -787,9 +818,8 @@
 	pcmd = pACB->pQueryHead;
 	if (!pcmd)
 		return pcmd;
-	DEBUG0(printk(DC395X_NAME ": Get cmd %li from Query\n", pcmd->pid);
-	    )
-	    pACB->pQueryHead = (void *) pcmd->host_scribble;
+	dprintkdbg(DBG_0, "Get cmd %li from Query\n", pcmd->pid);
+	pACB->pQueryHead = (void *) pcmd->host_scribble;
 	pcmd->host_scribble = NULL;
 	if (!pACB->pQueryHead)
 		pACB->pQueryTail = NULL;
@@ -807,7 +837,7 @@
 	/*DC395x_Free_integrity (pACB); */
 	pSRB = pACB->pFreeSRB;
 	if (!pSRB)
-		printk(DC395X_NAME ": Out of Free SRBs :-(\n");
+		dprintkl(KERN_ERR, "Out of Free SRBs :-(\n");
 	if (pSRB) {
 		pACB->pFreeSRB = pSRB->pNextSRB;
 		pSRB->pNextSRB = NULL;
@@ -821,9 +851,8 @@
 static __inline__ void
 DC395x_Free_insert(struct AdapterCtlBlk *pACB, struct ScsiReqBlk *pSRB)
 {
-	DEBUG0(printk(DC395X_NAME ": Free SRB %p\n", pSRB);
-	    )
-	    pSRB->pNextSRB = pACB->pFreeSRB;
+	dprintkdbg(DBG_0, "Free SRB %p\n", pSRB);
+	pSRB->pNextSRB = pACB->pFreeSRB;
 	pACB->pFreeSRB = pSRB;
 }
 
@@ -832,11 +861,8 @@
 static __inline__ void
 DC395x_Waiting_insert(struct DeviceCtlBlk *pDCB, struct ScsiReqBlk *pSRB)
 {
-	DEBUG0(printk
-	       (DC395X_NAME ": Insert pSRB %p cmd %li to Waiting\n", pSRB,
-		pSRB->pcmd->pid);
-	    )
-	    pSRB->pNextSRB = pDCB->pWaitingSRB;
+	dprintkdbg(DBG_0, "Insert pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid);
+	pSRB->pNextSRB = pDCB->pWaitingSRB;
 	if (!pDCB->pWaitingSRB)
 		pDCB->pWaitLast = pSRB;
 	pDCB->pWaitingSRB = pSRB;
@@ -848,11 +874,8 @@
 static __inline__ void
 DC395x_Waiting_append(struct DeviceCtlBlk *pDCB, struct ScsiReqBlk *pSRB)
 {
-	DEBUG0(printk
-	       (DC395X_NAME ": Append pSRB %p cmd %li to Waiting\n", pSRB,
-		pSRB->pcmd->pid);
-	    )
-	    if (pDCB->pWaitingSRB)
+	dprintkdbg(DBG_0, "Append pSRB %p cmd %li to Waiting\n", pSRB, pSRB->pcmd->pid);
+	if (pDCB->pWaitingSRB)
 		pDCB->pWaitLast->pNextSRB = pSRB;
 	else
 		pDCB->pWaitingSRB = pSRB;
@@ -868,10 +891,9 @@
 static __inline__ void
 DC395x_Going_append(struct DeviceCtlBlk *pDCB, struct ScsiReqBlk *pSRB)
 {
-	DEBUG0(printk(DC395X_NAME ": Append SRB %p to Going\n", pSRB);
-	    )
-	    /* Append to the list of Going commands */
-	    if (pDCB->pGoingSRB)
+	dprintkdbg(DBG_0, "Append SRB %p to Going\n", pSRB);
+	/* Append to the list of Going commands */
+	if (pDCB->pGoingSRB)
 		pDCB->pGoingLast->pNextSRB = pSRB;
 	else
 		pDCB->pGoingSRB = pSRB;
@@ -908,8 +930,7 @@
 	if (pre->pNextSRB != pSRB)
 		pre = DC395x_find_SRBpre(pSRB, pre);
 	if (!pre) {
-		printk(DC395X_NAME
-		       ": Internal ERROR: SRB to rmv not found in Q!\n");
+		dprintkl(KERN_ERR, "Internal ERROR: SRB to rmv not found in Q!\n");
 		return 0;
 	}
 	pre->pNextSRB = pSRB->pNextSRB;
@@ -924,10 +945,9 @@
 		    struct ScsiReqBlk *hint)
 {
 	struct ScsiReqBlk *pre = 0;
-	DEBUG0(printk(DC395X_NAME ": Remove SRB %p from Going\n", pSRB);
-	    )
-	    if (!pSRB)
-		printk(DC395X_NAME ": Going_remove %p!\n", pSRB);
+	dprintkdbg(DBG_0, "Remove SRB %p from Going\n", pSRB);
+	if (!pSRB)
+		dprintkl(KERN_ERR, "Going_remove %p!\n", pSRB);
 	if (pSRB == pDCB->pGoingSRB)
 		pDCB->pGoingSRB = pSRB->pNextSRB;
 	else if (hint && hint->pNextSRB == pSRB)
@@ -946,10 +966,9 @@
 		      struct ScsiReqBlk *hint)
 {
 	struct ScsiReqBlk *pre = 0;
-	DEBUG0(printk(DC395X_NAME ": Remove SRB %p from Waiting\n", pSRB);
-	    )
-	    if (!pSRB)
-		printk(DC395X_NAME ": Waiting_remove %p!\n", pSRB);
+	dprintkdbg(DBG_0, "Remove SRB %p from Waiting\n", pSRB);
+	if (!pSRB)
+		dprintkl(KERN_ERR, "Waiting_remove %p!\n", pSRB);
 	if (pSRB == pDCB->pWaitingSRB)
 		pDCB->pWaitingSRB = pSRB->pNextSRB;
 	else if (hint && hint->pNextSRB == pSRB)
@@ -966,13 +985,9 @@
 static void
 DC395x_Going_to_Waiting(struct DeviceCtlBlk *pDCB, struct ScsiReqBlk *pSRB)
 {
-	DEBUG0(printk
-	       (KERN_INFO DC395X_NAME
-		": Going_to_Waiting (SRB %p) pid = %li\n", pSRB,
-		pSRB->pcmd->pid);
-	    )
-	    /* Remove SRB from Going */
-	    DC395x_Going_remove(pDCB, pSRB, 0);
+	dprintkdbg(DBG_0, "Going_to_Waiting (SRB %p) pid = %li\n", pSRB, pSRB->pcmd->pid);
+	/* Remove SRB from Going */
+	DC395x_Going_remove(pDCB, pSRB, 0);
 	TRACEPRINTF("GtW *");
 	/* Insert on top of Waiting */
 	DC395x_Waiting_insert(pDCB, pSRB);
@@ -985,11 +1000,8 @@
 DC395x_Waiting_to_Going(struct DeviceCtlBlk *pDCB, struct ScsiReqBlk *pSRB)
 {
 	/* Remove from waiting list */
-	DEBUG0(printk
-	       (DC395X_NAME ": Remove SRB %p from head of Waiting\n",
-		pSRB);
-	    )
-	    DC395x_Waiting_remove(pDCB, pSRB, 0);
+	dprintkdbg(DBG_0, "Remove SRB %p from head of Waiting\n", pSRB);
+	DC395x_Waiting_remove(pDCB, pSRB, 0);
 	TRACEPRINTF("WtG *");
 	DC395x_Going_append(pDCB, pSRB);
 }
@@ -1059,9 +1071,7 @@
 {
 	unsigned long flags;
 	struct AdapterCtlBlk *pACB = (struct AdapterCtlBlk *) ptr;
-#ifdef DC395x_DEBUG_KG
-	printk(DC395X_NAME ": Debug: Waiting queue woken up by timer.\n");
-#endif
+	dprintkdbg(DBG_KG, "Debug: Waiting queue woken up by timer.\n");
 	DC395x_LOCK_IO(pACB->pScsiHost);
 	DC395x_Waiting_process(pACB);
 	DC395x_UNLOCK_IO(pACB->pScsiHost);
@@ -1138,9 +1148,7 @@
 	u32 request_size;
 	int dir;

-#ifdef DC395x_DEBUG0
-	printk(KERN_INFO DC395X_NAME ": DC395x_BuildSRB..............\n ");
-#endif
+	dprintkdbg(DBG_0, "DC395x_BuildSRB..............\n");
 	/*memset (pSRB, 0, sizeof (struct ScsiReqBlk)); */
 	pSRB->pSRBDCB = pDCB;
 	pSRB->pcmd = pcmd;
@@ -1157,15 +1165,13 @@
 			       pcmd->use_sg, dir);
 		sgp = pSRB->SegmentX;
 		request_size = pcmd->request_bufflen;
-#ifdef DC395x_SGPARANOIA
-		printk(KERN_INFO DC395X_NAME
-		       ": BuildSRB: Bufflen = %d, buffer = %p, use_sg = %d\n",
+		dprintkdbg(DBG_SGPARANOIA, 
+		       "BuildSRB: Bufflen = %d, buffer = %p, use_sg = %d\n",
 		       pcmd->request_bufflen, pcmd->request_buffer,
 		       pcmd->use_sg);
-		printk(KERN_INFO DC395X_NAME
-		       ": Mapped %i Segments to %i\n", pcmd->use_sg,
+		dprintkdbg(DBG_SGPARANOIA, 
+		       "Mapped %i Segments to %i\n", pcmd->use_sg,
 		       pSRB->SRBSGCount);
-#endif
 		sl = (struct scatterlist *) pcmd->request_buffer;

 		pSRB->virt_addr = page_address(sl->page);
@@ -1175,18 +1181,16 @@
 			sgp[i].address = busaddr;
 			sgp[i].length = seglen;
 			len += seglen;
-#ifdef DC395x_SGPARANOIA
-			printk(KERN_INFO DC395X_NAME
-			       ": Setting up sgp %d, address = 0x%08x, length = %d, tot len = %d\n",
+			dprintkdbg(DBG_SGPARANOIA,
+			       "Setting up sgp %d, address = 0x%08x, length = %d, tot len = %d\n",
 			       i, busaddr, seglen, len);
-#endif
 		}
 		sgp += max - 1;
 		/* Fixup for last buffer too big as it is allocated on even page boundaries */
 		if (len > request_size) {
-#if defined(DC395x_DEBUG_KG) || defined (DC395x_SGPARANOIA)
-			printk(KERN_INFO DC395X_NAME
-			       ": Fixup SG total length: %d->%d, last seg %d->%d\n",
+#if debug_enabled(DBG_KG) || debug_enabled(DBG_SGPARANOIA)
+			dprintkdbg(DBG_KG|DBG_SGPARANOIA,
+			       "Fixup SG total length: %d->%d, last seg %d->%d\n",
 			       len, request_size, sgp->length,
 			       sgp->length - (len - request_size));
 #endif
@@ -1205,13 +1209,11 @@
 				   sizeof(struct SGentry) *
 				   DC395x_MAX_SG_LISTENTRY,
 				   PCI_DMA_TODEVICE);
-#ifdef DC395x_SGPARANOIA
-		printk(DC395X_NAME
-		       ": Map SG descriptor list %p (%05x) to %08x\n",
+		dprintkdbg(DBG_SGPARANOIA,
+		       "Map SG descriptor list %p (%05x) to %08x\n",
 		       pSRB->SegmentX,
 		       sizeof(struct SGentry) * DC395x_MAX_SG_LISTENTRY,
 		       pSRB->SRBSGBusAddr);
-#endif
 	} else {
 		if (pcmd->request_buffer && dir != PCI_DMA_NONE) {
 			u32 len = pcmd->request_bufflen;	/* Actual request size */
@@ -1226,23 +1228,19 @@
 			pSRB->SRBTotalXferLength = len;
 			pSRB->virt_addr = pcmd->request_buffer;
 			pSRB->SRBSGBusAddr = 0;
-#ifdef DC395x_SGPARANOIA
-			printk(KERN_INFO DC395X_NAME
-			       ": BuildSRB: len = %d, buffer = %p, use_sg = %d, map %08x\n",
+			dprintkdbg(DBG_SGPARANOIA,
+			       "BuildSRB: len = %d, buffer = %p, use_sg = %d, map %08x\n",
 			       len, pcmd->request_buffer, pcmd->use_sg,
 			       pSRB->SegmentX[0].address);
-#endif
 		} else {
 			pSRB->SRBSGCount = 0;
 			pSRB->SRBTotalXferLength = 0;
 			pSRB->SRBSGBusAddr = 0;
 			pSRB->virt_addr = 0;
-#ifdef DC395x_SGPARANOIA
-			printk(KERN_INFO DC395X_NAME
-			       ": BuildSRB: buflen = %d, buffer = %p, use_sg = %d, NOMAP %08x\n",
+			dprintkdbg(DBG_SGPARANOIA,
+			       "BuildSRB: buflen = %d, buffer = %p, use_sg = %d, NOMAP %08x\n",
 			       pcmd->bufflen, pcmd->request_buffer,
 			       pcmd->use_sg, pSRB->SegmentX[0].address);
-#endif
 		}
 	}

@@ -1255,16 +1253,15 @@
 	pSRB->SRBState = 0;
 	pSRB->RetryCnt = 0;

-#if DC395x_SGPARANOIA
-	if ((unsigned long) pSRB->debugtrace & (DEBUGTRACEBUFSZ - 1)) {
-		printk(DC395X_NAME
-		       ": SRB %i (%p): debugtrace %p corrupt!\n",
-		       (pSRB -
-			pDCB->pDCBACB->SRB_array) /
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL) && debug_enabled(DBG_SGPARANOIA)
+	if ((unsigned long)pSRB->debugtrace & (DEBUGTRACEBUFSZ - 1)) {
+		dprintkdbg(DBG_SGPARANOIA,
+			"SRB %i (%p): debugtrace %p corrupt!\n",
+		       (pSRB - pDCB->pDCBACB->SRB_array) /
 		       sizeof(struct ScsiReqBlk), pSRB, pSRB->debugtrace);
 	}
 #endif
-#ifdef DC395x_TRACEDEBUG
+#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 	pSRB->debugpos = 0;
 	pSRB->debugtrace = 0;
 #endif
@@ -1303,8 +1300,7 @@
 				   pcmd->device->lun);
 		if (!pDCB) {
 			DC395x_Free_insert(pACB, pSRB);
-			printk(KERN_ERR DC395X_NAME
-			       ": Command in queue to non-existing device!\n");
+			dprintkl(KERN_ERR, "Command in queue to non-existing device!\n");
 			pcmd->result =
 			    MK_RES(DRIVER_ERROR, DID_ERROR, 0, 0);
 			/*DC395x_UNLOCK_ACB_NI; */
@@ -1343,55 +1339,55 @@
 	    (struct AdapterCtlBlk *) cmd->device->host->hostdata;
 

-	DEBUG0(			/*  if(pACB->scan_devices) */
-		      printk(KERN_INFO DC395X_NAME
-			     ": Queue Cmd=%02x,Tgt=%d,LUN=%d (pid=%li)\n",
-			     cmd->cmnd[0], cmd->device->id,
-			     cmd->device->lun, cmd->pid);
-	    )
-
-	    DEBUGRECURSION(if (in_driver++ > NORM_REC_LVL)
-			   printk(DC395X_NAME
-				  ": %i queue_command () recursion? (pid=%li)\n",
-				  in_driver, cmd->pid);)
+	dprintkdbg(DBG_0, "Queue Cmd=%02x,Tgt=%d,LUN=%d (pid=%li)\n",
+		cmd->cmnd[0], cmd->device->id,
+		cmd->device->lun, cmd->pid);
+
+#if debug_enabled(DBG_RECURSION)
+	if (dbg_in_driver++ > NORM_REC_LVL) {
+		dprintkl(KERN_DEBUG,
+			": %i queue_command () recursion? (pid=%li)\n",
+			dbg_in_driver, cmd->pid);
+	}
+#endif
 
-		/* Assume BAD_TARGET; will be cleared later */
-		cmd->result = DID_BAD_TARGET << 16;
+	/* Assume BAD_TARGET; will be cleared later */
+	cmd->result = DID_BAD_TARGET << 16;

 	if ((cmd->device->id >= pACB->pScsiHost->max_id)
 	    || (cmd->device->lun >= pACB->pScsiHost->max_lun)
 	    || (cmd->device->lun >31)) {
-		/*      printk (KERN_INFO DC395X_NAME "Ignore target %d lun %d\n",
+		/*      dprintkl(KERN_INFO, "Ignore target %d lun %d\n",
 		   cmd->device->id, cmd->device->lun); */
-		DEBUGRECURSION(in_driver--;
-		    )
-		    /*return 1; */
-		    done(cmd);
+#if debug_enabled(DBG_RECURSION)
+		dbg_in_driver--
+#endif
+		/*return 1; */
+		done(cmd);
 		return 0;
 	}

 	if (!(pACB->DCBmap[cmd->device->id] & (1 << cmd->device->lun))) {
-		printk(KERN_INFO DC395X_NAME
-		       ": Ignore target %02x lun %02x\n", cmd->device->id,
+		dprintkl(KERN_INFO, "Ignore target %02x lun %02x\n", cmd->device->id,
 		       cmd->device->lun);
 		/*return 1; */
-		DEBUGRECURSION(in_driver--;
-		    )
-		    done(cmd);
+#if debug_enabled(DBG_RECURSION)
+		dbg_in_driver--
+#endif
+		done(cmd);
 		return 0;
 	} else {
 		pDCB =
 		    DC395x_findDCB(pACB, cmd->device->id,
 				   cmd->device->lun);
 		if (!pDCB) {	/* should never happen */
-			printk(KERN_ERR DC395X_NAME
-			       ": no DCB failed, target %02x lun %02x\n",
+			dprintkl(KERN_ERR, "no DCB failed, target %02x lun %02x\n",
 			       cmd->device->id, cmd->device->lun);
-			printk(DC395X_NAME
-			       ": No DCB in queuecommand (2)!\n");
-			DEBUGRECURSION(in_driver--;
-			    )
-			    return 1;
+			dprintkl(KERN_ERR, "No DCB in queuecommand (2)!\n");
+#if debug_enabled(DBG_RECURSION)
+			dbg_in_driver--
+#endif
+			return 1;
 		}
 	}


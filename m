From: Jamie Lenehan <lenehan@twibble.org>
Subject: Re: Tekram DC390(T) and linux 2.6
Date: Thu, 18 Sep 2003 08:54:36 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030917225435.GA933@twibble.org>
References: <1063831452.698.8.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:30676 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262896AbTIQWyv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Sep 2003 18:54:51 -0400
Content-Disposition: inline
In-Reply-To: <1063831452.698.8.camel@localhost>
List-Id: linux-scsi@vger.kernel.org
To: Michael Schl?ter <michael@johalla.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 17, 2003 at 10:44:13PM +0200, Michael Schl?ter wrote:
> Hi,,
> 
> is there anybody working on porting the Tekram DC390(T) driver to linux
> 2.6? If not I'll try it :).

There's been no work done on the driver for a long time. The last
time someone asked about the driver I took a quick look at it. I've
attached the patch I made to get it mostly fixed up - this patch
delete the entire write part of the proc support, but I don't think
that's a major problem (I did the same to the dc395x driver). The
main thing remaining to be done is to convert to the dma mapping api
and check the error handling. Would be nice to convert to hotplug
style driver as well.

Note that this driver was written by the same people as the dc395x
driver, so it may help looking at that driver (although I've changed
it so much that current version no longer look all that alike
anymore). For the DMA mapping stuff looking at where it was added to
the dc395x driver (in the 1.4 series of the driver) might be helpful.
See http://www.garloff.de/kurt/linux/dc395/ for the older dc395x
drivers.


diff -du -r a/drivers/scsi/scsiiom.c b/drivers/scsi/scsiiom.c
--- a/drivers/scsi/scsiiom.c	2003-09-18 08:45:20.457697790 +1000
+++ b/drivers/scsi/scsiiom.c	2003-09-18 08:44:32.792138772 +1000
@@ -213,7 +213,7 @@
 };
 #endif
 
-void __inline__
+irqreturn_t
 DC390_Interrupt( int irq, void *dev_id, struct pt_regs *regs)
 {
     PACB   pACB, pACB2;
@@ -227,21 +227,24 @@
     UCHAR  dstatus;
 #endif
     DC390_AFLAGS DC390_IFLAGS //DC390_DFLAGS
+    irqreturn_t handled = IRQ_NONE;
+            
 
     pACB = (PACB)dev_id;
     for (pACB2 = dc390_pACB_start; (pACB2 && pACB2 != pACB); pACB2 = pACB2->pNextACB);
     if (!pACB2)
     {
 	printk ("DC390: IRQ called with foreign dev_id %p!\n", pACB);
-	return;
+	return handled;
     }
     
     //DC390_LOCK_DRV;
 
     sstatus = DC390_read8 (Scsi_Status);
     if( !(sstatus & INTERRUPT) )
-	{ /*DC390_UNLOCK_DRV;*/ return; };
+	{ /*DC390_UNLOCK_DRV;*/ return handled; };
 
+    handled = IRQ_HANDLED;
     DEBUG1(printk (KERN_DEBUG "sstatus=%02x,", sstatus);)
 
 #if DMA_INT
@@ -256,7 +259,7 @@
       {
 	DEBUG0(printk (KERN_WARNING "DC390 Int w/o SCSI actions (only DMA?)\n");)
 	//DC390_UNLOCK_DRV;
-	return;
+	return handled;
       };
 #else
     //DC390_write32 (DMA_ScsiBusCtrl, WRT_ERASE_DMA_STAT | EN_INT_ON_PCI_ABORT);
@@ -342,15 +345,18 @@
     DC390_UNLOCK_ACB;
     DC390_UNLOCK_IO;
     //DC390_UNLOCK_DRV; /* Restore initial flags */
+    return handled;
 }
 
-void
+irqreturn_t
 do_DC390_Interrupt( int irq, void *dev_id, struct pt_regs *regs)
 {
+    irqreturn_t handled;
     DEBUG1(printk (KERN_INFO "DC390: Irq (%i) caught: ", irq);)
     /* Locking is done in DC390_Interrupt */
-    DC390_Interrupt(irq, dev_id, regs);
+    handled = DC390_Interrupt(irq, dev_id, regs);
     DEBUG1(printk (".. IRQ returned\n");)
+    return handled;
 }
 
 void
diff -du -r a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	2003-09-18 08:44:55.584580638 +1000
+++ b/drivers/scsi/tmscsim.c	2003-09-18 08:44:32.799137680 +1000
@@ -457,7 +457,7 @@
 static void __inline__ dc390_InvalidCmd( PACB pACB );
 static void __inline__ dc390_EnableMsgOut_Abort (PACB, PSRB);
 static void dc390_remove_dev (PACB pACB, PDCB pDCB);
-void do_DC390_Interrupt( int, void *, struct pt_regs *);
+irqreturn_t do_DC390_Interrupt( int, void *, struct pt_regs *);
 
 int    dc390_initAdapter( PSH psh, ULONG io_port, UCHAR Irq, UCHAR index );
 void   dc390_initDCB( PACB pACB, PDCB *ppDCB, UCHAR id, UCHAR lun);
@@ -869,12 +869,12 @@
     if( !pACB->QueryCnt )
 	pACB->pQueryHead = cmd;
     else
-	pACB->pQueryTail->next = cmd;
+	pACB->pQueryTail->host_scribble = (void*)cmd;
 
     pACB->pQueryTail = cmd;
     pACB->QueryCnt++;
     pACB->CmdOutOfSRB++;
-    cmd->next = NULL;
+    cmd->host_scribble = NULL;
 }
 
 
@@ -886,8 +886,8 @@
     pcmd = pACB->pQueryHead;
     if (!pcmd) return pcmd;
     DEBUG0(printk ("DC390: Get cmd %li from Query\n", pcmd->pid);)
-    pACB->pQueryHead = pcmd->next;
-    pcmd->next = NULL;
+    pACB->pQueryHead = (Scsi_Cmnd*)pcmd->host_scribble;
+    pcmd->host_scribble = NULL;
     if (!pACB->pQueryHead) pACB->pQueryTail = NULL;
     pACB->QueryCnt--;
     return( pcmd );
@@ -1071,11 +1071,11 @@
 	DC390_IFLAGS
 	DC390_AFLAGS
 	DEBUG0(printk ("DC390: Debug: Waiting queue woken up by timer!\n");)
-	DC390_LOCK_IO(pACB.pScsiHost);
+	DC390_LOCK_IO(pACB->pScsiHost);
 	DC390_LOCK_ACB;
 	dc390_Waiting_process (pACB);
 	DC390_UNLOCK_ACB;
-	DC390_UNLOCK_IO(pACB.pScsiHost);
+	DC390_UNLOCK_IO(pACB->pScsiHost);
 }
 
 /***********************************************************************
@@ -1561,8 +1561,8 @@
 	if( pcmd == cmd )
 	{
 	    /* Found: Dequeue */
-	    pACB->pQueryHead = pcmd->next;
-	    pcmd->next = NULL;
+	    pACB->pQueryHead = (Scsi_Cmnd*)pcmd->host_scribble;
+	    pcmd->host_scribble = NULL;
 	    if (cmd == pACB->pQueryTail) pACB->pQueryTail = NULL;
 	    pACB->QueryCnt--;
 	    status = SCSI_ABORT_SUCCESS;
@@ -1570,10 +1570,10 @@
 	}
 	for( count = pACB->QueryCnt, i=0; i<count-1; i++)
 	{
-	    if( pcmd->next == cmd )
+	    if( (Scsi_Cmnd*)pcmd->host_scribble == cmd )
 	    {
-		pcmd->next = cmd->next;
-		cmd->next = NULL;
+		pcmd->host_scribble = cmd->host_scribble;
+		cmd->host_scribble = NULL;
 		if (cmd == pACB->pQueryTail) pACB->pQueryTail = NULL;
 		pACB->QueryCnt--;
 		status = SCSI_ABORT_SUCCESS;
@@ -1581,7 +1581,7 @@
 	    }
 	    else
 	    {
-		pcmd = pcmd->next;
+		pcmd = (Scsi_Cmnd*)pcmd->host_scribble;
 	    }
 	}
     }
@@ -1624,7 +1624,7 @@
 IN_WAIT:
 	dc390_Free_insert (pACB, pSRB);
 	pDCB->WaitSRBCnt--;
-	cmd->next = NULL;
+	cmd->host_scribble = NULL;
 	status = SCSI_ABORT_SUCCESS;
 	goto  ABO_X;
     }
@@ -1781,7 +1781,7 @@
  * Returns : 0 on success.
  ***********************************************************************/
 
-int DC390_reset (Scsi_Cmnd *cmd, unsigned int resetFlags)
+int DC390_reset (Scsi_Cmnd *cmd)
 {
     UCHAR   bval;
     DC390_AFLAGS
@@ -1943,24 +1943,6 @@
 
 
 /***********************************************************************
- * Function : static void dc390_updateDCBs ()
- *
- * Purpose :  Set the configuration dependent DCB params for all DCBs
- ***********************************************************************/
-
-static void dc390_updateDCBs (PACB pACB)
-{
-  int i;
-  PDCB pDCB = pACB->pLinkDCB;
-  for (i = 0; i < pACB->DCBCnt; i++)
-    {
-      dc390_updateDCB (pACB, pDCB);
-      pDCB = pDCB->pNextDCB;
-    };
-};
-  
-
-/***********************************************************************
  * Function : static void dc390_initSRB()
  *
  * Purpose :  initialize the internal structures for a given SRB
@@ -2088,14 +2070,11 @@
     int    i;
     
     pACB = (PACB) psh->hostdata;
-    
-    if (check_region (io_port, psh->n_io_port))
-	{
-	    printk(KERN_ERR "DC390: register IO ports error!\n");
-	    return( -1 );
-	}
-    else
-	request_region (io_port, psh->n_io_port, "tmscsim");
+
+    if (!request_region(io_port, psh->n_io_port, "tmscsim")) {
+	    printk(KERN_ERR "DC390: Failed to reserver IO region!\n");
+	    return -1;
+    }
 
     DC390_read8_ (INT_Status, io_port);		/* Reset Pending INT */
 
@@ -2347,482 +2326,7 @@
 }
 
 
-/***********************************************************************
- * Functions: dc390_inquiry(), dc390_inquiry_done()
- *
- * Purpose: When changing speed etc., we have to issue an INQUIRY
- *	    command to make sure, we agree upon the nego parameters
- *	    with the device
- ***********************************************************************/
-
-static void dc390_inquiry_done (Scsi_Cmnd* cmd)
-{
-   printk (KERN_INFO "DC390: INQUIRY (ID %02x LUN %02x) returned %08x\n",
-	   cmd->device->id, cmd->device->lun, cmd->result);
-   if (cmd->result)
-   {
-	PACB pACB = (PACB)cmd->device->host->hostdata;
-	PDCB pDCB = dc390_findDCB (pACB, cmd->device->id, cmd->device->lun);
-	printk ("DC390: Unsetting DsCn, Sync and TagQ!\n");
-	if (pDCB)
-	{
-		pDCB->DevMode &= ~(SYNC_NEGO_ | TAG_QUEUEING_ | EN_DISCONNECT_ );
-		dc390_updateDCB (pACB, pDCB);
-	};
-   };
-   kfree (cmd);
-};
-
-void dc390_inquiry (PACB pACB, PDCB pDCB)
-{
-   char* buffer;
-   Scsi_Cmnd* cmd;
-   cmd = kmalloc (sizeof(Scsi_Cmnd) + 256, GFP_ATOMIC);
-   if (!cmd) { printk ("DC390: kmalloc failed in inquiry!\n"); return; };
-   buffer = (char*)cmd + sizeof(Scsi_Cmnd);
-
-   memset (cmd, 0, sizeof(Scsi_Cmnd) + 256);
-   cmd->cmnd[0] = INQUIRY;
-   cmd->cmnd[1] = (pDCB->TargetLUN << 5) & 0xe0;
-   cmd->cmnd[4] = 0xff;
-   
-   cmd->cmd_len = 6; cmd->old_cmd_len = 6;
-/* TODO FIXME */
-/*    cmd->host = pACB->pScsiHost; */
-   cmd->device->id = pDCB->TargetID;
-   cmd->device->lun = pDCB->TargetLUN; 
-   cmd->serial_number = 1;
-   cmd->pid = 390;
-   cmd->bufflen = 128;
-   cmd->buffer = buffer;
-   cmd->request_bufflen = 128;
-   cmd->request_buffer = &buffer[128];
-   cmd->done = dc390_inquiry_done;
-   cmd->scsi_done = dc390_inquiry_done;
-   cmd->timeout_per_command = HZ;
-
-   cmd->request.rq_status = RQ_SCSI_BUSY;
-
-   pDCB->SyncMode &= ~SYNC_NEGO_DONE;
-   printk (KERN_INFO "DC390: Queue INQUIRY command to dev ID %02x LUN %02x\n",
-	   pDCB->TargetID, pDCB->TargetLUN);
-   DC390_queue_command (cmd, dc390_inquiry_done);
-};
-
-/***********************************************************************
- * Functions: dc390_sendstart(), dc390_sendstart_done()
- *
- * Purpose: When changing speed etc., we have to issue an INQUIRY
- *	    command to make sure, we agree upon the nego parameters
- *	    with the device
- ***********************************************************************/
-
-static void dc390_sendstart_done (Scsi_Cmnd* cmd)
-{
-   printk (KERN_INFO "DC390: SENDSTART (ID %02x LUN %02x) returned %08x\n",
-	   cmd->device->id, cmd->device->lun, cmd->result);
-   kfree (cmd);
-};
-
-void dc390_sendstart (PACB pACB, PDCB pDCB)
-{
-   char* buffer;
-   Scsi_Cmnd* cmd;
-   cmd = kmalloc (sizeof(Scsi_Cmnd) + 256, GFP_ATOMIC);
-   if (!cmd) { printk ("DC390: kmalloc failed in sendstart!\n"); return; };
-   buffer = (char*)cmd + sizeof(Scsi_Cmnd);
-
-   memset (cmd, 0, sizeof(Scsi_Cmnd) + 256);
-   cmd->cmnd[0] = 0x1b; /* START_STOP_UNIT */
-   cmd->cmnd[1] = (pDCB->TargetLUN << 5) & 0xe0;
-   cmd->cmnd[4] = 0x01; /* START */
-   
-   cmd->cmd_len = 6; cmd->old_cmd_len = 6;
-/* TODO FIXME */
-/*    cmd->host = pACB->pScsiHost; */
-   cmd->device->id = pDCB->TargetID;
-   cmd->device->lun = pDCB->TargetLUN; 
-   cmd->serial_number = 1;
-   cmd->pid = 310;
-   cmd->bufflen = 128;
-   cmd->buffer = buffer;
-   cmd->request_bufflen = 128;
-   cmd->request_buffer = &buffer[128];
-   cmd->done = dc390_sendstart_done;
-   cmd->scsi_done = dc390_sendstart_done;
-   cmd->timeout_per_command = 5*HZ;
-
-   cmd->request.rq_status = RQ_SCSI_BUSY;
 
-   pDCB->SyncMode &= ~SYNC_NEGO_DONE;
-   printk (KERN_INFO "DC390: Queue SEND_START command to dev ID %02x LUN %02x\n",
-	   pDCB->TargetID, pDCB->TargetLUN);
-   DC390_queue_command (cmd, dc390_sendstart_done);
-};
-
-/********************************************************************
- * Function: dc390_set_info()
- *
- * Purpose: Change adapter config
- *
- * Strings are parsed similar to the output of tmscsim_proc_info ()
- * '-' means no change
- *******************************************************************/
-
-static int dc390_scanf (char** buffer, char** pos, char** p0, int* var)
-{
-   *p0 = *pos;
-   *var = simple_strtoul (*p0, pos, 10);
-   if (*p0 == *pos) return -1;
-   *pos = strsep (buffer, " \t\n:=,;.");
-   return 0;
-};
-
-#define SCANF(buffer, pos, p0, var, min, max)		\
-if (dc390_scanf (&buffer, &pos, &p0, &var)) goto einv;	\
-else if (var<min || var>max) goto einv2
-
-static int dc390_yesno (char** buffer, char** pos, char* var, char bmask)
-{
-   switch (**pos)
-     {
-      case 'Y': *var |= bmask; break;
-      case 'N': *var &= ~bmask; break;
-      case '-': break;
-      default: return -1;
-     }
-   *pos = strsep (buffer, " \t\n:=,;");
-   return 0;
-};
-
-#define YESNO(buffer, pos, var, bmask)			\
-if (dc390_yesno (&buffer, &pos, &var, bmask)) goto einv;	\
-else dc390_updateDCB (pACB, pDCB);		\
-if (!p) goto ok
-
-static int dc390_search (char** buffer, char** pos, char** p0, char* var, char* txt, int max, int scale, char* ign)
-{
-   int dum;
-   if (! memcmp (*pos, txt, strlen(txt)))
-     {
-	*p0 = strsep (buffer, " \t\n:=,;");
-	if (!*p0) return -1;
-	dum = simple_strtoul (*p0, pos, 10);
-	if (*p0 == *pos) return -1;
-	if (dum >= 0 && dum <= max) 
-	  { *var = (dum * 100) / scale; }
-	else return -2;
-	*pos = strsep (buffer, " \t\n:=,;");
-	if (*ign && *pos && strlen(*pos) >= strlen(ign) && 
-	    !(memcmp (*pos, ign, strlen(ign)))) 
-		*pos = strsep (buffer, " \t\n:=,;");
-
-     }
-   return 0;
-};
-
-#define SEARCH(buffer, pos, p0, var, txt, max)						\
-if (dc390_search (&buffer, &pos, &p0, (PUCHAR)(&var), txt, max, 100, "")) goto einv2;	\
-else if (!p1) goto ok2
-
-#define SEARCH2(buffer, pos, p0, var, txt, max, scale)					\
-if (dc390_search (&buffer, &pos, &p0, &var, txt, max, scale, "")) goto einv2; 		\
-else if (!p1) goto ok2
-
-#define SEARCH3(buffer, pos, p0, var, txt, max, scale, ign)				\
-if (dc390_search (&buffer, &pos, &p0, &var, txt, max, scale, ign)) goto einv2;		\
-else if (!p1) goto ok2
-
-
-#ifdef DC390_PARSEDEBUG
-static char _prstr[256];
-char* prstr (char* p, char* e)
-{
-   char* c = _prstr;
-   while (p < e)
-     if (*p == 0) { *c++ = ':'; p++; }
-     else if (*p == 10) { *c++ = '\\'; *c++ = 'n'; p++; }
-     else *c++ = *p++;
-   *c = 0;
-   return _prstr;
-};
-#endif
-
-int dc390_set_info (char *buffer, int length, PACB pACB)
-{
-  char *pos = buffer, *p0 = buffer;
-  char needs_inquiry = 0; 
-  int dum = 0;
-  char dev;
-  PDCB pDCB = pACB->pLinkDCB;
-  DC390_IFLAGS
-  DC390_AFLAGS 
-  pos[length] = 0;
-
-  DC390_LOCK_IO(pACB.pScsiHost);
-  DC390_LOCK_ACB;
-  /* UPPERCASE */ 
-  /* Don't use kernel toupper, because of 2.0.x bug: ctmp unexported */
-  while (*pos) 
-    { if (*pos >='a' && *pos <= 'z') *pos = *pos + 'A' - 'a'; pos++; };
-  
-  /* Remove WS */
-  pos = strsep (&buffer, " \t:\n=,;");
-  if (!*pos) goto ok;
-   
- next:
-  if (!memcmp (pos, "RESET", 5)) goto reset;
-  else if (!memcmp (pos, "INQUIRY", 7)) goto inquiry;
-  else if (!memcmp (pos, "REMOVE", 6)) goto remove;
-  else if (!memcmp (pos, "ADD", 3)) goto add;
-  else if (!memcmp (pos, "START", 5)) goto start;
-  else if (!memcmp (pos, "DUMP", 4)) goto dump;
-  
-  if (isdigit (*pos))
-    {
-      /* Device config line */
-      int dev, id, lun; char* pdec;
-      char olddevmode;
-      
-      SCANF (buffer, pos, p0, dev, 0, pACB->DCBCnt-1);
-      if (*pos) { SCANF (buffer, pos, p0, id, 0, 7); } else goto einv;
-      if (*pos) { SCANF (buffer, pos, p0, lun, 0, 7); } else goto einv;
-      if (!*pos) goto einv;
-      
-      PARSEDEBUG(printk (KERN_INFO "DC390: config line %i %i %i:\"%s\"\n", dev, id, lun, prstr (pos, &buffer[length]));)
-      pDCB = pACB->pLinkDCB;
-      for (dum = 0; dum < dev; dum++) pDCB = pDCB->pNextDCB;
-      /* Sanity Check */
-      if (pDCB->TargetID != id || pDCB->TargetLUN != lun) 
-	 {
-	    printk (KERN_ERR "DC390: no such device: Idx=%02i ID=%02i LUN=%02i\n",
-		    dev, id, lun);
-	    goto einv2;
-	 };
-
-      if (pDCB->pWaitingSRB || pDCB->pGoingSRB)
-      {
-	  printk ("DC390: Cannot change dev (%i-%i) cfg: Pending requests\n",
-		  pDCB->TargetID, pDCB->TargetLUN);
-	  goto einv;
-      };
-	  
-      olddevmode = pDCB->DevMode;
-      YESNO (buffer, pos, pDCB->DevMode, PARITY_CHK_);
-      needs_inquiry++;
-      YESNO (buffer, pos, pDCB->DevMode, SYNC_NEGO_);
-      if ((olddevmode & SYNC_NEGO_) == (pDCB->DevMode & SYNC_NEGO_)) needs_inquiry--;
-      needs_inquiry++;
-      YESNO (buffer, pos, pDCB->DevMode, EN_DISCONNECT_);
-      if ((olddevmode & EN_DISCONNECT_) == (pDCB->DevMode & EN_DISCONNECT_)) needs_inquiry--;
-      YESNO (buffer, pos, pDCB->DevMode, SEND_START_);
-      needs_inquiry++;
-      YESNO (buffer, pos, pDCB->DevMode, TAG_QUEUEING_);
-      if ((olddevmode & TAG_QUEUEING_) == (pDCB->DevMode & TAG_QUEUEING_)) needs_inquiry--;
-
-      dc390_updateDCB (pACB, pDCB);
-      if (!*pos) goto ok;
-       
-      olddevmode = pDCB->NegoPeriod;
-      /* Look for decimal point (Speed) */
-      pdec = pos; 
-      while (pdec++ < &buffer[length]) if (*pdec == '.') break;
-      /* NegoPeriod */
-      if (*pos != '-')
-	{
-	  SCANF (buffer, pos, p0, dum, 72, 800); 
-	  pDCB->NegoPeriod = dum >> 2;
-	  if (pDCB->NegoPeriod != olddevmode) needs_inquiry++;
-	  if (!pos) goto ok;
-	  if (memcmp (pos, "NS", 2) == 0) pos = strsep (*pos, " \t\n:=,;.");
-	}
-      else pos = strsep (*pos, " \t\n:=,;.");
-      if (!*pos) goto ok;
-      
-      /* Sync Speed in MHz */
-      if (*pos != '-')
-	{
-	  SCANF (buffer, pos, p0, dum, 1, 13); 
-	  pDCB->NegoPeriod = (1000/dum) >> 2;
-	  if (pDCB->NegoPeriod != olddevmode && !pos) needs_inquiry++;
-	  if (!*pos) goto ok;
-	  /* decimal */
-	  if (pos-1 == pdec)
-	     {
-		int dumold = dum;
-		dum = simple_strtoul (pos, &p0, 10) * 10;
-		for (; p0-pos > 1; p0--) dum /= 10;
-		pDCB->NegoPeriod = (100000/(100*dumold + dum)) >> 2;
-		if (pDCB->NegoPeriod < 19) pDCB->NegoPeriod = 19;
-		pos = strsep (*pos, " \t\n:=,;");
-		if (!*pos) goto ok;
-	     };
-	  if (*pos == 'M') pos = strsep (*pos, " \t\n:=,;");
-	  if (pDCB->NegoPeriod != olddevmode) needs_inquiry++;
-	}
-      else pos = strsep (*pos, " \t\n:=,;");
-      /* dc390_updateDCB (pACB, pDCB); */
-      if (!*pos) goto ok;
-
-      olddevmode = pDCB->SyncOffset;
-      /* SyncOffs */
-      if (*pos != '-')
-	{
-	  SCANF (buffer, pos, p0, dum, 0, 0x0f); 
-	  pDCB->SyncOffset = dum;
-	  if (pDCB->SyncOffset > olddevmode) needs_inquiry++;
-	}
-      else pos = strsep (*pos, " \t\n:=,;");
-      if (!*pos) goto ok;
-      dc390_updateDCB (pACB, pDCB);
-
-      //olddevmode = pDCB->MaxCommand;
-      /* MaxCommand (Tags) */
-      if (*pos != '-')
-	{
-	  SCANF (buffer, pos, p0, dum, 1, 32 /*pACB->TagMaxNum*/);
-	  if (pDCB->SyncMode & EN_TAG_QUEUEING)
-		pDCB->MaxCommand = dum;
-	  else printk (KERN_INFO "DC390: Can't set MaxCmd larger than one without Tag Queueing!\n");
-	}
-      else pos = strsep (*pos, " \t\n:=,;");
-
-    }
-  else
-    {
-      char* p1 = pos; UCHAR dum, newadaptid;
-      PARSEDEBUG(printk (KERN_INFO "DC390: chg adapt cfg \"%s\"\n", prstr (pos, &buffer[length]));)
-      dum = GLITCH_TO_NS (pACB->glitch_cfg);
-      /* Adapter setting */
-      SEARCH (buffer, pos, p0, pACB->pScsiHost->max_id, "MAXID", 8); 
-      SEARCH (buffer, pos, p0, pACB->pScsiHost->max_lun, "MAXLUN", 8); 
-      SEARCH (buffer, pos, p0, newadaptid, "ADAPTERID", 7);
-      SEARCH (buffer, pos, p0, pACB->TagMaxNum, "TAGMAXNUM", 32);
-      SEARCH (buffer, pos, p0, pACB->ACBFlag, "ACBFLAG", 255);
-      SEARCH3 (buffer, pos, p0, dum, "GLITCHEATER", 40, 1000, "NS");
-      SEARCH3 (buffer, pos, p0, pACB->sel_timeout, "SELTIMEOUT", 400, 163, "MS");
-      SEARCH3 (buffer, pos, p0, dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY], "DELAYRESET", 180, 100, "S");
-    ok2:
-      pACB->glitch_cfg = NS_TO_GLITCH (dum);
-      if (pACB->sel_timeout < 60) pACB->sel_timeout = 60;
-      DC390_write8 (Scsi_TimeOut, pACB->sel_timeout);
-      if (newadaptid != pACB->pScsiHost->this_id)
-      {
-	pACB->pScsiHost->this_id = newadaptid;
-	dc390_ResetDevParam (pACB);
-      }	    
-      //dum = 0; while (1 << dum <= pACB->TagMaxNum) dum ++;
-      //pACB->TagMaxNum &= (1 << --dum);
-      dc390_updateDCBs (pACB);
-      // All devs should be INQUIRED now
-      if (pos == p1) goto einv;
-    }
-  if (*pos) goto next;
-      
- ok:
-  DC390_UNLOCK_ACB;
-  if (needs_inquiry) 
-     { dc390_updateDCB (pACB, pDCB); dc390_inquiry (pACB, pDCB); };
-  DC390_UNLOCK_IO(pACB.pScsiHost);
-  return (length);
-
- einv2:
-  pos = p0;
- einv:
-  DC390_UNLOCK_ACB;
-  DC390_UNLOCK_IO(pACB.pScsiHost);
-  printk (KERN_WARNING "DC390: parse error near \"%s\"\n", (pos? pos: "NULL"));
-  return (-EINVAL);
-   
- reset:
-     {
-	Scsi_Cmnd cmd;
-	/* TODO FIXME */
-	/* cmd.host = pACB->pScsiHost; */
-	printk (KERN_WARNING "DC390: Driver reset requested!\n");
-	DC390_UNLOCK_ACB;
-	DC390_reset (&cmd, 0);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
-  return (length);
-
- dump:
-     {
-	dc390_dumpinfo (pACB, 0, 0);
-	DC390_UNLOCK_ACB;
-	DC390_UNLOCK_IO(pACB.pScsiHost);       
-     }
-  return (length);
-	
- inquiry:
-     {
-	pos = strsep (*pos, " \t\n.:;="); if (!*pos) goto einv;
-	dev = simple_strtoul (pos, &p0, 10);
-	if (dev >= pACB->DCBCnt) goto einv_dev;
-	for (dum = 0; dum < dev; dum++) pDCB = pDCB->pNextDCB;
-	printk (KERN_NOTICE " DC390: Issue INQUIRY command to Dev(Idx) %i SCSI ID %i LUN %i\n",
-		dev, pDCB->TargetID, pDCB->TargetLUN);
-	DC390_UNLOCK_ACB;
-	dc390_inquiry (pACB, pDCB);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
-   return (length);
-
- remove:
-     {
-	pos = strsep (*pos, " \t\n.:;="); if (!*pos) goto einv;
-	dev = simple_strtoul (pos, &p0, 10);
-	if (dev >= pACB->DCBCnt) goto einv_dev;
-	for (dum = 0; dum < dev; dum++) pDCB = pDCB->pNextDCB;
-	printk (KERN_NOTICE " DC390: Remove DCB for Dev(Idx) %i SCSI ID %i LUN %i\n",
-		dev, pDCB->TargetID, pDCB->TargetLUN);
-	/* TO DO: We should make sure no pending commands are left */
-	dc390_remove_dev (pACB, pDCB);
-	DC390_UNLOCK_ACB;
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
-   return (length);
-
- add:
-     {
-	int id, lun;
-	pos = strsep (*pos, " \t\n.:;=");
-	if (*pos) { SCANF (buffer, pos, p0, id, 0, 7); } else goto einv;
-	if (*pos) { SCANF (buffer, pos, p0, lun, 0, 7); } else goto einv;
-	pDCB = dc390_findDCB (pACB, id, lun);
-	if (pDCB) { printk ("DC390: ADD: Device already existing\n"); goto einv; };
-	dc390_initDCB (pACB, &pDCB, id, lun);
-	DC390_UNLOCK_ACB;
-	dc390_inquiry (pACB, pDCB);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
-   return (length);
-
- start:
-     {
-	int id, lun;
-	pos = strsep (*pos, " \t\n.:;=");
-	if (*pos) { SCANF (buffer, pos, p0, id, 0, 7); } else goto einv;
-	if (*pos) { SCANF (buffer, pos, p0, lun, 0, 7); } else goto einv;
-	pDCB = dc390_findDCB (pACB, id, lun);
-	if (pDCB) printk ("DC390: SendStart: Device already existing ...\n");
-	else dc390_initDCB (pACB, &pDCB, id, lun);
-	DC390_UNLOCK_ACB;
-	dc390_sendstart (pACB, pDCB);
-	dc390_inquiry (pACB, pDCB);
-	DC390_UNLOCK_IO(pACB.pScsiHost);
-     };
-   return (length);
-
- einv_dev:
-   printk (KERN_WARNING "DC390: Ignore cmnd to invalid Dev(Idx) %i. Valid range: 0 - %i.\n", 
-	   dev, pACB->DCBCnt - 1);
-   DC390_UNLOCK_ACB;
-   DC390_UNLOCK_IO(pACB.pScsiHost);
-   return (-EINVAL);
-	     
-	     
-}
 
 #undef SEARCH
 #undef YESNO
@@ -2877,7 +2381,7 @@
   if (pACB == (PACB)-1) return(-ESRCH);
 
   if(inout) /* Has data been written to the file ? */
-      return dc390_set_info(buffer, length, pACB);
+      return -EPERM;
    
   SPRINTF("Tekram DC390/AM53C974 PCI SCSI Host Adapter, ");
   SPRINTF("Driver Version %s\n", DC390_VERSION);
@@ -2932,7 +2436,7 @@
       pDCB = pDCB->pNextDCB;
      }
     SPRINTF ("Commands in Queues: Query: %li:", pACB->QueryCnt);
-    for (pcmd = pACB->pQueryHead; pcmd; pcmd = pcmd->next)
+    for (pcmd = pACB->pQueryHead; pcmd; pcmd = (Scsi_Cmnd*)pcmd->host_scribble)
 	SPRINTF (" %li", pcmd->pid);
     if (timer_pending(&pACB->Waiting_Timer)) SPRINTF ("Waiting queue timer running\n");
     else SPRINTF ("\n");
@@ -3057,15 +2561,16 @@
 }
 #endif /* def MODULE */
 
-static Scsi_Host_Template driver_template = DC390_T;
+static Scsi_Host_Template driver_template = {
+   .module         = THIS_MODULE,
    .proc_name      = "tmscsim", 
    .proc_info      = DC390_proc_info,
    .name           = DC390_BANNER " V" DC390_VERSION,
    .detect         = DC390_detect,
    .release        = DC390_release,
    .queuecommand   = DC390_queue_command,
-   .abort          = DC390_abort,
-   .reset          = DC390_reset,
+   .eh_abort_handler     = DC390_abort,
+   .eh_bus_reset_handler = DC390_reset,
    .bios_param     = DC390_bios_param,
    .can_queue      = 42,
    .this_id        = 7,

-- 
 Jamie Lenehan <lenehan@twibble.org>

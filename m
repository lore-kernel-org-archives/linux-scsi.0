From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill tmscsim ->proc_info
Date: Tue, 17 Aug 2004 18:18:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817161858.GA16589@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:11499 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265789AbUHQQTG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:19:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: g.liakhovetski@gmx.de
Cc: linux-scsi@vger.kernel.org

hrrible code like all proc_info implementations and no really usefull
information.  We might want to add sysfs attributes if some users really
miss anything.


--- 1.45/drivers/scsi/tmscsim.c	2004-07-05 00:35:28 +02:00
+++ edited/drivers/scsi/tmscsim.c	2004-08-15 19:22:09 +02:00
@@ -295,9 +295,6 @@
 static int    dc390_initAdapter(struct Scsi_Host *psh, unsigned long io_port, u8 Irq, u8 index );
 static void   dc390_updateDCB (struct dc390_acb* pACB, struct dc390_dcb* pDCB);
 
-static int DC390_proc_info (struct Scsi_Host *shpnt, char *buffer, char **start,
-			    off_t offset, int length, int inout);
-
 static struct dc390_acb*	dc390_pACB_start= NULL;
 static struct dc390_acb*	dc390_pACB_current = NULL;
 static u32	dc390_laststatus = 0;
@@ -1664,7 +1630,6 @@
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "tmscsim", 
-	.proc_info		= DC390_proc_info,
 	.name			= DC390_BANNER " V" DC390_VERSION,
 	.slave_alloc		= dc390_slave_alloc,
 	.slave_configure	= dc390_slave_configure,
@@ -1784,152 +1749,6 @@
 	scsi_host_put(scsi_host);
 	pci_set_drvdata(dev, NULL);
 }
-
-/********************************************************************
- * Function: DC390_proc_info(char* buffer, char **start,
- *			     off_t offset, int length, int hostno, int inout)
- *
- * Purpose: return SCSI Adapter/Device Info
- *
- * Input: buffer: Pointer to a buffer where to write info
- *	  start :
- *	  offset:
- *	  hostno: Host adapter index
- *	  inout : Read (=0) or set(!=0) info
- *
- * Output: buffer: contains info
- *	   length; length of info in buffer
- *
- * return value: length
- *
- ********************************************************************/
-
-#undef SPRINTF
-#define SPRINTF(args...) pos += sprintf(pos, ## args)
-
-#define YESNO(YN)		\
- if (YN) SPRINTF(" Yes ");	\
- else SPRINTF(" No  ")
-
-
-static int DC390_proc_info (struct Scsi_Host *shpnt, char *buffer, char **start,
-			    off_t offset, int length, int inout)
-{
-  int dev, spd, spd1;
-  char *pos = buffer;
-  struct dc390_acb* pACB;
-  struct dc390_dcb* pDCB;
-
-  pACB = dc390_pACB_start;
-
-  while(pACB != (struct dc390_acb*)-1)
-     {
-	if (shpnt == pACB->pScsiHost)
-		break;
-	pACB = pACB->pNextACB;
-     }
-
-  if (pACB == (struct dc390_acb*)-1) return(-ESRCH);
-
-  if(inout) /* Has data been written to the file ? */
-      return -ENOSYS;
-   
-  SPRINTF("Tekram DC390/AM53C974 PCI SCSI Host Adapter, ");
-  SPRINTF("Driver Version %s\n", DC390_VERSION);
-
-  SPRINTF("SCSI Host Nr %i, ", shpnt->host_no);
-  SPRINTF("%s Adapter Nr %i\n", dc390_adapname, pACB->AdapterIndex);
-  SPRINTF("IOPortBase 0x%04x, ", pACB->IOPortBase);
-  SPRINTF("IRQ %02i\n", pACB->IRQLevel);
-
-  SPRINTF("MaxID %i, MaxLUN %i, ", shpnt->max_id, shpnt->max_lun);
-  SPRINTF("AdapterID %i, SelTimeout %i ms, DelayReset %i s\n", 
-	  shpnt->this_id, (pACB->sel_timeout*164)/100,
-	  dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY]);
-
-  SPRINTF("TagMaxNum %i, Status 0x%02x, ACBFlag 0x%02x, GlitchEater %i ns\n",
-	  pACB->TagMaxNum, pACB->status, pACB->ACBFlag, GLITCH_TO_NS(pACB->glitch_cfg)*12);
-
-  SPRINTF("Statistics: Cmnds %li, Cmnds not sent directly %i, Out of SRB conds %i\n",
-	  pACB->Cmds, pACB->CmdInQ, pACB->CmdOutOfSRB);
-  SPRINTF("            Lost arbitrations %i, Sel. connected %i, Connected: %s\n", 
-	  pACB->SelLost, pACB->SelConn, pACB->Connected? "Yes": "No");
-   
-  SPRINTF("Nr of DCBs: %i\n", pACB->DCBCnt);
-  SPRINTF("Map of attached LUNs: %02x %02x %02x %02x %02x %02x %02x %02x\n",
-	  pACB->DCBmap[0], pACB->DCBmap[1], pACB->DCBmap[2], pACB->DCBmap[3], 
-	  pACB->DCBmap[4], pACB->DCBmap[5], pACB->DCBmap[6], pACB->DCBmap[7]);
-
-  SPRINTF("Idx ID LUN Prty Sync DsCn SndS TagQ NegoPeriod SyncSpeed SyncOffs MaxCmd\n");
-
-  pDCB = pACB->pLinkDCB;
-  for (dev = 0; dev < pACB->DCBCnt; dev++)
-     {
-      SPRINTF("%02i  %02i  %02i ", dev, pDCB->TargetID, pDCB->TargetLUN);
-      YESNO(pDCB->DevMode & PARITY_CHK_);
-      YESNO(pDCB->SyncMode & SYNC_NEGO_DONE);
-      YESNO(pDCB->DevMode & EN_DISCONNECT_);
-      YESNO(pDCB->DevMode & SEND_START_);
-      YESNO(pDCB->SyncMode & EN_TAG_QUEUEING);
-      if (pDCB->SyncOffset & 0x0f)
-      {
-	 int sp = pDCB->SyncPeriod; if (! (pDCB->CtrlR3 & FAST_SCSI)) sp++;
-	 SPRINTF("  %03i ns ", (pDCB->NegoPeriod) << 2);
-	 spd = 40/(sp); spd1 = 40%(sp);
-	 spd1 = (spd1 * 10 + sp/2) / (sp);
-	 SPRINTF("   %2i.%1i M      %02i", spd, spd1, (pDCB->SyncOffset & 0x0f));
-      }
-      else SPRINTF(" (%03i ns)                 ", (pDCB->NegoPeriod) << 2);
-      /* Add more info ...*/
-      SPRINTF ("      %02i\n", pDCB->MaxCommand);
-      pDCB = pDCB->pNextDCB;
-     }
-    if (timer_pending(&pACB->Waiting_Timer)) SPRINTF ("Waiting queue timer running\n");
-    else SPRINTF ("\n");
-    pDCB = pACB->pLinkDCB;
-	
-    for (dev = 0; dev < pACB->DCBCnt; dev++)
-    {
-	struct dc390_srb* pSRB;
-	if (pDCB->WaitSRBCnt) 
-		    SPRINTF ("DCB (%02i-%i): Waiting: %i:", pDCB->TargetID, pDCB->TargetLUN,
-			     pDCB->WaitSRBCnt);
-	for (pSRB = pDCB->pWaitingSRB; pSRB; pSRB = pSRB->pNextSRB)
-		SPRINTF(" %li", pSRB->pcmd->pid);
-	if (pDCB->GoingSRBCnt) 
-		    SPRINTF ("\nDCB (%02i-%i): Going  : %i:", pDCB->TargetID, pDCB->TargetLUN,
-			     pDCB->GoingSRBCnt);
-	for (pSRB = pDCB->pGoingSRB; pSRB; pSRB = pSRB->pNextSRB)
-#if 0 //def DC390_DEBUGTRACE
-		SPRINTF(" %s\n  ", pSRB->debugtrace);
-#else
-		SPRINTF(" %li", pSRB->pcmd->pid);
-#endif
-	if (pDCB->WaitSRBCnt || pDCB->GoingSRBCnt) SPRINTF ("\n");
-	pDCB = pDCB->pNextDCB;
-    }
-	
-#ifdef DC390_DEBUGDCB
-    SPRINTF ("DCB list for ACB %p:\n", pACB);
-    pDCB = pACB->pLinkDCB;
-    SPRINTF ("%p", pDCB);
-    for (dev = 0; dev < pACB->DCBCnt; dev++, pDCB=pDCB->pNextDCB)
-	SPRINTF ("->%p", pDCB->pNextDCB);
-    SPRINTF("\n");
-#endif
-  
-  *start = buffer + offset;
-
-  if (pos - buffer < offset)
-    return 0;
-  else if (pos - buffer - offset < length)
-    return pos - buffer - offset;
-  else
-    return length;
-}
-
-#undef YESNO
-#undef SPRINTF
 
 static struct pci_driver dc390_driver = {
 	.name           = "tmscsim",

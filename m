From: Roessner Christian <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Thu, 15 Apr 2004 18:05:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404151805.18505.info@roessner-net.com>
References: <Pine.LNX.4.44.0404132232490.11576-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+KrfAh9iv2Dkank"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:12251 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S264331AbUDOQFD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 12:05:03 -0400
In-Reply-To: <Pine.LNX.4.44.0404132232490.11576-100000@poirot.grange>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org


--Boundary-00=_+KrfAh9iv2Dkank
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

today I have patched a fresh vanilla-2.6.5 with your code. I changed some 
lines (Do you use 2.6.3?).

I have burned CDs and did parallel reading with cp and two instances of dd=...

I tested a CD with sector errors and one without errors. The code seems to be 
stable.

Below you can find my changed version of your patch (for 2.6.5)

Thanks for your help

Auf Wiedersehen

Christian

Am Dienstag, 13. April 2004 22:40 schrieben Sie:
> On Tue, 13 Apr 2004, Christian Roessner wrote:
> > great! Problem fixed. cdrecord -scanbus show my TEAC 512
> > writer. /proc/scsi/tmscsim/5 shows sync-speed 5.0M. Fine!
> >
> > Can I remove the debugging statements?
>
> Yes! Now you are allowed to remove all the debugging!:-) And the last
> thing I would ask you to try - is a bit of stress-testing. Try burning
> some CDs (ok, you can burn re-writables, although, they tend to be slower
> than recordables), put some load in parallel, mount dome CDs, dd from them
> (dd if=/dev/scd0 of=/dev/null), play some music from them. Do you have any
> other SCSI devices you could connect to it? But, you know, AM53C974 is not
> the most performant SCSI-controller:-) Actually, when I just completed
> initial porting it to 2.6, I said, it would be nice to test it on some
> HIGHMEM / 64bit platforms, and somebody replied, that, probably, nobody
> would ever think of using this chip on such a system:-)
>
> And, please post output of your /proc/scsi/scsi and /proc/scsi/tmscsim/...
>
> Thanks for your help!
> Guennadi
> ---
> Guennadi Liakhovetski

-- 
Roessner Network Solutions (R.N.S.)

Tel.: 0641-2097252, Fax: 0641-2097253, Mobil: 0171-3611230
URL: http://www.roessner-net.com/
PGP: http://www.roessner-net.com/0x6A549505.asc








--Boundary-00=_+KrfAh9iv2Dkank
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="tmscsim-64.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="tmscsim-64.patch"

--- linux-2.6.5/drivers/scsi/tmscsim.c	Fri Mar 12 22:22:11 2004
+++ linux-2.6.5/drivers/scsi/tmscsim.c	Tue Apr 13 22:50:05 2004
@@ -168,6 +168,7 @@
  *	2.1a  03/11/29  GL, KG	Initial fixing for 2.6. Convert to	*
  *				use the current PCI-mapping API, update	*
  *				command-queuing.			*
+ *	2.1b  04/04/13  GL	Fix for 64-bit platforms		*
  ***********************************************************************/
 
 /* Uncomment SA_INTERRUPT, if the driver refuses to share its IRQ with other devices */
@@ -1022,7 +1023,7 @@
 			pci_map_page(pdev, virt_to_page(pcmd->sense_buffer),
 				     (unsigned long)pcmd->sense_buffer & ~PAGE_MASK, sizeof(pcmd->sense_buffer),
 				     DMA_FROM_DEVICE);
-		pSRB->Segmentx.length = sizeof(pcmd->sense_buffer);
+		sg_dma_len(&pSRB->Segmentx) = sizeof(pcmd->sense_buffer);
 		pSRB->SGcount = 1;
 		pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
 		DEBUG1(printk("%s(): Mapped sense buffer %p at %x\n", __FUNCTION__, pcmd->sense_buffer, cmdp->saved_dma_handle));
@@ -1043,7 +1044,7 @@
 				     (unsigned long)pcmd->request_buffer & ~PAGE_MASK,
 				     pcmd->request_bufflen, scsi_to_pci_dma_dir(pcmd->sc_data_direction));
 		/* TODO: error handling */
-		pSRB->Segmentx.length = pcmd->request_bufflen;
+		sg_dma_len(&pSRB->Segmentx) = sizeof(pcmd->sense_buffer);
 		pSRB->SGcount = 1;
 		pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
 		DEBUG1(printk("%s(): Mapped request buffer %p at %x\n", __FUNCTION__, pcmd->request_buffer, cmdp->saved_dma_handle));
@@ -1131,7 +1132,7 @@
 	if (!pcmd) { dc390_Free_insert (pACB, pSRB); return; } /* should not happen */
 	pDCB = dc390_findDCB (pACB, pcmd->device->id, pcmd->device->lun);
 	if (!pDCB) 
-	{ 
+	{
 		dc390_Free_insert (pACB, pSRB);
 		printk (KERN_ERR "DC390: Command in queue to non-existing device!\n");
 		pcmd->result = MK_RES(DRIVER_ERROR,DID_ERROR,0,0);
@@ -1180,7 +1181,7 @@
     /* Assume BAD_TARGET; will be cleared later */
     cmd->result = DID_BAD_TARGET << 16;
    
-    /* TODO: Change the policy: Alway accept TEST_UNIT_READY or INQUIRY 
+    /* TODO: Change the policy: Always accept TEST_UNIT_READY or INQUIRY 
      * commands and alloc a DCB for the device if not yet there. DCB will
      * be removed in dc390_SRBdone if SEL_TIMEOUT */
 
@@ -1767,7 +1768,7 @@
     PDCB pDCB, pDCB2;
 
     pDCB = kmalloc (sizeof(DC390_DCB), GFP_ATOMIC);
-    DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i): %p\n"	\
+    DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i): %p\n",	\
 		     id, lun, pDCB));
  
     *ppDCB = pDCB;
@@ -2221,7 +2222,7 @@
 {
     PDEVDECL0;
     UCHAR   irq;
-    UINT    io_port;
+    ULONG   io_port;
 
     //dc390_pSHT_start = psht;
     dc390_pACB_start = NULL;
@@ -2229,10 +2230,13 @@
     if ( PCI_PRESENT )
 	while (PCI_FIND_DEVICE (PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD53C974))
 	{
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,3,30)
 	    if (pci_enable_device (pdev))
 		continue;
-#endif
+
+	    if (pci_set_dma_mask(pdev, 0xffffffff)) {
+		    printk(KERN_ERR "DC390(%i): No suitable DMA available.\n", dc390_adapterCnt);
+		    continue;
+	    }
 	    PCI_GET_IO_AND_IRQ;
 	    DEBUG0(printk(KERN_INFO "DC390(%i): IO_PORT=%04x,IRQ=%x\n", dc390_adapterCnt, (UINT) io_port, irq));
 
--- linux-2.6.5/drivers/scsi/scsiiom.c	Fri Mar 12 22:22:10 2004
+++ linux-2.6.5/drivers/scsi/scsiiom.c	Tue Apr 13 22:46:19 2004
@@ -521,7 +521,7 @@
     {
 	    DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);
 	    DC390_write8 (DMA_Cmd, READ_DIRECTION+DMA_IDLE_CMD); /* | DMA_INT */
-    }	    
+    }
 }
 
 static void
@@ -740,9 +740,9 @@
 	psgl = pSRB->pSegmentList;
 	//dc390_pci_sync(pSRB);
 
-	while (pSRB->TotalXferredLen + (ULONG) psgl->length < pSRB->Saved_Ptr)
+	while (pSRB->TotalXferredLen + (ULONG) sg_dma_len(psgl) < pSRB->Saved_Ptr)
 	{
-	    pSRB->TotalXferredLen += (ULONG) psgl->length;
+	    pSRB->TotalXferredLen += (ULONG) sg_dma_len(psgl);
 	    pSRB->SGIndex++;
 	    if( pSRB->SGIndex < pSRB->SGcount )
 	    {
@@ -762,7 +762,7 @@
     } else if(pcmd->request_buffer) {
 	//dc390_pci_sync(pSRB);
 
-	pSRB->Segmentx.length = pcmd->request_bufflen - pSRB->Saved_Ptr;
+	sg_dma_len(&pSRB->Segmentx) = pcmd->request_bufflen - pSRB->Saved_Ptr;
 	pSRB->SGcount = 1;
 	pSRB->pSegmentList = (PSGL) &pSRB->Segmentx;
     } else {
@@ -885,6 +885,8 @@
 	if (pDCB) printk (KERN_ERR "DC390: pSRB == pTmpSRB! (TagQ Error?) (%02i-%i)\n",
 			  pDCB->TargetID, pDCB->TargetLUN);
 	else printk (KERN_ERR "DC390: pSRB == pTmpSRB! (TagQ Error?) (DCB 0!)\n");
+
+	pSRB->pSRBDCB = pDCB;
 	dc390_EnableMsgOut_Abort (pACB, pSRB);
 	if (pDCB) pDCB->DCBFlag |= ABORT_DEV;
 	return;
@@ -1466,7 +1468,7 @@
 		ptr2 = pSRB->pSegmentList;
 		for( i=pSRB->SGIndex; i < bval; i++)
 		{
-		    swlval += ptr2->length;
+		    swlval += sg_dma_len(ptr2);
 		    ptr2++;
 		}
 		REMOVABLEDEBUG(printk(KERN_INFO "XferredLen=%08x,NotXferLen=%08x\n",\
--- linux-2.6.5/drivers/scsi/dc390.h	Fri Mar 12 22:22:10 2004
+++ linux-2.6.5/drivers/scsi/dc390.h	Tue Apr 13 22:50:26 2004
@@ -19,7 +19,7 @@
 #endif
 
 #define DC390_BANNER "Tekram DC390/AM53C974"
-#define DC390_VERSION "2.0f 2000-12-20"
+#define DC390_VERSION "2.1b 2004-04-13"
 
 /* We don't have eh_abort_handler, eh_device_reset_handler, 
  * eh_bus_reset_handler, eh_host_reset_handler yet! 

--Boundary-00=_+KrfAh9iv2Dkank--

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: remove remaining INQUIRY sniffing
Date: Sun, 3 Oct 2004 22:39:04 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410032222130.2073@poirot.grange>
References: <20041003133935.GA1538@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:31125 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268142AbUJCUpK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Oct 2004 16:45:10 -0400
In-Reply-To: <20041003133935.GA1538@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, 3 Oct 2004, Christoph Hellwig wrote:

> [on top of my host list removal patch and Guennadi last two patches]

Thanks, Christoph

<quote>

Date: Sat, 2 Oct 2004 01:46:35 +0200 (CEST)
From: Guennadi Liakhovetski <lyakh@poirot.grange>
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged

On Fri, 1 Oct 2004, Christoph Hellwig wrote:

> And while we're at it: The whole inquiry sniffing in dc390_SRBdone (aka all
> uses of ptr and ptr) can easily go away if you kill pDCB->Inquiry7 and check
> sdev->sdtr instead.

You once already suggested that - I didn't forget, it's a separate 
patch:-) It'll follow, but after "internal queuing removal."

</quote>

So, I just wanted to let the so far submitted patches settle down a bit, 
at least hear some reaction to them, and then submit this one. But yours 
looks a bit better: I overlooked the possibility to do srb->pcmd->device, 
and added a dcb->sdev pointer to get to sdtr. So, be it yours.

Thanks
Guennadi
---
Guennadi Liakhovetski


>
>
> --- 1.21/drivers/scsi/scsiiom.c	2004-10-03 15:12:37 +02:00
> +++ edited/drivers/scsi/scsiiom.c	2004-10-03 15:39:17 +02:00
> @@ -18,6 +18,7 @@
> static int
> dc390_StartSCSI( struct dc390_acb* pACB, struct dc390_dcb* pDCB, struct dc390_srb* pSRB )
> {
> +    struct scsi_device *sdev = pSRB->pcmd->device;
>     u8 cmd; u8  disc_allowed, try_sync_nego;
>
>     pSRB->ScsiPhase = SCSI_NOP0;
> @@ -59,7 +60,7 @@
> 	 * (pSRB->pcmd->cmnd[0] == TEST_UNIT_READY)) && pACB->scan_devices)
> 		||*/ (pSRB->SRBFlag & AUTO_REQSENSE) )
>       disc_allowed = 0;
> -    if ( (pDCB->SyncMode & SYNC_ENABLE) && (pDCB->TargetLUN == 0) && (pDCB->Inquiry7 & 0x10) &&
> +    if ( (pDCB->SyncMode & SYNC_ENABLE) && (pDCB->TargetLUN == 0) && sdev->sdtr &&
> 	( ( ( (pSRB->pcmd->cmnd[0] == REQUEST_SENSE) || (pSRB->SRBFlag & AUTO_REQSENSE) )
> 	  && !(pDCB->SyncMode & SYNC_NEGO_DONE) ) || (pSRB->pcmd->cmnd[0] == INQUIRY) ) )
>       try_sync_nego = 1;
> @@ -1307,20 +1308,13 @@
> {
>     u8  bval, status;
>     struct scsi_cmnd *pcmd;
> -    PSCSI_INQDATA  ptr;
> -    struct scatterlist *ptr2;
>
>     pcmd = pSRB->pcmd;
>     /* KG: Moved pci_unmap here */
>     dc390_pci_unmap(pSRB);
>
>     status = pSRB->TargetStatus;
> -    if (pcmd->use_sg) {
> -	    ptr2 = (struct scatterlist *) (pcmd->request_buffer);
> -	    ptr = (PSCSI_INQDATA) (page_address(ptr2->page) + ptr2->offset);
> -    } else
> -	    ptr = (PSCSI_INQDATA) (pcmd->request_buffer);
> -
> +
>     DEBUG0(printk (" SRBdone (%02x,%08x), SRB %p, pid %li\n", status, pcmd->result,\
> 		pSRB, pcmd->pid));
>     if(pSRB->SRBFlag & AUTO_REQSENSE)
> @@ -1355,22 +1349,6 @@
>     {
> 	if( status_byte(status) == CHECK_CONDITION )
> 	{
> -#ifdef DC390_REMOVABLEDEBUG
> -	    printk(KERN_INFO "DC390: Check_Condition (Cmd %02x, Id %02x, LUN %02x)\n",
> -		   pcmd->cmnd[0], pDCB->TargetID, pDCB->TargetLUN);
> -	    if ((pSRB->SGIndex < pSRB->SGcount) && (pSRB->SGcount) && (pSRB->SGToBeXferLen))
> -	    {
> -		bval = pSRB->SGcount;
> -		swlval = 0;
> -		ptr2 = pSRB->pSegmentList;
> -		for( i=pSRB->SGIndex; i < bval; i++)
> -		{
> -		    swlval += sg_dma_len(ptr2);
> -		    ptr2++;
> -		}
> -		printk(KERN_INFO "XferredLen=%08x,NotXferLen=%08x\n", (u32) pSRB->TotalXferredLen, (u32) swlval);
> -	    }
> -#endif
> 	    if (dc390_RequestSense(pACB, pDCB, pSRB)) {
> 		SET_RES_DID(pcmd->result, DID_ERROR);
> 		goto cmd_done;
> @@ -1431,13 +1409,6 @@
> 	    SET_RES_DID(pcmd->result,DID_OK);
> 	}
>     }
> -    if ((pcmd->result & RES_DID) == 0 &&
> -	pcmd->cmnd[0] == INQUIRY &&
> -	pcmd->cmnd[2] == 0 &&
> -	pcmd->request_bufflen >= 8 &&
> -	ptr &&
> -	(ptr->Vers & 0x07) >= 2)
> -	    pDCB->Inquiry7 = ptr->Flags;
>
> cmd_done:
>     pcmd->resid = pcmd->request_bufflen - pSRB->TotalXferredLen;
> --- 1.55/drivers/scsi/tmscsim.c	2004-10-03 15:12:37 +02:00
> +++ edited/drivers/scsi/tmscsim.c	2004-10-03 15:15:29 +02:00
> @@ -710,7 +710,6 @@
>
> 		pDCB->CtrlR3 = pDCB2->CtrlR3;
> 		pDCB->CtrlR4 = pDCB2->CtrlR4;
> -		pDCB->Inquiry7 = pDCB2->Inquiry7;
> 	} else {
> 		u8 index = pACB->AdapterIndex;
> 		PEEprom prom = (PEEprom) &dc390_eepromBuf[index][id << 2];
> --- 1.10/drivers/scsi/tmscsim.h	2004-10-03 15:12:37 +02:00
> +++ edited/drivers/scsi/tmscsim.h	2004-10-03 15:21:36 +02:00
> @@ -103,7 +103,6 @@
> u8		CtrlR1;
> u8		CtrlR3;
> u8		CtrlR4;
> -u8		Inquiry7;
>
> u8		SyncMode;	/*; 0:async mode */
> u8		NegoPeriod;	/*;for nego. */
> @@ -323,64 +322,6 @@
> typedef struct {
> 	dma_addr_t		saved_dma_handle;
> } dc390_cmd_scp_t;
> -
> -/*
> -**  Inquiry Data format
> -*/
> -
> -typedef struct	_SCSIInqData { /* INQUIRY */
> -
> -	u8	 DevType;		/* Periph Qualifier & Periph Dev Type*/
> -	u8	 RMB_TypeMod;		/* rem media bit & Dev Type Modifier */
> -	u8	 Vers;			/* ISO, ECMA, & ANSI versions	     */
> -	u8	 RDF;			/* AEN, TRMIOP, & response data format*/
> -	u8	 AddLen;		/* length of additional data	     */
> -	u8	 Res1;			/* reserved			     */
> -	u8	 Res2;			/* reserved			     */
> -	u8	 Flags; 		/* RelADr,Wbus32,Wbus16,Sync,etc.    */
> -	u8	 VendorID[8];		/* Vendor Identification	     */
> -	u8	 ProductID[16]; 	/* Product Identification	     */
> -	u8	 ProductRev[4]; 	/* Product Revision		     */
> -
> -
> -} SCSI_INQDATA, *PSCSI_INQDATA;
> -
> -
> -/*  Inquiry byte 0 masks */
> -
> -
> -#define SCSI_DEVTYPE	    0x1F      /* Peripheral Device Type 	    */
> -#define SCSI_PERIPHQUAL     0xE0      /* Peripheral Qualifier		    */
> -#define TYPE_NODEV	    SCSI_DEVTYPE    /* Unknown or no device type    */
> -
> -
> -/*  Inquiry byte 1 mask */
> -
> -#define SCSI_REMOVABLE_MEDIA  0x80    /* Removable Media bit (1=removable)  */
> -
> -
> -/*  Peripheral Device Type definitions */
> -/*  see include/scsi/scsi.h for the rest */
> -
> -#ifndef TYPE_PRINTER
> -# define TYPE_PRINTER		 0x02	   /* Printer device		   */
> -#endif
> -#ifndef TYPE_COMM
> -# define TYPE_COMM		 0x09	   /* Communications device	   */
> -#endif
> -
> -/*
> -** Inquiry flag definitions (Inq data byte 7)
> -*/
> -
> -#define SCSI_INQ_RELADR       0x80    /* device supports relative addressing*/
> -#define SCSI_INQ_WBUS32       0x40    /* device supports 32 bit data xfers  */
> -#define SCSI_INQ_WBUS16       0x20    /* device supports 16 bit data xfers  */
> -#define SCSI_INQ_SYNC	      0x10    /* device supports synchronous xfer   */
> -#define SCSI_INQ_LINKED       0x08    /* device supports linked commands    */
> -#define SCSI_INQ_CMDQUEUE     0x02    /* device supports command queueing   */
> -#define SCSI_INQ_SFTRE	      0x01    /* device supports soft resets */
> -
>
> /*
> ;==========================================================
>
>

---
Guennadi Liakhovetski


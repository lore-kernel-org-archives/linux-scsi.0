From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] convert inia100 to new probing API
Date: Wed, 19 Nov 2003 14:18:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119131818.GA23015@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:59010 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264045AbTKSNSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 08:18:36 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: dledford@redhat.com
Cc: linux-scsi@vger.kernel.org

Hi Doug,

you've been the last who touched inia100.c, so I may assume you
actually have the hardware?  I've updated the driver to the new
pci probing and scsi host registration code and it would be cool
if someone could test it so we could merge it into early 2.6.


--- 1.8/drivers/scsi/i60uscsi.c	Thu Sep 11 02:07:25 2003
+++ edited/drivers/scsi/i60uscsi.c	Tue Nov 18 08:50:32 2003
@@ -108,9 +108,6 @@
 /* ---- EXTERNAL FUNCTIONS ---- */
 extern void inia100SCBPost(BYTE * pHcb, BYTE * pScb);
 
-/* ---- INTERNAL VARIABLES ---- */
-struct inia100_Adpt_Struc *inia100_adpt;
-
 NVRAM nvram, *nvramp = &nvram;
 static UCHAR dftNvRam[64] =
 {
@@ -701,83 +698,6 @@
 			scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
 	}
 }
-
-/*****************************************************************************
- Function name	: Addinia100_into_Adapter_table
- Description	: This function will scan PCI bus to get all Orchid card
- Input		: None.
- Output		: None.
- Return		: SUCCESSFUL	- Successful scan
- ohterwise	- No drives founded
-*****************************************************************************/
-int Addinia100_into_Adapter_table(WORD wBIOS, WORD wBASE, struct pci_dev *pdev,
-		int iAdapters)
-{
-	unsigned int i, j;
-
-	for (i = 0; i < iAdapters; i++) {
-		if (inia100_adpt[i].ADPT_BIOS < wBIOS)
-			continue;
-		if (inia100_adpt[i].ADPT_BIOS == wBIOS) {
-			if (inia100_adpt[i].ADPT_BASE == wBASE) {
-				if (inia100_adpt[i].ADPT_pdev->bus->number != 0xFF)
-					return (FAILURE);
-			} else if (inia100_adpt[i].ADPT_BASE < wBASE)
-				continue;
-		}
-		for (j = iAdapters - 1; j > i; j--) {
-			inia100_adpt[j].ADPT_BASE = inia100_adpt[j - 1].ADPT_BASE;
-			inia100_adpt[j].ADPT_BIOS = inia100_adpt[j - 1].ADPT_BIOS;
-			inia100_adpt[j].ADPT_pdev = inia100_adpt[j - 1].ADPT_pdev;
-		}
-		inia100_adpt[i].ADPT_BASE = wBASE;
-		inia100_adpt[i].ADPT_BIOS = wBIOS;
-		inia100_adpt[i].ADPT_pdev = pdev;
-		return (SUCCESSFUL);
-	}
-	return (FAILURE);
-}
-
-
-/*****************************************************************************
- Function name	: init_inia100Adapter_table
- Description	: This function will scan PCI bus to get all Orchid card
- Input		: None.
- Output		: None.
- Return		: 0 on success, 1 on failure
-*****************************************************************************/
-int init_inia100Adapter_table(int iAdapters)
-{
-	int i;
-
-	inia100_adpt = kmalloc(sizeof(INIA100_ADPT_STRUCT) * iAdapters,
-			GFP_KERNEL);
-	if(inia100_adpt == NULL)
-		return 1;
-
-	for (i = 0; i < iAdapters; i++) {/* Initialize adapter structure */
-		inia100_adpt[i].ADPT_BIOS = 0xffff;
-		inia100_adpt[i].ADPT_BASE = 0xffff;
-		inia100_adpt[i].ADPT_pdev = NULL;
-	}
-	return 0;
-}
-
-/*****************************************************************************
- Function name  : get_orcPCIConfig
- Description    : 
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-void get_orcPCIConfig(ORC_HCS * pCurHcb, int ch_idx)
-{
-	pCurHcb->HCS_Base = inia100_adpt[ch_idx].ADPT_BASE;	/* Supply base address  */
-	pCurHcb->HCS_BIOS = inia100_adpt[ch_idx].ADPT_BIOS;	/* Supply BIOS address  */
-	pCurHcb->HCS_Intr = inia100_adpt[ch_idx].ADPT_pdev->irq;	/* Supply interrupt line */
-	return;
-}
-
 
 /*****************************************************************************
  Function name  : abort_SCB
===== drivers/scsi/inia100.c 1.25 vs edited =====
--- 1.25/drivers/scsi/inia100.c	Fri May  2 21:35:59 2003
+++ edited/drivers/scsi/inia100.c	Tue Nov 18 09:23:02 2003
@@ -65,10 +65,15 @@
  *          - Clean up interrupt handler registration
  *          - Fix memory leaks
  *          - Fix allocation of scsi host structs and private data
+ * 18/11/03 Christoph Hellwig <hch@lst.de>
+ *	    - Port to new probing API
+ *	    - Fix some more leaks in init failure cases
+ * TODO:
+ *	    - use list.h macros for SCB queue
+ *	  ( - merge with i60uscsi.c )
  **************************************************************************/
 
 #include <linux/module.h>
-
 #include <linux/errno.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
@@ -76,37 +81,19 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/spinlock.h>
-#include <linux/stat.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
-//#include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/proc_fs.h>
-
 #include <asm/io.h>
 #include <asm/irq.h>
 
-#include "scsi.h"
-#include "hosts.h"
-#include "inia100.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 
-static Scsi_Host_Template driver_template = {
-	.proc_name	= "inia100",
-	.name		= inia100_REVID,
-	.detect		= inia100_detect,
-	.release	= inia100_release,
-	.queuecommand	= inia100_queue,
-	.eh_abort_handler = inia100_abort,
-	.eh_bus_reset_handler	= inia100_bus_reset,
-	.eh_device_reset_handler = inia100_device_reset,
-	.can_queue	= 1,
-	.this_id	= 1,
-	.sg_tablesize	= SG_ALL,
-	.cmd_per_lun 	= 1,
-	.use_clustering	= ENABLE_CLUSTERING,
-};
-#include "scsi_module.c"
+#include "inia100.h"
 
 #define ORC_RDWORD(x,y)         (short)(inl((int)((ULONG)((ULONG)x+(UCHAR)y)) ))
 
@@ -115,32 +102,19 @@
 char *inia100_ProductName = "INI-A100U2W";
 char *inia100_Version = "v1.02d";
 
-/* set by inia100_setup according to the command line */
-static int setup_called = 0;
-
-/* ---- INTERNAL VARIABLES ---- */
-#define NUMBER(arr)     (sizeof(arr) / sizeof(arr[0]))
-static char *setup_str = (char *) NULL;
-
-static irqreturn_t inia100_intr(int, void *, struct pt_regs *);
-static void inia100_panic(char *msg);
-
 /* ---- EXTERNAL FUNCTIONS ---- */
 extern void inia100SCBPost(BYTE * pHcb, BYTE * pScb);
-extern int Addinia100_into_Adapter_table(WORD, WORD, struct pci_dev *, int);
 extern int init_inia100Adapter_table(int);
 extern ORC_SCB *orc_alloc_scb(ORC_HCS * hcsp);
 extern void orc_exec_scb(ORC_HCS * hcsp, ORC_SCB * scbp);
 extern void orc_release_scb(ORC_HCS * hcsp, ORC_SCB * scbp);
-extern void orc_release_dma(ORC_HCS * hcsp, Scsi_Cmnd * cmnd);
+extern void orc_release_dma(ORC_HCS * hcsp, struct scsi_cmnd * cmnd);
 extern void orc_interrupt(ORC_HCS * hcsp);
-extern int orc_device_reset(ORC_HCS * pHCB, Scsi_Cmnd *SCpnt, unsigned int target);
+extern int orc_device_reset(ORC_HCS * pHCB, struct scsi_cmnd *SCpnt, unsigned int target);
 extern int orc_reset_scsi_bus(ORC_HCS * pHCB);
 extern int abort_SCB(ORC_HCS * hcsp, ORC_SCB * pScb);
-extern int orc_abort_srb(ORC_HCS * hcsp, Scsi_Cmnd *SCpnt);
-extern void get_orcPCIConfig(ORC_HCS * pCurHcb, int ch_idx);
+extern int orc_abort_srb(ORC_HCS * hcsp, struct scsi_cmnd *SCpnt);
 extern int init_orchid(ORC_HCS * hcsp);
-extern struct inia100_Adpt_Struc *inia100_adpt;
 
 /*****************************************************************************
  Function name  : inia100AppendSRBToQueue
@@ -150,7 +124,7 @@
  Output         : None.
  Return         : None.
 *****************************************************************************/
-static void inia100AppendSRBToQueue(ORC_HCS * pHCB, Scsi_Cmnd * pSRB)
+static void inia100AppendSRBToQueue(ORC_HCS * pHCB, struct scsi_cmnd * pSRB)
 {
 	ULONG flags;
 
@@ -173,13 +147,13 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static Scsi_Cmnd *inia100PopSRBFromQueue(ORC_HCS * pHCB)
+static struct scsi_cmnd *inia100PopSRBFromQueue(ORC_HCS * pHCB)
 {
-	Scsi_Cmnd *pSRB;
+	struct scsi_cmnd *pSRB;
 	ULONG flags;
 	spin_lock_irqsave(&(pHCB->pSRB_lock), flags);
-	if ((pSRB = (Scsi_Cmnd *) pHCB->pSRB_head) != NULL) {
-		pHCB->pSRB_head = (Scsi_Cmnd *) pHCB->pSRB_head->SCp.ptr;
+	if ((pSRB = (struct scsi_cmnd *) pHCB->pSRB_head) != NULL) {
+		pHCB->pSRB_head = (struct scsi_cmnd *) pHCB->pSRB_head->SCp.ptr;
 		pSRB->SCp.ptr = NULL;
 	}
 	spin_unlock_irqrestore(&(pHCB->pSRB_lock), flags);
@@ -187,273 +161,13 @@
 }
 
 /*****************************************************************************
- Function name  : inia100_setup
- Description    : 
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-void inia100_setup(char *str, int *ints)
-{
-	if (setup_called)
-		inia100_panic("inia100: inia100_setup called twice.\n");
-
-	setup_called = ints[0];
-	setup_str = str;
-}
-
-/*****************************************************************************
- Function name	: orc_ReturnNumberOfAdapters
- Description	: This function will scan PCI bus to get all Orchid card
- Input		: None.
- Output		: None.
- Return		: SUCCESSFUL	- Successful scan
-		  ohterwise	- No drives founded
-*****************************************************************************/
-int orc_ReturnNumberOfAdapters(void)
-{
-	unsigned int iAdapters;
-
-	iAdapters = 0;
-	/*
-	 * PCI-bus probe.
-	 */
-	{
-		/*
-		 * Note: I removed the struct pci_device_list stuff since this
-		 * driver only cares about one device ID.  If that changes in
-		 * the future it can be added in with only a very moderate
-		 * amount of work.  It made the double scan of the device list
-		 * for getting a count and allocating the device list easier
-		 * to not have the for(i ... ) loop in there....
-		 */
-		unsigned int dRegValue;
-		WORD wBIOS, wBASE;
-#ifdef MMAPIO
-		unsigned long page_offset, base;
-#endif
-		struct pci_dev *pdev = NULL;
-
-		/*
-		 * Get a count of adapters that we expect to be able to use.
-		 * Pass that count to init_inia100Adapter_table() for malloc
-		 * reasons.
-		 */
-		pdev = NULL;
-		while((pdev=pci_find_device(ORC_VENDOR_ID, ORC_DEVICE_ID, pdev)))
-		{
-			if (pci_enable_device(pdev))
-				continue;
-			if (pci_set_dma_mask(pdev, (u64)0xffffffff)) {
-				printk(KERN_WARNING "Unable to set 32bit DMA "
-					"on inia100 adapter, ignoring.\n");
-				continue;
-			}
-			iAdapters++;
-		}
-		if(init_inia100Adapter_table(iAdapters))
-			return 0;
-		/*
-		 * Now go through the adapters again actually setting them up
-		 * and putting them in the table this time.
-		 */
-		pdev = NULL;
-		while((pdev=pci_find_device(ORC_VENDOR_ID, ORC_DEVICE_ID, pdev)))
-		{
-			/*
-			 * Read sundry information from PCI BIOS.
-			 */
-			dRegValue = pci_resource_start(pdev, 0);
-			if (dRegValue == -1) {	/* Check return code */
-				printk("\n\rinia100: orchid read configuration error.\n");
-				iAdapters--;
-				continue;	/* Read configuration space error  */
-			}
-
-			/* <02> read from base address + 0x50 offset to get the wBIOS balue. */
-			wBASE = (WORD) dRegValue;
-
-			/* Now read the interrupt line value */
-			dRegValue = pdev->irq;
-
-			wBIOS = ORC_RDWORD(wBASE, 0x50);
-
-			pci_set_master(pdev);
-
-#ifdef MMAPIO
-			base = wBASE & PAGE_MASK;
-			page_offset = wBASE - base;
-
-			/*
-			 * replace the next line with this one if you are using 2.1.x:
-			 * temp_p->maddr = ioremap(base, page_offset + 256);
-			 */
-			wBASE = ioremap(base, page_offset + 256);
-			if (wBASE) {
-				wBASE += page_offset;
-			}
-#endif
-
-			Addinia100_into_Adapter_table(wBIOS, wBASE, pdev, iAdapters);
-		}	/* while(pdev=....) */
-	}			/* PCI BIOS present */
-	return (iAdapters);
-}
-
-/*****************************************************************************
- Function name  : inia100_detect
- Description    : 
- Input          : pHCB  -       Pointer to host adapter structure
- Output         : None.
- Return         : pSRB  -       Pointer to SCSI request block.
-*****************************************************************************/
-int inia100_detect(Scsi_Host_Template * tpnt)
-{
-	ORC_HCS *pHCB;
-	struct Scsi_Host *hreg;
-	U32 sz;
-	U32 i;			/* 01/14/98                     */
-	int ok = 0, iAdapters;
-	ULONG dBiosAdr;
-	BYTE *pbBiosAdr;
-	struct pci_dev *pdev;
-
-	tpnt->proc_name = "inia100";
-	if (setup_called) {
-		/* Setup by inia100_setup          */
-		printk("inia100: processing commandline: ");
-	}
-	/* Get total number of adapters in the motherboard */
-	iAdapters = orc_ReturnNumberOfAdapters();
-
-	/* printk("inia100: Total Initio Adapters = %d\n", iAdapters); */
-	if (iAdapters == 0)	/* If no orc founded, return */
-		return (0);
-
-#if 0
-	printk("orc_num_scb= %x orc_num_ch= %x hcsize= %x scbsize= %x escbsize= %x\n",
-	       orc_num_scb, orc_num_ch, sizeof(ORC_HCS), sizeof(ORC_SCB), sizeof(ESCB));
-#endif
-
-	for (i = 0; i < iAdapters; i++) {
-		pdev = inia100_adpt[i].ADPT_pdev;
-		hreg = scsi_register(tpnt, sizeof(ORC_HCS));
-		if (hreg == NULL) {
-			goto out_disable;
-		}
-		pHCB = (ORC_HCS *)hreg->hostdata;
-		pHCB->pdev = pdev;
-		pHCB->pSRB_head = NULL;	/* Initial SRB save queue       */
-		pHCB->pSRB_tail = NULL;	/* Initial SRB save queue       */
-		pHCB->pSRB_lock = SPIN_LOCK_UNLOCKED; /* SRB save queue lock */
-		pHCB->BitAllocFlagLock = SPIN_LOCK_UNLOCKED;
-		/* Get total memory needed for SCB */
-		sz = ORC_MAXQUEUE * sizeof(ORC_SCB);
-		if ((pHCB->HCS_virScbArray = (PVOID) pci_alloc_consistent(pdev, sz, &pHCB->HCS_physScbArray)) == NULL) {
-			printk("inia100: SCB memory allocation error\n");
-			goto out_unregister;
-		}
-		memset((unsigned char *) pHCB->HCS_virScbArray, 0, sz);
-
-		/* Get total memory needed for ESCB */
-		sz = ORC_MAXQUEUE * sizeof(ESCB);
-		if ((pHCB->HCS_virEscbArray = (PVOID) pci_alloc_consistent(pdev, sz, &pHCB->HCS_physEscbArray)) == NULL) {
-			printk("inia100: ESCB memory allocation error\n");
-			goto out_unalloc;
-		}
-		memset((unsigned char *) pHCB->HCS_virEscbArray, 0, sz);
-
-		get_orcPCIConfig(pHCB, i);
-
-		dBiosAdr = pHCB->HCS_BIOS;
-		dBiosAdr = (dBiosAdr << 4);
-
-		pbBiosAdr = phys_to_virt(dBiosAdr);
-
-		if (init_orchid(pHCB)) {	/* Initial orchid chip    */
-			printk("inia100: initial orchid fail!!\n");
-			goto out_unalloc;
-		}
-		if (!request_region(pHCB->HCS_Base, 256, "inia100")) {
-			printk(KERN_WARNING "inia100: io port 0x%x, is busy.\n", 
-			       pHCB->HCS_Base);
-			return (0);
-		}
-
-		hreg->io_port = pHCB->HCS_Base;
-		hreg->n_io_port = 0xff;
-		hreg->can_queue = ORC_MAXQUEUE;	/* 03/05/98                   */
-
-		hreg->unique_id = pHCB->HCS_Base;
-		hreg->max_id = pHCB->HCS_MaxTar;
-
-		hreg->max_lun = 16;	/* 10/21/97                     */
-/*
-   hreg->max_lun = 8;
-   hreg->max_channel = 1;
- */
-		hreg->irq = pHCB->HCS_Intr;
-		hreg->this_id = pHCB->HCS_SCSI_ID;	/* Assign HCS index           */
-
-#if 1
-		hreg->sg_tablesize = TOTAL_SG_ENTRY;	/* Maximun support is 32 */
-#else
-		hreg->sg_tablesize = SG_NONE;	/* No SG                        */
-#endif
-
-		/* Initial orc chip           */
-		ok = request_irq(pHCB->HCS_Intr, inia100_intr, SA_SHIRQ, "inia100", hreg);
-		if (ok < 0) {
-			if (ok == -EINVAL) {
-				printk("inia100: bad IRQ %d.\n", pHCB->HCS_Intr);
-				printk("         Contact author.\n");
-			} else {
-				if (ok == -EBUSY)
-					printk("inia100: IRQ %d already in use. Configure another.\n", pHCB->HCS_Intr);
-				else {
-					printk("\ninia100: Unexpected error code on requesting IRQ %d.\n",
-					       pHCB->HCS_Intr);
-					printk("         Contact author.\n");
-				}
-			}
-			goto out_irq;
-		}
-	}
-
-	tpnt->this_id = -1;
-	tpnt->can_queue = 1;
-	kfree(inia100_adpt);
-	return 1;
-
-out_irq:
-        release_region(pHCB->HCS_Base, 256);
-out_unalloc:
-	if(pHCB->HCS_virEscbArray) {
-		pci_free_consistent(pHCB->pdev, ORC_MAXQUEUE * sizeof(ESCB),
-			pHCB->HCS_virEscbArray, pHCB->HCS_physEscbArray);
-		pHCB->HCS_virEscbArray = NULL;
-	}
-	if(pHCB->HCS_virScbArray) {
-		pci_free_consistent(pHCB->pdev, ORC_MAXQUEUE * sizeof(ORC_SCB),
-			pHCB->HCS_virScbArray, pHCB->HCS_physScbArray);
-		pHCB->HCS_virScbArray = NULL;
-	}
-out_unregister:
-	scsi_unregister(hreg);
-out_disable:
-	pci_disable_device(pdev);
-	kfree(inia100_adpt);
-	return i;
-}
-
-/*****************************************************************************
  Function name  : inia100BuildSCB
  Description    : 
  Input          : pHCB  -       Pointer to host adapter structure
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static void inia100BuildSCB(ORC_HCS * pHCB, ORC_SCB * pSCB, Scsi_Cmnd * SCpnt)
+static void inia100BuildSCB(ORC_HCS * pHCB, ORC_SCB * pSCB, struct scsi_cmnd * SCpnt)
 {				/* Create corresponding SCB     */
 	struct scatterlist *pSrbSG;
 	ORC_SG *pSG;		/* Pointer to SG list           */
@@ -479,7 +193,7 @@
 			TotalLen = 0;
 			pSrbSG = (struct scatterlist *) SCpnt->request_buffer;
 			count_sg = pci_map_sg(pHCB->pdev, pSrbSG, SCpnt->use_sg,
-				scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+					SCpnt->sc_data_direction);
 			pSCB->SCB_SGLen = (U32) (count_sg * 8);
 			for (i = 0; i < count_sg; i++, pSG++, pSrbSG++) {
 				pSG->SG_Ptr = (U32) sg_dma_address(pSrbSG);
@@ -490,7 +204,7 @@
 			pSCB->SCB_SGLen = 0x8;
 			pSG->SG_Ptr = (U32) pci_map_single(pHCB->pdev,
 				SCpnt->request_buffer, SCpnt->request_bufflen,
-				scsi_to_pci_dma_dir(SCpnt->sc_data_direction));
+				SCpnt->sc_data_direction);
 			SCpnt->host_scribble = (void *)pSG->SG_Ptr;
 			pSG->SG_Len = (U32) SCpnt->request_bufflen;
 		} else {
@@ -526,7 +240,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int inia100_queue(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	register ORC_SCB *pSCB;
 	ORC_HCS *pHCB;		/* Point to Host adapter control block */
@@ -553,7 +267,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_abort(Scsi_Cmnd * SCpnt)
+static int inia100_abort(struct scsi_cmnd * SCpnt)
 {
 	ORC_HCS *hcsp;
 
@@ -569,7 +283,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_bus_reset(Scsi_Cmnd * SCpnt)
+static int inia100_bus_reset(struct scsi_cmnd * SCpnt)
 {				/* I need Host Control Block Information */
 	ORC_HCS *pHCB;
 	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
@@ -583,7 +297,7 @@
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_device_reset(Scsi_Cmnd * SCpnt)
+static int inia100_device_reset(struct scsi_cmnd * SCpnt)
 {				/* I need Host Control Block Information */
 	ORC_HCS *pHCB;
 	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
@@ -602,7 +316,7 @@
 *****************************************************************************/
 void inia100SCBPost(BYTE * pHcb, BYTE * pScb)
 {
-	Scsi_Cmnd *pSRB;	/* Pointer to SCSI request block */
+	struct scsi_cmnd *pSRB;	/* Pointer to SCSI request block */
 	ORC_HCS *pHCB;
 	ORC_SCB *pSCB;
 	ESCB *pEScb;
@@ -610,7 +324,7 @@
 	pHCB = (ORC_HCS *) pHcb;
 	pSCB = (ORC_SCB *) pScb;
 	pEScb = pSCB->SCB_EScb;
-	if ((pSRB = (Scsi_Cmnd *) pEScb->SCB_Srb) == 0) {
+	if ((pSRB = (struct scsi_cmnd *) pEScb->SCB_Srb) == 0) {
 		printk("inia100SCBPost: SRB pointer is empty\n");
 		orc_release_scb(pHCB, pSCB);	/* Release SCB for current channel */
 		return;
@@ -676,47 +390,187 @@
 static irqreturn_t inia100_intr(int irqno, void *devid, struct pt_regs *regs)
 {
 	struct Scsi_Host *host = (struct Scsi_Host *)devid;
-	ORC_HCS *pHcb;
+	ORC_HCS *pHcb = (ORC_HCS *)host->hostdata;
 	unsigned long flags;
 
- 	pHcb = (ORC_HCS *)host->hostdata;	/* Host adapter control block */
 	spin_lock_irqsave(host->host_lock, flags);
 	orc_interrupt(pHcb);
 	spin_unlock_irqrestore(host->host_lock, flags);
+
 	return IRQ_HANDLED;
 }
 
-/* 
- * Dump the current driver status and panic...
- */
-static void inia100_panic(char *msg)
+static struct scsi_host_template inia100_template = {
+	.proc_name		= "inia100",
+	.name			= inia100_REVID,
+	.queuecommand		= inia100_queue,
+	.eh_abort_handler	= inia100_abort,
+	.eh_bus_reset_handler	= inia100_bus_reset,
+	.eh_device_reset_handler = inia100_device_reset,
+	.can_queue		= 1,
+	.this_id		= 1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun 		= 1,
+	.use_clustering		= ENABLE_CLUSTERING,
+};
+
+static int __devinit inia100_probe_one(struct pci_dev *pdev,
+		const struct pci_device_id *id)
 {
-	printk("\ninia100_panic: %s\n", msg);
-	panic("inia100 panic");
+	struct Scsi_Host *shost;
+	ORC_HCS *pHCB;
+	unsigned long port, bios;
+	int ok = -ENODEV;
+	u32 sz;
+	unsigned long dBiosAdr;
+	char *pbBiosAdr;
+
+	if (pci_enable_device(pdev))
+		goto out;
+	if (pci_set_dma_mask(pdev, 0xffffffffULL)) {
+		printk(KERN_WARNING "Unable to set 32bit DMA "
+				    "on inia100 adapter, ignoring.\n");
+		goto out_disable_device;
+	}
+
+	port = pci_resource_start(pdev, 0);
+	if (!request_region(pHCB->HCS_Base, 256, "inia100")) {
+		printk(KERN_WARNING "inia100: io port 0x%x, is busy.\n", 
+		       pHCB->HCS_Base);
+		goto out_disable_device; /* XXX: undo init_orchid() ?? */
+	}
+
+	/* <02> read from base address + 0x50 offset to get the bios balue. */
+	bios = ORC_RDWORD(port, 0x50);
+
+	pci_set_master(pdev);
+
+	shost = scsi_host_alloc(&inia100_template, sizeof(ORC_HCS));
+	if (!shost)
+		goto out_release_region;
+
+	pHCB = (ORC_HCS *)shost->hostdata;
+	pHCB->pdev = pdev;
+	pHCB->HCS_Base = port;
+	pHCB->HCS_BIOS = bios;
+	pHCB->pSRB_head = NULL;	/* Initial SRB save queue       */
+	pHCB->pSRB_tail = NULL;	/* Initial SRB save queue       */
+	pHCB->pSRB_lock = SPIN_LOCK_UNLOCKED; /* SRB save queue lock */
+	pHCB->BitAllocFlagLock = SPIN_LOCK_UNLOCKED;
+
+	/* Get total memory needed for SCB */
+	sz = ORC_MAXQUEUE * sizeof(ORC_SCB);
+	pHCB->HCS_virScbArray = pci_alloc_consistent(pdev, sz, &pHCB->HCS_physScbArray);
+	if (!pHCB->HCS_virScbArray) {
+		printk("inia100: SCB memory allocation error\n");
+		goto out_host_put;
+	}
+	memset(pHCB->HCS_virScbArray, 0, sz);
+
+	/* Get total memory needed for ESCB */
+	sz = ORC_MAXQUEUE * sizeof(ESCB);
+	pHCB->HCS_virEscbArray = pci_alloc_consistent(pdev, sz, &pHCB->HCS_physEscbArray);
+	if (!pHCB->HCS_virEscbArray) {
+		printk("inia100: ESCB memory allocation error\n");
+		goto out_free_scb_array;
+	}
+	memset(pHCB->HCS_virEscbArray, 0, sz);
+
+	dBiosAdr = pHCB->HCS_BIOS;
+	dBiosAdr = (dBiosAdr << 4);
+	pbBiosAdr = phys_to_virt(dBiosAdr);
+	if (init_orchid(pHCB)) {	/* Initialize orchid chip */
+		printk("inia100: initial orchid fail!!\n");
+		goto out_free_escb_array;
+	}
+
+	shost->io_port = pHCB->HCS_Base;
+	shost->n_io_port = 0xff;
+	shost->can_queue = ORC_MAXQUEUE;
+	shost->unique_id = shost->io_port;
+	shost->max_id = pHCB->HCS_MaxTar;
+	shost->max_lun = 16;
+	shost->irq = pHCB->HCS_Intr;
+	shost->this_id = pHCB->HCS_SCSI_ID;	/* Assign HCS index */
+	shost->sg_tablesize = TOTAL_SG_ENTRY;
+
+	/* Initial orc chip           */
+	ok = request_irq(pHCB->HCS_Intr, inia100_intr, SA_SHIRQ, "inia100", shost);
+	if (ok < 0) {
+		printk(KERN_WARNING "inia100: unable to get irq %d\n", pHCB->HCS_Intr);
+		goto out_free_escb_array;
+	}
+
+	pci_set_drvdata(pdev, shost);
+
+	ok = scsi_add_host(shost, &pdev->dev);
+	if (!ok)
+		goto out_free_irq;
+
+	scsi_scan_host(shost);
+	return 0;
+
+ out_free_irq:
+        free_irq(shost->irq, shost);
+ out_free_escb_array:
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ESCB),
+			pHCB->HCS_virEscbArray, pHCB->HCS_physEscbArray);
+ out_free_scb_array:
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ORC_SCB),
+			pHCB->HCS_virScbArray, pHCB->HCS_physScbArray);
+ out_host_put:
+	scsi_host_put(shost);
+ out_release_region:
+        release_region(pHCB->HCS_Base, 256);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return ok;
 }
 
-/*
- * Release ressources
- */
-static int inia100_release(struct Scsi_Host *hreg)
+static void __devexit inia100_remove_one(struct pci_dev *pdev)
 {
-	ORC_HCS *pHCB = (ORC_HCS *)hreg->hostdata;
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	ORC_HCS *pHCB = (ORC_HCS *)shost->hostdata;
+
+	scsi_remove_host(shost);
 
-        free_irq(hreg->irq, hreg);
-        release_region(hreg->io_port, 256);
-	if(pHCB->HCS_virEscbArray) {
-		pci_free_consistent(pHCB->pdev, ORC_MAXQUEUE * sizeof(ESCB),
+        free_irq(shost->irq, shost);
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ESCB),
 			pHCB->HCS_virEscbArray, pHCB->HCS_physEscbArray);
-		pHCB->HCS_virEscbArray = NULL;
-	}
-	if(pHCB->HCS_virScbArray) {
-		pci_free_consistent(pHCB->pdev, ORC_MAXQUEUE * sizeof(ORC_SCB),
+	pci_free_consistent(pdev, ORC_MAXQUEUE * sizeof(ORC_SCB),
 			pHCB->HCS_virScbArray, pHCB->HCS_physScbArray);
-		pHCB->HCS_virScbArray = NULL;
-	}
-	pci_disable_device(pHCB->pdev);
-        return 0;
+        release_region(shost->io_port, 256);
+
+	scsi_host_put(shost);
 } 
 
+static struct pci_device_id inia100_pci_tbl[] = {
+	{ORC_VENDOR_ID, ORC_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, inia100_pci_tbl);
+
+static struct pci_driver inia100_pci_driver = {
+	.name		= "inia100",
+	.id_table	= inia100_pci_tbl,
+	.probe		= inia100_probe_one,
+	.remove		= __devexit_p(inia100_remove_one),
+};
+
+static int __init inia100_init(void)
+{
+	return pci_module_init(&inia100_pci_driver);
+}
+
+static void __exit inia100_exit(void)
+{
+	pci_unregister_driver(&inia100_pci_driver);
+}
+
+MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
+MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");
-/*#include "inia100scsi.c" */
+
+module_init(inia100_init);
+module_exit(inia100_exit);
===== drivers/scsi/inia100.h 1.16 vs edited =====
--- 1.16/drivers/scsi/inia100.h	Tue Sep  2 02:20:32 2003
+++ edited/drivers/scsi/inia100.h	Tue Nov 18 09:18:52 2003
@@ -67,13 +67,6 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
-static int inia100_detect(Scsi_Host_Template *);
-static int inia100_release(struct Scsi_Host *);
-static int inia100_queue(Scsi_Cmnd *, void (*done) (Scsi_Cmnd *));
-static int inia100_abort(Scsi_Cmnd *);
-static int inia100_device_reset(Scsi_Cmnd *);
-static int inia100_bus_reset(Scsi_Cmnd *);
-
 #define inia100_REVID "Initio INI-A100U2W SCSI device driver; Revision: 1.02d"
 
 #define ULONG   unsigned long
@@ -115,13 +108,6 @@
 	U32 SG_Len;		/* Data Length */
 } ORC_SG;
 
-typedef struct inia100_Adpt_Struc {
-        UWORD ADPT_BIOS;        /* 0 */
-        UWORD ADPT_BASE;        /* 1 */
-        struct pci_dev *ADPT_pdev;      /* 2 */
-} INIA100_ADPT_STRUCT;
-
-
 /* SCSI related definition                                              */
 #define DISC_NOT_ALLOW          0x80	/* Disconnect is not allowed    */
 #define DISC_ALLOW              0xC0	/* Disconnect is allowed        */
@@ -211,7 +197,7 @@
 
 typedef struct orc_extended_scb {	/* Extended SCB                 */
 	ORC_SG ESCB_SGList[TOTAL_SG_ENTRY];	/*0 Start of SG list              */
-	Scsi_Cmnd *SCB_Srb;	/*50 SRB Pointer */
+	struct scsi_cmnd *SCB_Srb;	/*50 SRB Pointer */
 } ESCB;
 
 /***********************************************************************
@@ -344,8 +330,8 @@
 	ORC_TCS HCS_Tcs[16];	/* 28 */
 	U32 BitAllocFlag[MAX_CHANNELS][8];	/* Max STB is 256, So 256/32 */
 	spinlock_t BitAllocFlagLock;
-	Scsi_Cmnd *pSRB_head;
-	Scsi_Cmnd *pSRB_tail;
+	struct scsi_cmnd *pSRB_head;
+	struct scsi_cmnd *pSRB_tail;
 	spinlock_t pSRB_lock;
 	struct pci_dev *pdev;
 } ORC_HCS;
===== drivers/scsi/megaraid.c 1.56 vs edited =====
--- 1.56/drivers/scsi/megaraid.c	Thu Nov 13 07:58:04 2003
+++ edited/drivers/scsi/megaraid.c	Wed Nov 19 10:06:32 2003
@@ -14,6 +14,9 @@
  *	  - speed-ups (list handling fixes, issued_list, optimizations.)
  *	  - lots of cleanups.
  *
+ * Copyright (c) 2003  Christoph Hellwig  <hch@lst.de>
+ *	  - new-style, hotplug-aware pci probing and scsi registration
+ *
  * Version : v2.00.3 (Feb 19, 2003) - Atul Mukker <Atul.Mukker@lsil.com>
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
@@ -79,10 +82,6 @@
 static adapter_t *hba_soft_state[MAX_CONTROLLERS];
 static struct proc_dir_entry *mega_proc_dir_entry;
 
-static struct notifier_block mega_notifier = {
-	.notifier_call = megaraid_reboot_notify
-};
-
 /* For controller re-ordering */
 static struct mega_hbas mega_hbas[MAX_CONTROLLERS];
 
@@ -116,548 +115,6 @@
  */
 static int trace_level;
 
-/*
- * megaraid_validate_parms()
- *
- * Validate that any module parms passed in
- * have proper values.
- */
-static void
-megaraid_validate_parms(void)
-{
-	if( (max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN) )
-		max_cmd_per_lun = MAX_CMD_PER_LUN;
-	if( max_mbox_busy_wait > MBOX_BUSY_WAIT )
-		max_mbox_busy_wait = MBOX_BUSY_WAIT;
-}
-
-
-/**
- * megaraid_detect()
- * @host_template - Our soft state maintained by mid-layer
- *
- * the detect entry point for the mid-layer.
- * We scan the PCI bus for our controllers and start them.
- *
- * Note: PCI_DEVICE_ID_PERC4_DI below represents the PERC4/Di class of
- * products. All of them share the same vendor id, device id, and subsystem
- * vendor id but different subsystem ids. As of now, driver does not use the
- * subsystem id.
- */
-static int
-megaraid_detect(Scsi_Host_Template *host_template)
-{
-	int	i;
-	u16	dev_sw_table[] = {	/* Table of all supported
-					   vendor/device ids */
-
-		PCI_VENDOR_ID_DELL,		PCI_DEVICE_ID_DISCOVERY, 
-		PCI_VENDOR_ID_DELL,		PCI_DEVICE_ID_PERC4_DI, 
-		PCI_VENDOR_ID_LSI_LOGIC,	PCI_DEVICE_ID_PERC4_QC_VERDE, 
-		PCI_VENDOR_ID_AMI,		PCI_DEVICE_ID_AMI_MEGARAID, 
-		PCI_VENDOR_ID_AMI,		PCI_DEVICE_ID_AMI_MEGARAID2, 
-		PCI_VENDOR_ID_AMI,		PCI_DEVICE_ID_AMI_MEGARAID3, 
-		PCI_VENDOR_ID_INTEL,		PCI_DEVICE_ID_AMI_MEGARAID3, 
-		PCI_VENDOR_ID_LSI_LOGIC,	PCI_DEVICE_ID_AMI_MEGARAID3 };
-
-	host_template->proc_name = "megaraid";
-
-	printk(KERN_NOTICE "megaraid: " MEGARAID_VERSION);
-
-	megaraid_validate_parms();
-
-	memset(mega_hbas, 0, sizeof (mega_hbas));
-
-	hba_count = 0;
-
-	/*
-	 * Scan PCI bus for our all devices.
-	 */
-	for( i = 0; i < sizeof(dev_sw_table)/sizeof(u16); i += 2 ) {
-
-		mega_find_card(host_template, dev_sw_table[i],
-				dev_sw_table[i+1]);
-	}
-
-	if(hba_count) {
-		/*
-		 * re-order hosts so that one with bootable logical drive
-		 * comes first
-		 */
-#ifdef CONFIG_PROC_FS
-		mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
-
-		if(!mega_proc_dir_entry) {
-			printk(KERN_WARNING
-				"megaraid: failed to create megaraid root\n");
-		}
-		else {
-			for(i = 0; i < hba_count; i++) {
-				mega_create_proc_entry(i, mega_proc_dir_entry);
-			}
-		}
-#endif
-
-		/*
-		 * Register the driver as a character device, for applications
-		 * to access it for ioctls.
-		 * First argument (major) to register_chrdev implies a dynamic
-		 * major number allocation.
-		 */
-		major = register_chrdev(0, "megadev", &megadev_fops);
-
-		/*
-		 * Register the Shutdown Notification hook in kernel
-		 */
-		if(register_reboot_notifier(&mega_notifier)) {
-			printk(KERN_WARNING
-				"MegaRAID Shutdown routine not registered!!\n");
-		}
-
-	}
-
-	return hba_count;
-}
-
-
-
-/**
- * mega_find_card() - find and start this controller
- * @host_template - Our soft state maintained by mid-layer
- * @pci_vendor - pci vendor id for this controller
- * @pci_device - pci device id for this controller
- *
- * Scans the PCI bus for this vendor and device id combination, setup the
- * resources, and register ourselves as a SCSI HBA driver, and setup all
- * parameters for our soft state.
- *
- * This routine also checks for some buggy firmware and ajust the flags
- * accordingly.
- */
-static void
-mega_find_card(Scsi_Host_Template *host_template, u16 pci_vendor,
-	u16 pci_device)
-{
-	struct Scsi_Host	*host = NULL;
-	adapter_t	*adapter = NULL;
-	u32	magic64;
-	unsigned long	mega_baseport;
-	u16	subsysid, subsysvid;
-	u8	pci_bus;
-	u8	pci_dev_func;
-	u8	irq;
-	struct pci_dev	*pdev = NULL;
-	u8	did_ioremap_f = 0;
-	u8	did_req_region_f = 0;
-	u8	did_scsi_reg_f = 0;
-	u8	alloc_int_buf_f = 0;
-	u8	alloc_scb_f = 0;
-	u8	got_irq_f = 0;
-	u8	did_setup_mbox_f = 0;
-	unsigned long	tbase;
-	unsigned long	flag = 0;
-	int	i, j;
-
-	while((pdev = pci_find_device(pci_vendor, pci_device, pdev))) {
-
-		if(pci_enable_device (pdev)) continue;
-
-		pci_bus = pdev->bus->number;
-		pci_dev_func = pdev->devfn;
-
-		/*
-		 * For these vendor and device ids, signature offsets are not
-		 * valid and 64 bit is implicit
-		 */
-		if( (pci_vendor == PCI_VENDOR_ID_DELL &&
-			pci_device == PCI_DEVICE_ID_PERC4_DI) ||
-			(pci_vendor == PCI_VENDOR_ID_LSI_LOGIC &&
-			pci_device == PCI_DEVICE_ID_PERC4_QC_VERDE) ) {
-
-			flag |= BOARD_64BIT;
-		}
-		else {
-			pci_read_config_dword(pdev, PCI_CONF_AMISIG64,
-					&magic64);
-
-			if (magic64 == HBA_SIGNATURE_64BIT)
-				flag |= BOARD_64BIT;
-		}
-
-		subsysvid = pdev->subsystem_vendor;
-		subsysid = pdev->subsystem_device;
-
-		/*
-		 * If we do not find the valid subsys vendor id, refuse to
-		 * load the driver. This is part of PCI200X compliance
-		 * We load the driver if subsysvid is 0.
-		 */
-		if( subsysvid && (subsysvid != AMI_SUBSYS_VID) &&
-				(subsysvid != DELL_SUBSYS_VID) &&
-				(subsysvid != HP_SUBSYS_VID) &&
-				(subsysvid != INTEL_SUBSYS_VID) &&
-				(subsysvid != LSI_SUBSYS_VID) ) continue;
-
-
-		printk(KERN_NOTICE "megaraid: found 0x%4.04x:0x%4.04x:bus %d:",
-			pci_vendor, pci_device, pci_bus);
-
-		printk("slot %d:func %d\n",
-			PCI_SLOT(pci_dev_func), PCI_FUNC(pci_dev_func));
-
-		/* Read the base port and IRQ from PCI */
-		mega_baseport = pci_resource_start(pdev, 0);
-		irq = pdev->irq;
-
-		tbase = mega_baseport;
-
-		if( pci_resource_flags(pdev, 0) & IORESOURCE_MEM ) {
-
-			if (!request_mem_region(mega_baseport, 128,
-					"MegaRAID: LSI Logic Corporation.")) {
-				printk(KERN_WARNING
-					"megaraid: mem region busy!\n");
-				continue;
-			}
-
-			mega_baseport =
-				(unsigned long)ioremap(mega_baseport, 128);
-
-			if( !mega_baseport ) {
-				printk(KERN_WARNING
-					"megaraid: could not map hba memory\n");
-
-				release_mem_region(tbase, 128);
-
-				continue;
-			}
-
-			flag |= BOARD_MEMMAP;
-
-			did_ioremap_f = 1;
-		}
-		else {
-			mega_baseport += 0x10;
-
-			if( !request_region(mega_baseport, 16, "megaraid") )
-				goto fail_attach;
-
-			flag |= BOARD_IOMAP;
-
-			did_req_region_f = 1;
-		}
-
-		/* Initialize SCSI Host structure */
-		host = scsi_register(host_template, sizeof(adapter_t));
-
-		if(!host) goto fail_attach;
-
-		did_scsi_reg_f = 1;
-
-		scsi_set_device(host, &pdev->dev);
-
-		adapter = (adapter_t *)host->hostdata;
-		memset(adapter, 0, sizeof(adapter_t));
-
-		printk(KERN_NOTICE
-			"scsi%d:Found MegaRAID controller at 0x%lx, IRQ:%d\n",
-			host->host_no, mega_baseport, irq);
-
-		adapter->base = mega_baseport;
-
-		/* Copy resource info into structure */
-		INIT_LIST_HEAD(&adapter->free_list);
-		INIT_LIST_HEAD(&adapter->pending_list);
-		INIT_LIST_HEAD(&adapter->completed_list);
-
-		adapter->flag = flag;
-		spin_lock_init(&adapter->lock);
-		scsi_assign_lock(host, &adapter->lock);
-
-		host->cmd_per_lun = max_cmd_per_lun;
-		host->max_sectors = max_sectors_per_io;
-
-		adapter->dev = pdev;
-		adapter->host = host;
-
-		adapter->host->irq = irq;
-
-		if( flag & BOARD_MEMMAP ) {
-			adapter->host->base = tbase;
-		}
-		else {
-			adapter->host->io_port = tbase;
-			adapter->host->n_io_port = 16;
-		}
-
-		adapter->host->unique_id = (pci_bus << 8) | pci_dev_func;
-
-		/*
-		 * Allocate buffer to issue internal commands.
-		 */
-		adapter->mega_buffer = pci_alloc_consistent(adapter->dev,
-			MEGA_BUFFER_SIZE, &adapter->buf_dma_handle);
-
-		if( !adapter->mega_buffer ) {
-			printk(KERN_WARNING "megaraid: out of RAM.\n");
-			goto fail_attach;
-		}
-		alloc_int_buf_f = 1;
-
-		adapter->scb_list = kmalloc(sizeof(scb_t)*MAX_COMMANDS,
-				GFP_KERNEL);
-
-		if(!adapter->scb_list) {
-			printk(KERN_WARNING "megaraid: out of RAM.\n");
-			goto fail_attach;
-		}
-
-		alloc_scb_f = 1;
-
-		/* Request our IRQ */
-		if( adapter->flag & BOARD_MEMMAP ) {
-			if(request_irq(irq, megaraid_isr_memmapped, SA_SHIRQ,
-						"megaraid", adapter)) {
-				printk(KERN_WARNING
-					"megaraid: Couldn't register IRQ %d!\n",
-					irq);
-				goto fail_attach;
-			}
-		}
-		else {
-			if(request_irq(irq, megaraid_isr_iomapped, SA_SHIRQ,
-						"megaraid", adapter)) {
-				printk(KERN_WARNING
-					"megaraid: Couldn't register IRQ %d!\n",
-					irq);
-				goto fail_attach;
-			}
-		}
-		got_irq_f = 1;
-
-		if( mega_setup_mailbox(adapter) != 0 )
-			goto fail_attach;
-
-		did_setup_mbox_f = 1;
-
-		if( mega_query_adapter(adapter) != 0 )
-			goto fail_attach;
-
-		/*
-		 * Have checks for some buggy f/w
-		 */
-		if((subsysid == 0x1111) && (subsysvid == 0x1111)) {
-			/*
-			 * Which firmware
-			 */
-			if (!strcmp(adapter->fw_version, "3.00") ||
-					!strcmp(adapter->fw_version, "3.01")) {
-
-				printk( KERN_WARNING
-					"megaraid: Your  card is a Dell PERC "
-					"2/SC RAID controller with  "
-					"firmware\nmegaraid: 3.00 or 3.01.  "
-					"This driver is known to have "
-					"corruption issues\nmegaraid: with "
-					"those firmware versions on this "
-					"specific card.  In order\nmegaraid: "
-					"to protect your data, please upgrade "
-					"your firmware to version\nmegaraid: "
-					"3.10 or later, available from the "
-					"Dell Technical Support web\n"
-					"megaraid: site at\nhttp://support."
-					"dell.com/us/en/filelib/download/"
-					"index.asp?fileid=2940\n"
-				);
-			}
-		}
-
-		/*
-		 * If we have a HP 1M(0x60E7)/2M(0x60E8) controller with
-		 * firmware H.01.07, H.01.08, and H.01.09 disable 64 bit
-		 * support, since this firmware cannot handle 64 bit
-		 * addressing
-		 */
-
-		if((subsysvid == HP_SUBSYS_VID) &&
-				((subsysid == 0x60E7)||(subsysid == 0x60E8))) {
-
-			/*
-			 * which firmware
-			 */
-			if( !strcmp(adapter->fw_version, "H01.07") ||
-				!strcmp(adapter->fw_version, "H01.08") ||
-				!strcmp(adapter->fw_version, "H01.09") ) {
-
-				printk(KERN_WARNING
-					"megaraid: Firmware H.01.07, "
-					"H.01.08, and H.01.09 on 1M/2M "
-					"controllers\n"
-					"megaraid: do not support 64 bit "
-					"addressing.\nmegaraid: DISABLING "
-					"64 bit support.\n");
-				adapter->flag &= ~BOARD_64BIT;
-			}
-		}
-
-
-		if(mega_is_bios_enabled(adapter)) {
-			mega_hbas[hba_count].is_bios_enabled = 1;
-		}
-		mega_hbas[hba_count].hostdata_addr = adapter;
-
-		/*
-		 * Find out which channel is raid and which is scsi. This is
-		 * for ROMB support.
-		 */
-		mega_enum_raid_scsi(adapter);
-
-		/*
-		 * Find out if a logical drive is set as the boot drive. If
-		 * there is one, will make that as the first logical drive.
-		 * ROMB: Do we have to boot from a physical drive. Then all
-		 * the physical drives would appear before the logical disks.
-		 * Else, all the physical drives would be exported to the mid
-		 * layer after logical drives.
-		 */
-		mega_get_boot_drv(adapter);
-
-		if( ! adapter->boot_pdrv_enabled ) {
-			for( i = 0; i < NVIRT_CHAN; i++ )
-				adapter->logdrv_chan[i] = 1;
-
-			for( i = NVIRT_CHAN; i<MAX_CHANNELS+NVIRT_CHAN; i++ )
-				adapter->logdrv_chan[i] = 0;
-
-			adapter->mega_ch_class <<= NVIRT_CHAN;
-		}
-		else {
-			j = adapter->product_info.nchannels;
-			for( i = 0; i < j; i++ )
-				adapter->logdrv_chan[i] = 0;
-
-			for( i = j; i < NVIRT_CHAN + j; i++ )
-				adapter->logdrv_chan[i] = 1;
-		}
-
-
-		/*
-		 * Do we support random deletion and addition of logical
-		 * drives
-		 */
-		adapter->read_ldidmap = 0;	/* set it after first logdrv
-						   delete cmd */
-		adapter->support_random_del = mega_support_random_del(adapter);
-
-		/* Initialize SCBs */
-		if(mega_init_scb(adapter)) {
-			goto fail_attach;
-		}
-
-		/*
-		 * Reset the pending commands counter
-		 */
-		atomic_set(&adapter->pend_cmds, 0);
-
-		/*
-		 * Reset the adapter quiescent flag
-		 */
-		atomic_set(&adapter->quiescent, 0);
-
-		hba_soft_state[hba_count] = adapter;
-
-		/*
-		 * Fill in the structure which needs to be passed back to the
-		 * application when it does an ioctl() for controller related
-		 * information.
-		 */
-		i = hba_count;
-
-		mcontroller[i].base = mega_baseport;
-		mcontroller[i].irq = irq;
-		mcontroller[i].numldrv = adapter->numldrv;
-		mcontroller[i].pcibus = pci_bus;
-		mcontroller[i].pcidev = pci_device;
-		mcontroller[i].pcifun = PCI_FUNC (pci_dev_func);
-		mcontroller[i].pciid = -1;
-		mcontroller[i].pcivendor = pci_vendor;
-		mcontroller[i].pcislot = PCI_SLOT (pci_dev_func);
-		mcontroller[i].uid = (pci_bus << 8) | pci_dev_func;
-
-
-		/* Set the Mode of addressing to 64 bit if we can */
-		if((adapter->flag & BOARD_64BIT)&&(sizeof(dma_addr_t) == 8)) {
-			pci_set_dma_mask(pdev, 0xffffffffffffffffULL);
-			adapter->has_64bit_addr = 1;
-		}
-		else  {
-			pci_set_dma_mask(pdev, 0xffffffff);
-			adapter->has_64bit_addr = 0;
-		}
-		
-		init_MUTEX(&adapter->int_mtx);
-		init_waitqueue_head(&adapter->int_waitq);
-
-		adapter->this_id = DEFAULT_INITIATOR_ID;
-		adapter->host->this_id = DEFAULT_INITIATOR_ID;
-
-#if MEGA_HAVE_CLUSTERING
-		/*
-		 * Is cluster support enabled on this controller
-		 * Note: In a cluster the HBAs ( the initiators ) will have
-		 * different target IDs and we cannot assume it to be 7. Call
-		 * to mega_support_cluster() will get the target ids also if
-		 * the cluster support is available
-		 */
-		adapter->has_cluster = mega_support_cluster(adapter);
-
-		if( adapter->has_cluster ) {
-			printk(KERN_NOTICE
-				"megaraid: Cluster driver, initiator id:%d\n",
-				adapter->this_id);
-		}
-#endif
-
-		hba_count++;
-		continue;
-
-fail_attach:
-		if( did_setup_mbox_f ) {
-			pci_free_consistent(adapter->dev, sizeof(mbox64_t),
-					(void *)adapter->una_mbox64,
-					adapter->una_mbox64_dma);
-		}
-
-		if( got_irq_f ) {
-			irq_disable(adapter);
-			free_irq(adapter->host->irq, adapter);
-		}
-
-		if( alloc_scb_f ) {
-			kfree(adapter->scb_list);
-		}
-
-		if( alloc_int_buf_f ) {
-			pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
-					(void *)adapter->mega_buffer,
-					adapter->buf_dma_handle);
-		}
-
-		if( did_scsi_reg_f ) scsi_unregister(host);
-
-		if( did_ioremap_f ) {
-			iounmap((void *)mega_baseport);
-			release_mem_region(tbase, 128);
-		}
-
-		if( did_req_region_f )
-			release_region(mega_baseport, 16);
-	}
-
-	return;
-}
-
-
 /**
  * mega_setup_mailbox()
  * @adapter - pointer to our soft state
@@ -2396,126 +1853,6 @@
 		enquiry3->pdrv_state[i] = inquiry->pdrv_info.pdrv_state[i];
 }
 
-/*
- * Release the controller's resources
- */
-static int
-megaraid_release(struct Scsi_Host *host)
-{
-	adapter_t	*adapter;
-	mbox_t	*mbox;
-	u_char	raw_mbox[sizeof(struct mbox_out)];
-	char	buf[12] = { 0 };
-
-	adapter = (adapter_t *)host->hostdata;
-	mbox = (mbox_t *)raw_mbox;
-
-	printk(KERN_NOTICE "megaraid: being unloaded...");
-
-	/* Flush adapter cache */
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
-	raw_mbox[0] = FLUSH_ADAPTER;
-
-	irq_disable(adapter);
-	free_irq(adapter->host->irq, adapter);
-
-	/* Issue a blocking (interrupts disabled) command to the card */
-	issue_scb_block(adapter, raw_mbox);
-
-	/* Flush disks cache */
-	memset(&mbox->m_out, 0, sizeof(raw_mbox));
-	raw_mbox[0] = FLUSH_SYSTEM;
-
-	/* Issue a blocking (interrupts disabled) command to the card */
-	issue_scb_block(adapter, raw_mbox);
-
-
-	/* Free our resources */
-	if( adapter->flag & BOARD_MEMMAP ) {
-		iounmap((void *)adapter->base);
-		release_mem_region(adapter->host->base, 128);
-	}
-	else {
-		release_region(adapter->base, 16);
-	}
-
-	mega_free_sgl(adapter);
-
-#ifdef CONFIG_PROC_FS
-	if( adapter->controller_proc_dir_entry ) {
-		remove_proc_entry("stat", adapter->controller_proc_dir_entry);
-		remove_proc_entry("config",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("mailbox",
-				adapter->controller_proc_dir_entry);
-#if MEGA_HAVE_ENH_PROC
-		remove_proc_entry("rebuild-rate",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("battery-status",
-				adapter->controller_proc_dir_entry);
-
-		remove_proc_entry("diskdrives-ch0",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("diskdrives-ch1",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("diskdrives-ch2",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("diskdrives-ch3",
-				adapter->controller_proc_dir_entry);
-
-		remove_proc_entry("raiddrives-0-9",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("raiddrives-10-19",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("raiddrives-20-29",
-				adapter->controller_proc_dir_entry);
-		remove_proc_entry("raiddrives-30-39",
-				adapter->controller_proc_dir_entry);
-#endif
-
-		sprintf(buf, "hba%d", adapter->host->host_no);
-		remove_proc_entry(buf, mega_proc_dir_entry);
-	}
-#endif
-
-	pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
-			adapter->mega_buffer, adapter->buf_dma_handle);
-	kfree(adapter->scb_list);
-	pci_free_consistent(adapter->dev, sizeof(mbox64_t),
-			(void *)adapter->una_mbox64, adapter->una_mbox64_dma);
-
-	hba_count--;
-
-	if( hba_count == 0 ) {
-
-		/*
-		 * Unregister the character device interface to the driver.
-		 */
-		unregister_chrdev(major, "megadev");
-
-		unregister_reboot_notifier(&mega_notifier);
-
-#ifdef CONFIG_PROC_FS
-		if( adapter->controller_proc_dir_entry ) {
-			remove_proc_entry ("megaraid", &proc_root);
-		}
-#endif
-
-	}
-
-	/*
-	 * Release the controller memory. A word of warning this frees
-	 * hostdata and that includes adapter-> so be careful what you
-	 * dereference beyond this point
-	 */
-	scsi_unregister(host);
-
-
-	printk("ok.\n");
-
-	return 0;
-}
-
 static inline void
 mega_free_sgl(adapter_t *adapter)
 {
@@ -3850,76 +3187,6 @@
 }
 
 /**
- * megaraid_reboot_notify()
- * @this - unused
- * @code - shutdown code
- * @unused - unused
- *
- * This routine will be called when the use has done a forced shutdown on the
- * system. Flush the Adapter and disks cache.
- */
-static int
-megaraid_reboot_notify (struct notifier_block *this, unsigned long code,
-		void *unused)
-{
-	adapter_t *adapter;
-	struct Scsi_Host *host;
-	u8 raw_mbox[sizeof(struct mbox_out)];
-	mbox_t *mbox;
-	int i,j;
-
-	/*
-	 * Flush the controller's cache irrespective of the codes coming down.
-	 * SYS_DOWN, SYS_HALT, SYS_RESTART, SYS_POWER_OFF
-	 */
-	for( i = 0; i < hba_count; i++ ) {
-		printk(KERN_INFO "megaraid: flushing adapter %d..", i);
-		host = hba_soft_state[i]->host;
-
-		adapter = (adapter_t *)host->hostdata;
-		mbox = (mbox_t *)raw_mbox;
-
-		/* Flush adapter cache */
-		memset(&mbox->m_out, 0, sizeof(raw_mbox));
-		raw_mbox[0] = FLUSH_ADAPTER;
-
-		irq_disable(adapter);
-		free_irq(adapter->host->irq, adapter);
-
-		/*
-		 * Issue a blocking (interrupts disabled) command to
-		 * the card
-		 */
-		issue_scb_block(adapter, raw_mbox);
-
-		/* Flush disks cache */
-		memset(&mbox->m_out, 0, sizeof(raw_mbox));
-		raw_mbox[0] = FLUSH_SYSTEM;
-
-		issue_scb_block(adapter, raw_mbox);
-
-		printk("Done.\n");
-
-		if( atomic_read(&adapter->pend_cmds) > 0 ) {
-			printk(KERN_WARNING "megaraid: pending commands!!\n");
-		}
-	}
-
-	/*
-	 * Have a delibrate delay to make sure all the caches are
-	 * actually flushed.
-	 */
-	printk("megaraid: cache flush delay: ");
-	for( j = 10; j >= 0; j-- ) {
-		printk("[%d] ", j);
-		mdelay(1000);
-	}
-	printk("\n");
-
-	return NOTIFY_DONE;
-}
-
-/**
  * mega_init_scb()
  * @adapter - pointer to our soft state
  *
@@ -5345,24 +4612,553 @@
 	kfree(pdev);
 }
 
-static Scsi_Host_Template driver_template = {
-	.name =				"MegaRAID",
-	.detect =			megaraid_detect,
-	.release =			megaraid_release,
-	.info =				megaraid_info,
-	.queuecommand =			megaraid_queue,	
-	.bios_param =			megaraid_biosparam,
-	.max_sectors =			MAX_SECTORS_PER_IO,
-	.can_queue =			MAX_COMMANDS,
-	.this_id =			DEFAULT_INITIATOR_ID,
-	.sg_tablesize =			MAX_SGLIST,
-	.cmd_per_lun =			DEF_CMD_PER_LUN,
-	.use_clustering =		ENABLE_CLUSTERING,
-	.eh_abort_handler =		megaraid_abort,
-	.eh_device_reset_handler =	megaraid_reset,
-	.eh_bus_reset_handler =		megaraid_reset,
-	.eh_host_reset_handler =	megaraid_reset,
+static struct scsi_host_template megaraid_template = {
+	.name				= "MegaRAID",
+	.proc_name			= "megaraid",
+	.info				= megaraid_info,
+	.queuecommand			= megaraid_queue,	
+	.bios_param			= megaraid_biosparam,
+	.max_sectors			= MAX_SECTORS_PER_IO,
+	.can_queue			= MAX_COMMANDS,
+	.this_id			= DEFAULT_INITIATOR_ID,
+	.sg_tablesize			= MAX_SGLIST,
+	.cmd_per_lun			= DEF_CMD_PER_LUN,
+	.use_clustering			= ENABLE_CLUSTERING,
+	.eh_abort_handler		= megaraid_abort,
+	.eh_device_reset_handler	= megaraid_reset,
+	.eh_bus_reset_handler		= megaraid_reset,
+	.eh_host_reset_handler		= megaraid_reset,
 };
-#include "scsi_module.c"
+
+static int __devinit
+megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct Scsi_Host *host;
+	adapter_t *adapter;
+	unsigned long mega_baseport, tbase, flag = 0;
+	u16 subsysid, subsysvid;
+	u8 pci_bus, pci_dev_func;
+	int irq, i, j;
+	int error = -ENODEV;
+
+	if (pci_enable_device(pdev))
+		goto out;
+
+	pci_bus = pdev->bus->number;
+	pci_dev_func = pdev->devfn;
+
+	/*
+	 * For these vendor and device ids, signature offsets are not
+	 * valid and 64 bit is implicit
+	 */
+	if (id->driver_data & BOARD_64BIT)
+		flag |= BOARD_64BIT;
+	else {
+		u32 magic64;
+
+		pci_read_config_dword(pdev, PCI_CONF_AMISIG64, &magic64);
+		if (magic64 == HBA_SIGNATURE_64BIT)
+			flag |= BOARD_64BIT;
+	}
+
+	subsysvid = pdev->subsystem_vendor;
+	subsysid = pdev->subsystem_device;
+
+	printk(KERN_NOTICE "megaraid: found 0x%4.04x:0x%4.04x:bus %d:",
+		id->vendor, id->device, pci_bus);
+
+	printk("slot %d:func %d\n",
+		PCI_SLOT(pci_dev_func), PCI_FUNC(pci_dev_func));
+
+	/* Read the base port and IRQ from PCI */
+	mega_baseport = pci_resource_start(pdev, 0);
+	irq = pdev->irq;
+
+	tbase = mega_baseport;
+	if (pci_resource_flags(pdev, 0) & IORESOURCE_MEM) {
+		flag |= BOARD_MEMMAP;
+
+		if (!request_mem_region(mega_baseport, 128, "megaraid")) {
+			printk(KERN_WARNING "megaraid: mem region busy!\n");
+			goto out_disable_device;
+		}
+
+		mega_baseport = (unsigned long)ioremap(mega_baseport, 128);
+		if (!mega_baseport) {
+			printk(KERN_WARNING
+			       "megaraid: could not map hba memory\n");
+			goto out_release_region;
+		}
+	} else {
+		flag |= BOARD_IOMAP;
+		mega_baseport += 0x10;
+
+		if (!request_region(mega_baseport, 16, "megaraid"))
+			goto out_disable_device;
+	}
+
+	/* Initialize SCSI Host structure */
+	host = scsi_host_alloc(&megaraid_template, sizeof(adapter_t));
+	if (!host)
+		goto out_iounmap;
+
+	adapter = (adapter_t *)host->hostdata;
+	memset(adapter, 0, sizeof(adapter_t));
+
+	printk(KERN_NOTICE
+		"scsi%d:Found MegaRAID controller at 0x%lx, IRQ:%d\n",
+		host->host_no, mega_baseport, irq);
+
+	adapter->base = mega_baseport;
+
+	INIT_LIST_HEAD(&adapter->free_list);
+	INIT_LIST_HEAD(&adapter->pending_list);
+	INIT_LIST_HEAD(&adapter->completed_list);
+
+	adapter->flag = flag;
+	spin_lock_init(&adapter->lock);
+	scsi_assign_lock(host, &adapter->lock);
+
+	host->cmd_per_lun = max_cmd_per_lun;
+	host->max_sectors = max_sectors_per_io;
+
+	adapter->dev = pdev;
+	adapter->host = host;
+
+	adapter->host->irq = irq;
+
+	if (flag & BOARD_MEMMAP)
+		adapter->host->base = tbase;
+	else {
+		adapter->host->io_port = tbase;
+		adapter->host->n_io_port = 16;
+	}
+
+	adapter->host->unique_id = (pci_bus << 8) | pci_dev_func;
+
+	/*
+	 * Allocate buffer to issue internal commands.
+	 */
+	adapter->mega_buffer = pci_alloc_consistent(adapter->dev,
+		MEGA_BUFFER_SIZE, &adapter->buf_dma_handle);
+	if (!adapter->mega_buffer) {
+		printk(KERN_WARNING "megaraid: out of RAM.\n");
+		goto out_host_put;
+	}
+
+	adapter->scb_list = kmalloc(sizeof(scb_t) * MAX_COMMANDS, GFP_KERNEL);
+	if (!adapter->scb_list) {
+		printk(KERN_WARNING "megaraid: out of RAM.\n");
+		goto out_free_cmd_buffer;
+	}
+
+	if (request_irq(irq, (adapter->flag & BOARD_MEMMAP) ?
+				megaraid_isr_memmapped : megaraid_isr_iomapped,
+					SA_SHIRQ, "megaraid", adapter)) {
+		printk(KERN_WARNING
+			"megaraid: Couldn't register IRQ %d!\n", irq);
+		goto out_free_scb_list;
+	}
+
+	if (mega_setup_mailbox(adapter))
+		goto out_free_irq;
+
+	if (mega_query_adapter(adapter))
+		goto out_free_mbox;
+
+	/*
+	 * Have checks for some buggy f/w
+	 */
+	if ((subsysid == 0x1111) && (subsysvid == 0x1111)) {
+		/*
+		 * Which firmware
+		 */
+		if (!strcmp(adapter->fw_version, "3.00") ||
+				!strcmp(adapter->fw_version, "3.01")) {
+
+			printk( KERN_WARNING
+				"megaraid: Your  card is a Dell PERC "
+				"2/SC RAID controller with  "
+				"firmware\nmegaraid: 3.00 or 3.01.  "
+				"This driver is known to have "
+				"corruption issues\nmegaraid: with "
+				"those firmware versions on this "
+				"specific card.  In order\nmegaraid: "
+				"to protect your data, please upgrade "
+				"your firmware to version\nmegaraid: "
+				"3.10 or later, available from the "
+				"Dell Technical Support web\n"
+				"megaraid: site at\nhttp://support."
+				"dell.com/us/en/filelib/download/"
+				"index.asp?fileid=2940\n"
+			);
+		}
+	}
+
+	/*
+	 * If we have a HP 1M(0x60E7)/2M(0x60E8) controller with
+	 * firmware H.01.07, H.01.08, and H.01.09 disable 64 bit
+	 * support, since this firmware cannot handle 64 bit
+	 * addressing
+	 */
+	if ((subsysvid == HP_SUBSYS_VID) &&
+	    ((subsysid == 0x60E7) || (subsysid == 0x60E8))) {
+		/*
+		 * which firmware
+		 */
+		if (!strcmp(adapter->fw_version, "H01.07") ||
+		    !strcmp(adapter->fw_version, "H01.08") ||
+		    !strcmp(adapter->fw_version, "H01.09") ) {
+			printk(KERN_WARNING
+				"megaraid: Firmware H.01.07, "
+				"H.01.08, and H.01.09 on 1M/2M "
+				"controllers\n"
+				"megaraid: do not support 64 bit "
+				"addressing.\nmegaraid: DISABLING "
+				"64 bit support.\n");
+			adapter->flag &= ~BOARD_64BIT;
+		}
+	}
+
+	if (mega_is_bios_enabled(adapter))
+		mega_hbas[hba_count].is_bios_enabled = 1;
+	mega_hbas[hba_count].hostdata_addr = adapter;
+
+	/*
+	 * Find out which channel is raid and which is scsi. This is
+	 * for ROMB support.
+	 */
+	mega_enum_raid_scsi(adapter);
+
+	/*
+	 * Find out if a logical drive is set as the boot drive. If
+	 * there is one, will make that as the first logical drive.
+	 * ROMB: Do we have to boot from a physical drive. Then all
+	 * the physical drives would appear before the logical disks.
+	 * Else, all the physical drives would be exported to the mid
+	 * layer after logical drives.
+	 */
+	mega_get_boot_drv(adapter);
+
+	if (adapter->boot_pdrv_enabled) {
+		j = adapter->product_info.nchannels;
+		for( i = 0; i < j; i++ )
+			adapter->logdrv_chan[i] = 0;
+		for( i = j; i < NVIRT_CHAN + j; i++ )
+			adapter->logdrv_chan[i] = 1;
+	} else {
+		for (i = 0; i < NVIRT_CHAN; i++)
+			adapter->logdrv_chan[i] = 1;
+		for (i = NVIRT_CHAN; i < MAX_CHANNELS+NVIRT_CHAN; i++)
+			adapter->logdrv_chan[i] = 0;
+		adapter->mega_ch_class <<= NVIRT_CHAN;
+	}
+
+	/*
+	 * Do we support random deletion and addition of logical
+	 * drives
+	 */
+	adapter->read_ldidmap = 0;	/* set it after first logdrv
+						   delete cmd */
+	adapter->support_random_del = mega_support_random_del(adapter);
+
+	/* Initialize SCBs */
+	if (mega_init_scb(adapter))
+		goto out_free_mbox;
+
+	/*
+	 * Reset the pending commands counter
+	 */
+	atomic_set(&adapter->pend_cmds, 0);
+
+	/*
+	 * Reset the adapter quiescent flag
+	 */
+	atomic_set(&adapter->quiescent, 0);
+
+	hba_soft_state[hba_count] = adapter;
+
+	/*
+	 * Fill in the structure which needs to be passed back to the
+	 * application when it does an ioctl() for controller related
+	 * information.
+	 */
+	i = hba_count;
+
+	mcontroller[i].base = mega_baseport;
+	mcontroller[i].irq = irq;
+	mcontroller[i].numldrv = adapter->numldrv;
+	mcontroller[i].pcibus = pci_bus;
+	mcontroller[i].pcidev = id->device;
+	mcontroller[i].pcifun = PCI_FUNC (pci_dev_func);
+	mcontroller[i].pciid = -1;
+	mcontroller[i].pcivendor = id->vendor;
+	mcontroller[i].pcislot = PCI_SLOT(pci_dev_func);
+	mcontroller[i].uid = (pci_bus << 8) | pci_dev_func;
+
+
+	/* Set the Mode of addressing to 64 bit if we can */
+	if ((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) == 8)) {
+		pci_set_dma_mask(pdev, 0xffffffffffffffffULL);
+		adapter->has_64bit_addr = 1;
+	} else  {
+		pci_set_dma_mask(pdev, 0xffffffff);
+		adapter->has_64bit_addr = 0;
+	}
+		
+	init_MUTEX(&adapter->int_mtx);
+	init_waitqueue_head(&adapter->int_waitq);
+
+	adapter->this_id = DEFAULT_INITIATOR_ID;
+	adapter->host->this_id = DEFAULT_INITIATOR_ID;
+
+#if MEGA_HAVE_CLUSTERING
+	/*
+	 * Is cluster support enabled on this controller
+	 * Note: In a cluster the HBAs ( the initiators ) will have
+	 * different target IDs and we cannot assume it to be 7. Call
+	 * to mega_support_cluster() will get the target ids also if
+	 * the cluster support is available
+	 */
+	adapter->has_cluster = mega_support_cluster(adapter);
+	if (adapter->has_cluster) {
+		printk(KERN_NOTICE
+			"megaraid: Cluster driver, initiator id:%d\n",
+			adapter->this_id);
+	}
+#endif
+
+	pci_set_drvdata(pdev, host);
+
+	mega_create_proc_entry(hba_count, mega_proc_dir_entry);
+
+	error = scsi_add_host(host, &pdev->dev);
+	if (error)
+		goto out_free_mbox;
+
+	scsi_scan_host(host);
+	hba_count++;
+	return 0;
+
+ out_free_mbox:
+	pci_free_consistent(adapter->dev, sizeof(mbox64_t),
+			adapter->una_mbox64, adapter->una_mbox64_dma);
+ out_free_irq:
+	free_irq(adapter->host->irq, adapter);
+ out_free_scb_list:
+	kfree(adapter->scb_list);
+ out_free_cmd_buffer:
+	pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
+			adapter->mega_buffer, adapter->buf_dma_handle);
+ out_host_put:
+	scsi_host_put(host);
+ out_iounmap:
+	if (flag & BOARD_MEMMAP)
+		iounmap((void *)mega_baseport);
+ out_release_region:
+	if (flag & BOARD_MEMMAP)
+		release_mem_region(tbase, 128);
+	else
+		release_region(mega_baseport, 16);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return error;
+}
+
+static void
+__megaraid_shutdown(adapter_t *adapter)
+{
+	u_char	raw_mbox[sizeof(struct mbox_out)];
+	mbox_t	*mbox = (mbox_t *)raw_mbox;
+	int	i;
+
+	/* Flush adapter cache */
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	raw_mbox[0] = FLUSH_ADAPTER;
+
+	free_irq(adapter->host->irq, adapter);
+
+	/* Issue a blocking (interrupts disabled) command to the card */
+	issue_scb_block(adapter, raw_mbox);
+
+	/* Flush disks cache */
+	memset(&mbox->m_out, 0, sizeof(raw_mbox));
+	raw_mbox[0] = FLUSH_SYSTEM;
+
+	/* Issue a blocking (interrupts disabled) command to the card */
+	issue_scb_block(adapter, raw_mbox);
+	
+	if (atomic_read(&adapter->pend_cmds) > 0)
+		printk(KERN_WARNING "megaraid: pending commands!!\n");
+
+	/*
+	 * Have a delibrate delay to make sure all the caches are
+	 * actually flushed.
+	 */
+	for (i = 0; i <= 10; i++)
+		mdelay(1000);
+}
+
+static void
+megaraid_remove_one(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	adapter_t *adapter = (adapter_t *)host->hostdata;
+	char	buf[12] = { 0 };
+
+	scsi_remove_host(host);
+
+	__megaraid_shutdown(adapter);
+
+	/* Free our resources */
+	if (adapter->flag & BOARD_MEMMAP) {
+		iounmap((void *)adapter->base);
+		release_mem_region(adapter->host->base, 128);
+	} else
+		release_region(adapter->base, 16);
+
+	mega_free_sgl(adapter);
+
+#ifdef CONFIG_PROC_FS
+	if (adapter->controller_proc_dir_entry) {
+		remove_proc_entry("stat", adapter->controller_proc_dir_entry);
+		remove_proc_entry("config",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("mailbox",
+				adapter->controller_proc_dir_entry);
+#if MEGA_HAVE_ENH_PROC
+		remove_proc_entry("rebuild-rate",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("battery-status",
+				adapter->controller_proc_dir_entry);
+
+		remove_proc_entry("diskdrives-ch0",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("diskdrives-ch1",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("diskdrives-ch2",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("diskdrives-ch3",
+				adapter->controller_proc_dir_entry);
+
+		remove_proc_entry("raiddrives-0-9",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("raiddrives-10-19",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("raiddrives-20-29",
+				adapter->controller_proc_dir_entry);
+		remove_proc_entry("raiddrives-30-39",
+				adapter->controller_proc_dir_entry);
+#endif
+		sprintf(buf, "hba%d", adapter->host->host_no);
+		remove_proc_entry(buf, mega_proc_dir_entry);
+	}
+#endif
+
+	pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
+			adapter->mega_buffer, adapter->buf_dma_handle);
+	kfree(adapter->scb_list);
+	pci_free_consistent(adapter->dev, sizeof(mbox64_t),
+			adapter->una_mbox64, adapter->una_mbox64_dma);
+
+	scsi_host_put(host);
+	pci_disable_device(pdev);
+
+	hba_count--;
+}
+
+static void
+megaraid_shutdown(struct device *dev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(to_pci_dev(dev));
+	adapter_t *adapter = (adapter_t *)host->hostdata;
+
+	__megaraid_shutdown(adapter);
+}
+
+static struct pci_device_id megaraid_pci_tbl[] = {
+	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DISCOVERY,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_PERC4_DI,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
+	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_PERC4_QC_VERDE,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_AMI_MEGARAID,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{0,}
+};
+MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);
+
+static struct pci_driver megaraid_pci_driver = {
+	.name		= "megaraid",
+	.id_table	= megaraid_pci_tbl,
+	.probe		= megaraid_probe_one,
+	.remove		= __devexit_p(megaraid_remove_one),
+	.driver		= {
+		.shutdown = megaraid_shutdown,
+	},
+};
+
+static int __init megaraid_init(void)
+{
+	int error;
+
+	if ((max_cmd_per_lun <= 0) || (max_cmd_per_lun > MAX_CMD_PER_LUN))
+		max_cmd_per_lun = MAX_CMD_PER_LUN;
+	if (max_mbox_busy_wait > MBOX_BUSY_WAIT)
+		max_mbox_busy_wait = MBOX_BUSY_WAIT;
+
+	error = pci_module_init(&megaraid_pci_driver);
+	if (error) 
+		return error;
+	
+#ifdef CONFIG_PROC_FS
+	mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
+	if (!mega_proc_dir_entry) {
+		printk(KERN_WARNING
+				"megaraid: failed to create megaraid root\n");
+	}
+#endif
+
+	/*
+	 * Register the driver as a character device, for applications
+	 * to access it for ioctls.
+	 * First argument (major) to register_chrdev implies a dynamic
+	 * major number allocation.
+	 */
+	major = register_chrdev(0, "megadev", &megadev_fops);
+	if (!major) {
+		printk(KERN_WARNING
+				"megaraid: failed to register char device\n");
+	}
+
+	return 0;
+}
+
+static void __exit megaraid_exit(void)
+{
+	/*
+	 * Unregister the character device interface to the driver.
+	 */
+	unregister_chrdev(major, "megadev");
+
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("megaraid", &proc_root);
+#endif
+
+	pci_unregister_driver(&megaraid_pci_driver);
+}
+
+module_init(megaraid_init);
+module_exit(megaraid_exit);
 
 /* vi: set ts=8 sw=8 tw=78: */
===== drivers/scsi/megaraid.h 1.23 vs edited =====
--- 1.23/drivers/scsi/megaraid.h	Thu Nov 13 07:56:20 2003
+++ edited/drivers/scsi/megaraid.h	Mon Nov 17 22:14:23 2003
@@ -989,8 +989,6 @@
 
 const char *megaraid_info (struct Scsi_Host *);
 
-static int megaraid_detect(Scsi_Host_Template *);
-static void mega_find_card(Scsi_Host_Template *, u16, u16);
 static int mega_query_adapter(adapter_t *);
 static inline int issue_scb(adapter_t *, scb_t *);
 static int mega_setup_mailbox(adapter_t *);
@@ -1007,7 +1005,6 @@
 
 static void mega_free_scb(adapter_t *, scb_t *);
 
-static int megaraid_release (struct Scsi_Host *);
 static int megaraid_abort(Scsi_Cmnd *);
 static int megaraid_reset(Scsi_Cmnd *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
@@ -1025,8 +1022,6 @@
 static void mega_8_to_40ld (mraid_inquiry *inquiry,
 		mega_inquiry3 *enquiry3, mega_product_info *);
 
-static int megaraid_reboot_notify (struct notifier_block *,
-				   unsigned long, void *);
 static int megadev_open (struct inode *, struct file *);
 static int megadev_ioctl (struct inode *, struct file *, unsigned int,
 		unsigned long);

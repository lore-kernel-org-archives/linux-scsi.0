From: David Jeffery <david_jeffery@adaptec.com>
Subject: [PATCH2.5] ips 3/4: use pci_dma APIs and remove GFP abuse
Date: 15 Aug 2003 08:43:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060951415.3251.46.camel@blackmagic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FlZn3OAsNF2fd9fQxHcd"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:8083 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S275936AbTHOMlG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 08:41:06 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h7FCf5o18470
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2003 05:41:05 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id FAA24419
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2003 05:41:04 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-FlZn3OAsNF2fd9fQxHcd
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch removes several places where we were using kmalloc flag
tricks to always get memory <4GB instead of using the proper
dma_alloc_consistent() API.  It also no longer #errors on when compiled
for x86-64 kernels.

David Jeffery

--=-FlZn3OAsNF2fd9fQxHcd
Content-Disposition: attachment; filename=test3.patch3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=test3.patch3; charset=ANSI_X3.4-1968

diff -urN linux-2.6.0-test3_p2/drivers/scsi/ips.c linux-2.6.0-test3_p3/driv=
ers/scsi/ips.c
--- linux-2.6.0-test3_p2/drivers/scsi/ips.c	2003-08-11 13:53:24.000000000 -=
0400
+++ linux-2.6.0-test3_p3/drivers/scsi/ips.c	2003-08-11 13:54:05.000000000 -=
0400
@@ -198,8 +198,8 @@
 #define IPS_VERSION_HIGH        "5.99"
 #define IPS_VERSION_LOW         ".01-BETA"
=20
-#if !defined(__i386__) && !defined(__ia64__)
-#error "This driver has only been tested on the x86/ia64 platforms"
+#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
+#error "This driver has only been tested on the x86/ia64/x86_64 platforms"
 #endif
=20
 #if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,5,0)
@@ -250,6 +250,7 @@
 static int ips_ioctlsize =3D IPS_IOCTL_SIZE;	/* Size of the ioctl buffer  =
      */
 static int ips_cd_boot;		/* Booting from Manager CD         */
 static char *ips_FlashData =3D NULL;	/* CD Boot - Flash Data Buffer      *=
/
+static dma_addr_t ips_flashbusaddr;
 static long ips_FlashDataInUse;	/* CD Boot - Flash Data In Use Flag */
 static uint32_t MaxLiteCmds =3D 32;	/* Max Active Cmds for a Lite Adapter =
*/
 static Scsi_Host_Template ips_driver_template =3D {
@@ -589,17 +590,6 @@
 		ips_setup(ips);
 #endif
=20
-	/* If Booting from the Manager CD, Allocate a large Flash        */
-	/* Buffer ( so we won't need to allocate one for each adapter ). */
-	if (ips_cd_boot) {
-		ips_FlashData =3D (char *) __get_free_pages(IPS_INIT_GFP, 7);
-		if (ips_FlashData =3D=3D NULL) {
-			/* The validity of this pointer is checked in ips_make_passthru() befor=
e it is used */
-			printk(KERN_WARNING
-			       "ERROR: Can't Allocate Large Buffer for Flashing\n");
-		}
-	}
-
 	for (i =3D 0; i < ips_num_controllers; i++) {
 		if (ips_register_scsi(i))
 			ips_free(ips_ha[i]);
@@ -1630,21 +1620,20 @@
 ips_alloc_passthru_buffer(ips_ha_t * ha, int length)
 {
 	void *bigger_buf;
-	int count;
-	int order;
+	dma_addr_t dma_busaddr;
=20
-	if (ha->ioctl_data && length <=3D (PAGE_SIZE << ha->ioctl_order))
+	if (ha->ioctl_data && length <=3D ha->ioctl_len)
 		return 0;
 	/* there is no buffer or it's not big enough, allocate a new one */
-	for (count =3D PAGE_SIZE, order =3D 0;
-	     count < length; order++, count <<=3D 1) ;
-	bigger_buf =3D (void *) __get_free_pages(IPS_ATOMIC_GFP, order);
+	bigger_buf =3D pci_alloc_consistent(ha->pcidev, length, &dma_busaddr);
 	if (bigger_buf) {
 		/* free the old memory */
-		free_pages((unsigned long) ha->ioctl_data, ha->ioctl_order);
+		pci_free_consistent(ha->pcidev, ha->ioctl_len, ha->ioctl_data,
+				    ha->ioctl_busaddr);
 		/* use the new memory */
 		ha->ioctl_data =3D (char *) bigger_buf;
-		ha->ioctl_order =3D order;
+		ha->ioctl_len =3D length;
+		ha->ioctl_busaddr =3D dma_busaddr;
 	} else {
 		return -1;
 	}
@@ -1761,7 +1750,7 @@
 static int
 ips_flash_copperhead(ips_ha_t * ha, ips_passthru_t * pt, ips_scb_t * scb)
 {
-	int datasize, count;
+	int datasize;
=20
 	/* Trombone is the only copperhead that can do packet flash, but only
 	 * for firmware. No one said it had to make sence. */
@@ -1781,24 +1770,28 @@
 		pt->BasicStatus =3D 0;
 		return ips_flash_bios(ha, pt, scb);
 	} else if (pt->CoppCP.cmd.flashfw.packet_num =3D=3D 0) {
-		if (ips_FlashData && !test_and_set_bit(0, &ips_FlashDataInUse)) {
+		if (ips_FlashData && !test_and_set_bit(0, &ips_FlashDataInUse)){
 			ha->flash_data =3D ips_FlashData;
-			ha->flash_order =3D 7;
+			ha->flash_busaddr =3D ips_flashbusaddr;
+			ha->flash_len =3D PAGE_SIZE << 7;
 			ha->flash_datasize =3D 0;
 		} else if (!ha->flash_data) {
 			datasize =3D pt->CoppCP.cmd.flashfw.total_packets *
 			    pt->CoppCP.cmd.flashfw.count;
-			for (count =3D PAGE_SIZE, ha->flash_order =3D 0;
-			     count < datasize; ha->flash_order++, count <<=3D 1) ;
-			ha->flash_data =3D
-			    (char *) __get_free_pages(IPS_ATOMIC_GFP,
-						      ha->flash_order);
+			ha->flash_data =3D pci_alloc_consistent(ha->pcidev,
+					                      datasize,
+							      &ha->flash_busaddr);
+			if (!ha->flash_data){
+				printk(KERN_WARNING "Unable to allocate a flash buffer\n");
+				return IPS_FAILURE;
+			}
 			ha->flash_datasize =3D 0;
+			ha->flash_len =3D datasize;
 		} else
 			return IPS_FAILURE;
 	} else {
 		if (pt->CoppCP.cmd.flashfw.count + ha->flash_datasize >
-		    (PAGE_SIZE << ha->flash_order)) {
+		    ha->flash_len) {
 			ips_free_flash_copperhead(ha);
 			IPS_PRINTK(KERN_WARNING, ha->pcidev,
 				   "failed size sanity check\n");
@@ -1987,7 +1980,8 @@
 	if (ha->flash_data =3D=3D ips_FlashData)
 		test_and_clear_bit(0, &ips_FlashDataInUse);
 	else if (ha->flash_data)
-		free_pages((unsigned long) ha->flash_data, ha->flash_order);
+		pci_free_consistent(ha->pcidev, ha->flash_len, ha->flash_data,
+				    ha->flash_busaddr);
 	ha->flash_data =3D NULL;
 }
=20
@@ -2040,12 +2034,7 @@
=20
 	if (pt->CmdBSize) {
 		scb->data_len =3D pt->CmdBSize;
-		scb->data_busaddr =3D pci_map_single(ha->pcidev,
-						   ha->ioctl_data +
-						   sizeof (ips_passthru_t),
-						   pt->CmdBSize,
-						   IPS_DMA_DIR(scb));
-		scb->flags |=3D IPS_SCB_MAP_SINGLE;
+		scb->data_busaddr =3D ha->ioctl_busaddr + sizeof (ips_passthru_t);
 	} else {
 		scb->data_busaddr =3D 0L;
 	}
@@ -2469,9 +2458,7 @@
 	} else {
 		/* Morpheus Family - Send Command to the card */
=20
-		buffer =3D kmalloc(0x1000, IPS_ATOMIC_GFP);
-		if (!buffer)
-			return;
+		buffer =3D ha->ioctl_data;
=20
 		memset(buffer, 0, 0x1000);
=20
@@ -2490,11 +2477,7 @@
 		scb->cmd.flashfw.total_packets =3D 1;
 		scb->cmd.flashfw.packet_num =3D 0;
 		scb->data_len =3D 0x1000;
-		scb->data_busaddr =3D
-		    pci_map_single(ha->pcidev, buffer, scb->data_len,
-				   IPS_DMA_DIR(scb));
-		scb->cmd.flashfw.buffer_addr =3D scb->data_busaddr;
-		scb->flags |=3D IPS_SCB_MAP_SINGLE;
+		scb->cmd.flashfw.buffer_addr =3D ha->ioctl_busaddr;
=20
 		/* issue the command */
 		if (((ret =3D
@@ -2503,7 +2486,6 @@
 		    || (ret =3D=3D IPS_SUCCESS_IMM)
 		    || ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1)) {
 			/* Error occurred */
-			kfree(buffer);
=20
 			return;
 		}
@@ -2513,11 +2495,8 @@
 			minor =3D buffer[0x1fe + 0xC0];	/* Offset 0x1fe after the header (0xc0)=
 */
 			subminor =3D buffer[0x1fd + 0xC0];	/* Offset 0x1fd after the header (0x=
c0) */
 		} else {
-			kfree(buffer);
 			return;
 		}
-
-		kfree(buffer);
 	}
=20
 	ha->bios_version[0] =3D hexDigits[(major & 0xF0) >> 4];
@@ -3984,11 +3963,7 @@
 			scb->cmd.basic_io.segment_4G =3D 0;
 			scb->cmd.basic_io.enhanced_sg =3D 0;
 			scb->data_len =3D sizeof (*ha->enq);
-			scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->enq,
-							   scb->data_len,
-							   IPS_DMA_DIR(scb));
-			scb->cmd.basic_io.sg_addr =3D scb->data_busaddr;
-			scb->flags |=3D IPS_SCB_MAP_SINGLE;
+			scb->cmd.basic_io.sg_addr =3D ha->enq_busaddr;
 			ret =3D IPS_SUCCESS;
 			break;
=20
@@ -4550,7 +4525,8 @@
=20
 	if (ha) {
 		if (ha->enq) {
-			kfree(ha->enq);
+			pci_free_consistent(ha->pcidev, sizeof(IPS_ENQ),
+					    ha->enq, ha->enq_busaddr);
 			ha->enq =3D NULL;
 		}
=20
@@ -4578,11 +4554,11 @@
 		}
=20
 		if (ha->ioctl_data) {
-			free_pages((unsigned long) ha->ioctl_data,
-				   ha->ioctl_order);
+			pci_free_consistent(ha->pcidev, ha->ioctl_len,
+					    ha->ioctl_data, ha->ioctl_busaddr);
 			ha->ioctl_data =3D NULL;
 			ha->ioctl_datasize =3D 0;
-			ha->ioctl_order =3D 0;
+			ha->ioctl_len =3D 0;
 		}
 		ips_deallocatescbs(ha, ha->max_cmds);
=20
@@ -5920,10 +5896,7 @@
 	scb->cmd.basic_io.sector_count =3D 0;
 	scb->cmd.basic_io.log_drv =3D 0;
 	scb->data_len =3D sizeof (*ha->enq);
-	scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->enq, scb->data_len,
-					   IPS_DMA_DIR(scb));
-	scb->cmd.basic_io.sg_addr =3D scb->data_busaddr;
-	scb->flags |=3D IPS_SCB_MAP_SINGLE;
+	scb->cmd.basic_io.sg_addr =3D ha->enq_busaddr;
=20
 	/* send command */
 	if (((ret =3D
@@ -5966,10 +5939,7 @@
 	scb->cmd.basic_io.sector_count =3D 0;
 	scb->cmd.basic_io.log_drv =3D 0;
 	scb->data_len =3D sizeof (*ha->subsys);
-	scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->subsys,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.basic_io.sg_addr =3D scb->data_busaddr;
-	scb->flags |=3D IPS_SCB_MAP_SINGLE;
+	scb->cmd.basic_io.sg_addr =3D ha->ioctl_busaddr;
=20
 	/* send command */
 	if (((ret =3D
@@ -5978,6 +5948,7 @@
 	    || ((scb->basic_status & IPS_GSC_STATUS_MASK) > 1))
 		return (0);
=20
+	memcpy(ha->subsys, ha->ioctl_data, sizeof(*ha->subsys));
 	return (1);
 }
=20
@@ -6013,10 +5984,7 @@
 	scb->cmd.basic_io.op_code =3D IPS_CMD_READ_CONF;
 	scb->cmd.basic_io.command_id =3D IPS_COMMAND_ID(ha, scb);
 	scb->data_len =3D sizeof (*ha->conf);
-	scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->conf,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.basic_io.sg_addr =3D scb->data_busaddr;
-	scb->flags |=3D IPS_SCB_MAP_SINGLE;
+	scb->cmd.basic_io.sg_addr =3D ha->ioctl_busaddr;
=20
 	/* send command */
 	if (((ret =3D
@@ -6037,7 +6005,8 @@
=20
 		return (0);
 	}
-
+=09
+	memcpy(ha->conf, ha->ioctl_data, sizeof(*ha->conf));
 	return (1);
 }
=20
@@ -6072,11 +6041,10 @@
 	scb->cmd.nvram.reserved =3D 0;
 	scb->cmd.nvram.reserved2 =3D 0;
 	scb->data_len =3D sizeof (*ha->nvram);
-	scb->data_busaddr =3D pci_map_single(ha->pcidev, ha->nvram,
-					   scb->data_len, IPS_DMA_DIR(scb));
-	scb->cmd.nvram.buffer_addr =3D scb->data_busaddr;
-	scb->flags |=3D IPS_SCB_MAP_SINGLE;
-
+	scb->cmd.nvram.buffer_addr =3D ha->ioctl_busaddr;
+	if (write)
+		memcpy(ha->ioctl_data, ha->nvram, sizeof(*ha->nvram));
+=09
 	/* issue the command */
 	if (((ret =3D
 	      ips_send_wait(ha, scb, ips_cmd_timeout, intr)) =3D=3D IPS_FAILURE)
@@ -6087,7 +6055,8 @@
=20
 		return (0);
 	}
-
+	if (!write)
+		memcpy(ha->nvram, ha->ioctl_data, sizeof(*ha->nvram));
 	return (1);
 }
=20
@@ -7242,7 +7211,6 @@
 	uint16_t subdevice_id;
 	int j;
 	int index;
-	uint32_t count;
 	dma_addr_t dma_address;
 	char *ioremap_ptr;
 	char *mem_ptr;
@@ -7367,9 +7335,13 @@
 			return ips_abort_init(ha, index);
 		}
 	}
+	if(ips_cd_boot && !ips_FlashData){
+		ips_FlashData =3D pci_alloc_consistent(pci_dev, PAGE_SIZE << 7,
+						     &ips_flashbusaddr);
+	}
=20
-	ha->enq =3D kmalloc(sizeof (IPS_ENQ), IPS_INIT_GFP);
-
+	ha->enq =3D pci_alloc_consistent(pci_dev, sizeof (IPS_ENQ),
+				       &ha->enq_busaddr);
 	if (!ha->enq) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
 			   "Unable to allocate host inquiry structure\n");
@@ -7386,7 +7358,7 @@
 	ha->adapt->hw_status_start =3D dma_address;
 	ha->dummy =3D (void *) (ha->adapt + 1);
=20
-	ha->conf =3D kmalloc(sizeof (IPS_CONF), IPS_INIT_GFP);
+	ha->conf =3D kmalloc(sizeof (IPS_CONF), GFP_KERNEL);
=20
 	if (!ha->conf) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
@@ -7394,7 +7366,7 @@
 		return ips_abort_init(ha, index);
 	}
=20
-	ha->nvram =3D kmalloc(sizeof (IPS_NVRAM_P5), IPS_INIT_GFP);
+	ha->nvram =3D kmalloc(sizeof (IPS_NVRAM_P5), GFP_KERNEL);
=20
 	if (!ha->nvram) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
@@ -7402,7 +7374,7 @@
 		return ips_abort_init(ha, index);
 	}
=20
-	ha->subsys =3D kmalloc(sizeof (IPS_SUBSYS), IPS_INIT_GFP);
+	ha->subsys =3D kmalloc(sizeof (IPS_SUBSYS), GFP_KERNEL);
=20
 	if (!ha->subsys) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
@@ -7410,19 +7382,18 @@
 		return ips_abort_init(ha, index);
 	}
=20
-	for (count =3D PAGE_SIZE, ha->ioctl_order =3D 0;
-	     count < ips_ioctlsize; ha->ioctl_order++, count <<=3D 1) ;
-
-	ha->ioctl_data =3D
-	    (char *) __get_free_pages(IPS_INIT_GFP, ha->ioctl_order);
-	ha->ioctl_datasize =3D count;
-
+	/* the ioctl buffer is now used during adapter initialization, so its
+	 * successful allocation is now required */
+	if (ips_ioctlsize < PAGE_SIZE)
+		ips_ioctlsize =3D PAGE_SIZE;
+
+	ha->ioctl_data =3D pci_alloc_consistent(pci_dev, ips_ioctlsize,
+					      &ha->ioctl_busaddr);
+	ha->ioctl_len =3D ips_ioctlsize;
 	if (!ha->ioctl_data) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
 			   "Unable to allocate IOCTL data\n");
-		ha->ioctl_data =3D NULL;
-		ha->ioctl_order =3D 0;
-		ha->ioctl_datasize =3D 0;
+		return ips_abort_init(ha, index);
 	}
=20
 	/*
diff -urN linux-2.6.0-test3_p2/drivers/scsi/ips.h linux-2.6.0-test3_p3/driv=
ers/scsi/ips.h
--- linux-2.6.0-test3_p2/drivers/scsi/ips.h	2003-08-11 12:43:05.000000000 -=
0400
+++ linux-2.6.0-test3_p3/drivers/scsi/ips.h	2003-08-11 13:54:05.000000000 -=
0400
@@ -128,22 +128,13 @@
       #define min(x,y) ((x) < (y) ? x : y)
    #endif
=20
+   #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
=20
    #if (BITS_PER_LONG > 32) || (defined CONFIG_HIGHMEM64G && defined IPS_H=
IGHIO)
       #define IPS_ENABLE_DMA64        (1)
-      #define pci_dma_hi32(a)         (a >> 32)
    #else
       #define IPS_ENABLE_DMA64        (0)
-      #define pci_dma_hi32(a)         (0)
-   #endif
-
-   #if defined(__ia64__)
-      #define IPS_ATOMIC_GFP	(GFP_DMA | GFP_ATOMIC)
-      #define IPS_INIT_GFP	GFP_DMA
-   #else
-      #define IPS_ATOMIC_GFP    GFP_ATOMIC
-      #define IPS_INIT_GFP	GFP_KERNEL
    #endif
=20
    /*
@@ -1110,7 +1101,8 @@
    uint16_t           device_id;          /* PCI device ID              */
    uint8_t            slot_num;           /* PCI Slot Number            */
    uint16_t           subdevice_id;       /* Subsystem device ID        */
-   uint8_t            ioctl_order;        /* Number of pages in ioctl   */
+   int                ioctl_len;          /* size of ioctl buffer       */
+   dma_addr_t         ioctl_busaddr;      /* dma address of ioctl buffer*/
    uint8_t            bios_version[8];    /* BIOS Revision              */
    uint32_t           mem_addr;           /* Memory mapped address      */
    uint32_t           io_len;             /* Size of IO Address         */
@@ -1120,8 +1112,10 @@
    ips_hw_func_t      func;               /* hw function pointers       */
    struct pci_dev    *pcidev;             /* PCI device handle          */
    char              *flash_data;         /* Save Area for flash data   */
-   u8                 flash_order;        /* Save Area for flash size orde=
r */
+   int                flash_len;          /* length of flash buffer     */
    u32                flash_datasize;     /* Save Area for flash data size=
 */
+   dma_addr_t         flash_busaddr;      /* dma address of flash buffer*/
+   dma_addr_t         enq_busaddr;        /* dma address of enq struct  */
    uint8_t            requires_esl;       /* Requires an EraseStripeLock *=
/
 } ips_ha_t;
=20

--=-FlZn3OAsNF2fd9fQxHcd--


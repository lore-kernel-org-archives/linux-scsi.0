From: Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH] Remove IP27 hacks in qlogicisp driver
Date: Fri, 15 Jul 2005 17:30:17 +0100
Message-ID: <20050715163017.GA24308@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extgw-uk.mips.com ([62.254.210.129]:52509 "EHLO
	bacchus.net.dhis.org") by vger.kernel.org with ESMTP
	id S263328AbVGOQbE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2005 12:31:04 -0400
Received: from dea.linux-mips.net (localhost.localdomain [127.0.0.1])
	by bacchus.net.dhis.org (8.13.4/8.13.1) with ESMTP id j6FGV4Mm024456
	for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2005 17:31:04 +0100
Received: (from ralf@localhost)
	by dea.linux-mips.net (8.13.4/8.13.4/Submit) id j6FGV4Zn024455
	for linux-scsi@vger.kernel.org; Fri, 15 Jul 2005 17:31:04 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>

Now that the qla1280 driver is working on IP27 there is no more point
in keeping the old hacks around that were introduced in 1999.  One
nail more in the coffin of this driver.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/Kconfig                |    4 -
 arch/mips/configs/ip27_defconfig |    1 
 drivers/scsi/qlogicisp.c         |   86 ---------------------------------------
 3 files changed, 91 deletions(-)

Index: linux-sgi-ip27-ua/drivers/scsi/qlogicisp.c
===================================================================
--- linux-sgi-ip27-ua.orig/drivers/scsi/qlogicisp.c	2005-07-15 18:13:44.000000000 +0200
+++ linux-sgi-ip27-ua/drivers/scsi/qlogicisp.c	2005-07-15 18:13:48.000000000 +0200
@@ -192,14 +192,8 @@
 #define REQUEST_QUEUE_WAKEUP		0x8005
 #define EXECUTION_TIMEOUT_RESET		0x8006
 
-#ifdef CONFIG_QL_ISP_A64
-#define IOCB_SEGS                       2
-#define CONTINUATION_SEGS               5
-#define MAX_CONTINUATION_ENTRIES        254
-#else
 #define IOCB_SEGS                       4
 #define CONTINUATION_SEGS               7
-#endif /* CONFIG_QL_ISP_A64 */
 
 struct Entry_header {
 	u_char	entry_type;
@@ -209,13 +203,8 @@
 };
 
 /* entry header type commands */
-#ifdef CONFIG_QL_ISP_A64
-#define ENTRY_COMMAND           9
-#define ENTRY_CONTINUATION      0xa
-#else
 #define ENTRY_COMMAND		1
 #define ENTRY_CONTINUATION	2
-#endif /* CONFIG_QL_ISP_A64 */
 
 #define ENTRY_STATUS		3
 #define ENTRY_MARKER		4
@@ -229,9 +218,6 @@
 
 struct dataseg {
 	u_int			d_base;
-#ifdef CONFIG_QL_ISP_A64
-	u_int                   d_base_hi;
-#endif
 	u_int			d_count;
 };
 
@@ -246,10 +232,6 @@
 	u_short			time_out;
 	u_short			segment_cnt;
 	u_char			cdb[12];
-#ifdef CONFIG_QL_ISP_A64
-	u_int                   rsvd1;
-	u_int                   rsvd2;
-#endif
 	struct dataseg		dataseg[IOCB_SEGS];
 };
 
@@ -277,9 +259,7 @@
 
 struct Continuation_Entry {
 	struct Entry_header	hdr;
-#ifndef CONFIG_QL_ISP_A64
 	u_int			reserved;
-#endif
 	struct dataseg		dataseg[CONTINUATION_SEGS];
 };
 
@@ -424,11 +404,6 @@
 #define MBOX_WRITE_FOUR_RAM_WORDS	0x0041
 #define MBOX_EXEC_BIOS_IOCB		0x0042
 
-#ifdef CONFIG_QL_ISP_A64
-#define MBOX_CMD_INIT_REQUEST_QUEUE_64      0x0052
-#define MBOX_CMD_INIT_RESPONSE_QUEUE_64     0x0053
-#endif /* CONFIG_QL_ISP_A64 */
-
 #include "qlogicisp_asm.c"
 
 #define PACKB(a, b)			(((a)<<4)|(b))
@@ -501,25 +476,6 @@
 	PACKB(1, 2),	/* MBOX_RETURN_BIOS_BLOCK_ADDR */
 	PACKB(6, 1),	/* MBOX_WRITE_FOUR_RAM_WORDS */
 	PACKB(2, 3)	/* MBOX_EXEC_BIOS_IOCB */
-#ifdef CONFIG_QL_ISP_A64
-	,PACKB(0, 0),	/* 0x0043 */
-	PACKB(0, 0),	/* 0x0044 */
-	PACKB(0, 0),	/* 0x0045 */
-	PACKB(0, 0),	/* 0x0046 */
-	PACKB(0, 0),	/* 0x0047 */
-	PACKB(0, 0),	/* 0x0048 */
-	PACKB(0, 0),	/* 0x0049 */
-	PACKB(0, 0),	/* 0x004a */
-	PACKB(0, 0),	/* 0x004b */
-	PACKB(0, 0),	/* 0x004c */
-	PACKB(0, 0),	/* 0x004d */
-	PACKB(0, 0),	/* 0x004e */
-	PACKB(0, 0),	/* 0x004f */
-	PACKB(0, 0),	/* 0x0050 */
-	PACKB(0, 0),	/* 0x0051 */
-	PACKB(8, 8),	/* MBOX_CMD_INIT_REQUEST_QUEUE_64 (0x0052) */
-	PACKB(8, 8)	/* MBOX_CMD_INIT_RESPONSE_QUEUE_64 (0x0053) */
-#endif /* CONFIG_QL_ISP_A64 */
 };
 
 #define MAX_MBOX_COMMAND	(sizeof(mbox_param)/sizeof(u_short))
@@ -888,9 +844,6 @@
 		for (i = 0; i < n; i++) {
 			dma_addr = sg_dma_address(sg);
 			ds[i].d_base  = cpu_to_le32((u32) dma_addr);
-#ifdef CONFIG_QL_ISP_A64
-			ds[i].d_base_hi = cpu_to_le32((u32) (dma_addr>>32));
-#endif /* CONFIG_QL_ISP_A64 */
 			ds[i].d_count = cpu_to_le32(sg_dma_len(sg));
 			++sg;
 		}
@@ -911,9 +864,7 @@
 			cont->hdr.entry_cnt  = 0;
 			cont->hdr.sys_def_1  = 0;
 			cont->hdr.flags      = 0;
-#ifndef CONFIG_QL_ISP_A64
 			cont->reserved = 0;
-#endif
 			ds = cont->dataseg;
 			n = sg_count;
 			if (n > CONTINUATION_SEGS)
@@ -921,9 +872,6 @@
 			for (i = 0; i < n; ++i) {
 				dma_addr = sg_dma_address(sg);
 				ds[i].d_base = cpu_to_le32((u32) dma_addr);
-#ifdef CONFIG_QL_ISP_A64
-				ds[i].d_base_hi = cpu_to_le32((u32)(dma_addr>>32));
-#endif /* CONFIG_QL_ISP_A64 */
 				ds[i].d_count = cpu_to_le32(sg_dma_len(sg));
 				++sg;
 			}
@@ -939,18 +887,11 @@
 
 		cmd->dataseg[0].d_base =
 			cpu_to_le32((u32) dma_addr);
-#ifdef CONFIG_QL_ISP_A64
-		cmd->dataseg[0].d_base_hi =
-			cpu_to_le32((u32) (dma_addr>>32));
-#endif /* CONFIG_QL_ISP_A64 */
 		cmd->dataseg[0].d_count =
 			cpu_to_le32((u32)Cmnd->request_bufflen);
 		cmd->segment_cnt = cpu_to_le16(1);
 	} else {
 		cmd->dataseg[0].d_base = 0;
-#ifdef CONFIG_QL_ISP_A64
-		cmd->dataseg[0].d_base_hi = 0;
-#endif /* CONFIG_QL_ISP_A64 */
 		cmd->dataseg[0].d_count = 0;
 		cmd->segment_cnt = cpu_to_le16(1); /* Shouldn't this be 0? */
 	}
@@ -1070,11 +1011,7 @@
 				     Cmnd->sc_data_direction);
 		else if (Cmnd->request_bufflen)
 			pci_unmap_single(hostdata->pci_dev,
-#ifdef CONFIG_QL_ISP_A64
-					 (dma_addr_t)((long)Cmnd->SCp.ptr),
-#else
 					 (u32)((long)Cmnd->SCp.ptr),
-#endif
 					 Cmnd->request_bufflen,
 					 Cmnd->sc_data_direction);
 
@@ -1625,13 +1562,8 @@
 static int isp1020_load_parameters(struct Scsi_Host *host)
 {
 	int i, k;
-#ifdef CONFIG_QL_ISP_A64
-	u_long queue_addr;
-	u_short param[8];
-#else
 	u_int queue_addr;
 	u_short param[6];
-#endif
 	u_short isp_cfg1, hwrev;
 	struct isp1020_hostdata *hostdata =
 		(struct isp1020_hostdata *) host->hostdata;
@@ -1758,20 +1690,12 @@
 	}
 
 	queue_addr = hostdata->res_dma;
-#ifdef CONFIG_QL_ISP_A64
-	param[0] = MBOX_CMD_INIT_RESPONSE_QUEUE_64;
-#else
 	param[0] = MBOX_INIT_RES_QUEUE;
-#endif
 	param[1] = RES_QUEUE_LEN + 1;
 	param[2] = (u_short) (queue_addr >> 16);
 	param[3] = (u_short) (queue_addr & 0xffff);
 	param[4] = 0;
 	param[5] = 0;
-#ifdef CONFIG_QL_ISP_A64
-	param[6] = (u_short) (queue_addr >> 48);
-	param[7] = (u_short) (queue_addr >> 32);
-#endif
 
 	isp1020_mbox_command(host, param);
 
@@ -1781,22 +1705,12 @@
 	}
 
 	queue_addr = hostdata->req_dma;
-#ifdef CONFIG_QL_ISP_A64
-	param[0] = MBOX_CMD_INIT_REQUEST_QUEUE_64;
-#else
 	param[0] = MBOX_INIT_REQ_QUEUE;
-#endif
 	param[1] = QLOGICISP_REQ_QUEUE_LEN + 1;
 	param[2] = (u_short) (queue_addr >> 16);
 	param[3] = (u_short) (queue_addr & 0xffff);
 	param[4] = 0;
 
-#ifdef CONFIG_QL_ISP_A64
-	param[5] = 0;
-	param[6] = (u_short) (queue_addr >> 48);
-	param[7] = (u_short) (queue_addr >> 32);
-#endif
-
 	isp1020_mbox_command(host, param);
 
 	if (param[0] != MBOX_COMMAND_COMPLETE) {
Index: linux-sgi-ip27-ua/arch/mips/configs/ip27_defconfig
===================================================================
--- linux-sgi-ip27-ua.orig/arch/mips/configs/ip27_defconfig	2005-07-15 18:13:44.000000000 +0200
+++ linux-sgi-ip27-ua/arch/mips/configs/ip27_defconfig	2005-07-15 18:13:48.000000000 +0200
@@ -127,7 +127,6 @@
 CONFIG_MIPS_L1_CACHE_SHIFT=7
 CONFIG_ARC64=y
 CONFIG_BOOT_ELF64=y
-CONFIG_QL_ISP_A64=y
 
 #
 # CPU selection
Index: linux-sgi-ip27-ua/arch/mips/Kconfig
===================================================================
--- linux-sgi-ip27-ua.orig/arch/mips/Kconfig	2005-07-15 18:13:44.000000000 +0200
+++ linux-sgi-ip27-ua/arch/mips/Kconfig	2005-07-15 18:13:48.000000000 +0200
@@ -506,7 +506,6 @@
 	select DMA_IP27
 	select HW_HAS_PCI
 	select PCI_DOMAINS
-	select QL_ISP_A64
 	select SYS_SUPPORTS_64BIT_KERNEL
 	select SYS_SUPPORTS_BIG_ENDIAN
 	help
@@ -917,9 +916,6 @@
 config BOOT_ELF64
 	bool
 
-config QL_ISP_A64
-	bool
-
 config TOSHIBA_BOARDS
 	bool
 

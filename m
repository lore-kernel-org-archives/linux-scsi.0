From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] more ncr updates
Date: Fri, 26 Sep 2003 17:17:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926151751.GA23650@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:57733 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262351AbTIZPSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 11:18:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org

 - kill pre-2.4 'dma mapping' code
 - kill nvram support
 - kill pci leftovers


--- 1.48/drivers/scsi/Makefile	Tue Sep 23 13:50:13 2003
+++ edited/drivers/scsi/Makefile	Thu Sep 25 20:54:35 2003
@@ -136,11 +136,9 @@
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH \
 			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS \
-			-DCONFIG_SCSI_NCR53C8XX_NO_NVRAM \
 			-DSCSI_NCR_BIG_ENDIAN -DSIMULATED_INTFLY
-ncr53c8xx-flags-$(CONFIG_SCSI_NCR_Q720) \
-		:= -DCONFIG_SCSI_NCR53C8XX_NO_NVRAM \
-			-DSIMULATED_INTFLY
+ncr53c8xx-flags-$(CONFIG_SCSI_NCR_Q720)	\
+		:= -DSIMULATED_INTFLY
 CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
--- 1.36/drivers/scsi/ncr53c8xx.c	Tue Sep 23 13:45:17 2003
+++ edited/drivers/scsi/ncr53c8xx.c	Thu Sep 25 20:53:28 2003
@@ -341,11 +341,6 @@
 #define initverbose (driver_setup.verbose)
 #define bootverbose (np->verbose)
 
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-static u_char Tekram_sync[16] __initdata =
-	{25,31,37,43, 50,62,75,125, 12,15,18,21, 6,7,9,10};
-#endif /* SCSI_NCR_NVRAM_SUPPORT */
-
 /*==========================================================
 **
 **	Command control block states.
@@ -3193,61 +3188,7 @@
 	}
 }
 
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-
-/*
-**	Get target set-up from Symbios format NVRAM.
-*/
-
-static void __init 
-ncr_Symbios_setup_target(ncb_p np, int target, Symbios_nvram *nvram)
-{
-	tcb_p tp = &np->target[target];
-	Symbios_target *tn = &nvram->target[target];
-
-	tp->usrsync = tn->sync_period ? (tn->sync_period + 3) / 4 : 255;
-	tp->usrwide = tn->bus_width == 0x10 ? 1 : 0;
-	tp->usrtags =
-		(tn->flags & SYMBIOS_QUEUE_TAGS_ENABLED)? MAX_TAGS : 0;
-
-	if (!(tn->flags & SYMBIOS_DISCONNECT_ENABLE))
-		tp->usrflag |= UF_NODISC;
-	if (!(tn->flags & SYMBIOS_SCAN_AT_BOOT_TIME))
-		tp->usrflag |= UF_NOSCAN;
-}
-
-/*
-**	Get target set-up from Tekram format NVRAM.
-*/
-
-static void __init 
-ncr_Tekram_setup_target(ncb_p np, int target, Tekram_nvram *nvram)
-{
-	tcb_p tp = &np->target[target];
-	struct Tekram_target *tn = &nvram->target[target];
-	int i;
-
-	if (tn->flags & TEKRAM_SYNC_NEGO) {
-		i = tn->sync_index & 0xf;
-		tp->usrsync = Tekram_sync[i];
-	}
-
-	tp->usrwide = (tn->flags & TEKRAM_WIDE_NEGO) ? 1 : 0;
-
-	if (tn->flags & TEKRAM_TAGGED_COMMANDS) {
-		tp->usrtags = 2 << nvram->max_tags_index;
-	}
-
-	if (!(tn->flags & TEKRAM_DISCONNECT_ENABLE))
-		tp->usrflag = UF_NODISC;
- 
-	/* If any device does not support parity, we will not use this option */
-	if (!(tn->flags & TEKRAM_PARITY_CHECK))
-		np->rv_scntl0  &= ~0x0a; /* SCSI parity checking disabled */
-}
-#endif /* SCSI_NCR_NVRAM_SUPPORT */
-
-static int __init ncr_prepare_setting(ncb_p np, ncr_nvram *nvram)
+static int __init ncr_prepare_setting(ncb_p np)
 {
 	u_char	burst_max;
 	u_long	period;
@@ -3398,25 +3339,6 @@
 	if (driver_setup.scsi_parity)
 		np->rv_scntl0	|= 0x0a;	/*  full arb., ena parity, par->ATN  */
 
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-	/*
-	**	Get parity checking, host ID and verbose mode from NVRAM
-	**/
-	if (nvram) {
-		switch(nvram->type) {
-		case SCSI_NCR_TEKRAM_NVRAM:
-			np->myaddr = nvram->data.Tekram.host_id & 0x0f;
-			break;
-		case SCSI_NCR_SYMBIOS_NVRAM:
-			if (!(nvram->data.Symbios.flags & SYMBIOS_PARITY_ENABLE))
-				np->rv_scntl0  &= ~0x0a;
-			np->myaddr = nvram->data.Symbios.host_id & 0x0f;
-			if (nvram->data.Symbios.flags & SYMBIOS_VERBOSE_MSGS)
-				np->verbose += 1;
-			break;
-		}
-	}
-#endif
 	/*
 	**  Get SCSI addr of host adapter (set by bios?).
 	*/
@@ -3454,8 +3376,6 @@
 				break;
 			}
 		case 3:	/* SYMBIOS controllers report HVD through GPIO3 */
-			if (nvram && nvram->type != SCSI_NCR_SYMBIOS_NVRAM)
-				break;
 			if (INB(nc_gpreg) & 0x08)
 				break;
 		case 2:	/* Set HVD unconditionally */
@@ -3478,9 +3398,7 @@
 	**	that drive the LED directly.
 	**	Also probe initial setting of GPIO0 as output.
 	*/
-	if ((driver_setup.led_pin ||
-	     (nvram && nvram->type == SCSI_NCR_SYMBIOS_NVRAM)) &&
-	    !(np->features & FE_LEDC) && !(np->sv_gpcntl & 0x01))
+	if (driver_setup.led_pin)
 		np->features |= FE_LED0;
 
 	/*
@@ -3507,43 +3425,18 @@
 		tcb_p tp = &np->target[i];
 
 		tp->usrsync = 255;
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-		if (nvram) {
-			switch(nvram->type) {
-			case SCSI_NCR_TEKRAM_NVRAM:
-				ncr_Tekram_setup_target(np, i, &nvram->data.Tekram);
-				break;
-			case SCSI_NCR_SYMBIOS_NVRAM:
-				ncr_Symbios_setup_target(np, i, &nvram->data.Symbios);
-				break;
-			}
-			if (driver_setup.use_nvram & 0x2)
-				tp->usrsync = driver_setup.default_sync;
-			if (driver_setup.use_nvram & 0x4)
-				tp->usrwide = driver_setup.max_wide;
-			if (driver_setup.use_nvram & 0x8)
-				tp->usrflag &= ~UF_NOSCAN;
-		}
-		else {
-#else
-		if (1) {
-#endif
-			tp->usrsync = driver_setup.default_sync;
-			tp->usrwide = driver_setup.max_wide;
-			tp->usrtags = MAX_TAGS;
-			if (!driver_setup.disconnection)
-				np->target[i].usrflag = UF_NODISC;
-		}
+		tp->usrsync = driver_setup.default_sync;
+		tp->usrwide = driver_setup.max_wide;
+		tp->usrtags = MAX_TAGS;
+		if (!driver_setup.disconnection)
+			np->target[i].usrflag = UF_NODISC;
 	}
 
 	/*
 	**	Announce all that stuff to user.
 	*/
 
-	i = nvram ? nvram->type : 0;
-	printk(KERN_INFO "%s: %sID %d, Fast-%d%s%s\n", ncr_name(np),
-		i  == SCSI_NCR_SYMBIOS_NVRAM ? "Symbios format NVRAM, " :
-		(i == SCSI_NCR_TEKRAM_NVRAM  ? "Tekram format NVRAM, " : ""),
+	printk(KERN_INFO "%s: ID %d, Fast-%d%s%s\n", ncr_name(np),
 		np->myaddr,
 		np->minsync < 12 ? 40 : (np->minsync < 25 ? 20 : 10),
 		(np->rv_scntl0 & 0xa)	? ", Parity Checking"	: ", NO Parity",
@@ -3585,7 +3478,6 @@
 	ncb_p np = 0;
         struct Scsi_Host *instance = 0;
 	u_long flags = 0;
-	ncr_nvram *nvram = device->nvram;
 	int i;
 
 #ifdef SCSI_NCR_PROC_INFO_SUPPORT
@@ -3713,32 +3605,10 @@
 	np->base_io = device->slot.io_port;
 #endif /* !defined SCSI_NCR_IOMAPPED */
 
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-	if (nvram) {
-		switch(nvram->type) {
-		case SCSI_NCR_SYMBIOS_NVRAM:
-#ifdef SCSI_NCR_DEBUG_NVRAM
-			ncr_display_Symbios_nvram(&nvram->data.Symbios);
-#endif
-			break;
-		case SCSI_NCR_TEKRAM_NVRAM:
-#ifdef SCSI_NCR_DEBUG_NVRAM
-			ncr_display_Tekram_nvram(&nvram->data.Tekram);
-#endif
-			break;
-		default:
-			nvram = 0;
-#ifdef SCSI_NCR_DEBUG_NVRAM
-			printk(KERN_DEBUG "%s: NVRAM: None or invalid data.\n", ncr_name(np));
-#endif
-		}
-	}
-#endif
-
 	/*
 	**	Do chip dependent initialization.
 	*/
-	(void)ncr_prepare_setting(np, nvram);
+	(void)ncr_prepare_setting(np);
 
 	if (np->paddr2 && sizeof(struct script) > 4096) {
 		np->paddr2 = 0;
@@ -8576,10 +8446,8 @@
 
      cmd->scsi_done     = done;
      cmd->host_scribble = NULL;
-#ifdef SCSI_NCR_DYNAMIC_DMA_MAPPING
      cmd->__data_mapped = 0;
      cmd->__data_mapping = 0;
-#endif
 
      NCR_LOCK_NCB(np, flags);
 
===== drivers/scsi/ncr53c8xx.h 1.14 vs edited =====
--- 1.14/drivers/scsi/ncr53c8xx.h	Mon Sep 22 20:12:11 2003
+++ edited/drivers/scsi/ncr53c8xx.h	Thu Sep 25 21:00:36 2003
@@ -71,24 +71,6 @@
 
 /*==========================================================
 **
-**	Structure used to store the NVRAM content.
-**
-**==========================================================
-*/
-typedef struct {
-	int type;
-#define	SCSI_NCR_SYMBIOS_NVRAM	(1)
-#define	SCSI_NCR_TEKRAM_NVRAM	(2)
-#ifdef	SCSI_NCR_NVRAM_SUPPORT
-	union {
-		Symbios_nvram Symbios;
-		Tekram_nvram Tekram;
-	} data;
-#endif
-} ncr_nvram;
-
-/*==========================================================
-**
 **	Structure used by detection routine to save data on 
 **	each detected board for attach.
 **
@@ -98,7 +80,6 @@
 	struct device  *dev;
 	ncr_slot  slot;
 	ncr_chip  chip;
-	ncr_nvram *nvram;
 	u_char host_id;
 #ifdef	SCSI_NCR_PQS_PDS_SUPPORT
 	u_char pqs_pds;
===== drivers/scsi/sym53c8xx_comm.h 1.14 vs edited =====
--- 1.14/drivers/scsi/sym53c8xx_comm.h	Tue Sep 23 13:47:30 2003
+++ edited/drivers/scsi/sym53c8xx_comm.h	Thu Sep 25 20:48:58 2003
@@ -74,8 +74,6 @@
 **==========================================================
 */
 
-#define SCSI_NCR_DYNAMIC_DMA_MAPPING
-
 /*==========================================================
 **
 **	Miscallaneous defines.
@@ -360,7 +358,6 @@
 	struct m_link *next;
 } m_link_s;
 
-#ifdef	SCSI_NCR_DYNAMIC_DMA_MAPPING
 typedef struct m_vtob {		/* Virtual to Bus address translation */
 	struct m_vtob *next;
 	m_addr_t vaddr;
@@ -371,10 +368,8 @@
 #define VTOB_HASH_MASK		(VTOB_HASH_SIZE-1)
 #define VTOB_HASH_CODE(m)	\
 	((((m_addr_t) (m)) >> MEMO_CLUSTER_SHIFT) & VTOB_HASH_MASK)
-#endif
 
 typedef struct m_pool {		/* Memory pool of a given kind */
-#ifdef	SCSI_NCR_DYNAMIC_DMA_MAPPING
 	m_bush_t bush;
 	m_addr_t (*getp)(struct m_pool *);
 	void (*freep)(struct m_pool *, m_addr_t);
@@ -385,10 +380,6 @@
 	int nump;
 	m_vtob_s *(vtob[VTOB_HASH_SIZE]);
 	struct m_pool *next;
-#else
-#define M_GETP()		__GetFreePages(MEMO_GFP_FLAGS, MEMO_PAGE_ORDER)
-#define M_FREEP(p)		free_pages(p, MEMO_PAGE_ORDER)
-#endif	/* SCSI_NCR_DYNAMIC_DMA_MAPPING */
 	struct m_link h[PAGE_SHIFT-MEMO_SHIFT+MEMO_PAGE_ORDER+1];
 } m_pool_s;
 
@@ -514,13 +505,6 @@
  * for memory we donnot need to DMA from/to and one pool per pcidev for 
  * memory accessed by the PCI chip. `mp0' is the default not DMAable pool.
  */
-
-#ifndef	SCSI_NCR_DYNAMIC_DMA_MAPPING
-
-static m_pool_s mp0;
-
-#else
-
 static m_addr_t ___mp0_getp(m_pool_s *mp)
 {
 	m_addr_t m = GetPages();
@@ -537,22 +521,6 @@
 
 static m_pool_s mp0 = {0, ___mp0_getp, ___mp0_freep};
 
-#endif	/* SCSI_NCR_DYNAMIC_DMA_MAPPING */
-
-/*
- * DMAable pools.
- */
-
-#ifndef	SCSI_NCR_DYNAMIC_DMA_MAPPING
-
-/* Without pci bus iommu support, all the memory is assumed DMAable */
-
-#define __m_calloc_dma(b, s, n)		m_calloc(s, n)
-#define __m_free_dma(b, p, s, n)	m_free(p, s, n)
-#define __vtobus(b, p)			virt_to_bus(p)
-
-#else
-
 /*
  * With pci bus iommu support, we maintain one pool per pcidev and a 
  * hashed reverse table for virtual to bus physical address translations.
@@ -687,8 +655,6 @@
 	return vp ? vp->baddr + (((m_addr_t) m) - a) : 0;
 }
 
-#endif	/* SCSI_NCR_DYNAMIC_DMA_MAPPING */
-
 #define _m_calloc_dma(np, s, n)		__m_calloc_dma(np->dev, s, n)
 #define _m_free_dma(np, p, s, n)	__m_free_dma(np->dev, p, s, n)
 #define m_calloc_dma(s, n)		_m_calloc_dma(np, s, n)
@@ -700,22 +666,6 @@
  *  Deal with DMA mapping/unmapping.
  */
 
-#ifndef SCSI_NCR_DYNAMIC_DMA_MAPPING
-
-/* Linux versions prior to pci bus iommu kernel interface */
-
-#define __unmap_scsi_data(dev, cmd)	do {; } while (0)
-#define __map_scsi_single_data(dev, cmd) (__vtobus(dev,(cmd)->request_buffer))
-#define __map_scsi_sg_data(dev, cmd)	((cmd)->use_sg)
-#define __sync_scsi_data(dev, cmd)	do {; } while (0)
-
-#define scsi_sg_dma_address(sc)		vtobus((sc)->address)
-#define scsi_sg_dma_len(sc)		((sc)->length)
-
-#else
-
-/* Linux version with pci bus iommu kernel interface */
-
 /* To keep track of the dma mapping (sg/single) that has been set */
 #define __data_mapped	SCp.phase
 #define __data_mapping	SCp.have_data_in
@@ -790,64 +740,13 @@
 #define scsi_sg_dma_address(sc)		sg_dma_address(sc)
 #define scsi_sg_dma_len(sc)		sg_dma_len(sc)
 
-#endif	/* SCSI_NCR_DYNAMIC_DMA_MAPPING */
-
 #define unmap_scsi_data(np, cmd)	__unmap_scsi_data(np->dev, cmd)
 #define map_scsi_single_data(np, cmd)	__map_scsi_single_data(np->dev, cmd)
 #define map_scsi_sg_data(np, cmd)	__map_scsi_sg_data(np->dev, cmd)
 #define sync_scsi_data(np, cmd)		__sync_scsi_data(np->dev, cmd)
 
-/*==========================================================
-**
-**	SCSI data transfer direction
-**
-**	Until some linux kernel version near 2.3.40, 
-**	low-level scsi drivers were not told about data 
-**	transfer direction. We check the existence of this 
-**	feature that has been expected for a _long_ time by 
-**	all SCSI driver developers by just testing against 
-**	the definition of SCSI_DATA_UNKNOWN. Indeed this is 
-**	a hack, but testing against a kernel version would 
-**	have been a shame. ;-)
-**
-**==========================================================
-*/
-#ifdef	SCSI_DATA_UNKNOWN
-
 #define scsi_data_direction(cmd)	(cmd->sc_data_direction)
 
-#else
-
-#define	SCSI_DATA_UNKNOWN	0
-#define	SCSI_DATA_WRITE		1
-#define	SCSI_DATA_READ		2
-#define	SCSI_DATA_NONE		3
-
-static __inline__ int scsi_data_direction(Scsi_Cmnd *cmd)
-{
-	int direction;
-
-	switch((int) cmd->cmnd[0]) {
-	case 0x08:  /*	READ(6)				08 */
-	case 0x28:  /*	READ(10)			28 */
-	case 0xA8:  /*	READ(12)			A8 */
-		direction = SCSI_DATA_READ;
-		break;
-	case 0x0A:  /*	WRITE(6)			0A */
-	case 0x2A:  /*	WRITE(10)			2A */
-	case 0xAA:  /*	WRITE(12)			AA */
-		direction = SCSI_DATA_WRITE;
-		break;
-	default:
-		direction = SCSI_DATA_UNKNOWN;
-		break;
-	}
-
-	return direction;
-}
-
-#endif	/* SCSI_DATA_UNKNOWN */
-
 /*==========================================================
 **
 **	Driver setup.
@@ -868,603 +767,6 @@
 
 #define initverbose (driver_setup.verbose)
 #define bootverbose (np->verbose)
-
-
-/*==========================================================
-**
-**	NVRAM detection and reading.
-**	 
-**	Currently supported:
-**	- 24C16 EEPROM with both Symbios and Tekram layout.
-**	- 93C46 EEPROM with Tekram layout.
-**
-**==========================================================
-*/
-
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-/*
- *  24C16 EEPROM reading.
- *
- *  GPOI0 - data in/data out
- *  GPIO1 - clock
- *  Symbios NVRAM wiring now also used by Tekram.
- */
-
-#define SET_BIT 0
-#define CLR_BIT 1
-#define SET_CLK 2
-#define CLR_CLK 3
-
-/*
- *  Set/clear data/clock bit in GPIO0
- */
-static void __init
-S24C16_set_bit(ncr_slot *np, u_char write_bit, u_char *gpreg, int bit_mode)
-{
-	UDELAY (5);
-	switch (bit_mode){
-	case SET_BIT:
-		*gpreg |= write_bit;
-		break;
-	case CLR_BIT:
-		*gpreg &= 0xfe;
-		break;
-	case SET_CLK:
-		*gpreg |= 0x02;
-		break;
-	case CLR_CLK:
-		*gpreg &= 0xfd;
-		break;
-
-	}
-	OUTB (nc_gpreg, *gpreg);
-	UDELAY (5);
-}
-
-/*
- *  Send START condition to NVRAM to wake it up.
- */
-static void __init S24C16_start(ncr_slot *np, u_char *gpreg)
-{
-	S24C16_set_bit(np, 1, gpreg, SET_BIT);
-	S24C16_set_bit(np, 0, gpreg, SET_CLK);
-	S24C16_set_bit(np, 0, gpreg, CLR_BIT);
-	S24C16_set_bit(np, 0, gpreg, CLR_CLK);
-}
-
-/*
- *  Send STOP condition to NVRAM - puts NVRAM to sleep... ZZzzzz!!
- */
-static void __init S24C16_stop(ncr_slot *np, u_char *gpreg)
-{
-	S24C16_set_bit(np, 0, gpreg, SET_CLK);
-	S24C16_set_bit(np, 1, gpreg, SET_BIT);
-}
-
-/*
- *  Read or write a bit to the NVRAM,
- *  read if GPIO0 input else write if GPIO0 output
- */
-static void __init 
-S24C16_do_bit(ncr_slot *np, u_char *read_bit, u_char write_bit, u_char *gpreg)
-{
-	S24C16_set_bit(np, write_bit, gpreg, SET_BIT);
-	S24C16_set_bit(np, 0, gpreg, SET_CLK);
-	if (read_bit)
-		*read_bit = INB (nc_gpreg);
-	S24C16_set_bit(np, 0, gpreg, CLR_CLK);
-	S24C16_set_bit(np, 0, gpreg, CLR_BIT);
-}
-
-/*
- *  Output an ACK to the NVRAM after reading,
- *  change GPIO0 to output and when done back to an input
- */
-static void __init
-S24C16_write_ack(ncr_slot *np, u_char write_bit, u_char *gpreg, u_char *gpcntl)
-{
-	OUTB (nc_gpcntl, *gpcntl & 0xfe);
-	S24C16_do_bit(np, 0, write_bit, gpreg);
-	OUTB (nc_gpcntl, *gpcntl);
-}
-
-/*
- *  Input an ACK from NVRAM after writing,
- *  change GPIO0 to input and when done back to an output
- */
-static void __init 
-S24C16_read_ack(ncr_slot *np, u_char *read_bit, u_char *gpreg, u_char *gpcntl)
-{
-	OUTB (nc_gpcntl, *gpcntl | 0x01);
-	S24C16_do_bit(np, read_bit, 1, gpreg);
-	OUTB (nc_gpcntl, *gpcntl);
-}
-
-/*
- *  WRITE a byte to the NVRAM and then get an ACK to see it was accepted OK,
- *  GPIO0 must already be set as an output
- */
-static void __init 
-S24C16_write_byte(ncr_slot *np, u_char *ack_data, u_char write_data, 
-		  u_char *gpreg, u_char *gpcntl)
-{
-	int x;
-	
-	for (x = 0; x < 8; x++)
-		S24C16_do_bit(np, 0, (write_data >> (7 - x)) & 0x01, gpreg);
-		
-	S24C16_read_ack(np, ack_data, gpreg, gpcntl);
-}
-
-/*
- *  READ a byte from the NVRAM and then send an ACK to say we have got it,
- *  GPIO0 must already be set as an input
- */
-static void __init 
-S24C16_read_byte(ncr_slot *np, u_char *read_data, u_char ack_data, 
-	         u_char *gpreg, u_char *gpcntl)
-{
-	int x;
-	u_char read_bit;
-
-	*read_data = 0;
-	for (x = 0; x < 8; x++) {
-		S24C16_do_bit(np, &read_bit, 1, gpreg);
-		*read_data |= ((read_bit & 0x01) << (7 - x));
-	}
-
-	S24C16_write_ack(np, ack_data, gpreg, gpcntl);
-}
-
-/*
- *  Read 'len' bytes starting at 'offset'.
- */
-static int __init 
-sym_read_S24C16_nvram (ncr_slot *np, int offset, u_char *data, int len)
-{
-	u_char	gpcntl, gpreg;
-	u_char	old_gpcntl, old_gpreg;
-	u_char	ack_data;
-	int	retv = 1;
-	int	x;
-
-	/* save current state of GPCNTL and GPREG */
-	old_gpreg	= INB (nc_gpreg);
-	old_gpcntl	= INB (nc_gpcntl);
-	gpcntl		= old_gpcntl & 0x1c;
-
-	/* set up GPREG & GPCNTL to set GPIO0 and GPIO1 in to known state */
-	OUTB (nc_gpreg,  old_gpreg);
-	OUTB (nc_gpcntl, gpcntl);
-
-	/* this is to set NVRAM into a known state with GPIO0/1 both low */
-	gpreg = old_gpreg;
-	S24C16_set_bit(np, 0, &gpreg, CLR_CLK);
-	S24C16_set_bit(np, 0, &gpreg, CLR_BIT);
-		
-	/* now set NVRAM inactive with GPIO0/1 both high */
-	S24C16_stop(np, &gpreg);
-	
-	/* activate NVRAM */
-	S24C16_start(np, &gpreg);
-
-	/* write device code and random address MSB */
-	S24C16_write_byte(np, &ack_data,
-		0xa0 | ((offset >> 7) & 0x0e), &gpreg, &gpcntl);
-	if (ack_data & 0x01)
-		goto out;
-
-	/* write random address LSB */
-	S24C16_write_byte(np, &ack_data,
-		offset & 0xff, &gpreg, &gpcntl);
-	if (ack_data & 0x01)
-		goto out;
-
-	/* regenerate START state to set up for reading */
-	S24C16_start(np, &gpreg);
-	
-	/* rewrite device code and address MSB with read bit set (lsb = 0x01) */
-	S24C16_write_byte(np, &ack_data,
-		0xa1 | ((offset >> 7) & 0x0e), &gpreg, &gpcntl);
-	if (ack_data & 0x01)
-		goto out;
-
-	/* now set up GPIO0 for inputting data */
-	gpcntl |= 0x01;
-	OUTB (nc_gpcntl, gpcntl);
-		
-	/* input all requested data - only part of total NVRAM */
-	for (x = 0; x < len; x++) 
-		S24C16_read_byte(np, &data[x], (x == (len-1)), &gpreg, &gpcntl);
-
-	/* finally put NVRAM back in inactive mode */
-	gpcntl &= 0xfe;
-	OUTB (nc_gpcntl, gpcntl);
-	S24C16_stop(np, &gpreg);
-	retv = 0;
-out:
-	/* return GPIO0/1 to original states after having accessed NVRAM */
-	OUTB (nc_gpcntl, old_gpcntl);
-	OUTB (nc_gpreg,  old_gpreg);
-
-	return retv;
-}
-
-#undef SET_BIT
-#undef CLR_BIT
-#undef SET_CLK
-#undef CLR_CLK
-
-/*
- *  Try reading Symbios NVRAM.
- *  Return 0 if OK.
- */
-static int __init sym_read_Symbios_nvram (ncr_slot *np, Symbios_nvram *nvram)
-{
-	static u_char Symbios_trailer[6] = {0xfe, 0xfe, 0, 0, 0, 0};
-	u_char *data = (u_char *) nvram;
-	int len  = sizeof(*nvram);
-	u_short	csum;
-	int x;
-
-	/* probe the 24c16 and read the SYMBIOS 24c16 area */
-	if (sym_read_S24C16_nvram (np, SYMBIOS_NVRAM_ADDRESS, data, len))
-		return 1;
-
-	/* check valid NVRAM signature, verify byte count and checksum */
-	if (nvram->type != 0 ||
-	    memcmp(nvram->trailer, Symbios_trailer, 6) ||
-	    nvram->byte_count != len - 12)
-		return 1;
-
-	/* verify checksum */
-	for (x = 6, csum = 0; x < len - 6; x++)
-		csum += data[x];
-	if (csum != nvram->checksum)
-		return 1;
-
-	return 0;
-}
-
-/*
- *  93C46 EEPROM reading.
- *
- *  GPOI0 - data in
- *  GPIO1 - data out
- *  GPIO2 - clock
- *  GPIO4 - chip select
- *
- *  Used by Tekram.
- */
-
-/*
- *  Pulse clock bit in GPIO0
- */
-static void __init T93C46_Clk(ncr_slot *np, u_char *gpreg)
-{
-	OUTB (nc_gpreg, *gpreg | 0x04);
-	UDELAY (2);
-	OUTB (nc_gpreg, *gpreg);
-}
-
-/* 
- *  Read bit from NVRAM
- */
-static void __init T93C46_Read_Bit(ncr_slot *np, u_char *read_bit, u_char *gpreg)
-{
-	UDELAY (2);
-	T93C46_Clk(np, gpreg);
-	*read_bit = INB (nc_gpreg);
-}
-
-/*
- *  Write bit to GPIO0
- */
-static void __init T93C46_Write_Bit(ncr_slot *np, u_char write_bit, u_char *gpreg)
-{
-	if (write_bit & 0x01)
-		*gpreg |= 0x02;
-	else
-		*gpreg &= 0xfd;
-		
-	*gpreg |= 0x10;
-		
-	OUTB (nc_gpreg, *gpreg);
-	UDELAY (2);
-
-	T93C46_Clk(np, gpreg);
-}
-
-/*
- *  Send STOP condition to NVRAM - puts NVRAM to sleep... ZZZzzz!!
- */
-static void __init T93C46_Stop(ncr_slot *np, u_char *gpreg)
-{
-	*gpreg &= 0xef;
-	OUTB (nc_gpreg, *gpreg);
-	UDELAY (2);
-
-	T93C46_Clk(np, gpreg);
-}
-
-/*
- *  Send read command and address to NVRAM
- */
-static void __init 
-T93C46_Send_Command(ncr_slot *np, u_short write_data, 
-		    u_char *read_bit, u_char *gpreg)
-{
-	int x;
-
-	/* send 9 bits, start bit (1), command (2), address (6)  */
-	for (x = 0; x < 9; x++)
-		T93C46_Write_Bit(np, (u_char) (write_data >> (8 - x)), gpreg);
-
-	*read_bit = INB (nc_gpreg);
-}
-
-/*
- *  READ 2 bytes from the NVRAM
- */
-static void __init 
-T93C46_Read_Word(ncr_slot *np, u_short *nvram_data, u_char *gpreg)
-{
-	int x;
-	u_char read_bit;
-
-	*nvram_data = 0;
-	for (x = 0; x < 16; x++) {
-		T93C46_Read_Bit(np, &read_bit, gpreg);
-
-		if (read_bit & 0x01)
-			*nvram_data |=  (0x01 << (15 - x));
-		else
-			*nvram_data &= ~(0x01 << (15 - x));
-	}
-}
-
-/*
- *  Read Tekram NvRAM data.
- */
-static int __init 
-T93C46_Read_Data(ncr_slot *np, u_short *data,int len,u_char *gpreg)
-{
-	u_char	read_bit;
-	int	x;
-
-	for (x = 0; x < len; x++)  {
-
-		/* output read command and address */
-		T93C46_Send_Command(np, 0x180 | x, &read_bit, gpreg);
-		if (read_bit & 0x01)
-			return 1; /* Bad */
-		T93C46_Read_Word(np, &data[x], gpreg);
-		T93C46_Stop(np, gpreg);
-	}
-
-	return 0;
-}
-
-/*
- *  Try reading 93C46 Tekram NVRAM.
- */
-static int __init 
-sym_read_T93C46_nvram (ncr_slot *np, Tekram_nvram *nvram)
-{
-	u_char gpcntl, gpreg;
-	u_char old_gpcntl, old_gpreg;
-	int retv = 1;
-
-	/* save current state of GPCNTL and GPREG */
-	old_gpreg	= INB (nc_gpreg);
-	old_gpcntl	= INB (nc_gpcntl);
-
-	/* set up GPREG & GPCNTL to set GPIO0/1/2/4 in to known state, 0 in,
-	   1/2/4 out */
-	gpreg = old_gpreg & 0xe9;
-	OUTB (nc_gpreg, gpreg);
-	gpcntl = (old_gpcntl & 0xe9) | 0x09;
-	OUTB (nc_gpcntl, gpcntl);
-
-	/* input all of NVRAM, 64 words */
-	retv = T93C46_Read_Data(np, (u_short *) nvram,
-				sizeof(*nvram) / sizeof(short), &gpreg);
-	
-	/* return GPIO0/1/2/4 to original states after having accessed NVRAM */
-	OUTB (nc_gpcntl, old_gpcntl);
-	OUTB (nc_gpreg,  old_gpreg);
-
-	return retv;
-}
-
-/*
- *  Try reading Tekram NVRAM.
- *  Return 0 if OK.
- */
-static int __init 
-sym_read_Tekram_nvram (ncr_slot *np, u_short device_id, Tekram_nvram *nvram)
-{
-	u_char *data = (u_char *) nvram;
-	int len = sizeof(*nvram);
-	u_short	csum;
-	int x;
-
-	switch (device_id) {
-	case PCI_DEVICE_ID_NCR_53C885:
-	case PCI_DEVICE_ID_NCR_53C895:
-	case PCI_DEVICE_ID_NCR_53C896:
-		x = sym_read_S24C16_nvram(np, TEKRAM_24C16_NVRAM_ADDRESS,
-					  data, len);
-		break;
-	case PCI_DEVICE_ID_NCR_53C875:
-		x = sym_read_S24C16_nvram(np, TEKRAM_24C16_NVRAM_ADDRESS,
-					  data, len);
-		if (!x)
-			break;
-	default:
-		x = sym_read_T93C46_nvram(np, nvram);
-		break;
-	}
-	if (x)
-		return 1;
-
-	/* verify checksum */
-	for (x = 0, csum = 0; x < len - 1; x += 2)
-		csum += data[x] + (data[x+1] << 8);
-	if (csum != 0x1234)
-		return 1;
-
-	return 0;
-}
-
-#endif	/* SCSI_NCR_NVRAM_SUPPORT */
-
-/*===================================================================
-**
-**    Detect and try to read SYMBIOS and TEKRAM NVRAM.
-**
-**    Data can be used to order booting of boards.
-**
-**    Data is saved in ncr_device structure if NVRAM found. This
-**    is then used to find drive boot order for ncr_attach().
-**
-**    NVRAM data is passed to Scsi_Host_Template later during 
-**    ncr_attach() for any device set up.
-**
-**===================================================================
-*/
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-static void __init ncr_get_nvram(struct ncr_device *devp, ncr_nvram *nvp)
-{
-	devp->nvram = nvp;
-	if (!nvp)
-		return;
-	/*
-	**    Get access to chip IO registers
-	*/
-#ifdef SCSI_NCR_IOMAPPED
-	request_region(devp->slot.io_port, 128, NAME53C8XX);
-	devp->slot.base_io = devp->slot.io_port;
-#else
-	devp->slot.reg = 
-		(struct ncr_reg *) remap_pci_mem(devp->slot.base_c, 128);
-	if (!devp->slot.reg)
-		return;
-#endif
-
-	/*
-	**    Try to read SYMBIOS nvram.
-	**    Try to read TEKRAM nvram if Symbios nvram not found.
-	*/
-	if	(!sym_read_Symbios_nvram(&devp->slot, &nvp->data.Symbios))
-		nvp->type = SCSI_NCR_SYMBIOS_NVRAM;
-	else if	(!sym_read_Tekram_nvram(&devp->slot, devp->chip.device_id,
-					&nvp->data.Tekram))
-		nvp->type = SCSI_NCR_TEKRAM_NVRAM;
-	else {
-		nvp->type = 0;
-		devp->nvram = 0;
-	}
-
-	/*
-	** Release access to chip IO registers
-	*/
-#ifdef SCSI_NCR_IOMAPPED
-	release_region(devp->slot.base_io, 128);
-#else
-	unmap_pci_mem((u_long) devp->slot.reg, 128ul);
-#endif
-
-}
-
-/*===================================================================
-**
-**	Display the content of NVRAM for debugging purpose.
-**
-**===================================================================
-*/
-#ifdef	SCSI_NCR_DEBUG_NVRAM
-static void __init ncr_display_Symbios_nvram(Symbios_nvram *nvram)
-{
-	int i;
-
-	/* display Symbios nvram host data */
-	printk(KERN_DEBUG NAME53C8XX ": HOST ID=%d%s%s%s%s%s\n",
-		nvram->host_id & 0x0f,
-		(nvram->flags  & SYMBIOS_SCAM_ENABLE)	? " SCAM"	:"",
-		(nvram->flags  & SYMBIOS_PARITY_ENABLE)	? " PARITY"	:"",
-		(nvram->flags  & SYMBIOS_VERBOSE_MSGS)	? " VERBOSE"	:"", 
-		(nvram->flags  & SYMBIOS_CHS_MAPPING)	? " CHS_ALT"	:"", 
-		(nvram->flags1 & SYMBIOS_SCAN_HI_LO)	? " HI_LO"	:"");
-
-	/* display Symbios nvram drive data */
-	for (i = 0 ; i < 15 ; i++) {
-		struct Symbios_target *tn = &nvram->target[i];
-		printk(KERN_DEBUG NAME53C8XX 
-		"-%d:%s%s%s%s WIDTH=%d SYNC=%d TMO=%d\n",
-		i,
-		(tn->flags & SYMBIOS_DISCONNECT_ENABLE)	? " DISC"	: "",
-		(tn->flags & SYMBIOS_SCAN_AT_BOOT_TIME)	? " SCAN_BOOT"	: "",
-		(tn->flags & SYMBIOS_SCAN_LUNS)		? " SCAN_LUNS"	: "",
-		(tn->flags & SYMBIOS_QUEUE_TAGS_ENABLED)? " TCQ"	: "",
-		tn->bus_width,
-		tn->sync_period / 4,
-		tn->timeout);
-	}
-}
-
-static u_char Tekram_boot_delay[7] __initdata = {3, 5, 10, 20, 30, 60, 120};
-
-static void __init ncr_display_Tekram_nvram(Tekram_nvram *nvram)
-{
-	int i, tags, boot_delay;
-	char *rem;
-
-	/* display Tekram nvram host data */
-	tags = 2 << nvram->max_tags_index;
-	boot_delay = 0;
-	if (nvram->boot_delay_index < 6)
-		boot_delay = Tekram_boot_delay[nvram->boot_delay_index];
-	switch((nvram->flags & TEKRAM_REMOVABLE_FLAGS) >> 6) {
-	default:
-	case 0:	rem = "";			break;
-	case 1: rem = " REMOVABLE=boot device";	break;
-	case 2: rem = " REMOVABLE=all";		break;
-	}
-
-	printk(KERN_DEBUG NAME53C8XX
-		": HOST ID=%d%s%s%s%s%s%s%s%s%s BOOT DELAY=%d tags=%d\n",
-		nvram->host_id & 0x0f,
-		(nvram->flags1 & SYMBIOS_SCAM_ENABLE)	? " SCAM"	:"",
-		(nvram->flags & TEKRAM_MORE_THAN_2_DRIVES) ? " >2DRIVES":"",
-		(nvram->flags & TEKRAM_DRIVES_SUP_1GB)	? " >1GB"	:"",
-		(nvram->flags & TEKRAM_RESET_ON_POWER_ON) ? " RESET"	:"",
-		(nvram->flags & TEKRAM_ACTIVE_NEGATION)	? " ACT_NEG"	:"",
-		(nvram->flags & TEKRAM_IMMEDIATE_SEEK)	? " IMM_SEEK"	:"",
-		(nvram->flags & TEKRAM_SCAN_LUNS)	? " SCAN_LUNS"	:"",
-		(nvram->flags1 & TEKRAM_F2_F6_ENABLED)	? " F2_F6"	:"",
-		rem, boot_delay, tags);
-
-	/* display Tekram nvram drive data */
-	for (i = 0; i <= 15; i++) {
-		int sync, j;
-		struct Tekram_target *tn = &nvram->target[i];
-		j = tn->sync_index & 0xf;
-		sync = Tekram_sync[j];
-		printk(KERN_DEBUG NAME53C8XX "-%d:%s%s%s%s%s%s PERIOD=%d\n",
-		i,
-		(tn->flags & TEKRAM_PARITY_CHECK)	? " PARITY"	: "",
-		(tn->flags & TEKRAM_SYNC_NEGO)		? " SYNC"	: "",
-		(tn->flags & TEKRAM_DISCONNECT_ENABLE)	? " DISC"	: "",
-		(tn->flags & TEKRAM_START_CMD)		? " START"	: "",
-		(tn->flags & TEKRAM_TAGGED_COMMANDS)	? " TCQ"	: "",
-		(tn->flags & TEKRAM_WIDE_NEGO)		? " WIDE"	: "",
-		sync);
-	}
-}
-#endif /* SCSI_NCR_DEBUG_NVRAM */
-#endif	/* SCSI_NCR_NVRAM_SUPPORT */
-
 
 /*===================================================================
 **
===== drivers/scsi/sym53c8xx_defs.h 1.12 vs edited =====
--- 1.12/drivers/scsi/sym53c8xx_defs.h	Mon Sep 22 20:10:24 2003
+++ edited/drivers/scsi/sym53c8xx_defs.h	Thu Sep 25 20:59:19 2003
@@ -78,15 +78,6 @@
 #endif
 
 /*
- *	No more an option, enabled by default.
- */
-#ifndef CONFIG_SCSI_NCR53C8XX_NO_NVRAM
-# ifndef CONFIG_SCSI_NCR53C8XX_NVRAM_DETECT
-#  define CONFIG_SCSI_NCR53C8XX_NVRAM_DETECT
-# endif
-#endif
-
-/*
 **	These options are not tunable from 'make config'
 */
 #define	SCSI_NCR_PROC_INFO_SUPPORT
@@ -111,18 +102,6 @@
 #	define SCSI_NCR_ENABLE_INTEGRITY_CHECK
 #endif
 
-/*==========================================================
-**
-** nvram settings - #define SCSI_NCR_NVRAM_SUPPORT to enable
-**
-**==========================================================
-*/
-
-#ifdef CONFIG_SCSI_NCR53C8XX_NVRAM_DETECT
-#define SCSI_NCR_NVRAM_SUPPORT
-/* #define SCSI_NCR_DEBUG_NVRAM */
-#endif
-
 /* ---------------------------------------------------------------------
 ** Take into account kernel configured parameters.
 ** Most of these options can be overridden at startup by a command line.
@@ -619,71 +598,6 @@
 #define PSEUDO_720_ID 0x5a00
 #endif
 
-#ifndef PCI_DEVICE_ID_NCR_53C810
-#define PCI_DEVICE_ID_NCR_53C810 1
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C810AP
-#define PCI_DEVICE_ID_NCR_53C810AP 5
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C815
-#define PCI_DEVICE_ID_NCR_53C815 4
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C820
-#define PCI_DEVICE_ID_NCR_53C820 2
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C825
-#define PCI_DEVICE_ID_NCR_53C825 3
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C860
-#define PCI_DEVICE_ID_NCR_53C860 6
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C875
-#define PCI_DEVICE_ID_NCR_53C875 0xf
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C875J
-#define PCI_DEVICE_ID_NCR_53C875J 0x8f
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C885
-#define PCI_DEVICE_ID_NCR_53C885 0xd
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C895
-#define PCI_DEVICE_ID_NCR_53C895 0xc
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C896
-#define PCI_DEVICE_ID_NCR_53C896 0xb
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C895A
-#define PCI_DEVICE_ID_NCR_53C895A 0x12
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C875A
-#define PCI_DEVICE_ID_NCR_53C875A 0x13
-#endif
-
-#ifndef PCI_DEVICE_ID_NCR_53C1510D
-#define PCI_DEVICE_ID_NCR_53C1510D 0xa
-#endif
-
-#ifndef PCI_DEVICE_ID_LSI_53C1010
-#define PCI_DEVICE_ID_LSI_53C1010 0x20
-#endif
-
-#ifndef PCI_DEVICE_ID_LSI_53C1010_66
-#define PCI_DEVICE_ID_LSI_53C1010_66 0x21
-#endif
-
-
 /*
 **   NCR53C8XX devices features table.
 */
@@ -739,106 +653,6 @@
 #define FE_CACHE0_SET	(FE_CACHE_SET & ~FE_ERL)
 
 /*
-**	DEL 397 - 53C875 Rev 3 - Part Number 609-0392410 - ITEM 5.
-**	On paper, this errata is harmless. But it is a good reason for 
-**	using a shorter programmed burst length (64 DWORDS instead of 128).
-*/
-
-#define SCSI_NCR_CHIP_TABLE						\
-{									\
- {PSEUDO_720_ID, 0x0f, "720",  3,  8, 4,				\
- FE_WIDE|FE_DIFF|FE_EHP|FE_MUX|FE_EA}					\
- ,									\
- {PCI_DEVICE_ID_NCR_53C810, 0x0f, "810",  4,  8, 4,			\
- FE_ERL}								\
- ,									\
- {PCI_DEVICE_ID_NCR_53C810, 0xff, "810a", 4,  8, 4,			\
- FE_CACHE_SET|FE_LDSTR|FE_PFEN|FE_BOF}					\
- ,									\
- {PCI_DEVICE_ID_NCR_53C815, 0xff, "815",  4,  8, 4,			\
- FE_ERL|FE_BOF}								\
- ,									\
- {PCI_DEVICE_ID_NCR_53C820, 0xff, "820",  4,  8, 4,			\
- FE_WIDE|FE_ERL}							\
- ,									\
- {PCI_DEVICE_ID_NCR_53C825, 0x0f, "825",  4,  8, 4,			\
- FE_WIDE|FE_ERL|FE_BOF|FE_DIFF}						\
- ,									\
- {PCI_DEVICE_ID_NCR_53C825, 0xff, "825a", 6,  8, 4,			\
- FE_WIDE|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|FE_RAM|FE_DIFF}	\
- ,									\
- {PCI_DEVICE_ID_NCR_53C860, 0xff, "860",  4,  8, 5,			\
- FE_ULTRA|FE_CACHE_SET|FE_BOF|FE_LDSTR|FE_PFEN}				\
- ,									\
- {PCI_DEVICE_ID_NCR_53C875, 0x01, "875",  6, 16, 5,			\
- FE_WIDE|FE_ULTRA|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|		\
- FE_RAM|FE_DIFF|FE_VARCLK}						\
- ,									\
- {PCI_DEVICE_ID_NCR_53C875, 0xff, "875",  6, 16, 5,			\
- FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_DIFF|FE_VARCLK}						\
- ,									\
- {PCI_DEVICE_ID_NCR_53C875J,0xff, "875J", 6, 16, 5,			\
- FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_VARCLK}							\
- ,									\
- {PCI_DEVICE_ID_NCR_53C885, 0xff, "885",  6, 16, 5,			\
- FE_WIDE|FE_ULTRA|FE_DBLR|FE_CACHE0_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_DIFF|FE_VARCLK}						\
- ,									\
- {PCI_DEVICE_ID_NCR_53C895, 0xff, "895",  6, 31, 7,			\
- FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM}								\
- ,									\
- {PCI_DEVICE_ID_NCR_53C896, 0xff, "896",  6, 31, 7,			\
- FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_ISTAT1}	\
- ,									\
- {PCI_DEVICE_ID_NCR_53C895A, 0xff, "895a",  6, 31, 7,			\
- FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_RAM8K|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC}			\
- ,									\
- {PCI_DEVICE_ID_NCR_53C875A, 0xff, "875a",  6, 31, 7,			\
- FE_WIDE|FE_ULTRA|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC}				\
- ,									\
- {PCI_DEVICE_ID_NCR_53C1510D, 0xff, "1510D",  7, 31, 7,			\
- FE_WIDE|FE_ULTRA2|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|	\
- FE_RAM|FE_IO256}							\
- ,									\
- {PCI_DEVICE_ID_LSI_53C1010, 0xff, "1010-33",  6, 62, 7,		\
- FE_WIDE|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|FE_ISTAT1|	\
- FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_ULTRA3}	\
- ,									\
- {PCI_DEVICE_ID_LSI_53C1010_66, 0xff, "1010-66",  6, 62, 7,		\
- FE_WIDE|FE_QUAD|FE_CACHE_SET|FE_BOF|FE_DFS|FE_LDSTR|FE_PFEN|FE_ISTAT1|	\
- FE_RAM|FE_RAM8K|FE_64BIT|FE_DAC|FE_IO256|FE_NOPM|FE_LEDC|FE_ULTRA3|	\
- FE_66MHZ}								\
-}
-
-/*
- * List of supported NCR chip ids
- */
-#define SCSI_NCR_CHIP_IDS		\
-{					\
-	PSEUDO_720_ID,		\
-	PCI_DEVICE_ID_NCR_53C810,	\
-	PCI_DEVICE_ID_NCR_53C815,	\
-	PCI_DEVICE_ID_NCR_53C820,	\
-	PCI_DEVICE_ID_NCR_53C825,	\
-	PCI_DEVICE_ID_NCR_53C860,	\
-	PCI_DEVICE_ID_NCR_53C875,	\
-	PCI_DEVICE_ID_NCR_53C875J,	\
-	PCI_DEVICE_ID_NCR_53C885,	\
-	PCI_DEVICE_ID_NCR_53C895,	\
-	PCI_DEVICE_ID_NCR_53C896,	\
-	PCI_DEVICE_ID_NCR_53C895A,	\
-	PCI_DEVICE_ID_NCR_53C1510D,	\
- 	PCI_DEVICE_ID_LSI_53C1010,	\
- 	PCI_DEVICE_ID_LSI_53C1010_66	\
-}
-
-/*
 **	Driver setup structure.
 **
 **	This structure is initialized from linux config options.
@@ -934,136 +748,6 @@
 	0,					\
 	255					\
 }
-
-#ifdef SCSI_NCR_NVRAM_SUPPORT
-/*
-**	Symbios NvRAM data format
-*/
-#define SYMBIOS_NVRAM_SIZE 368
-#define SYMBIOS_NVRAM_ADDRESS 0x100
-
-struct Symbios_nvram {
-/* Header 6 bytes */
-	u_short type;		/* 0x0000 */
-	u_short byte_count;	/* excluding header/trailer */
-	u_short checksum;
-
-/* Controller set up 20 bytes */
-	u_char	v_major;	/* 0x00 */
-	u_char	v_minor;	/* 0x30 */
-	u32	boot_crc;
-	u_short	flags;
-#define SYMBIOS_SCAM_ENABLE	(1)
-#define SYMBIOS_PARITY_ENABLE	(1<<1)
-#define SYMBIOS_VERBOSE_MSGS	(1<<2)
-#define SYMBIOS_CHS_MAPPING	(1<<3)
-#define SYMBIOS_NO_NVRAM	(1<<3)	/* ??? */
-	u_short	flags1;
-#define SYMBIOS_SCAN_HI_LO	(1)
-	u_short	term_state;
-#define SYMBIOS_TERM_CANT_PROGRAM	(0)
-#define SYMBIOS_TERM_ENABLED		(1)
-#define SYMBIOS_TERM_DISABLED		(2)
-	u_short	rmvbl_flags;
-#define SYMBIOS_RMVBL_NO_SUPPORT	(0)
-#define SYMBIOS_RMVBL_BOOT_DEVICE	(1)
-#define SYMBIOS_RMVBL_MEDIA_INSTALLED	(2)
-	u_char	host_id;
-	u_char	num_hba;	/* 0x04 */
-	u_char	num_devices;	/* 0x10 */
-	u_char	max_scam_devices;	/* 0x04 */
-	u_char	num_valid_scam_devives;	/* 0x00 */
-	u_char	rsvd;
-
-/* Boot order 14 bytes * 4 */
-	struct Symbios_host{
-		u_short	type;		/* 4:8xx / 0:nok */
-		u_short	device_id;	/* PCI device id */
-		u_short	vendor_id;	/* PCI vendor id */
-		u_char	bus_nr;		/* PCI bus number */
-		u_char	device_fn;	/* PCI device/function number << 3*/
-		u_short	word8;
-		u_short	flags;
-#define	SYMBIOS_INIT_SCAN_AT_BOOT	(1)
-		u_short	io_port;	/* PCI io_port address */
-	} host[4];
-
-/* Targets 8 bytes * 16 */
-	struct Symbios_target {
-		u_char	flags;
-#define SYMBIOS_DISCONNECT_ENABLE	(1)
-#define SYMBIOS_SCAN_AT_BOOT_TIME	(1<<1)
-#define SYMBIOS_SCAN_LUNS		(1<<2)
-#define SYMBIOS_QUEUE_TAGS_ENABLED	(1<<3)
-		u_char	rsvd;
-		u_char	bus_width;	/* 0x08/0x10 */
-		u_char	sync_offset;
-		u_short	sync_period;	/* 4*period factor */
-		u_short	timeout;
-	} target[16];
-/* Scam table 8 bytes * 4 */
-	struct Symbios_scam {
-		u_short	id;
-		u_short	method;
-#define SYMBIOS_SCAM_DEFAULT_METHOD	(0)
-#define SYMBIOS_SCAM_DONT_ASSIGN	(1)
-#define SYMBIOS_SCAM_SET_SPECIFIC_ID	(2)
-#define SYMBIOS_SCAM_USE_ORDER_GIVEN	(3)
-		u_short status;
-#define SYMBIOS_SCAM_UNKNOWN		(0)
-#define SYMBIOS_SCAM_DEVICE_NOT_FOUND	(1)
-#define SYMBIOS_SCAM_ID_NOT_SET		(2)
-#define SYMBIOS_SCAM_ID_VALID		(3)
-		u_char	target_id;
-		u_char	rsvd;
-	} scam[4];
-
-	u_char	spare_devices[15*8];
-	u_char	trailer[6];		/* 0xfe 0xfe 0x00 0x00 0x00 0x00 */
-};
-typedef struct Symbios_nvram	Symbios_nvram;
-typedef struct Symbios_host	Symbios_host;
-typedef struct Symbios_target	Symbios_target;
-typedef struct Symbios_scam	Symbios_scam;
-
-/*
-**	Tekram NvRAM data format.
-*/
-#define TEKRAM_NVRAM_SIZE 64
-#define TEKRAM_93C46_NVRAM_ADDRESS 0
-#define TEKRAM_24C16_NVRAM_ADDRESS 0x40
-
-struct Tekram_nvram {
-	struct Tekram_target {
-		u_char	flags;
-#define	TEKRAM_PARITY_CHECK		(1)
-#define TEKRAM_SYNC_NEGO		(1<<1)
-#define TEKRAM_DISCONNECT_ENABLE	(1<<2)
-#define	TEKRAM_START_CMD		(1<<3)
-#define TEKRAM_TAGGED_COMMANDS		(1<<4)
-#define TEKRAM_WIDE_NEGO		(1<<5)
-		u_char	sync_index;
-		u_short	word2;
-	} target[16];
-	u_char	host_id;
-	u_char	flags;
-#define TEKRAM_MORE_THAN_2_DRIVES	(1)
-#define TEKRAM_DRIVES_SUP_1GB		(1<<1)
-#define	TEKRAM_RESET_ON_POWER_ON	(1<<2)
-#define TEKRAM_ACTIVE_NEGATION		(1<<3)
-#define TEKRAM_IMMEDIATE_SEEK		(1<<4)
-#define	TEKRAM_SCAN_LUNS		(1<<5)
-#define	TEKRAM_REMOVABLE_FLAGS		(3<<6)	/* 0: disable; 1: boot device; 2:all */
-	u_char	boot_delay_index;
-	u_char	max_tags_index;
-	u_short	flags1;
-#define TEKRAM_F2_F6_ENABLED		(1)
-	u_short	spare[29];
-};
-typedef struct Tekram_nvram	Tekram_nvram;
-typedef struct Tekram_target	Tekram_target;
-
-#endif /* SCSI_NCR_NVRAM_SUPPORT */
 
 /**************** ORIGINAL CONTENT of ncrreg.h from FreeBSD ******************/
 

From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] ncr iomem annotations
Date: Sun, 21 Nov 2004 18:33:36 +0000
Message-ID: <20041121183336.GD26051@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:27804 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261780AbUKUSdj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Nov 2004 13:33:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC10-rc2-bk6-3w-9xxx/drivers/scsi/NCR_Q720.c RC10-rc2-bk6-ncr/drivers/scsi/NCR_Q720.c
--- RC10-rc2-bk6-3w-9xxx/drivers/scsi/NCR_Q720.c	Sun Nov 21 10:49:00 2004
+++ RC10-rc2-bk6-ncr/drivers/scsi/NCR_Q720.c	Sun Nov 21 10:50:56 2004
@@ -39,7 +39,7 @@
 /* We needs this helper because we have up to four hosts per struct device */
 struct NCR_Q720_private {
 	struct device		*dev;
-	__u32			mem_base;
+	void __iomem *		mem_base;
 	__u32			phys_mem_base;
 	__u32			mem_size;
 	__u8			irq;
@@ -75,7 +75,7 @@
 
 static int __init
 NCR_Q720_probe_one(struct NCR_Q720_private *p, int siop,
-		int irq, int slot, __u32 paddr, __u32 vaddr)
+		int irq, int slot, __u32 paddr, void __iomem *vaddr)
 {
 	struct ncr_device device;
 	__u8 scsi_id;
@@ -146,7 +146,7 @@
 	__u8 pos2, pos4, asr2, asr9, asr10;
 	__u16 io_base;
 	__u32 base_addr, mem_size;
-	__u32 mem_base;
+	void __iomem *mem_base;
 
 	p = kmalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
@@ -227,7 +227,7 @@
 	 */
 	mem_base = (__u32)dma_mark_declared_memory_occupied(dev, base_addr,
 							    1024);
-	if (IS_ERR((void *)mem_base)) {
+	if (IS_ERR(mem_base)) {
 		printk("NCR_Q720 failed to reserve memory mapped region\n");
 		goto out_release;
 	}
@@ -271,7 +271,7 @@
 	}
 	/* disable all the siop interrupts */
 	for(i = 0; i < siops; i++) {
-		__u32 reg_scsr1 = mem_base + NCR_Q720_CHIP_REGISTER_OFFSET
+		void __iomem *reg_scsr1 = mem_base + NCR_Q720_CHIP_REGISTER_OFFSET
 			+ i*NCR_Q720_SIOP_SHIFT + NCR_Q720_SCSR_OFFSET + 1;
 		__u8 scsr1 = readb(reg_scsr1);
 		scsr1 |= 0x01;
@@ -280,7 +280,7 @@
 
 	/* plumb in all 720 chips */
 	for (i = 0; i < siops; i++) {
-		__u32 siop_v_base = mem_base + NCR_Q720_CHIP_REGISTER_OFFSET
+		void __iomem *siop_v_base = mem_base + NCR_Q720_CHIP_REGISTER_OFFSET
 			+ i*NCR_Q720_SIOP_SHIFT;
 		__u32 siop_p_base = base_addr + NCR_Q720_CHIP_REGISTER_OFFSET
 			+ i*NCR_Q720_SIOP_SHIFT;
diff -urN RC10-rc2-bk6-3w-9xxx/drivers/scsi/ncr53c8xx.c RC10-rc2-bk6-ncr/drivers/scsi/ncr53c8xx.c
--- RC10-rc2-bk6-3w-9xxx/drivers/scsi/ncr53c8xx.c	Sun Nov 21 10:49:30 2004
+++ RC10-rc2-bk6-ncr/drivers/scsi/ncr53c8xx.c	Sun Nov 21 10:50:56 2004
@@ -950,11 +950,11 @@
 	**	Virtual and physical bus addresses of the chip.
 	**----------------------------------------------------------------
 	*/
-	unsigned long	vaddr;		/* Virtual and bus address of	*/
+	void __iomem *vaddr;		/* Virtual and bus address of	*/
 	unsigned long	paddr;		/*  chip's IO registers.	*/
 	unsigned long	paddr2;		/* On-chip RAM bus address.	*/
 	volatile			/* Pointer to volatile for 	*/
-	struct ncr_reg	*reg;		/*  memory mapped IO.		*/
+	struct ncr_reg	__iomem *reg;	/*  memory mapped IO.		*/
 
 	/*----------------------------------------------------------------
 	**	SCRIPTS virtual and physical bus addresses.
@@ -7839,7 +7839,7 @@
 	if (device->slot.base_v)
 		np->vaddr = device->slot.base_v;
 	else
-		np->vaddr = (unsigned long)ioremap(device->slot.base_c, 128);
+		np->vaddr = ioremap(device->slot.base_c, 128);
 
 	if (!np->vaddr) {
 		printk(KERN_ERR
@@ -7855,7 +7855,7 @@
 	 * OUTB OUTW OUTL macros can be used safely.
 	 */
 
-	np->reg = (struct ncr_reg*) np->vaddr;
+	np->reg = (struct ncr_reg __iomem *)np->vaddr;
 
 	/* Do chip dependent initialization.  */
 	ncr_prepare_setting(np);
diff -urN RC10-rc2-bk6-3w-9xxx/drivers/scsi/ncr53c8xx.h RC10-rc2-bk6-ncr/drivers/scsi/ncr53c8xx.h
--- RC10-rc2-bk6-3w-9xxx/drivers/scsi/ncr53c8xx.h	Sun Nov 21 10:49:05 2004
+++ RC10-rc2-bk6-ncr/drivers/scsi/ncr53c8xx.h	Sun Nov 21 10:50:56 2004
@@ -70,11 +70,11 @@
 	u_long	base_2;
 	u_long	base_c;
 	u_long	base_2_c;
-	u_long	base_v;
-	u_long	base_2_v;
+	void __iomem *base_v;
+	void __iomem *base_2_v;
 	int	irq;
 /* port and reg fields to use INB, OUTB macros */
-	volatile struct ncr_reg	*reg;
+	volatile struct ncr_reg	__iomem *reg;
 };
 
 /*==========================================================
diff -urN RC10-rc2-bk6-3w-9xxx/drivers/scsi/sym53c8xx_defs.h RC10-rc2-bk6-ncr/drivers/scsi/sym53c8xx_defs.h
--- RC10-rc2-bk6-3w-9xxx/drivers/scsi/sym53c8xx_defs.h	Sun Nov 21 10:49:06 2004
+++ RC10-rc2-bk6-ncr/drivers/scsi/sym53c8xx_defs.h	Sun Nov 21 10:50:56 2004
@@ -415,42 +415,42 @@
  *  MEMORY mapped IO input / output
  */
 
-#define INB_OFF(o)		readb_raw((char *)np->reg + ncr_offb(o))
-#define OUTB_OFF(o, val)	writeb_raw((val), (char *)np->reg + ncr_offb(o))
+#define INB_OFF(o)		readb_raw((char __iomem *)np->reg + ncr_offb(o))
+#define OUTB_OFF(o, val)	writeb_raw((val), (char __iomem *)np->reg + ncr_offb(o))
 
 #if	defined(__BIG_ENDIAN) && !defined(SCSI_NCR_BIG_ENDIAN)
 
-#define INW_OFF(o)		readw_l2b((char *)np->reg + ncr_offw(o))
-#define INL_OFF(o)		readl_l2b((char *)np->reg + (o))
+#define INW_OFF(o)		readw_l2b((char __iomem *)np->reg + ncr_offw(o))
+#define INL_OFF(o)		readl_l2b((char __iomem *)np->reg + (o))
 
-#define OUTW_OFF(o, val)	writew_b2l((val), (char *)np->reg + ncr_offw(o))
-#define OUTL_OFF(o, val)	writel_b2l((val), (char *)np->reg + (o))
+#define OUTW_OFF(o, val)	writew_b2l((val), (char __iomem *)np->reg + ncr_offw(o))
+#define OUTL_OFF(o, val)	writel_b2l((val), (char __iomem *)np->reg + (o))
 
 #elif	defined(__LITTLE_ENDIAN) && defined(SCSI_NCR_BIG_ENDIAN)
 
-#define INW_OFF(o)		readw_b2l((char *)np->reg + ncr_offw(o))
-#define INL_OFF(o)		readl_b2l((char *)np->reg + (o))
+#define INW_OFF(o)		readw_b2l((char __iomem *)np->reg + ncr_offw(o))
+#define INL_OFF(o)		readl_b2l((char __iomem *)np->reg + (o))
 
-#define OUTW_OFF(o, val)	writew_l2b((val), (char *)np->reg + ncr_offw(o))
-#define OUTL_OFF(o, val)	writel_l2b((val), (char *)np->reg + (o))
+#define OUTW_OFF(o, val)	writew_l2b((val), (char __iomem *)np->reg + ncr_offw(o))
+#define OUTL_OFF(o, val)	writel_l2b((val), (char __iomem *)np->reg + (o))
 
 #else
 
 #ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
 /* Only 8 or 32 bit transfers allowed */
-#define INW_OFF(o)		(readb((char *)np->reg + ncr_offw(o)) << 8 | readb((char *)np->reg + ncr_offw(o) + 1))
+#define INW_OFF(o)		(readb((char __iomem *)np->reg + ncr_offw(o)) << 8 | readb((char __iomem *)np->reg + ncr_offw(o) + 1))
 #else
-#define INW_OFF(o)		readw_raw((char *)np->reg + ncr_offw(o))
+#define INW_OFF(o)		readw_raw((char __iomem *)np->reg + ncr_offw(o))
 #endif
-#define INL_OFF(o)		readl_raw((char *)np->reg + (o))
+#define INL_OFF(o)		readl_raw((char __iomem *)np->reg + (o))
 
 #ifdef CONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
 /* Only 8 or 32 bit transfers allowed */
-#define OUTW_OFF(o, val)	do { writeb((char)((val) >> 8), (char *)np->reg + ncr_offw(o)); writeb((char)(val), (char *)np->reg + ncr_offw(o) + 1); } while (0)
+#define OUTW_OFF(o, val)	do { writeb((char)((val) >> 8), (char __iomem *)np->reg + ncr_offw(o)); writeb((char)(val), (char __iomem *)np->reg + ncr_offw(o) + 1); } while (0)
 #else
-#define OUTW_OFF(o, val)	writew_raw((val), (char *)np->reg + ncr_offw(o))
+#define OUTW_OFF(o, val)	writew_raw((val), (char __iomem *)np->reg + ncr_offw(o))
 #endif
-#define OUTL_OFF(o, val)	writel_raw((val), (char *)np->reg + (o))
+#define OUTL_OFF(o, val)	writel_raw((val), (char __iomem *)np->reg + (o))
 
 #endif
 

From: Ke Wei <kewei.mv@gmail.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Sun, 27 Jan 2008 23:27:33 +0800
Message-ID: <20080127152733.GC21302@ubuntu.domain>
References: <20080122151857.GA8680@ubuntu.domain> <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com> <4796BB5A.9090003@garzik.org> <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com> <479727D5.8060901@garzik.org> <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com> <1201300769.3119.78.camel@localhost.localdomain>
Reply-To: Ke Wei <kewei.mv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:28345 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYA0P0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jan 2008 10:26:47 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1402184rvb.1
        for <linux-scsi@vger.kernel.org>; Sun, 27 Jan 2008 07:26:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1201300769.3119.78.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, kewei.mv@gmail.com, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, kewei@marvell.com

mvsas : Fixed coding problem

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |   61 +++++++++++++++++++++++++++----------------------
 1 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 321be21..3bf009b 100755
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -55,11 +55,11 @@
 
 /* offset for D2H FIS in the Received FIS List Structure */
 #define SATA_RECEIVED_D2H_FIS(reg_set) \
-	(mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
+	((void *) mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
 #define SATA_RECEIVED_PIO_FIS(reg_set) \
-	(mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
+	((void *) mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
 #define UNASSOC_D2H_FIS(id) \
-	(mvi->rx_fis + 0x100 * id)
+	((void *) mvi->rx_fis + 0x100 * id)
 
 /* driver compile-time configuration */
 enum driver_configuration {
@@ -553,17 +553,16 @@ struct mvs_phy {
 	struct mvs_port		*port;
 	struct asd_sas_phy	sas_phy;
 	struct sas_identify identify;
-	__le32		dev_info;
-	__le64		dev_sas_addr;
-	__le32		att_dev_info;
-	__le64		att_dev_sas_addr;
+	u64		dev_sas_addr;
+	u64		att_dev_sas_addr;
+	u32		att_dev_info;
+	u32		dev_info;
 	u32		type;
-	__le32		phy_status;
-	__le32		irq_status;
-	u8		wide_port_phymap;
+	u32		phy_status;
+	u32		irq_status;
 	u32		frame_rcvd_size;
 	u8		frame_rcvd[32];
-
+	u8		wide_port_phymap;
 };
 
 struct mvs_info {
@@ -586,7 +585,7 @@ struct mvs_info {
 	dma_addr_t		rx_dma;
 	u32			rx_cons;	/* RX consumer idx */
 
-	void			*rx_fis;	/* RX'd FIS area */
+	__le32			*rx_fis;	/* RX'd FIS area */
 	dma_addr_t		rx_fis_dma;
 
 	struct mvs_cmd_hdr	*slot;	/* DMA command header slots */
@@ -624,7 +623,6 @@ static void mvs_write_port_vsr_data(struct mvs_info *mvi, u32 port, u32 val);
 static void mvs_write_port_vsr_addr(struct mvs_info *mvi, u32 port, u32 addr);
 static u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32 port);
 static void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val);
-static u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port);
 static void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val);
 
 static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
@@ -705,8 +703,7 @@ static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
 	else
 		len_ct = MVS_SSP_CMD_SZ;
 
-	offset =
-	    len_ct + MVS_OAF_SZ +
+	offset = len_ct + MVS_OAF_SZ +
 	    sizeof(struct mvs_prd) * mvi->slot_info[tag].n_elem;
 	dev_printk(KERN_DEBUG, &pdev->dev, "+---->Status buffer :\n");
 	mvs_hexdump(32, (u8 *) mvi->slot_info[tag].response,
@@ -792,21 +789,27 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
 #endif
 }
 
-static void mvs_hba_interrupt_enable(struct mvs_info *mvi, int enable)
+#if 0
+static void mvs_hba_interrupt_enable(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp;
-	unsigned long flags;
 
-	spin_lock_irqsave(&mvi->lock, flags);
 	tmp = mr32(GBL_CTL);
 
-	if (enable)
-		mw32(GBL_CTL, tmp | INT_EN);
-	else
-		mw32(GBL_CTL, tmp & ~INT_EN);
-	spin_unlock_irqrestore(&mvi->lock, flags);
+	mw32(GBL_CTL, tmp | INT_EN);
+}
+
+static void mvs_hba_interrupt_disable(struct mvs_info *mvi)
+{
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	tmp = mr32(GBL_CTL);
+
+	mw32(GBL_CTL, tmp & ~INT_EN);
 }
+#endif
 
 static int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
 
@@ -1345,6 +1348,7 @@ err_out:
 	return rc;
 }
 
+#if 0
 static void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 {
 	void __iomem *regs = mvi->regs;
@@ -1364,6 +1368,7 @@ static void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 
 	port->taskfileset = MVS_ID_NOT_MAPPED;
 }
+#endif
 
 static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 {
@@ -2122,10 +2127,12 @@ static void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val)
 	mvs_write_port(mvi, MVS_P0_INT_STAT, MVS_P4_INT_STAT, port, val);
 }
 
+#if 0
 static u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port)
 {
 	return mvs_read_port(mvi, MVS_P0_INT_MASK, MVS_P4_INT_MASK, port);
 }
+#endif
 
 static void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val)
 {
@@ -2258,17 +2265,17 @@ static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
 	u32 tmp;
-	__le64 tmp64;
+	u64 tmp64;
 	struct pci_dev *pdev = mvi->pdev;
 
 	mvs_write_port_cfg_addr(mvi, i, PHYR_IDENTIFY);
 	phy->dev_info = mvs_read_port_cfg_data(mvi, i);
 
 	mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_HI);
-	phy->dev_sas_addr = (__le64) mvs_read_port_cfg_data(mvi, i) << 32;
+	phy->dev_sas_addr = (u64) mvs_read_port_cfg_data(mvi, i) << 32;
 
 	mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_LO);
-	phy->dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);	/* le */
+	phy->dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
 
 	phy->phy_status = mvs_read_phy_ctl(mvi, i);
 
@@ -2286,7 +2293,7 @@ static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
 
 		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
 		phy->att_dev_sas_addr =
-			(__le64) mvs_read_port_cfg_data(mvi, i) << 32;
+				(u64) mvs_read_port_cfg_data(mvi, i) << 32;
 
 		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
 		phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
-- 
1.5.4.rc4

> I really don't think you should be doing this.  That single ring governs
> all the potential tag slots for everything in this device.  If you do a
> simple head tail allocation, what can happen is that you get a slow tag
> (attached to a format command, or a tape command) and then the ring head
> will hit the slow tag and the entire device will halt.  I think you need
> a bitmap based allocation algorithm to ensure that if you have a free
> tag anywhere, you'll use it.
> 
> If you look at the aic94xx index functions in aic94xx_hwi.h you'll see
> asd_tc_index_get() and asd_tc_index_release() doing exactly what you
> want with the native linux bitmap functions (the aic also uses a single
> issue queue with indexes into it).

I don't think we need to make use of a bitmap based allocation algorithm.
My algorithm is a simple non-blocking scheduling. Some faster tag may
be free in advance, so ring will alloc a tag number which has been
stored in mvi->tags array instead of waiting to hit the slow tag. 

I think that the bitmap based allocation algorithm try to poll and find
the first zero bit. So process may be slow. 

pls point out anything wrong.

On Fri, Jan 25, 2008 at 04:39:29PM -0600, James Bottomley wrote:
> On Sat, 2008-01-26 at 00:43 +0800, Ke Wei wrote:
> 
> >  struct mvs_phy {
> >         struct mvs_port         *port;
> >         struct asd_sas_phy      sas_phy;
> > +       struct sas_identify identify;
> > +       __le32          dev_info;
> > +       __le64          dev_sas_addr;
> > +       __le32          att_dev_info;
> > +       __le64          att_dev_sas_addr;
> > +       u32             type;
> > +       __le32          phy_status;
> > +       __le32          irq_status;
> > +       u8              wide_port_phymap;
> > +       u32             frame_rcvd_size;
> > +       u8              frame_rcvd[32];
> >  
> > -       u8                      frame_rcvd[24 + 1024];
> >  };
> 
> These __le quantites don't look right ... they're all read in by readl,
> which will convert little endian to CPU anyway.
> 
> 
> > @@ -437,27 +586,55 @@ struct mvs_info {
> >         dma_addr_t              rx_dma;
> >         u32                     rx_cons;        /* RX consumer idx */
> >  
> > -       __le32                  *rx_fis;        /* RX'd FIS area */
> > +       void                    *rx_fis;        /* RX'd FIS area */
> 
> Now the received FIS, on the other hand, provided you're storing it in
> wire format (which you look to be) *is* little endian data by definition
> in the ATA spec.
> 
> 
> > -static void mvs_tag_clear(struct mvs_info *mvi, unsigned int tag)
> > +static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
> >  {
> > -       mvi->tags[tag / sizeof(unsigned long)] &=
> > -               ~(1UL << (tag % sizeof(unsigned long)));
> > +       mvi->tag_in = (mvi->tag_in + 1) & (MVS_SLOTS - 1);
> > +       mvi->tags[mvi->tag_in] = tag;
> >  }
> >  
> > -static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
> > +static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
> >  {
> > -       mvi->tags[tag / sizeof(unsigned long)] |=
> > -               (1UL << (tag % sizeof(unsigned long)));
> > +       mvi->tag_out = (mvi->tag_out - 1) & (MVS_SLOTS - 1);
> >  }
> >  
> > -static bool mvs_tag_test(struct mvs_info *mvi, unsigned int tag)
> > +static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
> >  {
> > -       return mvi->tags[tag / sizeof(unsigned long)] &
> > -               (1UL << (tag % sizeof(unsigned long)));
> > +       if (mvi->tag_out != mvi->tag_in) {
> > +               *tag_out = mvi->tags[mvi->tag_out];
> > +               mvi->tag_out = (mvi->tag_out + 1) & (MVS_SLOTS - 1);
> > +               return 0;
> > +       }
> > +       return -EBUSY;
> 
> I really don't think you should be doing this.  That single ring governs
> all the potential tag slots for everything in this device.  If you do a
> simple head tail allocation, what can happen is that you get a slow tag
> (attached to a format command, or a tape command) and then the ring head
> will hit the slow tag and the entire device will halt.  I think you need
> a bitmap based allocation algorithm to ensure that if you have a free
> tag anywhere, you'll use it.
> 
> If you look at the aic94xx index functions in aic94xx_hwi.h you'll see
> asd_tc_index_get() and asd_tc_index_release() doing exactly what you
> want with the native linux bitmap functions (the aic also uses a single
> issue queue with indexes into it).
> 
> James

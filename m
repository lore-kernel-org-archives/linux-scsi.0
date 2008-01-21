From: "Ke Wei" <kewei.mv@gmail.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver (draft)
Date: Mon, 21 Jan 2008 10:43:56 +0800
Message-ID: <6b2481670801201843o61baf0b7p78bfdbe20b5bb2ec@mail.gmail.com>
References: <6b2481670801092253v666e969doe5ec2bd77e10a87e@mail.gmail.com>
	 <1200682435.3111.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:19629 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbYAUCn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 21:43:56 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3405492wah.23
        for <linux-scsi@vger.kernel.org>; Sun, 20 Jan 2008 18:43:56 -0800 (PST)
In-Reply-To: <1200682435.3111.46.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, jeff@garzik.org, qzhao@marvell.com

Hello James:


       I read your comments.

> >       .target_alloc           = sas_target_alloc,
> >       .slave_configure        = sas_slave_configure,
> >       .slave_destroy          = sas_slave_destroy,
> >       .change_queue_depth     = sas_change_queue_depth,
> >       .change_queue_type      = sas_change_queue_type,
> >       .bios_param             = sas_bios_param,
> > -     .can_queue              = 1,
> > +     .can_queue              = 30,
>
> I don't think you want to do this.  It starts sending multiple commands
> at once.  The design use of libsas is to start off at 1 and then up the
> limit in slave configure once we know what type of device we're dealing
> with.  The current sas_slave_configure has a limitation in that the
> depth is hard coded to 32, so if you need it smaller, we'll have to find
> a way of allowing this?  Is 30 your max queue depth?

Yes , I may not do this. But I need to set
sas_ha_struct.lldd_queue_size to suitable value.
Because sas_queue sends multiple commands according to lldd_queue_size
before calling lldd_execute_task function which supports queue depth ,
30 is suitable.


> >       .cmd_per_lun            = 1,
> >       .this_id                = -1,
> > -     .sg_tablesize           = SG_ALL,
> > -     .max_sectors            = SCSI_DEFAULT_MAX_SECTORS,
> > -     .use_clustering         = ENABLE_CLUSTERING,
> > +     .sg_tablesize           = 32,
>
> 32 looks a little small.  My reading of the code is that the PRD table
> has to fit with the command header, OAF area and status area into an 8k
> segment of memory, so at 16 bytes per PRD entry, it looks like a page
> worth at least (256) isn't unreasonable.  You should probably have some
> type of macro for this though.
>
> > +     .max_sectors            = (128*1024)>>9,

Yes , It's demo code . And I need to test device to find a good value
according to performance and reliability.


> > +     .use_clustering         = DISABLE_CLUSTERING,
>
> I think this is wrong ... there should be no modern device that disables
> clustering (otherwise they fall over badly on iommu platforms).
>
> >       .eh_device_reset_handler= sas_eh_device_reset_handler,
> >       .eh_bus_reset_handler   = sas_eh_bus_reset_handler,
> > -     .slave_alloc            = sas_slave_alloc,
>
> Please don't remove this ... it's a standard callback, and it's required
> for the day you support SATA.

You are right. I forgot to recover these codes when I debuged.
And Driver has support for SATA devices . I will commit the patches in
this weeks.

Thank you for your help.

Ke Wei.

On Jan 19, 2008 2:53 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2008-01-10 at 14:53 +0800, Ke Wei wrote:
> > The 88SE6440 driver :
> >
> > The driver is based on bare code from Jeff Garzik. And it can work
> > under linux kernel 2.6.23.
> > By far, Can discover and find SAS HDD, but SATA is currently
> > unsupported. Command queue depth can be above 1.
> > Most error handling, and some phy handling code is notably missing.
> >
> >
> > contains the following updates:
> >
> > --- mvsas_orig.c      2007-12-06 19:21:32.000000000 -0500
> > +++ mvsas.c   2008-01-09 04:53:14.000000000 -0500
> [...]
> > +#define MVS_BIT(x)                         (1L << (x))
> > +
> > +#define PORT_TYPE_SATA                    MVS_BIT(0)
> > +#define PORT_TYPE_SAS                     MVS_BIT(1)
> > +
> > +#define READ_PORT_CONFIG_DATA(i) \
> > +     ((i>3)?mr32(P4_CFG_DATA+(i-4)*8):mr32(P0_CFG_DATA+i*8))
> > +#define WRITE_PORT_CONFIG_DATA(i,tmp) \
> > +     {if(i>3)mw32(P4_CFG_DATA+(i-4)*8,tmp);else mw32(P0_CFG_DATA+i*8,tmp);}
> > +#define WRITE_PORT_CONFIG_ADDR(i,tmp) \
> > +     {if(i>3)mw32(P4_CFG_ADDR+(i-4)*8,tmp);else mw32(P0_CFG_ADDR+i*8,tmp);}
> > +
> > +#define READ_PORT_PHY_CONTROL(i) \
> > +   ((i>3)?mr32(P4_SER_CTLSTAT+(i-4)*4):mr32(P0_SER_CTLSTAT+i*4))
> > +#define WRITE_PORT_PHY_CONTROL(i,tmp) \
> > +   {if(i>3)mw32(P4_SER_CTLSTAT+(i-4)*4,tmp);else
> > mw32(P0_SER_CTLSTAT+i*4,tmp);}
>
> This is an example of where you mailer has broken a line (which causes
> the patch not to apply).
>
>
> > +
> > +#define READ_PORT_VSR_DATA(i) \
> > +   ((i>3)?mr32(P4_VSR_DATA+(i-4)*8):mr32(P0_VSR_DATA+i*8))
> > +#define WRITE_PORT_VSR_DATA(i,tmp) \
> > +   {if(i>3)mw32(P4_VSR_DATA+(i-4)*8,tmp);else mw32(P0_VSR_DATA+i*8,tmp);}
> > +#define WRITE_PORT_VSR_ADDR(i,tmp) \
> > +   {if(i>3)mw32(P4_VSR_ADDR+(i-4)*8,tmp);else mw32(P0_VSR_ADDR+i*8,tmp);}
> > +
> > +#define READ_PORT_IRQ_STAT(i) \
> > +   ((i>3)?mr32(P4_INT_STAT+(i-4)*8):mr32(P0_INT_STAT+i*8))
> > +#define WRITE_PORT_IRQ_STAT(i,tmp) \
> > +   {if(i>3)mw32(P4_INT_STAT+(i-4)*8,tmp);else mw32(P0_INT_STAT+i*8,tmp);}
> > +#define READ_PORT_IRQ_MASK(i) \
> > +   ((i>3)?mr32(P4_INT_MASK+(i-4)*8):mr32(P0_INT_MASK+i*8))
> > +#define WRITE_PORT_IRQ_MASK(i,tmp) \
> > +   {if(i>3)mw32(P4_INT_MASK+(i-4)*8,tmp);else mw32(P0_INT_MASK+i*8,tmp);}
> > +
> >  /* driver compile-time configuration */
> >  enum driver_configuration {
> > -     MVS_TX_RING_SZ          = 1024, /* TX ring size (12-bit) */
> > +     MVS_TX_RING_SZ          = 512,  /* TX ring size (12-bit) */
> >       MVS_RX_RING_SZ          = 1024, /* RX ring size (12-bit) */
> >                                       /* software requires power-of-2
> >                                          ring size */
> > @@ -89,7 +125,7 @@
> >       MVS_GBL_CTL             = 0x04,  /* global control */
> >       MVS_GBL_INT_STAT        = 0x08,  /* global irq status */
> >       MVS_GBL_PI              = 0x0C,  /* ports implemented bitmask */
> > -     MVS_GBL_PORT_TYPE       = 0x00,  /* port type */
> > +     MVS_GBL_PORT_TYPE       = 0xa0,  /* port type */
> >
> >       MVS_CTL                 = 0x100, /* SAS/SATA port configuration */
> >       MVS_PCS                 = 0x104, /* SAS/SATA port control/status */
> > @@ -102,11 +138,12 @@
> >       MVS_TX_LO               = 0x124, /* TX (delivery) ring addr */
> >       MVS_TX_HI               = 0x128,
> >
> > -     MVS_RX_PROD_IDX         = 0x12C, /* RX producer pointer */
> > -     MVS_RX_CONS_IDX         = 0x130, /* RX consumer pointer (RO) */
> > +     MVS_TX_PROD_IDX         = 0x12C, /* TX producer pointer */
> > +     MVS_TX_CONS_IDX         = 0x130, /* TX consumer pointer (RO) */
> >       MVS_RX_CFG              = 0x134, /* RX configuration */
> >       MVS_RX_LO               = 0x138, /* RX (completion) ring addr */
> >       MVS_RX_HI               = 0x13C,
> > +     MVS_RX_CONS_IDX         = 0x140, /* RX consumer pointer (RO) */
> >
> >       MVS_INT_COAL            = 0x148, /* Int coalescing config */
> >       MVS_INT_COAL_TMOUT      = 0x14C, /* Int coalescing timeout */
> > @@ -117,9 +154,12 @@
> >                                        /* ports 1-3 follow after this */
> >       MVS_P0_INT_STAT         = 0x160, /* port0 interrupt status */
> >       MVS_P0_INT_MASK         = 0x164, /* port0 interrupt mask */
> > +     MVS_P4_INT_STAT         = 0x200, /* Port 4 interrupt status */
> > +     MVS_P4_INT_MASK         = 0x204, /* Port 4 interrupt enable/disable mask */
> >
> >                                        /* ports 1-3 follow after this */
> >       MVS_P0_SER_CTLSTAT      = 0x180, /* port0 serial control/status */
> > +     MVS_P4_SER_CTLSTAT      = 0x220, /* port4 serial control/status */
> >
> >       MVS_CMD_ADDR            = 0x1B8, /* Command register port (addr) */
> >       MVS_CMD_DATA            = 0x1BC, /* Command register port (data) */
> > @@ -127,6 +167,14 @@
> >                                        /* ports 1-3 follow after this */
> >       MVS_P0_CFG_ADDR         = 0x1C0, /* port0 phy register address */
> >       MVS_P0_CFG_DATA         = 0x1C4, /* port0 phy register data */
> > +     MVS_P4_CFG_ADDR         = 0x230, /* Port 4 config address */
> > +     MVS_P4_CFG_DATA         = 0x234, /* Port 4 config data */
> > +
> > +                                      /* ports 1-3 follow after this */
> > +     MVS_P0_VSR_ADDR         = 0x1E0, /* port0 vendor specific register address */
> > +     MVS_P0_VSR_DATA         = 0x1E4, /* port0 vendor specific register data */
> > +     MVS_P4_VSR_ADDR         = 0x250, /* port 4 Vendor Specific Register addr */
> > +     MVS_P4_VSR_DATA         = 0x254, /* port 4 Vendor Specific Register Data */
> >  };
> >
> >  enum hw_register_bits {
> > @@ -140,8 +188,31 @@
> >
> >       /* MVS_GBL_PORT_TYPE */                 /* shl for ports 1-3 */
> >       SATA_TARGET             = (1U << 16),   /* port0 SATA target enable */
> > -     AUTO_DET                = (1U << 8),    /* port0 SAS/SATA autodetect */
> > -     SAS_MODE                = (1U << 0),    /* port0 SAS(1), SATA(0) mode */
> > +     MODE_AUTO_DET_PORT7 = (1U << 15),       /* port0 SAS/SATA autodetect */
> > +     MODE_AUTO_DET_PORT6 = (1U << 14),
> > +     MODE_AUTO_DET_PORT5 = (1U << 13),
> > +     MODE_AUTO_DET_PORT4 = (1U << 12),
> > +     MODE_AUTO_DET_PORT3 = (1U << 11),
> > +     MODE_AUTO_DET_PORT2 = (1U << 10),
> > +     MODE_AUTO_DET_PORT1 = (1U << 9),
> > +     MODE_AUTO_DET_PORT0 = (1U << 8),
> > +     MODE_AUTO_DET_EN    = MODE_AUTO_DET_PORT0 | MODE_AUTO_DET_PORT1 |
> > +                           MODE_AUTO_DET_PORT2 | MODE_AUTO_DET_PORT3 |
> > +                           MODE_AUTO_DET_PORT4 | MODE_AUTO_DET_PORT5 |
> > +                           MODE_AUTO_DET_PORT6 | MODE_AUTO_DET_PORT7,
> > +     MODE_SAS_PORT7_MASK = (1U << 7),  /* port0 SAS(1), SATA(0) mode */
> > +     MODE_SAS_PORT6_MASK = (1U << 6),
> > +     MODE_SAS_PORT5_MASK = (1U << 5),
> > +     MODE_SAS_PORT4_MASK = (1U << 4),
> > +     MODE_SAS_PORT3_MASK = (1U << 3),
> > +     MODE_SAS_PORT2_MASK = (1U << 2),
> > +     MODE_SAS_PORT1_MASK = (1U << 1),
> > +     MODE_SAS_PORT0_MASK = (1U << 0),
> > +     MODE_SAS_SATA           =       MODE_SAS_PORT0_MASK | MODE_SAS_PORT1_MASK |
> > +                                                     MODE_SAS_PORT2_MASK | MODE_SAS_PORT3_MASK |
> > +                                                     MODE_SAS_PORT4_MASK | MODE_SAS_PORT5_MASK |
> > +                                                     MODE_SAS_PORT6_MASK | MODE_SAS_PORT7_MASK,
> > +
> >                                               /* SAS_MODE value may be
> >                                                * dictated (in hw) by values
> >                                                * of SATA_TARGET & AUTO_DET
> > @@ -167,12 +238,14 @@
> >       CINT_MEM                = (1U << 26),   /* int mem parity err */
> >       CINT_I2C_SLAVE          = (1U << 25),   /* slave I2C event */
> >       CINT_SRS                = (1U << 3),    /* SRS event */
> > -     CINT_CI_STOP            = (1U << 10),   /* cmd issue stopped */
> > +     CINT_CI_STOP            = (1U << 1),    /* cmd issue stopped */
> >       CINT_DONE               = (1U << 0),    /* cmd completion */
> >
> >                                               /* shl for ports 1-3 */
> >       CINT_PORT_STOPPED       = (1U << 16),   /* port0 stopped */
> > -     CINT_PORT               = (1U << 8),    /* port0 event */
> > +     CINT_PORT                       = (1U << 8),    /* port0 event */
> > +     CINT_PORT_MASK_OFFSET   = 8,
> > +     CINT_PORT_MASK          = (0xFF << CINT_PORT_MASK_OFFSET),
> >
> >       /* TX (delivery) ring bits */
> >       TXQ_CMD_SHIFT           = 29,
> > @@ -236,9 +309,14 @@
> >
> >       /* MVS_Px_SER_CTLSTAT (per-phy control) */
> >       PHY_SSP_RST             = (1U << 3),    /* reset SSP link layer */
> > -     PHY_BCAST_CHG           = (1U << 2),    /* broadcast(change) notif */
> > -     PHY_RST_HARD            = (1U << 1),    /* hard reset + phy reset */
> > +     PHY_BCAST_CHG   = (1U << 2),    /* broadcast(change) notif */
> > +     PHY_RST_HARD    = (1U << 1),    /* hard reset + phy reset */
> >       PHY_RST                 = (1U << 0),    /* phy reset */
> > +     PHY_MIN_SPP_PHYS_LINK_RATE_MASK = (0xF << 8),
> > +     PHY_MAX_SPP_PHYS_LINK_RATE_MASK = (0xF << 12),
> > +     PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET = 16,
> > +     PHY_NEG_SPP_PHYS_LINK_RATE_MASK = (0xF <<
> > PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET),
> > +     PHY_READY_MASK                                  = (1U << 20),
> >
> >       /* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
> >       PHYEV_UNASSOC_FIS       = (1U << 19),   /* unassociated FIS rx'd */
> > @@ -260,12 +338,14 @@
> >       PHYEV_RDY_CH            = (1U << 0),    /* phy ready changed state */
> >
> >       /* MVS_PCS */
> > +     PCS_EN_PORT_XMT_START   =  (12),                /*Enable Port Transmit*/
> > +     PCS_EN_PORT_XMT_START2  =  (8),                 /*For 6480*/
> >       PCS_SATA_RETRY          = (1U << 8),    /* retry ctl FIS on R_ERR */
> >       PCS_RSP_RX_EN           = (1U << 7),    /* raw response rx */
> >       PCS_SELF_CLEAR          = (1U << 5),    /* self-clearing int mode */
> >       PCS_FIS_RX_EN           = (1U << 4),    /* FIS rx enable */
> >       PCS_CMD_STOP_ERR        = (1U << 3),    /* cmd stop-on-err enable */
> > -     PCS_CMD_RST             = (1U << 2),    /* reset cmd issue */
> > +     PCS_CMD_RST             = (1U << 1),    /* reset cmd issue */
> >       PCS_CMD_EN              = (1U << 0),    /* enable cmd issue */
> >  };
> >
> > @@ -288,7 +368,7 @@
> >       CMD_SAS_CTL1            = 0x128, /* SAS control register 1 */
> >       CMD_SAS_CTL2            = 0x12c, /* SAS control register 2 */
> >       CMD_SAS_CTL3            = 0x130, /* SAS control register 3 */
> > -     CMD_ID_TEST             = 0x134, /* ID test register */
> > +     CMD_ID_TEST                     = 0x134, /* ID test register */
> >       CMD_PL_TIMER            = 0x138, /* PL timer register */
> >       CMD_WD_TIMER            = 0x13c, /* WD timer register */
> >       CMD_PORT_SEL_COUNT      = 0x140, /* port selector count register */
> > @@ -345,12 +425,15 @@
> >
> >  enum pci_cfg_registers {
> >       PCR_PHY_CTL             = 0x40,
> > -     PCR_PHY_CTL2            = 0x90,
> > +     PCR_PHY_CTL2    = 0x90,
> > +     PCR_DEV_CTRL    = 0xE8,
> >  };
> >
> >  enum pci_cfg_register_bits {
> >       PCTL_PWR_ON             = (0xFU << 24),
> >       PCTL_OFF                = (0xFU << 12),
> > +     PRD_REQ_SIZE    = (0x4000),
> > +     PRD_REQ_MASK    = (0x00007000),
> >  };
> >
> >  enum nvram_layout_offsets {
> > @@ -412,8 +495,20 @@
> >
> >  struct mvs_phy {
> >       struct mvs_port         *port;
> > -     struct asd_sas_phy      sas_phy;
> > -
> > +     struct asd_sas_phy      sas_phy;
> >
> > +     struct sas_identify identify;
> > +/* from PORT_CONFIG_ADDR0-3, PhyID/device protocol/sas_addr/SIG/wide_port */
> > +     __le32          DevInfo;
> > +     __le64          DevSASAddr;
> > +     __le32          AttDevInfo;
> > +     __le64          AttDevSASAddr;
> > +     u8                      Type;
> > +     u8                      WidePortPhyMap;
> > +     u8                      Reserved0[2];
> > +/* from PORT_PHY_CONTROL0-3, REG_PORT_PHY_CONTROL, linkrate, current status */
> > +     __le32          PhyStatus;
> > +/* from PORT_IRQ_MASK0-3 */
> > +     __le32          IRQStatus;
> >       u8                      frame_rcvd[24 + 1024];
> >  };
> >
> > @@ -447,10 +542,19 @@
> >
> >                                       /* further per-slot information */
> >       struct mvs_slot_info    slot_info[MVS_SLOTS];
> > -     unsigned long           tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
> > -
> > +     unsigned long           tags[MVS_SLOTS];
> >       struct mvs_phy          phy[MVS_MAX_PHYS];
> >       struct mvs_port         port[MVS_MAX_PHYS];
> > +
> > +     u32                                     can_queue;      /* per adapter */
> > +     u32                                     tag_out;        /*Get*/
> > +     u32                                     tag_in;         /*Give*/
> > +};
> > +
> > +struct mvs_queue_task {
> > +     struct list_head list;
> > +
> > +     void   *uldd_task;
> >  };
> >
> >  static struct scsi_transport_template *mvs_stt;
> > @@ -464,27 +568,128 @@
> >  static struct scsi_host_template mvs_sht = {
> >       .module                 = THIS_MODULE,
> >       .name                   = DRV_NAME,
> > -     .queuecommand           = sas_queuecommand,
> > +     .queuecommand           = sas_queuecommand,
>
> This change is just adding whitespace at the end, which is unnecessary.
> If you run your patch through scripts/checkpatch.pl in the linux kernel
> directory, it will pick up things like this.
>
> >       .target_alloc           = sas_target_alloc,
> >       .slave_configure        = sas_slave_configure,
> >       .slave_destroy          = sas_slave_destroy,
> >       .change_queue_depth     = sas_change_queue_depth,
> >       .change_queue_type      = sas_change_queue_type,
> >       .bios_param             = sas_bios_param,
> > -     .can_queue              = 1,
> > +     .can_queue              = 30,
>
> I don't think you want to do this.  It starts sending multiple commands
> at once.  The design use of libsas is to start off at 1 and then up the
> limit in slave configure once we know what type of device we're dealing
> with.  The current sas_slave_configure has a limitation in that the
> depth is hard coded to 32, so if you need it smaller, we'll have to find
> a way of allowing this?  Is 30 your max queue depth?
>
> >       .cmd_per_lun            = 1,
> >       .this_id                = -1,
> > -     .sg_tablesize           = SG_ALL,
> > -     .max_sectors            = SCSI_DEFAULT_MAX_SECTORS,
> > -     .use_clustering         = ENABLE_CLUSTERING,
> > +     .sg_tablesize           = 32,
>
> 32 looks a little small.  My reading of the code is that the PRD table
> has to fit with the command header, OAF area and status area into an 8k
> segment of memory, so at 16 bytes per PRD entry, it looks like a page
> worth at least (256) isn't unreasonable.  You should probably have some
> type of macro for this though.
>
> > +     .max_sectors            = (128*1024)>>9,
>
> I didn't see any sector length limitations on the transfers in this
> driver ... is 256 really the max number of sectors per command?
>
> > +     .use_clustering         = DISABLE_CLUSTERING,
>
> I think this is wrong ... there should be no modern device that disables
> clustering (otherwise they fall over badly on iommu platforms).
>
> >       .eh_device_reset_handler= sas_eh_device_reset_handler,
> >       .eh_bus_reset_handler   = sas_eh_bus_reset_handler,
> > -     .slave_alloc            = sas_slave_alloc,
>
> Please don't remove this ... it's a standard callback, and it's required
> for the day you support SATA.
>
>
> I'll look more into the rest later.
>
> Thanks,
>
> James
>
>
>

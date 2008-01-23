From: "Ke Wei" <kewei.mv@gmail.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Wed, 23 Jan 2008 18:54:42 +0800
Message-ID: <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com>
References: <20080122151857.GA8680@ubuntu.domain>
	 <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
	 <4796BB5A.9090003@garzik.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_30970_22761752.1201085682796"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:1133 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYAWKyq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 05:54:46 -0500
Received: by wa-out-1112.google.com with SMTP id v27so4981948wah.23
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 02:54:43 -0800 (PST)
In-Reply-To: <4796BB5A.9090003@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com

------=_Part_30970_22761752.1201085682796
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Attachment is a patch file for 6440 driver. I will have to spend more
time on setting my mail client. Yesterday I used mutt tool. But Look
like the problem still exists.
I fixed all issues which you mentioned , but

> > @@ -666,11 +970,53 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned
> > int addr,
> >  err_out:
> >        dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
> >        return rc;
> > +#else
> > +       memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
> > +       return 0;
> > +#endif
>
>
> what happens if two adapters are used, with the same SAS address?  That
> causes problems...
>
>
Our bios can write SAS Address per port when system boot , so I think
we don't need read or configure address.

And I reserved hexdump funciton if you don't care. Only debugging.

> > +static int mvs_abort_task(struct sas_task *task)
> > +{
> > +       /*FIXME*/
> > +       MVS_PRINTK("mvs abort task\n");
> > +       return TMF_RESP_FUNC_COMPLETE;
> > +}
>
> should make an attempt to do something sane here
>
if entering this abort function , I think I must fix the unknown
issues instead of here.  But I also will implement next.

On Jan 23, 2008 11:58 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Comments inline, mostly minor stuff cleaning up the source.
>
> Major problem though:  your mailer converted tabs to spaces, so our
> automated patch tools won't work on your submission.  It usually takes a
> few attempts to get your email setup working, such that all the
> automated tools used in the Linux community work.
>
>
> Ke Wei wrote:
> > +#define MVS_QUEUE_SIZE (30)
>
> to be consistent with the rest of the driver, make this an enum
>
>
> > +#define MVS_PRINTK(_x_, ...) \
> > +       printk(KERN_NOTICE DRV_NAME ": " _x_ , ## __VA_ARGS__)
> >
> >  #define mr32(reg)      readl(regs + MVS_##reg)
> >  #define mw32(reg,val)  writel((val), regs + MVS_##reg)
> > @@ -47,6 +53,65 @@
> >        readl(regs + MVS_##reg);                \
> >        } while (0)
> >
> > +#define MVS_BIT(x)             (1L << (x))
> > +
> > +#define PORT_TYPE_SATA         MVS_BIT(0)
> > +#define PORT_TYPE_SAS          MVS_BIT(1)
>
> to be consistent with the rest of the driver, just open-code "1 << n".
> This also makes it easier to get the C type correct.
>
>
>
> > +#define MVS_ID_NOT_MAPPED      0xff
> > +#define MVS_CHIP_SLOT_SZ       (1U << mvi->chip->slot_width)
> > +
> > +/* offset for D2H FIS in the Received FIS List Structure */
> > +#define SATA_RECEIVED_D2H_FIS(reg_set) \
> > +       (mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
> > +#define SATA_RECEIVED_PIO_FIS(reg_set) \
> > +       (mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
> > +#define UNASSOC_D2H_FIS(id) \
> > +       (mvi->rx_fis + 0x100 * id)
> > +
> > +
> > +#define READ_PORT_CONFIG_DATA(i) \
> > +       ((i > 3)?mr32(P4_CFG_DATA + (i - 4) * 8):mr32(P0_CFG_DATA + i * 8))
> > +#define WRITE_PORT_CONFIG_DATA(i,tmp) \
> > +       {if (i > 3)mw32(P4_CFG_DATA + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_CFG_DATA + i * 8, tmp); }
> > +#define WRITE_PORT_CONFIG_ADDR(i,tmp) \
> > +       {if (i > 3)mw32(P4_CFG_ADDR + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_CFG_ADDR + i * 8, tmp); }
> > +
> > +#define READ_PORT_PHY_CONTROL(i) \
> > +       ((i > 3)?mr32(P4_SER_CTLSTAT + (i - 4) * 4):mr32(P0_SER_CTLSTAT+i * 4))
> > +#define WRITE_PORT_PHY_CONTROL(i,tmp) \
> > +       {if (i > 3)mw32(P4_SER_CTLSTAT + (i - 4) * 4, tmp); \
> > +       else \
> > +               mw32(P0_SER_CTLSTAT + i * 4, tmp); }
> > +
> > +#define READ_PORT_VSR_DATA(i) \
> > +       ((i > 3)?mr32(P4_VSR_DATA + (i - 4) * 8):mr32(P0_VSR_DATA+i*8))
> > +#define WRITE_PORT_VSR_DATA(i,tmp) \
> > +       {if (i > 3)mw32(P4_VSR_DATA + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_VSR_DATA + i*8, tmp); }
> > +#define WRITE_PORT_VSR_ADDR(i,tmp) \
> > +       {if (i > 3)mw32(P4_VSR_ADDR + (i - 4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_VSR_ADDR + i * 8, tmp); }
> > +
> > +#define READ_PORT_IRQ_STAT(i) \
> > +       ((i > 3)?mr32(P4_INT_STAT + (i - 4) * 8):mr32(P0_INT_STAT + i * 8))
> > +#define WRITE_PORT_IRQ_STAT(i,tmp) \
> > +       {if (i > 3)mw32(P4_INT_STAT + (i-4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_INT_STAT + i * 8, tmp); }
> > +#define READ_PORT_IRQ_MASK(i) \
> > +       ((i > 3)?mr32(P4_INT_MASK + (i-4) * 8):mr32(P0_INT_MASK+i*8))
> > +#define WRITE_PORT_IRQ_MASK(i,tmp) \
> > +       {if (i > 3)mw32(P4_INT_MASK + (i-4) * 8, tmp); \
> > +       else \
> > +               mw32(P0_INT_MASK + i * 8, tmp); }
>
>
> make these macros readable, by breaking each C statement into a separate
> line
>
>
>
>
> > @@ -260,13 +368,33 @@ enum hw_register_bits {
> >        PHYEV_RDY_CH            = (1U << 0),    /* phy ready changed state */
> >
> >        /* MVS_PCS */
> > +       PCS_EN_SATA_REG         = (16),         /* Enable SATA Register Set*/
> > +       PCS_EN_PORT_XMT_START   = (12),         /* Enable Port Transmit*/
> > +       PCS_EN_PORT_XMT_START2  = (8),          /* For 6480*/
> >        PCS_SATA_RETRY          = (1U << 8),    /* retry ctl FIS on R_ERR */
> >        PCS_RSP_RX_EN           = (1U << 7),    /* raw response rx */
> >        PCS_SELF_CLEAR          = (1U << 5),    /* self-clearing int mode */
> >        PCS_FIS_RX_EN           = (1U << 4),    /* FIS rx enable */
> >        PCS_CMD_STOP_ERR        = (1U << 3),    /* cmd stop-on-err enable */
> > -       PCS_CMD_RST             = (1U << 2),    /* reset cmd issue */
> > +       PCS_CMD_RST             = (1U << 1),    /* reset cmd issue */
> >        PCS_CMD_EN              = (1U << 0),    /* enable cmd issue */
> > +
> > +       /*Port n Attached Device Info*/
> > +       PORT_DEV_SSP_TRGT       = (1U << 19),
> > +       PORT_DEV_SMP_TRGT       = (1U << 18),
> > +       PORT_DEV_STP_TRGT       = (1U << 17),
> > +       PORT_DEV_SSP_INIT       = (1U << 11),
> > +       PORT_DEV_SMP_INIT       = (1U << 10),
> > +       PORT_DEV_STP_INIT       = (1U << 9),
> > +       PORT_PHY_ID_MASK        = (0xFFU << 24),
> > +       PORT_DEV_TRGT_MASK      = (0x7U << 17),
> > +       PORT_DEV_INIT_MASK      = (0x7U << 9),
> > +       PORT_DEV_TYPE_MASK      = (0x7U << 0),
> > +
> > +       /*Port n PHY Status*/
> > +       PHY_RDY                 = (1U << 2),
> > +       PHY_DW_SYNC             = (1U << 1),
> > +       PHY_OOB_DTCTD           = (1U << 0),
>
> to be consistent, add spaces after /* and before */
>
>
> >
> >  struct mvs_port {
> >        struct asd_sas_port     sas_port;
> > +       u8                      taskfileset;
> >  };
> >
> >  struct mvs_phy {
> >        struct mvs_port         *port;
> >        struct asd_sas_phy      sas_phy;
> > +       struct sas_identify identify;
> > +       __le32          devinfo;
> > +       __le64          devsasaddr;
> > +       __le32          attdevinfo;
> > +       __le64          attdevsasaddr;
> > +       u32             type;
> > +       __le32          phystatus;
> > +       __le32          irqstatus;
> > +       u8              wideportphymap;
> > +       u32             frame_rcvd_size;
> > +       u8              frame_rcvd[32];
>
> following linux style (and style used in my original driver), consider
> adding some '_' underscores, to separate out words.
>
> dev_info
> phy_stat
> irq_stat
> etc.
>
> also, following the style in this driver, please add comments describing
> what the fields do
>
>
>
> > -       u8                      frame_rcvd[24 + 1024];
> >  };
> >
> >  struct mvs_info {
> > @@ -437,27 +585,39 @@ struct mvs_info {
> >        dma_addr_t              rx_dma;
> >        u32                     rx_cons;        /* RX consumer idx */
> >
> > -       __le32                  *rx_fis;        /* RX'd FIS area */
> > +       void                    *rx_fis;        /* RX'd FIS area */
> >        dma_addr_t              rx_fis_dma;
> >
> > -       struct mvs_cmd_hdr      *slot;          /* DMA command header slots */
> > +       struct mvs_cmd_hdr      *slot;  /* DMA command header slots */
> >        dma_addr_t              slot_dma;
> >
> >        const struct mvs_chip_info *chip;
> >
> > -                                       /* further per-slot information */
> > +       unsigned long           tags[MVS_SLOTS];
> >        struct mvs_slot_info    slot_info[MVS_SLOTS];
> > -       unsigned long           tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
> > -
> > +                               /* further per-slot information */
> >        struct mvs_phy          phy[MVS_MAX_PHYS];
> >        struct mvs_port         port[MVS_MAX_PHYS];
> > +
> > +       u32                     can_queue;      /* per adapter */
> > +       u32                     tag_out;        /*Get*/
> > +       u32                     tag_in;         /*Give*/
> > +};
> > +
> > +struct mvs_queue_task {
> > +       struct list_head list;
> > +
> > +       void   *uldd_task;
> >  };
> >
> > +static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
> > +static void mvs_scan_start(struct Scsi_Host *);
> > +
> >  static struct scsi_transport_template *mvs_stt;
> >
> >  static const struct mvs_chip_info mvs_chips[] = {
> > -       [chip_6320] =           { 2, 16, 9 },
> > -       [chip_6440] =           { 4, 16, 9 },
> > +       [chip_6320] =           { 2, 16, 9  },
> > +       [chip_6440] =           { 4, 16, 9  },
> >        [chip_6480] =           { 8, 32, 10 },
> >  };
> >
> > @@ -468,6 +628,8 @@ static struct scsi_host_template mvs_sht = {
> >        .target_alloc           = sas_target_alloc,
> >        .slave_configure        = sas_slave_configure,
> >        .slave_destroy          = sas_slave_destroy,
> > +       .scan_finished          = mvs_scan_finished,
> > +       .scan_start             = mvs_scan_start,
> >        .change_queue_depth     = sas_change_queue_depth,
> >        .change_queue_type      = sas_change_queue_type,
> >        .bios_param             = sas_bios_param,
> > @@ -477,14 +639,154 @@ static struct scsi_host_template mvs_sht = {
> >        .sg_tablesize           = SG_ALL,
> >        .max_sectors            = SCSI_DEFAULT_MAX_SECTORS,
> >        .use_clustering         = ENABLE_CLUSTERING,
> > -       .eh_device_reset_handler= sas_eh_device_reset_handler,
> > +       .eh_device_reset_handler        = sas_eh_device_reset_handler,
> >        .eh_bus_reset_handler   = sas_eh_bus_reset_handler,
> >        .slave_alloc            = sas_slave_alloc,
> >        .target_destroy         = sas_target_destroy,
> >        .ioctl                  = sas_ioctl,
> >  };
> >
> > -static void mvs_int_rx(struct mvs_info *mvi, bool self_clear);
> > +static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
> > +{
> > +       u32 i;
> > +       u32 run;
> > +       u32 offset;
> > +
> > +       offset = 0;
> > +       while (size) {
> > +               printk("%08X : ", baseaddr + offset);
> > +               if (size >= 16)
> > +                       run = 16;
> > +               else
> > +                       run = size;
> > +               size -= run;
> > +               for (i = 0; i < 16; i++) {
> > +                       if (i < run)
> > +                               printk("%02X ", (unsigned int)data[i]);
> > +                       else
> > +                               printk("   ");
> > +               }
> > +               printk(": ");
> > +               for (i = 0; i < run; i++)
> > +                       printk("%c", isalnum(data[i]) ? data[i] : '.');
> > +               printk("\n");
> > +               data = &data[16];
> > +               offset += run;
> > +       }
> > +       printk("\n");
> > +}
>
> lib/hexdump.c should already provide most of this functionality?
>
>
> > @@ -666,11 +970,53 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned
> > int addr,
> >  err_out:
> >        dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
> >        return rc;
> > +#else
> > +       memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
> > +       return 0;
> > +#endif
>
>
> what happens if two adapters are used, with the same SAS address?  That
> causes problems...
>
>
>
> >  static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
> >  {
> > -       /* FIXME */
> > +       void __iomem *regs = mvi->regs;
> > +       /*
> > +               events is port event.now ,
> > +               we need check the interrupt status which belongs to per port.
> > +       */
> > +       MVS_PRINTK("Port0 = %d", READ_PORT_IRQ_STAT(0));
> >  }
> >
> >  static void mvs_int_sata(struct mvs_info *mvi)
> > @@ -681,9 +1027,10 @@ static void mvs_int_sata(struct mvs_info *mvi)
> >  static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
> >                          struct mvs_slot_info *slot, unsigned int slot_idx)
> >  {
> > -       if (slot->n_elem)
> > -               pci_unmap_sg(mvi->pdev, task->scatter,
> > -                            slot->n_elem, task->data_dir);
> > +       if (!sas_protocol_ata(task->task_proto))
> > +               if (slot->n_elem)
> > +                       pci_unmap_sg(mvi->pdev, task->scatter,
> > +                                    slot->n_elem, task->data_dir);
> >
> >        switch (task->task_proto) {
> >        case SAS_PROTO_SMP:
> > @@ -708,9 +1055,34 @@ static void mvs_slot_err(struct mvs_info *mvi, struct
> > sas_task *task,
> >                         unsigned int slot_idx)
> >  {
> >        /* FIXME */
> > +       mvs_hba_sb_dump(mvi, slot_idx, task->task_proto);
> >  }
> >
> > -static void mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
> > +static inline int mvs_can_queue(struct mvs_info *mvi, int num)
> > +{
> > +       int res = 0;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&mvi->lock, flags);
> > +       if ((mvi->can_queue - num) < 0)
> > +               res = -EBUSY;
> > +       else
> > +               mvi->can_queue -= num;
> > +       spin_unlock_irqrestore(&mvi->lock, flags);
> > +
> > +       return res;
> > +}
> > +
> > +static inline void mvs_can_dequeue(struct mvs_info *mvi, int num)
> > +{
> > +       /*unsigned long flags;*/
> > +
> > +       /*spin_lock_irqsave(&mvi->lock, flags);*/
> > +       mvi->can_queue += num;
> > +       /*spin_unlock_irqrestore(&mvi->lock, flags);*/
>
> these functions are dead code and can be removed, AFAICS
>
>
>
> > @@ -816,32 +1201,45 @@ static void mvs_int_rx(struct mvs_info *mvi, bool
> > self_clear)
> >         * we don't have to stall the CPU reading that register.
> >         * The actual RX ring is offset by one dword, due to this.
> >         */
> > -       rx_prod_idx = le32_to_cpu(mvi->rx[0]) & 0xfff;
> > +       rx_prod_idx = le32_to_cpu(mr32(RX_CONS_IDX)) & RX_RING_SZ_MASK;
>
> This appears to add a new bug...  the le32_to_cpu() is not longer
> needed, once you started using mr32() macro
>
> The PCI MMIO read/write functions handle that for you (since PCI is
> defined to be a little endian bus).
>
>
> > @@ -978,9 +1458,8 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
> >         */
> >        memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
> >
> > -       /* region 1: command table area (MVS_ATA_CMD_SZ bytes) ***************/
> > -       buf_cmd =
> > -       buf_tmp = slot->buf;
> > +       /* region 1: command table area (MVS_ATA_CMD_SZ bytes) ************** */
> > +       buf_cmd = buf_tmp = slot->buf;
> >        buf_tmp_dma = slot->buf_dma;
> >
> >        hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
> > @@ -988,7 +1467,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
> >        buf_tmp += MVS_ATA_CMD_SZ;
> >        buf_tmp_dma += MVS_ATA_CMD_SZ;
> >
> > -       /* region 2: open address frame area (MVS_OAF_SZ bytes) **********/
> > +       /* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
> >        /* used for STP.  unused for SATA? */
> >        buf_oaf = buf_tmp;
> >        hdr->open_frame = cpu_to_le64(buf_tmp_dma);
>
> > @@ -996,32 +1475,37 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
> >        buf_tmp += MVS_OAF_SZ;
> >        buf_tmp_dma += MVS_OAF_SZ;
> >
> > -       /* region 3: PRD table ***********************************************/
> > +       /* region 3: PRD table ********************************************** */
>
>
> adding this space before "*/" is strange
>
>
>
> >        /* fill in command FIS and ATAPI CDB */
> > -       memcpy(buf_cmd, &task->ata_task.fis,
> > -              sizeof(struct host_to_dev_fis));
> > -       memcpy(buf_cmd + 0x40, task->ata_task.atapi_packet, 16);
> > +       task->ata_task.fis.flags |= 0x80;
> > +       memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
> > +       if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
> > +               memcpy(buf_cmd + 0x40, task->ata_task.atapi_packet, 16);
>
> prefer that you use named constants rather than 0x40 and 0x80
>
> We call such numeric constants "magic numbers", because open source
> reviewers are not given any hint as to what that number represents, its
> purpose, its meaning.
>
>
>
> > -       /* region 4: status buffer (larger the PRD, smaller this buf) ********/
> > +       /* region 4: status buffer (larger the PRD, smaller this buf) ******* */
> >        slot->response = buf_tmp;
> >        hdr->status_buf = cpu_to_le64(buf_tmp_dma);
> >
> > -       req_len = sizeof(struct ssp_frame_hdr) + 28;
> >        resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_OAF_SZ -
> > -                  sizeof(struct mvs_err_info) - i;
> > +           sizeof(struct mvs_err_info) - i;
> > +       resp_len = min(resp_len, (u32) 0x400);
> > +
> > +       req_len = sizeof(struct ssp_frame_hdr) + 28;
>
> same comment here -- use a numeric constant rather than 0x400
>
>
>
> > @@ -1131,12 +1620,11 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
> >        buf_cmd += sizeof(*ssp_hdr);
> >        memcpy(buf_cmd, &task->ssp_task.LUN, 8);
> >        buf_cmd[9] = fburst |
> > -               task->ssp_task.task_attr |
> > -               (task->ssp_task.task_prio << 3);
> > +           task->ssp_task.task_attr | (task->ssp_task.task_prio << 3);
> >        memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
> > -
> > -       /* fill in PRD (scatter/gather) table, if any */
> > -       sg = task->scatter;
> > +       /*CDB*/
> > +           /* fill in PRD (scatter/gather) table, if any */
> > +           sg = task->scatter;
>
> strange C code indentation (but maybe that's just the patch
> tabs-to-spaces corruption mentioned at the top of this email)
>
>
> >        for (i = 0; i < tei->n_elem; i++) {
> >                buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
> >                buf_prd->len = cpu_to_le32(sg_dma_len(sg));
> > @@ -1155,72 +1643,106 @@ static int mvs_task_exec(struct sas_task *task, const
> > int num, gfp_t gfp_flags)
> >        void __iomem *regs = mvi->regs;
> >        unsigned long flags;
> >        struct mvs_task_exec_info tei;
> > +       struct sas_task *t = task;
> > +       u32 n = num, pass = 0;
> > +
> > +       mvs_hba_interrupt_enable(mvi, 0);
>
>
> this is most likely a bug, or remnant of another driver.
>
> should not not need to disable and then re-enable the HBA interrupt on
> every task_exec call.
>
> if it's an interrupt mitigation strategy, it needs a large comment block
> somewhere, describing what's going on.
>
>
>
> > +       do {
> > +               if (!sas_protocol_ata(t->task_proto)) {
> > +                       if (t->num_scatter) {
> > +                               n_elem = pci_map_sg(mvi->pdev, t->scatter,
> > +                                                   t->num_scatter,
> > +                                                   t->data_dir);
> > +                               if (!n_elem) {
> > +                                       rc = -ENOMEM;
> > +                                       goto err_out;
> > +                               }
> > +                       }
> > +               } else {
> > +                       n_elem = t->num_scatter;
> > +               }
> >
> > -       /* FIXME: STP/SATA support not complete yet */
> > -       if (task->task_proto == SATA_PROTO || task->task_proto == SAS_PROTO_STP)
> > -               return -SAS_DEV_NO_RESPONSE;
> > +               rc = mvs_tag_alloc(mvi, &tag);
> > +               if (rc)
> > +                       goto err_out;
> >
> > -       if (task->num_scatter) {
> > -               n_elem = pci_map_sg(mvi->pdev, task->scatter,
> > -                                   task->num_scatter, task->data_dir);
> > -               if (!n_elem)
> > -                       return -ENOMEM;
> > -       }
> > +               mvi->slot_info[tag].task = t;
> > +               mvi->slot_info[tag].n_elem = n_elem;
> > +               tei.task = t;
> > +               tei.hdr = &mvi->slot[tag];
> > +               tei.tag = tag;
> > +               tei.n_elem = n_elem;
> >
> > -       spin_lock_irqsave(&mvi->lock, flags);
> > +               switch (t->task_proto) {
> > +               case SAS_PROTO_SMP:
> > +                       rc = mvs_task_prep_smp(mvi, &tei);
> > +                       break;
> > +               case SAS_PROTO_SSP:
> > +                       rc = mvs_task_prep_ssp(mvi, &tei);
> > +                       break;
> > +               case SATA_PROTO:
> > +               case SAS_PROTO_STP:
> > +                       rc = mvs_task_prep_ata(mvi, &tei);
> > +                       break;
> > +               default:
> > +                       rc = -EINVAL;
> > +                       break;
> > +               }
> >
> > -       rc = mvs_tag_alloc(mvi, &tag);
> > -       if (rc)
> > -               goto err_out;
> > +               if (rc)
> > +                       goto err_out_tag;
> >
> > -       mvi->slot_info[tag].task = task;
> > -       mvi->slot_info[tag].n_elem = n_elem;
> > -       tei.task = task;
> > -       tei.hdr = &mvi->slot[tag];
> > -       tei.tag = tag;
> > -       tei.n_elem = n_elem;
> > +               /* TODO: select normal or high priority */
> >
> > -       switch (task->task_proto) {
> > -       case SAS_PROTO_SMP:
> > -               rc = mvs_task_prep_smp(mvi, &tei);
> > -               break;
> > -       case SAS_PROTO_SSP:
> > -               rc = mvs_task_prep_ssp(mvi, &tei);
> > -               break;
> > -       case SATA_PROTO:
> > -       case SAS_PROTO_STP:
> > -               rc = mvs_task_prep_ata(mvi, &tei);
> > -               break;
> > -       default:
> > -               rc = -EINVAL;
> > -               break;
> > -       }
> > -
> > -       if (rc)
> > -               goto err_out_tag;
> > +               spin_lock_irqsave(&t->task_state_lock, flags);
> > +               t->task_state_flags |= SAS_TASK_AT_INITIATOR;
> > +               spin_unlock_irqrestore(&t->task_state_lock, flags);
> >
> > -       /* TODO: select normal or high priority */
> > +               if (n == 1) {
> > +                       mvs_hba_interrupt_enable(mvi, 1);
> > +                       mw32(TX_PROD_IDX, mvi->tx_prod);
> > +               }
> > +               /*
>
> ditto.  this is highly irregular (enabling/disabling HBA interrupt for
> each task exec -- lotsa of overhead for questionable gain)
>
>
>
> > +static int mvs_abort_task(struct sas_task *task)
> > +{
> > +       /*FIXME*/
> > +       MVS_PRINTK("mvs abort task\n");
> > +       return TMF_RESP_FUNC_COMPLETE;
> > +}
>
> should make an attempt to do something sane here
>
>
> > @@ -1249,10 +1771,12 @@ static void mvs_free(struct mvs_info *mvi)
> >                                  mvi->rx, mvi->rx_dma);
> >        if (mvi->slot)
> >                dma_free_coherent(&mvi->pdev->dev,
> > -                                 sizeof(*mvi->slot) * MVS_RX_RING_SZ,
> > +                                 sizeof(*mvi->slot) * MVS_SLOTS,
> >                                  mvi->slot, mvi->slot_dma);
> > +#if 0
> >        if (mvi->peri_regs)
> >                iounmap(mvi->peri_regs);
> > +#endif
> >        if (mvi->regs)
> >                iounmap(mvi->regs);
> >        if (mvi->shost)
>
> maybe change this #if, and related #ifs, to
>
>        #ifdef MVS_ENABLE_PERI
>
>
> ?
>
>
> > @@ -1274,25 +1798,25 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy,
> > enum phy_func func,
> >        reg = mvi->regs + MVS_P0_SER_CTLSTAT + (phy_id * 4);
> >
> >        switch (func) {
> > -       case PHY_FUNC_SET_LINK_RATE: {
> > -               struct sas_phy_linkrates *rates = funcdata;
> > -               u32 lrmin = 0, lrmax = 0;
> > +       case PHY_FUNC_SET_LINK_RATE:{
> > +                       struct sas_phy_linkrates *rates = funcdata;
> > +                       u32 lrmin = 0, lrmax = 0;
> >
> > -               lrmin = (rates->minimum_linkrate << 8);
> > -               lrmax = (rates->maximum_linkrate << 12);
> > +                       lrmin = (rates->minimum_linkrate << 8);
> > +                       lrmax = (rates->maximum_linkrate << 12);
> >
> > -               tmp = readl(reg);
> > -               if (lrmin) {
> > -                       tmp &= ~(0xf << 8);
> > -                       tmp |= lrmin;
> > -               }
> > -               if (lrmax) {
> > -                       tmp &= ~(0xf << 12);
> > -                       tmp |= lrmax;
> > +                       tmp = readl(reg);
> > +                       if (lrmin) {
> > +                               tmp &= ~(0xf << 8);
> > +                               tmp |= lrmin;
> > +                       }
> > +                       if (lrmax) {
> > +                               tmp &= ~(0xf << 12);
> > +                               tmp |= lrmax;
> > +                       }
> > +                       writel(tmp, reg);
> > +                       break;
>
> the C code indentation appears wrong (but again, maybe that's the email
> problem)
>
>
> > @@ -1381,9 +1905,10 @@ static struct mvs_info * __devinit mvs_alloc(struct
> > pci_dev *pdev,
> >
> >        SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
> >        mvi->shost->transportt = mvs_stt;
> > -       mvi->shost->max_id = ~0;
> > -       mvi->shost->max_lun = ~0;
> > -       mvi->shost->max_cmd_len = ~0;
> > +       mvi->shost->max_id = 21;
> > +       mvi->shost->max_lun = 2;
> > +       mvi->shost->max_channel = 0;
> > +       mvi->shost->max_cmd_len = 16;
>
> max_lun of 2?  that seems quite incorrect.  your hardware does not have
> that limit, AFAICS.
>
>
>
> > @@ -1476,13 +2008,13 @@ err_out:
> >        return NULL;
> >  }
> >
> > -static u32 mvs_cr32(void __iomem *regs, u32 addr)
> > +static inline u32 mvs_cr32(void __iomem *regs, u32 addr)
> >  {
> >        mw32(CMD_ADDR, addr);
> >        return mr32(CMD_DATA);
> >  }
> >
> > -static void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
> > +static inline void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
> >  {
> >        mw32(CMD_ADDR, addr);
> >        mw32(CMD_DATA, val);
>
> there is no need for explicit inlining here.  if its useful to inline,
> let the compiler make that decision.
>
> it's marked 'static', which is sufficient to enable the compiler to do
> module-scoped optimizations.
>
>
> > @@ -1547,6 +2079,174 @@ static void __devinit mvs_phy_hacks(struct mvs_info
> > *mvi)
> >        tmp &= 0x1fffffff;
> >        tmp |= (2U << 29);      /* 8 ms retry */
> >        mvs_cw32(regs, CMD_PHY_TIMER, tmp);
> > +
> > +       /* TEST - for phy decoding error, adjust voltage levels */
> > +       mw32(P0_VSR_ADDR + 0, 0x8);
> > +       mw32(P0_VSR_DATA + 0, 0x2F0);
> > +
> > +       mw32(P0_VSR_ADDR + 8, 0x8);
> > +       mw32(P0_VSR_DATA + 8, 0x2F0);
> > +
> > +       mw32(P0_VSR_ADDR + 16, 0x8);
> > +       mw32(P0_VSR_DATA + 16, 0x2F0);
> > +
> > +       mw32(P0_VSR_ADDR + 24, 0x8);
> > +       mw32(P0_VSR_DATA + 24, 0x2F0);
> > +
> > +}
>
> is this test code needed in the submitted driver?
>
>
>
> > +               /* workaround for HW phy decoding error on 1.5g disk drive */
> > +               WRITE_PORT_VSR_ADDR(i, 0x06);
> > +               tmp = READ_PORT_VSR_DATA(i);
> > +               if (((phy->phystatus & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
> > +                    PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
> > +                       SAS_LINK_RATE_1_5_GBPS)
> > +                       tmp &= ~0x20000000;
> > +               else
> > +                       tmp |= 0x20000000;
> > +               WRITE_PORT_VSR_DATA(i, tmp);
> > +
> > +       }
> > +       phy->irqstatus = READ_PORT_IRQ_STAT(i);
>
> replace 0x20000000 with a named constant
>
>
>
> >  static int __devinit mvs_hw_init(struct mvs_info *mvi)
> > @@ -1559,6 +2259,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
> >        mw32(GBL_CTL, 0);
> >        tmp = mr32(GBL_CTL);
> >
> > +       /*ResetController */
>
>
>        /* reset controller */
>
> it's not a function, and whitespace makes things more readable :)
>
>
> > @@ -1590,13 +2290,24 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
> >                return -EBUSY;
> >        }
> >
> > +       /*InitChip */
>
> ditto
>
>
>
> >        /* make sure RST is set; HBA_RST /should/ have done that for us */
> > -       cctl = mr32(CTL);
> > +       cctl = mr32(CTL);       /*MVS_CTL */
> >        if (cctl & CCTL_RST)
> >                cctl &= ~CCTL_RST;
> >        else
> >                mw32_f(CTL, cctl | CCTL_RST);
> >
> > +       pci_read_config_dword(mvi->pdev, PCI_COMMAND, &tmp);
> > +       /*MV_PCI_DEV_EN */
> > +       tmp |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
> > +       pci_write_config_dword(mvi->pdev, PCI_COMMAND, tmp);
>
> are you sure this wasn't just copied from another driver?
>
> pci_enable_device() turns on PCI_COMMAND_IO and PCI_COMMAND_MEMORY, and
> pci_set_master() turns on PCI_COMMAND_MASTER.
>
> In general, you should not need to twiddle PCI_COMMAND register this
> way, it has already been done for you.
>
>
> > @@ -1609,6 +2320,9 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
> >
> >        mw32_f(CTL, cctl);
> >
> > +       /* reset control */
> > +       mw32(PCS, 0);           /*MVS_PCS */
> > +
> >        mvs_phy_hacks(mvi);
> >
>
> request improved comment :)  or simply delete, if it is redundant to
> "reset control" comment
>
>
>
> Overall:  no major complaints or objections, only minor stuff.  After
> fixing all the minor stuff, the main issue is getting your email set up
> correctly to send patches.
>
>        Jeff
>
>
>
>
>



-- 
Best Regards,
Ke Wei

------=_Part_30970_22761752.1201085682796
Content-Type: text/plain; name=mvsas.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fbrr4k8s0
Content-Disposition: attachment; filename=mvsas.patch

U2lnbmVkLW9mZi1ieTogS2UgV2VpIDxrZXdlaUBtYXJ2ZWxsLmNvbT4KLS0tCiBkcml2ZXJzL3Nj
c2kvbXZzYXMuYyB8ICAzMDQgKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0KIDEgZmlsZXMgY2hhbmdlZCwgMTU5IGluc2VydGlvbnMoKyksIDE0NSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbXZzYXMuYyBiL2RyaXZlcnMvc2Nz
aS9tdnNhcy5jCmluZGV4IGZiMzc2YTcuLjA2MzdhMmIgMTAwNzU1Ci0tLSBhL2RyaXZlcnMvc2Nz
aS9tdnNhcy5jCisrKyBiL2RyaXZlcnMvc2NzaS9tdnNhcy5jCkBAIC00Miw3ICs0Miw3IEBACiAj
ZGVmaW5lIERSVl9WRVJTSU9OCSIwLjMiCiAjZGVmaW5lIF9NVl9EVU1QIDAKICNkZWZpbmUgTVZT
X0RJU0FCTEVfTlZSQU0KLSNkZWZpbmUgTVZTX1FVRVVFX1NJWkUgKDMwKQorCiAjZGVmaW5lIE1W
U19QUklOVEsoX3hfLCAuLi4pIFwKIAlwcmludGsoS0VSTl9OT1RJQ0UgRFJWX05BTUUgIjogIiBf
eF8gLCAjIyBfX1ZBX0FSR1NfXykKIApAQCAtNTMsMTEgKzUzLDYgQEAKIAlyZWFkbChyZWdzICsg
TVZTXyMjcmVnKTsJCVwKIAl9IHdoaWxlICgwKQogCi0jZGVmaW5lIE1WU19CSVQoeCkJCSgxTCA8
PCAoeCkpCi0KLSNkZWZpbmUgUE9SVF9UWVBFX1NBVEEJCU1WU19CSVQoMCkKLSNkZWZpbmUgUE9S
VF9UWVBFX1NBUwkJTVZTX0JJVCgxKQotCiAjZGVmaW5lIE1WU19JRF9OT1RfTUFQUEVECTB4ZmYK
ICNkZWZpbmUgTVZTX0NISVBfU0xPVF9TWgkoMVUgPDwgbXZpLT5jaGlwLT5zbG90X3dpZHRoKQog
CkBAIC03Miw0NSArNjcsNTkgQEAKIAogI2RlZmluZSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSkg
XAogCSgoaSA+IDMpP21yMzIoUDRfQ0ZHX0RBVEEgKyAoaSAtIDQpICogOCk6bXIzMihQMF9DRkdf
REFUQSArIGkgKiA4KSkKLSNkZWZpbmUgV1JJVEVfUE9SVF9DT05GSUdfREFUQShpLHRtcCkgXAot
CXtpZiAoaSA+IDMpbXczMihQNF9DRkdfREFUQSArIChpIC0gNCkgKiA4LCB0bXApOyBcCisjZGVm
aW5lIFdSSVRFX1BPUlRfQ09ORklHX0RBVEEoaSx0bXApIHsgXAorCWlmIChpID4gMykgXAorCQlt
dzMyKFA0X0NGR19EQVRBICsgKGkgLSA0KSAqIDgsIHRtcCk7IFwKIAllbHNlIFwKLQkJbXczMihQ
MF9DRkdfREFUQSArIGkgKiA4LCB0bXApOyB9Ci0jZGVmaW5lIFdSSVRFX1BPUlRfQ09ORklHX0FE
RFIoaSx0bXApIFwKLQl7aWYgKGkgPiAzKW13MzIoUDRfQ0ZHX0FERFIgKyAoaSAtIDQpICogOCwg
dG1wKTsgXAorCQltdzMyKFAwX0NGR19EQVRBICsgaSAqIDgsIHRtcCk7IFwKKwl9CisjZGVmaW5l
IFdSSVRFX1BPUlRfQ09ORklHX0FERFIoaSx0bXApIHsgXAorCWlmIChpID4gMykgXAorCQltdzMy
KFA0X0NGR19BRERSICsgKGkgLSA0KSAqIDgsIHRtcCk7IFwKIAllbHNlIFwKLQkJbXczMihQMF9D
RkdfQUREUiArIGkgKiA4LCB0bXApOyB9CisJCW13MzIoUDBfQ0ZHX0FERFIgKyBpICogOCwgdG1w
KTsgXAorCX0KIAogI2RlZmluZSBSRUFEX1BPUlRfUEhZX0NPTlRST0woaSkgXAogCSgoaSA+IDMp
P21yMzIoUDRfU0VSX0NUTFNUQVQgKyAoaSAtIDQpICogNCk6bXIzMihQMF9TRVJfQ1RMU1RBVCtp
ICogNCkpCi0jZGVmaW5lIFdSSVRFX1BPUlRfUEhZX0NPTlRST0woaSx0bXApIFwKLQl7aWYgKGkg
PiAzKW13MzIoUDRfU0VSX0NUTFNUQVQgKyAoaSAtIDQpICogNCwgdG1wKTsgXAorI2RlZmluZSBX
UklURV9QT1JUX1BIWV9DT05UUk9MKGksdG1wKSB7IFwKKwlpZiAoaSA+IDMpIFwKKwkJbXczMihQ
NF9TRVJfQ1RMU1RBVCArIChpIC0gNCkgKiA0LCB0bXApOyBcCiAJZWxzZSBcCi0JCW13MzIoUDBf
U0VSX0NUTFNUQVQgKyBpICogNCwgdG1wKTsgfQorCQltdzMyKFAwX1NFUl9DVExTVEFUICsgaSAq
IDQsIHRtcCk7IFwKKwl9CiAKICNkZWZpbmUgUkVBRF9QT1JUX1ZTUl9EQVRBKGkpIFwKIAkoKGkg
PiAzKT9tcjMyKFA0X1ZTUl9EQVRBICsgKGkgLSA0KSAqIDgpOm1yMzIoUDBfVlNSX0RBVEEraSo4
KSkKLSNkZWZpbmUgV1JJVEVfUE9SVF9WU1JfREFUQShpLHRtcCkgXAotCXtpZiAoaSA+IDMpbXcz
MihQNF9WU1JfREFUQSArIChpIC0gNCkgKiA4LCB0bXApOyBcCisjZGVmaW5lIFdSSVRFX1BPUlRf
VlNSX0RBVEEoaSx0bXApIHsgXAorCWlmIChpID4gMykgXAorCQltdzMyKFA0X1ZTUl9EQVRBICsg
KGkgLSA0KSAqIDgsIHRtcCk7IFwKIAllbHNlIFwKLQkJbXczMihQMF9WU1JfREFUQSArIGkqOCwg
dG1wKTsgfQotI2RlZmluZSBXUklURV9QT1JUX1ZTUl9BRERSKGksdG1wKSBcCi0Je2lmIChpID4g
MyltdzMyKFA0X1ZTUl9BRERSICsgKGkgLSA0KSAqIDgsIHRtcCk7IFwKKwkJbXczMihQMF9WU1Jf
REFUQSArIGkqOCwgdG1wKTsgXAorCX0KKyNkZWZpbmUgV1JJVEVfUE9SVF9WU1JfQUREUihpLHRt
cCkgeyBcCisJaWYgKGkgPiAzKSBcCisJCW13MzIoUDRfVlNSX0FERFIgKyAoaSAtIDQpICogOCwg
dG1wKTsgXAogCWVsc2UgXAotCQltdzMyKFAwX1ZTUl9BRERSICsgaSAqIDgsIHRtcCk7IH0KKwkJ
bXczMihQMF9WU1JfQUREUiArIGkgKiA4LCB0bXApOyBcCisJfQogCiAjZGVmaW5lIFJFQURfUE9S
VF9JUlFfU1RBVChpKSBcCiAJKChpID4gMyk/bXIzMihQNF9JTlRfU1RBVCArIChpIC0gNCkgKiA4
KTptcjMyKFAwX0lOVF9TVEFUICsgaSAqIDgpKQotI2RlZmluZSBXUklURV9QT1JUX0lSUV9TVEFU
KGksdG1wKSBcCi0Je2lmIChpID4gMyltdzMyKFA0X0lOVF9TVEFUICsgKGktNCkgKiA4LCB0bXAp
OyBcCisjZGVmaW5lIFdSSVRFX1BPUlRfSVJRX1NUQVQoaSx0bXApIHsgXAorCWlmIChpID4gMykg
XAorCQltdzMyKFA0X0lOVF9TVEFUICsgKGktNCkgKiA4LCB0bXApOyBcCiAJZWxzZSBcCi0JCW13
MzIoUDBfSU5UX1NUQVQgKyBpICogOCwgdG1wKTsgfQorCQltdzMyKFAwX0lOVF9TVEFUICsgaSAq
IDgsIHRtcCk7IFwKKwl9CiAjZGVmaW5lIFJFQURfUE9SVF9JUlFfTUFTSyhpKSBcCiAJKChpID4g
Myk/bXIzMihQNF9JTlRfTUFTSyArIChpLTQpICogOCk6bXIzMihQMF9JTlRfTUFTSytpKjgpKQot
I2RlZmluZSBXUklURV9QT1JUX0lSUV9NQVNLKGksdG1wKSBcCi0Je2lmIChpID4gMyltdzMyKFA0
X0lOVF9NQVNLICsgKGktNCkgKiA4LCB0bXApOyBcCisjZGVmaW5lIFdSSVRFX1BPUlRfSVJRX01B
U0soaSx0bXApIHsgXAorCWlmIChpID4gMykgXAorCQltdzMyKFA0X0lOVF9NQVNLICsgKGktNCkg
KiA4LCB0bXApOyBcCiAJZWxzZSBcCi0JCW13MzIoUDBfSU5UX01BU0sgKyBpICogOCwgdG1wKTsg
fQorCQltdzMyKFAwX0lOVF9NQVNLICsgaSAqIDgsIHRtcCk7IFwKKwl9CiAKIC8qIGRyaXZlciBj
b21waWxlLXRpbWUgY29uZmlndXJhdGlvbiAqLwogZW51bSBkcml2ZXJfY29uZmlndXJhdGlvbiB7
CkBAIC0xMjYsNiArMTM1LDggQEAgZW51bSBkcml2ZXJfY29uZmlndXJhdGlvbiB7CiAJTVZTX09B
Rl9TWgkJPSA2NCwJLyogT3BlbiBhZGRyZXNzIGZyYW1lIGJ1ZmZlciBzaXplICovCiAKIAlNVlNf
UlhfRklTX0NPVU5UCT0gMTcsCS8qIE9wdGlvbmFsIHJ4J2QgRklTcyAobWF4IDE3KSAqLworCisJ
TVZTX1FVRVVFX1NJWkUJCT0gMzAsCS8qIFN1cHBvcnQgUXVldWUgZGVwdGggKi8KIH07CiAKIC8q
IHVuY2hhbmdlYWJsZSBoYXJkd2FyZSBkZXRhaWxzICovCkBAIC0zNjgsOSArMzc5LDkgQEAgZW51
bSBod19yZWdpc3Rlcl9iaXRzIHsKIAlQSFlFVl9SRFlfQ0gJCT0gKDFVIDw8IDApLAkvKiBwaHkg
cmVhZHkgY2hhbmdlZCBzdGF0ZSAqLwogCiAJLyogTVZTX1BDUyAqLwotCVBDU19FTl9TQVRBX1JF
RwkJPSAoMTYpLAkJLyogRW5hYmxlIFNBVEEgUmVnaXN0ZXIgU2V0Ki8KLQlQQ1NfRU5fUE9SVF9Y
TVRfU1RBUlQJPSAoMTIpLAkJLyogRW5hYmxlIFBvcnQgVHJhbnNtaXQqLwotCVBDU19FTl9QT1JU
X1hNVF9TVEFSVDIJPSAoOCksCQkvKiBGb3IgNjQ4MCovCisJUENTX0VOX1NBVEFfUkVHCQk9ICgx
NiksCQkvKiBFbmFibGUgU0FUQSBSZWdpc3RlciBTZXQgKi8KKwlQQ1NfRU5fUE9SVF9YTVRfU1RB
UlQJPSAoMTIpLAkJLyogRW5hYmxlIFBvcnQgVHJhbnNtaXQgKi8KKwlQQ1NfRU5fUE9SVF9YTVRf
U1RBUlQyCT0gKDgpLAkJLyogRm9yIDY0ODAgKi8KIAlQQ1NfU0FUQV9SRVRSWQkJPSAoMVUgPDwg
OCksCS8qIHJldHJ5IGN0bCBGSVMgb24gUl9FUlIgKi8KIAlQQ1NfUlNQX1JYX0VOCQk9ICgxVSA8
PCA3KSwJLyogcmF3IHJlc3BvbnNlIHJ4ICovCiAJUENTX1NFTEZfQ0xFQVIJCT0gKDFVIDw8IDUp
LAkvKiBzZWxmLWNsZWFyaW5nIGludCBtb2RlICovCkBAIC0zNzksNyArMzkwLDcgQEAgZW51bSBo
d19yZWdpc3Rlcl9iaXRzIHsKIAlQQ1NfQ01EX1JTVAkJPSAoMVUgPDwgMSksCS8qIHJlc2V0IGNt
ZCBpc3N1ZSAqLwogCVBDU19DTURfRU4JCT0gKDFVIDw8IDApLAkvKiBlbmFibGUgY21kIGlzc3Vl
ICovCiAKLQkvKlBvcnQgbiBBdHRhY2hlZCBEZXZpY2UgSW5mbyovCisJLyogUG9ydCBuIEF0dGFj
aGVkIERldmljZSBJbmZvICovCiAJUE9SVF9ERVZfU1NQX1RSR1QJPSAoMVUgPDwgMTkpLAogCVBP
UlRfREVWX1NNUF9UUkdUCT0gKDFVIDw8IDE4KSwKIAlQT1JUX0RFVl9TVFBfVFJHVAk9ICgxVSA8
PCAxNyksCkBAIC0zOTEsMTAgKzQwMiwxNCBAQCBlbnVtIGh3X3JlZ2lzdGVyX2JpdHMgewogCVBP
UlRfREVWX0lOSVRfTUFTSwk9ICgweDdVIDw8IDkpLAogCVBPUlRfREVWX1RZUEVfTUFTSwk9ICgw
eDdVIDw8IDApLAogCi0JLypQb3J0IG4gUEhZIFN0YXR1cyovCisJLyogUG9ydCBuIFBIWSBTdGF0
dXMgKi8KIAlQSFlfUkRZCQkJPSAoMVUgPDwgMiksCiAJUEhZX0RXX1NZTkMJCT0gKDFVIDw8IDEp
LAogCVBIWV9PT0JfRFRDVEQJCT0gKDFVIDw8IDApLAorCisJLyogVlNSICovCisJLyogUEhZTU9E
RSA2IChDREIpICovCisJUEhZX01PREU2X0RUTF9TUEVFRAk9ICgxVSA8PCAyNyksCiB9OwogCiBl
bnVtIG12c19pbmZvX2ZsYWdzIHsKQEAgLTQ3Nyw2ICs0OTIsMjQgQEAgZW51bSBzYXNfc2F0YV9j
b25maWdfcG9ydF9yZWdzIHsKIAlQSFlSX0NVUlJFTlQyCQk9IDB4ODgsCS8qIGN1cnJlbnQgY29u
bmVjdGlvbiBpbmZvIDIgKi8KIH07CiAKKy8qICBTQVMvU0FUQSBWZW5kb3IgU3BlY2lmaWMgUG9y
dCBSZWdpc3RlcnMgKi8KK2VudW0gc2FzX3NhdGFfdnNwX3JlZ3MgeworCVZTUl9QSFlfU1RBVAkJ
PSAweDAwLCAvKiBQaHkgU3RhdHVzICovCisJVlNSX1BIWV9NT0RFMQkJPSAweDAxLCAvKiBwaHkg
dHggKi8KKwlWU1JfUEhZX01PREUyCQk9IDB4MDIsIC8qIHR4IHNjYyAqLworCVZTUl9QSFlfTU9E
RTMJCT0gMHgwMywgLyogcGxsICovCisJVlNSX1BIWV9NT0RFNAkJPSAweDA0LCAvKiBWQ08gKi8K
KwlWU1JfUEhZX01PREU1CQk9IDB4MDUsIC8qIFJ4ICovCisJVlNSX1BIWV9NT0RFNgkJPSAweDA2
LCAvKiBDRFIgKi8KKwlWU1JfUEhZX01PREU3CQk9IDB4MDcsIC8qIEltcGVkYW5jZSAqLworCVZT
Ul9QSFlfTU9ERTgJCT0gMHgwOCwgLyogVm9sdGFnZSAqLworCVZTUl9QSFlfTU9ERTkJCT0gMHgw
OSwgLyogVGVzdCAqLworCVZTUl9QSFlfTU9ERTEwCQk9IDB4MEEsIC8qIFBvd2VyICovCisJVlNS
X1BIWV9NT0RFMTEJCT0gMHgwQiwgLyogUGh5IE1vZGUgKi8KKwlWU1JfUEhZX1ZTMAkJPSAweDBD
LCAvKiBWZWRub3IgU3BlY2lmaWMgMCAqLworCVZTUl9QSFlfVlMxCQk9IDB4MEQsIC8qIFZlZG5v
ciBTcGVjaWZpYyAxICovCit9OworCiBlbnVtIHBjaV9jZmdfcmVnaXN0ZXJzIHsKIAlQQ1JfUEhZ
X0NUTAk9IDB4NDAsCiAJUENSX1BIWV9DVEwyCT0gMHg5MCwKQEAgLTUwMSw2ICs1MzQsMzQgQEAg
ZW51bSBjaGlwX2ZsYXZvcnMgewogCWNoaXBfNjQ4MCwKIH07CiAKK2VudW0gcG9ydF90eXBlIHsK
KwlQT1JUX1RZUEVfU0FTCT0gICgxTCA8PCAxKSwKKwlQT1JUX1RZUEVfU0FUQQk9ICAoMUwgPDwg
MCksCit9OworCisvKiBDb21tYW5kIFRhYmxlIEZvcm1hdCAqLworZW51bSBjdF9mb3JtYXQgewor
CS8qIFNTUCAqLworCVNTUF9GX0gJCT0gIDB4MDAsCisJU1NQX0ZfSVUJPSAgMHgxOCwKKwlTU1Bf
Rl9NQVgJPSAgMHg0RCwKKwkvKiBTVFAgKi8KKwlTVFBfQ01EX0ZJUwk9ICAweDAwLAorCVNUUF9B
VEFQSV9DTUQJPSAgMHg0MCwKKwlTVFBfRl9NQVgJPSAgMHgxMCwKKwkvKiBTTVAgKi8KKwlTTVBf
Rl9UCQk9ICAweDAwLAorCVNNUF9GX0RFUAk9ICAweDAxLAorCVNNUF9GX01BWAk9ICAweDEwMSwK
K307CisKK2VudW0gc3RhdHVzX2J1ZmZlciB7CisJU0JfRUlSX09GRgk9ICAweDAwLAkvKiBFcnJv
ciBJbmZvcm1hdGlvbiBSZWNvcmQgKi8KKwlTQl9SRkJfT0ZGCT0gIDB4MDgsCS8qIFJlc3BvbnNl
IEZyYW1lIEJ1ZmZlciAqLworCVNCX1JGQl9NQVgJPSAgMHg0MDAsCS8qIFJGQiBzaXplKi8KK307
CisKKwogc3RydWN0IG12c19jaGlwX2luZm8gewogCXUzMgkJbl9waHk7CiAJdTMyCQlzcnNfc3o7
CkBAIC01NTIsMTQgKzYxMywxNCBAQCBzdHJ1Y3QgbXZzX3BoeSB7CiAJc3RydWN0IG12c19wb3J0
CQkqcG9ydDsKIAlzdHJ1Y3QgYXNkX3Nhc19waHkJc2FzX3BoeTsKIAlzdHJ1Y3Qgc2FzX2lkZW50
aWZ5IGlkZW50aWZ5OwotCV9fbGUzMgkJZGV2aW5mbzsKLQlfX2xlNjQJCWRldnNhc2FkZHI7Ci0J
X19sZTMyCQlhdHRkZXZpbmZvOwotCV9fbGU2NAkJYXR0ZGV2c2FzYWRkcjsKKwlfX2xlMzIJCWRl
dl9pbmZvOworCV9fbGU2NAkJZGV2X3Nhc19hZGRyOworCV9fbGUzMgkJYXR0X2Rldl9pbmZvOwor
CV9fbGU2NAkJYXR0X2Rldl9zYXNfYWRkcjsKIAl1MzIJCXR5cGU7Ci0JX19sZTMyCQlwaHlzdGF0
dXM7Ci0JX19sZTMyCQlpcnFzdGF0dXM7Ci0JdTgJCXdpZGVwb3J0cGh5bWFwOworCV9fbGUzMgkJ
cGh5X3N0YXR1czsKKwlfX2xlMzIJCWlycV9zdGF0dXM7CisJdTgJCXdpZGVfcG9ydF9waHltYXA7
CiAJdTMyCQlmcmFtZV9yY3ZkX3NpemU7CiAJdTgJCWZyYW1lX3JjdmRbMzJdOwogCkBAIC02NzYs
NyArNzM3LDcgQEAgc3RhdGljIHZvaWQgbXZzX2hleGR1bXAodTMyIHNpemUsIHU4ICpkYXRhLCB1
MzIgYmFzZWFkZHIpCiAJcHJpbnRrKCJcbiIpOwogfQogCi1zdGF0aWMgaW5saW5lIHZvaWQgbXZz
X2hiYV9zYl9kdW1wKHN0cnVjdCBtdnNfaW5mbyAqbXZpLCB1MzIgdGFnLAorc3RhdGljIHZvaWQg
bXZzX2hiYV9zYl9kdW1wKHN0cnVjdCBtdnNfaW5mbyAqbXZpLCB1MzIgdGFnLAogCQkJCSAgIGVu
dW0gc2FzX3Byb3RvIHByb3RvKQogewogCXUzMiBvZmZzZXQ7CkBAIC04MjEsMTggKzg4MiwxOCBA
QCBzdGF0aWMgaW50IHBjaV9nb182NChzdHJ1Y3QgcGNpX2RldiAqcGRldikKIAlyZXR1cm4gcmM7
CiB9CiAKLXN0YXRpYyBpbmxpbmUgdm9pZCBtdnNfdGFnX2NsZWFyKHN0cnVjdCBtdnNfaW5mbyAq
bXZpLCB1MzIgdGFnKQorc3RhdGljIHZvaWQgbXZzX3RhZ19jbGVhcihzdHJ1Y3QgbXZzX2luZm8g
Km12aSwgdTMyIHRhZykKIHsKIAltdmktPnRhZ19pbiA9IChtdmktPnRhZ19pbiArIDEpICYgKE1W
U19TTE9UUyAtIDEpOwogCW12aS0+dGFnc1ttdmktPnRhZ19pbl0gPSB0YWc7CiB9CiAKLXN0YXRp
YyBpbmxpbmUgdm9pZCBtdnNfdGFnX2ZyZWUoc3RydWN0IG12c19pbmZvICptdmksIHUzMiB0YWcp
CitzdGF0aWMgdm9pZCBtdnNfdGFnX2ZyZWUoc3RydWN0IG12c19pbmZvICptdmksIHUzMiB0YWcp
CiB7CiAJbXZpLT50YWdfb3V0ID0gKG12aS0+dGFnX291dCAtIDEpICYgKE1WU19TTE9UUyAtIDEp
OwogfQogCi1zdGF0aWMgaW5saW5lIGludCBtdnNfdGFnX2FsbG9jKHN0cnVjdCBtdnNfaW5mbyAq
bXZpLCB1MzIgKnRhZ19vdXQpCitzdGF0aWMgaW50IG12c190YWdfYWxsb2Moc3RydWN0IG12c19p
bmZvICptdmksIHUzMiAqdGFnX291dCkKIHsKIAlpZiAobXZpLT50YWdfb3V0ICE9IG12aS0+dGFn
X2luKSB7CiAJCSp0YWdfb3V0ID0gbXZpLT50YWdzW212aS0+dGFnX291dF07CkBAIC05NzEsNyAr
MTAzMiw2IEBAIGVycl9vdXQ6CiAJZGV2X3ByaW50ayhLRVJOX0VSUiwgJm12aS0+cGRldi0+ZGV2
LCAiJXMiLCBtc2cpOwogCXJldHVybiByYzsKICNlbHNlCi0JbWVtY3B5KGJ1ZiwgIlx4NTBceDA1
XHgwNFx4MzBceDExXHhhYlx4MDBceDAwIiwgOCk7CiAJcmV0dXJuIDA7CiAjZW5kaWYKIH0KQEAg
LTEwNTgsMzAgKzExMTgsNiBAQCBzdGF0aWMgdm9pZCBtdnNfc2xvdF9lcnIoc3RydWN0IG12c19p
bmZvICptdmksIHN0cnVjdCBzYXNfdGFzayAqdGFzaywKIAltdnNfaGJhX3NiX2R1bXAobXZpLCBz
bG90X2lkeCwgdGFzay0+dGFza19wcm90byk7CiB9CiAKLXN0YXRpYyBpbmxpbmUgaW50IG12c19j
YW5fcXVldWUoc3RydWN0IG12c19pbmZvICptdmksIGludCBudW0pCi17Ci0JaW50IHJlcyA9IDA7
Ci0JdW5zaWduZWQgbG9uZyBmbGFnczsKLQotCXNwaW5fbG9ja19pcnFzYXZlKCZtdmktPmxvY2ss
IGZsYWdzKTsKLQlpZiAoKG12aS0+Y2FuX3F1ZXVlIC0gbnVtKSA8IDApCi0JCXJlcyA9IC1FQlVT
WTsKLQllbHNlCi0JCW12aS0+Y2FuX3F1ZXVlIC09IG51bTsKLQlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZtdmktPmxvY2ssIGZsYWdzKTsKLQotCXJldHVybiByZXM7Ci19Ci0KLXN0YXRpYyBpbmxp
bmUgdm9pZCBtdnNfY2FuX2RlcXVldWUoc3RydWN0IG12c19pbmZvICptdmksIGludCBudW0pCi17
Ci0JLyp1bnNpZ25lZCBsb25nIGZsYWdzOyovCi0KLQkvKnNwaW5fbG9ja19pcnFzYXZlKCZtdmkt
PmxvY2ssIGZsYWdzKTsqLwotCW12aS0+Y2FuX3F1ZXVlICs9IG51bTsKLQkvKnNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoJm12aS0+bG9jaywgZmxhZ3MpOyovCi19Ci0KIHN0YXRpYyBpbnQgbXZzX3Ns
b3RfY29tcGxldGUoc3RydWN0IG12c19pbmZvICptdmksIHUzMiByeF9kZXNjKQogewogCXVuc2ln
bmVkIGludCBzbG90X2lkeCA9IHJ4X2Rlc2MgJiBSWFFfU0xPVF9NQVNLOwpAQCAtMTIwMSw3ICsx
MjM3LDcgQEAgc3RhdGljIGludCBtdnNfaW50X3J4KHN0cnVjdCBtdnNfaW5mbyAqbXZpLCBib29s
IHNlbGZfY2xlYXIpCiAJICogd2UgZG9uJ3QgaGF2ZSB0byBzdGFsbCB0aGUgQ1BVIHJlYWRpbmcg
dGhhdCByZWdpc3Rlci4KIAkgKiBUaGUgYWN0dWFsIFJYIHJpbmcgaXMgb2Zmc2V0IGJ5IG9uZSBk
d29yZCwgZHVlIHRvIHRoaXMuCiAJICovCi0JcnhfcHJvZF9pZHggPSBsZTMyX3RvX2NwdShtcjMy
KFJYX0NPTlNfSURYKSkgJiBSWF9SSU5HX1NaX01BU0s7CisJcnhfcHJvZF9pZHggPSBtcjMyKFJY
X0NPTlNfSURYKSAmIFJYX1JJTkdfU1pfTUFTSzsKIAlpZiAocnhfcHJvZF9pZHggPT0gMHhmZmYp
IHsJLyogaC93IGhhc24ndCB0b3VjaGVkIFJYIHJpbmcgeWV0ICovCiAJCW12aS0+cnhfY29ucyA9
IDB4ZmZmOwogCQlyZXR1cm4gMDsKQEAgLTEzNDQsNyArMTM4MCw3IEBAIGVycl9vdXQ6CiAJcmV0
dXJuIHJjOwogfQogCi1zdGF0aWMgaW5saW5lIHZvaWQgbXZzX2ZyZWVfcmVnX3NldChzdHJ1Y3Qg
bXZzX2luZm8gKm12aSwgc3RydWN0IG12c19wb3J0ICpwb3J0KQorc3RhdGljIHZvaWQgbXZzX2Zy
ZWVfcmVnX3NldChzdHJ1Y3QgbXZzX2luZm8gKm12aSwgc3RydWN0IG12c19wb3J0ICpwb3J0KQog
ewogCXZvaWQgX19pb21lbSAqcmVncyA9IG12aS0+cmVnczsKIAl1MzIgdG1wLCBvZmZzOwpAQCAt
MTM2NCw3ICsxNDAwLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIG12c19mcmVlX3JlZ19zZXQoc3Ry
dWN0IG12c19pbmZvICptdmksIHN0cnVjdCBtdnNfcG9ydCAqcG9ydCkKIAlwb3J0LT50YXNrZmls
ZXNldCA9IE1WU19JRF9OT1RfTUFQUEVEOwogfQogCi1zdGF0aWMgaW5saW5lIHU4IG12c19hc3Np
Z25fcmVnX3NldChzdHJ1Y3QgbXZzX2luZm8gKm12aSwgc3RydWN0IG12c19wb3J0ICpwb3J0KQor
c3RhdGljIHU4IG12c19hc3NpZ25fcmVnX3NldChzdHJ1Y3QgbXZzX2luZm8gKm12aSwgc3RydWN0
IG12c19wb3J0ICpwb3J0KQogewogCWludCBpOwogCXUzMiB0bXAsIG9mZnM7CkBAIC0xMzkyLDcg
KzE0MjgsNyBAQCBzdGF0aWMgaW5saW5lIHU4IG12c19hc3NpZ25fcmVnX3NldChzdHJ1Y3QgbXZz
X2luZm8gKm12aSwgc3RydWN0IG12c19wb3J0ICpwb3J0KQogCXJldHVybiBNVlNfSURfTk9UX01B
UFBFRDsKIH0KIAotc3RhdGljIGlubGluZSB1MzIgbXZzX2dldF9uY3FfdGFnKHN0cnVjdCBzYXNf
dGFzayAqdGFzaykKK3N0YXRpYyB1MzIgbXZzX2dldF9uY3FfdGFnKHN0cnVjdCBzYXNfdGFzayAq
dGFzaykKIHsKIAl1MzIgdGFnID0gMDsKIAlzdHJ1Y3QgYXRhX3F1ZXVlZF9jbWQgKnFjID0gdGFz
ay0+dWxkZF90YXNrOwpAQCAtMTQxOCw3ICsxNDU0LDggQEAgc3RhdGljIGludCBtdnNfdGFza19w
cmVwX2F0YShzdHJ1Y3QgbXZzX2luZm8gKm12aSwKIAl2b2lkICpidWZfdG1wOwogCXU4ICpidWZf
Y21kLCAqYnVmX29hZjsKIAlkbWFfYWRkcl90IGJ1Zl90bXBfZG1hOwotCXVuc2lnbmVkIGludCBp
LCByZXFfbGVuLCByZXNwX2xlbjsKKwl1MzIgaSwgcmVxX2xlbiwgcmVzcF9sZW47CisJY29uc3Qg
dTMyIG1heF9yZXNwX2xlbiA9IFNCX1JGQl9NQVg7CiAJc3RydWN0IG12c19wb3J0ICpwb3J0ID0g
KHN0cnVjdCBtdnNfcG9ydCAqKXNhc19wb3J0LT5sbGRkX3BvcnQ7CiAKIAlpZiAobXZzX2Fzc2ln
bl9yZWdfc2V0KG12aSwgcG9ydCkgPT0gTVZTX0lEX05PVF9NQVBQRUQpCkBAIC0xNDk4LDE0ICsx
NTM1LDE1IEBAIHN0YXRpYyBpbnQgbXZzX3Rhc2tfcHJlcF9hdGEoc3RydWN0IG12c19pbmZvICpt
dmksCiAJICAgIHNpemVvZihzdHJ1Y3QgbXZzX2Vycl9pbmZvKSAtIGk7CiAKIAkvKiByZXF1ZXN0
LCByZXNwb25zZSBsZW5ndGhzICovCi0JcmVzcF9sZW4gPSBtaW4ocmVzcF9sZW4sICh1MzIpIDB4
NDAwKTsKKwlyZXNwX2xlbiA9IG1pbihyZXNwX2xlbiwgbWF4X3Jlc3BfbGVuKTsKIAloZHItPmxl
bnMgPSBjcHVfdG9fbGUzMigoKHJlc3BfbGVuIC8gNCkgPDwgMTYpIHwgKHJlcV9sZW4gLyA0KSk7
CiAKKwl0YXNrLT5hdGFfdGFzay5maXMuZmxhZ3MgfD0gMHg4MDsgLyogQz0xOiB1cGRhdGUgQVRB
IGNtZCByZWcgKi8KIAkvKiBmaWxsIGluIGNvbW1hbmQgRklTIGFuZCBBVEFQSSBDREIgKi8KLQl0
YXNrLT5hdGFfdGFzay5maXMuZmxhZ3MgfD0gMHg4MDsKIAltZW1jcHkoYnVmX2NtZCwgJnRhc2st
PmF0YV90YXNrLmZpcywgc2l6ZW9mKHN0cnVjdCBob3N0X3RvX2Rldl9maXMpKTsKIAlpZiAoZGV2
LT5zYXRhX2Rldi5jb21tYW5kX3NldCA9PSBBVEFQSV9DT01NQU5EX1NFVCkKLQkJbWVtY3B5KGJ1
Zl9jbWQgKyAweDQwLCB0YXNrLT5hdGFfdGFzay5hdGFwaV9wYWNrZXQsIDE2KTsKKwkJbWVtY3B5
KGJ1Zl9jbWQgKyBTVFBfQVRBUElfQ01ELAorCQkJdGFzay0+YXRhX3Rhc2suYXRhcGlfcGFja2V0
LCAxNik7CiAKIAkvKiBmaWxsIGluIFBSRCAoc2NhdHRlci9nYXRoZXIpIHRhYmxlLCBpZiBhbnkg
Ki8KIAlzZyA9IHRhc2stPnNjYXR0ZXI7CkBAIC0xNTI4LDEzICsxNTY2LDE0IEBAIHN0YXRpYyBp
bnQgbXZzX3Rhc2tfcHJlcF9zc3Aoc3RydWN0IG12c19pbmZvICptdmksCiAJc3RydWN0IG12c19j
bWRfaGRyICpoZHIgPSB0ZWktPmhkcjsKIAlzdHJ1Y3QgbXZzX3Nsb3RfaW5mbyAqc2xvdDsKIAlz
dHJ1Y3Qgc2NhdHRlcmxpc3QgKnNnOwotCXUzMiByZXNwX2xlbiwgcmVxX2xlbiwgaSwgdGFnID0g
dGVpLT50YWc7CiAJc3RydWN0IG12c19wcmQgKmJ1Zl9wcmQ7CiAJc3RydWN0IHNzcF9mcmFtZV9o
ZHIgKnNzcF9oZHI7CiAJdm9pZCAqYnVmX3RtcDsKIAl1OCAqYnVmX2NtZCwgKmJ1Zl9vYWYsIGZi
dXJzdCA9IDA7CiAJZG1hX2FkZHJfdCBidWZfdG1wX2RtYTsKIAl1MzIgZmxhZ3M7CisJdTMyIHJl
c3BfbGVuLCByZXFfbGVuLCBpLCB0YWcgPSB0ZWktPnRhZzsKKwljb25zdCB1MzIgbWF4X3Jlc3Bf
bGVuID0gU0JfUkZCX01BWDsKIAogCXNsb3QgPSAmbXZpLT5zbG90X2luZm9bdGFnXTsKIApAQCAt
MTU5Myw3ICsxNjMyLDcgQEAgc3RhdGljIGludCBtdnNfdGFza19wcmVwX3NzcChzdHJ1Y3QgbXZz
X2luZm8gKm12aSwKIAogCXJlc3BfbGVuID0gTVZTX1NMT1RfQlVGX1NaIC0gTVZTX1NTUF9DTURf
U1ogLSBNVlNfT0FGX1NaIC0KIAkgICAgc2l6ZW9mKHN0cnVjdCBtdnNfZXJyX2luZm8pIC0gaTsK
LQlyZXNwX2xlbiA9IG1pbihyZXNwX2xlbiwgKHUzMikgMHg0MDApOworCXJlc3BfbGVuID0gbWlu
KHJlc3BfbGVuLCBtYXhfcmVzcF9sZW4pOwogCiAJcmVxX2xlbiA9IHNpemVvZihzdHJ1Y3Qgc3Nw
X2ZyYW1lX2hkcikgKyAyODsKIApAQCAtMTYxOSwxMiArMTY1OCwxMSBAQCBzdGF0aWMgaW50IG12
c190YXNrX3ByZXBfc3NwKHN0cnVjdCBtdnNfaW5mbyAqbXZpLAogCS8qIGZpbGwgaW4gY29tbWFu
ZCBmcmFtZSBJVSAqLwogCWJ1Zl9jbWQgKz0gc2l6ZW9mKCpzc3BfaGRyKTsKIAltZW1jcHkoYnVm
X2NtZCwgJnRhc2stPnNzcF90YXNrLkxVTiwgOCk7Ci0JYnVmX2NtZFs5XSA9IGZidXJzdCB8Ci0J
ICAgIHRhc2stPnNzcF90YXNrLnRhc2tfYXR0ciB8ICh0YXNrLT5zc3BfdGFzay50YXNrX3ByaW8g
PDwgMyk7CisJYnVmX2NtZFs5XSA9IGZidXJzdCB8IHRhc2stPnNzcF90YXNrLnRhc2tfYXR0ciB8
CisJCQkodGFzay0+c3NwX3Rhc2sudGFza19wcmlvIDw8IDMpOwogCW1lbWNweShidWZfY21kICsg
MTIsICZ0YXNrLT5zc3BfdGFzay5jZGIsIDE2KTsKLQkvKkNEQiovCi0JICAgIC8qIGZpbGwgaW4g
UFJEIChzY2F0dGVyL2dhdGhlcikgdGFibGUsIGlmIGFueSAqLwotCSAgICBzZyA9IHRhc2stPnNj
YXR0ZXI7CisJLyogZmlsbCBpbiBQUkQgKHNjYXR0ZXIvZ2F0aGVyKSB0YWJsZSwgaWYgYW55ICov
CisJc2cgPSB0YXNrLT5zY2F0dGVyOwogCWZvciAoaSA9IDA7IGkgPCB0ZWktPm5fZWxlbTsgaSsr
KSB7CiAJCWJ1Zl9wcmQtPmFkZHIgPSBjcHVfdG9fbGU2NChzZ19kbWFfYWRkcmVzcyhzZykpOwog
CQlidWZfcHJkLT5sZW4gPSBjcHVfdG9fbGUzMihzZ19kbWFfbGVuKHNnKSk7CkBAIC0xNjQ2LDcg
KzE2ODQsNyBAQCBzdGF0aWMgaW50IG12c190YXNrX2V4ZWMoc3RydWN0IHNhc190YXNrICp0YXNr
LCBjb25zdCBpbnQgbnVtLCBnZnBfdCBnZnBfZmxhZ3MpCiAJc3RydWN0IHNhc190YXNrICp0ID0g
dGFzazsKIAl1MzIgbiA9IG51bSwgcGFzcyA9IDA7CiAKLQltdnNfaGJhX2ludGVycnVwdF9lbmFi
bGUobXZpLCAwKTsKKwlzcGluX2xvY2tfaXJxc2F2ZSgmbXZpLT5sb2NrLCBmbGFncyk7CiAKIAlk
byB7CiAJCWlmICghc2FzX3Byb3RvY29sX2F0YSh0LT50YXNrX3Byb3RvKSkgewpAQCAtMTY5NSwx
MiArMTczMywxMiBAQCBzdGF0aWMgaW50IG12c190YXNrX2V4ZWMoc3RydWN0IHNhc190YXNrICp0
YXNrLCBjb25zdCBpbnQgbnVtLCBnZnBfdCBnZnBfZmxhZ3MpCiAKIAkJLyogVE9ETzogc2VsZWN0
IG5vcm1hbCBvciBoaWdoIHByaW9yaXR5ICovCiAKLQkJc3Bpbl9sb2NrX2lycXNhdmUoJnQtPnRh
c2tfc3RhdGVfbG9jaywgZmxhZ3MpOworCQlzcGluX2xvY2soJnQtPnRhc2tfc3RhdGVfbG9jayk7
CiAJCXQtPnRhc2tfc3RhdGVfZmxhZ3MgfD0gU0FTX1RBU0tfQVRfSU5JVElBVE9SOwotCQlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZ0LT50YXNrX3N0YXRlX2xvY2ssIGZsYWdzKTsKKwkJc3Bpbl91
bmxvY2soJnQtPnRhc2tfc3RhdGVfbG9jayk7CiAKIAkJaWYgKG4gPT0gMSkgewotCQkJbXZzX2hi
YV9pbnRlcnJ1cHRfZW5hYmxlKG12aSwgMSk7CisJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZt
dmktPmxvY2ssIGZsYWdzKTsKIAkJCW13MzIoVFhfUFJPRF9JRFgsIG12aS0+dHhfcHJvZCk7CiAJ
CX0KIAkJLyoKQEAgLTE3MzIsNyArMTc3MCw3IEBAIGVycl9vdXQ6CiAJCQkJICAgICB0LT5kYXRh
X2Rpcik7CiAJaWYgKHBhc3MpCiAJCW13MzIoVFhfUFJPRF9JRFgsIChtdmktPnR4X3Byb2QgLSAx
KSAmIChNVlNfQ0hJUF9TTE9UX1NaIC0gMSkpOwotCW12c19oYmFfaW50ZXJydXB0X2VuYWJsZSht
dmksIDEpOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJm12aS0+bG9jaywgZmxhZ3MpOwogCXJl
dHVybiByYzsKIH0KIApAQCAtMTc3Myw3ICsxODExLDcgQEAgc3RhdGljIHZvaWQgbXZzX2ZyZWUo
c3RydWN0IG12c19pbmZvICptdmkpCiAJCWRtYV9mcmVlX2NvaGVyZW50KCZtdmktPnBkZXYtPmRl
diwKIAkJCQkgIHNpemVvZigqbXZpLT5zbG90KSAqIE1WU19TTE9UUywKIAkJCQkgIG12aS0+c2xv
dCwgbXZpLT5zbG90X2RtYSk7Ci0jaWYgMAorI2lmZGVmIE1WU19FTkFCTEVfUEVSSQogCWlmICht
dmktPnBlcmlfcmVncykKIAkJaW91bm1hcChtdmktPnBlcmlfcmVncyk7CiAjZW5kaWYKQEAgLTE5
MDYsNyArMTk0NCw3IEBAIHN0YXRpYyBzdHJ1Y3QgbXZzX2luZm8gKl9fZGV2aW5pdCBtdnNfYWxs
b2Moc3RydWN0IHBjaV9kZXYgKnBkZXYsCiAJU0hPU1RfVE9fU0FTX0hBKG12aS0+c2hvc3QpID0g
Jm12aS0+c2FzOwogCW12aS0+c2hvc3QtPnRyYW5zcG9ydHQgPSBtdnNfc3R0OwogCW12aS0+c2hv
c3QtPm1heF9pZCA9IDIxOwotCW12aS0+c2hvc3QtPm1heF9sdW4gPSAyOworCW12aS0+c2hvc3Qt
Pm1heF9sdW4gPSB+MDsKIAltdmktPnNob3N0LT5tYXhfY2hhbm5lbCA9IDA7CiAJbXZpLT5zaG9z
dC0+bWF4X2NtZF9sZW4gPSAxNjsKIApAQCAtMTkzNCw3ICsxOTcyLDcgQEAgc3RhdGljIHN0cnVj
dCBtdnNfaW5mbyAqX19kZXZpbml0IG12c19hbGxvYyhzdHJ1Y3QgcGNpX2RldiAqcGRldiwKIAlp
ZiAoIXJlc19zdGFydCB8fCAhcmVzX2xlbikKIAkJZ290byBlcnJfb3V0OwogCi0jaWYgMAorI2lm
ZGVmIE1WU19FTkFCTEVfUEVSSQogCW12aS0+cGVyaV9yZWdzID0gaW9yZW1hcF9ub2NhY2hlKHJl
c19zdGFydCwgcmVzX2xlbik7CiAJaWYgKCFtdmktPnBlcmlfcmVncykKIAkJZ290byBlcnJfb3V0
OwpAQCAtMjAwOCw0MCArMjA0NiwxOCBAQCBlcnJfb3V0OgogCXJldHVybiBOVUxMOwogfQogCi1z
dGF0aWMgaW5saW5lIHUzMiBtdnNfY3IzMih2b2lkIF9faW9tZW0gKnJlZ3MsIHUzMiBhZGRyKQor
c3RhdGljIHUzMiBtdnNfY3IzMih2b2lkIF9faW9tZW0gKnJlZ3MsIHUzMiBhZGRyKQogewogCW13
MzIoQ01EX0FERFIsIGFkZHIpOwogCXJldHVybiBtcjMyKENNRF9EQVRBKTsKIH0KIAotc3RhdGlj
IGlubGluZSB2b2lkIG12c19jdzMyKHZvaWQgX19pb21lbSAqcmVncywgdTMyIGFkZHIsIHUzMiB2
YWwpCitzdGF0aWMgdm9pZCBtdnNfY3czMih2b2lkIF9faW9tZW0gKnJlZ3MsIHUzMiBhZGRyLCB1
MzIgdmFsKQogewogCW13MzIoQ01EX0FERFIsIGFkZHIpOwogCW13MzIoQ01EX0RBVEEsIHZhbCk7
CiB9CiAKLSNpZiAwCi1zdGF0aWMgdTMyIG12c19waHlfcmVhZChzdHJ1Y3QgbXZzX2luZm8gKm12
aSwgdW5zaWduZWQgaW50IHBoeV9pZCwgdTMyIGFkZHIpCi17Ci0Jdm9pZCBfX2lvbWVtICpyZWdz
ID0gbXZpLT5yZWdzOwotCXZvaWQgX19pb21lbSAqcGh5X3JlZ3MgPSByZWdzICsgTVZTX1AwX0NG
R19BRERSICsgKHBoeV9pZCAqIDgpOwotCi0Jd3JpdGVsKGFkZHIsIHBoeV9yZWdzKTsKLQlyZXR1
cm4gcmVhZGwocGh5X3JlZ3MgKyA0KTsKLX0KLQotc3RhdGljIHZvaWQgbXZzX3BoeV93cml0ZShz
dHJ1Y3QgbXZzX2luZm8gKm12aSwgdW5zaWduZWQgaW50IHBoeV9pZCwKLQkJCSAgdTMyIGFkZHIs
IHUzMiB2YWwpCi17Ci0Jdm9pZCBfX2lvbWVtICpyZWdzID0gbXZpLT5yZWdzOwotCXZvaWQgX19p
b21lbSAqcGh5X3JlZ3MgPSByZWdzICsgTVZTX1AwX0NGR19BRERSICsgKHBoeV9pZCAqIDgpOwot
Ci0Jd3JpdGVsKGFkZHIsIHBoeV9yZWdzKTsKLQl3cml0ZWwodmFsLCBwaHlfcmVncyArIDQpOwot
CXJlYWRsKHBoeV9yZWdzKTsJLyogZmx1c2ggKi8KLX0KLSNlbmRpZgotCiBzdGF0aWMgdm9pZCBf
X2RldmluaXQgbXZzX3BoeV9oYWNrcyhzdHJ1Y3QgbXZzX2luZm8gKm12aSkKIHsKIAl2b2lkIF9f
aW9tZW0gKnJlZ3MgPSBtdmktPnJlZ3M7CkBAIC0yMDk1LDcgKzIxMTEsNyBAQCBzdGF0aWMgdm9p
ZCBfX2RldmluaXQgbXZzX3BoeV9oYWNrcyhzdHJ1Y3QgbXZzX2luZm8gKm12aSkKIAogfQogCi1z
dGF0aWMgaW5saW5lIHZvaWQgbXZzX2VuYWJsZV94bXQoc3RydWN0IG12c19pbmZvICptdmksIGlu
dCBQaHlJZCkKK3N0YXRpYyB2b2lkIG12c19lbmFibGVfeG10KHN0cnVjdCBtdnNfaW5mbyAqbXZp
LCBpbnQgUGh5SWQpCiB7CiAJdm9pZCBfX2lvbWVtICpyZWdzID0gbXZpLT5yZWdzOwogCXUzMiB0
bXA7CkBAIC0yMTMxLDcgKzIxNDcsNyBAQCBzdGF0aWMgdm9pZCBtdnNfZGV0ZWN0X3BvcnR0eXBl
KHN0cnVjdCBtdnNfaW5mbyAqbXZpLCBpbnQgaSkKIAogfQogCi1zdGF0aWMgaW5saW5lIHZvaWQg
Km12c19nZXRfZDJoX3JlZyhzdHJ1Y3QgbXZzX2luZm8gKm12aSwgaW50IGksIHZvaWQgKmJ1ZikK
K3N0YXRpYyB2b2lkICptdnNfZ2V0X2QyaF9yZWcoc3RydWN0IG12c19pbmZvICptdmksIGludCBp
LCB2b2lkICpidWYpCiB7CiAJdTMyICpzID0gKHUzMiAqKSBidWY7CiAJdm9pZCBfX2lvbWVtICpy
ZWdzID0gbXZpLT5yZWdzOwpAQCAtMjE1NCw3ICsyMTcwLDcgQEAgc3RhdGljIGlubGluZSB2b2lk
ICptdnNfZ2V0X2QyaF9yZWcoc3RydWN0IG12c19pbmZvICptdmksIGludCBpLCB2b2lkICpidWYp
CiAJcmV0dXJuICh2b2lkICopczsKIH0KIAotc3RhdGljIGlubGluZSB1MzIgbXZzX2lzX3NpZ19m
aXNfcmVjZWl2ZWQoc3RydWN0IG12c19pbmZvICptdmksIGludCBpKQorc3RhdGljIHUzMiBtdnNf
aXNfc2lnX2Zpc19yZWNlaXZlZChzdHJ1Y3QgbXZzX2luZm8gKm12aSwgaW50IGkpCiB7CiAJdTMy
IHRtcDsKIAl2b2lkIF9faW9tZW0gKnJlZ3MgPSBtdmktPnJlZ3M7CkBAIC0yMTc0LDIzICsyMTkw
LDIyIEBAIHN0YXRpYyB2b2lkIF9fZGV2aW5pdCBtdnNfdXBkYXRlX3BoeWluZm8oc3RydWN0IG12
c19pbmZvICptdmksIGludCBpKQogCV9fbGU2NCB0bXA2NDsKIAogCVdSSVRFX1BPUlRfQ09ORklH
X0FERFIoaSwgUEhZUl9JREVOVElGWSk7Ci0JcGh5LT5kZXZpbmZvID0gUkVBRF9QT1JUX0NPTkZJ
R19EQVRBKGkpOworCXBoeS0+ZGV2X2luZm8gPSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSk7CiAK
IAlXUklURV9QT1JUX0NPTkZJR19BRERSKGksIFBIWVJfQUREUl9ISSk7Ci0JcGh5LT5kZXZzYXNh
ZGRyID0gKF9fbGU2NCkgUkVBRF9QT1JUX0NPTkZJR19EQVRBKGkpIDw8IDMyOworCXBoeS0+ZGV2
X3Nhc19hZGRyID0gKF9fbGU2NCkgUkVBRF9QT1JUX0NPTkZJR19EQVRBKGkpIDw8IDMyOwogCiAJ
V1JJVEVfUE9SVF9DT05GSUdfQUREUihpLCBQSFlSX0FERFJfTE8pOwotCXBoeS0+ZGV2c2FzYWRk
ciB8PSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSk7CS8qbGUgKi8KKwlwaHktPmRldl9zYXNfYWRk
ciB8PSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSk7CS8qIGxlICovCiAKLQlwaHktPnBoeXN0YXR1
cyA9IFJFQURfUE9SVF9QSFlfQ09OVFJPTChpKTsKLQkvKk1WU19QUklOVEsoIlBoeVN0YXR1cz0l
WFxuIixwaHktPnBoeXN0YXR1cyk7Ki8KKwlwaHktPnBoeV9zdGF0dXMgPSBSRUFEX1BPUlRfUEhZ
X0NPTlRST0woaSk7CiAKLQkvKkZJWE1FIFVwZGF0ZSBXaWRlIFBvcnQgaW5mbyAqLworCS8qIEZJ
WE1FIFVwZGF0ZSBXaWRlIFBvcnQgaW5mbyAqLwogCXBoeS0+cG9ydCA9ICZtdmktPnBvcnRbaV07
CiAJcGh5LT5wb3J0LT5zYXNfcG9ydC5sbGRkX3BvcnQgPSBwaHktPnBvcnQ7CiAJcGh5LT5wb3J0
LT50YXNrZmlsZXNldCA9IE1WU19JRF9OT1RfTUFQUEVEOwogCi0JaWYgKHBoeS0+cGh5c3RhdHVz
ICYgUEhZX1JFQURZX01BU0spIHsKKwlpZiAocGh5LT5waHlfc3RhdHVzICYgUEhZX1JFQURZX01B
U0spIHsKIAkJdTMyIHBoeV9zdDsKIAkJc3RydWN0IGFzZF9zYXNfcGh5ICpzYXNfcGh5ID0gbXZp
LT5zYXMuc2FzX3BoeVtpXTsKIApAQCAtMjE5OCwyNyArMjIxMywyOSBAQCBzdGF0aWMgdm9pZCBf
X2RldmluaXQgbXZzX3VwZGF0ZV9waHlpbmZvKHN0cnVjdCBtdnNfaW5mbyAqbXZpLCBpbnQgaSkK
IAkJcGh5X3N0ID0gUkVBRF9QT1JUX0NPTkZJR19EQVRBKGkpOwogCiAJCVdSSVRFX1BPUlRfQ09O
RklHX0FERFIoaSwgUEhZUl9BVFRfQUREUl9ISSk7Ci0JCXBoeS0+YXR0ZGV2c2FzYWRkciA9IChf
X2xlNjQpIFJFQURfUE9SVF9DT05GSUdfREFUQShpKSA8PCAzMjsKKwkJcGh5LT5hdHRfZGV2X3Nh
c19hZGRyID0gKF9fbGU2NCkgUkVBRF9QT1JUX0NPTkZJR19EQVRBKGkpIDw8IDMyOwogCiAJCVdS
SVRFX1BPUlRfQ09ORklHX0FERFIoaSwgUEhZUl9BVFRfQUREUl9MTyk7Ci0JCXBoeS0+YXR0ZGV2
c2FzYWRkciB8PSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSk7CisJCXBoeS0+YXR0X2Rldl9zYXNf
YWRkciB8PSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSk7CiAKIAkJLypVcGRhdGVkIGF0dGFjaGVk
X3Nhc19hZGRyICovCi0JCXRtcDY0ID0gcGh5LT5hdHRkZXZzYXNhZGRyOwotCQlNVlNfUFJJTlRL
KCJwaHlbJWRdIEdldCBBdHRhY2hlZCBBZGRyZXNzIDB4JWxsWCAgXG4iLCBpLCB0bXA2NCk7CisJ
CXRtcDY0ID0gcGh5LT5hdHRfZGV2X3Nhc19hZGRyOworCQlNVlNfUFJJTlRLKCJwaHlbJWRdIEdl
dCBBdHRhY2hlZCBBZGRyZXNzIDB4JWxsWCAsIgorCQkJCSIgU0FTIEFkZHJlc3MgMHglbGxYXG4i
LAorCQkJCWksIHRtcDY0LCBwaHktPmRldl9zYXNfYWRkcik7CiAJCXRtcDY0ID0gY3B1X3RvX2Jl
NjQodG1wNjQpOwogCQltZW1jcHkoc2FzX3BoeS0+YXR0YWNoZWRfc2FzX2FkZHIsICZ0bXA2NCwg
U0FTX0FERFJfU0laRSk7CiAKIAkJaWYgKHBoeS0+dHlwZSAmIFBPUlRfVFlQRV9TQVMpIHsKIAkJ
CVdSSVRFX1BPUlRfQ09ORklHX0FERFIoaSwgUEhZUl9BVFRfREVWX0lORk8pOwotCQkJcGh5LT5h
dHRkZXZpbmZvID0gUkVBRF9QT1JUX0NPTkZJR19EQVRBKGkpOworCQkJcGh5LT5hdHRfZGV2X2lu
Zm8gPSBSRUFEX1BPUlRfQ09ORklHX0RBVEEoaSk7CiAJCQlwaHktPmlkZW50aWZ5LmRldmljZV90
eXBlID0KLQkJCSAgICBwaHktPmF0dGRldmluZm8gJiBQT1JUX0RFVl9UWVBFX01BU0s7CisJCQkg
ICAgcGh5LT5hdHRfZGV2X2luZm8gJiBQT1JUX0RFVl9UWVBFX01BU0s7CiAJCQlNVlNfUFJJTlRL
KCJkZXZpY2VfdHlwZSA9ICVkXG4iLAogCQkJCSAgIHBoeS0+aWRlbnRpZnkuZGV2aWNlX3R5cGUp
OwogCiAJCQlzYXNfcGh5LT5saW5rcmF0ZSA9Ci0JCQkocGh5LT5waHlzdGF0dXMgJiBQSFlfTkVH
X1NQUF9QSFlTX0xJTktfUkFURV9NQVNLKSA+PgorCQkJKHBoeS0+cGh5X3N0YXR1cyAmIFBIWV9O
RUdfU1BQX1BIWVNfTElOS19SQVRFX01BU0spID4+CiAJCQkJUEhZX05FR19TUFBfUEhZU19MSU5L
X1JBVEVfTUFTS19PRkZTRVQ7CiAJCQlpZiAocGh5X3N0ICYgUEhZX09PQl9EVENURCkKIAkJCQlz
YXNfcGh5LT5vb2JfbW9kZSA9IFNBU19PT0JfTU9ERTsKQEAgLTIyMzUsMTggKzIyNTIsMTggQEAg
c3RhdGljIHZvaWQgX19kZXZpbml0IG12c191cGRhdGVfcGh5aW5mbyhzdHJ1Y3QgbXZzX2luZm8g
Km12aSwgaW50IGkpCiAJCQl9CiAJCX0KIAkJLyogd29ya2Fyb3VuZCBmb3IgSFcgcGh5IGRlY29k
aW5nIGVycm9yIG9uIDEuNWcgZGlzayBkcml2ZSAqLwotCQlXUklURV9QT1JUX1ZTUl9BRERSKGks
IDB4MDYpOworCQlXUklURV9QT1JUX1ZTUl9BRERSKGksIFZTUl9QSFlfTU9ERTYpOwogCQl0bXAg
PSBSRUFEX1BPUlRfVlNSX0RBVEEoaSk7Ci0JCWlmICgoKHBoeS0+cGh5c3RhdHVzICYgUEhZX05F
R19TUFBfUEhZU19MSU5LX1JBVEVfTUFTSykgPj4KKwkJaWYgKCgocGh5LT5waHlfc3RhdHVzICYg
UEhZX05FR19TUFBfUEhZU19MSU5LX1JBVEVfTUFTSykgPj4KIAkJICAgICBQSFlfTkVHX1NQUF9Q
SFlTX0xJTktfUkFURV9NQVNLX09GRlNFVCkgPT0KIAkJCVNBU19MSU5LX1JBVEVfMV81X0dCUFMp
Ci0JCQl0bXAgJj0gfjB4MjAwMDAwMDA7CisJCQl0bXAgJj0gflBIWV9NT0RFNl9EVExfU1BFRUQ7
CiAJCWVsc2UKLQkJCXRtcCB8PSAweDIwMDAwMDAwOworCQkJdG1wIHw9IFBIWV9NT0RFNl9EVExf
U1BFRUQ7CiAJCVdSSVRFX1BPUlRfVlNSX0RBVEEoaSwgdG1wKTsKIAogCX0KLQlwaHktPmlycXN0
YXR1cyA9IFJFQURfUE9SVF9JUlFfU1RBVChpKTsKKwlwaHktPmlycV9zdGF0dXMgPSBSRUFEX1BP
UlRfSVJRX1NUQVQoaSk7CiB9CiAKIHN0YXRpYyBpbnQgX19kZXZpbml0IG12c19od19pbml0KHN0
cnVjdCBtdnNfaW5mbyAqbXZpKQpAQCAtMjI1OSw3ICsyMjc2LDcgQEAgc3RhdGljIGludCBfX2Rl
dmluaXQgbXZzX2h3X2luaXQoc3RydWN0IG12c19pbmZvICptdmkpCiAJbXczMihHQkxfQ1RMLCAw
KTsKIAl0bXAgPSBtcjMyKEdCTF9DVEwpOwogCi0JLypSZXNldENvbnRyb2xsZXIgKi8KKwkvKiBS
ZXNldCBDb250cm9sbGVyICovCiAJaWYgKCEodG1wICYgSEJBX1JTVCkpIHsKIAkJaWYgKG12aS0+
ZmxhZ3MgJiBNVkZfUEhZX1BXUl9GSVgpIHsKIAkJCXBjaV9yZWFkX2NvbmZpZ19kd29yZChtdmkt
PnBkZXYsIFBDUl9QSFlfQ1RMLCAmdG1wKTsKQEAgLTIyOTAsMTggKzIzMDcsMTQgQEAgc3RhdGlj
IGludCBfX2RldmluaXQgbXZzX2h3X2luaXQoc3RydWN0IG12c19pbmZvICptdmkpCiAJCXJldHVy
biAtRUJVU1k7CiAJfQogCi0JLypJbml0Q2hpcCAqLworCS8qIEluaXQgQ2hpcCAqLwogCS8qIG1h
a2Ugc3VyZSBSU1QgaXMgc2V0OyBIQkFfUlNUIC9zaG91bGQvIGhhdmUgZG9uZSB0aGF0IGZvciB1
cyAqLwotCWNjdGwgPSBtcjMyKENUTCk7CS8qTVZTX0NUTCAqLworCWNjdGwgPSBtcjMyKENUTCk7
CiAJaWYgKGNjdGwgJiBDQ1RMX1JTVCkKIAkJY2N0bCAmPSB+Q0NUTF9SU1Q7CiAJZWxzZQogCQlt
dzMyX2YoQ1RMLCBjY3RsIHwgQ0NUTF9SU1QpOwogCi0JcGNpX3JlYWRfY29uZmlnX2R3b3JkKG12
aS0+cGRldiwgUENJX0NPTU1BTkQsICZ0bXApOwotCS8qTVZfUENJX0RFVl9FTiAqLwotCXRtcCB8
PSBQQ0lfQ09NTUFORF9JTyB8IFBDSV9DT01NQU5EX01FTU9SWSB8IFBDSV9DT01NQU5EX01BU1RF
UjsKLQlwY2lfd3JpdGVfY29uZmlnX2R3b3JkKG12aS0+cGRldiwgUENJX0NPTU1BTkQsIHRtcCk7
CiAJLyogd3JpdGUgdG8gZGV2aWNlIGNvbnRyb2wgX0FORF8gZGV2aWNlIHN0YXR1cyByZWdpc3Rl
cj8gLSBBLkMuICovCiAJcGNpX3JlYWRfY29uZmlnX2R3b3JkKG12aS0+cGRldiwgUENSX0RFVl9D
VFJMLCAmdG1wKTsKIAl0bXAgJj0gflBSRF9SRVFfTUFTSzsKQEAgLTIzNDIsNiArMjM1NSw3IEBA
IHN0YXRpYyBpbnQgX19kZXZpbml0IG12c19od19pbml0KHN0cnVjdCBtdnNfaW5mbyAqbXZpKQog
CS8qIGluaXQgYW5kIHJlc2V0IHBoeXMgKi8KIAlmb3IgKGkgPSAwOyBpIDwgbXZpLT5jaGlwLT5u
X3BoeTsgaSsrKSB7CiAJCS8qIEZJWE1FOiBpcyB0aGlzIHRoZSBjb3JyZWN0IGR3b3JkIG9yZGVy
PyAqLworI2lmZGVmIE1WU19ESVNBQkxFX05WUkFNCiAJCXUzMiBsbyA9ICooKHUzMiAqKSZtdmkt
PnNhc19hZGRyWzBdKTsKIAkJdTMyIGhpID0gKigodTMyICopJm12aS0+c2FzX2FkZHJbNF0pOwog
CkBAIC0yMzUyLDcgKzIzNjYsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBtdnNfaHdfaW5pdChz
dHJ1Y3QgbXZzX2luZm8gKm12aSkKIAkJV1JJVEVfUE9SVF9DT05GSUdfREFUQShpLCBsbyk7CiAJ
CVdSSVRFX1BPUlRfQ09ORklHX0FERFIoaSwgUEhZUl9BRERSX0hJKTsKIAkJV1JJVEVfUE9SVF9D
T05GSUdfREFUQShpLCBoaSk7Ci0KKyNlbmRpZgogCQkvKiByZXNldCBwaHkgKi8KIAkJdG1wID0g
UkVBRF9QT1JUX1BIWV9DT05UUk9MKGkpOwogCQl0bXAgfD0gUEhZX1JTVDsKLS0gCjEuNS4zLjcK
Cg==
------=_Part_30970_22761752.1201085682796--

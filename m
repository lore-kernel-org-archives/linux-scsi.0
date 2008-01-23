From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Tue, 22 Jan 2008 22:58:18 -0500
Message-ID: <4796BB5A.9090003@garzik.org>
References: <20080122151857.GA8680@ubuntu.domain> <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44632 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbYAWD6X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 22:58:23 -0500
In-Reply-To: <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi@vger.kernel.org, kewei@marvell.com, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com


Comments inline, mostly minor stuff cleaning up the source.

Major problem though:  your mailer converted tabs to spaces, so our 
automated patch tools won't work on your submission.  It usually takes a 
few attempts to get your email setup working, such that all the 
automated tools used in the Linux community work.


Ke Wei wrote:
> +#define MVS_QUEUE_SIZE (30)

to be consistent with the rest of the driver, make this an enum


> +#define MVS_PRINTK(_x_, ...) \
> +       printk(KERN_NOTICE DRV_NAME ": " _x_ , ## __VA_ARGS__)
> 
>  #define mr32(reg)      readl(regs + MVS_##reg)
>  #define mw32(reg,val)  writel((val), regs + MVS_##reg)
> @@ -47,6 +53,65 @@
>        readl(regs + MVS_##reg);                \
>        } while (0)
> 
> +#define MVS_BIT(x)             (1L << (x))
> +
> +#define PORT_TYPE_SATA         MVS_BIT(0)
> +#define PORT_TYPE_SAS          MVS_BIT(1)

to be consistent with the rest of the driver, just open-code "1 << n". 
This also makes it easier to get the C type correct.


> +#define MVS_ID_NOT_MAPPED      0xff
> +#define MVS_CHIP_SLOT_SZ       (1U << mvi->chip->slot_width)
> +
> +/* offset for D2H FIS in the Received FIS List Structure */
> +#define SATA_RECEIVED_D2H_FIS(reg_set) \
> +       (mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
> +#define SATA_RECEIVED_PIO_FIS(reg_set) \
> +       (mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
> +#define UNASSOC_D2H_FIS(id) \
> +       (mvi->rx_fis + 0x100 * id)
> +
> +
> +#define READ_PORT_CONFIG_DATA(i) \
> +       ((i > 3)?mr32(P4_CFG_DATA + (i - 4) * 8):mr32(P0_CFG_DATA + i * 8))
> +#define WRITE_PORT_CONFIG_DATA(i,tmp) \
> +       {if (i > 3)mw32(P4_CFG_DATA + (i - 4) * 8, tmp); \
> +       else \
> +               mw32(P0_CFG_DATA + i * 8, tmp); }
> +#define WRITE_PORT_CONFIG_ADDR(i,tmp) \
> +       {if (i > 3)mw32(P4_CFG_ADDR + (i - 4) * 8, tmp); \
> +       else \
> +               mw32(P0_CFG_ADDR + i * 8, tmp); }
> +
> +#define READ_PORT_PHY_CONTROL(i) \
> +       ((i > 3)?mr32(P4_SER_CTLSTAT + (i - 4) * 4):mr32(P0_SER_CTLSTAT+i * 4))
> +#define WRITE_PORT_PHY_CONTROL(i,tmp) \
> +       {if (i > 3)mw32(P4_SER_CTLSTAT + (i - 4) * 4, tmp); \
> +       else \
> +               mw32(P0_SER_CTLSTAT + i * 4, tmp); }
> +
> +#define READ_PORT_VSR_DATA(i) \
> +       ((i > 3)?mr32(P4_VSR_DATA + (i - 4) * 8):mr32(P0_VSR_DATA+i*8))
> +#define WRITE_PORT_VSR_DATA(i,tmp) \
> +       {if (i > 3)mw32(P4_VSR_DATA + (i - 4) * 8, tmp); \
> +       else \
> +               mw32(P0_VSR_DATA + i*8, tmp); }
> +#define WRITE_PORT_VSR_ADDR(i,tmp) \
> +       {if (i > 3)mw32(P4_VSR_ADDR + (i - 4) * 8, tmp); \
> +       else \
> +               mw32(P0_VSR_ADDR + i * 8, tmp); }
> +
> +#define READ_PORT_IRQ_STAT(i) \
> +       ((i > 3)?mr32(P4_INT_STAT + (i - 4) * 8):mr32(P0_INT_STAT + i * 8))
> +#define WRITE_PORT_IRQ_STAT(i,tmp) \
> +       {if (i > 3)mw32(P4_INT_STAT + (i-4) * 8, tmp); \
> +       else \
> +               mw32(P0_INT_STAT + i * 8, tmp); }
> +#define READ_PORT_IRQ_MASK(i) \
> +       ((i > 3)?mr32(P4_INT_MASK + (i-4) * 8):mr32(P0_INT_MASK+i*8))
> +#define WRITE_PORT_IRQ_MASK(i,tmp) \
> +       {if (i > 3)mw32(P4_INT_MASK + (i-4) * 8, tmp); \
> +       else \
> +               mw32(P0_INT_MASK + i * 8, tmp); }


make these macros readable, by breaking each C statement into a separate 
line



> @@ -260,13 +368,33 @@ enum hw_register_bits {
>        PHYEV_RDY_CH            = (1U << 0),    /* phy ready changed state */
> 
>        /* MVS_PCS */
> +       PCS_EN_SATA_REG         = (16),         /* Enable SATA Register Set*/
> +       PCS_EN_PORT_XMT_START   = (12),         /* Enable Port Transmit*/
> +       PCS_EN_PORT_XMT_START2  = (8),          /* For 6480*/
>        PCS_SATA_RETRY          = (1U << 8),    /* retry ctl FIS on R_ERR */
>        PCS_RSP_RX_EN           = (1U << 7),    /* raw response rx */
>        PCS_SELF_CLEAR          = (1U << 5),    /* self-clearing int mode */
>        PCS_FIS_RX_EN           = (1U << 4),    /* FIS rx enable */
>        PCS_CMD_STOP_ERR        = (1U << 3),    /* cmd stop-on-err enable */
> -       PCS_CMD_RST             = (1U << 2),    /* reset cmd issue */
> +       PCS_CMD_RST             = (1U << 1),    /* reset cmd issue */
>        PCS_CMD_EN              = (1U << 0),    /* enable cmd issue */
> +
> +       /*Port n Attached Device Info*/
> +       PORT_DEV_SSP_TRGT       = (1U << 19),
> +       PORT_DEV_SMP_TRGT       = (1U << 18),
> +       PORT_DEV_STP_TRGT       = (1U << 17),
> +       PORT_DEV_SSP_INIT       = (1U << 11),
> +       PORT_DEV_SMP_INIT       = (1U << 10),
> +       PORT_DEV_STP_INIT       = (1U << 9),
> +       PORT_PHY_ID_MASK        = (0xFFU << 24),
> +       PORT_DEV_TRGT_MASK      = (0x7U << 17),
> +       PORT_DEV_INIT_MASK      = (0x7U << 9),
> +       PORT_DEV_TYPE_MASK      = (0x7U << 0),
> +
> +       /*Port n PHY Status*/
> +       PHY_RDY                 = (1U << 2),
> +       PHY_DW_SYNC             = (1U << 1),
> +       PHY_OOB_DTCTD           = (1U << 0),

to be consistent, add spaces after /* and before */


> 
>  struct mvs_port {
>        struct asd_sas_port     sas_port;
> +       u8                      taskfileset;
>  };
> 
>  struct mvs_phy {
>        struct mvs_port         *port;
>        struct asd_sas_phy      sas_phy;
> +       struct sas_identify identify;
> +       __le32          devinfo;
> +       __le64          devsasaddr;
> +       __le32          attdevinfo;
> +       __le64          attdevsasaddr;
> +       u32             type;
> +       __le32          phystatus;
> +       __le32          irqstatus;
> +       u8              wideportphymap;
> +       u32             frame_rcvd_size;
> +       u8              frame_rcvd[32];

following linux style (and style used in my original driver), consider 
adding some '_' underscores, to separate out words.

dev_info
phy_stat
irq_stat
etc.

also, following the style in this driver, please add comments describing 
what the fields do


> -       u8                      frame_rcvd[24 + 1024];
>  };
> 
>  struct mvs_info {
> @@ -437,27 +585,39 @@ struct mvs_info {
>        dma_addr_t              rx_dma;
>        u32                     rx_cons;        /* RX consumer idx */
> 
> -       __le32                  *rx_fis;        /* RX'd FIS area */
> +       void                    *rx_fis;        /* RX'd FIS area */
>        dma_addr_t              rx_fis_dma;
> 
> -       struct mvs_cmd_hdr      *slot;          /* DMA command header slots */
> +       struct mvs_cmd_hdr      *slot;  /* DMA command header slots */
>        dma_addr_t              slot_dma;
> 
>        const struct mvs_chip_info *chip;
> 
> -                                       /* further per-slot information */
> +       unsigned long           tags[MVS_SLOTS];
>        struct mvs_slot_info    slot_info[MVS_SLOTS];
> -       unsigned long           tags[(MVS_SLOTS / sizeof(unsigned long)) + 1];
> -
> +                               /* further per-slot information */
>        struct mvs_phy          phy[MVS_MAX_PHYS];
>        struct mvs_port         port[MVS_MAX_PHYS];
> +
> +       u32                     can_queue;      /* per adapter */
> +       u32                     tag_out;        /*Get*/
> +       u32                     tag_in;         /*Give*/
> +};
> +
> +struct mvs_queue_task {
> +       struct list_head list;
> +
> +       void   *uldd_task;
>  };
> 
> +static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
> +static void mvs_scan_start(struct Scsi_Host *);
> +
>  static struct scsi_transport_template *mvs_stt;
> 
>  static const struct mvs_chip_info mvs_chips[] = {
> -       [chip_6320] =           { 2, 16, 9 },
> -       [chip_6440] =           { 4, 16, 9 },
> +       [chip_6320] =           { 2, 16, 9  },
> +       [chip_6440] =           { 4, 16, 9  },
>        [chip_6480] =           { 8, 32, 10 },
>  };
> 
> @@ -468,6 +628,8 @@ static struct scsi_host_template mvs_sht = {
>        .target_alloc           = sas_target_alloc,
>        .slave_configure        = sas_slave_configure,
>        .slave_destroy          = sas_slave_destroy,
> +       .scan_finished          = mvs_scan_finished,
> +       .scan_start             = mvs_scan_start,
>        .change_queue_depth     = sas_change_queue_depth,
>        .change_queue_type      = sas_change_queue_type,
>        .bios_param             = sas_bios_param,
> @@ -477,14 +639,154 @@ static struct scsi_host_template mvs_sht = {
>        .sg_tablesize           = SG_ALL,
>        .max_sectors            = SCSI_DEFAULT_MAX_SECTORS,
>        .use_clustering         = ENABLE_CLUSTERING,
> -       .eh_device_reset_handler= sas_eh_device_reset_handler,
> +       .eh_device_reset_handler        = sas_eh_device_reset_handler,
>        .eh_bus_reset_handler   = sas_eh_bus_reset_handler,
>        .slave_alloc            = sas_slave_alloc,
>        .target_destroy         = sas_target_destroy,
>        .ioctl                  = sas_ioctl,
>  };
> 
> -static void mvs_int_rx(struct mvs_info *mvi, bool self_clear);
> +static void mvs_hexdump(u32 size, u8 *data, u32 baseaddr)
> +{
> +       u32 i;
> +       u32 run;
> +       u32 offset;
> +
> +       offset = 0;
> +       while (size) {
> +               printk("%08X : ", baseaddr + offset);
> +               if (size >= 16)
> +                       run = 16;
> +               else
> +                       run = size;
> +               size -= run;
> +               for (i = 0; i < 16; i++) {
> +                       if (i < run)
> +                               printk("%02X ", (unsigned int)data[i]);
> +                       else
> +                               printk("   ");
> +               }
> +               printk(": ");
> +               for (i = 0; i < run; i++)
> +                       printk("%c", isalnum(data[i]) ? data[i] : '.');
> +               printk("\n");
> +               data = &data[16];
> +               offset += run;
> +       }
> +       printk("\n");
> +}

lib/hexdump.c should already provide most of this functionality?


> @@ -666,11 +970,53 @@ static int mvs_nvram_read(struct mvs_info *mvi, unsigned
> int addr,
>  err_out:
>        dev_printk(KERN_ERR, &mvi->pdev->dev, "%s", msg);
>        return rc;
> +#else
> +       memcpy(buf, "\x50\x05\x04\x30\x11\xab\x00\x00", 8);
> +       return 0;
> +#endif


what happens if two adapters are used, with the same SAS address?  That 
causes problems...


>  static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
>  {
> -       /* FIXME */
> +       void __iomem *regs = mvi->regs;
> +       /*
> +               events is port event.now ,
> +               we need check the interrupt status which belongs to per port.
> +       */
> +       MVS_PRINTK("Port0 = %d", READ_PORT_IRQ_STAT(0));
>  }
> 
>  static void mvs_int_sata(struct mvs_info *mvi)
> @@ -681,9 +1027,10 @@ static void mvs_int_sata(struct mvs_info *mvi)
>  static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
>                          struct mvs_slot_info *slot, unsigned int slot_idx)
>  {
> -       if (slot->n_elem)
> -               pci_unmap_sg(mvi->pdev, task->scatter,
> -                            slot->n_elem, task->data_dir);
> +       if (!sas_protocol_ata(task->task_proto))
> +               if (slot->n_elem)
> +                       pci_unmap_sg(mvi->pdev, task->scatter,
> +                                    slot->n_elem, task->data_dir);
> 
>        switch (task->task_proto) {
>        case SAS_PROTO_SMP:
> @@ -708,9 +1055,34 @@ static void mvs_slot_err(struct mvs_info *mvi, struct
> sas_task *task,
>                         unsigned int slot_idx)
>  {
>        /* FIXME */
> +       mvs_hba_sb_dump(mvi, slot_idx, task->task_proto);
>  }
> 
> -static void mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
> +static inline int mvs_can_queue(struct mvs_info *mvi, int num)
> +{
> +       int res = 0;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&mvi->lock, flags);
> +       if ((mvi->can_queue - num) < 0)
> +               res = -EBUSY;
> +       else
> +               mvi->can_queue -= num;
> +       spin_unlock_irqrestore(&mvi->lock, flags);
> +
> +       return res;
> +}
> +
> +static inline void mvs_can_dequeue(struct mvs_info *mvi, int num)
> +{
> +       /*unsigned long flags;*/
> +
> +       /*spin_lock_irqsave(&mvi->lock, flags);*/
> +       mvi->can_queue += num;
> +       /*spin_unlock_irqrestore(&mvi->lock, flags);*/

these functions are dead code and can be removed, AFAICS



> @@ -816,32 +1201,45 @@ static void mvs_int_rx(struct mvs_info *mvi, bool
> self_clear)
>         * we don't have to stall the CPU reading that register.
>         * The actual RX ring is offset by one dword, due to this.
>         */
> -       rx_prod_idx = le32_to_cpu(mvi->rx[0]) & 0xfff;
> +       rx_prod_idx = le32_to_cpu(mr32(RX_CONS_IDX)) & RX_RING_SZ_MASK;

This appears to add a new bug...  the le32_to_cpu() is not longer 
needed, once you started using mr32() macro

The PCI MMIO read/write functions handle that for you (since PCI is 
defined to be a little endian bus).


> @@ -978,9 +1458,8 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
>         */
>        memset(slot->buf, 0, MVS_SLOT_BUF_SZ);
> 
> -       /* region 1: command table area (MVS_ATA_CMD_SZ bytes) ***************/
> -       buf_cmd =
> -       buf_tmp = slot->buf;
> +       /* region 1: command table area (MVS_ATA_CMD_SZ bytes) ************** */
> +       buf_cmd = buf_tmp = slot->buf;
>        buf_tmp_dma = slot->buf_dma;
> 
>        hdr->cmd_tbl = cpu_to_le64(buf_tmp_dma);
> @@ -988,7 +1467,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
>        buf_tmp += MVS_ATA_CMD_SZ;
>        buf_tmp_dma += MVS_ATA_CMD_SZ;
> 
> -       /* region 2: open address frame area (MVS_OAF_SZ bytes) **********/
> +       /* region 2: open address frame area (MVS_OAF_SZ bytes) ********* */
>        /* used for STP.  unused for SATA? */
>        buf_oaf = buf_tmp;
>        hdr->open_frame = cpu_to_le64(buf_tmp_dma);

> @@ -996,32 +1475,37 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
>        buf_tmp += MVS_OAF_SZ;
>        buf_tmp_dma += MVS_OAF_SZ;
> 
> -       /* region 3: PRD table ***********************************************/
> +       /* region 3: PRD table ********************************************** */


adding this space before "*/" is strange



>        /* fill in command FIS and ATAPI CDB */
> -       memcpy(buf_cmd, &task->ata_task.fis,
> -              sizeof(struct host_to_dev_fis));
> -       memcpy(buf_cmd + 0x40, task->ata_task.atapi_packet, 16);
> +       task->ata_task.fis.flags |= 0x80;
> +       memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
> +       if (dev->sata_dev.command_set == ATAPI_COMMAND_SET)
> +               memcpy(buf_cmd + 0x40, task->ata_task.atapi_packet, 16);

prefer that you use named constants rather than 0x40 and 0x80

We call such numeric constants "magic numbers", because open source 
reviewers are not given any hint as to what that number represents, its 
purpose, its meaning.



> -       /* region 4: status buffer (larger the PRD, smaller this buf) ********/
> +       /* region 4: status buffer (larger the PRD, smaller this buf) ******* */
>        slot->response = buf_tmp;
>        hdr->status_buf = cpu_to_le64(buf_tmp_dma);
> 
> -       req_len = sizeof(struct ssp_frame_hdr) + 28;
>        resp_len = MVS_SLOT_BUF_SZ - MVS_SSP_CMD_SZ - MVS_OAF_SZ -
> -                  sizeof(struct mvs_err_info) - i;
> +           sizeof(struct mvs_err_info) - i;
> +       resp_len = min(resp_len, (u32) 0x400);
> +
> +       req_len = sizeof(struct ssp_frame_hdr) + 28;

same comment here -- use a numeric constant rather than 0x400



> @@ -1131,12 +1620,11 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
>        buf_cmd += sizeof(*ssp_hdr);
>        memcpy(buf_cmd, &task->ssp_task.LUN, 8);
>        buf_cmd[9] = fburst |
> -               task->ssp_task.task_attr |
> -               (task->ssp_task.task_prio << 3);
> +           task->ssp_task.task_attr | (task->ssp_task.task_prio << 3);
>        memcpy(buf_cmd + 12, &task->ssp_task.cdb, 16);
> -
> -       /* fill in PRD (scatter/gather) table, if any */
> -       sg = task->scatter;
> +       /*CDB*/
> +           /* fill in PRD (scatter/gather) table, if any */
> +           sg = task->scatter;

strange C code indentation (but maybe that's just the patch 
tabs-to-spaces corruption mentioned at the top of this email)


>        for (i = 0; i < tei->n_elem; i++) {
>                buf_prd->addr = cpu_to_le64(sg_dma_address(sg));
>                buf_prd->len = cpu_to_le32(sg_dma_len(sg));
> @@ -1155,72 +1643,106 @@ static int mvs_task_exec(struct sas_task *task, const
> int num, gfp_t gfp_flags)
>        void __iomem *regs = mvi->regs;
>        unsigned long flags;
>        struct mvs_task_exec_info tei;
> +       struct sas_task *t = task;
> +       u32 n = num, pass = 0;
> +
> +       mvs_hba_interrupt_enable(mvi, 0);


this is most likely a bug, or remnant of another driver.

should not not need to disable and then re-enable the HBA interrupt on 
every task_exec call.

if it's an interrupt mitigation strategy, it needs a large comment block 
somewhere, describing what's going on.


> +       do {
> +               if (!sas_protocol_ata(t->task_proto)) {
> +                       if (t->num_scatter) {
> +                               n_elem = pci_map_sg(mvi->pdev, t->scatter,
> +                                                   t->num_scatter,
> +                                                   t->data_dir);
> +                               if (!n_elem) {
> +                                       rc = -ENOMEM;
> +                                       goto err_out;
> +                               }
> +                       }
> +               } else {
> +                       n_elem = t->num_scatter;
> +               }
> 
> -       /* FIXME: STP/SATA support not complete yet */
> -       if (task->task_proto == SATA_PROTO || task->task_proto == SAS_PROTO_STP)
> -               return -SAS_DEV_NO_RESPONSE;
> +               rc = mvs_tag_alloc(mvi, &tag);
> +               if (rc)
> +                       goto err_out;
> 
> -       if (task->num_scatter) {
> -               n_elem = pci_map_sg(mvi->pdev, task->scatter,
> -                                   task->num_scatter, task->data_dir);
> -               if (!n_elem)
> -                       return -ENOMEM;
> -       }
> +               mvi->slot_info[tag].task = t;
> +               mvi->slot_info[tag].n_elem = n_elem;
> +               tei.task = t;
> +               tei.hdr = &mvi->slot[tag];
> +               tei.tag = tag;
> +               tei.n_elem = n_elem;
> 
> -       spin_lock_irqsave(&mvi->lock, flags);
> +               switch (t->task_proto) {
> +               case SAS_PROTO_SMP:
> +                       rc = mvs_task_prep_smp(mvi, &tei);
> +                       break;
> +               case SAS_PROTO_SSP:
> +                       rc = mvs_task_prep_ssp(mvi, &tei);
> +                       break;
> +               case SATA_PROTO:
> +               case SAS_PROTO_STP:
> +                       rc = mvs_task_prep_ata(mvi, &tei);
> +                       break;
> +               default:
> +                       rc = -EINVAL;
> +                       break;
> +               }
> 
> -       rc = mvs_tag_alloc(mvi, &tag);
> -       if (rc)
> -               goto err_out;
> +               if (rc)
> +                       goto err_out_tag;
> 
> -       mvi->slot_info[tag].task = task;
> -       mvi->slot_info[tag].n_elem = n_elem;
> -       tei.task = task;
> -       tei.hdr = &mvi->slot[tag];
> -       tei.tag = tag;
> -       tei.n_elem = n_elem;
> +               /* TODO: select normal or high priority */
> 
> -       switch (task->task_proto) {
> -       case SAS_PROTO_SMP:
> -               rc = mvs_task_prep_smp(mvi, &tei);
> -               break;
> -       case SAS_PROTO_SSP:
> -               rc = mvs_task_prep_ssp(mvi, &tei);
> -               break;
> -       case SATA_PROTO:
> -       case SAS_PROTO_STP:
> -               rc = mvs_task_prep_ata(mvi, &tei);
> -               break;
> -       default:
> -               rc = -EINVAL;
> -               break;
> -       }
> -
> -       if (rc)
> -               goto err_out_tag;
> +               spin_lock_irqsave(&t->task_state_lock, flags);
> +               t->task_state_flags |= SAS_TASK_AT_INITIATOR;
> +               spin_unlock_irqrestore(&t->task_state_lock, flags);
> 
> -       /* TODO: select normal or high priority */
> +               if (n == 1) {
> +                       mvs_hba_interrupt_enable(mvi, 1);
> +                       mw32(TX_PROD_IDX, mvi->tx_prod);
> +               }
> +               /*

ditto.  this is highly irregular (enabling/disabling HBA interrupt for 
each task exec -- lotsa of overhead for questionable gain)



> +static int mvs_abort_task(struct sas_task *task)
> +{
> +       /*FIXME*/
> +       MVS_PRINTK("mvs abort task\n");
> +       return TMF_RESP_FUNC_COMPLETE;
> +}

should make an attempt to do something sane here


> @@ -1249,10 +1771,12 @@ static void mvs_free(struct mvs_info *mvi)
>                                  mvi->rx, mvi->rx_dma);
>        if (mvi->slot)
>                dma_free_coherent(&mvi->pdev->dev,
> -                                 sizeof(*mvi->slot) * MVS_RX_RING_SZ,
> +                                 sizeof(*mvi->slot) * MVS_SLOTS,
>                                  mvi->slot, mvi->slot_dma);
> +#if 0
>        if (mvi->peri_regs)
>                iounmap(mvi->peri_regs);
> +#endif
>        if (mvi->regs)
>                iounmap(mvi->regs);
>        if (mvi->shost)

maybe change this #if, and related #ifs, to

	#ifdef MVS_ENABLE_PERI

?


> @@ -1274,25 +1798,25 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy,
> enum phy_func func,
>        reg = mvi->regs + MVS_P0_SER_CTLSTAT + (phy_id * 4);
> 
>        switch (func) {
> -       case PHY_FUNC_SET_LINK_RATE: {
> -               struct sas_phy_linkrates *rates = funcdata;
> -               u32 lrmin = 0, lrmax = 0;
> +       case PHY_FUNC_SET_LINK_RATE:{
> +                       struct sas_phy_linkrates *rates = funcdata;
> +                       u32 lrmin = 0, lrmax = 0;
> 
> -               lrmin = (rates->minimum_linkrate << 8);
> -               lrmax = (rates->maximum_linkrate << 12);
> +                       lrmin = (rates->minimum_linkrate << 8);
> +                       lrmax = (rates->maximum_linkrate << 12);
> 
> -               tmp = readl(reg);
> -               if (lrmin) {
> -                       tmp &= ~(0xf << 8);
> -                       tmp |= lrmin;
> -               }
> -               if (lrmax) {
> -                       tmp &= ~(0xf << 12);
> -                       tmp |= lrmax;
> +                       tmp = readl(reg);
> +                       if (lrmin) {
> +                               tmp &= ~(0xf << 8);
> +                               tmp |= lrmin;
> +                       }
> +                       if (lrmax) {
> +                               tmp &= ~(0xf << 12);
> +                               tmp |= lrmax;
> +                       }
> +                       writel(tmp, reg);
> +                       break;

the C code indentation appears wrong (but again, maybe that's the email 
problem)


> @@ -1381,9 +1905,10 @@ static struct mvs_info * __devinit mvs_alloc(struct
> pci_dev *pdev,
> 
>        SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
>        mvi->shost->transportt = mvs_stt;
> -       mvi->shost->max_id = ~0;
> -       mvi->shost->max_lun = ~0;
> -       mvi->shost->max_cmd_len = ~0;
> +       mvi->shost->max_id = 21;
> +       mvi->shost->max_lun = 2;
> +       mvi->shost->max_channel = 0;
> +       mvi->shost->max_cmd_len = 16;

max_lun of 2?  that seems quite incorrect.  your hardware does not have 
that limit, AFAICS.



> @@ -1476,13 +2008,13 @@ err_out:
>        return NULL;
>  }
> 
> -static u32 mvs_cr32(void __iomem *regs, u32 addr)
> +static inline u32 mvs_cr32(void __iomem *regs, u32 addr)
>  {
>        mw32(CMD_ADDR, addr);
>        return mr32(CMD_DATA);
>  }
> 
> -static void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
> +static inline void mvs_cw32(void __iomem *regs, u32 addr, u32 val)
>  {
>        mw32(CMD_ADDR, addr);
>        mw32(CMD_DATA, val);

there is no need for explicit inlining here.  if its useful to inline, 
let the compiler make that decision.

it's marked 'static', which is sufficient to enable the compiler to do 
module-scoped optimizations.


> @@ -1547,6 +2079,174 @@ static void __devinit mvs_phy_hacks(struct mvs_info
> *mvi)
>        tmp &= 0x1fffffff;
>        tmp |= (2U << 29);      /* 8 ms retry */
>        mvs_cw32(regs, CMD_PHY_TIMER, tmp);
> +
> +       /* TEST - for phy decoding error, adjust voltage levels */
> +       mw32(P0_VSR_ADDR + 0, 0x8);
> +       mw32(P0_VSR_DATA + 0, 0x2F0);
> +
> +       mw32(P0_VSR_ADDR + 8, 0x8);
> +       mw32(P0_VSR_DATA + 8, 0x2F0);
> +
> +       mw32(P0_VSR_ADDR + 16, 0x8);
> +       mw32(P0_VSR_DATA + 16, 0x2F0);
> +
> +       mw32(P0_VSR_ADDR + 24, 0x8);
> +       mw32(P0_VSR_DATA + 24, 0x2F0);
> +
> +}

is this test code needed in the submitted driver?



> +               /* workaround for HW phy decoding error on 1.5g disk drive */
> +               WRITE_PORT_VSR_ADDR(i, 0x06);
> +               tmp = READ_PORT_VSR_DATA(i);
> +               if (((phy->phystatus & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
> +                    PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
> +                       SAS_LINK_RATE_1_5_GBPS)
> +                       tmp &= ~0x20000000;
> +               else
> +                       tmp |= 0x20000000;
> +               WRITE_PORT_VSR_DATA(i, tmp);
> +
> +       }
> +       phy->irqstatus = READ_PORT_IRQ_STAT(i);

replace 0x20000000 with a named constant



>  static int __devinit mvs_hw_init(struct mvs_info *mvi)
> @@ -1559,6 +2259,7 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
>        mw32(GBL_CTL, 0);
>        tmp = mr32(GBL_CTL);
> 
> +       /*ResetController */


	/* reset controller */

it's not a function, and whitespace makes things more readable :)


> @@ -1590,13 +2290,24 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
>                return -EBUSY;
>        }
> 
> +       /*InitChip */

ditto



>        /* make sure RST is set; HBA_RST /should/ have done that for us */
> -       cctl = mr32(CTL);
> +       cctl = mr32(CTL);       /*MVS_CTL */
>        if (cctl & CCTL_RST)
>                cctl &= ~CCTL_RST;
>        else
>                mw32_f(CTL, cctl | CCTL_RST);
> 
> +       pci_read_config_dword(mvi->pdev, PCI_COMMAND, &tmp);
> +       /*MV_PCI_DEV_EN */
> +       tmp |= PCI_COMMAND_IO | PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER;
> +       pci_write_config_dword(mvi->pdev, PCI_COMMAND, tmp);

are you sure this wasn't just copied from another driver?

pci_enable_device() turns on PCI_COMMAND_IO and PCI_COMMAND_MEMORY, and 
pci_set_master() turns on PCI_COMMAND_MASTER.

In general, you should not need to twiddle PCI_COMMAND register this 
way, it has already been done for you.


> @@ -1609,6 +2320,9 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
> 
>        mw32_f(CTL, cctl);
> 
> +       /* reset control */
> +       mw32(PCS, 0);           /*MVS_PCS */
> +
>        mvs_phy_hacks(mvi);
> 

request improved comment :)  or simply delete, if it is redundant to 
"reset control" comment



Overall:  no major complaints or objections, only minor stuff.  After 
fixing all the minor stuff, the main issue is getting your email set up 
correctly to send patches.

	Jeff





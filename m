From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH v3 1/6] scsi: ufs: wrap the i/o access operations
Date: Tue, 07 May 2013 12:52:53 +0900
Message-ID: <001201ce4ad6$5a746f80$0f5d4e80$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <001101ce4a1b$c255ac10$47010430$%jun@samsung.com>
 <CALMYJDts4=UHuTmk22YZOAQqjjk=yxUZTph6_5_i0sqgK=_L3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:29038 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758072Ab3EGDw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 23:52:56 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MME00JR5TG6G9J0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 07 May 2013 12:52:54 +0900 (KST)
In-reply-to: <CALMYJDts4=UHuTmk22YZOAQqjjk=yxUZTph6_5_i0sqgK=_L3w@mail.gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Santosh Y' <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Tuesday, May 07, 2013, Santosh Y wrote:
> On Mon, May 6, 2013 at 11:07 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > Simplify operations with hiding mmio_base.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > Tested-by: Maya Erez <merez@codeaurora.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c |  105 +++++++++++++++++++--------------------------
> >  drivers/scsi/ufs/ufshcd.h |    7 +++-
> >  2 files changed, 50 insertions(+), 62 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index f244812..cf7c8e4 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -71,7 +71,7 @@ enum {
> >   */
> >  static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
> >  {
> > -       return readl(hba->mmio_base + REG_UFS_VERSION);
> > +       return ufshcd_readl(hba, REG_UFS_VERSION);
> >  }
> >
> >  /**
> > @@ -130,8 +130,7 @@ static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
> >   */
> >  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
> >  {
> > -       writel(~(1 << pos),
> > -               (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_CLEAR));
> > +       ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> >  }
> >
> >  /**
> > @@ -165,7 +164,7 @@ static inline int ufshcd_get_lists_status(u32 reg)
> >   */
> >  static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
> >  {
> > -       return readl(hba->mmio_base + REG_UIC_COMMAND_ARG_2) &
> > +       return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
> >                MASK_UIC_COMMAND_RESULT;
> >  }
> >
> > @@ -238,18 +237,15 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
> >  {
> >         switch (option) {
> >         case INT_AGGR_RESET:
> > -               writel((INT_AGGR_ENABLE |
> > -                       INT_AGGR_COUNTER_AND_TIMER_RESET),
> > -                       (hba->mmio_base +
> > -                        REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
> > +               ufshcd_writel(hba, INT_AGGR_ENABLE |
> > +                             INT_AGGR_COUNTER_AND_TIMER_RESET,
> > +                             REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
> >                 break;
> >         case INT_AGGR_CONFIG:
> > -               writel((INT_AGGR_ENABLE |
> > -                       INT_AGGR_PARAM_WRITE |
> > -                       INT_AGGR_COUNTER_THRESHOLD_VALUE |
> > -                       INT_AGGR_TIMEOUT_VALUE),
> > -                       (hba->mmio_base +
> > -                        REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
> > +               ufshcd_writel(hba, INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
> > +                             INT_AGGR_COUNTER_THRESHOLD_VALUE |
> > +                             INT_AGGR_TIMEOUT_VALUE,
> > +                             REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
> >                 break;
> >         }
> >  }
> > @@ -262,12 +258,10 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
> >   */
> >  static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
> >  {
> > -       writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
> > -              (hba->mmio_base +
> > -               REG_UTP_TASK_REQ_LIST_RUN_STOP));
> > -       writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
> > -              (hba->mmio_base +
> > -               REG_UTP_TRANSFER_REQ_LIST_RUN_STOP));
> > +       ufshcd_writel(hba, UTP_TASK_REQ_LIST_RUN_STOP_BIT,
> > +                     REG_UTP_TASK_REQ_LIST_RUN_STOP);
> > +       ufshcd_writel(hba, UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
> > +                     REG_UTP_TRANSFER_REQ_LIST_RUN_STOP);
> >  }
> >
> >  /**
> > @@ -276,7 +270,7 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
> >   */
> >  static inline void ufshcd_hba_start(struct ufs_hba *hba)
> >  {
> > -       writel(CONTROLLER_ENABLE , (hba->mmio_base + REG_CONTROLLER_ENABLE));
> > +       ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
> >  }
> >
> >  /**
> > @@ -287,7 +281,7 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
> >   */
> >  static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
> >  {
> > -       return (readl(hba->mmio_base + REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
> > +       return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
> >  }
> >
> >  /**
> > @@ -299,8 +293,7 @@ static inline
> >  void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> >  {
> >         __set_bit(task_tag, &hba->outstanding_reqs);
> > -       writel((1 << task_tag),
> > -              (hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL));
> > +       ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >  }
> >
> >  /**
> > @@ -381,8 +374,7 @@ void ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> >   */
> >  static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
> >  {
> > -       hba->capabilities =
> > -               readl(hba->mmio_base + REG_CONTROLLER_CAPABILITIES);
> > +       hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> >
> >         /* nutrs and nutmrs are 0 based values */
> >         hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> > @@ -399,16 +391,13 @@ static inline void
> >  ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
> >  {
> >         /* Write Args */
> > -       writel(uic_cmnd->argument1,
> > -             (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
> > -       writel(uic_cmnd->argument2,
> > -             (hba->mmio_base + REG_UIC_COMMAND_ARG_2));
> > -       writel(uic_cmnd->argument3,
> > -             (hba->mmio_base + REG_UIC_COMMAND_ARG_3));
> > +       ufshcd_writel(hba, uic_cmnd->argument1, REG_UIC_COMMAND_ARG_1);
> > +       ufshcd_writel(hba, uic_cmnd->argument2, REG_UIC_COMMAND_ARG_2);
> > +       ufshcd_writel(hba, uic_cmnd->argument3, REG_UIC_COMMAND_ARG_3);
> >
> >         /* Write UIC Cmd */
> > -       writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
> > -              (hba->mmio_base + REG_UIC_COMMAND));
> > +       ufshcd_writel(hba, uic_cmnd->command & COMMAND_OPCODE_MASK,
> > +                     REG_UIC_COMMAND);
> >  }
> >
> >  /**
> > @@ -460,16 +449,15 @@ static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
> >  {
> >         switch (option) {
> >         case UFSHCD_INT_ENABLE:
> > -               writel(hba->int_enable_mask,
> > -                     (hba->mmio_base + REG_INTERRUPT_ENABLE));
> > +               ufshcd_writel(hba, hba->int_enable_mask, REG_INTERRUPT_ENABLE);
> >                 break;
> >         case UFSHCD_INT_DISABLE:
> >                 if (hba->ufs_version == UFSHCI_VERSION_10)
> > -                       writel(INTERRUPT_DISABLE_MASK_10,
> > -                             (hba->mmio_base + REG_INTERRUPT_ENABLE));
> > +                       ufshcd_writel(hba, INTERRUPT_DISABLE_MASK_10,
> > +                                     REG_INTERRUPT_ENABLE);
> >                 else
> > -                       writel(INTERRUPT_DISABLE_MASK_11,
> > -                              (hba->mmio_base + REG_INTERRUPT_ENABLE));
> > +                       ufshcd_writel(hba, INTERRUPT_DISABLE_MASK_11,
> > +                                     REG_INTERRUPT_ENABLE);
> >                 break;
> >         }
> >  }
> > @@ -940,7 +928,7 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
> >         unsigned long flags;
> >
> >         /* check if controller is ready to accept UIC commands */
> > -       if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
> > +       if ((ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> >             UIC_COMMAND_READY) == 0x0) {
> >                 dev_err(hba->dev,
> >                         "Controller not ready"
> > @@ -985,7 +973,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
> >         u32 reg;
> >
> >         /* check if device present */
> > -       reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
> > +       reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
> >         if (!ufshcd_is_device_present(reg)) {
> >                 dev_err(hba->dev, "cc: Device not present\n");
> >                 err = -ENXIO;
> > @@ -1107,14 +1095,14 @@ static int ufshcd_initialize_hba(struct ufs_hba *hba)
> >                 return -EIO;
> >
> >         /* Configure UTRL and UTMRL base address registers */
> > -       writel(lower_32_bits(hba->utrdl_dma_addr),
> > -              (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
> > -       writel(upper_32_bits(hba->utrdl_dma_addr),
> > -              (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
> > -       writel(lower_32_bits(hba->utmrdl_dma_addr),
> > -              (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
> > -       writel(upper_32_bits(hba->utmrdl_dma_addr),
> > -              (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
> > +       ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
> > +                     REG_UTP_TRANSFER_REQ_LIST_BASE_L);
> > +       ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
> > +                     REG_UTP_TRANSFER_REQ_LIST_BASE_H);
> > +       ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
> > +                     REG_UTP_TASK_REQ_LIST_BASE_L);
> > +       ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
> > +                     REG_UTP_TASK_REQ_LIST_BASE_H);
> >
> >         /* Initialize unipro link startup procedure */
> >         return ufshcd_dme_link_startup(hba);
> > @@ -1427,8 +1415,7 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
> >         int index;
> >
> >         lrb = hba->lrb;
> > -       tr_doorbell =
> > -               readl(hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL);
> > +       tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> >         completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
> >
> >         for (index = 0; index < hba->nutrs; index++) {
> > @@ -1502,9 +1489,7 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
> >                 goto fatal_eh;
> >
> >         if (hba->errors & UIC_ERROR) {
> > -
> > -               reg = readl(hba->mmio_base +
> > -                           REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
> > +               reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
> >                 if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> >                         goto fatal_eh;
> >         }
> > @@ -1522,7 +1507,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
> >  {
> >         u32 tm_doorbell;
> >
> > -       tm_doorbell = readl(hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL);
> > +       tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> >         hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
> >         wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
> >  }
> > @@ -1563,15 +1548,14 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
> >         struct ufs_hba *hba = __hba;
> >
> >         spin_lock(hba->host->host_lock);
> > -       intr_status = readl(hba->mmio_base + REG_INTERRUPT_STATUS);
> > +       intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> >
> >         if (intr_status) {
> >                 ufshcd_sl_intr(hba, intr_status);
> >
> >                 /* If UFSHCI 1.0 then clear interrupt status register */
> >                 if (hba->ufs_version == UFSHCI_VERSION_10)
> > -                       writel(intr_status,
> > -                              (hba->mmio_base + REG_INTERRUPT_STATUS));
> > +                       ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
> >                 retval = IRQ_HANDLED;
> >         }
> >         spin_unlock(hba->host->host_lock);
> > @@ -1636,8 +1620,7 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
> >
> >         /* send command to the controller */
> >         __set_bit(free_slot, &hba->outstanding_tasks);
> > -       writel((1 << free_slot),
> > -              (hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL));
> > +       ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
> >
> >         spin_unlock_irqrestore(host->host_lock, flags);
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 336980b..6429bed 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -204,6 +204,11 @@ struct ufs_hba {
> >         struct ufs_query query;
> >  };
> >
> > +#define ufshcd_writel(hba, val, reg)   \
> > +       writel((val), (hba)->mmio_base + (reg))
> > +#define ufshcd_readl(hba, reg) \
> > +       readl((hba)->mmio_base + (reg))
> > +
> >  int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
> >                         unsigned int);
> >  void ufshcd_remove(struct ufs_hba *);
> > @@ -214,7 +219,7 @@ void ufshcd_remove(struct ufs_hba *);
> >   */
> >  static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> >  {
> > -       writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> > +       ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
> >  }
> >
> >  #endif /* End of Header */
> > --
> > 1.7.0.4
> >
> 
> Still git throws the same error "fatal: cannot convert from
> ks_c_5601-1987 to UTF-8". Please check it for all the patches.
Um...
Ok. Let me send test one for you, first.

Thanks,
Seungwon Jeon

> 
> --
> ~Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


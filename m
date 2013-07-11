From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [RFC/PATCH 4/4] block: Add URGENT request notification support to
 CFQ scheduler
Date: Thu, 11 Jul 2013 19:03:39 +0530
Message-ID: <CALMYJDs20ne9=NxFWYLgeK-j0yWhiOUcBO7bvyWWy4fVNw0c1w@mail.gmail.com>
References: <1373547671-2779-1-git-send-email-tlinder@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1373547671-2779-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-mmc-owner@vger.kernel.org
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: axboe@kernel.dk, linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, "open list:UNIVERSAL FLASH S..." <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 11, 2013 at 6:31 PM, Tanya Brokhman <tlinder@codeaurora.org> wrote:
> When the scheduler reports to the block layer that there is an urgent
> request pending, the device driver may decide to stop the transmission
> of the current request in order to handle the urgent one. This is done
> in order to reduce the latency of an urgent request. For example:
> long WRITE may be stopped to handle an urgent READ.
>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3ab3a62..705f4f9 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2090,7 +2090,10 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
>
>                 cpu = part_stat_lock();
>                 part = req->part;
> -               part_stat_add(cpu, part, sectors[rw], bytes >> 9);
> +               if (part == NULL)
> +                       pr_err("%s: YANIV - BUG START", __func__);
> +               else
> +                       part_stat_add(cpu, part, sectors[rw], bytes >> 9);
>                 part_stat_unlock();
>         }
>  }
> @@ -2111,12 +2114,13 @@ static void blk_account_io_done(struct request *req)
>                 cpu = part_stat_lock();
>                 part = req->part;
>
> -               part_stat_inc(cpu, part, ios[rw]);
> -               part_stat_add(cpu, part, ticks[rw], duration);
> -               part_round_stats(cpu, part);
> -               part_dec_in_flight(part, rw);
> -
> -               hd_struct_put(part);
> +               if (req->part != NULL) {
> +                       part_stat_inc(cpu, part, ios[rw]);
> +                       part_stat_add(cpu, part, ticks[rw], duration);
> +                       part_round_stats(cpu, part);
> +                       part_dec_in_flight(part, rw);
> +                       hd_struct_put(part);
> +               }
>                 part_stat_unlock();
>         }
>  }
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d5bbdcf..f936cb9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -320,6 +320,9 @@ struct cfq_data {
>         unsigned long workload_expires;
>         struct cfq_group *serving_group;
>
> +       unsigned int nr_urgent_pending;
> +       unsigned int nr_urgent_in_flight;
> +
>         /*
>          * Each priority tree is sorted by next_request position.  These
>          * trees are used when determining if two or more queues are
> @@ -2783,6 +2786,14 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>         (RQ_CFQG(rq))->dispatched++;
>         elv_dispatch_sort(q, rq);
>
> +       if (rq->cmd_flags & REQ_URGENT) {
> +               if (!cfqd->nr_urgent_pending)
> +                       WARN_ON(1);
> +               else
> +                       cfqd->nr_urgent_pending--;
> +               cfqd->nr_urgent_in_flight++;
> +       }
> +
>         cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
>         cfqq->nr_sectors += blk_rq_sectors(rq);
>         cfqg_stats_update_dispatch(cfqq->cfqg, blk_rq_bytes(rq), rq->cmd_flags);
> @@ -3909,6 +3920,68 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>         }
>  }
>
> +/*
> + * Called when a request (rq) is reinserted (to cfqq). Check if there's
> + * something we should do about it
> + */
> +static void
> +cfq_rq_requeued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> +               struct request *rq)
> +{
> +       struct cfq_io_cq *cic = RQ_CIC(rq);
> +
> +       cfqd->rq_queued++;
> +       if (rq->cmd_flags & REQ_PRIO)
> +               cfqq->prio_pending++;
> +
> +       cfqq->dispatched--;
> +       (RQ_CFQG(rq))->dispatched--;
> +
> +       cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
> +
> +       cfq_update_io_thinktime(cfqd, cfqq, cic);
> +       cfq_update_io_seektime(cfqd, cfqq, rq);
> +       cfq_update_idle_window(cfqd, cfqq, cic);
> +
> +       cfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
> +
> +       if (cfqq == cfqd->active_queue) {
> +               if (cfq_cfqq_wait_request(cfqq)) {
> +                       if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
> +                           cfqd->busy_queues > 1) {
> +                               cfq_del_timer(cfqd, cfqq);
> +                               cfq_clear_cfqq_wait_request(cfqq);
> +                       } else {
> +                               cfqg_stats_update_idle_time(cfqq->cfqg);
> +                               cfq_mark_cfqq_must_dispatch(cfqq);
> +                       }
> +               }
> +       } else if (cfq_should_preempt(cfqd, cfqq, rq)) {
> +               cfq_preempt_queue(cfqd, cfqq);
> +       }
> +}
> +
> +static int cfq_reinsert_request(struct request_queue *q, struct request *rq)
> +{
> +       struct cfq_data *cfqd = q->elevator->elevator_data;
> +       struct cfq_queue *cfqq = RQ_CFQQ(rq);
> +
> +       if (!cfqq || cfqq->cfqd != cfqd)
> +               return -EIO;
> +
> +       cfq_log_cfqq(cfqd, cfqq, "re-insert_request");
> +       list_add(&rq->queuelist, &cfqq->fifo);
> +       cfq_add_rq_rb(rq);
> +
> +       cfq_rq_requeued(cfqd, cfqq, rq);
> +       if (rq->cmd_flags & REQ_URGENT) {
> +                       if (cfqd->nr_urgent_in_flight)
> +                               cfqd->nr_urgent_in_flight--;
> +                       cfqd->nr_urgent_pending++;
> +       }
> +       return 0;
> +}
> +
>  static void cfq_insert_request(struct request_queue *q, struct request *rq)
>  {
>         struct cfq_data *cfqd = q->elevator->elevator_data;
> @@ -3923,6 +3996,43 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>         cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
>                                  rq->cmd_flags);
>         cfq_rq_enqueued(cfqd, cfqq, rq);
> +
> +       if (rq->cmd_flags & REQ_URGENT) {
> +               WARN_ON(1);
> +               blk_dump_rq_flags(rq, "");
> +               rq->cmd_flags &= ~REQ_URGENT;
> +       }
> +
> +       /*
> +        * Request is considered URGENT if:
> +        * 1. The queue being served is of a lower IO priority then the new
> +        *    request
> +        * OR:
> +        * 2. The workload being performed is ASYNC
> +        * Only READ requests may be considered as URGENT
> +        */
> +       if ((cfqd->active_queue &&
> +                cfqq->ioprio_class < cfqd->active_queue->ioprio_class) ||
> +               (cfqd->serving_wl_type == ASYNC_WORKLOAD &&
> +                rq_data_dir(rq) == READ)) {
> +               rq->cmd_flags |= REQ_URGENT;
> +               cfqd->nr_urgent_pending++;
> +       }
> +}
> +
> +/**
> + * cfq_urgent_pending() - Return TRUE if there is an urgent
> + *                       request on scheduler
> + * @q: requests queue
> + */
> +static bool cfq_urgent_pending(struct request_queue *q)
> +{
> +       struct cfq_data *cfqd = q->elevator->elevator_data;
> +
> +       if (cfqd->nr_urgent_pending && !cfqd->nr_urgent_in_flight)
> +               return true;
> +
> +       return false;
>  }
>
>  /*
> @@ -4006,6 +4116,14 @@ static void cfq_completed_request(struct request_queue *q, struct request *rq)
>         const int sync = rq_is_sync(rq);
>         unsigned long now;
>
> +       if (rq->cmd_flags & REQ_URGENT) {
> +               if (!cfqd->nr_urgent_in_flight)
> +                       WARN_ON(1);
> +               else
> +                       cfqd->nr_urgent_in_flight--;
> +               rq->cmd_flags &= ~REQ_URGENT;
> +       }
> +
>         now = jiffies;
>         cfq_log_cfqq(cfqd, cfqq, "complete rqnoidle %d",
>                      !!(rq->cmd_flags & REQ_NOIDLE));
> @@ -4550,6 +4668,8 @@ static struct elevator_type iosched_cfq = {
>                 .elevator_bio_merged_fn =       cfq_bio_merged,
>                 .elevator_dispatch_fn =         cfq_dispatch_requests,
>                 .elevator_add_req_fn =          cfq_insert_request,
> +               .elevator_reinsert_req_fn       = cfq_reinsert_request,
> +               .elevator_is_urgent_fn          = cfq_urgent_pending,
>                 .elevator_activate_req_fn =     cfq_activate_request,
>                 .elevator_deactivate_req_fn =   cfq_deactivate_request,
>                 .elevator_completed_req_fn =    cfq_completed_request,
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b743bd6..c32a478 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -33,16 +33,8 @@
>   * this program.
>   */
>
> -#include <linux/async.h>
> -
>  #include "ufshcd.h"
>
> -#define UFSHCD_ENABLE_INTRS    (UTP_TRANSFER_REQ_COMPL |\
> -                                UTP_TASK_REQ_COMPL |\
> -                                UFSHCD_ERROR_MASK)
> -/* UIC command timeout, unit: ms */
> -#define UIC_CMD_TIMEOUT        500
> -
>  enum {
>         UFSHCD_MAX_CHANNEL      = 0,
>         UFSHCD_MAX_ID           = 1,
> @@ -72,20 +64,6 @@ enum {
>  };
>
>  /**
> - * ufshcd_get_intr_mask - Get the interrupt bit mask
> - * @hba - Pointer to adapter instance
> - *
> - * Returns interrupt bit mask per version
> - */
> -static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
> -{
> -       if (hba->ufs_version == UFSHCI_VERSION_10)
> -               return INTERRUPT_MASK_ALL_VER_10;
> -       else
> -               return INTERRUPT_MASK_ALL_VER_11;
> -}
> -
> -/**
>   * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
>   * @hba - Pointer to adapter instance
>   *
> @@ -93,7 +71,7 @@ static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
>   */
>  static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
>  {
> -       return ufshcd_readl(hba, REG_UFS_VERSION);
> +       return readl(hba->mmio_base + REG_UFS_VERSION);
>  }
>
>  /**
> @@ -152,7 +130,8 @@ static inline int ufshcd_get_tm_free_slot(struct ufs_hba *hba)
>   */
>  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -       ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +       writel(~(1 << pos),
> +               (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_CLEAR));
>  }
>
>  /**
> @@ -186,11 +165,43 @@ static inline int ufshcd_get_lists_status(u32 reg)
>   */
>  static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
>  {
> -       return ufshcd_readl(hba, REG_UIC_COMMAND_ARG_2) &
> +       return readl(hba->mmio_base + REG_UIC_COMMAND_ARG_2) &
>                MASK_UIC_COMMAND_RESULT;
>  }
>
>  /**
> + * ufshcd_free_hba_memory - Free allocated memory for LRB, request
> + *                         and task lists
> + * @hba: Pointer to adapter instance
> + */
> +static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
> +{
> +       size_t utmrdl_size, utrdl_size, ucdl_size;
> +
> +       kfree(hba->lrb);
> +
> +       if (hba->utmrdl_base_addr) {
> +               utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
> +               dma_free_coherent(hba->dev, utmrdl_size,
> +                                 hba->utmrdl_base_addr, hba->utmrdl_dma_addr);
> +       }
> +
> +       if (hba->utrdl_base_addr) {
> +               utrdl_size =
> +               (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
> +               dma_free_coherent(hba->dev, utrdl_size,
> +                                 hba->utrdl_base_addr, hba->utrdl_dma_addr);
> +       }
> +
> +       if (hba->ucdl_base_addr) {
> +               ucdl_size =
> +               (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
> +               dma_free_coherent(hba->dev, ucdl_size,
> +                                 hba->ucdl_base_addr, hba->ucdl_dma_addr);
> +       }
> +}
> +
> +/**
>   * ufshcd_is_valid_req_rsp - checks if controller TR response is valid
>   * @ucd_rsp_ptr: pointer to response UPIU
>   *
> @@ -232,15 +243,18 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
>  {
>         switch (option) {
>         case INT_AGGR_RESET:
> -               ufshcd_writel(hba, INT_AGGR_ENABLE |
> -                             INT_AGGR_COUNTER_AND_TIMER_RESET,
> -                             REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
> +               writel((INT_AGGR_ENABLE |
> +                       INT_AGGR_COUNTER_AND_TIMER_RESET),
> +                       (hba->mmio_base +
> +                        REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
>                 break;
>         case INT_AGGR_CONFIG:
> -               ufshcd_writel(hba, INT_AGGR_ENABLE | INT_AGGR_PARAM_WRITE |
> -                             INT_AGGR_COUNTER_THRESHOLD_VALUE |
> -                             INT_AGGR_TIMEOUT_VALUE,
> -                             REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL);
> +               writel((INT_AGGR_ENABLE |
> +                       INT_AGGR_PARAM_WRITE |
> +                       INT_AGGR_COUNTER_THRESHOLD_VALUE |
> +                       INT_AGGR_TIMEOUT_VALUE),
> +                       (hba->mmio_base +
> +                        REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL));
>                 break;
>         }
>  }
> @@ -253,10 +267,12 @@ ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
>   */
>  static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
>  {
> -       ufshcd_writel(hba, UTP_TASK_REQ_LIST_RUN_STOP_BIT,
> -                     REG_UTP_TASK_REQ_LIST_RUN_STOP);
> -       ufshcd_writel(hba, UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
> -                     REG_UTP_TRANSFER_REQ_LIST_RUN_STOP);
> +       writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
> +              (hba->mmio_base +
> +               REG_UTP_TASK_REQ_LIST_RUN_STOP));
> +       writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT,
> +              (hba->mmio_base +
> +               REG_UTP_TRANSFER_REQ_LIST_RUN_STOP));
>  }
>
>  /**
> @@ -265,7 +281,7 @@ static void ufshcd_enable_run_stop_reg(struct ufs_hba *hba)
>   */
>  static inline void ufshcd_hba_start(struct ufs_hba *hba)
>  {
> -       ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
> +       writel(CONTROLLER_ENABLE , (hba->mmio_base + REG_CONTROLLER_ENABLE));
>  }
>
>  /**
> @@ -276,7 +292,7 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
>   */
>  static inline int ufshcd_is_hba_active(struct ufs_hba *hba)
>  {
> -       return (ufshcd_readl(hba, REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
> +       return (readl(hba->mmio_base + REG_CONTROLLER_ENABLE) & 0x1) ? 0 : 1;
>  }
>
>  /**
> @@ -288,7 +304,8 @@ static inline
>  void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
>  {
>         __set_bit(task_tag, &hba->outstanding_reqs);
> -       ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +       writel((1 << task_tag),
> +              (hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL));
>  }
>
>  /**
> @@ -312,7 +329,8 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
>   */
>  static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
>  {
> -       hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
> +       hba->capabilities =
> +               readl(hba->mmio_base + REG_CONTROLLER_CAPABILITIES);
>
>         /* nutrs and nutmrs are 0 based values */
>         hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> @@ -321,119 +339,24 @@ static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
>  }
>
>  /**
> - * ufshcd_ready_for_uic_cmd - Check if controller is ready
> - *                            to accept UIC commands
> + * ufshcd_send_uic_command - Send UIC commands to unipro layers
>   * @hba: per adapter instance
> - * Return true on success, else false
> - */
> -static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
> -{
> -       if (ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY)
> -               return true;
> -       else
> -               return false;
> -}
> -
> -/**
> - * ufshcd_dispatch_uic_cmd - Dispatch UIC commands to unipro layers
> - * @hba: per adapter instance
> - * @uic_cmd: UIC command
> - *
> - * Mutex must be held.
> + * @uic_command: UIC command
>   */
>  static inline void
> -ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> +ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic_cmnd)
>  {
> -       WARN_ON(hba->active_uic_cmd);
> -
> -       hba->active_uic_cmd = uic_cmd;
> -
>         /* Write Args */
> -       ufshcd_writel(hba, uic_cmd->argument1, REG_UIC_COMMAND_ARG_1);
> -       ufshcd_writel(hba, uic_cmd->argument2, REG_UIC_COMMAND_ARG_2);
> -       ufshcd_writel(hba, uic_cmd->argument3, REG_UIC_COMMAND_ARG_3);
> +       writel(uic_cmnd->argument1,
> +             (hba->mmio_base + REG_UIC_COMMAND_ARG_1));
> +       writel(uic_cmnd->argument2,
> +             (hba->mmio_base + REG_UIC_COMMAND_ARG_2));
> +       writel(uic_cmnd->argument3,
> +             (hba->mmio_base + REG_UIC_COMMAND_ARG_3));
>
>         /* Write UIC Cmd */
> -       ufshcd_writel(hba, uic_cmd->command & COMMAND_OPCODE_MASK,
> -                     REG_UIC_COMMAND);
> -}
> -
> -/**
> - * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
> - * @hba: per adapter instance
> - * @uic_command: UIC command
> - *
> - * Must be called with mutex held.
> - * Returns 0 only if success.
> - */
> -static int
> -ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> -{
> -       int ret;
> -       unsigned long flags;
> -
> -       if (wait_for_completion_timeout(&uic_cmd->done,
> -                                       msecs_to_jiffies(UIC_CMD_TIMEOUT)))
> -               ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
> -       else
> -               ret = -ETIMEDOUT;
> -
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> -       hba->active_uic_cmd = NULL;
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
> -       return ret;
> -}
> -
> -/**
> - * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
> - * @hba: per adapter instance
> - * @uic_cmd: UIC command
> - *
> - * Identical to ufshcd_send_uic_cmd() expect mutex. Must be called
> - * with mutex held.
> - * Returns 0 only if success.
> - */
> -static int
> -__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> -{
> -       int ret;
> -       unsigned long flags;
> -
> -       if (!ufshcd_ready_for_uic_cmd(hba)) {
> -               dev_err(hba->dev,
> -                       "Controller not ready to accept UIC commands\n");
> -               return -EIO;
> -       }
> -
> -       init_completion(&uic_cmd->done);
> -
> -       spin_lock_irqsave(hba->host->host_lock, flags);
> -       ufshcd_dispatch_uic_cmd(hba, uic_cmd);
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
> -
> -       ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
> -
> -       return ret;
> -}
> -
> -/**
> - * ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
> - * @hba: per adapter instance
> - * @uic_cmd: UIC command
> - *
> - * Returns 0 only if success.
> - */
> -static int
> -ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
> -{
> -       int ret;
> -
> -       mutex_lock(&hba->uic_cmd_mutex);
> -       ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
> -       mutex_unlock(&hba->uic_cmd_mutex);
> -
> -       return ret;
> +       writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
> +              (hba->mmio_base + REG_UIC_COMMAND));
>  }
>
>  /**
> @@ -477,45 +400,26 @@ static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
>  }
>
>  /**
> - * ufshcd_enable_intr - enable interrupts
> - * @hba: per adapter instance
> - * @intrs: interrupt bits
> - */
> -static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
> -{
> -       u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> -
> -       if (hba->ufs_version == UFSHCI_VERSION_10) {
> -               u32 rw;
> -               rw = set & INTERRUPT_MASK_RW_VER_10;
> -               set = rw | ((set ^ intrs) & intrs);
> -       } else {
> -               set |= intrs;
> -       }
> -
> -       ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
> -}
> -
> -/**
> - * ufshcd_disable_intr - disable interrupts
> + * ufshcd_int_config - enable/disable interrupts
>   * @hba: per adapter instance
> - * @intrs: interrupt bits
> + * @option: interrupt option
>   */
> -static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
> +static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
>  {
> -       u32 set = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
> -
> -       if (hba->ufs_version == UFSHCI_VERSION_10) {
> -               u32 rw;
> -               rw = (set & INTERRUPT_MASK_RW_VER_10) &
> -                       ~(intrs & INTERRUPT_MASK_RW_VER_10);
> -               set = rw | ((set & intrs) & ~INTERRUPT_MASK_RW_VER_10);
> -
> -       } else {
> -               set &= ~intrs;
> +       switch (option) {
> +       case UFSHCD_INT_ENABLE:
> +               writel(hba->int_enable_mask,
> +                     (hba->mmio_base + REG_INTERRUPT_ENABLE));
> +               break;
> +       case UFSHCD_INT_DISABLE:
> +               if (hba->ufs_version == UFSHCI_VERSION_10)
> +                       writel(INTERRUPT_DISABLE_MASK_10,
> +                             (hba->mmio_base + REG_INTERRUPT_ENABLE));
> +               else
> +                       writel(INTERRUPT_DISABLE_MASK_11,
> +                              (hba->mmio_base + REG_INTERRUPT_ENABLE));
> +               break;
>         }
> -
> -       ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE);
>  }
>
>  /**
> @@ -658,10 +562,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>
>         /* Allocate memory for UTP command descriptors */
>         ucdl_size = (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs);
> -       hba->ucdl_base_addr = dmam_alloc_coherent(hba->dev,
> -                                                 ucdl_size,
> -                                                 &hba->ucdl_dma_addr,
> -                                                 GFP_KERNEL);
> +       hba->ucdl_base_addr = dma_alloc_coherent(hba->dev,
> +                                                ucdl_size,
> +                                                &hba->ucdl_dma_addr,
> +                                                GFP_KERNEL);
>
>         /*
>          * UFSHCI requires UTP command descriptor to be 128 byte aligned.
> @@ -681,10 +585,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>          * UFSHCI requires 1024 byte alignment of UTRD
>          */
>         utrdl_size = (sizeof(struct utp_transfer_req_desc) * hba->nutrs);
> -       hba->utrdl_base_addr = dmam_alloc_coherent(hba->dev,
> -                                                  utrdl_size,
> -                                                  &hba->utrdl_dma_addr,
> -                                                  GFP_KERNEL);
> +       hba->utrdl_base_addr = dma_alloc_coherent(hba->dev,
> +                                                 utrdl_size,
> +                                                 &hba->utrdl_dma_addr,
> +                                                 GFP_KERNEL);
>         if (!hba->utrdl_base_addr ||
>             WARN_ON(hba->utrdl_dma_addr & (PAGE_SIZE - 1))) {
>                 dev_err(hba->dev,
> @@ -697,10 +601,10 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>          * UFSHCI requires 1024 byte alignment of UTMRD
>          */
>         utmrdl_size = sizeof(struct utp_task_req_desc) * hba->nutmrs;
> -       hba->utmrdl_base_addr = dmam_alloc_coherent(hba->dev,
> -                                                   utmrdl_size,
> -                                                   &hba->utmrdl_dma_addr,
> -                                                   GFP_KERNEL);
> +       hba->utmrdl_base_addr = dma_alloc_coherent(hba->dev,
> +                                                  utmrdl_size,
> +                                                  &hba->utmrdl_dma_addr,
> +                                                  GFP_KERNEL);
>         if (!hba->utmrdl_base_addr ||
>             WARN_ON(hba->utmrdl_dma_addr & (PAGE_SIZE - 1))) {
>                 dev_err(hba->dev,
> @@ -709,15 +613,14 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
>         }
>
>         /* Allocate memory for local reference block */
> -       hba->lrb = devm_kzalloc(hba->dev,
> -                               hba->nutrs * sizeof(struct ufshcd_lrb),
> -                               GFP_KERNEL);
> +       hba->lrb = kcalloc(hba->nutrs, sizeof(struct ufshcd_lrb), GFP_KERNEL);
>         if (!hba->lrb) {
>                 dev_err(hba->dev, "LRB Memory allocation failed\n");
>                 goto out;
>         }
>         return 0;
>  out:
> +       ufshcd_free_hba_memory(hba);
>         return -ENOMEM;
>  }
>
> @@ -771,7 +674,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>                 utrdlp[i].prd_table_offset =
>                                 cpu_to_le16((prdt_offset >> 2));
>                 utrdlp[i].response_upiu_length =
> -                               cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> +                               cpu_to_le16(ALIGNED_UPIU_SIZE);
>
>                 hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
>                 hba->lrb[i].ucd_cmd_ptr =
> @@ -796,16 +699,35 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
>   */
>  static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>  {
> -       struct uic_command uic_cmd = {0};
> -       int ret;
> -
> -       uic_cmd.command = UIC_CMD_DME_LINK_STARTUP;
> +       struct uic_command *uic_cmd;
> +       unsigned long flags;
>
> -       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> -       if (ret)
> +       /* check if controller is ready to accept UIC commands */
> +       if (((readl(hba->mmio_base + REG_CONTROLLER_STATUS)) &
> +           UIC_COMMAND_READY) == 0x0) {
>                 dev_err(hba->dev,
> -                       "dme-link-startup: error code %d\n", ret);
> -       return ret;
> +                       "Controller not ready"
> +                       " to accept UIC commands\n");
> +               return -EIO;
> +       }
> +
> +       spin_lock_irqsave(hba->host->host_lock, flags);
> +
> +       /* form UIC command */
> +       uic_cmd = &hba->active_uic_cmd;
> +       uic_cmd->command = UIC_CMD_DME_LINK_STARTUP;
> +       uic_cmd->argument1 = 0;
> +       uic_cmd->argument2 = 0;
> +       uic_cmd->argument3 = 0;
> +
> +       /* enable UIC related interrupts */
> +       hba->int_enable_mask |= UIC_COMMAND_COMPL;
> +       ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
> +
> +       /* sending UIC commands to controller */
> +       ufshcd_send_uic_command(hba, uic_cmd);
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +       return 0;
>  }
>
>  /**
> @@ -814,10 +736,9 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
>   *
>   * To bring UFS host controller to operational state,
>   * 1. Check if device is present
> - * 2. Enable required interrupts
> - * 3. Configure interrupt aggregation
> - * 4. Program UTRL and UTMRL base addres
> - * 5. Configure run-stop-registers
> + * 2. Configure run-stop-registers
> + * 3. Enable required interrupts
> + * 4. Configure interrupt aggregation
>   *
>   * Returns 0 on success, non-zero value on failure
>   */
> @@ -827,29 +748,13 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>         u32 reg;
>
>         /* check if device present */
> -       reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
> +       reg = readl((hba->mmio_base + REG_CONTROLLER_STATUS));
>         if (!ufshcd_is_device_present(reg)) {
>                 dev_err(hba->dev, "cc: Device not present\n");
>                 err = -ENXIO;
>                 goto out;
>         }
>
> -       /* Enable required interrupts */
> -       ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
> -
> -       /* Configure interrupt aggregation */
> -       ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
> -
> -       /* Configure UTRL and UTMRL base address registers */
> -       ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
> -                       REG_UTP_TRANSFER_REQ_LIST_BASE_L);
> -       ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
> -                       REG_UTP_TRANSFER_REQ_LIST_BASE_H);
> -       ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
> -                       REG_UTP_TASK_REQ_LIST_BASE_L);
> -       ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
> -                       REG_UTP_TASK_REQ_LIST_BASE_H);
> -
>         /*
>          * UCRDY, UTMRLDY and UTRLRDY bits must be 1
>          * DEI, HEI bits must be 0
> @@ -863,11 +768,23 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
>                 goto out;
>         }
>
> +       /* Enable required interrupts */
> +       hba->int_enable_mask |= (UTP_TRANSFER_REQ_COMPL |
> +                                UIC_ERROR |
> +                                UTP_TASK_REQ_COMPL |
> +                                DEVICE_FATAL_ERROR |
> +                                CONTROLLER_FATAL_ERROR |
> +                                SYSTEM_BUS_FATAL_ERROR);
> +       ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
> +
> +       /* Configure interrupt aggregation */
> +       ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
> +
>         if (hba->ufshcd_state == UFSHCD_STATE_RESET)
>                 scsi_unblock_requests(hba->host);
>
>         hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
> -
> +       scsi_scan_host(hba->host);
>  out:
>         return err;
>  }
> @@ -936,28 +853,34 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
>  }
>
>  /**
> - * ufshcd_link_startup - Initialize unipro link startup
> + * ufshcd_initialize_hba - start the initialization process
>   * @hba: per adapter instance
>   *
> - * Returns 0 for success, non-zero in case of failure
> + * 1. Enable the controller via ufshcd_hba_enable.
> + * 2. Program the Transfer Request List Address with the starting address of
> + * UTRDL.
> + * 3. Program the Task Management Request List Address with starting address
> + * of UTMRDL.
> + *
> + * Returns 0 on success, non-zero value on failure.
>   */
> -static int ufshcd_link_startup(struct ufs_hba *hba)
> +static int ufshcd_initialize_hba(struct ufs_hba *hba)
>  {
> -       int ret;
> -
> -       /* enable UIC related interrupts */
> -       ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> -
> -       ret = ufshcd_dme_link_startup(hba);
> -       if (ret)
> -               goto out;
> -
> -       ret = ufshcd_make_hba_operational(hba);
> +       if (ufshcd_hba_enable(hba))
> +               return -EIO;
>
> -out:
> -       if (ret)
> -               dev_err(hba->dev, "link startup failed %d\n", ret);
> -       return ret;
> +       /* Configure UTRL and UTMRL base address registers */
> +       writel(lower_32_bits(hba->utrdl_dma_addr),
> +              (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_L));
> +       writel(upper_32_bits(hba->utrdl_dma_addr),
> +              (hba->mmio_base + REG_UTP_TRANSFER_REQ_LIST_BASE_H));
> +       writel(lower_32_bits(hba->utmrdl_dma_addr),
> +              (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_L));
> +       writel(upper_32_bits(hba->utmrdl_dma_addr),
> +              (hba->mmio_base + REG_UTP_TASK_REQ_LIST_BASE_H));
> +
> +       /* Initialize unipro link startup procedure */
> +       return ufshcd_dme_link_startup(hba);
>  }
>
>  /**
> @@ -997,19 +920,12 @@ static int ufshcd_do_reset(struct ufs_hba *hba)
>         hba->outstanding_reqs = 0;
>         hba->outstanding_tasks = 0;
>
> -       /* Host controller enable */
> -       if (ufshcd_hba_enable(hba)) {
> +       /* start the initialization process */
> +       if (ufshcd_initialize_hba(hba)) {
>                 dev_err(hba->dev,
>                         "Reset: Controller initialization failed\n");
>                 return FAILED;
>         }
> -
> -       if (ufshcd_link_startup(hba)) {
> -               dev_err(hba->dev,
> -                       "Reset: Link start-up failed\n");
> -               return FAILED;
> -       }
> -
>         return SUCCESS;
>  }
>
> @@ -1241,19 +1157,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  }
>
>  /**
> - * ufshcd_uic_cmd_compl - handle completion of uic command
> - * @hba: per adapter instance
> - */
> -static void ufshcd_uic_cmd_compl(struct ufs_hba *hba)
> -{
> -       if (hba->active_uic_cmd) {
> -               hba->active_uic_cmd->argument2 |=
> -                       ufshcd_get_uic_cmd_result(hba);
> -               complete(&hba->active_uic_cmd->done);
> -       }
> -}
> -
> -/**
>   * ufshcd_transfer_req_compl - handle SCSI and query command completion
>   * @hba: per adapter instance
>   */
> @@ -1266,7 +1169,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>         int index;
>
>         lrb = hba->lrb;
> -       tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> +       tr_doorbell =
> +               readl(hba->mmio_base + REG_UTP_TRANSFER_REQ_DOOR_BELL);
>         completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
>
>         for (index = 0; index < hba->nutrs; index++) {
> @@ -1293,6 +1197,28 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
>  }
>
>  /**
> + * ufshcd_uic_cc_handler - handle UIC command completion
> + * @work: pointer to a work queue structure
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static void ufshcd_uic_cc_handler (struct work_struct *work)
> +{
> +       struct ufs_hba *hba;
> +
> +       hba = container_of(work, struct ufs_hba, uic_workq);
> +
> +       if ((hba->active_uic_cmd.command == UIC_CMD_DME_LINK_STARTUP) &&
> +           !(ufshcd_get_uic_cmd_result(hba))) {
> +
> +               if (ufshcd_make_hba_operational(hba))
> +                       dev_err(hba->dev,
> +                               "cc: hba not operational state\n");
> +               return;
> +       }
> +}
> +
> +/**
>   * ufshcd_fatal_err_handler - handle fatal errors
>   * @hba: per adapter instance
>   */
> @@ -1318,7 +1244,9 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
>                 goto fatal_eh;
>
>         if (hba->errors & UIC_ERROR) {
> -               reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
> +
> +               reg = readl(hba->mmio_base +
> +                           REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
>                 if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
>                         goto fatal_eh;
>         }
> @@ -1336,7 +1264,7 @@ static void ufshcd_tmc_handler(struct ufs_hba *hba)
>  {
>         u32 tm_doorbell;
>
> -       tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
> +       tm_doorbell = readl(hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL);
>         hba->tm_condition = tm_doorbell ^ hba->outstanding_tasks;
>         wake_up_interruptible(&hba->ufshcd_tm_wait_queue);
>  }
> @@ -1353,7 +1281,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
>                 ufshcd_err_handler(hba);
>
>         if (intr_status & UIC_COMMAND_COMPL)
> -               ufshcd_uic_cmd_compl(hba);
> +               schedule_work(&hba->uic_workq);
>
>         if (intr_status & UTP_TASK_REQ_COMPL)
>                 ufshcd_tmc_handler(hba);
> @@ -1377,11 +1305,15 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
>         struct ufs_hba *hba = __hba;
>
>         spin_lock(hba->host->host_lock);
> -       intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
> +       intr_status = readl(hba->mmio_base + REG_INTERRUPT_STATUS);
>
>         if (intr_status) {
> -               ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
>                 ufshcd_sl_intr(hba, intr_status);
> +
> +               /* If UFSHCI 1.0 then clear interrupt status register */
> +               if (hba->ufs_version == UFSHCI_VERSION_10)
> +                       writel(intr_status,
> +                              (hba->mmio_base + REG_INTERRUPT_STATUS));
>                 retval = IRQ_HANDLED;
>         }
>         spin_unlock(hba->host->host_lock);
> @@ -1446,7 +1378,8 @@ ufshcd_issue_tm_cmd(struct ufs_hba *hba,
>
>         /* send command to the controller */
>         __set_bit(free_slot, &hba->outstanding_tasks);
> -       ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
> +       writel((1 << free_slot),
> +              (hba->mmio_base + REG_UTP_TASK_REQ_DOOR_BELL));
>
>         spin_unlock_irqrestore(host->host_lock, flags);
>
> @@ -1576,21 +1509,6 @@ out:
>         return err;
>  }
>
> -/**
> - * ufshcd_async_scan - asynchronous execution for link startup
> - * @data: data pointer to pass to this function
> - * @cookie: cookie data
> - */
> -static void ufshcd_async_scan(void *data, async_cookie_t cookie)
> -{
> -       struct ufs_hba *hba = (struct ufs_hba *)data;
> -       int ret;
> -
> -       ret = ufshcd_link_startup(hba);
> -       if (!ret)
> -               scsi_scan_host(hba->host);
> -}
> -
>  static struct scsi_host_template ufshcd_driver_template = {
>         .module                 = THIS_MODULE,
>         .name                   = UFSHCD,
> @@ -1651,6 +1569,17 @@ int ufshcd_resume(struct ufs_hba *hba)
>  EXPORT_SYMBOL_GPL(ufshcd_resume);
>
>  /**
> + * ufshcd_hba_free - free allocated memory for
> + *                     host memory space data structures
> + * @hba: per adapter instance
> + */
> +static void ufshcd_hba_free(struct ufs_hba *hba)
> +{
> +       iounmap(hba->mmio_base);
> +       ufshcd_free_hba_memory(hba);
> +}
> +
> +/**
>   * ufshcd_remove - de-allocate SCSI host and host memory space
>   *             data structure memory
>   * @hba - per adapter instance
> @@ -1658,8 +1587,10 @@ EXPORT_SYMBOL_GPL(ufshcd_resume);
>  void ufshcd_remove(struct ufs_hba *hba)
>  {
>         /* disable interrupts */
> -       ufshcd_disable_intr(hba, hba->intr_mask);
> +       ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
> +
>         ufshcd_hba_stop(hba);
> +       ufshcd_hba_free(hba);
>
>         scsi_remove_host(hba->host);
>         scsi_host_put(hba->host);
> @@ -1714,9 +1645,6 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>         /* Get UFS version supported by the controller */
>         hba->ufs_version = ufshcd_get_ufs_version(hba);
>
> -       /* Get Interrupt bit mask per version */
> -       hba->intr_mask = ufshcd_get_intr_mask(hba);
> -
>         /* Allocate memory for host memory space */
>         err = ufshcd_memory_alloc(hba);
>         if (err) {
> @@ -1739,46 +1667,45 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
>         init_waitqueue_head(&hba->ufshcd_tm_wait_queue);
>
>         /* Initialize work queues */
> +       INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
>         INIT_WORK(&hba->feh_workq, ufshcd_fatal_err_handler);
>
> -       /* Initialize UIC command mutex */
> -       mutex_init(&hba->uic_cmd_mutex);
> -
>         /* IRQ registration */
> -       err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
> +       err = request_irq(irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
>         if (err) {
>                 dev_err(hba->dev, "request irq failed\n");
> -               goto out_disable;
> +               goto out_lrb_free;
>         }
>
>         /* Enable SCSI tag mapping */
>         err = scsi_init_shared_tag_map(host, host->can_queue);
>         if (err) {
>                 dev_err(hba->dev, "init shared queue failed\n");
> -               goto out_disable;
> +               goto out_free_irq;
>         }
>
>         err = scsi_add_host(host, hba->dev);
>         if (err) {
>                 dev_err(hba->dev, "scsi_add_host failed\n");
> -               goto out_disable;
> +               goto out_free_irq;
>         }
>
> -       /* Host controller enable */
> -       err = ufshcd_hba_enable(hba);
> +       /* Initialization routine */
> +       err = ufshcd_initialize_hba(hba);
>         if (err) {
> -               dev_err(hba->dev, "Host controller enable failed\n");
> +               dev_err(hba->dev, "Initialization failed\n");
>                 goto out_remove_scsi_host;
>         }
> -
>         *hba_handle = hba;
>
> -       async_schedule(ufshcd_async_scan, hba);
> -
>         return 0;
>
>  out_remove_scsi_host:
>         scsi_remove_host(hba->host);
> +out_free_irq:
> +       free_irq(irq, hba);
> +out_lrb_free:
> +       ufshcd_free_hba_memory(hba);
>  out_disable:
>         scsi_host_put(host);
>  out_error:
> --
> 1.7.6
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundatio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

You will have to re-submit without the ufshcd changes :-)

-- 
~Santosh

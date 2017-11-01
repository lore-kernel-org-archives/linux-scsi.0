From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi: sas: Convert timers to use timer_setup()
Date: Wed, 1 Nov 2017 08:58:26 +0100
Message-ID: <CAMGffEmbxRfaU8W6c8ZSOAZeKnHXfeULc5pdhV1vnKZiHT53xA@mail.gmail.com>
References: <20171025100800.GA145125@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171025100800.GA145125@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, lindar_liu <lindar_liu@usish.com>, Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, Baoyou Xie <baoyou.xie@linaro.org>, Wei Yongjun <weiyongjun1@huawei.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2017 at 12:08 PM, Kees Cook <keescook@chromium.org> wrote:
> In preparation for unconditionally passing the struct timer_list pointer to
> all timer callbacks, switch to using the new timer_setup() and from_timer()
> to pass the timer pointer explicitly. This requires adding a pointer to
> hold the timer's target task, as there isn't a link back from slow_task.
>
> Cc: John Garry <john.garry@huawei.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Jack Wang <jinpu.wang@profitbricks.com>
> Cc: lindar_liu@usish.com
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
> Cc: Baoyou Xie <baoyou.xie@linaro.org>
> Cc: Wei Yongjun <weiyongjun1@huawei.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 14 ++++++--------
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  6 +++---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 24 +++++++++++-------------
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +-
>  drivers/scsi/libsas/sas_expander.c     |  8 ++++----
>  drivers/scsi/libsas/sas_init.c         |  3 ++-
>  drivers/scsi/libsas/sas_scsi_host.c    |  2 +-
>  drivers/scsi/mvsas/mv_init.c           |  3 +--
>  drivers/scsi/mvsas/mv_sas.c            | 15 +++++++--------
>  drivers/scsi/mvsas/mv_sas.h            |  1 -
>  drivers/scsi/pm8001/pm8001_sas.c       | 11 +++++------
>  include/scsi/libsas.h                  |  1 +
>  13 files changed, 42 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 07f4a4cfbec1..15692ea05ced 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -103,7 +103,6 @@ struct hisi_sas_phy {
>         struct hisi_sas_port    *port;
>         struct asd_sas_phy      sas_phy;
>         struct sas_identify     identify;
> -       struct timer_list       timer;
>         struct work_struct      phyup_ws;
>         u64             port_id; /* from hw */
>         u64             dev_sas_addr;
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 9e2990268f00..0d772a83fbe4 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -627,7 +627,6 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
>
>         phy->hisi_hba = hisi_hba;
>         phy->port = NULL;
> -       init_timer(&phy->timer);
>         sas_phy->enabled = (phy_no < hisi_hba->n_phy) ? 1 : 0;
>         sas_phy->class = SAS;
>         sas_phy->iproto = SAS_PROTOCOL_ALL;
> @@ -792,9 +791,10 @@ static void hisi_sas_task_done(struct sas_task *task)
>         complete(&task->slow_task->completion);
>  }
>
> -static void hisi_sas_tmf_timedout(unsigned long data)
> +static void hisi_sas_tmf_timedout(struct timer_list *t)
>  {
> -       struct sas_task *task = (struct sas_task *)data;
> +       struct sas_task_slow *slow = from_timer(slow, t, timer);
> +       struct sas_task *task = slow->task;
>         unsigned long flags;
>
>         spin_lock_irqsave(&task->task_state_lock, flags);
> @@ -833,8 +833,7 @@ static int hisi_sas_exec_internal_tmf_task(struct domain_device *device,
>                 }
>                 task->task_done = hisi_sas_task_done;
>
> -               task->slow_task->timer.data = (unsigned long) task;
> -               task->slow_task->timer.function = hisi_sas_tmf_timedout;
> +               task->slow_task->timer.function = (TIMER_FUNC_TYPE)hisi_sas_tmf_timedout;
>                 task->slow_task->timer.expires = jiffies + TASK_TIMEOUT*HZ;
>                 add_timer(&task->slow_task->timer);
>
> @@ -1445,8 +1444,7 @@ hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
>         task->dev = device;
>         task->task_proto = device->tproto;
>         task->task_done = hisi_sas_task_done;
> -       task->slow_task->timer.data = (unsigned long)task;
> -       task->slow_task->timer.function = hisi_sas_tmf_timedout;
> +       task->slow_task->timer.function = (TIMER_FUNC_TYPE)hisi_sas_tmf_timedout;
>         task->slow_task->timer.expires = jiffies + msecs_to_jiffies(110);
>         add_timer(&task->slow_task->timer);
>
> @@ -1875,7 +1873,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
>         hisi_hba->shost = shost;
>         SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
>
> -       init_timer(&hisi_hba->timer);
> +       timer_setup(&hisi_hba->timer, NULL, 0);
>
>         if (hisi_sas_get_fw_info(hisi_hba) < 0)
>                 goto err_out;
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index 08eca20b0b81..9385554e43a6 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -807,9 +807,9 @@ static void phy_hard_reset_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
>         start_phy_v1_hw(hisi_hba, phy_no);
>  }
>
> -static void start_phys_v1_hw(unsigned long data)
> +static void start_phys_v1_hw(struct timer_list *t)
>  {
> -       struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
> +       struct hisi_hba *hisi_hba = from_timer(hisi_hba, t, timer);
>         int i;
>
>         for (i = 0; i < hisi_hba->n_phy; i++) {
> @@ -828,7 +828,7 @@ static void phys_init_v1_hw(struct hisi_hba *hisi_hba)
>                 hisi_sas_phy_read32(hisi_hba, i, CHL_INT2_MSK);
>         }
>
> -       setup_timer(timer, start_phys_v1_hw, (unsigned long)hisi_hba);
> +       timer_setup(timer, start_phys_v1_hw, 0);
>         mod_timer(timer, jiffies + HZ);
>  }
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 779af979b6db..b1f097dabd01 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -728,7 +728,7 @@ enum {
>  #define ERR_ON_RX_PHASE(err_phase) (err_phase == 0x10 || \
>                 err_phase == 0x20 || err_phase == 0x40)
>
> -static void link_timeout_disable_link(unsigned long data);
> +static void link_timeout_disable_link(struct timer_list *t);
>
>  static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
>  {
> @@ -1270,9 +1270,9 @@ static void init_reg_v2_hw(struct hisi_hba *hisi_hba)
>                          upper_32_bits(hisi_hba->initial_fis_dma));
>  }
>
> -static void link_timeout_enable_link(unsigned long data)
> +static void link_timeout_enable_link(struct timer_list *t)
>  {
> -       struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
> +       struct hisi_hba *hisi_hba = from_timer(hisi_hba, t, timer);
>         int i, reg_val;
>
>         for (i = 0; i < hisi_hba->n_phy; i++) {
> @@ -1287,13 +1287,13 @@ static void link_timeout_enable_link(unsigned long data)
>                 }
>         }
>
> -       hisi_hba->timer.function = link_timeout_disable_link;
> +       hisi_hba->timer.function = (TIMER_FUNC_TYPE)link_timeout_disable_link;
>         mod_timer(&hisi_hba->timer, jiffies + msecs_to_jiffies(900));
>  }
>
> -static void link_timeout_disable_link(unsigned long data)
> +static void link_timeout_disable_link(struct timer_list *t)
>  {
> -       struct hisi_hba *hisi_hba = (struct hisi_hba *)data;
> +       struct hisi_hba *hisi_hba = from_timer(hisi_hba, t, timer);
>         int i, reg_val;
>
>         reg_val = hisi_sas_read32(hisi_hba, PHY_STATE);
> @@ -1308,14 +1308,13 @@ static void link_timeout_disable_link(unsigned long data)
>                 }
>         }
>
> -       hisi_hba->timer.function = link_timeout_enable_link;
> +       hisi_hba->timer.function = (TIMER_FUNC_TYPE)link_timeout_enable_link;
>         mod_timer(&hisi_hba->timer, jiffies + msecs_to_jiffies(100));
>  }
>
>  static void set_link_timer_quirk(struct hisi_hba *hisi_hba)
>  {
> -       hisi_hba->timer.data = (unsigned long)hisi_hba;
> -       hisi_hba->timer.function = link_timeout_disable_link;
> +       hisi_hba->timer.function = (TIMER_FUNC_TYPE)link_timeout_disable_link;
>         hisi_hba->timer.expires = jiffies + msecs_to_jiffies(1000);
>         add_timer(&hisi_hba->timer);
>  }
> @@ -2574,9 +2573,9 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
>         return 0;
>  }
>
> -static void hisi_sas_internal_abort_quirk_timeout(unsigned long data)
> +static void hisi_sas_internal_abort_quirk_timeout(struct timer_list *t)
>  {
> -       struct hisi_sas_slot *slot = (struct hisi_sas_slot *)data;
> +       struct hisi_sas_slot *slot = from_timer(slot, t, internal_abort_timer);
>         struct hisi_sas_port *port = slot->port;
>         struct asd_sas_port *asd_sas_port;
>         struct asd_sas_phy *sas_phy;
> @@ -2619,8 +2618,7 @@ static int prep_abort_v2_hw(struct hisi_hba *hisi_hba,
>         struct timer_list *timer = &slot->internal_abort_timer;
>
>         /* setup the quirk timer */
> -       setup_timer(timer, hisi_sas_internal_abort_quirk_timeout,
> -                   (unsigned long)slot);
> +       timer_setup(timer, hisi_sas_internal_abort_quirk_timeout, 0);
>         /* Set the timeout to 10ms less than internal abort timeout */
>         mod_timer(timer, jiffies + msecs_to_jiffies(100));
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 2e5fa9717be8..3f2f0baf2a5e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -1823,7 +1823,7 @@ hisi_sas_shost_alloc_pci(struct pci_dev *pdev)
>         hisi_hba->shost = shost;
>         SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
>
> -       init_timer(&hisi_hba->timer);
> +       timer_setup(&hisi_hba->timer, NULL, 0);
>
>         if (hisi_sas_get_fw_info(hisi_hba) < 0)
>                 goto err_out;
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 6b4fd2375178..174e5eff6155 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -41,9 +41,10 @@ static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr);
>
>  /* ---------- SMP task management ---------- */
>
> -static void smp_task_timedout(unsigned long _task)
> +static void smp_task_timedout(struct timer_list *t)
>  {
> -       struct sas_task *task = (void *) _task;
> +       struct sas_task_slow *slow = from_timer(slow, t, timer);
> +       struct sas_task *task = slow->task;
>         unsigned long flags;
>
>         spin_lock_irqsave(&task->task_state_lock, flags);
> @@ -91,8 +92,7 @@ static int smp_execute_task_sg(struct domain_device *dev,
>
>                 task->task_done = smp_task_done;
>
> -               task->slow_task->timer.data = (unsigned long) task;
> -               task->slow_task->timer.function = smp_task_timedout;
> +               task->slow_task->timer.function = (TIMER_FUNC_TYPE)smp_task_timedout;
>                 task->slow_task->timer.expires = jiffies + SMP_TIMEOUT*HZ;
>                 add_timer(&task->slow_task->timer);
>
> diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
> index d3f5b57b3ebf..64fa6f53cb8b 100644
> --- a/drivers/scsi/libsas/sas_init.c
> +++ b/drivers/scsi/libsas/sas_init.c
> @@ -66,7 +66,8 @@ struct sas_task *sas_alloc_slow_task(gfp_t flags)
>         }
>
>         task->slow_task = slow;
> -       init_timer(&slow->timer);
> +       slow->task = task;
> +       timer_setup(&slow->timer, NULL, 0);
>         init_completion(&slow->completion);
>
>         return task;
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index ea8ad06ff582..91795eb56206 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -919,7 +919,7 @@ void sas_task_abort(struct sas_task *task)
>                         return;
>                 if (!del_timer(&slow->timer))
>                         return;
> -               slow->timer.function(slow->timer.data);
> +               slow->timer.function((TIMER_DATA_TYPE)&slow->timer);
>                 return;
>         }
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index 718c88de328b..8c91637cd598 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -95,7 +95,7 @@ static void mvs_phy_init(struct mvs_info *mvi, int phy_id)
>
>         phy->mvi = mvi;
>         phy->port = NULL;
> -       init_timer(&phy->timer);
> +       timer_setup(&phy->timer, NULL, 0);
>         sas_phy->enabled = (phy_id < mvi->chip->n_phy) ? 1 : 0;
>         sas_phy->class = SAS;
>         sas_phy->iproto = SAS_PROTOCOL_ALL;
> @@ -248,7 +248,6 @@ static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
>                 mvi->devices[i].dev_type = SAS_PHY_UNUSED;
>                 mvi->devices[i].device_id = i;
>                 mvi->devices[i].dev_status = MVS_DEV_NORMAL;
> -               init_timer(&mvi->devices[i].timer);
>         }
>
>         /*
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index ee81d10252e0..cff1c37b8d2e 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1283,9 +1283,10 @@ static void mvs_task_done(struct sas_task *task)
>         complete(&task->slow_task->completion);
>  }
>
> -static void mvs_tmf_timedout(unsigned long data)
> +static void mvs_tmf_timedout(struct timer_list *t)
>  {
> -       struct sas_task *task = (struct sas_task *)data;
> +       struct sas_task_slow *slow = from_timer(slow, t, timer);
> +       struct sas_task *task = slow->task;
>
>         task->task_state_flags |= SAS_TASK_STATE_ABORTED;
>         complete(&task->slow_task->completion);
> @@ -1309,8 +1310,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
>                 memcpy(&task->ssp_task, parameter, para_len);
>                 task->task_done = mvs_task_done;
>
> -               task->slow_task->timer.data = (unsigned long) task;
> -               task->slow_task->timer.function = mvs_tmf_timedout;
> +               task->slow_task->timer.function = (TIMER_FUNC_TYPE)mvs_tmf_timedout;
>                 task->slow_task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
>                 add_timer(&task->slow_task->timer);
>
> @@ -1954,9 +1954,9 @@ static int mvs_handle_event(struct mvs_info *mvi, void *data, int handler)
>         return ret;
>  }
>
> -static void mvs_sig_time_out(unsigned long tphy)
> +static void mvs_sig_time_out(struct timer_list *t)
>  {
> -       struct mvs_phy *phy = (struct mvs_phy *)tphy;
> +       struct mvs_phy *phy = from_timer(phy, t, timer);
>         struct mvs_info *mvi = phy->mvi;
>         u8 phy_no;
>
> @@ -2020,8 +2020,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
>                 MVS_CHIP_DISP->write_port_irq_mask(mvi, phy_no,
>                                         tmp | PHYEV_SIG_FIS);
>                 if (phy->timer.function == NULL) {
> -                       phy->timer.data = (unsigned long)phy;
> -                       phy->timer.function = mvs_sig_time_out;
> +                       phy->timer.function = (TIMER_FUNC_TYPE)mvs_sig_time_out;
>                         phy->timer.expires = jiffies + 5*HZ;
>                         add_timer(&phy->timer);
>                 }
> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
> index f9afd4cdd4c4..080676c1c9e5 100644
> --- a/drivers/scsi/mvsas/mv_sas.h
> +++ b/drivers/scsi/mvsas/mv_sas.h
> @@ -247,7 +247,6 @@ struct mvs_device {
>         enum sas_device_type dev_type;
>         struct mvs_info *mvi_info;
>         struct domain_device *sas_device;
> -       struct timer_list timer;
>         u32 attached_phy;
>         u32 device_id;
>         u32 running_req;
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index ce584c31d36e..7b2f92ae9866 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -656,9 +656,10 @@ void pm8001_task_done(struct sas_task *task)
>         complete(&task->slow_task->completion);
>  }
>
> -static void pm8001_tmf_timedout(unsigned long data)
> +static void pm8001_tmf_timedout(struct timer_list *t)
>  {
> -       struct sas_task *task = (struct sas_task *)data;
> +       struct sas_task_slow *slow = from_timer(slow, t, timer);
> +       struct sas_task *task = slow->task;
>
>         task->task_state_flags |= SAS_TASK_STATE_ABORTED;
>         complete(&task->slow_task->completion);
> @@ -694,8 +695,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
>                 task->task_proto = dev->tproto;
>                 memcpy(&task->ssp_task, parameter, para_len);
>                 task->task_done = pm8001_task_done;
> -               task->slow_task->timer.data = (unsigned long)task;
> -               task->slow_task->timer.function = pm8001_tmf_timedout;
> +               task->slow_task->timer.function = (TIMER_FUNC_TYPE)pm8001_tmf_timedout;
>                 task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT*HZ;
>                 add_timer(&task->slow_task->timer);
>
> @@ -781,8 +781,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
>                 task->dev = dev;
>                 task->task_proto = dev->tproto;
>                 task->task_done = pm8001_task_done;
> -               task->slow_task->timer.data = (unsigned long)task;
> -               task->slow_task->timer.function = pm8001_tmf_timedout;
> +               task->slow_task->timer.function = (TIMER_FUNC_TYPE)pm8001_tmf_timedout;
>                 task->slow_task->timer.expires = jiffies + PM8001_TASK_TIMEOUT * HZ;
>                 add_timer(&task->slow_task->timer);
>
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index ab6e18f1c01f..0f9cbf96c093 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -605,6 +605,7 @@ struct sas_task_slow {
>          */
>         struct timer_list     timer;
>         struct completion     completion;
> +       struct sas_task       *task;
>  };
>
>  #define SAS_TASK_STATE_PENDING      1
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security

Thanks Kees,
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

--

From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] mpt2sas,mpt3sas: make watchdog instantiated device
 removal safe
Date: Fri, 17 May 2013 09:29:02 -0600
Message-ID: <CAErSpo7E+XDQ2H5D7a-cE3cDFZ8nHiVP2fE7J3OrXJoVTC4hBg@mail.gmail.com>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com> <20130515132645.36b006bc@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20130515132645.36b006bc@jlaw-desktop.mno.stratus.com>
Sender: linux-pci-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[+cc linux-pci]

On Wed, May 15, 2013 at 11:26 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> From 9fc1a958ad48718216fbdc19405297dd11d11539 Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Tue, 14 May 2013 15:41:17 -0400
> Subject: [PATCH] mpt2sas,mpt3sas: make watchdog instantiated device removal
>  safe
>
> Calling pci_stop_and_remove_bus_device from a SCSI LLD may introduce
> device removal races with PCI callback functions such as device removal.
>
> Modify the MPT PCI callbacks to verify Scsi_Host attachment under a
> common mutex to prevent racing the driver's watchdog device removal.
> (PCI callbacks can trust pci_dev existence.)
>
> To protect the watchdog device removal thread from racing PCI removal,
> first wrapper the existing PCI device .remove function. The watchdog
> should directly call this function, not PCI hotplug API. Under the same
> common mutex, this routine should verify that pci_dev is on driver's
> ioc_list before proceeding with device removal. (Asynchronous driver
> watchdog kthread cannot trust pci_dev existence.)

I think it's a mistake to use the strategy of verifying that a pci_dev
still exists.  The driver should be written so that if you have a
pci_dev pointer, you are guaranteed that the pci_dev is still valid.
The driver should clean up any asynchronous threads or pending work
items that keep a pci_dev pointer in its .remove() method, which is
before the pci_dev is deallocated.

If a driver keeps a pointer to a struct pci_dev after .remove()
returns, that's a bug.

Bjorn

> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c  | 24 +++------
>  drivers/scsi/mpt2sas/mpt2sas_base.h  |  2 +
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c | 96 ++++++++++++++++++++++++++++--------
>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 22 +++------
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 95 ++++++++++++++++++++++++++++-------
>  6 files changed, 171 insertions(+), 70 deletions(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index bcb23d2..eb24ddd 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -116,24 +116,16 @@ module_param_call(mpt2sas_fwfault_debug, _scsih_set_fwfault_debug,
>
>  /**
>   *  mpt2sas_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> + * @pdev: PCI device struct
>   *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> + * Returns 0.
>   */
> -static int mpt2sas_remove_dead_ioc_func(void *arg)
> +static int
> +mpt2sas_remove_dead_ioc_func(void *arg)
>  {
> -               struct MPT2SAS_ADAPTER *ioc = (struct MPT2SAS_ADAPTER *)arg;
> -               struct pci_dev *pdev;
> -
> -               if ((ioc == NULL))
> -                       return -1;
> -
> -               pdev = ioc->pdev;
> -               if ((pdev == NULL))
> -                       return -1;
> -               pci_stop_and_remove_bus_device(pdev);
> -               return 0;
> +       /* mpt2sas_scsih_detach_pci will validate pci_dev */
> +       mpt2sas_scsih_detach_pci((struct pci_dev *)arg);
> +       return 0;
>  }
>
>
> @@ -192,7 +184,7 @@ _base_fault_reset_work(struct work_struct *work)
>                  */
>                 ioc->remove_host = 1;
>                 /*Remove the Dead Host */
> -               p = kthread_run(mpt2sas_remove_dead_ioc_func, ioc,
> +               p = kthread_run(mpt2sas_remove_dead_ioc_func, ioc->pdev,
>                     "mpt2sas_dead_ioc_%d", ioc->id);
>                 if (IS_ERR(p)) {
>                         printk(MPT2SAS_ERR_FMT
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index 4caaac1..d88515d 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -1079,6 +1079,8 @@ void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
>
>  void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
>
> +void mpt2sas_scsih_detach_pci(struct pci_dev *pdev);
> +
>  /* config shared API */
>  u8 mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
>      u32 reply);
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c6bdc92..8bff162 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -78,6 +78,8 @@ static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
>  LIST_HEAD(mpt2sas_ioc_list);
>
>  /* local parameters */
> +DEFINE_MUTEX(_mpt2sas_pci_mutex);
> +
>  static u8 scsi_io_cb_idx = -1;
>  static u8 tm_cb_idx = -1;
>  static u8 ctl_cb_idx = -1;
> @@ -7660,11 +7662,17 @@ _scsih_ir_shutdown(struct MPT2SAS_ADAPTER *ioc)
>  static void
>  _scsih_shutdown(struct pci_dev *pdev)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> +       struct Scsi_Host *shost;
> +       struct MPT2SAS_ADAPTER *ioc;
>         struct workqueue_struct *wq;
>         unsigned long flags;
>
> +       mutex_lock(&_mpt2sas_pci_mutex);
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +       ioc = shost_priv(shost);
> +
>         ioc->remove_host = 1;
>         _scsih_fw_event_cleanup_queue(ioc);
>
> @@ -7677,26 +7685,41 @@ _scsih_shutdown(struct pci_dev *pdev)
>
>         _scsih_ir_shutdown(ioc);
>         mpt2sas_base_detach(ioc);
> +out:
> +       mutex_unlock(&_mpt2sas_pci_mutex);
>  }
>
>  /**
> - * _scsih_remove - detach and remove add host
> + * mpt2sas_scsih_detach_pci - detach shost from PCI device
>   * @pdev: PCI device struct
>   *
> - * Routine called when unloading the driver.
> + * Routine called by pci driver .remove callback and watchdog-created
> + *   mpt2sas_remove_dead_ioc_func kthread.
>   * Return nothing.
>   */
> -static void
> -_scsih_remove(struct pci_dev *pdev)
> +void
> +mpt2sas_scsih_detach_pci(struct pci_dev *pdev)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> +       struct Scsi_Host *shost;
> +       struct MPT2SAS_ADAPTER *ioc;
>         struct _sas_port *mpt2sas_port, *next_port;
>         struct _raid_device *raid_device, *next;
>         struct MPT2SAS_TARGET *sas_target_priv_data;
>         struct workqueue_struct *wq;
>         unsigned long flags;
>
> +       mutex_lock(&_mpt2sas_pci_mutex);
> +       /* verify driver still knows about this pdev */
> +       list_for_each_entry(ioc, &mpt2sas_ioc_list, list) {
> +               if (ioc->pdev == pdev)
> +                       goto remove;
> +       }
> +       goto out;
> +remove:
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +
>         ioc->remove_host = 1;
>         _scsih_fw_event_cleanup_queue(ioc);
>
> @@ -7750,6 +7773,21 @@ _scsih_remove(struct pci_dev *pdev)
>         list_del(&ioc->list);
>         scsi_remove_host(shost);
>         scsi_host_put(shost);
> +out:
> +       mutex_unlock(&_mpt2sas_pci_mutex);
> +}
> +
> +/**
> + * _scsih_remove - detach and remove host
> + * @pdev: PCI device struct
> + *
> + * Routine called when unloading the driver and hotplug remove.
> + * Return nothing.
> + */
> +static void
> +_scsih_remove(struct pci_dev *pdev)
> +{
> +       mpt2sas_scsih_detach_pci(pdev);
>  }
>
>  /**
> @@ -8159,10 +8197,16 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  static int
>  _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> +       struct Scsi_Host *shost;
> +       struct MPT2SAS_ADAPTER *ioc;
>         pci_power_t device_state;
>
> +       mutex_lock(&_mpt2sas_pci_mutex);
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +       ioc = shost_priv(shost);
> +
>         mpt2sas_base_stop_watchdog(ioc);
>         scsi_block_requests(shost);
>         device_state = pci_choose_state(pdev, state);
> @@ -8174,6 +8218,9 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>         pci_save_state(pdev);
>         pci_disable_device(pdev);
>         pci_set_power_state(pdev, device_state);
> +out:
> +       mutex_unlock(&_mpt2sas_pci_mutex);
> +
>         return 0;
>  }
>
> @@ -8186,10 +8233,17 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>  static int
>  _scsih_resume(struct pci_dev *pdev)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> -       pci_power_t device_state = pdev->current_state;
> -       int r;
> +       struct Scsi_Host *shost;
> +       struct MPT2SAS_ADAPTER *ioc;
> +       pci_power_t device_state;
> +       int r = 0;
> +
> +       mutex_lock(&_mpt2sas_pci_mutex);
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +       ioc = shost_priv(shost);
> +       device_state = pdev->current_state;
>
>         printk(MPT2SAS_INFO_FMT "pdev=0x%p, slot=%s, previous "
>             "operating state [D%d]\n", ioc->name, pdev,
> @@ -8200,13 +8254,15 @@ _scsih_resume(struct pci_dev *pdev)
>         pci_restore_state(pdev);
>         ioc->pdev = pdev;
>         r = mpt2sas_base_map_resources(ioc);
> -       if (r)
> -               return r;
> +       if (!r) {
> +               mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
> +               scsi_unblock_requests(shost);
> +               mpt2sas_base_start_watchdog(ioc);
> +       }
> +out:
> +       mutex_unlock(&_mpt2sas_pci_mutex);
>
> -       mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
> -       scsi_unblock_requests(shost);
> -       mpt2sas_base_start_watchdog(ioc);
> -       return 0;
> +       return r;
>  }
>  #endif /* CONFIG_PM */
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 1836003..9d4f314 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -111,23 +111,15 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
>
>  /**
>   *  mpt3sas_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> + * @pdev: PCI device struct
>   *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> + * Returns 0.
>   */
> -static int mpt3sas_remove_dead_ioc_func(void *arg)
> +static int
> +mpt3sas_remove_dead_ioc_func(void *arg)
>  {
> -       struct MPT3SAS_ADAPTER *ioc = (struct MPT3SAS_ADAPTER *)arg;
> -       struct pci_dev *pdev;
> -
> -       if ((ioc == NULL))
> -               return -1;
> -
> -       pdev = ioc->pdev;
> -       if ((pdev == NULL))
> -               return -1;
> -       pci_stop_and_remove_bus_device(pdev);
> +       /* mpt3sas_scsih_detach_pci will validate pci_dev */
> +       mpt3sas_scsih_detach_pci((struct pci_dev *)arg);
>         return 0;
>  }
>
> @@ -173,7 +165,7 @@ _base_fault_reset_work(struct work_struct *work)
>                  */
>                 ioc->remove_host = 1;
>                 /*Remove the Dead Host */
> -               p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
> +               p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc->pdev,
>                     "mpt3sas_dead_ioc_%d", ioc->id);
>                 if (IS_ERR(p))
>                         pr_err(MPT3SAS_FMT
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 994656c..225c84f 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -1009,6 +1009,8 @@ struct _sas_device *mpt3sas_scsih_sas_device_find_by_sas_address(
>
>  void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
>
> +void mpt3sas_scsih_detach_pci(struct pci_dev *pdev);
> +
>  /* config shared API */
>  u8 mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
>         u32 reply);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index dcbf7c8..5b8c365 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -81,6 +81,8 @@ static int _scsih_scan_finished(struct Scsi_Host *shost, unsigned long time);
>  LIST_HEAD(mpt3sas_ioc_list);
>
>  /* local parameters */
> +DEFINE_MUTEX(_mpt3sas_pci_mutex);
> +
>  static u8 scsi_io_cb_idx = -1;
>  static u8 tm_cb_idx = -1;
>  static u8 ctl_cb_idx = -1;
> @@ -7365,22 +7367,36 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
>  }
>
>  /**
> - * _scsih_remove - detach and remove add host
> + * mpt3sas_scsih_detach_pci - detach shost from PCI device
>   * @pdev: PCI device struct
>   *
> - * Routine called when unloading the driver.
> + * Routine called by pci driver .remove callback and watchdog-created
> + *   mpt3sas_remove_dead_ioc_func kthread.
>   * Return nothing.
>   */
> -static void _scsih_remove(struct pci_dev *pdev)
> +void
> +mpt3sas_scsih_detach_pci(struct pci_dev *pdev)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> +       struct Scsi_Host *shost;
> +       struct MPT3SAS_ADAPTER *ioc;
>         struct _sas_port *mpt3sas_port, *next_port;
>         struct _raid_device *raid_device, *next;
>         struct MPT3SAS_TARGET *sas_target_priv_data;
>         struct workqueue_struct *wq;
>         unsigned long flags;
>
> +       mutex_lock(&_mpt3sas_pci_mutex);
> +       /* verify driver still knows about this pdev */
> +       list_for_each_entry(ioc, &mpt3sas_ioc_list, list) {
> +               if (ioc->pdev == pdev)
> +                       goto remove;
> +       }
> +       goto out;
> +remove:
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +
>         ioc->remove_host = 1;
>         _scsih_fw_event_cleanup_queue(ioc);
>
> @@ -7434,6 +7450,21 @@ static void _scsih_remove(struct pci_dev *pdev)
>         list_del(&ioc->list);
>         scsi_remove_host(shost);
>         scsi_host_put(shost);
> +out:
> +       mutex_unlock(&_mpt3sas_pci_mutex);
> +}
> +
> +/**
> + * _scsih_remove - detach and remove host
> + * @pdev: PCI device struct
> + *
> + * Routine called when unloading the driver and hotplug remove.
> + * Return nothing.
> + */
> +static void
> +_scsih_remove(struct pci_dev *pdev)
> +{
> +       mpt3sas_scsih_detach_pci(pdev);
>  }
>
>  /**
> @@ -7445,11 +7476,17 @@ static void _scsih_remove(struct pci_dev *pdev)
>  static void
>  _scsih_shutdown(struct pci_dev *pdev)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> +       struct Scsi_Host *shost;
> +       struct MPT3SAS_ADAPTER *ioc;
>         struct workqueue_struct *wq;
>         unsigned long flags;
>
> +       mutex_lock(&_mpt3sas_pci_mutex);
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +       ioc = shost_priv(shost);
> +
>         ioc->remove_host = 1;
>         _scsih_fw_event_cleanup_queue(ioc);
>
> @@ -7462,6 +7499,8 @@ _scsih_shutdown(struct pci_dev *pdev)
>
>         _scsih_ir_shutdown(ioc);
>         mpt3sas_base_detach(ioc);
> +out:
> +       mutex_unlock(&_mpt3sas_pci_mutex);
>  }
>
>
> @@ -7854,10 +7893,16 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  static int
>  _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> +       struct Scsi_Host *shost;
> +       struct MPT3SAS_ADAPTER *ioc;
>         pci_power_t device_state;
>
> +       mutex_lock(&_mpt3sas_pci_mutex);
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +       ioc = shost_priv(shost);
> +
>         mpt3sas_base_stop_watchdog(ioc);
>         flush_scheduled_work();
>         scsi_block_requests(shost);
> @@ -7869,6 +7914,9 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>         pci_save_state(pdev);
>         mpt3sas_base_free_resources(ioc);
>         pci_set_power_state(pdev, device_state);
> +out:
> +       mutex_unlock(&_mpt3sas_pci_mutex);
> +
>         return 0;
>  }
>
> @@ -7881,10 +7929,17 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>  static int
>  _scsih_resume(struct pci_dev *pdev)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> -       pci_power_t device_state = pdev->current_state;
> -       int r;
> +       struct Scsi_Host *shost;
> +       struct MPT3SAS_ADAPTER *ioc;
> +       pci_power_t device_state;
> +       int r = 0;
> +
> +       mutex_lock(&_mpt3sas_pci_mutex);
> +       shost = pci_get_drvdata(pdev);
> +       if (!shost)
> +               goto out;
> +       ioc = shost_priv(shost);
> +       device_state = pdev->current_state;
>
>         pr_info(MPT3SAS_FMT
>                 "pdev=0x%p, slot=%s, previous operating state [D%d]\n",
> @@ -7895,13 +7950,15 @@ _scsih_resume(struct pci_dev *pdev)
>         pci_restore_state(pdev);
>         ioc->pdev = pdev;
>         r = mpt3sas_base_map_resources(ioc);
> -       if (r)
> -               return r;
> +       if (!r) {
> +               mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
> +               scsi_unblock_requests(shost);
> +               mpt3sas_base_start_watchdog(ioc);
> +       }
> +out:
> +       mutex_unlock(&_mpt3sas_pci_mutex);
>
> -       mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
> -       scsi_unblock_requests(shost);
> -       mpt3sas_base_start_watchdog(ioc);
> -       return 0;
> +       return r;
>  }
>  #endif /* CONFIG_PM */
>
> --
> 1.8.1.4
>

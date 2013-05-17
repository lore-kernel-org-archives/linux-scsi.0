From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: mpt2sas,mpt3sas watchdog device removal
Date: Fri, 17 May 2013 09:29:06 -0600
Message-ID: <CAErSpo4OU2LRdmBLNBMbw79fYiR4yqYVJ++2ecju0qBNhAp-vA@mail.gmail.com>
References: <20130515132401.6a8ff7fb@jlaw-desktop.mno.stratus.com> <20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20130515132948.7dc4c551@jlaw-desktop.mno.stratus.com>
Sender: linux-pci-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[+cc linux-pci]

On Wed, May 15, 2013 at 11:29 AM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> From 84ac7a35ebd61e84d4254eae78bb967de17254c2 Mon Sep 17 00:00:00 2001
> From: Joe Lawrence <joe.lawrence@stratus.com>
> Date: Wed, 15 May 2013 12:52:31 -0400
> Subject: [PATCH] mpt2sas,mpt3sas: make watchdog instantiated device removal
>  safe
>
> Calling pci_stop_and_remove_bus_device from a SCSI LLD may introduce
> device removal races with PCI callback functions.
>
> Simplify the mpt2sas watchdog mechanism by separating PCI device removal
> from SCSI midlayer detachment. When the watchdog wishes to remove a SCSI
> device from the topology, detach from the SCSI midlayer, leaving the PCI
> device alone. Adjust various pci_driver callbacks to account for a
> potentially SCSI detached PCI device.

I don't know the details of the SCSI detachment, but this approach
looks much cleaner to me.

Thanks for doing all this work, Joe.  I know this isn't finished, but
it looks like a great step in making these drivers simpler and more
reliable.

Bjorn

> Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c  | 43 +---------------
>  drivers/scsi/mpt2sas/mpt2sas_base.h  |  2 +
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c | 97 +++++++++++++++++++++---------------
>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 43 +---------------
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 65 +++++++++++++++---------
>  6 files changed, 105 insertions(+), 147 deletions(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index bcb23d2..cc1bf28 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -57,7 +57,6 @@
>  #include <linux/sort.h>
>  #include <linux/io.h>
>  #include <linux/time.h>
> -#include <linux/kthread.h>
>  #include <linux/aer.h>
>
>  #include "mpt2sas_base.h"
> @@ -115,29 +114,6 @@ module_param_call(mpt2sas_fwfault_debug, _scsih_set_fwfault_debug,
>      param_get_int, &mpt2sas_fwfault_debug, 0644);
>
>  /**
> - *  mpt2sas_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> - *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> - */
> -static int mpt2sas_remove_dead_ioc_func(void *arg)
> -{
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
> -}
> -
> -
> -/**
>   * _base_fault_reset_work - workq handling ioc fault conditions
>   * @work: input argument, used to derive ioc
>   * Context: sleep.
> @@ -152,7 +128,6 @@ _base_fault_reset_work(struct work_struct *work)
>         unsigned long    flags;
>         u32 doorbell;
>         int rc;
> -       struct task_struct *p;
>
>         spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
>         if (ioc->shost_recovery || ioc->pci_error_recovery)
> @@ -186,23 +161,7 @@ _base_fault_reset_work(struct work_struct *work)
>                  * command back from HW.
>                  */
>                 ioc->schedule_dead_ioc_flush_running_cmds(ioc);
> -               /*
> -                * Set remove_host flag early since kernel thread will
> -                * take some time to execute.
> -                */
> -               ioc->remove_host = 1;
> -               /*Remove the Dead Host */
> -               p = kthread_run(mpt2sas_remove_dead_ioc_func, ioc,
> -                   "mpt2sas_dead_ioc_%d", ioc->id);
> -               if (IS_ERR(p)) {
> -                       printk(MPT2SAS_ERR_FMT
> -                       "%s: Running mpt2sas_dead_ioc thread failed !!!!\n",
> -                       ioc->name, __func__);
> -               } else {
> -                   printk(MPT2SAS_ERR_FMT
> -                       "%s: Running mpt2sas_dead_ioc thread success !!!!\n",
> -                       ioc->name, __func__);
> -               }
> +               mpt2sas_scsih_detach(ioc);
>
>                 return; /* don't rearm timer */
>         }
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
> index 4caaac1..94d0e98 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.h
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
> @@ -817,6 +817,7 @@ struct MPT2SAS_ADAPTER {
>         u8              broadcast_aen_busy;
>         u16             broadcast_aen_pending;
>         u8              shost_recovery;
> +       u8              shost_attached;
>
>         struct mutex    reset_in_progress_mutex;
>         spinlock_t      ioc_reset_in_progress_lock;
> @@ -1078,6 +1079,7 @@ struct _sas_device *mpt2sas_scsih_sas_device_find_by_sas_address(
>  void mpt2sas_port_enable_complete(struct MPT2SAS_ADAPTER *ioc);
>
>  void mpt2sas_scsih_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase);
> +void mpt2sas_scsih_detach(struct MPT2SAS_ADAPTER *ioc);
>
>  /* config shared API */
>  u8 mpt2sas_config_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> index c6bdc92..a06662c 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
> @@ -7652,51 +7652,23 @@ _scsih_ir_shutdown(struct MPT2SAS_ADAPTER *ioc)
>  }
>
>  /**
> - * _scsih_shutdown - routine call during system shutdown
> - * @pdev: PCI device struct
> - *
> - * Return nothing.
> - */
> -static void
> -_scsih_shutdown(struct pci_dev *pdev)
> -{
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> -       struct workqueue_struct *wq;
> -       unsigned long flags;
> -
> -       ioc->remove_host = 1;
> -       _scsih_fw_event_cleanup_queue(ioc);
> -
> -       spin_lock_irqsave(&ioc->fw_event_lock, flags);
> -       wq = ioc->firmware_event_thread;
> -       ioc->firmware_event_thread = NULL;
> -       spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> -       if (wq)
> -               destroy_workqueue(wq);
> -
> -       _scsih_ir_shutdown(ioc);
> -       mpt2sas_base_detach(ioc);
> -}
> -
> -/**
> - * _scsih_remove - detach and remove add host
> - * @pdev: PCI device struct
> + * mpt2sas_scsih_detach - detach from SCSI midlayer and free resources
> + * @ioc: per adapter object
>   *
> - * Routine called when unloading the driver.
>   * Return nothing.
>   */
> -static void
> -_scsih_remove(struct pci_dev *pdev)
> +void
> +mpt2sas_scsih_detach(struct MPT2SAS_ADAPTER *ioc)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
>         struct _sas_port *mpt2sas_port, *next_port;
>         struct _raid_device *raid_device, *next;
>         struct MPT2SAS_TARGET *sas_target_priv_data;
>         struct workqueue_struct *wq;
>         unsigned long flags;
>
> +       if (!ioc->shost_attached)
> +               return;
> +
>         ioc->remove_host = 1;
>         _scsih_fw_event_cleanup_queue(ioc);
>
> @@ -7745,11 +7717,52 @@ _scsih_remove(struct pci_dev *pdev)
>                 ioc->sas_hba.num_phys = 0;
>         }
>
> -       sas_remove_host(shost);
> +       sas_remove_host(ioc->shost);
> +       scsi_remove_host(ioc->shost);
> +       ioc->shost_attached = 0;
> +}
> +
> +/**
> + * _scsih_shutdown - routine call during system shutdown
> + * @pdev: PCI device struct
> + *
> + * Return nothing.
> + */
> +static void
> +_scsih_shutdown(struct pci_dev *pdev)
> +{
> +       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> +
> +       ioc->remove_host = 1;
> +
> +       mpt2sas_base_stop_watchdog(ioc);
> +       mpt2sas_scsih_detach(ioc);
> +       mpt2sas_base_detach(ioc);
> +}
> +
> +/**
> + * _scsih_remove - detach and remove add host
> + * @pdev: PCI device struct
> + *
> + * Routine called when unloading the driver.
> + * Return nothing.
> + */
> +static void
> +_scsih_remove(struct pci_dev *pdev)
> +{
> +       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +       struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
> +
> +       ioc->remove_host = 1;
> +
> +       mpt2sas_base_stop_watchdog(ioc);
> +       mpt2sas_scsih_detach(ioc);
> +
>         mpt2sas_base_detach(ioc);
>         list_del(&ioc->list);
> -       scsi_remove_host(shost);
> -       scsi_host_put(shost);
> +
> +       scsi_host_put(ioc->shost);
>  }
>
>  /**
> @@ -8022,6 +8035,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         INIT_LIST_HEAD(&ioc->list);
>         list_add_tail(&ioc->list, &mpt2sas_ioc_list);
>         ioc->shost = shost;
> +       ioc->shost_attached = 1;
>         ioc->id = mpt_ids++;
>         sprintf(ioc->name, "%s%d", MPT2SAS_DRIVER_NAME, ioc->id);
>         ioc->pdev = pdev;
> @@ -8144,6 +8158,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         list_del(&ioc->list);
>         scsi_remove_host(shost);
>   out_add_shost_fail:
> +       ioc->shost_attached = 0;
>         scsi_host_put(shost);
>         return -ENODEV;
>  }
> @@ -8164,7 +8179,8 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>         pci_power_t device_state;
>
>         mpt2sas_base_stop_watchdog(ioc);
> -       scsi_block_requests(shost);
> +       if (ioc->shost_attached)
> +               scsi_block_requests(shost);
>         device_state = pci_choose_state(pdev, state);
>         printk(MPT2SAS_INFO_FMT "pdev=0x%p, slot=%s, entering "
>             "operating state [D%d]\n", ioc->name, pdev,
> @@ -8204,7 +8220,8 @@ _scsih_resume(struct pci_dev *pdev)
>                 return r;
>
>         mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
> -       scsi_unblock_requests(shost);
> +       if (ioc->shost_attached)
> +               scsi_unblock_requests(shost);
>         mpt2sas_base_start_watchdog(ioc);
>         return 0;
>  }
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 1836003..f8c25a1 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -56,7 +56,6 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
>  #include <linux/time.h>
> -#include <linux/kthread.h>
>  #include <linux/aer.h>
>
>
> @@ -110,28 +109,6 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
>         param_get_int, &mpt3sas_fwfault_debug, 0644);
>
>  /**
> - *  mpt3sas_remove_dead_ioc_func - kthread context to remove dead ioc
> - * @arg: input argument, used to derive ioc
> - *
> - * Return 0 if controller is removed from pci subsystem.
> - * Return -1 for other case.
> - */
> -static int mpt3sas_remove_dead_ioc_func(void *arg)
> -{
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
> -       return 0;
> -}
> -
> -/**
>   * _base_fault_reset_work - workq handling ioc fault conditions
>   * @work: input argument, used to derive ioc
>   * Context: sleep.
> @@ -146,8 +123,6 @@ _base_fault_reset_work(struct work_struct *work)
>         unsigned long    flags;
>         u32 doorbell;
>         int rc;
> -       struct task_struct *p;
> -
>
>         spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
>         if (ioc->shost_recovery)
> @@ -167,22 +142,8 @@ _base_fault_reset_work(struct work_struct *work)
>                  * command back from HW.
>                  */
>                 ioc->schedule_dead_ioc_flush_running_cmds(ioc);
> -               /*
> -                * Set remove_host flag early since kernel thread will
> -                * take some time to execute.
> -                */
> -               ioc->remove_host = 1;
> -               /*Remove the Dead Host */
> -               p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
> -                   "mpt3sas_dead_ioc_%d", ioc->id);
> -               if (IS_ERR(p))
> -                       pr_err(MPT3SAS_FMT
> -                       "%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
> -                       ioc->name, __func__);
> -               else
> -                       pr_err(MPT3SAS_FMT
> -                       "%s: Running mpt3sas_dead_ioc thread success !!!!\n",
> -                       ioc->name, __func__);
> +               mpt3sas_scsih_detach(ioc);
> +
>                 return; /* don't rearm timer */
>         }
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 994656c..9fbf56c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -731,6 +731,7 @@ struct MPT3SAS_ADAPTER {
>         u8              broadcast_aen_busy;
>         u16             broadcast_aen_pending;
>         u8              shost_recovery;
> +       u8              shost_attached;
>
>         struct mutex    reset_in_progress_mutex;
>         spinlock_t      ioc_reset_in_progress_lock;
> @@ -990,6 +991,7 @@ int mpt3sas_port_enable(struct MPT3SAS_ADAPTER *ioc);
>  u8 mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
>         u32 reply);
>  void mpt3sas_scsih_reset_handler(struct MPT3SAS_ADAPTER *ioc, int reset_phase);
> +void mpt3sas_scsih_detach(struct MPT3SAS_ADAPTER *ioc);
>
>  int mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
>         uint channel, uint id, uint lun, u8 type, u16 smid_task,
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index dcbf7c8..9ae0914 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -7365,22 +7365,23 @@ _scsih_ir_shutdown(struct MPT3SAS_ADAPTER *ioc)
>  }
>
>  /**
> - * _scsih_remove - detach and remove add host
> - * @pdev: PCI device struct
> + * mpt3sas_scsih_detach - detach from SCSI midlayer and free resources
> + * @ioc: per adapter object
>   *
> - * Routine called when unloading the driver.
>   * Return nothing.
>   */
> -static void _scsih_remove(struct pci_dev *pdev)
> +void
> +mpt3sas_scsih_detach(struct MPT3SAS_ADAPTER *ioc)
>  {
> -       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> -       struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
>         struct _sas_port *mpt3sas_port, *next_port;
>         struct _raid_device *raid_device, *next;
>         struct MPT3SAS_TARGET *sas_target_priv_data;
>         struct workqueue_struct *wq;
>         unsigned long flags;
>
> +       if (!ioc->shost_attached)
> +               return;
> +
>         ioc->remove_host = 1;
>         _scsih_fw_event_cleanup_queue(ioc);
>
> @@ -7429,11 +7430,9 @@ static void _scsih_remove(struct pci_dev *pdev)
>                 ioc->sas_hba.num_phys = 0;
>         }
>
> -       sas_remove_host(shost);
> -       mpt3sas_base_detach(ioc);
> -       list_del(&ioc->list);
> -       scsi_remove_host(shost);
> -       scsi_host_put(shost);
> +       sas_remove_host(ioc->shost);
> +       scsi_remove_host(ioc->shost);
> +       ioc->shost_attached = 0;
>  }
>
>  /**
> @@ -7447,23 +7446,37 @@ _scsih_shutdown(struct pci_dev *pdev)
>  {
>         struct Scsi_Host *shost = pci_get_drvdata(pdev);
>         struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> -       struct workqueue_struct *wq;
> -       unsigned long flags;
>
>         ioc->remove_host = 1;
> -       _scsih_fw_event_cleanup_queue(ioc);
> -
> -       spin_lock_irqsave(&ioc->fw_event_lock, flags);
> -       wq = ioc->firmware_event_thread;
> -       ioc->firmware_event_thread = NULL;
> -       spin_unlock_irqrestore(&ioc->fw_event_lock, flags);
> -       if (wq)
> -               destroy_workqueue(wq);
>
> -       _scsih_ir_shutdown(ioc);
> +       mpt3sas_base_stop_watchdog(ioc);
> +       mpt3sas_scsih_detach(ioc);
>         mpt3sas_base_detach(ioc);
>  }
>
> +/**
> + * _scsih_remove - detach and remove add host
> + * @pdev: PCI device struct
> + *
> + * Routine called when unloading the driver.
> + * Return nothing.
> + */
> +static void
> +_scsih_remove(struct pci_dev *pdev)
> +{
> +       struct Scsi_Host *shost = pci_get_drvdata(pdev);
> +       struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
> +
> +       ioc->remove_host = 1;
> +
> +       mpt3sas_base_stop_watchdog(ioc);
> +       mpt3sas_scsih_detach(ioc);
> +
> +       mpt3sas_base_detach(ioc);
> +       list_del(&ioc->list);
> +
> +       scsi_host_put(ioc->shost);
> +}
>
>  /**
>   * _scsih_probe_boot_devices - reports 1st device
> @@ -7735,6 +7748,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         INIT_LIST_HEAD(&ioc->list);
>         list_add_tail(&ioc->list, &mpt3sas_ioc_list);
>         ioc->shost = shost;
> +       ioc->shost_attached = 1;
>         ioc->id = mpt_ids++;
>         sprintf(ioc->name, "%s%d", MPT3SAS_DRIVER_NAME, ioc->id);
>         ioc->pdev = pdev;
> @@ -7839,6 +7853,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>         list_del(&ioc->list);
>         scsi_remove_host(shost);
>   out_add_shost_fail:
> +       ioc->shost_attached = 0;
>         scsi_host_put(shost);
>         return -ENODEV;
>  }
> @@ -7860,7 +7875,8 @@ _scsih_suspend(struct pci_dev *pdev, pm_message_t state)
>
>         mpt3sas_base_stop_watchdog(ioc);
>         flush_scheduled_work();
> -       scsi_block_requests(shost);
> +       if (ioc->shost_attached)
> +               scsi_block_requests(shost);
>         device_state = pci_choose_state(pdev, state);
>         pr_info(MPT3SAS_FMT
>                 "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
> @@ -7899,7 +7915,8 @@ _scsih_resume(struct pci_dev *pdev)
>                 return r;
>
>         mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP, SOFT_RESET);
> -       scsi_unblock_requests(shost);
> +       if (ioc->shost_attached)
> +               scsi_unblock_requests(shost);
>         mpt3sas_base_start_watchdog(ioc);
>         return 0;
>  }
> --
> 1.8.1.4
>

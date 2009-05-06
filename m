From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/10] scsi: megaraid_sas - Add Poll Wait mechanism to
 MegaRAID SAS driver (PART-I)
Date: Wed, 6 May 2009 14:17:05 -0700
Message-ID: <20090506141705.5edc74d9.akpm@linux-foundation.org>
References: <4B6A08C587958942AA3002690DD4F8C354F61C22@cosmail02.lsi.com>
	<4B6A08C587958942AA3002690DD4F8C354F61C3E@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbZEFVU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 17:20:27 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C3E@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Winston.Austria@lsi.com

On Tue, 5 May 2009 18:25:55 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Add Poll_wait mechanism to SAS-2 MegaRAID SAS Linux driver. Driver will wakeup poll after the driver get event from MegaRAID SAS FW.  Driver also reregisters for Event with the FW when it receives AEN.
> 

Seems fairly strage to be adding poll support to a scsi driver, but I
see it isn't the first driver to do this.

> 
>
> ...
>
> @@ -1295,13 +1301,20 @@ megasas_service_aen(struct megasas_insta
>         /*
>          * Don't signal app if it is just an aborted previously registered aen
>          */
> -       if (!cmd->abort_aen)
> +       if ((!cmd->abort_aen) && (instance->unload == 0)) {
> +               megasas_poll_wait_aen = 1;
> +               wake_up(&megasas_poll_wait);
>                 kill_fasync(&megasas_async_queue, SIGIO, POLL_IN);
> +       }
>         else
>                 cmd->abort_aen = 0;
> 
>         instance->aen_cmd = NULL;
>         megasas_return_cmd(instance, cmd);
> +
> +       if ((!cmd->abort_aen) && (instance->unload == 0)) {
> +               megasas_aen_polling(instance);
> +       }

I see you're not a big fan of checkpatch, nor of kernel coding style :(

>  }
> 
>  /*
> @@ -2583,6 +2596,8 @@ megasas_probe_one(struct pci_dev *pdev,
> 
>         *instance->producer = 0;
>         *instance->consumer = 0;
> +       megasas_poll_wait_aen = 0;
> +       instance->hotplug_wk = NULL;
> 
>         instance->evt_detail = pci_alloc_consistent(pdev,
>                                                     sizeof(struct
> @@ -2621,6 +2636,7 @@ megasas_probe_one(struct pci_dev *pdev,
> 
>         megasas_dbg_lvl = 0;
>         instance->flag = 0;
> +       instance->unload = 0;
>         instance->last_time = 0;
> 
>         /*
> @@ -2924,6 +2940,7 @@ static void __devexit megasas_detach_one
>         struct megasas_instance *instance;
> 
>         instance = pci_get_drvdata(pdev);
> +       instance->unload = 1;
>         host = instance->host;
> 
>         if (poll_mode_io)
> @@ -2932,6 +2949,15 @@ static void __devexit megasas_detach_one
>         scsi_remove_host(instance->host);
>         megasas_flush_cache(instance);
>         megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
> +
> +       /*
> +       * cancel the delayed work if this work still in queue
> +       */
> +       if (instance->hotplug_wk != NULL) {
> +               cancel_delayed_work(
> +                       (struct delayed_work *)instance->hotplug_wk);

whah?  Can't do that!  cancel_delayed_work() will do del_timer_sync()
on megasas_instance.flag and will crash.

> +                       

> +               flush_scheduled_work();
> +       }
>         tasklet_kill(&instance->isr_tasklet);
> 
>         /*
> @@ -3027,6 +3053,19 @@ static int megasas_mgmt_fasync(int fd, s
>  }
> 
>  /**
> + * megasas_mgmt_poll -  char node "poll" entry point
> + * */
> +static unsigned int megasas_mgmt_poll(struct file *file, poll_table *wait)
> +{
> +       unsigned int mask = 0;
> +       poll_wait(file, &megasas_poll_wait, wait);
> +       if (megasas_poll_wait_aen) {
> +               mask |=   (POLLIN | POLLRDNORM);
> +       }
> +       return mask;
> +}
> +
> +/**
>   * megasas_mgmt_fw_ioctl -     Issues management ioctls to FW
>   * @instance:                  Adapter soft state
>   * @argp:                      User's ioctl packet
> @@ -3348,6 +3387,7 @@ static const struct file_operations mega
>         .open = megasas_mgmt_open,
>         .fasync = megasas_mgmt_fasync,
>         .unlocked_ioctl = megasas_mgmt_ioctl,
> +       .poll = megasas_mgmt_poll,
>  #ifdef CONFIG_COMPAT
>         .compat_ioctl = megasas_mgmt_compat_ioctl,
>  #endif
> @@ -3462,6 +3502,100 @@ out:
>         return retval;
>  }
> 
> +static void
> +megasas_scsi_scan_host(struct work_struct *work)
> +{
> +       struct megasas_aen_event *ev = container_of(work,
> +               struct megasas_aen_event, hotplug_work);
> +       struct megasas_instance *instance = ev->instance;
> +
> +       instance->hotplug_wk = NULL;
> +       if (!instance) {

oh come on.  If this test returns true then the preceding statement
just oopsed the kernel.

> +               printk(KERN_ERR "%s: invalid instance!\n", __FUNCTION__);
> +               kfree(ev);
> +               return;
> +       }
> +
> +       printk(KERN_INFO "%s[%d]: scanning ...\n",
> +               __FUNCTION__, instance->host->host_no);
> +       scsi_scan_host(instance->host);
> +       kfree(ev);
> +}
> +
> +static void
> +megasas_aen_polling(struct megasas_instance *instance)
> +{
> +       union megasas_evt_class_locale class_locale;
> +       int doscan = 0;
> +       u32 seq_num;
> +       int error;
> +
> +       if (instance->evt_detail) {
> +               printk(KERN_INFO "%s[%d]: event code 0x%04x\n", __FUNCTION__,

Users of checkpatch know to use __func__.

> +                       instance->host->host_no, instance->evt_detail->code);
> +
> +               switch (instance->evt_detail->code) {
> +
> +               case MR_EVT_LD_CREATED:
> +               case MR_EVT_PD_INSERTED:
> +               case MR_EVT_LD_DELETED:
> +               case MR_EVT_LD_OFFLINE:
> +               case MR_EVT_CFG_CLEARED:
> +               case MR_EVT_PD_REMOVED:
> +               case MR_EVT_FOREIGN_CFG_IMPORTED:
> +               case MR_EVT_LD_STATE_CHANGE:
> +               case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
> +                       doscan = 1;
> +                       break;
> +               default:
> +                       doscan = 0;
> +                       break;
> +               }
> +       } else {
> +               printk(KERN_ERR "%s[%d]: invalid evt_detail!\n",
> +                       __FUNCTION__, instance->host->host_no);
> +               return;
> +       }
> +
> +       if (doscan) {
> +               struct megasas_aen_event *ev;
> +               ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
> +               if (!ev) {
> +                       printk(KERN_ERR "%s: out of memory\n", __FUNCTION__);
> +               } else {
> +                       ev->instance = instance;
> +                       instance->hotplug_wk = &ev->hotplug_work;
> +                       INIT_WORK(&ev->hotplug_work, megasas_scsi_scan_host);
> +                       schedule_delayed_work(
> +                               (struct delayed_work *)&ev->hotplug_work, 0);
> +               }
> +       }
> +
> +       seq_num = instance->evt_detail->seq_num + 1;
> +
> +       /**
> +       * Register AEN with FW for latest sequence number plus 1
> +       **/

The /** token is used to introduce a kerneldoc comment.  This is not a
kerneldoc comment.

> +       class_locale.members.reserved = 0;
> +       class_locale.members.locale = MR_EVT_LOCALE_ALL;
> +       class_locale.members.class = MR_EVT_CLASS_DEBUG;
> +
> +       if ( instance->aen_cmd != NULL ) {
> +               return ;
> +       }
> +
> +       mutex_lock(&instance->aen_mutex);
> +       error = megasas_register_aen(instance, seq_num,
> +                               class_locale.word);
> +       mutex_unlock(&instance->aen_mutex);
> +
> +       if (error)
> +               printk(KERN_ERR "%s[%d]: register aen failed error %x\n",
> +                        __FUNCTION__, instance->host->host_no, error);
> +}
> +
> +
>
> ...
>
> @@ -1118,8 +1134,10 @@ struct megasas_instance {
> 
>         struct megasas_instance_template *instancet;
>         struct tasklet_struct isr_tasklet;
> +       struct work_struct *hotplug_wk;

"hotplug_work"

> 
>         u8 flag;
> +       u8 unload;
>         unsigned long last_time;
> 
>         struct timer_list io_completion_timer;

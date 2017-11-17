From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 0/2] sd: Fix a deadlock between event checking and device removal
Date: Fri, 17 Nov 2017 16:14:47 +0100
Message-ID: <CAD+HZHWAUPRxHyG0VRcfTmBs2KbUX30wsa7=HGGApQ94sEj26g@mail.gmail.com>
References: <a8f0ee8f-7b40-2375-47a4-52f78af29d8d@sandisk.com>
 <1479016028.17624.16.camel@linux.vnet.ibm.com> <9500e9b2-2d34-099d-aa90-d38fb3feb02e@sandisk.com>
 <CAD+HZHUVsaDYO7yL2Ct868kdK=dE3PuRmy-Jfp2d2zmEBJPwFg@mail.gmail.com> <1510680828.2280.16.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35269 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757389AbdKQPOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Nov 2017 10:14:49 -0500
Received: by mail-wm0-f65.google.com with SMTP id y80so7097375wmd.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 07:14:48 -0800 (PST)
In-Reply-To: <1510680828.2280.16.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "snitzer@redhat.com" <snitzer@redhat.com>

2017-11-14 18:33 GMT+01:00 Bart Van Assche <Bart.VanAssche@wdc.com>:
> On Tue, 2017-11-14 at 18:01 +0100, Jack Wang wrote:
>> I suspect we run into same bug you were trying to fix in this patch
>> set. we're running in v4.4.50
>>
>> I was trying to reproduce it, but no lucky yet, do you still have your
>> reproducer?
>
> Hello Jack,
>
> I can reproduce this about every fifth run of test one of the srp-test
> software and with the SRP initiator and target drivers of what will become
> kernel v4.15-rc1 and by switching the ib_srpt driver from non-SRQ to SRQ
> mode while the initiator is logging in. I'm currently analyzing where in the
> block layer a queue run is missing. The patch below for the sd driver does
> not fix the root cause but seems to help.
>
> Bart.
>
Thanks Bart,

You're always kind and helpful.
I tried srp-test in my test machine, but still no luck.

In my case,  we had on storage failure, and lead scsi error handle and
offlined both devices, so both paths down, raid1 failed one leg (the
dm device).
During incident recovery, when tried to delete the broken scsi device,
there are processes in D state

[Mon Nov  6 09:55:19 2017] sysrq: SysRq : Show Blocked State
[Mon Nov  6 09:55:19 2017]   task                        PC stack   pid father
[Mon Nov  6 09:55:19 2017] kworker/40:2    D ffff883004327a98     0
65322      2 0x00000000
[Mon Nov  6 09:55:19 2017] Workqueue: events_freezable_power_ disk_events_workfn
[Mon Nov  6 09:55:19 2017]  ffff883004327a98 ffff881804973400
ffff882fe6e4b400 ffff883004327ad0
[Mon Nov  6 09:55:19 2017]  0000000000000282 ffff883004328000
000000011c546eb0 ffff883004327ad0
[Mon Nov  6 09:55:19 2017]  ffff883007c0cd80 0000000000000028
ffff883004327ab0 ffffffff81800540
[Mon Nov  6 09:55:19 2017] Call Trace:
[Mon Nov  6 09:55:19 2017]  [<ffffffff81800540>] schedule+0x30/0x80
[Mon Nov  6 09:55:19 2017]  [<ffffffff81802ffa>] schedule_timeout+0x14a/0x290
[Mon Nov  6 09:55:19 2017]  [<ffffffff810b6800>] ?
trace_raw_output_itimer_expire+0x80/0x80
[Mon Nov  6 09:55:19 2017]  [<ffffffff817ffa86>] io_schedule_timeout+0xb6/0x130
[Mon Nov  6 09:55:19 2017]  [<ffffffff8180101b>]
wait_for_completion_io_timeout+0x9b/0x110
[Mon Nov  6 09:55:19 2017]  [<ffffffff8107fbf0>] ? wake_up_q+0x70/0x70
[Mon Nov  6 09:55:19 2017]  [<ffffffff814029a2>] blk_execute_rq+0x92/0x110
[Mon Nov  6 09:55:19 2017]  [<ffffffff81094790>] ? wait_woken+0x80/0x80
[Mon Nov  6 09:55:19 2017]  [<ffffffff813fa44d>] ? blk_get_request+0x7d/0xe0
[Mon Nov  6 09:55:19 2017]  [<ffffffffa0149733>]
scsi_execute+0x143/0x5f0 [scsi_mod]
[Mon Nov  6 09:55:19 2017]  [<ffffffffa014b904>]
scsi_execute_req_flags+0x94/0x100 [scsi_mod]
[Mon Nov  6 09:55:19 2017]  [<ffffffffa014bfab>]
scsi_test_unit_ready+0x7b/0x2a0 [scsi_mod]
[Mon Nov  6 09:55:19 2017]  [<ffffffffa0644971>] 0xffffffffa0644971
sd_check_events
[Mon Nov  6 09:55:19 2017]  [<ffffffff8140d3e4>] disk_check_events+0x54/0x130
[Mon Nov  6 09:55:19 2017]  [<ffffffff8140d4d1>] disk_events_workfn+0x11/0x20
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106f928>] process_one_work+0x148/0x410
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106ff31>] worker_thread+0x61/0x450
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106fed0>] ? rescuer_thread+0x2e0/0x2e0
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106fed0>] ? rescuer_thread+0x2e0/0x2e0
[Mon Nov  6 09:55:19 2017]  [<ffffffff81075066>] kthread+0xd6/0xf0
[Mon Nov  6 09:55:19 2017]  [<ffffffff81074f90>] ? kthread_park+0x50/0x50
[Mon Nov  6 09:55:19 2017]  [<ffffffff8180411f>] ret_from_fork+0x3f/0x70
[Mon Nov  6 09:55:19 2017]  [<ffffffff81074f90>] ? kthread_park+0x50/0x50
[Mon Nov  6 09:55:19 2017] repair_md_dev   D ffff8807a258fa28     0
18979  18978 0x00000000
[Mon Nov  6 09:55:19 2017]  ffff8807a258fa28 ffff881804970000
ffff8807f11eb400 ffff882807d146e0
[Mon Nov  6 09:55:19 2017]  ffff882807d146e0 ffff8807a2590000
7fffffffffffffff ffff8807a258fb70
[Mon Nov  6 09:55:19 2017]  ffff8807f11eb400 ffff8807f11eb400
ffff8807a258fa40 ffffffff81800540
[Mon Nov  6 09:55:19 2017] Call Trace:
[Mon Nov  6 09:55:19 2017]  [<ffffffff81800540>] schedule+0x30/0x80
[Mon Nov  6 09:55:19 2017]  [<ffffffff818030d0>] schedule_timeout+0x220/0x290
[Mon Nov  6 09:55:19 2017]  [<ffffffff8103f489>] ?
physflat_send_IPI_mask+0x9/0x10
[Mon Nov  6 09:55:19 2017]  [<ffffffff8107f7ef>] ? try_to_wake_up+0x4f/0x3c0
[Mon Nov  6 09:55:19 2017]  [<ffffffff8180170a>] wait_for_completion+0x9a/0xf0
[Mon Nov  6 09:55:19 2017]  [<ffffffff8107fbf0>] ? wake_up_q+0x70/0x70
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106e715>] flush_work+0xe5/0x140
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106c720>] ? destroy_worker+0x90/0x90
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106f337>] __cancel_work_timer+0x97/0x1b0
[Mon Nov  6 09:55:19 2017]  [<ffffffff81208dd3>] ? kernfs_put+0xf3/0x1a0
[Mon Nov  6 09:55:19 2017]  [<ffffffff8106f46e>]
cancel_delayed_work_sync+0xe/0x10
[Mon Nov  6 09:55:19 2017]  [<ffffffff8140e21d>] disk_block_events+0x8d/0x90
[Mon Nov  6 09:55:19 2017]  [<ffffffff8140e2e5>] del_gendisk+0x35/0x230
[Mon Nov  6 09:55:19 2017]  [<ffffffffa0643b79>] 0xffffffffa0643b79
[Mon Nov  6 09:55:19 2017]  [<ffffffff814eb8a1>]
__device_release_driver+0x91/0x130
[Mon Nov  6 09:55:19 2017]  [<ffffffff814eb967>] device_release_driver+0x27/0x40
[Mon Nov  6 09:55:19 2017]  [<ffffffff814ea6dc>] bus_remove_device+0xfc/0x170
[Mon Nov  6 09:55:19 2017]  [<ffffffff814e6da3>] device_del+0x123/0x240
[Mon Nov  6 09:55:19 2017]  [<ffffffff8120b9d0>] ?
sysfs_remove_file_ns+0x10/0x20
[Mon Nov  6 09:55:19 2017]  [<ffffffffa0151a89>]
__scsi_remove_device+0xc9/0xd0 [scsi_mod]
[Mon Nov  6 09:55:19 2017]  [<ffffffffa0151aba>]
scsi_remove_device+0x2a/0x80 [scsi_mod]
[Mon Nov  6 09:55:19 2017]  [<ffffffffa0151afb>]
scsi_remove_device+0x6b/0x80 [scsi_mod]
[Mon Nov  6 09:55:19 2017]  [<ffffffff814e60d3>] dev_attr_store+0x13/0x20
[Mon Nov  6 09:55:19 2017]  [<ffffffff8120b742>] sysfs_kf_write+0x32/0x40
[Mon Nov  6 09:55:19 2017]  [<ffffffff8120b2ce>] kernfs_fop_write+0x12e/0x180
[Mon Nov  6 09:55:19 2017]  [<ffffffff81196583>] __vfs_write+0x23/0xe0
[Mon Nov  6 09:55:19 2017]  [<ffffffff81098a3d>] ? percpu_down_read+0xd/0x50
[Mon Nov  6 09:55:19 2017]  [<ffffffff81196cbf>] vfs_write+0xaf/0x1a0
[Mon Nov  6 09:55:19 2017]  [<ffffffff811979ca>] SyS_write+0x4a/0xb0
[Mon Nov  6 09:55:19 2017]  [<ffffffff81803dd7>]
entry_SYSCALL_64_fastpath+0x12/0x6a

For multipath we are not using:
    path_checker tur
    rr_min_io 1
    polling_interval 10
    path_grouping_policy "multibus"
    flush_on_last_del yes
    path_selector "round-robin 0"
    no_path_retry fail

I suspect could be missing run queue or lost IO, IMHO it's unlikely
below disk probing fix the bug.

Regards,
Jack

>
> Subject: [PATCH] Increase SCSI disk probing concurrency
>
> ---
>  drivers/scsi/scsi.c        |  5 -----
>  drivers/scsi/scsi_pm.c     |  6 ++++--
>  drivers/scsi/scsi_priv.h   |  1 -
>  drivers/scsi/sd.c          | 26 +++++++++++++++++++++-----
>  drivers/scsi/sd.h          |  1 +
>  include/scsi/scsi_driver.h |  1 +
>  6 files changed, 27 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a7e4fba724b7..e6d69e647f6a 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -85,10 +85,6 @@ unsigned int scsi_logging_level;
>  EXPORT_SYMBOL(scsi_logging_level);
>  #endif
>
> -/* sd, scsi core and power management need to coordinate flushing async actions */
> -ASYNC_DOMAIN(scsi_sd_probe_domain);
> -EXPORT_SYMBOL(scsi_sd_probe_domain);
> -
>  /*
>   * Separate domain (from scsi_sd_probe_domain) to maximize the benefit of
>   * asynchronous system resume operations.  It is marked 'exclusive' to avoid
> @@ -839,7 +835,6 @@ static void __exit exit_scsi(void)
>         scsi_exit_devinfo();
>         scsi_exit_procfs();
>         scsi_exit_queue();
> -       async_unregister_domain(&scsi_sd_probe_domain);
>  }
>
>  subsys_initcall(init_scsi);
> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
> index b44c1bb687a2..d8e43c2f4d40 100644
> --- a/drivers/scsi/scsi_pm.c
> +++ b/drivers/scsi/scsi_pm.c
> @@ -171,9 +171,11 @@ static int scsi_bus_resume_common(struct device *dev,
>  static int scsi_bus_prepare(struct device *dev)
>  {
>         if (scsi_is_sdev_device(dev)) {
> -               /* sd probing uses async_schedule.  Wait until it finishes. */
> -               async_synchronize_full_domain(&scsi_sd_probe_domain);
> +               struct scsi_driver *drv = to_scsi_driver(dev->driver);
>
> +               /* sd probing happens asynchronously. Wait until it finishes. */
> +               if (drv->sync)
> +                       drv->sync(dev);
>         } else if (scsi_is_host_device(dev)) {
>                 /* Wait until async scanning is finished */
>                 scsi_complete_async_scans();
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index dab29f538612..bf0cadf6a321 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -174,7 +174,6 @@ static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
>  #endif /* CONFIG_PM */
>
>  extern struct async_domain scsi_sd_pm_domain;
> -extern struct async_domain scsi_sd_probe_domain;
>
>  /* scsi_dh.c */
>  #ifdef CONFIG_SCSI_DH
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 0313486d85c8..c26dbb38b60c 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -112,6 +112,7 @@ static void sd_shutdown(struct device *);
>  static int sd_suspend_system(struct device *);
>  static int sd_suspend_runtime(struct device *);
>  static int sd_resume(struct device *);
> +static void sd_sync_probe_domain(struct device *dev);
>  static void sd_rescan(struct device *);
>  static int sd_init_command(struct scsi_cmnd *SCpnt);
>  static void sd_uninit_command(struct scsi_cmnd *SCpnt);
> @@ -564,6 +565,7 @@ static struct scsi_driver sd_template = {
>                 .shutdown       = sd_shutdown,
>                 .pm             = &sd_pm_ops,
>         },
> +       .sync                   = sd_sync_probe_domain,
>         .rescan                 = sd_rescan,
>         .init_command           = sd_init_command,
>         .uninit_command         = sd_uninit_command,
> @@ -3221,9 +3223,9 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
>  /*
>   * The asynchronous part of sd_probe
>   */
> -static void sd_probe_async(void *data, async_cookie_t cookie)
> +static void sd_probe_async(struct work_struct *work)
>  {
> -       struct scsi_disk *sdkp = data;
> +       struct scsi_disk *sdkp = container_of(work, typeof(*sdkp), probe_work);
>         struct scsi_device *sdp;
>         struct gendisk *gd;
>         u32 index;
> @@ -3326,6 +3328,8 @@ static int sd_probe(struct device *dev)
>         if (!sdkp)
>                 goto out;
>
> +       INIT_WORK(&sdkp->probe_work, sd_probe_async);
> +
>         gd = alloc_disk(SD_MINORS);
>         if (!gd)
>                 goto out_free;
> @@ -3377,8 +3381,8 @@ static int sd_probe(struct device *dev)
>         get_device(dev);
>         dev_set_drvdata(dev, sdkp);
>
> -       get_device(&sdkp->dev); /* prevent release before async_schedule */
> -       async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
> +       get_device(&sdkp->dev); /* prevent release before sd_probe_async() */
> +       WARN_ON_ONCE(!queue_work(system_unbound_wq, &sdkp->probe_work));
>
>         return 0;
>
> @@ -3395,6 +3399,18 @@ static int sd_probe(struct device *dev)
>         return error;
>  }
>
> +static void sd_wait_for_probing(struct scsi_disk *sdkp)
> +{
> +       flush_work(&sdkp->probe_work);
> +}
> +
> +static void sd_sync_probe_domain(struct device *dev)
> +{
> +       struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +
> +       sd_wait_for_probing(sdkp);
> +}
> +
>  /**
>   *     sd_remove - called whenever a scsi disk (previously recognized by
>   *     sd_probe) is detached from the system. It is called (potentially
> @@ -3416,7 +3432,7 @@ static int sd_remove(struct device *dev)
>         scsi_autopm_get_device(sdkp->device);
>
>         async_synchronize_full_domain(&scsi_sd_pm_domain);
> -       async_synchronize_full_domain(&scsi_sd_probe_domain);
> +       sd_wait_for_probing(sdkp);
>         device_del(&sdkp->dev);
>         del_gendisk(sdkp->disk);
>         sd_shutdown(dev);
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 7b57dafcd45a..2cc47183c9aa 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -81,6 +81,7 @@ struct scsi_disk {
>         unsigned int    zones_optimal_nonseq;
>         unsigned int    zones_max_open;
>  #endif
> +       struct work_struct probe_work;
>         atomic_t        openers;
>         sector_t        capacity;       /* size in logical blocks */
>         u32             max_xfer_blocks;
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index a5534ccad859..145d6239eecf 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -11,6 +11,7 @@ struct scsi_device;
>  struct scsi_driver {
>         struct device_driver    gendrv;
>
> +       void (*sync)(struct device *);
>         void (*rescan)(struct device *);
>         int (*init_command)(struct scsi_cmnd *);
>         void (*uninit_command)(struct scsi_cmnd *);
> --
> 2.15.0

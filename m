From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's
 request queue
Date: Thu, 08 Dec 2016 09:04:46 -0500
Message-ID: <1481205886.28416.273.camel@localhost.localdomain>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
         <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
         <584763FB.9010602@huawei.com>
         <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
         <584784D7.1070009@huawei.com>
         <BLUPR02MB1683A85CB4376E9904F1B38881850@BLUPR02MB1683.namprd02.prod.outlook.com>
         <5847B355.2050100@huawei.com>
         <9d9b3296-09d8-0f65-f52d-33fc19c4b6c2@sandisk.com>
         <d5b9960c-b68c-c636-dd1d-dfd056d99e52@sandisk.com>
         <1481132411.28416.232.camel@localhost.localdomain>
         <1481134565.2354.43.camel@linux.vnet.ibm.com>
         <1481138661.28416.238.camel@localhost.localdomain>
         <1481141375.2354.53.camel@linux.vnet.ibm.com>
         <1481142648.28416.244.camel@localhost.localdomain>
         <1481154187.2354.67.camel@linux.vnet.ibm.com> <5848C535.5010408@huawei.com>
         <1481164381.2354.81.camel@linux.vnet.ibm.com> <5848D205.8060007@huawei.com>
         <5848FFD8.5070606@huawei.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752495AbcLHOEs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Dec 2016 09:04:48 -0500
In-Reply-To: <5848FFD8.5070606@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, chenzengxi@huawei.com

On Thu, 2016-12-08 at 14:38 +0800, Wei Fang wrote:
> Hi, James, Ewan, Bart,
> 
> On 2016/12/8 11:22, Wei Fang wrote:
> > I looked through those code and found that if we fix this bug
> > by removing setting the state in scsi_sysfs_add_sdev(), it
> > can't be fixed completely:
> > 
> > scsi_device_set_state(sdev, SDEV_RUNNING) in scsi_add_lun() and
> > scsi_device_set_state(sdev, SDEV_CREATED_BLOCK) in scsi_internal_device_block()
> > can be called simultaneously. Because there is no synchronization
> > between scsi_device_set_state(), those calls may both return
> > success, and the state may be SDEV_RUNNING after that, and the
> > device queue is stopped.
> 
> Can we fix it in this way:
> 
> Add a state lock to make sure the result of simultaneously calling
> of scsi_device_set_state() is not unpredictable.
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 253ee74..80cb493 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2457,10 +2457,16 @@ EXPORT_SYMBOL(scsi_test_unit_ready);
>  int
>  scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
>  {
> -       enum scsi_device_state oldstate = sdev->sdev_state;
> +       enum scsi_device_state oldstate;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&sdev->state_lock, flags);
> +       oldstate = sdev->sdev_state;
> 
> -       if (state == oldstate)
> +       if (state == oldstate) {
> +               spin_unlock_irqrestore(&sdev->state_lock, flags);
>                 return 0;
> +       }
> 
>         switch (state) {
>         case SDEV_CREATED:
> @@ -2558,9 +2564,11 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
> 
>         }
>         sdev->sdev_state = state;
> +       spin_unlock_irqrestore(&sdev->state_lock, flags);
>         return 0;
> 
>   illegal:
> +       spin_unlock_irqrestore(&sdev->state_lock, flags);
>         SCSI_LOG_ERROR_RECOVERY(1,
>                                 sdev_printk(KERN_ERR, sdev,
>                                             "Illegal state transition %s->%s",
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6f7128f..ba2f38f 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -238,6 +238,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>         INIT_LIST_HEAD(&sdev->starved_entry);
>         INIT_LIST_HEAD(&sdev->event_list);
>         spin_lock_init(&sdev->list_lock);
> +       spin_lock_init(&sdev->state_lock);
>         mutex_init(&sdev->inquiry_mutex);
>         INIT_WORK(&sdev->event_work, scsi_evt_thread);
>         INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 0734927..82dfe07 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1204,10 +1204,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>         struct request_queue *rq = sdev->request_queue;
>         struct scsi_target *starget = sdev->sdev_target;
> 
> -       error = scsi_device_set_state(sdev, SDEV_RUNNING);
> -       if (error)
> -               return error;
> -
>         error = scsi_target_add(starget);
>         if (error)
>                 return error;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 8990e58..e00764e 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -31,7 +31,7 @@ struct scsi_mode_data {
>  enum scsi_device_state {
>         SDEV_CREATED = 1,       /* device created but not added to sysfs
>                                  * Only internal commands allowed (for inq) */
> -       SDEV_RUNNING,           /* device properly configured
> +       SDEV_RUNNING,           /* device properly initialized
>                                  * All commands allowed */
>         SDEV_CANCEL,            /* beginning to delete device
>                                  * Only error handler commands allowed */
> @@ -207,6 +207,7 @@ struct scsi_device {
>         void                    *handler_data;
> 
>         unsigned char           access_state;
> +       spinlock_t              state_lock;
>         enum scsi_device_state sdev_state;
>         unsigned long           sdev_data[0];
>  } __attribute__((aligned(sizeof(unsigned long))));
> 
> Haven't tested yet. Sending this for your opinion.
> 
> Thanks,
> Wei
> 

You would presumably need to take your lock in scsi_internal_device_unblock()
as well, since it also checks and updates sdev_state directly.  There are also
places like scsi_device_resume() that examine the state before deciding to
call scsi_device_set_state().

-Ewan





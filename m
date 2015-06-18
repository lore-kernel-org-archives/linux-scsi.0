From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 17/20 v1] [SCSI] mpt3sas: Use alloc_ordered_workqueue()
 API instead of create_singlethread_workqueue() API
Date: Thu, 18 Jun 2015 08:10:04 -0400
Message-ID: <5582B51C.8070700@stratus.com>
References: <1434433027-40682-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1434433027-40682-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org, hch@infradead.org, jthumshirn@suse.de
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 06/16/2015 01:37 AM, Sreekanth Reddy wrote:
> Created a thread using alloc_ordered_workqueue() API in order to process
> the works from firmware Work-queue sequentially instead of
> create_singlethread_workqueue() API.
> 
> Changes in v1:
>     No need to check for backport compatibility in the upstream kernel.
> so removing the else section where driver use 
> create_singlethread_workqueue() API if alloc_ordered_workqueue() API is
> not defined, This else section is not required since in the latest upstream
> kernel this alloc_ordered_workqueue() API is always defined.
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index b848458..7e5926c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -8085,8 +8085,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	/* event thread */
>  	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
>  	    "fw_event%d", ioc->id);
> -	ioc->firmware_event_thread = create_singlethread_workqueue(
> -	    ioc->firmware_event_name);
> +	ioc->firmware_event_thread = alloc_ordered_workqueue(
> +	    ioc->firmware_event_name, WQ_MEM_RECLAIM);
>  	if (!ioc->firmware_event_thread) {
>  		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
>  		    ioc->name, __FILE__, __LINE__, __func__);
> 

Hi Sreekanth,

Is this change still needed after e09c2c2954684 workqueue: apply
__WQ_ORDERED to create_singlethread_workqueue() ?  (3.17+)

In upstream, this change looks cosmetic (unless Tejun has a preference
for one over the other), but maybe converting to alloc_ordered_workqueue
keeps your in house version in closer sync?

Thanks,

-- Joe

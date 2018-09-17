From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 5/5] scsi: libsas: fix a race condition when smp task
 timeout
Date: Mon, 17 Sep 2018 15:57:57 +0200
Message-ID: <58397edb-e05c-f782-1f2a-c9a1dae4b525@suse.com>
References: <20180912082946.34814-1-yanaijie@huawei.com>
 <20180912082946.34814-6-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180912082946.34814-6-yanaijie@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, zhaohongjiang@huawei.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 09/12/2018 10:29 AM, Jason Yan wrote:
> When the lldd is processing the complete sas task in interrupt and set
> the task stat as SAS_TASK_STATE_DONE, the smp timeout timer is able to
> be triggered at the same time. And smp_task_timedout() will complete the
> task wheter the SAS_TASK_STATE_DONE is set or not. Then the sas task may
> freed before lldd end the interrupt process. Thus a use-after-free will
> happen.
> 
> Fix this by calling the complete() only when SAS_TASK_STATE_DONE is not
> set. And remove the check of the return value of the del_timer().
> 
> Reported-by: chenxiang <chenxiang66@hisilicon.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> CC: John Garry <john.garry@huawei.com>
> CC: Johannes Thumshirn <jthumshirn@suse.de>
> CC: Ewan Milne <emilne@redhat.com>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Tomas Henzl <thenzl@redhat.com>
> CC: Dan Williams <dan.j.williams@intel.com>
> CC: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/libsas/sas_expander.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 52222940d398..0d1f72752ca2 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -48,17 +48,16 @@ static void smp_task_timedout(struct timer_list *t)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&task->task_state_lock, flags);
> -	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
> +	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
>  		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
> +		complete(&task->slow_task->completion);
> +	}
>  	spin_unlock_irqrestore(&task->task_state_lock, flags);
> -
> -	complete(&task->slow_task->completion);
>  }
>  
>  static void smp_task_done(struct sas_task *task)
>  {
> -	if (!del_timer(&task->slow_task->timer))
> -		return;
> +	del_timer(&task->slow_task->timer);
>  	complete(&task->slow_task->completion);
>  }
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

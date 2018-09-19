From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v2 5/5] scsi: libsas: fix a race condition when smp task
 timeout
Date: Wed, 19 Sep 2018 09:42:45 +0100
Message-ID: <e4383f9f-7fd8-be48-3ea2-5e65dceae584@huawei.com>
References: <20180919033204.11102-1-yanaijie@huawei.com>
 <20180919033204.11102-6-yanaijie@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919033204.11102-6-yanaijie@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com, hare@suse.com, dan.j.williams@intel.com, jthumshirn@suse.de, hch@lst.de, huangdaode@hisilicon.com, chenxiang66@hisilicon.com, miaoxie@huawei.com, Ewan Milne <emilne@redhat.com>, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 19/09/2018 04:32, Jason Yan wrote:
> When the lldd is processing the complete sas task in interrupt and set
> the task stat as SAS_TASK_STATE_DONE, the smp timeout timer is able to
> be triggered at the same time. And smp_task_timedout() will complete the
> task wheter the SAS_TASK_STATE_DONE is set or not. Then the sas task may
> freed before lldd end the interrupt process. Thus a use-after-free will
> happen.
>
> Fix this by calling the complete() only when SAS_TASK_STATE_DONE is not
> set. And remove the check of the return value of the del_timer(). Once
> the LLDD sets DONE, it must call task->done(), which will call
> smp_task_done()->complete() and the task will be completed and freed
> correctly.
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

Uh, I should have added this for my last comment on v1:
Reviewed-by: John Garry <john.garry@huawei.com>

> Reviewed-by: Hannes Reinecke <hare@suse.com>
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

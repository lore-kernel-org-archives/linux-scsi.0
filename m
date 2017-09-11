From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] scsi: shost->async_scan should be protected by mutex_lock
Date: Sun, 10 Sep 2017 18:44:26 -0700
Message-ID: <8e8d0a1b-f053-6eab-a85a-ec83201b50be@gmail.com>
References: <f99d1494-af46-4f0f-5a24-bb88a860d0fe@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f99d1494-af46-4f0f-5a24-bb88a860d0fe@huawei.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "Ouyangzhaowei (Charles)" <ouyangzhaowei@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Suoben <suoben@huawei.com>, "Wulizhen (Pss)" <pss.wulizhen@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 09/07/2017 11:54 PM, Ouyangzhaowei (Charles) wrote:
> shost->async_scan should be protected by mutex_lock, otherwise the check
> of "called twice" won't work.
> 
> Signed-off-by: Ouyang Zhaowei <ouyangzhaowei@huawei.com>
> ---
>  drivers/scsi/scsi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index fd88dab..1d1df51 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1722,6 +1722,7 @@ static struct async_scan_data
> *scsi_prep_async_scan(struct Scsi_Host *shost)
>         if (strncmp(scsi_scan_type, "sync", 4) == 0)
>                 return NULL;
> 
> +       mutex_lock(&shost->scan_mutex);

The mutex will not be unlocked in the event that either the host has called
scsi_prep_async_scan() twice, or a condition is meet the branches to the "err" label prior
to where the original mutex_lock() was located below.

-Tyrel

>         if (shost->async_scan) {
>                 shost_printk(KERN_DEBUG, shost, "%s called twice\n",
> __func__);
>                 return NULL;
> @@ -1735,7 +1736,6 @@ static struct async_scan_data
> *scsi_prep_async_scan(struct Scsi_Host *shost)
>                 goto err;
>         init_completion(&data->prev_finished);
> 
> -       mutex_lock(&shost->scan_mutex);
>         spin_lock_irqsave(shost->host_lock, flags);
>         shost->async_scan = 1;
>         spin_unlock_irqrestore(shost->host_lock, flags);
> 

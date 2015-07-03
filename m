From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: use shost_for_each_device() instead of
 open coding
Date: Fri, 3 Jul 2015 18:34:41 +0000
Message-ID: <BY2PR0301MB165414DB098870532C34064FA0960@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1435743087-7824-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435743087-7824-1-git-send-email-vkuznets@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Long Li <longli@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Wednesday, July 1, 2015 2:31 AM
> To: linux-scsi@vger.kernel.org
> Cc: Long Li; KY Srinivasan; Haiyang Zhang; James E.J. Bottomley;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: storvsc: use shost_for_each_device() instead of open
> coding
> 
> Comment in struct Scsi_Host says that drivers are not supposed to access
> __devices directly. storvsc_host_scan() doesn't happen in irq context
> so we can just use shost_for_each_device().
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 3c6584f..9ea912b 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -426,7 +426,6 @@ static void storvsc_host_scan(struct work_struct
> *work)
>  	struct storvsc_scan_work *wrk;
>  	struct Scsi_Host *host;
>  	struct scsi_device *sdev;
> -	unsigned long flags;
> 
>  	wrk = container_of(work, struct storvsc_scan_work, work);
>  	host = wrk->host;
> @@ -443,14 +442,8 @@ static void storvsc_host_scan(struct work_struct
> *work)
>  	 * may have been removed this way.
>  	 */
>  	mutex_lock(&host->scan_mutex);
> -	spin_lock_irqsave(host->host_lock, flags);
> -	list_for_each_entry(sdev, &host->__devices, siblings) {
> -		spin_unlock_irqrestore(host->host_lock, flags);
> +	shost_for_each_device(sdev, host)
>  		scsi_test_unit_ready(sdev, 1, 1, NULL);
> -		spin_lock_irqsave(host->host_lock, flags);
> -		continue;
> -	}
> -	spin_unlock_irqrestore(host->host_lock, flags);
>  	mutex_unlock(&host->scan_mutex);
>  	/*
>  	 * Now scan the host to discover LUNs that may have been added.
> --
> 2.4.3

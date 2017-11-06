From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH] storvsc: Avoid excessive host scan on controller change
Date: Mon, 6 Nov 2017 13:01:35 -0500
Message-ID: <5A00A37F.9070601@redhat.com>
References: <20171031215808.11629-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171031215808.11629-1-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@exchange.microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/31/2017 05:58 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
>
> When there are multiple disks attached to the same SCSI controller,
> the host may send several VSTOR_OPERATION_REMOVE_DEVICE or
> VSTOR_OPERATION_ENUMERATE_BUS messages in a row, to indicate there is a
> change on the SCSI controller. In response, storvsc rescans the SCSI host.
>
> There is no need to do multiple scans on the same host. Fix the code to do
> only one scan.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   drivers/scsi/storvsc_drv.c | 26 +++++++++++---------------
>   1 file changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 6febcdb..b602f52 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -488,6 +488,8 @@ struct hv_host_device {
>   	unsigned char target;
>   	struct workqueue_struct *handle_error_wq;
>   	char work_q_name[20];
> +	struct work_struct host_scan_work;
> +	struct Scsi_Host *host;
>   };
>   
>   struct storvsc_scan_work {
> @@ -516,13 +518,12 @@ static void storvsc_device_scan(struct work_struct *work)
>   
>   static void storvsc_host_scan(struct work_struct *work)
>   {
> -	struct storvsc_scan_work *wrk;
>   	struct Scsi_Host *host;
>   	struct scsi_device *sdev;
> +	struct hv_host_device *host_device =
> +		container_of(work, struct hv_host_device, host_scan_work);
>   
> -	wrk = container_of(work, struct storvsc_scan_work, work);
> -	host = wrk->host;
> -
> +	host = host_device->host;
>   	/*
>   	 * Before scanning the host, first check to see if any of the
>   	 * currrently known devices have been hot removed. We issue a
> @@ -542,8 +543,6 @@ static void storvsc_host_scan(struct work_struct *work)
>   	 * Now scan the host to discover LUNs that may have been added.
>   	 */
>   	scsi_scan_host(host);
> -
> -	kfree(wrk);
>   }
>   
>   static void storvsc_remove_lun(struct work_struct *work)
> @@ -1119,8 +1118,7 @@ static void storvsc_on_receive(struct storvsc_device *stor_device,
>   			     struct vstor_packet *vstor_packet,
>   			     struct storvsc_cmd_request *request)
>   {
> -	struct storvsc_scan_work *work;
> -
> +	struct hv_host_device *host_dev;
>   	switch (vstor_packet->operation) {
>   	case VSTOR_OPERATION_COMPLETE_IO:
>   		storvsc_on_io_completion(stor_device, vstor_packet, request);
> @@ -1128,13 +1126,9 @@ static void storvsc_on_receive(struct storvsc_device *stor_device,
>   
>   	case VSTOR_OPERATION_REMOVE_DEVICE:
>   	case VSTOR_OPERATION_ENUMERATE_BUS:
> -		work = kmalloc(sizeof(struct storvsc_scan_work), GFP_ATOMIC);
> -		if (!work)
> -			return;
> -
> -		INIT_WORK(&work->work, storvsc_host_scan);
> -		work->host = stor_device->host;
> -		schedule_work(&work->work);
> +		host_dev = shost_priv(stor_device->host);
> +		queue_work(
> +			host_dev->handle_error_wq, &host_dev->host_scan_work);
>   		break;
>   
>   	case VSTOR_OPERATION_FCHBA_DATA:
> @@ -1747,6 +1741,7 @@ static int storvsc_probe(struct hv_device *device,
>   
>   	host_dev->port = host->host_no;
>   	host_dev->dev = device;
> +	host_dev->host = host;
>   
>   
>   	stor_device = kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);
> @@ -1815,6 +1810,7 @@ static int storvsc_probe(struct hv_device *device,
>   			create_singlethread_workqueue(host_dev->work_q_name);
>   	if (!host_dev->handle_error_wq)
>   		goto err_out2;
> +	INIT_WORK(&host_dev->host_scan_work, storvsc_host_scan);
>   	/* Register the HBA and start the scsi bus scan */
>   	ret = scsi_add_host(host, &device->device);
>   	if (ret != 0)

I've tested this patch with both a multipath failover while running fio 
and taking hyperV snap shots while luns are being hot added and removed.

Tested-by: Cathy Avery <cavery@redhat.com>

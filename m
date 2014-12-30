From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 1/4] Drivers: scsi: storvsc: In responce to a scan event,
 scan the host
Date: Tue, 30 Dec 2014 19:21:52 +0000
Message-ID: <BLUPR03MB4075B290CA33C4BDFD03B7ACE5E0@BLUPR03MB407.namprd03.prod.outlook.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1418764905-11250-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: KY Srinivasan <kys@microsoft.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of K. Y. Srinivasan
> Sent: Tuesday, December 16, 2014 1:22 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> jbottomley@parallels.com; hch@infradead.org; linux-scsi@vger.kernel.org
> Subject: [PATCH 1/4] Drivers: scsi: storvsc: In responce to a scan event, scan
> the host
> 
> The virtual HBA that storvsc implements can support multiple channels and
> targets. So, scan the host when the host notifies that a scan is needed.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |   19 +++++++------------
>  1 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> e3ba251..0a96fef 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -426,21 +426,16 @@ done:
>  	kfree(wrk);
>  }
> 
> -static void storvsc_bus_scan(struct work_struct *work)
> +static void storvsc_host_scan(struct work_struct *work)
>  {
>  	struct storvsc_scan_work *wrk;
> -	int id, order_id;
> +	struct Scsi_Host *host;
> 
>  	wrk = container_of(work, struct storvsc_scan_work, work);
> -	for (id = 0; id < wrk->host->max_id; ++id) {
> -		if (wrk->host->reverse_ordering)
> -			order_id = wrk->host->max_id - id - 1;
> -		else
> -			order_id = id;
> -
> -		scsi_scan_target(&wrk->host->shost_gendev, 0,
> -				order_id, SCAN_WILD_CARD, 1);
> -	}
> +	host = wrk->host;
> +
> +	scsi_scan_host(host);
> +
>  	kfree(wrk);
>  }
> 
> @@ -1198,7 +1193,7 @@ static void storvsc_on_receive(struct hv_device
> *device,
>  		if (!work)
>  			return;
> 
> -		INIT_WORK(&work->work, storvsc_bus_scan);
> +		INIT_WORK(&work->work, storvsc_host_scan);
>  		work->host = stor_device->host;
>  		schedule_work(&work->work);
>  		break;
> --
> 1.7.4.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

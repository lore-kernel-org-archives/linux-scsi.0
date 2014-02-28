From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc_device_destroy NULL pointer fix
Date: Fri, 28 Feb 2014 02:08:26 +0000
Message-ID: <3f6f360973de44bcb1991c510ca8a81e@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1393495410-17575-1-git-send-email-alnovak@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393495410-17575-1-git-send-email-alnovak@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ales Novak <alnovak@suse.cz>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jkosina@suse.cz" <jkosina@suse.cz>, Thomas Abraham <tabraham@suse.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Ales Novak [mailto:alnovak@suse.cz]
> Sent: Thursday, February 27, 2014 2:04 AM
> To: KY Srinivasan; James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> jkosina@suse.cz; Ales Novak; Thomas Abraham
> Subject: [PATCH] scsi: storvsc_device_destroy NULL pointer fix
> 
> If the initialization of storvsc fails, the storvsc_device_destroy() causes NULL
> pointer dereference.
> 
> storvsc_bus_scan()
>   scsi_scan_target()
>     __scsi_scan_target()
>       scsi_probe_and_add_lun(hostdata=NULL)
>         scsi_alloc_sdev(hostdata=NULL)
> 
> 	  sdev->hostdata = hostdata
> 
> 	  now the host allocation fails
> 
>           __scsi_remove_device(sdev)
> 
> 	  calls sdev->host->hostt->slave_destroy() ==
> 	  storvsc_device_destroy(sdev)
> 	    access of sdev->hostdata->request_mempool
> 
> Signed-off-by: Ales Novak <alnovak@suse.cz>
> Signed-off-by: Thomas Abraham <tabraham@suse.com>
> Acked-by: Jiri Kosina <jkosina@suse.cz>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c index
> 17d7404..9969fa1 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1419,6 +1419,9 @@ static void storvsc_device_destroy(struct
> scsi_device *sdevice)  {
>  	struct stor_mem_pools *memp = sdevice->hostdata;
> 
> +	if (!memp)
> +		return;
> +
>  	mempool_destroy(memp->request_mempool);
>  	kmem_cache_destroy(memp->request_pool);
>  	kfree(memp);
> --
> 1.8.1.4

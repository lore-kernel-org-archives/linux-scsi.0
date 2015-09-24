From: Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH 2/3] ibmvcsci: display default value for max_id, max_lun
 and max_channel.
Date: Thu, 24 Sep 2015 18:16:02 +0200
Message-ID: <560421C2.5000903@redhat.com>
References: <1441876994-16821-1-git-send-email-lvivier@redhat.com>
 <1441876994-16821-2-git-send-email-lvivier@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441876994-16821-2-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, dgibson@redhat.com, thuth@redhat.com, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

Ping ?

On 10/09/2015 11:23, Laurent Vivier wrote:
> As devices with values greater than that are silently ignored,
> this gives some hints to the sys admin to know why he doesn't see
> his devices...
> 
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 3e76490..f9d7ec4 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -106,9 +106,9 @@ MODULE_LICENSE("GPL");
>  MODULE_VERSION(IBMVSCSI_VERSION);
>  
>  module_param_named(max_id, max_id, int, S_IRUGO);
> -MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
> +MODULE_PARM_DESC(max_id, "Largest ID value for each channel [Default=64]");
>  module_param_named(max_channel, max_channel, int, S_IRUGO);
> -MODULE_PARM_DESC(max_channel, "Largest channel value");
> +MODULE_PARM_DESC(max_channel, "Largest channel value [Default=3]");
>  module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
>  module_param_named(max_requests, max_requests, int, S_IRUGO);
> @@ -2294,6 +2294,10 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>  	host->max_channel = max_channel;
>  	host->max_cmd_len = 16;
>  
> +	dev_info(dev,
> +		 "Maximum ID: %d Maximum LUN: %d Maximum Channel: %d\n",
> +		 host->max_id, host->max_lun, host->max_channel);
> +
>  	if (scsi_add_host(hostdata->host, hostdata->dev))
>  		goto add_host_failed;
>  
> 

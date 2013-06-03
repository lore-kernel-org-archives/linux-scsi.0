From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/5] Drivers: scsi: storvsc: Make the scsi timeout a
 module parameter
Date: Mon, 3 Jun 2013 23:03:01 +0000
Message-ID: <1370300581.2013.14.camel@dabdike.int.hansenpartnership.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
	 <1370301688-27286-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370301688-27286-1-git-send-email-kys@microsoft.com>
Content-Language: en-US
Content-ID: <CCA35D962D415D449099BF7AF5127F5E@sw.swsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-06-03 at 16:21 -0700, K. Y. Srinivasan wrote:
> The standard scsi timeout is not appropriate in some of the environments where
> Hyper-V is deployed. Set this timeout appropriately for all devices managed
> by this driver. Further make this a module parameter.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 16a3a0c..8d29a95 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -221,6 +221,13 @@ static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
>  module_param(storvsc_ringbuffer_size, int, S_IRUGO);
>  MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
>  
> +/*
> + * Timeout in seconds for all devices managed by this driver.
> + */
> +static int storvsc_timeout = 180;
> +module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
> +MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
> +
>  #define STORVSC_MAX_IO_REQUESTS				128
>  
>  /*
> @@ -1204,6 +1211,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
>  
>  	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
>  
> +	blk_queue_rq_timeout(sdevice->request_queue, (storvsc_timeout * HZ));

Why does this need to be a module parameter?  It's already a sysfs one
in the scsi_device class?  Three minutes is also a bit large.  The
default is 30s with huge cache arrays recommending upping this to
60s ... you're three times this.

James

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi/sd: release scan_mutex during sync_cache and
 start_stop
Date: Wed, 8 Feb 2017 13:02:58 -0800
Message-ID: <20170208210258.GA8957@infradead.org>
References: <20170208204240.4002411-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39337 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdBHVUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 16:20:52 -0500
Content-Disposition: inline
In-Reply-To: <20170208204240.4002411-1-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Feb 08, 2017 at 12:42:40PM -0800, Song Liu wrote:
> When a device is deleted through sysfs handle "delete", the code
> locks shost->scan_mutex. If multiple devices are deleted at the
> same time, these deletes will be handled in series.
> 
> On the other hand, sd_shutdown() sometimes issues long latency
> commands: sync cache and start_stop. It is not necessary for these
> commands to run in series.
> 
> To reduce latency of parallel "delete" requests, this patch unlock
> shost->scan_mutex before long latency commands and relock the mutex
> after the command.
> 
> Fixed bug from previous version.
> 
> Reported-by: kernel test robot <fengguang.wu@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  drivers/scsi/sd.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 9e0783b..22add77 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3304,6 +3304,9 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct scsi_device *sdev;
> +	struct Scsi_Host *shost;
> +	bool scan_mutex_locked;
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
> @@ -3311,14 +3314,26 @@ static void sd_shutdown(struct device *dev)
>  	if (pm_runtime_suspended(dev))
>  		return;
>  
> +	sdev = sdkp->device;
> +	shost = sdev->host;
> +	scan_mutex_locked = mutex_is_locked(&shost->scan_mutex);

The use of mutex_is_locked outside of asserts is always bogus.

The fix you want is most like in the caller of the method.

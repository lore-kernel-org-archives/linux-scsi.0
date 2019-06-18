From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: Re: [PATCH] scsi: scsi_sysfs.c: Hide wwid sdev attr if VPD is not
 supported
Date: Tue, 18 Jun 2019 19:47:36 -0300
Message-ID: <20190618224734.GB11899@continental>
References: <20190612020828.8140-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190612020828.8140-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

ping? Can anybody take a look at this patch?

Thanks,
Marcos

On Tue, Jun 11, 2019 at 11:08:28PM -0300, Marcos Paulo de Souza wrote:
> WWID composed from VPD data from device, specifically page 0x83. So,
> when a device does not have VPD support, for example USB storage devices
> where VPD is specifically disabled, a read into <blk device>/device/wwid
> file will always return ENXIO. To avoid this, change the
> scsi_sdev_attr_is_visible function to hide wwid sysfs file when the
> devices does not support VPD.
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---
>  drivers/scsi/scsi_sysfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dbb206c90ecf..bfd890fa0c69 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1159,6 +1159,9 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
>  	struct device *dev = container_of(kobj, struct device, kobj);
>  	struct scsi_device *sdev = to_scsi_device(dev);
>  
> +	/* do not present wwid if the device does not support VPD */
> +	if (attr == &dev_attr_wwid.attr && sdev->skip_vpd_pages)
> +		return 0;
>  
>  	if (attr == &dev_attr_queue_depth.attr &&
>  	    !sdev->host->hostt->change_queue_depth)
> -- 
> 2.21.0
> 

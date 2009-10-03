From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Sat, 3 Oct 2009 16:19:47 +0900
Message-ID: <200910031619.GHF86400.QSVFFFLOMOtHOJ@I-love.SAKURA.ne.jp>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
	<1253625194.5923.10.camel@concordia>
	<1254508208.3874.131.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753413AbZJCHTw@vger.kernel.org>
In-Reply-To: <1254508208.3874.131.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de, michael@ellerman.id.au
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
List-Id: linux-scsi@vger.kernel.org

Hello.

James Bottomley wrote:
> Can we verify this fixes the memory leak?
I tested this patch on 2.6.31.1 and verified that
the memory leak was solved by this patch.

Thank you.
> 
> ---
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index c447838..0547a7f 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -317,6 +317,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>  out_device_destroy:
>  	scsi_device_set_state(sdev, SDEV_DEL);
>  	transport_destroy_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  	put_device(&sdev->sdev_gendev);
>  out:
>  	if (display_failure_msg)
> @@ -957,6 +958,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);
>  	transport_destroy_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  	put_device(&sdev->sdev_gendev);
>  }
>  
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index fde5453..5c7eb63 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -864,10 +864,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  		goto clean_device;
>  	}
>  
> -	/* take a reference for the sdev_dev; this is
> -	 * released by the sdev_class .release */
> -	get_device(&sdev->sdev_gendev);
> -
>  	/* create queue files, which may be writable, depending on the host */
>  	if (sdev->host->hostt->change_queue_depth)
>  		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
> @@ -917,6 +913,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  
>  	device_del(&sdev->sdev_gendev);
>  	transport_destroy_device(&sdev->sdev_gendev);
> +	put_device(&sdev->sdev_dev);
>  	put_device(&sdev->sdev_gendev);
>  
>  	return error;
> @@ -1065,7 +1062,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>  		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
>  
>  	device_initialize(&sdev->sdev_dev);
> -	sdev->sdev_dev.parent = &sdev->sdev_gendev;
> +	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
>  	sdev->sdev_dev.class = &sdev_class;
>  	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
>  		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);

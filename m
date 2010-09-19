From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 10/14] scsi: osd: fix device_register() error handling
Date: Sun, 19 Sep 2010 16:26:53 +0200
Message-ID: <20100919142653.GF6236@bicker>
References: <1284900907-24621-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1284900907-24621-1-git-send-email-segooon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 19, 2010 at 04:55:07PM +0400, Vasiliy Kulikov wrote:
> If device_register() fails then call put_device().
> See comment to device_register.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  compile tested.
> 
>  drivers/scsi/osd/osd_uld.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index cefb2c0..3e0edc2 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -474,7 +474,7 @@ static int osd_probe(struct device *dev)
>  	error = device_register(&oud->class_dev);
>  	if (error) {
>  		OSD_ERR("device_register failed => %d\n", error);
> -		goto err_put_cdev;
> +		goto err_put_device;
>  	}
>  
>  	get_device(&oud->class_dev);
> @@ -482,6 +482,8 @@ static int osd_probe(struct device *dev)
>  	OSD_INFO("osd_probe %s\n", disk->disk_name);
>  	return 0;
>  

Hm...  So if device_register() fails then we should always call
device_put()?  It seems like a lot of existing code does that but I
hadn't realized until now that that is how it works.

Why can't the device_put() just be added inside the device_register() so
the unwinding works automatically?

Also if someone add some more stuff to the end of this function, will
the device_unregister() followed by a device_put() cause problems if we
unwind like this?

+err_free_something:
+	kfree(foo);
+	device_unregister(&oud->class_dev);
> +err_put_device:
> +	put_device(&oud->class_dev);
>  err_put_cdev:
>  	cdev_del(&oud->cdev);
>  err_put_disk:

If that's the case then the put_device() should be called infront of the
goto.

regards,
dan carpenter

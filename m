From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] osduld: Use device->release instead of internal
 kref
Date: Thu, 29 Oct 2009 13:11:43 -0400
Message-ID: <1256836303.7191.21.camel@mulgrave.site>
References: <4AE5D374.80400@panasas.com>
	 <1256576294-10430-1-git-send-email-bharrosh@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39417 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837AbZJ2RLn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 13:11:43 -0400
In-Reply-To: <1256576294-10430-1-git-send-email-bharrosh@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On Mon, 2009-10-26 at 18:58 +0200, Boaz Harrosh wrote:
> @@ -335,18 +370,19 @@ static int osd_probe(struct device *dev)
>  		OSD_ERR("cdev_add failed\n");
>  		goto err_put_disk;
>  	}
> -	kobject_get(&oud->cdev.kobj); /* 2nd ref see osd_remove() */
>  
>  	/* class_member */
> -	oud->class_member = device_create(osd_sysfs_class, dev,
> -		MKDEV(SCSI_OSD_MAJOR, oud->minor), "%s", disk->disk_name);
> +	oud->class_member = device_create(&osd_uld_class, dev,
> +		MKDEV(SCSI_OSD_MAJOR, oud->minor), oud, disk->disk_name);
>  	if (IS_ERR(oud->class_member)) {
>  		OSD_ERR("class_device_create failed\n");
>  		error = PTR_ERR(oud->class_member);
>  		goto err_put_cdev;
>  	}
> +	oud->save_release = oud->class_member->release;
> +	oud->class_member->release = __remove;

What exactly is the reason for this iffy manipulation?  Can't this be
done properly by adding a dev_release member to osd_uld_class without
this unnecessary and improper function chaining?

James



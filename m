From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] rework shost/sdev attribute handling
Date: Fri, 27 Jun 2003 12:39:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030627193940.GB3338@beaverton.ibm.com>
References: <20030627181053.GA20375@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:45714 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264694AbTF0TXG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 15:23:06 -0400
Content-Disposition: inline
In-Reply-To: <20030627181053.GA20375@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> @@ -282,8 +308,21 @@
>  {
>  	int i;
>  
> -	for (i = 0; sdev->host->hostt->sdev_attrs[i] != NULL; i++)
> -		device_remove_file(&sdev->sdev_gendev, sdev->host->hostt->sdev_attrs[i]);
> +	for (i = 0; scsi_sysfs_sdev_attrs[i]; i++) {
> +		if (!attr_overridden(sdev->host->hostt->sdev_attrs,
> +					scsi_sysfs_sdev_attrs[i])) {
> +			device_remove_file(&sdev->sdev_gendev,
> +					scsi_sysfs_sdev_attrs[i]);
> +		}
> +	}
> +
> +	if (sdev->host->hostt->sdev_attrs) {
> +		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
> +			device_remove_file(&sdev->sdev_gendev,
> +					sdev->host->hostt->sdev_attrs[i]);
> +		}
> +	}
> +
>  	class_device_unregister(&sdev->sdev_classdev);
>  	device_unregister(&sdev->sdev_gendev);
>  }

Just a minor comment.

We are inconsistent in our cleanup, but...

I was told that you do not need to do individual removal of files if you are in the
process of unregistering. You only need to do this if you just want to remove
the attribute, but are still going to stay around. The files are cleaned
up in the sysfs_remove_dir function call.

The comment on sysfs_remove_dir indicates this also.

I might have incorrect info.

-andmike
--
Michael Anderson
andmike@us.ibm.com


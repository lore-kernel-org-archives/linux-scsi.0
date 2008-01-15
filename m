From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2/2] sg: handle class_device_create failure properly
Date: Mon, 14 Jan 2008 23:55:55 -0500
Message-ID: <478C3CDB.3020009@torque.net>
References: <20080115131800Q.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46796 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYAOE4o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 23:56:44 -0500
In-Reply-To: <20080115131800Q.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, mdr@sgi.com, linux-scsi@vger.kernel.org, tomof@acm.org

FUJITA Tomonori wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/sg.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 92b4367..527e2eb 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1430,11 +1430,14 @@ sg_add(struct class_device *cl_dev, struct class_interface *cl_intf)
>  				MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
>  				cl_dev->dev, "%s",
>  				disk->disk_name);
> -		if (IS_ERR(sg_class_member))
> -			printk(KERN_WARNING "sg_add: "
> -				"class_device_create failed\n");
> +		if (IS_ERR(sg_class_member)) {
> +			printk(KERN_ERR "sg_add: "
> +			       "class_device_create failed\n");
> +			error = PTR_ERR(sg_class_member);
> +			goto cdev_add_err;
> +		}
>  		class_set_devdata(sg_class_member, sdp);
> -		error = sysfs_create_link(&scsidp->sdev_gendev.kobj, 
> +		error = sysfs_create_link(&scsidp->sdev_gendev.kobj,
>  					  &sg_class_member->kobj, "generic");
>  		if (error)
>  			printk(KERN_ERR "sg_add: unable to make symlink "

Signed-off-by: Douglas Gilbert <dougg@torque.net>


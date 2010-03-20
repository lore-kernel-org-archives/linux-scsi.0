From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi: fix lockdep warning
Date: Sat, 20 Mar 2010 10:41:50 -0500
Message-ID: <1269099710.4353.106.camel@mulgrave.site>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>
	 <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>
	 <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org>
	 <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org>
	 <4BA47692.7040401@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab0CTPl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2010 11:41:58 -0400
In-Reply-To: <4BA47692.7040401@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Sat, 2010-03-20 at 00:17 -0700, Yinghai Lu wrote:
> Index: linux-2.6/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi_sysfs.c
> +++ linux-2.6/drivers/scsi/scsi_sysfs.c
> @@ -907,20 +907,27 @@ int scsi_sysfs_add_sdev(struct scsi_devi
>  
>         /* create queue files, which may be writable, depending on the
> host */
>         if (sdev->host->hostt->change_queue_depth) {
> +               sysfs_bin_attr_init(&sdev_attr_queue_depth_rw);
>                 error = device_create_file(&sdev->sdev_gendev,
>                                            &sdev_attr_queue_depth_rw);
> +               sysfs_bin_attr_init(&sdev_attr_queue_ramp_up_period);
>                 error = device_create_file(&sdev->sdev_gendev,
> 
> &sdev_attr_queue_ramp_up_period);
>         }
> -       else
> +       else {
> +               sysfs_bin_attr_init(&dev_attr_queue_depth);
>                 error = device_create_file(&sdev->sdev_gendev,
> &dev_attr_queue_depth);
> +       }
>         if (error)
>                 return error;
>  
> -       if (sdev->host->hostt->change_queue_type)
> +       if (sdev->host->hostt->change_queue_type)  {
> +               sysfs_bin_attr_init(&sdev_attr_queue_type_rw);
>                 error = device_create_file(&sdev->sdev_gendev,
> &sdev_attr_queue_type_rw);
> -       else
> +       } else {
> +               sysfs_bin_attr_init(&dev_attr_queue_type);
>                 error = device_create_file(&sdev->sdev_gendev,
> &dev_attr_queue_type);
> +       }
>         if (error)
>                 return error;
>  
> @@ -935,6 +942,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
>         /* add additional host specific attributes */
>         if (sdev->host->hostt->sdev_attrs) {
>                 for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
> +                       sysfs_bin_attr_init(sdev->host->hostt->sdev_attrs[i]);
>                         error = device_create_file(&sdev->sdev_gendev,
>                                         sdev->host->hostt->sdev_attrs[i]);
>                         if (error)
> @@ -1060,6 +1068,7 @@ int scsi_sysfs_add_host(struct Scsi_Host
>         /* add host specific attributes */
>         if (shost->hostt->shost_attrs) {
>                 for (i = 0; shost->hostt->shost_attrs[i]; i++) {
> +                       sysfs_bin_attr_init(shost->hostt->shost_attrs[i]);
>                         error = device_create_file(&shost->shost_dev,
>                                         shost->hostt->shost_attrs[i]);
>                         if (error)


These are all clearly wrong.  The attribute in question is a device
attribute not a binary attribute.  It only actually compiles because
whoever did sysfs_bin_attr_init() has no type checking on the define and
it just so happens that struct device_attr has a member named attr as
well.

Also, none of these are dynamic attributes, so they shouldn't actually
need initialisation even for lockdep, so what went wrong?

James



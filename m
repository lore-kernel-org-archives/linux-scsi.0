From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.34-rc1: ACPI: BUG: key f71f0168 not in .data!
Date: Fri, 12 Mar 2010 22:46:16 -0600
Message-ID: <1268455576.2802.750.camel@mulgrave.site>
References: <a4423d671003081547v5c955d58t248db945c06d2a7f@mail.gmail.com>
	 <86802c441003081612r2f44efd6n9664b4b7c98a636a@mail.gmail.com>
	 <m1d3zel4b4.fsf@fess.ebiederm.org> <4B95F37E.6060309@kernel.org>
	 <m14okqnczd.fsf@fess.ebiederm.org> <4B99A6F0.4080203@kernel.org>
	 <4B9B0868.7080807@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B9B0868.7080807@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Beregalov <a.beregalov@gmail.com>, Greg KH <gregkh@suse.de>, linux-acpi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2010-03-12 at 19:37 -0800, Yinghai Lu wrote:
> ---
>  drivers/base/attribute_container.c |    1 +
>  drivers/scsi/lpfc/lpfc_attr.c      |    3 +++
>  drivers/scsi/scsi_sysfs.c          |   15 ++++++++++++---
>  3 files changed, 16 insertions(+), 3 deletions(-)

Added linux-scsi, since this seems to be a SCSI fix.

I've no idea what actual problem this is fixing, what's the descriptive
changelog for this?

James


> Index: linux-2.6/drivers/scsi/lpfc/lpfc_attr.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/lpfc/lpfc_attr.c
> +++ linux-2.6/drivers/scsi/lpfc/lpfc_attr.c
> @@ -3780,6 +3780,7 @@ lpfc_alloc_sysfs_attr(struct lpfc_vport
>  	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
>  	int error;
>  
> +	sysfs_bin_attr_init(&sysfs_drvr_stat_data_attr);
>  	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
>  				      &sysfs_drvr_stat_data_attr);
>  
> @@ -3787,11 +3788,13 @@ lpfc_alloc_sysfs_attr(struct lpfc_vport
>  	if (error || vport->port_type == LPFC_NPIV_PORT)
>  		goto out;
>  
> +	sysfs_bin_attr_init(&sysfs_ctlreg_attr);
>  	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
>  				      &sysfs_ctlreg_attr);
>  	if (error)
>  		goto out_remove_stat_attr;
>  
> +	sysfs_bin_attr_init(&sysfs_mbox_attr);
>  	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
>  				      &sysfs_mbox_attr);
>  	if (error)
> Index: linux-2.6/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi_sysfs.c
> +++ linux-2.6/drivers/scsi/scsi_sysfs.c
> @@ -907,20 +907,27 @@ int scsi_sysfs_add_sdev(struct scsi_devi
>  
>  	/* create queue files, which may be writable, depending on the host */
>  	if (sdev->host->hostt->change_queue_depth) {
> +		sysfs_bin_attr_init(&sdev_attr_queue_depth_rw);
>  		error = device_create_file(&sdev->sdev_gendev,
>  					   &sdev_attr_queue_depth_rw);
> +		sysfs_bin_attr_init(&sdev_attr_queue_ramp_up_period);
>  		error = device_create_file(&sdev->sdev_gendev,
>  					   &sdev_attr_queue_ramp_up_period);
>  	}
> -	else
> +	else {
> +		sysfs_bin_attr_init(&dev_attr_queue_depth);
>  		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_depth);
> +	}
>  	if (error)
>  		return error;
>  
> -	if (sdev->host->hostt->change_queue_type)
> +	if (sdev->host->hostt->change_queue_type)  {
> +		sysfs_bin_attr_init(&sdev_attr_queue_type_rw);
>  		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_type_rw);
> -	else
> +	} else {
> +		sysfs_bin_attr_init(&dev_attr_queue_type);
>  		error = device_create_file(&sdev->sdev_gendev, &dev_attr_queue_type);
> +	}
>  	if (error)
>  		return error;
>  
> @@ -935,6 +942,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
>  	/* add additional host specific attributes */
>  	if (sdev->host->hostt->sdev_attrs) {
>  		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
> +			sysfs_bin_attr_init(sdev->host->hostt->sdev_attrs[i]);
>  			error = device_create_file(&sdev->sdev_gendev,
>  					sdev->host->hostt->sdev_attrs[i]);
>  			if (error)
> @@ -1060,6 +1068,7 @@ int scsi_sysfs_add_host(struct Scsi_Host
>  	/* add host specific attributes */
>  	if (shost->hostt->shost_attrs) {
>  		for (i = 0; shost->hostt->shost_attrs[i]; i++) {
> +			sysfs_bin_attr_init(shost->hostt->shost_attrs[i]);
>  			error = device_create_file(&shost->shost_dev,
>  					shost->hostt->shost_attrs[i]);
>  			if (error)
> Index: linux-2.6/drivers/base/attribute_container.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/attribute_container.c
> +++ linux-2.6/drivers/base/attribute_container.c
> @@ -328,6 +328,7 @@ attribute_container_add_attrs(struct dev
>  		return sysfs_create_group(&classdev->kobj, cont->grp);
>  
>  	for (i = 0; attrs[i]; i++) {
> +		sysfs_bin_attr_init(attrs[i]);
>  		error = device_create_file(classdev, attrs[i]);
>  		if (error)
>  			return error;

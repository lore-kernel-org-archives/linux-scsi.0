From: "Kershner, David A" <David.Kershner@unisys.com>
Subject: RE: [PATCH 26/28] visorhba: sanitze private device data allocation
Date: Fri, 30 Jun 2017 20:16:08 +0000
Message-ID: <CY4PR07MB317616F792E1C47677A230DFF0D30@CY4PR07MB3176.namprd07.prod.outlook.com>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
 <1498638316-44420-27-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0076.outbound.protection.outlook.com ([104.47.33.76]:34880
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751919AbdF3UQL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 16:16:11 -0400
In-Reply-To: <1498638316-44420-27-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, June 28, 2017 4:25 AM
> To: Christoph Hellwig <hch@lst.de>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Hannes Reinecke <hare@suse.com>;
> Kershner, David A <David.Kershner@unisys.com>
> Subject: [PATCH 26/28] visorhba: sanitze private device data allocation
>=20
> There's no need to keep the private data for a device in a separate
> list; better to store it in ->hostdata and do away with the additional
> list.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Cc: David Kershner <david.kershner@unisys.com>

Thanks for the patch, works great!  Tested it on s-Par.=20

Acked-by: David Kershner <david.kershner@unisys.com>

Thanks,=20
David Kershner

> ---
>  drivers/staging/unisys/visorhba/visorhba_main.c | 123 ++++++++++--------=
--
> ----
>  1 file changed, 53 insertions(+), 70 deletions(-)
>=20
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c
> b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 6997b16..811abfc 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -47,8 +47,8 @@
>  MODULE_ALIAS("visorbus:"
> SPAR_VHBA_CHANNEL_PROTOCOL_UUID_STR);
>=20
>  struct visordisk_info {
> +	struct scsi_device *sdev;
>  	u32 valid;
> -	u32 channel, id, lun;	/* Disk Path */
>  	atomic_t ios_threshold;
>  	atomic_t error_count;
>  	struct visordisk_info *next;
> @@ -101,12 +101,6 @@ struct visorhba_devices_open {
>  	struct visorhba_devdata *devdata;
>  };
>=20
> -#define for_each_vdisk_match(iter, list, match) \
> -	for (iter =3D &list->head; iter->next; iter =3D iter->next) \
> -		if ((iter->channel =3D=3D match->channel) && \
> -		    (iter->id =3D=3D match->id) && \
> -		    (iter->lun =3D=3D match->lun))
> -
>  /*
>   *	visor_thread_start - starts a thread for the device
>   *	@threadfn: Function the thread starts
> @@ -296,10 +290,9 @@ static void cleanup_scsitaskmgmt_handles(struct idr
> *idrtable,
>   *	Returns whether the command was queued successfully or not.
>   */
>  static int forward_taskmgmt_command(enum task_mgmt_types tasktype,
> -				    struct scsi_cmnd *scsicmd)
> +				    struct scsi_device *scsidev)
>  {
>  	struct uiscmdrsp *cmdrsp;
> -	struct scsi_device *scsidev =3D scsicmd->device;
>  	struct visorhba_devdata *devdata =3D
>  		(struct visorhba_devdata *)scsidev->host->hostdata;
>  	int notifyresult =3D 0xffff;
> @@ -347,12 +340,6 @@ static int forward_taskmgmt_command(enum
> task_mgmt_types tasktype,
>  	dev_dbg(&scsidev->sdev_gendev,
>  		"visorhba: taskmgmt type=3D%d success; result=3D0x%x\n",
>  		 tasktype, notifyresult);
> -	if (tasktype =3D=3D TASK_MGMT_ABORT_TASK)
> -		scsicmd->result =3D DID_ABORT << 16;
> -	else
> -		scsicmd->result =3D DID_RESET << 16;
> -
> -	scsicmd->scsi_done(scsicmd);
>  	cleanup_scsitaskmgmt_handles(&devdata->idr, cmdrsp);
>  	return SUCCESS;
>=20
> @@ -376,17 +363,20 @@ static int visorhba_abort_handler(struct scsi_cmnd
> *scsicmd)
>  	/* issue TASK_MGMT_ABORT_TASK */
>  	struct scsi_device *scsidev;
>  	struct visordisk_info *vdisk;
> -	struct visorhba_devdata *devdata;
> +	int rtn;
>=20
>  	scsidev =3D scsicmd->device;
> -	devdata =3D (struct visorhba_devdata *)scsidev->host->hostdata;
> -	for_each_vdisk_match(vdisk, devdata, scsidev) {
> -		if (atomic_read(&vdisk->error_count) <
> VISORHBA_ERROR_COUNT)
> -			atomic_inc(&vdisk->error_count);
> -		else
> -			atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
> +	vdisk =3D scsidev->hostdata;
> +	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
> +		atomic_inc(&vdisk->error_count);
> +	else
> +		atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
> +	rtn =3D forward_taskmgmt_command(TASK_MGMT_ABORT_TASK,
> scsidev);
> +	if (rtn =3D=3D SUCCESS) {
> +		scsicmd->result =3D DID_ABORT << 16;
> +		scsicmd->scsi_done(scsicmd);
>  	}
> -	return forward_taskmgmt_command(TASK_MGMT_ABORT_TASK,
> scsicmd);
> +	return rtn;
>  }
>=20
>  /*
> @@ -400,17 +390,20 @@ static int visorhba_device_reset_handler(struct
> scsi_cmnd *scsicmd)
>  	/* issue TASK_MGMT_LUN_RESET */
>  	struct scsi_device *scsidev;
>  	struct visordisk_info *vdisk;
> -	struct visorhba_devdata *devdata;
> +	int rtn;
>=20
>  	scsidev =3D scsicmd->device;
> -	devdata =3D (struct visorhba_devdata *)scsidev->host->hostdata;
> -	for_each_vdisk_match(vdisk, devdata, scsidev) {
> -		if (atomic_read(&vdisk->error_count) <
> VISORHBA_ERROR_COUNT)
> -			atomic_inc(&vdisk->error_count);
> -		else
> -			atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
> +	vdisk =3D scsidev->hostdata;
> +	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
> +		atomic_inc(&vdisk->error_count);
> +	else
> +		atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
> +	rtn =3D forward_taskmgmt_command(TASK_MGMT_LUN_RESET,
> scsidev);
> +	if (rtn =3D=3D SUCCESS) {
> +		scsicmd->result =3D DID_RESET << 16;
> +		scsicmd->scsi_done(scsicmd);
>  	}
> -	return forward_taskmgmt_command(TASK_MGMT_LUN_RESET,
> scsicmd);
> +	return rtn;
>  }
>=20
>  /*
> @@ -424,17 +417,22 @@ static int visorhba_bus_reset_handler(struct
> scsi_cmnd *scsicmd)
>  {
>  	struct scsi_device *scsidev;
>  	struct visordisk_info *vdisk;
> -	struct visorhba_devdata *devdata;
> +	int rtn;
>=20
>  	scsidev =3D scsicmd->device;
> -	devdata =3D (struct visorhba_devdata *)scsidev->host->hostdata;
> -	for_each_vdisk_match(vdisk, devdata, scsidev) {
> +	shost_for_each_device(scsidev, scsidev->host) {
> +		vdisk =3D scsidev->hostdata;
>  		if (atomic_read(&vdisk->error_count) <
> VISORHBA_ERROR_COUNT)
>  			atomic_inc(&vdisk->error_count);
>  		else
>  			atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
>  	}
> -	return forward_taskmgmt_command(TASK_MGMT_BUS_RESET,
> scsicmd);
> +	rtn =3D forward_taskmgmt_command(TASK_MGMT_BUS_RESET,
> scsidev);
> +	if (rtn =3D=3D SUCCESS) {
> +		scsicmd->result =3D DID_RESET << 16;
> +		scsicmd->scsi_done(scsicmd);
> +	}
> +	return rtn;
>  }
>=20
>  /*
> @@ -569,25 +567,22 @@ static int visorhba_slave_alloc(struct scsi_device
> *scsidev)
>  	 * LLD can alloc any struct & do init if needed.
>  	 */
>  	struct visordisk_info *vdisk;
> -	struct visordisk_info *tmpvdisk;
>  	struct visorhba_devdata *devdata;
>  	struct Scsi_Host *scsihost =3D (struct Scsi_Host *)scsidev->host;
>=20
> +	if (scsidev->hostdata)
> +		return 0; /* already allocated return success */
> +
>  	devdata =3D (struct visorhba_devdata *)scsihost->hostdata;
>  	if (!devdata)
>  		return 0; /* even though we errored, treat as success */
>=20
> -	for_each_vdisk_match(vdisk, devdata, scsidev)
> -		return 0; /* already allocated return success */
> -
> -	tmpvdisk =3D kzalloc(sizeof(*tmpvdisk), GFP_ATOMIC);
> -	if (!tmpvdisk)
> +	vdisk =3D kzalloc(sizeof(*vdisk), GFP_ATOMIC);
> +	if (!vdisk)
>  		return -ENOMEM;
>=20
> -	tmpvdisk->channel =3D scsidev->channel;
> -	tmpvdisk->id =3D scsidev->id;
> -	tmpvdisk->lun =3D scsidev->lun;
> -	vdisk->next =3D tmpvdisk;
> +	vdisk->sdev =3D scsidev;
> +	scsidev->hostdata =3D vdisk;
>  	return 0;
>  }
>=20
> @@ -603,17 +598,11 @@ static void visorhba_slave_destroy(struct
> scsi_device *scsidev)
>  	/* midlevel calls this after device has been quiesced and
>  	 * before it is to be deleted.
>  	 */
> -	struct visordisk_info *vdisk, *delvdisk;
> -	struct visorhba_devdata *devdata;
> -	struct Scsi_Host *scsihost =3D (struct Scsi_Host *)scsidev->host;
> +	struct visordisk_info *vdisk;
>=20
> -	devdata =3D (struct visorhba_devdata *)scsihost->hostdata;
> -	for_each_vdisk_match(vdisk, devdata, scsidev) {
> -		delvdisk =3D vdisk->next;
> -		vdisk->next =3D delvdisk->next;
> -		kfree(delvdisk);
> -		return;
> -	}
> +	vdisk =3D scsidev->hostdata;
> +	scsidev->hostdata =3D NULL;
> +	kfree(vdisk);
>  }
>=20
>  static struct scsi_host_template visorhba_driver_template =3D {
> @@ -787,7 +776,6 @@ static int visorhba_serverdown(struct
> visorhba_devdata *devdata)
>  static void
>  do_scsi_linuxstat(struct uiscmdrsp *cmdrsp, struct scsi_cmnd *scsicmd)
>  {
> -	struct visorhba_devdata *devdata;
>  	struct visordisk_info *vdisk;
>  	struct scsi_device *scsidev;
>=20
> @@ -800,12 +788,10 @@ static int visorhba_serverdown(struct
> visorhba_devdata *devdata)
>  	    (cmdrsp->scsi.addlstat =3D=3D ADDL_SEL_TIMEOUT))
>  		return;
>  	/* Okay see what our error_count is here.... */
> -	devdata =3D (struct visorhba_devdata *)scsidev->host->hostdata;
> -	for_each_vdisk_match(vdisk, devdata, scsidev) {
> -		if (atomic_read(&vdisk->error_count) <
> VISORHBA_ERROR_COUNT) {
> -			atomic_inc(&vdisk->error_count);
> -			atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
> -		}
> +	vdisk =3D scsidev->hostdata;
> +	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
> {
> +		atomic_inc(&vdisk->error_count);
> +		atomic_set(&vdisk->ios_threshold,
> IOS_ERROR_THRESHOLD);
>  	}
>  }
>=20
> @@ -846,7 +832,6 @@ static int set_no_disk_inquiry_result(unsigned char
> *buf,
>  	char *this_page_orig;
>  	int bufind =3D 0;
>  	struct visordisk_info *vdisk;
> -	struct visorhba_devdata *devdata;
>=20
>  	scsidev =3D scsicmd->device;
>  	if ((cmdrsp->scsi.cmnd[0] =3D=3D INQUIRY) &&
> @@ -883,13 +868,11 @@ static int set_no_disk_inquiry_result(unsigned char
> *buf,
>  		}
>  		kfree(buf);
>  	} else {
> -		devdata =3D (struct visorhba_devdata *)scsidev->host-
> >hostdata;
> -		for_each_vdisk_match(vdisk, devdata, scsidev) {
> -			if (atomic_read(&vdisk->ios_threshold) > 0) {
> -				atomic_dec(&vdisk->ios_threshold);
> -				if (atomic_read(&vdisk->ios_threshold) =3D=3D 0)
> -					atomic_set(&vdisk->error_count, 0);
> -			}
> +		vdisk =3D scsidev->hostdata;
> +		if (atomic_read(&vdisk->ios_threshold) > 0) {
> +			atomic_dec(&vdisk->ios_threshold);
> +			if (atomic_read(&vdisk->ios_threshold) =3D=3D 0)
> +				atomic_set(&vdisk->error_count, 0);
>  		}
>  	}
>  }
> --
> 1.8.5.6

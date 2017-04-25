From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 07/37] smartpqi: enhance resets
Date: Tue, 25 Apr 2017 20:01:46 +0000
Message-ID: <1493150504.2628.11.camel@sandisk.com>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
         <149314959452.13903.17367079226921525023.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60150 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947277AbdDYUBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 16:01:51 -0400
In-Reply-To: <149314959452.13903.17367079226921525023.stgit@brunhilda>
Content-Language: en-US
Content-ID: <58E5AACAD7861F4DB06437E346717690@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Viswas.G@microsemi.com" <Viswas.G@microsemi.com>, "gerry.morong@microsemi.com" <gerry.morong@microsemi.com>, "Mahesh.Rajashekhara@microsemi.com" <Mahesh.Rajashekhara@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>, "scott.benesh@microsemi.com" <scott.benesh@microsemi.com>, "don.brace@microsemi.com" <don.brace@microsemi.com>, "bader.alisaleh@microsemi.com" <bader.alisaleh@microsemi.com>, "Kevin.Barnett@microsemi.com" <Kevin.Barnett@microsemi.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, "scott.teel@microsemi.com" <scott.teel@microsemi.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "Justin.Lindley@microsemi.com" <Justin.Lindley@microsemi.com>, "john.hall@microsemi.com" <john.hall@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 2017-04-25 at 14:46 -0500, Don Brace wrote:
> @@ -4655,23 +4860,46 @@ static int pqi_device_reset(struct pqi_ctrl_info =
*ctrl_info,
>  static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
>  {
>  	int rc;
> +	struct Scsi_Host *shost;
>  	struct pqi_ctrl_info *ctrl_info;
>  	struct pqi_scsi_dev *device;
> =20
> -	ctrl_info =3D shost_to_hba(scmd->device->host);
> +	shost =3D scmd->device->host;
> +	ctrl_info =3D shost_to_hba(shost);
>  	device =3D scmd->device->hostdata;
> =20
>  	dev_err(&ctrl_info->pci_dev->dev,
>  		"resetting scsi %d:%d:%d:%d\n",
> -		ctrl_info->scsi_host->host_no,
> -		device->bus, device->target, device->lun);
> +		shost->host_no, device->bus, device->target, device->lun);
> =20
> -	rc =3D pqi_device_reset(ctrl_info, device);
> +	pqi_check_ctrl_health(ctrl_info);
> +	if (pqi_ctrl_offline(ctrl_info)) {
> +		rc =3D FAILED;
> +		goto out;
> +	}
> =20
> +	mutex_lock(&ctrl_info->lun_reset_mutex);
> +
> +	pqi_ctrl_block_requests(ctrl_info);
> +	pqi_ctrl_wait_until_quiesced(ctrl_info);
> +	pqi_fail_io_queued_for_device(ctrl_info, device);
> +	rc =3D pqi_wait_until_inbound_queues_empty(ctrl_info);
> +	pqi_device_reset_start(device);
> +	pqi_ctrl_unblock_requests(ctrl_info);
> +
> +	if (rc)
> +		rc =3D FAILED;
> +	else
> +		rc =3D pqi_device_reset(ctrl_info, device);
> +
> +	pqi_device_reset_done(device);
> +
> +	mutex_unlock(&ctrl_info->lun_reset_mutex);
> +
> +out:
>  	dev_err(&ctrl_info->pci_dev->dev,
>  		"reset of scsi %d:%d:%d:%d: %s\n",
> -		ctrl_info->scsi_host->host_no,
> -		device->bus, device->target, device->lun,
> +		shost->host_no, device->bus, device->target, device->lun,
>  		rc =3D=3D SUCCESS ? "SUCCESS" : "FAILED");
> =20
>  	return rc;

Please use scsi_target_block() / scsi_target_unblock() instead of reimpleme=
nting
these functions.

Thanks,

Bart.

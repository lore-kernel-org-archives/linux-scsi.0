From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 2/2] scsi: storvsc: Use the specified target ID in
 device lookup
Date: Thu, 28 Jan 2016 09:29:57 +0100
Message-ID: <20160128082957.GE27565@c203.arch.suse.de>
References: <1453947739-28725-1-git-send-email-kys@microsoft.com>
 <1453947765-28764-1-git-send-email-kys@microsoft.com>
 <1453947765-28764-2-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934741AbcA1I37 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 03:29:59 -0500
Content-Disposition: inline
In-Reply-To: <1453947765-28764-2-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de

On Wed, Jan 27, 2016 at 06:22:45PM -0800, K. Y. Srinivasan wrote:
> The current code assumes that there is only one target in device look=
up.
> Fix this bug. This will alow us to correctly handle hot reomoval of L=
UNs.
>=20
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Alex Ng <alexng@microsoft.com>
> Tested-by: Vivek Yadav <vyadav@microsoft.com>
> ---
> 	V2: Made lun and target_id unsigned 8 bit entities - Hannes Reinecke=
 <hare@suse.de>
>=20
>  drivers/scsi/storvsc_drv.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 622f64a..132b168 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -478,19 +478,18 @@ struct hv_host_device {
>  struct storvsc_scan_work {
>  	struct work_struct work;
>  	struct Scsi_Host *host;
> -	uint lun;
> +	u8 lun;
> +	u8 tgt_id;
>  };
> =20
>  static void storvsc_device_scan(struct work_struct *work)
>  {
>  	struct storvsc_scan_work *wrk;
> -	uint lun;
>  	struct scsi_device *sdev;
> =20
>  	wrk =3D container_of(work, struct storvsc_scan_work, work);
> -	lun =3D wrk->lun;
> =20
> -	sdev =3D scsi_device_lookup(wrk->host, 0, 0, lun);
> +	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
>  	if (!sdev)
>  		goto done;
>  	scsi_rescan_device(&sdev->sdev_gendev);
> @@ -541,7 +540,7 @@ static void storvsc_remove_lun(struct work_struct=
 *work)
>  	if (!scsi_host_get(wrk->host))
>  		goto done;
> =20
> -	sdev =3D scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
> +	sdev =3D scsi_device_lookup(wrk->host, 0, wrk->tgt_id, wrk->lun);
> =20
>  	if (sdev) {
>  		scsi_remove_device(sdev);
> @@ -941,6 +940,7 @@ static void storvsc_handle_error(struct vmscsi_re=
quest *vm_srb,
> =20
>  	wrk->host =3D host;
>  	wrk->lun =3D vm_srb->lun;
> +	wrk->tgt_id =3D vm_srb->target_id;
>  	INIT_WORK(&wrk->work, process_err_fn);
>  	schedule_work(&wrk->work);
>  }
> --=20
> 1.7.4.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

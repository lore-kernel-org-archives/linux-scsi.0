From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4] scsi/sd: release scan_mutex during sync_cache and
 start_stop
Date: Thu, 9 Feb 2017 22:24:56 +0000
Message-ID: <0424414C-BF11-41AA-B22C-C1235F1544F8@fb.com>
References: <20170209010116.362206-1-songliubraving@fb.com>
 <20170209085106.GA7313@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49631 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753170AbdBIW1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2017 17:27:02 -0500
In-Reply-To: <20170209085106.GA7313@lst.de>
Content-Language: en-US
Content-ID: <CEDE511B8CAB21438EE354EE751F64E8@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>

Hi Christoph,=20

IMHO, scan_mutex maybe still needed for other part of scsi_remove_device().=
=20

For example, device=10_del() in sd_remove() and scsi_sysfs_add_devices() in=
=20
scsi_finish_async_scan() should not run in parallel?=20

On the other hand, other parts of sd_remove(), including sd_shutdown(),=20
does not touch shared resource.  So it is safe to run these sections withou=
t
holding scan_mutex.=20

Another (and maybe better) solution is to move mutex_lock/unlock() of=20
scan_mutex to each _remove function. So we only hold the lock when accessin=
g
scsi_host related data.=20

Thanks,
Song


> On Feb 9, 2017, at 12:51 AM, Christoph Hellwig <hch@lst.de> wrote:
>=20
> And what is the lock protecting if we can just release and reacquire it
> safely?  Probably nothing, but someone needs to do the audit carefully.
>=20
> Once that is done we can just apply a patch like the one below and
> be done with it:
>=20
> ---
> From 47572d7f0758cc0cbd979b1a2c3791f3b94c566e Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 9 Feb 2017 09:49:04 +0100
> Subject: scsi: remove scan_mutex
>=20
> All our lookup structures are properly locked these days, there shouldn't
> be any need to serialize the high-level scan process.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> drivers/scsi/scsi_scan.c | 15 ---------------
> 1 file changed, 15 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6f7128f49c30..c92be1ad486c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1490,7 +1490,6 @@ struct scsi_device *__scsi_add_device(struct Scsi_H=
ost *shost, uint channel,
> 		return ERR_PTR(-ENOMEM);
> 	scsi_autopm_get_target(starget);
>=20
> -	mutex_lock(&shost->scan_mutex);
> 	if (!shost->async_scan)
> 		scsi_complete_async_scans();
>=20
> @@ -1498,7 +1497,6 @@ struct scsi_device *__scsi_add_device(struct Scsi_H=
ost *shost, uint channel,
> 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
> 		scsi_autopm_put_host(shost);
> 	}
> -	mutex_unlock(&shost->scan_mutex);
> 	scsi_autopm_put_target(starget);
> 	/*
> 	 * paired with scsi_alloc_target().  Target will be destroyed unless
> @@ -1629,7 +1627,6 @@ void scsi_scan_target(struct device *parent, unsign=
ed int channel,
> 	    strncmp(scsi_scan_type, "manual", 6) =3D=3D 0)
> 		return;
>=20
> -	mutex_lock(&shost->scan_mutex);
> 	if (!shost->async_scan)
> 		scsi_complete_async_scans();
>=20
> @@ -1637,7 +1634,6 @@ void scsi_scan_target(struct device *parent, unsign=
ed int channel,
> 		__scsi_scan_target(parent, channel, id, lun, rescan);
> 		scsi_autopm_put_host(shost);
> 	}
> -	mutex_unlock(&shost->scan_mutex);
> }
> EXPORT_SYMBOL(scsi_scan_target);
>=20
> @@ -1686,7 +1682,6 @@ int scsi_scan_host_selected(struct Scsi_Host *shost=
, unsigned int channel,
> 	    ((lun !=3D SCAN_WILD_CARD) && (lun >=3D shost->max_lun)))
> 		return -EINVAL;
>=20
> -	mutex_lock(&shost->scan_mutex);
> 	if (!shost->async_scan)
> 		scsi_complete_async_scans();
>=20
> @@ -1700,7 +1695,6 @@ int scsi_scan_host_selected(struct Scsi_Host *shost=
, unsigned int channel,
> 			scsi_scan_channel(shost, channel, id, lun, rescan);
> 		scsi_autopm_put_host(shost);
> 	}
> -	mutex_unlock(&shost->scan_mutex);
>=20
> 	return 0;
> }
> @@ -1752,11 +1746,9 @@ static struct async_scan_data *scsi_prep_async_sca=
n(struct Scsi_Host *shost)
> 		goto err;
> 	init_completion(&data->prev_finished);
>=20
> -	mutex_lock(&shost->scan_mutex);
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	shost->async_scan =3D 1;
> 	spin_unlock_irqrestore(shost->host_lock, flags);
> -	mutex_unlock(&shost->scan_mutex);
>=20
> 	spin_lock(&async_scan_lock);
> 	if (list_empty(&scanning_hosts))
> @@ -1789,12 +1781,9 @@ static void scsi_finish_async_scan(struct async_sc=
an_data *data)
>=20
> 	shost =3D data->shost;
>=20
> -	mutex_lock(&shost->scan_mutex);
> -
> 	if (!shost->async_scan) {
> 		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
> 		dump_stack();
> -		mutex_unlock(&shost->scan_mutex);
> 		return;
> 	}
>=20
> @@ -1806,8 +1795,6 @@ static void scsi_finish_async_scan(struct async_sca=
n_data *data)
> 	shost->async_scan =3D 0;
> 	spin_unlock_irqrestore(shost->host_lock, flags);
>=20
> -	mutex_unlock(&shost->scan_mutex);
> -
> 	spin_lock(&async_scan_lock);
> 	list_del(&data->list);
> 	if (!list_empty(&scanning_hosts)) {
> @@ -1915,7 +1902,6 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_H=
ost *shost)
> 	struct scsi_device *sdev =3D NULL;
> 	struct scsi_target *starget;
>=20
> -	mutex_lock(&shost->scan_mutex);
> 	if (!scsi_host_scan_allowed(shost))
> 		goto out;
> 	starget =3D scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
> @@ -1929,7 +1915,6 @@ struct scsi_device *scsi_get_host_dev(struct Scsi_H=
ost *shost)
> 		scsi_target_reap(starget);
> 	put_device(&starget->dev);
>  out:
> -	mutex_unlock(&shost->scan_mutex);
> 	return sdev;
> }
> EXPORT_SYMBOL(scsi_get_host_dev);
> --=20
> 2.11.0
>=20

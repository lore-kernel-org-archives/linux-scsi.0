From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi subsystem : fix function __scsi_device_lookup
Date: Thu, 15 Oct 2015 09:53:42 +0200
Message-ID: <561F5B86.5090409@suse.de>
References: <1444894715-4906-1-git-send-email-johnzzpcrystal@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbJOHxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Oct 2015 03:53:44 -0400
In-Reply-To: <1444894715-4906-1-git-send-email-johnzzpcrystal@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zhengping Zhou <johnzzpcrystal@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On 10/15/2015 09:38 AM, Zhengping Zhou wrote:
> when a scsi_device is unpluged from scsi controller, if the
> scsi_device is still be used by application layer,it won't be
> released until users release it. In this case, scsi_device_remove jus=
t set
> the scsi_device's state to be SDEV_DEL. But if you plug the disk
> just before the old scsi_device is released, then there will be two
> scsi_device structures in scsi_host->__devices. when the next unplugi=
ng=20
> event happens,some low-level drivers will check whether the scsi_devi=
ce=20
> has been added to host (for example, the megaraid sas series controll=
er)=20
> by calling scsi_device_lookup(call __scsi_device_lookup).=20
> __scsi_device_lookup will return the first scsi_device. Because its=20
> state is SDEV_DEL, the scsi_device_lookup will return NULL finally,=20
> making the low-level driver assume that the scsi_device has been=20
> removed,and won't call scsi_device_remove,which will lead the=20
> failure of hot swap.
> Signed-off-by: Zhengping Zhou <johnzzpcrystal@gmail.com>
> ---
> Hi all:
> 	I'm sorry to bother again,that's my second time to send=20
> 	this patch.
> 	I find a bug about the failure of hot swap when I am using=20
> 	megaraid sas series controller. Finally I have found that=20
> 	when controller receives the event of hot swap, it will firstly=20
> 	check whether the device is added to the system/host by calling=20
> 	scsi_device_lookup.The logics in function megasas_aen_polling=20
> 	is as follows:
>             case MR_EVT_PD_REMOVED:
>                     if (megasas_get_pd_list(instance) =3D=3D 0) {=20
>                     for (i =3D 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
>                             for (j =3D 0;=20
>                             j < MEGASAS_MAX_DEV_PER_CHANNEL;
>                             j++) {
>=20
>                             pd_index =3D
>                             (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;=20
>=20
>                             sdev1 =3D scsi_device_lookup(host, i, j, =
0);
>=20
>                             if (instance->pd_list[pd_index].driveStat=
e
>                                     =3D=3D MR_PD_STATE_SYSTEM) {
>                                     if (sdev1)
>                                             scsi_device_put(sdev1);
>                             } else {
>                                     if (sdev1) {
>                                             scsi_remove_device(sdev1)=
;
>                                             scsi_device_put(sdev1);
>                                     }   =20
>                             }   =20
>                             }   =20
>                     }   =20
>                     }   =20
> 	If the previous scsi_device is not released, this will lead the=20
> 	appearance of two scsi_devices which correspond with the same disk.
> 	And when the disk is unpluged afterwards, the controller will assume
> 	that this disk has never been added into the system/host. Thus it wo=
n't=20
> 	call scsi_device_remove. When I finish this modification, this probl=
em
> 	is fixed.So far, I have successfully test PCI_DEVICE_ID_LSI_SAS0073S=
KINNY=20
> 	and PCI_DEVICE_ID_LSI_FURY.
> Thanks
> Zhengping
> ---
>  drivers/scsi/scsi.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 207d6a7..5251d6d 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1118,6 +1118,8 @@ struct scsi_device *__scsi_device_lookup(struct=
 Scsi_Host *shost,
>  	struct scsi_device *sdev;
> =20
>  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +		if (sdev->sdev_state =3D=3D SDEV_DEL)
> +			continue;
>  		if (sdev->channel =3D=3D channel && sdev->id =3D=3D id &&
>  				sdev->lun =3D=3Dlun)
>  			return sdev;
>=20
Ho-hum.

So lookup will return NULL, which then will cause the subsequent
functions to assume the scsi_device is not present, right?

And if you're _really_ unlucky it'll continue to add this device
(with the same LUN, target, bus, and host number!) to the list,
resulting in us having _two_ devices with the same number on the list.

Happy lookup.

I guess this calls for the lock rework from Johannes ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

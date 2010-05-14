From: Hannes Reinecke <hare@suse.de>
Subject: Re: [QEMU-KVM]: Megasas + TCM_Loop + SG_IO into Windows XP guests
Date: Fri, 14 May 2010 09:22:33 +0200
Message-ID: <4BECFA39.7040809@suse.de>
References: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab0ENHWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2010 03:22:35 -0400
In-Reply-To: <1273786731.13658.49.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kvm-devel <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, linux-scsi <linux-scsi@vger.kernel.org>

Nicholas A. Bellinger wrote:
> Greetings Hannes and co,
>=20
> I have been spending a bit of time trying Megasas HBA emulation +
> TCM_Loop + SG_IO with a Windows XP SP2 KVM guests..  So far, I notice=
d
> that hw/scsi-generic.c:execute_command_run() using bdev_aio_ioctl()
> appears to be broken for XP guests, which causes the first 36-byte
> INQUIRY sent via SG_IO to never make it back to QEMU and results in t=
he
> win32 LSI drive taking the LUN offline, et al.  Note that everything
> does appear to be functioning as expected in kernel space for the fir=
st
> INQUIRY with the TCM_Loop LLD and Linux/SCSI code (AFAICT) and Linux =
KVM
> guests using megasas emulation are still working.
>=20
Now that is really odd. Have you checked if it works with the
'normal' KVM disk backend?

> So, I ended up needing requiring the following quick hack for
> hw/scsi-generic.c:execute_command_run() to make SG_IO function
> synchronously using bdrv_ioctl(), which at least gets LUN registratio=
n
> and basic control path CDBs working for the XP guest.
>=20
> Here is how it looks in action on a v2.6.34-rc7 host so far:
>=20
> http://www.linux-iscsi.org/images/TCM-KVM-megasas-XP-05132010.png
>=20
>=20
> diff --git a/hw/scsi-generic.c b/hw/scsi-generic.c
> index 6c58742..aa1eb83 100644
> --- a/hw/scsi-generic.c
> +++ b/hw/scsi-generic.c
> @@ -140,6 +140,7 @@ static int execute_command_run(SCSIGenericReq *r,
>  {
>      BlockDriverState *bdrv =3D r->req.dev->conf.dinfo->bdrv;
>      SCSIGenericState *s =3D DO_UPCAST(SCSIGenericState, qdev, r->req=
=2Edev);
> +    int ret;
> =20
>      r->io_header.interface_id =3D 'S';
>      r->io_header.dxfer_direction =3D sgdir[r->req.cmd.mode];
> @@ -161,11 +162,16 @@ static int execute_command_run(SCSIGenericReq *=
r,
>      printf("\n");
>      }
>  #endif
> +#if 0
>      r->req.aiocb =3D bdrv_aio_ioctl(bdrv, SG_IO, &r->io_header, comp=
lete, r);
>      if (r->req.aiocb =3D=3D NULL) {
>          BADF("execute_command: read failed !\n");
>          return -1;
>      }
> +#else
> +    ret =3D bdrv_ioctl(bdrv, SG_IO, &r->io_header);
> +    complete((void *)r, ret);
> +#endif
> =20
>       *      return 0;
>  }
>=20
>=20
> Beyond the initial LUN registration and control CDB parts, doing bulk
> DATA_SG_IO traffic is completing successfully (and everything looks s=
ane
> with TCM_Loop and Linux/SCSI) but it appears that the correct blocks =
are
> not actually getting written/read by megasas.  This appears to be the
> case with both hw/scsi-generic.c and hw/scsi-disk.c modes of operatio=
n
> for megasas with the win32 XP guest.
>=20
Oh. Hmm.

> So I was wondering if anyone aware of known issues with QEMU
> asynchronous SG_IO into MSFT KVM guests with virtio or hw/lsi53c895a.=
c,
> or would this be something specific to megasas HBA emulation and XP
> guests..?
>=20
> Hannes, which MSFT guest + driver did you get work stable with bulk
> DATA_SG_IO and hw/scsi-disk.c..?
>=20
Well, I have two more patches for megasas.
The one is just a cleanup to remove duplicate definitions, but the
other contains a real issue with a misjudged cast in megasas_enqueue_fr=
ame().
Not sure if that helps here, but it's worth a try nevertheless.

I'll be sending them with separate mails.

Let's see if I can find some time working on the megasas emulation.
Maybe I find something.
Last time I checked it was with a Windows7 build, but I didn't do
any real tests there. Basically just checking if the system boots up :-=
)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

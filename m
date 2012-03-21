From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: DMA doesn't work since "make ata port as parent device of scsi
 host"
Date: Wed, 21 Mar 2012 20:40:43 +0100
Message-ID: <20120321194042.GA16112@alea.gnuu.de>
References: <20120315014807.GA3051@alea.gnuu.de>
 <1331776741.3436.33.camel@minggr>
 <1331781968.3436.43.camel@minggr>
 <20120315074835.GA18295@alea.gnuu.de>
 <1331799598.3436.46.camel@minggr>
 <20120315155924.GA6738@alea.gnuu.de>
 <1332293133.17160.12.camel@minggr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1332293133.17160.12.camel@minggr>
Sender: linux-ide-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Lin Ming hat am Wed 21. Mar, 09:25 (+0800) geschrieben:
> On Thu, 2012-03-15 at 16:59 +0100, J=F6rg Sommer wrote:
> > Lin Ming hat am Thu 15. Mar, 16:19 (+0800) geschrieben:
> > > On Thu, 2012-03-15 at 08:48 +0100, J=F6rg Sommer wrote:
> > > > Lin Ming hat am Thu 15. Mar, 11:26 (+0800) geschrieben:
> > > > > On Thu, 2012-03-15 at 09:59 +0800, Lin Ming wrote:
> > > > > > On Thu, 2012-03-15 at 02:48 +0100, J=F6rg Sommer wrote:
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > I'm getting these messages in a KVM virtualized host and the =
access to
> > > > > > > the disks is very slow. Using libata.dma=3D0 suppresses the w=
arnings, but
> > > > > > > the disks are still slow.
> > > > > >=20
> > > > > > Hi J=F6rg,
> > > > > >=20
> > > > > > Let me try to reproduce this issue first.
> > > > >=20
> > > > > I tried below commands on x86_32, but can't reproduce it.
> > > > >=20
> > > > > qemu-system-i386 -kernel /root/vmlinuz-3.3.0-rc7 -append "root=3D=
/dev/sda1
> > > > > zcache" -hda /root/debian-32.img -hdb /root/data.img
> > > > >=20
> > > > > Maybe because i386 uses different ata controller than ppc(ata_pii=
x vs
> > > > > pata-macio).
> > > > >=20
> > > > > I'll try qemu-system-ppc.
> > > > >=20
> > > > > Did you need to run some workload to trigger these warings?
> > > > > Or did you get these warnings right after booting the VM?
> > > >=20
> > > > These warnings come up before =BBINIT started=AB. I don't have to do
> > > > anything, just wait and see.
> > > >=20
> > > > # truncate -s100M /mnt/data/new
> > > > # mke2fs -Fq /mnt/data/new
> > > > # mount -o loop /mnt/data/new /mnt/other
> > > > # cp --parents /bin/zsh-static /mnt/other/zsh
> > > > # umount /mnt/other
> > > > # qemu-system-ppc -enable-kvm -M mac99 -cpu G4 -k de -kernel /boot/=
vmlinuz-3.3.0-rc5-04520-g8d233c0 -append 'root=3D/dev/sda ro console=3DttyP=
Z0 init=3D/zsh' -hda /mnt/data/new
> > > >=20
> > > > I've uploaded my config and the kernel:
> > > > http://alioth.debian.org/~jo-guest/config-3.3.0-rc5-04520-g8d233c0
> > > > http://alioth.debian.org/~jo-guest/vmlinuz-3.3.0-rc5-04520-g8d233c0
> > > >=20
> > > > You have to switch to the serial console (Ctrl-Alt-3 or with -nogra=
phic
> > > > Ctrl-a c). All kernel messages arrive there.
> > > >=20

> Hi,=20
>=20
> Below patch should fix the problem.
>=20
> Could you help to test it?

Yes, it does. The kernel doesn't hang at bootup. Thanks for you
investigation.

> >From a36022015c97c9a9f80e71b4283f0ff5f481ffc3 Mon Sep 17 00:00:00 2001
> From: Lin Ming <ming.m.lin@intel.com>
> Date: Tue, 20 Mar 2012 14:35:10 +0800
> Subject: [PATCH] [SCSI] scsi_lib: use correct DMA device in __scsi_alloc_=
queue
>=20
> Currently, __scsi_alloc_queue uses SCSI host's parent device
> as DMA device to set segment boundary. But the parent device may not
> refer to the DMA device. For example, for ATA disk, SCSI host's parent
> device now refers to ATA port.
>=20
> Since commit d139b9b([SCSI] scsi_lib_dma: fix bug with dma maps on
> nested scsi objects), a new field Scsi_Host->dma_device was introduced
> to refer to the real DMA device.
>=20
> Use ->dma_device in __scsi_alloc_queue to correctly set segment
> boundary.
>=20
> And use scsi_add_host_with_dma in ata_scsi_add_hosts to pass in the
> correct DMA device.
>=20
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Tested-by: J=F6rg Sommer <joerg@alea.gnuu.de>

> ---
>  drivers/ata/libata-scsi.c |    3 ++-
>  drivers/scsi/scsi_lib.c   |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 7ae1e77..e47f889 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3398,7 +3398,8 @@ int ata_scsi_add_hosts(struct ata_host *host, struc=
t scsi_host_template *sht)
>  		 */
>  		shost->max_host_blocked =3D 1;
> =20
> -		rc =3D scsi_add_host(ap->scsi_host, &ap->tdev);
> +		rc =3D scsi_add_host_with_dma(ap->scsi_host,
> +						&ap->tdev, ap->host->dev);
>  		if (rc)
>  			goto err_add;
>  	}
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f85cfa6..486088b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1642,7 +1642,7 @@ struct request_queue *__scsi_alloc_queue(struct Scs=
i_Host *shost,
>  					 request_fn_proc *request_fn)
>  {
>  	struct request_queue *q;
> -	struct device *dev =3D shost->shost_gendev.parent;
> +	struct device *dev =3D shost->dma_dev;
> =20
>  	q =3D blk_init_queue(request_fn, NULL);
>  	if (!q)
> --=20
> 1.7.2.5
>=20
>=20

Regards, J=F6rg.
--=20
Dein Gesicht wird dir geschenkt. L=E4cheln musst du selber! (Inga Hermann)

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9qLroACgkQwe0mZwH1VICSVwCfZd66Qmj86U7SOtEGlPTJhLrP
L24An2DOPF6ctF6i3vZ1LA7tAdImuC/V
=oPZi
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--

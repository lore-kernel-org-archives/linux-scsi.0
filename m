From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: (as141) Unaligned scatter-gather buffers and usb-storage
Date: Sun, 30 Nov 2003 17:30:13 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20031130173013.B2136@one-eyed-alien.net>
References: <20031120191859.GA3569@kai.makisara.local> <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Fri, Nov 21, 2003 at 01:03:05PM -0500
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?iso-8859-1?Q?Kai_M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Jens Axboe <axboe@suse.de>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm going to hold on to this patch until I see the SCSI parts go in.  Alan,
try to remind me if you don't see this get merged after a while.

Matt

On Fri, Nov 21, 2003 at 01:03:05PM -0500, Alan Stern wrote:
> I'm not sure whether Jens is objecting to adding the extra member to the
> host template or to making the default alignment something other than 512=
. =20
> Here's my attempt at a compromise patch, which boils the area of
> disagreement between Kai and Jens down to a single line of code (plus a
> comment).  It doesn't change the host template and it shouldn't slow down
> any tape I/O programs when using a non-USB device.
>=20
> If there aren't any more objections to this, I urge James to apply the
> SCSI parts to a post-2.6.0-final tree, and likewise for Matt and the USB=
=20
> part.
>=20
> Alan Stern
>=20
>=20
> =3D=3D=3D=3D=3D scsiglue.c 1.60 vs edited =3D=3D=3D=3D=3D
> --- 1.60/drivers/usb/storage/scsiglue.c	Fri Oct 24 14:53:38 2003
> +++ edited/drivers/usb/storage/scsiglue.c	Fri Nov 21 12:45:21 2003
> @@ -65,6 +65,16 @@
> =20
>  static int slave_configure (struct scsi_device *sdev)
>  {
> +	/* Scatter-gather buffers (all but the last) must have a length
> +	 * divisible by the bulk maxpacket size.  Otherwise a data packet
> +	 * would end up being short, causing a premature end to the data
> +	 * transfer.  Since high-speed bulk pipes have a maxpacket size
> +	 * of 512, we'll use that as the scsi device queue's DMA alignment
> +	 * mask.  Guaranteeing proper alignment of the first buffer will
> +	 * have the desired effect because, except at the beginning and
> +	 * the end, scatter-gather buffers follow page boundaries. */
> +	blk_queue_dma_alignment(sdev->request_queue, (512 - 1));
> +
>  	/* this is to satisify the compiler, tho I don't think the=20
>  	 * return code is ever checked anywhere. */
>  	return 0;
> =3D=3D=3D=3D=3D sg.c 1.48 vs edited =3D=3D=3D=3D=3D
> --- 1.48/drivers/scsi/sg.c	Fri Oct 24 14:53:37 2003
> +++ edited/drivers/scsi/sg.c	Fri Nov 21 12:28:52 2003
> @@ -1741,7 +1741,11 @@
>  	int sg_tablesize =3D sfp->parentdp->sg_tablesize;
>  	struct scatterlist *sgl;
>  	int mx_sc_elems, res;
> +	struct scsi_device *sdev =3D sfp->parentdp->device;
> =20
> +	if (((unsigned long)hp->dxferp &
> +			queue_dma_alignment(sdev->request_queue)) !=3D 0)
> +		return 1;
>  	mx_sc_elems =3D sg_build_sgat(schp, sfp, sg_tablesize);
>          if (mx_sc_elems <=3D 0) {
>                  return 1;
> =3D=3D=3D=3D=3D st.c 1.45 vs edited =3D=3D=3D=3D=3D
> --- 1.45/drivers/scsi/st.c	Fri Sep  5 12:16:40 2003
> +++ edited/drivers/scsi/st.c	Fri Nov 21 12:30:34 2003
> @@ -1267,7 +1267,8 @@
>  		i =3D STp->try_dio && try_rdio;
>  	else
>  		i =3D STp->try_dio && try_wdio;
> -	if (i) {
> +	if (i && ((unsigned int)buf & queue_dma_alignment(
> +					STp->device->request_queue)) =3D=3D 0) {
>  		i =3D st_map_user_pages(&(STbp->sg[0]), STbp->use_sg,
>  				      (unsigned long)buf, count, (is_read ? READ : WRITE),
>  				      STp->max_pfn);
> =3D=3D=3D=3D=3D scsi_scan.c 1.52 vs edited =3D=3D=3D=3D=3D
> --- 1.52/drivers/scsi/scsi_scan.c	Fri Oct 24 14:53:37 2003
> +++ edited/drivers/scsi/scsi_scan.c	Fri Nov 21 12:34:00 2003
> @@ -231,6 +231,15 @@
>  	sdev->request_queue->queuedata =3D sdev;
>  	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
> =20
> +	/*
> +	 * Set the queue's mask to require a mere 8-byte alignment for
> +	 * DMA buffers, rather than the default 512.  This shouldn't
> +	 * inconvenience any user programs and should be okay for most
> +	 * host adapters.  A host driver can alter this mask in its
> +	 * slave_alloc() or slave_configure() callback if necessary.
> +	 */
> +	blk_queue_dma_alignment(sdev->request_queue, (8 - 1));
> +
>  	if (shost->hostt->slave_alloc) {
>  		if (shost->hostt->slave_alloc(sdev))
>  			goto out_free_queue;

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I want my GPFs!!!
					-- Stef
User Friendly, 11/9/1998

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/ypmlIjReC7bSPZARAm9fAJ0XCqRXrp0De8rzootbSO4YQ3OoiQCgg8jI
skXENpYIWo5ZhJkYyEaU23o=
=Y7ic
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--


-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?  SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: (as141) Unaligned scatter-gather buffers and usb-storage
Date: Sun, 4 Jan 2004 16:41:58 -0800
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <20040105004158.GA30408@one-eyed-alien.net>
References: <20031120191859.GA3569@kai.makisara.local> <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kai =?iso-8859-1?Q?M=E4kisara?= <kai.makisara@kolumbus.fi>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Jens Axboe <axboe@suse.de>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Is there any indication that the SCSI parts of this patch will get
accepted?

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

I need a computer?
					-- Customer
User Friendly, 2/19/1998

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/+LLWIjReC7bSPZARApQeAJ0ZEYeJm/qNO4CiLQeM82IWTlJ73wCggBmh
YBBDUQd209LrQxgb3iwveaE=
=W7S4
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--


-------------------------------------------------------
This SF.net email is sponsored by: IBM Linux Tutorials.
Become an expert in LINUX or just sharpen your skills.  Sign up for IBM's
Free Linux Tutorials.  Learn everything from the bash shell to sys admin.
Click now! http://ads.osdn.com/?ad_id=1278&alloc_id=3371&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Tue, 23 Feb 2010 11:49:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1002231143450.1308-100000@iolanthe.rowland.org>
References: <3e7aae31002230729h823ba5dk374de6fdf32c5556@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44243 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752620Ab0BWQtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 11:49:22 -0500
In-Reply-To: <3e7aae31002230729h823ba5dk374de6fdf32c5556@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Tue, 23 Feb 2010, Ramya Desai wrote:

> On Mon, Feb 22, 2010 at 11:14 PM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
>=20
> Dear Alan,
>=20
> Thanks for the information.
>=20
> > Usb-storage sets max_sectors to 240 in the host template. =A0For so=
me
> > reason, the block layer also changes max_hw_sectors to the same val=
ue
> > (see block/blk-settings.c:blk_queue_max_sectors()).
>=20
> I am setting the max_sectors in host template (scsiglue.c file). When
> the max_sectors value is <=3D 1024, then only the max_sectors_kb and
> max_hw_sectors_kb are same in the sys interface. However, if the
> max_sectors value is > 1024 then the values in the sys interface file=
s
> are different as shown in block/blk-setting.c:blk_queue_max_sectors()=
=2E
>=20
> if (BLK_DEF_MAX_SECTORS > max_sectors)
> 	q->limits.max_hw_sectors =3D q->limits.max_sectors =3D max_sectors;
> else {
> 	q->limits.max_sectors =3D BLK_DEF_MAX_SECTORS;
> 	q->limits.max_hw_sectors =3D max_sectors;
> }

James or Jens, is there a reason why this routine limits max_sectors to
1024?

And is there a reason why it sets both max_sectors and max_hw_sectors,=20
leaving no way to change one without the other?

Are drivers supposed to assign values directly to=20
q->limits.max_sectors?  Shouldn't there be a cleaner API for all this?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

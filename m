From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Wed, 24 Feb 2010 14:12:11 +0100
Message-ID: <20100224131211.GA1025@kernel.dk>
References: <yq1aauzopk2.fsf@sermon.lab.mkp.net> <Pine.LNX.4.44L0.1002231253320.1308-100000@iolanthe.rowland.org> <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39529 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756933Ab0BXNMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Feb 2010 08:12:12 -0500
Content-Disposition: inline
In-Reply-To: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Wed, Feb 24 2010, Ramya Desai wrote:
> On Tue, Feb 23, 2010 at 11:31 PM, Alan Stern <stern@rowland.harvard.e=
du> wrote:
>=20
> Dear Alan,
>=20
> Thanks a lot.
>=20
> > So Ramya, it looks like you need to edit store_max_sectors() in
> > drivers/usb/storage/scsiglue.c. =A0Get rid of the " && ms <=3D
> > SCSI_DEFAULT_MAX_SECTORS" part.
> >
> > Then you should be able to write a large value to
> > /sys/block/sdX/device/max_sectors to increase the hardware limit. =A0=
The
> > new value divided by 2 will show up in
> > /sys/block/sdX/queue/max_hw_sectors_kb.
> >
> > Once that limit is increased, you can write a large value to
> > /sys/block/sdX/queue/max_sectors_kb. =A0That should give you long
> > transfer lengths.
>=20
> I did exactly. I removed the following statement from
> store_max_sectors (drivers/usb/storage/scsiglue.c) function.
> " && ms <=3D SCSI_DEFAULT_MAX_SECTORS". I also changed the .max_secto=
rs
> =3D 2048 in the host template.
>=20
> Then I restarted the system and build the usb-storage without any iss=
ue.
>=20
> After inserting my device, I found 1024 in
> /sys/block/sdb/device/max_sectors. So, I tried to increase the value
> through echo 2048 > /sys/block/sdb/device/max_sectors. When I do this=
,
> it invoked the store_max_sectors() in the scsiglue.c file and able to
> see ms (the variable in the store_max_sectors()) is 2048. But, the
> value in the /sys/block/sdb/device/max_sectors is still 1024 only.
>=20
> When I looked into the /sys/block/sdb/queue/max_hw_sectors_kb, it
> shows 1024, which is 2048 sectors. Then, I tried to increase the valu=
e
> in /sys/block/sdb/queue/max_sectors_kb through echo 1024 >
> /sys/block/sdb/queue/max_sectors_kb. After this, I saw 1024 in the
> /sys/block/sdb/queue/max_sectors_kb. When I see 1024 in
> /sys/block/sdb/queue/max_sectors_kb then I found 2048 in
> /sys/block/sdb/device/max_sectors. However, this time, still my devic=
e
> received 512 KB (1024) data transfer buffers in scsi_command.
>=20
> Please let me know If I missed any thing here?

You cannot make max_sectors_kb larger than max_hw_sectors_kb, as the
latter implies a hardware restriction (as seen by the block layer).
Drivers should not fiddle with max_sectors_kb, they should only concern
themselves with max_hw_sectors. The former is then set to a reasonable
value, which is either the system default or the hardware limit, which
ever one is lower.

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

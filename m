From: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Wed, 24 Feb 2010 18:37:27 +0530
Message-ID: <3e7aae31002240507r5d5c4c2bj8e653a3d65fa6709@mail.gmail.com>
References: <yq1aauzopk2.fsf@sermon.lab.mkp.net>
	 <Pine.LNX.4.44L0.1002231253320.1308-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1002231253320.1308-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 23, 2010 at 11:31 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org=
> wrote:

Dear Alan,

Thanks a lot.

> So Ramya, it looks like you need to edit store_max_sectors() in
> drivers/usb/storage/scsiglue.c. =A0Get rid of the " && ms <=3D
> SCSI_DEFAULT_MAX_SECTORS" part.
>
> Then you should be able to write a large value to
> /sys/block/sdX/device/max_sectors to increase the hardware limit. =A0=
The
> new value divided by 2 will show up in
> /sys/block/sdX/queue/max_hw_sectors_kb.
>
> Once that limit is increased, you can write a large value to
> /sys/block/sdX/queue/max_sectors_kb. =A0That should give you long
> transfer lengths.

I did exactly. I removed the following statement from
store_max_sectors (drivers/usb/storage/scsiglue.c) function.
" && ms <=3D SCSI_DEFAULT_MAX_SECTORS". I also changed the .max_sectors
=3D 2048 in the host template.

Then I restarted the system and build the usb-storage without any issue=
=2E

After inserting my device, I found 1024 in
/sys/block/sdb/device/max_sectors. So, I tried to increase the value
through echo 2048 > /sys/block/sdb/device/max_sectors. When I do this,
it invoked the store_max_sectors() in the scsiglue.c file and able to
see ms (the variable in the store_max_sectors()) is 2048. But, the
value in the /sys/block/sdb/device/max_sectors is still 1024 only.

When I looked into the /sys/block/sdb/queue/max_hw_sectors_kb, it
shows 1024, which is 2048 sectors. Then, I tried to increase the value
in /sys/block/sdb/queue/max_sectors_kb through echo 1024 >
/sys/block/sdb/queue/max_sectors_kb. After this, I saw 1024 in the
/sys/block/sdb/queue/max_sectors_kb. When I see 1024 in
/sys/block/sdb/queue/max_sectors_kb then I found 2048 in
/sys/block/sdb/device/max_sectors. However, this time, still my device
received 512 KB (1024) data transfer buffers in scsi_command.

Please let me know If I missed any thing here?

Thanks and Regards,
RD.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

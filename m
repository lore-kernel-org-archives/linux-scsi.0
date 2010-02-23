From: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Tue, 23 Feb 2010 20:59:55 +0530
Message-ID: <3e7aae31002230729h823ba5dk374de6fdf32c5556@mail.gmail.com>
References: <1266843999.4414.27.camel@mulgrave.site>
	 <Pine.LNX.4.44L0.1002221232160.1251-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1002221232160.1251-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 22, 2010 at 11:14 PM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org=
> wrote:

Dear Alan,

Thanks for the information.

> Usb-storage sets max_sectors to 240 in the host template. =A0For some
> reason, the block layer also changes max_hw_sectors to the same value
> (see block/blk-settings.c:blk_queue_max_sectors()).

I am setting the max_sectors in host template (scsiglue.c file). When
the max_sectors value is <=3D 1024, then only the max_sectors_kb and
max_hw_sectors_kb are same in the sys interface. However, if the
max_sectors value is > 1024 then the values in the sys interface files
are different as shown in block/blk-setting.c:blk_queue_max_sectors().

if (BLK_DEF_MAX_SECTORS > max_sectors)
	q->limits.max_hw_sectors =3D q->limits.max_sectors =3D max_sectors;
else {
	q->limits.max_sectors =3D BLK_DEF_MAX_SECTORS;
	q->limits.max_hw_sectors =3D max_sectors;
}

I guess, in my case, it enters into the ELSE part. I tried to debug
these sources (block/blk-setting.c), but I am not able to do it.
Please let me know, how can I get the debug statements from this file?

> The value can be changed by writing to
> /sys/block/sdX/device/max_sectors (where X is the drive letter). =A0N=
ote
> that this value is in 512-byte blocks, not in KB. =A0However it is
> limited to SCSI_DEFAULT_MAX_SECTORS, which is 1024, corresponding to
> 512 MB. =A0If larger transfers are needed then
> drivers/usb/storage/scsiglue.c:store_max_sectors() must be changed.

I have chaged the value in /sys/block/sdb/queue/max_sectors_kb through
echo command. Even after this change,  I have received only 1024
sectors (512 KB) data transfer buffers in my SCSI command. Even I have
modified the store_max_sectors() function code in the scsiglue.c file.
But, there is no luck and still I received 1024 sectors (512 KB)
transfer buffers in the scsi_command.

Please let me know, if you need any additional information.

Thanks and Regards,
RD.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

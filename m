From: "Kay Sievers" <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Mon, 27 Oct 2008 17:26:17 +0100
Message-ID: <ac3eb2510810270926m2e47bdb2ra8ff38282a8a9ed0@mail.gmail.com>
References: <Pine.LNX.4.44L0.0810271007030.4059-100000@iolanthe.rowland.org>
	 <4905D68D.7030407@interlog.com> <4905D986.6050001@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4905D986.6050001-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Luciano Rocha <luciano-YWehAnL2kLNBDgjK7y7TUQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Linux-Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 27, 2008 at 16:08, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org> wrote:
> Douglas Gilbert wrote:
>>
>> Since the READ CAPACITY "off by one" error is so common,
>> perhaps drivers such as usb-storage could have a hook to
>> do a pseudo READ CAPACITY. Then if the capacity value
>> looked odd (in both senses) the driver could do an IO to
>> the suspect block and if that failed decrement the capacity
>> value passed back to the mid level.
>> Put another way, why don't these defective devices trip up
>> another OS?
>>
>
> Window$ never reads the last sector unless it is actually written
> to. I had such a device it got stuck when I wrote to the
> last sector.
>
>> BTW a single disk in RAID 0 (seen on a HP E200 controller)
>> has a shortened capacity value seen in the midlevel on the
>> corresponding logical drive. That missing chunk is probably
>> where the RAID controller puts its control information.
>> Anyway, playing with the capacity value returned by READ
>> CAPACITY certainly has a precedent.
>>
>>> Later on the system tries to read the contents of what it thinks is the
>>> last sector:
>>
>> I know that happens but it seems strange that upper levels
>> are reading a block that has never been written to. Read ahead?
>>
>
> That would be udev or hald, I can't remember which. It is a special Linux
> fixture. ;)

It's vol_id from udev. To auto-detect raid setups, LVM, MD metadata, ...

Such devices carry their magic sequence at the "end" of the device,
usually the last sector or a few sectors before the last sector. The
"last" sector is obviously determined by the capacity the device
reports.

There is no way around looking at all block devices' last sector on a
Linux box, as long as people expect auto-setup, auto-mounting,
anything that is not put in /etc/fstab to work, as long as any "meta
device" format puts a magic number at the end of the device.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

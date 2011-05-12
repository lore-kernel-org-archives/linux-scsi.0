From: Charles Hannum <root-5QZFqCxYnb9eoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone
 (one line)
Date: Thu, 12 May 2011 16:59:24 -0400
Message-ID: <BANLkTin1peZBPiRZCbMEeqaME=-ok5dCQw@mail.gmail.com>
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
	<201105122203.13671.rjw@sisk.pl>
	<1305232563.2575.85.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305232563.2575.85.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, May 12, 2011 at 16:36, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Thu, 2011-05-12 at 22:03 +0200, Rafael J. Wysocki wrote:
>> Hi,
>>
>> Added some CCs.
>>
>> On Thursday, May 12, 2011, Charles Hannum wrote:
>> > Short version: My laptop doesn't suspend when my Android phone is
>> > connected and has been =93ejected=94.
>> >
>> > Long version:
>> >
>> > Android phones connect as USB mass storage devices. =A0After the =93=
Turn
>> > on USB storage=94 button has been clicked, there are a few differe=
nt
>> > ways to detach the =93disk=94:
>> >
>> > 1) pull the cable
>> > 2) click =93Turn off USB storage=94
>> > 3) =93eject=94 the device
>> >
>> > In cases 2 & 3, the USB device is still attached to the system, bu=
t
>> > will now return MEDIUM NOT PRESENT for many commands, including
>> > SYNCHRONIZE CACHE=97basically it acts like any device with removab=
le
>> > media. =A0However, the act of the =93media=94 being removed does n=
ot
>> > invalidate sdkp->WCE; therefore sd_shutdown() and sd_suspend() sti=
ll
>> > call sd_sync_cache(), which *fails* because it gets a MEDIUM NOT
>> > PRESENT sense code. =A0In the sd_suspend() case, this causes the e=
ntire
>> > suspend to fail, and the laptop rewakes immediately.
>
> So this was the subject of some debate when suspend of sd was first
> introduced. =A0The synopsis of that debate is that by suspending, we'=
re
> about the power down the system, and anything in the cache will be lo=
st,
> possibly causing corruption, so failure to synchronise the cache
> *should* abort suspend.

If the device has been =93ejected=94, there is by definition no data in
the cache that needs to be synchronized=97or, if there is, it's because
we failed to do a SYNCHRONIZE CACHE in the eject path.  At this point
the device believes there's no medium present, and the driver even
agrees, so it's perfectly reasonable for the device to return MEDIUM
NOT PRESENT.  The problem here is a generic failure of the suspend
code in the case of removable media that has been removed=97there is a
piece of state left behind in the driver that causes it to misbehave.

Nothing I have mentioned (other than enumerating the cable-pulling
case), nor the change I proposed, has anything whatsoever to do with
the user inappropriately yanking an active device.

>> > There are a few different ways to fix this; e.g. one could
>> > specifically test media_not_present() if a sense code is returned =
in
>> > sd_sync_cache().
>
> Isn't this the best approach? =A0For removable medium, the onus is on=
 the
> user not to eject with the cache unsynced. =A0If the user ignores tha=
t, we
> should recognise the problem and take a caveat emptor approach.

I was attempting to make the case where the user behaved completely
appropriately work right, not worrying about the other cases.  It
seems a bit silly to even call sd_sync_cache() if we already know the
medium has been removed; furthermore, it means the behavior is
different between when the device is first plugged in (WCE is still 0)
and when it's been used and then ejected (WCE remains 1 until a new
medium is inserted); this inconsistency seems poor.

> As a side note: having write through caches on removable media is a
> really silly idea because of the above problem ...

In the Android case, I see no reason why it's a problem, and the
device acts appropriately under the circumstances.  And given tray
locking, I'm not sure why it's a problem even for spinning media.  But
regardless, these are real devices, and that ship has long since
sailed.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

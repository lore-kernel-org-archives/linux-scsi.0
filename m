From: Oliver Neukum <oliver@neukum.name>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 20:00:29 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200301212000.29832.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301210150.55286.oliver@neukum.name> <3E2D8E78.4050405@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <3E2D8E78.4050405@splentec.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Luben Tuikov <luben@splentec.com>
Cc: David Brownell <david-b@pacbell.net>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 21. Januar 2003 19:16 schrieb Luben Tuikov:
> Oliver Neukum wrote:
> > Disconnect is not really a callback. There's a distinct lack of a bac=
k
> > movement here. khubd -> usbcore -> disconnect() in driver -> [layer o=
n
> > top]
> >
> > The proposed API in SCSI looks like:
> > <bus system> -> LLD -> midlayer -> top layer -> midlayer -> LLD with
> > destroy_slave() and that's not OK.
>
> No, not quite.
>
> When the Low Level Device Driver (LLDD), being the transport portal,
> notices that the device is going away or has gone away from the
> ``fabric'' (wlg), it will fire a device-gone event with the kernel.
> *Not* necessarily with SCSI Core, in fact I'd rather it didn't,
> but with a well defined kernel entry for device-gone events.

Well, we are in feature freeze. I see no alternative but to notify
the mid layer. Who else but the mid layer knows what a physical device
is logically associated with?

> At the same time the LLDD will start returning TARGET gone, or
> whatever is appropriate to newly queued commands, and error out
> all internally queued commands (if it does it's own queuing).
> (I've seen this work nicely on mount and read/write(2) and fsck.)

Right.

> I.e. the ``synchronization'' has started already by the LLDD erroring
> out commands, new and queued.
>
> All the while the kernel has started higher level cleaning up,
> decrementing ref counts, etc, stuff which may not be so easy to be
> cleaned up just by LLDD returning TARGET error.  Even though,

You cannot really make anything depend on errors returned, because
there simply may not be any commands queued. You can make it a
requirement for an LLDD to return all commands in flight with an error,
but you can do little with these errors. Basically you have to treat them
like uncorrectable errors, except maybe for the error code returned to
user space. But the processing of the disconnect itself should be trigger=
ed
by the LLDD's notification, because it's the only indication of an unplug
event you are sure to get.

> good design dictates that complete cleaning up should happen just
> by the LLDD returning TARGET error (e.g. on mount), we *have* to allow
> for this immediate high level entry point (as I mentioned above)
> notification, which will be kind of ``meeting place'' for events like t=
his.

That I don't understand. It would seem to me to be cleanest to have just
one path to process a disconnect event.

> Depending on what needs to be done at those ``higher'' levels, the
> event will eventually bubble down to the SCSI Core with something like
> scsi_remove_device() which will do slave_destroy() in the driver.
>
> The point is that at that point in time, it will be *safe* to do
> scsi_remove_device() as all ULP have alreay been notified, and they've
> relinquished their use of the LLD (Low Level Device), thus the safety.

But there can be no users of the LLDD at this point. There can of
course be references to devices and hosts, but not really uses.
After we have done a notification of the event the first things to do
are to make further opening of the device fail and make sure no more
commands are sent to the device. Likewise all queued commands have
returned with an error. So at this point it's impossible to use an unplug=
ged
device.

> But there's no such thing as ``waiting around indefinitely'' or
> ``blocking wait'' as you've suggested in some of your emails.
>
> Even if this UL entry point doesn't do anything, ref counts should
> go to zero, after all users error out on this device, at which point
> the user can remove the device from *the system* by hand/old method
> through proc or whatever finalizes for 2.6.

You cannot be sure that reference counts will go to zero ever.
You can be sure that they won't increase as you can fail any operation th=
at
would cause them to increase, but you cannot force userland to close its =
fds.
And waiting for somebody to remove a device is wrong. It's gone physicall=
y.
There's no choice but to remove it. The refcounts can tell you when to fr=
ee
data structures associated with devices, but what else do you want them t=
o do?

=09Regards
=09=09Oliver



-------------------------------------------------------
This SF.net email is sponsored by: Scholarships for Techies!
Can't afford IT training? All 2003 ictp students receive scholarships.
Get hands-on training in Microsoft, Cisco, Sun, Linux/UNIX, and more.
www.ictp.com/training/sourceforge.asp
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

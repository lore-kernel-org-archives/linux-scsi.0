From: Oliver Neukum <oliver@neukum.name>
Subject: Re: Re: [PATCH] USB changes for 2.5.58
Date: Fri, 17 Jan 2003 23:07:41 +0100
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200301172307.41308.oliver@neukum.name>
References: <10426732153816@kroah.com> <20030117105414.E359@one-eyed-alien.net> <20030117202523.GE1225@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20030117202523.GE1225@beaverton.ibm.com>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Mike Anderson <andmike@us.ibm.com>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


> > The way this should work is that the LLD calls scsi_remove_device(), =
and
> > that cuts off the flow of commands.  The LLD can promise to error-out=
 any
> > pending commands in the device command queue.
> >
> > That is, unless scsi_block_requests() and scsi_unblock_requests() are
> > more useful than the documentation suggests... block(), error all
> > commands, unregister()... that would make some sense.  We could call
> > scsi_block_request() as soon as we know the unit is gone, and
> > unregister() as soon as the queue is empty.
>
> We should really ensure that we have good separation between stopping
> device IO, device gone, and release resources.

Very good.

> =09- SCSI seems to have the flags to stop the IO, but instead of
> =09  scsi_block_requests we may want to export the setting of
> =09  device online. This can be done from sysfs now, but

Yes, extremely good, we _need_ this.

> =09  not from the driver ( the driver does have a handle to the
> =09  device, but it would be better to have an interface in case we
> =09  need to do something addition operations).
>
> =09- Possibly add a scsi_remove_device that would always succeed and
> =09  a version of scsi_remove_host that calls scsi_remove_device for
> =09  all devices. Though with the recent change to SCSI remove host to
> =09  allow non sysfs device registration I do not believe we could
> =09  ensure devices would be cleaned up.

Meaning? If memory stays tied up, we have a beautiful DOS attack,
if disconnection can be faked by software.

=09Regards
=09=09Oliver



-------------------------------------------------------
This SF.NET email is sponsored by: Thawte.com - A 128-bit supercerts will
allow you to extend the highest allowed 128 bit encryption to all your 
clients even if they use browsers that are limited to 40 bit encryption. 
Get a guide here:http://ads.sourceforge.net/cgi-bin/redirect.pl?thaw0030en
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

From: Oliver Neukum <oliver@neukum.name>
Subject: Re: [linux-usb-devel] Re: [PATCH] USB changes for 2.5.58
Date: Tue, 21 Jan 2003 01:50:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301210150.55286.oliver@neukum.name>
References: <10426732153816@kroah.com> <200301210000.24705.oliver@neukum.name> <3E2C97D7.1070406@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3E2C97D7.1070406@pacbell.net>
List-Id: linux-scsi@vger.kernel.org
To: David Brownell <david-b@pacbell.net>
Cc: Luben Tuikov <luben@splentec.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Mike Anderson <andmike@us.ibm.com>, Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Dienstag, 21. Januar 2003 01:44 schrieb David Brownell:
> Oliver Neukum wrote:
> >>So you were talking past what I said about notifying that highest level,
> >>not disagreeing with it.
> >
> > I was trying to make the point that callbacks have no place in that
> > process.
>
> If so, you didn't persuade me ...
>
> > It must go bottom to top and that's it.
>
> ... because those disconnect() callbacks are exactly how USB and PCI
> deliver that notification to the "top" level, and you've already agreed
> that SCSI needs to accomodate those models.  So clearly they have at least
> that much of a place.

Disconnect is not really a callback. There's a distinct lack of a back movement here.
khubd -> usbcore -> disconnect() in driver -> [layer on top]

The proposed API in SCSI looks like:
<bus system> -> LLD -> midlayer -> top layer -> midlayer -> LLD with destroy_slave()
and that's not OK.

> > 	 Refusing to take notice of a device removal is just not an option.
> > This is exactly what the current SCSI idea of an API to do bus removal
> > does.
>
> I perceive violent agreement that a change is needed in that area.
>
> But the next step there would seem to be a patch to the SCSI APIs,
> unless I mis-understood what Matt was saying about the issue he ran
> into when making usb-storage use the enumeration facilities in the
> current SCSI mid/low layers.

I have some horrible notions when I see what APIs grace the SCSI layer.

	Regards
		Oliver


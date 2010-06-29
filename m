From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Alternate ways to do Scatter-Gather from BOT Class driver
Date: Tue, 29 Jun 2010 14:06:06 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006291352470.1314-100000@iolanthe.rowland.org>
References: <AANLkTilIM-9svLKrqaPfsjESn_9VnqsffBDwtiau8B_3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTilIM-9svLKrqaPfsjESn_9VnqsffBDwtiau8B_3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Subs <sar.subs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 29 Jun 2010, Subs wrote:

> On Tue, Jun 29, 2010 at 12:25 AM, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLrNAH6kLmebB@public.gmane.org=
du> wrote:
> > On Mon, 28 Jun 2010, Subs wrote:
> >
> >> Hi All,
> >>
> >> In my class driver I am receiving data transfer buffer as number o=
f
> >> Scatter-Gather lists from SCSI layer to perform data transfers.
> >>
> >> Is there any alternate way to get the transfer buffer from SCSI ot=
her
> >> than SG. I wanted to receive the complete data transfer buffer as =
a
> >> single pointer.
> >
> > As far as I know, there is no alternate way to get the transfer buf=
fer
> > from the SCSI layer.
> >
> > However you can get the effect you want by setting the sg_tablesize
> > field in your scsi_host_template to 1.
> >
> > Just out of curiosity, why are you writing a class driver for the B=
OT
> > class? =A0Aren't the two existing drivers in the kernel good enough=
?
> >
> > Alan Stern
> >
> >
>=20
> By changing sg_tablesize to 1, there is no change in number of buffer=
s
> that I am receiving in SG list.

Then you must be doing something wrong.  I just tried changing
sg_tablesize in the usb-storage driver, and as a result the
scatterlists it received contained only one element.  (Of course, in
usb-storage what matters is not the value in the scsi_host_template but
rather the value returned by usb_stor_sg_tablesize.)

> > Just out of curiosity, why are you writing a class driver for the B=
OT
> > class?  Aren't the two existing drivers in the kernel good enough?
>=20
> I am writing my custom class driver, which can do Control and Bulk
> transfers only. This is nowhere related to Mass Storage BOT transfers=
=2E

Then why did you mention BOT in the email Subject: line?  Does it refer=
=20
to something other than Bulk-Only-Transport?

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

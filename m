From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Date: Mon, 8 Nov 2010 09:50:15 -0800 (PST)
Message-ID: <549309.47855.qm@web31801.mail.mud.yahoo.com>
Reply-To: ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

--- On Mon, 11/8/10, Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:
> --- On Mon, 11/8/10, Matthew Wilcox
> <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> wrote:
> > On Wed, Oct 27, 2010 at 01:22:22PM
> > -0700, Luben Tuikov wrote:
> > > "Be conservative in what you send, liberal in
> what
> > > you accept." -- In the spirit of this adage,
> don't
> > > send Command IUs with randomly filled in data in
> > > the reserved fields. (Yes, this shows up on the
> > > wire.)
> >=20
> > Applied, with a better changelog entry ...
>=20
> "Better"? Where did you apply it? Your willy/uas.git
> doesn't show it (updated 3 months ago), neither do Greg's.
>=20
> BTW, is it customary to change the change log?=A0 What
> did you change? Do you mind sharing?

Matthew, could you reply-all here with your new, changed and
modified change log?

I'd like you to be accountable to what and how you've changed the chang=
elog HERE and not in a git three somewhere and have an open comparison =
to what your new change log is and what is says.

Mine, quoted above:
  a) mentions an adage that's been around for 30 years at least,
     in the UNIX/net field to which we adhere.
  b) mentions (only!) the Command IU of making out on the wire
     with stale system data of the memory used for it.

Could you please reconsider your professional integrity and
submit the patch as is with the original log?

> > > @@ -660,7 +660,7 @@ static int uas_probe(struct
> > usb_interface *intf, const struct usb_device_id *id)
> > >=A0 =A0=A0=A0 =A0=A0=A0
> > =A0=A0=A0 return -ENODEV;
> > >=A0 =A0=A0=A0 }
> > >=A0=20
> > > -=A0=A0=A0 devinfo =3D kmalloc(sizeof(struct
> > uas_dev_info), GFP_KERNEL);
> > > +=A0=A0=A0 devinfo =3D kzalloc(sizeof(struct
> > uas_dev_info), GFP_KERNEL);
> > >=A0 =A0=A0=A0 if (!devinfo)
> > >=A0 =A0=A0=A0 =A0=A0=A0 return
> > -ENOMEM;
> > >=A0=20
> >=20
> > Except for this hunk, which isn't an IU and doesn't go
> out
> > on the wire.
>=20
> Lol, no of course it doesn't, silly!

And notice that /my/ change log doesn't claim that=20
uas_dev_info makes it out the wire. It only mentions that
the Command IU makes it out the wire with stale data.

>=20
> So help us understand: You've preserved all changes from
> kmalloc->kzalloc and left a single kmalloc alone. And
> your reason is that "*This* one doesn't go out on the
> wire?"
>=20
> Wouldn't if have been more consistent (and harmless) to
> have changed all of them, just as the patch did?
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

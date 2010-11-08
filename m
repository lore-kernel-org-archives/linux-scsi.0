From: Luben Tuikov <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Date: Mon, 8 Nov 2010 10:46:18 -0800 (PST)
Message-ID: <532497.95375.qm@web31810.mail.mud.yahoo.com>
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
> --- On Mon, 11/8/10, Luben Tuikov
> <ltuikov-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> wrote:
> > --- On Mon, 11/8/10, Matthew Wilcox
> > <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > wrote:
> > > On Wed, Oct 27, 2010 at 01:22:22PM
> > > -0700, Luben Tuikov wrote:
> > > > "Be conservative in what you send, liberal
> in
> > what
> > > > you accept." -- In the spirit of this
> adage,
> > don't
> > > > send Command IUs with randomly filled in
> data in
> > > > the reserved fields. (Yes, this shows up on
> the
> > > > wire.)
> > >=20
> > > Applied, with a better changelog entry ...
> >=20
> > "Better"? Where did you apply it? Your willy/uas.git
> > doesn't show it (updated 3 months ago), neither do
> Greg's.
> >=20
> > BTW, is it customary to change the change log?=A0 What
> > did you change? Do you mind sharing?
>=20
> Matthew, could you reply-all here with your new, changed
> and
> modified change log?
>=20
> I'd like you to be accountable to what and how you've
> changed the changelog HERE and not in a git three somewhere
> and have an open comparison to what your new change log is
> and what is says.
>=20
> Mine, quoted above:
> =A0 a) mentions an adage that's been around for 30 years
> at least,
> =A0 =A0=A0=A0in the UNIX/net field to which we
> adhere.
> =A0 b) mentions (only!) the Command IU of making out on
> the wire
> =A0 =A0=A0=A0with stale system data of the
> memory used for it.
>=20
> Could you please reconsider your professional integrity
> and
> submit the patch as is with the original log?

Matthew,

I did NOT Signed-off-by: with my name and email to a patch where you've=
 changed both the change log and the diff.

Now, you have two options here:

a) commit the modified by you patches, {change log and diff}, AS YOUR O=
WN patches, removing the Signed-off-by: me line, OR

b) commit the patch, {change log and diff}, as I've posted it, thus pre=
serving the Signed-off-by: me line.

A Signed-off-by: line is a digital signature, and we cannot have that u=
nder text (the change log) that that person didn't write or agree to.

I don't mind either a) or b), but if a) then we need to include this pr=
actice of changing the patch {change log and diff} by the maintainer an=
d removing the Signed-off-by: line of the author of the patch in Docume=
ntation/development-process/ so that contributors to the kernel are awa=
re of this practice.

>=20
> > > > @@ -660,7 +660,7 @@ static int
> uas_probe(struct
> > > usb_interface *intf, const struct usb_device_id
> *id)
> > > >=A0 =A0=A0=A0 =A0=A0=A0
> > > =A0=A0=A0 return -ENODEV;
> > > >=A0 =A0=A0=A0 }
> > > >=A0=20
> > > > -=A0=A0=A0 devinfo =3D kmalloc(sizeof(struct
> > > uas_dev_info), GFP_KERNEL);
> > > > +=A0=A0=A0 devinfo =3D kzalloc(sizeof(struct
> > > uas_dev_info), GFP_KERNEL);
> > > >=A0 =A0=A0=A0 if (!devinfo)
> > > >=A0 =A0=A0=A0 =A0=A0=A0 return
> > > -ENOMEM;
> > > >=A0=20
> > >=20
> > > Except for this hunk, which isn't an IU and
> doesn't go
> > out
> > > on the wire.
> >=20
> > Lol, no of course it doesn't, silly!
>=20
> And notice that /my/ change log doesn't claim that=20
> uas_dev_info makes it out the wire. It only mentions that
> the Command IU makes it out the wire with stale data.
>=20
> >=20
> > So help us understand: You've preserved all changes
> from
> > kmalloc->kzalloc and left a single kmalloc alone.
> And
> > your reason is that "*This* one doesn't go out on the
> > wire?"
> >=20
> > Wouldn't if have been more consistent (and harmless)
> to
> > have changed all of them, just as the patch did?
> >=20
> >
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

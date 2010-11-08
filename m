From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] UAS: Use kzalloc instead of kmalloc
Date: Mon, 8 Nov 2010 08:59:00 -0800 (PST)
Message-ID: <99736.19751.qm@web31801.mail.mud.yahoo.com>
References: <20101108112131.GG4173@linux.intel.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:35504 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754948Ab0KHQ7C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2010 11:59:02 -0500
In-Reply-To: <20101108112131.GG4173@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

--- On Mon, 11/8/10, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Wed, Oct 27, 2010 at 01:22:22PM
> -0700, Luben Tuikov wrote:
> > "Be conservative in what you send, liberal in what
> > you accept." -- In the spirit of this adage, don't
> > send Command IUs with randomly filled in data in
> > the reserved fields. (Yes, this shows up on the
> > wire.)
>=20
> Applied, with a better changelog entry ...

"Better"? Where did you apply it? Your willy/uas.git doesn't show it (u=
pdated 3 months ago), neither do Greg's.

BTW, is it customary to change the change log?  What did you change? Do=
 you mind sharing?

> > @@ -660,7 +660,7 @@ static int uas_probe(struct
> usb_interface *intf, const struct usb_device_id *id)
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return -ENODEV;
> >=A0 =A0=A0=A0 }
> >=A0=20
> > -=A0=A0=A0 devinfo =3D kmalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
> > +=A0=A0=A0 devinfo =3D kzalloc(sizeof(struct
> uas_dev_info), GFP_KERNEL);
> >=A0 =A0=A0=A0 if (!devinfo)
> >=A0 =A0=A0=A0 =A0=A0=A0 return
> -ENOMEM;
> >=A0=20
>=20
> Except for this hunk, which isn't an IU and doesn't go out
> on the wire.

Lol, no of course it doesn't, silly!

So help us understand: You've preserved all changes from kmalloc->kzall=
oc and left a single kmalloc alone. And your reason is that "*This* one=
 doesn't go out on the wire?"

Wouldn't if have been more consistent (and harmless) to have changed al=
l of them, just as the patch did?

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

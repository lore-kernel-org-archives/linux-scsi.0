From: Andrew Morton <akpm@osdl.org>
Subject: Re: lots and lots of disks again
Date: Wed, 11 Feb 2004 14:29:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211142933.484ca978.akpm@osdl.org>
References: <20040204024512.5bf68428.akpm@osdl.org>
	<20040210110417.GB4010@tpkurt.garloff.de>
	<20040210112658.GC4010@tpkurt.garloff.de>
	<20040210133932.A3870@infradead.org>
	<20040210154751.GH4010@tpkurt.garloff.de>
	<20040210102603.0c835212.akpm@osdl.org>
	<20040211145614.GA4010@tpkurt.garloff.de>
	<20040211132848.49eece0d.akpm@osdl.org>
	<20040211220918.GJ4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:4288 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266218AbUBKW1x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 17:27:53 -0500
In-Reply-To: <20040211220918.GJ4010@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com, "viro@parcelfarce.linux.theplanet.co.uk" <viro@parcelfarce.linux.theplanet.co.uk>

Kurt Garloff <garloff@suse.de> wrote:
>
> We're fighting about a static 4k array currently ;-)

yup.  Sorry I was distracting.

> Actually, I'm not sure we currently have the right discussion here.

Absolutely.

I was rather hoping that Al would follow up on his comments yesterday
actually.

Kurt Garloff <garloff@suse.de> wrote:
>
> Hi Andrew,
>=20
> On Wed, Feb 11, 2004 at 01:28:48PM -0800, Andrew Morton wrote:
> > Kurt Garloff <garloff@suse.de> wrote:
> > > If we really allocate thousands of disks, the overhead of this so=
lution
> > > will be higher than the bitmap, I'm afraid.
> >=20
> > Four (or eight) bytes per disk!  I perceive a lack of perspecitve h=
ere ;)
>=20
> We're fighting about a static 4k array currently ;-)
>=20
> Well, it's certainly true that the memory we allocate in gendisk per
> disk is higher than these wasted 4/8 bytes. It's just that I don't li=
ke
> wasting anything ... The waste is 32/64times higher than with our
> bitfield, except that it's dynamic.
>=20
> > I'd trade clarity of implementation for that. =20
>=20
> You seem to have used idr often before. It took me much longer to rea=
d
> the docu and look at the function decsl than to understand the array
> and the meaning of find_first_zero_bit().
>=20
> > (As well as, possibly, reduced memory use on low-end machines).
>=20
> This one is true.
>=20
> If you think this is a relevant issue, tell me. I'll convert to use
> idr then. Currently, I'm not sure whether the patch has any chance
> to be merged, given the opposition of some people.=20
>=20
> Actually, I'm not sure we currently have the right discussion here.
>=20
> We want to have > 256 disk support, and we need to agree on how we=20
> want to present it to the user. Changing some implementation behind
> this is not really painful to do afterwards. Changing the way we
> interpret majors/minors would be painful. Thus the suggestion of
> Matthew which I liked and adopted. No need for new majors, no
> changes to the well known numbers.
>=20
> Of course there's the long term perspective of having a "disk" major
> and udev taking care of everything. This will happen, but nobody
> so far told that this should be done within 2.6. Nor do I see
> udev replacing the classical device nodes completely within that
> timeframe.
>=20
> If we want something useful now, we need to keep the old disks=20
> major/minor scheme untouched.
> I see two possibilities to get somes done:
> * Matthew's proposal (whatever we use the two extra "partition"
>   bits for in the end)
> * Introducing new majors, where we introduce a new numbering scheme.
>   One major can accomodate 65536 disks =E0 16 partitions or 8192 disk=
s
>   with 64 partitions. We'd allocate one new major and sort disks
>   after 256 there. The 64 partitions is actually out of the race,
>   as the number of possible partitions would depend on the order=20
>   that scsi disks are detected :-/
>=20
> I think adding some bit shifting in the kernel is preferable to
> breaking user interfaces. The effort to fix all the apps is much
> higher. We should be aware that some bit shifting in the kernel
> is really not the most complex part of this picture.
>=20
> I would appreciate if those disliking Matthew's maj/min layout would
> come up with a proposal and tell what they want. Or maybe admit that
> they actually don't care?
>=20
> I'm definitely not religious about how to solve this. But I would
> like to have _a_ solution and I would like this solution not to
> change anything for already well-known devices.
>=20
> Once we have that, we can struggle about implememtation details that
> are easy to change anyways.
>  =20
> Regards,
> --=20
> Kurt Garloff  <garloff@suse.de>                            Cologne, D=
E=20
> SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head=
)
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.3.0
Date: Mon, 11 Oct 2004 14:00:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041011120049.GQ4021@marowsky-bree.de>
References: <1096071849.4466.31.camel@zezette> <1097054573.4163b96d1262c@imp5-q.free.fr> <20041006095009.GD1542@marowsky-bree.de> <1097057920.4163c680eaee0@imp5-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1097057920.4163c680eaee0@imp5-q.free.fr>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2004-10-06T12:18:40, christophe.varoqui@free.fr wrote:

Sorry for the late reply, I was somewhat busy, but I'm going to be
working on multipathing during the next couple of days / weeks again.

> It all depends on the satisfaction of the testers.
>=20
> Let's review the current situation with regards to files touched by
> the package :

>=20
> * /etc/multipathd.conf :
>=20
> optional
> you only need to create one if you use multipath aliases or have hard=
ware not
> known internaly

This is a good point. If we can make it work out of the box, then that'=
s
of course best.

> its synthax is not yet fully stabilized : for example, I may decide t=
o move from
>=20
> multipath {
>   wwid =3D 00000acdefg123456ff
>   alias =3D system
> }
>=20
> to
>=20
> multipath 00000acdefg123456ff {
>   alias =3D system
> }

I'd probably leave it in the first form, as a multipath array might be
identified not only by the wwid but by other means in the future too,
no?

> also expect a few keyword additions to cover the new reinstate featur=
e
> of the kernel driver.

Ok.

> * /etc/hotplug.d/scsi/multipath
>=20
> dead and to be removed from 0.3.0 and up

Ok.

> * /etc/dev.d/block/multipath.dev
>=20
> optional
> this is where we call multipath and kpartx when nodes appear in /sys/=
block
> this one should not change too much, but I expect more feedback from =
testers

I don't think this one will need to be touched by admins on the systems=
,
so it's not really a configuration file...

> * /etc/udev/udev.rules
>=20
> from 0.3.0 and up, we don't touch it anymore

That's very good indeed and actually makes configuration easier! Which
udev version do you require though?

> these copy udev, multipath tools and config files to initrd when
> mkinitrd is launched.

Yes. I'm not yet sure how/if we are going to support booting from
multipath root fs in SLES9, so this doesn't really affect me for the
time being.

I first will need to do a gap analysis and figure out where to go today
;-)

> this certainly needs refining, and I expect distrib packagers to show
> interest in taking them over. Do you ?

We'll certainly need to pull them into our own mkinitrd tools and make
distribution specific adjustments, and of course where applicable give
them back to you.

My main job right now is to extend multipath to work with the
active/passive scenarios, where a special path activation command needs
to be send down before a new path group can be used. Anything else I ca=
n
solve as I go along that one is welcome but optional to me.

Thanks for the explanations, I'll now go and have a real closer look at
the tools and modules...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

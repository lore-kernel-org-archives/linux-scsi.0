From: scameron@beardog.cce.hp.com
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Fri, 2 Sep 2011 10:03:21 -0500
Message-ID: <20110902150321.GU9189@beardog.cce.hp.com>
References: <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com> <1314903038.3067.27.camel@dabdike> <20110901125938.7cb1da85@jbarnes-desktop> <20110901200349.GO9189@beardog.cce.hp.com> <20110901130930.5caec2d4@jbarnes-desktop> <20110901204419.GY8422@beardog.cce.hp.com> <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com> <1314956388.2573.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <1314958133.2573.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:30863 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1IBPD0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 11:03:26 -0400
Content-Disposition: inline
In-Reply-To: <1314958133.2573.13.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Fri, Sep 02, 2011 at 12:08:53PM +0200, Eric Dumazet wrote:
> Le vendredi 02 septembre 2011 =E0 11:39 +0200, Eric Dumazet a =E9crit=
 :
> > Le jeudi 01 septembre 2011 =E0 16:50 -0500, Jon Mason a =E9crit :
> >=20
> > > I believe modifying the MRRS values is what is causing the issues=
=2E
> > > Can you try the attached patch and verify that it also resolves t=
he
> > > issue?
> >=20
> > I tested this patch and can confirm this solves the corruption prob=
lem.
> >=20
> > But my disk is _much_ slower than before
> >=20
> > # hdparm -t /dev/sda1
> >=20
> > Before :
> >=20
> >  Timing buffered disk reads: 254 MB in  3.02 seconds =3D  84.16 MB/=
sec
> >=20
> > After :
> >=20
> >  Timing buffered disk reads: 120 MB in  3.04 seconds =3D  39.42 MB/=
sec
>=20
> Hmm, this speed regression is probably old : the 84MB/s was with the
> standard debian 6.0.2 kernel (2.6.32-5-amd64)
>=20

This regression might be due to these two patches:

	d0be5ec8693944c2e2fc0de70fda9dbc1b93bd7d
	[SCSI] hpsa: do readl after writel in main i/o path to ensure commands=
 don't get lost.

	Apparently we've been doin it rong for a decade, but only lately do we
	run into problems.
and
	fec62c368b9c8b05d5124ca6c3b8336b537f26f3
	[SCSI] hpsa: do not attempt to read from a write-only register

	Most smartarrays tolerate it, but a few new ones don't.
	Without this change some newer Smart Arrays will lock up
	and i/o will grind to a halt.

with the second patch being a correction to the first.

It seems like the readl after the writel should not be needed,
and wasn't needed for a very long time, but there is some very
hard to trigger and not yet well understood problem in which very
occasionally a command would get lost and the driver thinks a=20
command is out, but controller firmware thinks all commands are
completed -- a circumstance which tends to make things grind to
a halt.

Those two patches avoid that problem.

-- steve

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

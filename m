From: Doug Ledford <dledford@redhat.com>
Subject: Re: iowait problems on 2.6, not on 2.4
Date: Sat, 29 May 2004 20:46:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085877991.18642.336.camel@compaq.xsintricity.com>
References: <200405261743.28111.antlarr@tedial.com>
	 <20040526205225.7a0866aa.akpm@osdl.org>
	 <200405281516.41901.antlarr@tedial.com>
	 <20040528154525.6ed5f7b9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:17814 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261358AbUE3AsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 20:48:05 -0400
In-Reply-To: <20040528154525.6ed5f7b9.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Antonio Larrosa =?ISO-8859-1?Q?Jim=E9nez?= <antlarr@tedial.com>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2004-05-28 at 18:45, Andrew Morton wrote:
> Antonio Larrosa Jim=C3=A9nez <antlarr@tedial.com> wrote:
> >
> > On Thursday 27 May 2004 05:52, you wrote:
> > > Antonio Larrosa Jim=C3=A9nez <antlarr@tedial.com> wrote:
> > > > My next test will be to do the "dd tests" on one of the interna=
l hard
> > > > disks and use it for the data instead of the external raid.
> > >
> > > That's a logical next step.  The reduced read bandwith on the rai=
d array
> > > should be fixed up before we can go any further.  I don't recall =
any
> > > reports of qlogic fc-scsi performance regressions though.
> >=20
> > Ok, let's analyze that first.
> >=20
> > The dd tests gave the following results:
>=20
> Let me cc linux-scsi.
>=20
> Guys: poke.  Does anyone know why this:
>=20
>   The machine is a 4 cpu Pentium III (Cascades) system with four SCSI
>   SEAGATE ST336704 hard disks connected to an Adaptec AIC-7899P U160/=
m, and
>   a external RAID connected to a QLA2200/QLA2xxx FC-SCSI Host Bus Ada=
pter.=20
>   The machine has 1Gb RAM.
>=20
> got all slow at reads?

My first guess would be read ahead values.  Try poking around with
those.  When using a hard disk vs. a raid array, it's easier to trigger
firmware read ahead since all reads go to a single physical device and
that in turn compensates for lack of reasonable OS read ahead.  On a
raid array, depending on the vendor, there may be next to no firmware
initiated read ahead and that can drastically reduce read performance o=
n
sequential reads.


> > So yes, I suppose there's a regression on the qlogic fc-scsi module=
=2E

A regression, yes.  In the qlogic-fc driver?  I doubt it.  Performance
tuning is what I think this basically boils down to.

But, I could be wrong.  Give it a try and see what happens.  In the 2.4
kernels I would tell you to tweak /proc/sys/vm/{min,max}-readahead,
don't know if those two knobs still exist in 2.6 and if they have the
same effect.  Andrew?

--=20
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

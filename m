From: Jean Delvare <jdelvare@suse.de>
Subject: RE: megaraid_sas: "FW in FAULT state!!", how to get more debug
 output? [BKO63661]
Date: Fri, 10 Jul 2015 16:05:15 +0200
Message-ID: <1436537115.4540.31.camel@chaos.site>
References: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
	 <CAErSpo5+=33byGqCjFCSfTpfKFtSAHRqYLzGF7yf5d18gEmWsQ@mail.gmail.com>
	 <robbat2-20140712T215640-831385120Z@orbis-terrarum.net>
	 <20150429172832.GB7888@google.com> <20150528122443.GI10210@google.com>
	 <9e8b957da24d7b1f532ed83ffb86ca37@mail.gmail.com>
	 <20150707104426.3d7e8697@endymion.delvare>
	 <a2dbe3edaba57bb78f0c3e22d6068178@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <a2dbe3edaba57bb78f0c3e22d6068178@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Adam Radford <aradford@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, arkadiusz.bubala@open-e.com, Matthew Garrett <matthew.garrett@nebula.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Kashyap,

Le Tuesday 07 July 2015 =C3=A0 14:48 +0530, Kashyap Desai a =C3=A9crit =
:
> > -----Original Message-----
> > From: Jean Delvare [mailto:jdelvare@suse.de]
> > Sent: Tuesday, July 07, 2015 2:14 PM
> > To: Kashyap Desai
> > Cc: Bjorn Helgaas; Robin H. Johnson; Adam Radford; Neela Syam Kolli=
;
> linux-
> > scsi@vger.kernel.org; arkadiusz.bubala@open-e.com; Matthew Garrett;
> Sumit
> > Saxena; Uday Lingala; PDL,MEGARAIDLINUX; linux-pci@vger.kernel.org;
> linux-
> > kernel@vger.kernel.org; Myron Stowe
> > Subject: Re: megaraid_sas: "FW in FAULT state!!", how to get more d=
ebug
> > output? [BKO63661]
> >
> > Hi Kashyap,
> >
> > On Thu, 28 May 2015 19:05:35 +0530, Kashyap Desai wrote:
> > > Bjorn/Robin,
> > >
> > > Apologies for delay. Here is one quick suggestion as we have seen
> > > similar issue (not exactly similar, but high probably to have sam=
e
> > > issue) while controller is configured on VM as pass-through and V=
M
> reboot
> > abruptly.
> > > In that particular issue, driver interact with FW which may  requ=
ire
> > > chip reset to bring controller to operation state.
> > >
> > > Relevant patch was submitted for only Older controller as it was =
only
> > > seen for few MegaRaid controller. Below patch already try to do c=
hip
> > > reset, but only for limited controllers...I have attached one mor=
e
> > > patch which does chip reset from driver load time for
> > > Thunderbolt/Invader/Fury etc. (In your case you have Thunderbolt
> > > controller, so attached patch is required.)
> > >
> > > http://www.spinics.net/lists/linux-scsi/msg67288.html
> > >
> > > Please post the result with attached patch.
> >
> > Good news! Customer tested your patch and said it fixed the problem=
 :-)
> >
> > I am now in the process of backporting the patch to the SLES 11 SP3
> > kernel for further testing. I'll let you know how it goes. Thank yo=
u
> > very much for your assistance.

=46or the record I was able to backport the patch by myself to SLES 11
SP3, it's currently under testing by the customer.

> Thanks for confirmation. Whatever patch I submitted to you, we have a=
dded
> recently (as part of common interface approach to do chip reset at lo=
ad
> time). We will be submitting that patch to mainline soon.

I am about to commit the patch that was successfully tested by the
customer on SLES 12, but I'm a bit confused. The upstream patch you
referred to is:

https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?h=3D=
for-next&id=3D6431f5d7c6025f8b007af06ea090de308f7e6881
[SCSI] megaraid_sas: megaraid_sas driver init fails in kdump kernel

But the patch I used is the one you sent by e-mail on May 28th. It is
completely different!

So what am I supposed to do? Use the patch you sent (and that was teste=
d
by the customer) for SLES 11 SP3 and SLES 12? Or was it just for testin=
g
and the proper way of fixing the problem would be to backport the
upstream commit?

Please advise,
--=20
Jean Delvare
SUSE L3 Support

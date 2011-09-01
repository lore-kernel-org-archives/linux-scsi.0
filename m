From: scameron@beardog.cce.hp.com
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 1 Sep 2011 17:16:48 -0500
Message-ID: <20110901221648.GR9189@beardog.cce.hp.com>
References: <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110901160724.GN9189@beardog.cce.hp.com> <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com> <1314903038.3067.27.camel@dabdike> <20110901125938.7cb1da85@jbarnes-desktop> <20110901200349.GO9189@beardog.cce.hp.com> <20110901130930.5caec2d4@jbarnes-desktop> <20110901204419.GY8422@beardog.cce.hp.com> <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Jon Mason <mason@myri.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Dumazet <eric.dumazet@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 01, 2011 at 04:50:45PM -0500, Jon Mason wrote:
> On Thu, Sep 1, 2011 at 3:44 PM,  <scameron@beardog.cce.hp.com> wrote:
> > On Thu, Sep 01, 2011 at 01:09:30PM -0700, Jesse Barnes wrote:
> >> On Thu, 1 Sep 2011 15:03:49 -0500
> >> scameron@beardog.cce.hp.com wrote:
> >>
> >> > On Thu, Sep 01, 2011 at 12:59:38PM -0700, Jesse Barnes wrote:
> >> > > On Thu, 01 Sep 2011 11:50:38 -0700
> >> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >> > >
> >> > > > On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
> >> > > > > > OK I found the bad commit,I got lucky... I lost some fil=
es but my
> >> > > > > > machine was able to complete the bisection. CC involved =
people
> >> > > > >
> >> > > > > > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: S=
et PCI-E Max Payload Size on fabric
> >> > > > >
> >> > > > > Hi Eric,
> >> > > > >
> >> > > > > I guess it would be useful to see "lspci -vv" output with =
a "good" kernel
> >> > > > > and with that bad patch applied. =A0Most likely we should =
see some difference
> >> > > > > somewhere in the MaxPayload fields in the PCI Express capa=
bility of
> >> > > > > some device.
> >> > > > >
> >> > > > > Either the RAID controller or something else lies, and put=
s a value
> >> > > > > in the DevCap that it can't actually support, or else the =
patch is
> >> > > > > buggy and puts something out of range in a DevCtl somewher=
e.
> >> > > >
> >> > > >
> >> > > > While we investigate, I think the problems produced by the p=
atch (data
> >> > > > corruption) are serious enough to warrant reverting it, plea=
se Jesse.
> >> > >
> >> > > Hm I haven't been paying attention to the compromise thread; h=
ow should
> >> > > I share these changes? =A0Is master.kernel.org down indefinite=
ly? =A0Is
> >> > > there a new server at kernel.org I can use?
> >> >
> >> > I can't answer that question, but I would like a copy of your re=
vert
> >> > patch(es) to test (as a simple patch --reverse of the original c=
ommit on the 3.1-rc4
> >> > tree didn't go in cleanly).
> >>
> >> Attached is the series. =A0Applies on top of my for-linus branch.
> >
> > Thanks. =A0I tried them out vs. 3.1-rc4, and they applied cleanly a=
nd
> > make things work on my BL460g7.
>=20
> I believe modifying the MRRS values is what is causing the issues.
> Can you try the attached patch and verify that it also resolves the
> issue?

Ok, just tried it.

The mrrs_removal patch does also appear to resolve the issue.

Thanks.

-- steve

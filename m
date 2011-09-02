From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Fri, 02 Sep 2011 07:32:58 +0200
Message-ID: <1314941578.14747.3.camel@edumazet-laptop>
References: <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20110901160724.GN9189@beardog.cce.hp.com>
	 <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
	 <1314903038.3067.27.camel@dabdike>
	 <20110901125938.7cb1da85@jbarnes-desktop>
	 <20110901200349.GO9189@beardog.cce.hp.com>
	 <20110901130930.5caec2d4@jbarnes-desktop>
	 <20110901204419.GY8422@beardog.cce.hp.com>
	 <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
	 <20110901221648.GR9189@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51727 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1IBFdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 01:33:11 -0400
In-Reply-To: <20110901221648.GR9189@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Jon Mason <mason@myri.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>

Le jeudi 01 septembre 2011 =C3=A0 17:16 -0500, scameron@beardog.cce.hp.=
com a
=C3=A9crit :
> On Thu, Sep 01, 2011 at 04:50:45PM -0500, Jon Mason wrote:
> > On Thu, Sep 1, 2011 at 3:44 PM,  <scameron@beardog.cce.hp.com> wrot=
e:
> > > On Thu, Sep 01, 2011 at 01:09:30PM -0700, Jesse Barnes wrote:
> > >> On Thu, 1 Sep 2011 15:03:49 -0500
> > >> scameron@beardog.cce.hp.com wrote:
> > >>
> > >> > On Thu, Sep 01, 2011 at 12:59:38PM -0700, Jesse Barnes wrote:
> > >> > > On Thu, 01 Sep 2011 11:50:38 -0700
> > >> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrot=
e:
> > >> > >
> > >> > > > On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
> > >> > > > > > OK I found the bad commit,I got lucky... I lost some f=
iles but my
> > >> > > > > > machine was able to complete the bisection. CC involve=
d people
> > >> > > > >
> > >> > > > > > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI:=
 Set PCI-E Max Payload Size on fabric
> > >> > > > >
> > >> > > > > Hi Eric,
> > >> > > > >
> > >> > > > > I guess it would be useful to see "lspci -vv" output wit=
h a "good" kernel
> > >> > > > > and with that bad patch applied.  Most likely we should =
see some difference
> > >> > > > > somewhere in the MaxPayload fields in the PCI Express ca=
pability of
> > >> > > > > some device.
> > >> > > > >
> > >> > > > > Either the RAID controller or something else lies, and p=
uts a value
> > >> > > > > in the DevCap that it can't actually support, or else th=
e patch is
> > >> > > > > buggy and puts something out of range in a DevCtl somewh=
ere.
> > >> > > >
> > >> > > >
> > >> > > > While we investigate, I think the problems produced by the=
 patch (data
> > >> > > > corruption) are serious enough to warrant reverting it, pl=
ease Jesse.
> > >> > >
> > >> > > Hm I haven't been paying attention to the compromise thread;=
 how should
> > >> > > I share these changes?  Is master.kernel.org down indefinite=
ly?  Is
> > >> > > there a new server at kernel.org I can use?
> > >> >
> > >> > I can't answer that question, but I would like a copy of your =
revert
> > >> > patch(es) to test (as a simple patch --reverse of the original=
 commit on the 3.1-rc4
> > >> > tree didn't go in cleanly).
> > >>
> > >> Attached is the series.  Applies on top of my for-linus branch.
> > >
> > > Thanks.  I tried them out vs. 3.1-rc4, and they applied cleanly a=
nd
> > > make things work on my BL460g7.
> >=20
> > I believe modifying the MRRS values is what is causing the issues.
> > Can you try the attached patch and verify that it also resolves the
> > issue?
>=20
> Ok, just tried it.
>=20
> The mrrs_removal patch does also appear to resolve the issue.
>=20

I cannot say that right now, as it appears the last "bad" kernel
destroyed my distro enough that I cannot test this patch without a full
reinstall. (/root partition is busted, even after several fsck -f -y)

[   42.501569] EXT3-fs error (device cciss/c0d0p1): ext3_free_inode: bi=
t already cleared for inode 424649
[   42.501721] Aborting journal on device cciss/c0d0p1.
[   42.516101] Remounting filesystem read-only
[   42.529563] EXT3-fs error (device cciss/c0d0p1) in ext3_delete_inode=
: IO failure


 I'll have to do this reinstall when I am at the office, in a couple of
hours.


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

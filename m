From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 27 Jul 2007 17:29:11 -0400
Message-ID: <200707271729.11422.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <1185455711.3501.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:60334
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761911AbXG0V3O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 17:29:14 -0400
In-Reply-To: <1185455711.3501.46.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Thursday 26 July 2007 9:15:11 am James Bottomley wrote:
> On Wed, 2007-07-25 at 23:28 -0400, Rob Landley wrote:
> > 1) Is the summary of the scsi subsystem in appendix A of your 2002 =
OLS
> > paper still more or less current?  (The scsi mid-layer document nev=
er
> > seems to talk about the _upper_ layer it interfaces with.  Which is
> > presumably the block layer...)
>
> No, the block layer is the service layer.  Upper layer is the SCSI
> driver layer (top level drivers like sd, sr and st).

Now that I've noticed that http://sg.torque.net/scsi/SCSI-2.4-HOWTO.htm=
l and=20
http://sg.torque.net/scsi/SCSI-Generic-HOWTO.html are separate document=
s, I=20
see where that's documented. :)

So upper layer drivers provide /dev nodes, lower level talks to SCSI ha=
rdware,=20
and the mid-layer understands scsi commands ala http://www.t10.org/scsi=
-3.htm =20

Where _does_ the block layer work into this?

> > 2) Documentation/scsi/scsi_fc_transport.txt is talking about Fiber
> > Channel, right? =C2=A0(It never expands the fc, not even in the tit=
le...)
>
> Yes.

Already sent a separate email about that one.  (Although I now see that=
=20
t10.org inclues some fiber channel standards, and what the relationship=
=20
between it and t11 is I have no idea.)

> > 3) After reading Documentation/scsi/scsi-generic.txt I'm curious wh=
at the
> > relationships between a given sg device and sd device.  Each sd has=
 a
> > corresponding sg?  (I can't find where it explicitly says this, but=
 it's
> > a char device, not a block device, so...)  They're always in the sa=
me
> > order? Does _each_ sd have an sg?  Can I call the SG_IO ioctl on an=
 sd?=20
> > Is there an obvious document on this I've missed?
>
> This is one of those evolutionary problems in Linux.  Originally sg
> existed simply to provide the SG_IO ioctl to SCSI devices.  Then,
> because it was extremely useful, we made it a core feature of the blo=
ck
> layer (in block/scsi_ioctl.c) which extended it as a general packet
> command feature to devices beyond SCSI.

But it's still a char device, so you presumably can't mount /dev/sg1 to=
 read=20
the CD in your burner.  You need to burn the CD and mount the CD throug=
h=20
separate devices.

To someone like me from the IDE world, the numbering on scsi is weird. =
 It=20
won't leave holes like the ATA driver did to avoid renumbering categori=
es of=20
devices that can't be moved without a screwdriver.  (I realize there _a=
re_=20
truly dynamic devices, but the hard drive in my laptop is not one of th=
em and=20
it's an artifact of the scsi layer that it's considered so.)

So if you don't attach an sg to every sd, then either there are holes, =
or they=20
don't line up, in which case how do you tell which sg goes with a given=
 sd?

> The logical thing then became to=20
> attach sg as an upper driver *only* to devices which otherwise wouldn=
't
> have one ... however, the sg maintainer has never accepted this.

Do you mean only to devices that otherwise wouldn't have an upper drive=
r?  (So=20
there would be an sg for devices that have _no_ sd?  This implies that =
the=20
answer to my earlier question about whether the SG_IO ioctl can be used=
 on sd=20
block devices is "yes"?  (In which case the bit where the sg document t=
alked=20
about the nonblocking write to sg thing being useful for queueing comma=
nds=20
comes back up, is there currently a way to do that through the sd ioctl=
?)

It sounds like your preferred solution would be to have either an sg _o=
r_ an=20
sd for each scsi device, so there would be no duplicates but only "no h=
oles"=20
if you look at _both_ groups and interlace them.  And the sg maintainer=
 went=20
with "have both for every device"?

> Various distros have tried it at various times, though, so currently
> it's safe to say that if sg is loaded, every SCSI device has an sg no=
de,
> but it's not safe to assume that universally.

Ok, so currently, on distros using recent 2.6 kernels, there's an sg=20
corresponding to every sd, using the same number.  Right.

Did the various distros patch the kernel, or did they do udev rules to =
filter=20
out the sg they didn't want?  Any idea which distros those were, and wh=
ether=20
or not they're still relevant?

> We can't even agree on=20
> unifying the SG_IO paths, so we have two separate codings, one in sg.=
c
> and one in block/scsi_ioctl.c.

What would unifying the SG_IO paths mean?  Would it have any impact on=20
userspace, or is it just an implementation detail inside the kernel?

> >  seems that a read-only cd will be an sd, but you talk to a burner
> > through an sg...)
>
> No, they're both sr.

What was that again?  (Googles...)  Oh yeah, the "upper layer" drivers =
from=20
the scsi-2.4-howto.  I thought scsi-tape and scsi-cdrom were obsolete, =
but I=20
guess not.=20

Back in the IDE world, my hard drive was /dev/hda and my CD burner=20
was /dev/hdc.  When /dev/hdc gained the ability to be used directly as =
a cd=20
burner, I just assumed you could do it to sd as well.  My initial menta=
l=20
model was "sg gives you a char device to pass through scsi commands for=
 a=20
random scsi device, and sd gives you a way to look at it as a block dev=
ice",=20
which doesn't explain sr and st but as I said I thought they were obsol=
ete...

> Users have great difficulty understanding how to=20
> map sg to sr (or sd), so we're trying to encourage them only to use t=
he
> actual device node, so /dev/sdx or /dev/srn.

Actually, these days everybody I know uses /dev/cdrom, expects it to be=
 a=20
symlink, and doesn't care where it points.  Last time I used a system t=
hat=20
had more than one of the suckers I believe it had /dev/cdrom0, /dev/cdr=
om1,=20
etc.

I note that in the ubuntu system on my laptop, /dev/sr0 is a symlink=20
to /dev/scd0, which is an actual device node with a major and minor tha=
t=20
presumably means something to the system, but not to me personally.  (N=
ot=20
that I consider Ubuntu 7.04 much of a model on how to arrange devices=20
considering it put a UUID label on every _partition_ on my hard drive a=
nd=20
mounts them by label in /etc/fstab rather than that having udev do its =
job=20
and make stable symlinks.)

But it seems that users aren't the only ones who have trouble with this=
,=20
distro maintainers do too.

Question: how much of the difference between /dev/sd* and /dev/sr* do u=
sers=20
actually have to care about these days?  (And is st still relevant, or =
does=20
sg cover that?)

> > 4) Is http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO/ still current, =
given
> > it was last updated in 2002?
>
> Probably not ... the transport classes all come after that.

Unfortunately, Documentation/scsi/scsi-generic.txt (which seems a logic=
al=20
starting point) is essentially nothing more than a link to that documen=
t and=20
a note about using scsi drivers as modules.

It also still seems to be the best introduction to sd vs sr vs sg.  It =
would=20
be nice if there was some kind of quick reference card listing the=20
concepts...

Similarly, Documentation/scsi/scsi.txt is a link to the SCSI-2.4-HOWTO =
and a=20
note about using scsi drivers as modules.  (And the first time I read t=
hose=20
two, I didn't notice that the SCSI-2.4-HOWTO and the SCSI-Generic-HOWTO=
 were=20
two separate documents...)

> > 5) I notice there's a "man 4 sd", from 1992.  Still relevant?
>
> Yes .. but only as far as it goes, which isn't very far.

I noticed.  It'd be nice if it at least explained the differences betwe=
en sd,=20
sr, st, and sg.  I'll ping the man-pages maintainer about it...

> Taking this to linux-scsi might be the best course ...

And now that I've confirmed it's ok with you, I've cc'd this thread the=
re.

> Doug Gilbert=20
> tends to be the best maintainer of our docs, although he's the sg
> author, which is why the docs tend to emphasize it as the preferred
> option ...

I'm still trying to figure what the other options _are_.

> James

Rob
--=20
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Mon, 19 Jan 2004 22:36:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFE401C565.89112EED-ONC1256E20.0054728B-C1256E20.0077264F@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:14578 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S263903AbUASVhl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:37:41 -0500
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Christoph Hellwig <hch@infradead.org>, Arjan Van de Ven <arjanv@redhat.com>, Jens Axboe <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi mailing list <linux-scsi@vger.kernel.org>, ihno@suse.de

Doug Ledford wrote:
> On Tue, 2004-01-13 at 15:55, Marcelo Tosatti wrote:
> > What is this mlqueue patchset fixing ? To tell you the truth, I'm n=
ot
> > aware of the SCSI stack problems.
>
> OK.  This is a different problem entirely.  The current 2.4 scsi stac=
k
> has a problem handling QUEUE_FULL and BUSY status commands.  Amongst
> other things, it retries the command immediately and will basically h=
ang
> the SCSI bus if the low level driver doesn't intervene.  Most well
> written drivers have workaround code in them (including my aic7xxx_ol=
d
> driver). The mlqueue patch changes it so that the mid layer implement=
s
> delayed retries of QUEUE_FULL and BUSY commands.  It also makes the m=
id
> layer recognize the situation where you get a QUEUE_FULL or BUSY comm=
and
> status with 0 outstanding commands.  This used to cause the mid layer=
 to
> hang on that device because there would be no command completion to k=
ick
> the queue back into gear.

http://marc.theaimsgroup.com/?t=3D106001205900001&r=3D1&w=3D2
We also stumbled about this problem last year. Our patch wasn't
as sophisticated as Doug's new patch. However, it worked,
and some fix is certainly needed.

> Now, with the mlqueue patch, it detects 0
> outstanding commands and sets a 1/5 second timer that restarts comman=
d
> flow after the delay.  This solved several IBM bugs in one go.

This includes a panic
http://marc.theaimsgroup.com/?t=3D105167914900002&r=3D1&w=3D2
, hung SCSI hosts due to an error handling deadlock related to
commands snoozing in the mlqueue (can't find a link),
as well as the problem mentioned above.

> Again,
> this is a problem that older drivers with workaround code didn't need=
,
> but newer drivers such as the IBM zfcp (is that right?) and the open
> source Emulex driver don't have the standard workarounds for the bug =
and
> were getting hit by it.

Doug, you are right with regard to zfcp. But given the above listing
of is issues, I don't see how we could perfectly work around :-)

> By fixing the problem properly, a lot of
> drivers could actually remove their workaround code and use the mid
> layer code.  The first version of this patch just solves the hang and
> immediate retry problem.  Ongoing work will fix the patch to do more
> things correctly, such as replaying commands in their original order,
> stuff like that.

Sounds good.


Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Doug Ledford <dledford@redhat.com> on 17/01/2004 14:10:00

To:    Marcelo Tosatti <marcelo.tosatti@cyclades.com>
cc:    Christoph Hellwig <hch@infradead.org>, Arjan Van de Ven
       <arjanv@redhat.com>, Martin Peschke3/Germany/IBM@IBMDE, Jens Axb=
oe
       <axboe@suse.de>, Peter Yao <peter@exavio.com.cn>,
       linux-kernel@vger.kernel.org, linux-scsi mailing list
       <linux-scsi@vger.kernel.org>, ihno@suse.de
Subject:    Re: smp dead lock of io_request_lock/queue_lock patch


On Tue, 2004-01-13 at 15:55, Marcelo Tosatti wrote:
> On Mon, 12 Jan 2004, Doug Ledford wrote:
>
> > On Mon, 2004-01-12 at 14:48, Christoph Hellwig wrote:
> > > On Mon, Jan 12, 2004 at 04:12:30PM +0100, Arjan van de Ven wrote:
> > > > > as the patch discussed in this thread, i.e. pure (partially
> > > > > vintage) bugfixes.
> > > >
> > > > Both SuSE and Red Hat submit bugfixes they put in the respectiv=
e
trees to
> > > > marcelo already. There will not be many "pure bugfixes" that yo=
u
can find in
> > > > vendor trees but not in marcelo's tree.
> > >
> > > I haven't seen SCSI patches sumission for 2.4 from the vendors on
linux-scsi
> > > for ages.  In fact I asked Jens & Doug two times whether they cou=
ld
sort out
> > > the distro patches for the 2.4 stack and post them, but it seems
they're busy
> > > enough with real work so this never happened.
> >
> > More or less.  But part of it also is that a lot of the patches I'v=
e
> > written are on top of other patches that people don't want (aka, th=
e
> > iorl patch).  I've got a mlqueue patch that actually *really* shoul=
d go
> > into mainline because it solves a slew of various problems in one g=
o,
> > but the current version of the patch depends on some semantic chang=
es
> > made by the iorl patch.  So, sorting things out can sometimes be
> > difficult.  But, I've been told to go ahead and do what I can as fa=
r as
> > getting the stuff out, so I'm taking some time to try and get a bk =
tree
> > out there so people can see what I'm talking about.  Once I've got =
the
> > full tree out there, then it might be possible to start picking and
> > choosing which things to port against mainline so that they don't
depend
> > on patches like the iorl patch.
>
> Hi,
>
> Merging "straight" _bugfixes_

OK, I've got some new bk trees established on linux-scsi.bkbits.net.
There is a 2.4-for-marcelo, which is where I will stick stuff I think i=
s
ready to go to you.  There is a 2.4-drivers.  Then there is a
2.4-everything.  The everything tree will be a place to put any and all
patches that aren't just experimental patches.  So, just about any Red
Hat SCSI patch is fair game.  Same for the mods SuSE has made.  Pushing
changes from here to 2.4-for-marcelo on a case by case basis is more or
less my plan.  Right now, these trees are all just perfect clones of
Marcelo's tree.  As I make changes and commit things, I'll update the
lists with the new stuff.

> (I think all we agree that merging
> performance enhancements at this point in 2.4 is not interesting)

Well, I can actually make a fairly impressive argument for the iorl
patch if you ask me.  It's your decision if you want it, but here's my
take on the issue:

1)  Red Hat has shipped the iorl patch in our 2.4.9 Advanced Server 2.1
release, our 2.4.18 based Advanced Server 2.1 for IPF release, and our
current 2.4.21 based RHEL 3 release.  So, it's getting *lots* of testin=
g
outside the community.  Including things like all the specweb
benchmarks, Oracle TPC benchmarks, and all of our customers are using
this patch.  That's a *lot* of real world, beat it to death testing.

2)  As I recall, SuSE has shipped either their own iorl type patch, or
they used one of our versions of the patch, don't really know which.
But, I know they've got the same basic functionality.  Between 1 and 2,
that greatly increases the field testing of the iorl patch and greatly
reduces the breadth of testing of the regular kernel scsi stack.

3)  OK, you can call it a performance patch if you want, but that
doesn't really do it justice.  So, here's a little history.  I used the
lockmeter patch when I was writing the iorl patch to get a clue just ho=
w
much difference it made.  Obviously, on single disk systems it makes
very little difference (but it does make some difference because the
host controller and scsi_request_fn use different locks even on a singl=
e
device and that does help some).  But, on a test machine with 4 CPUs an=
d
something like 14 disks, without the patch a disk benchmark was using
100% of CPU and hitting something like 98% contention on the
io_request_lock.  On the same system with the patch, benchmark CPU usag=
e
dropped to something like 12% and because we weren't spinning any more
scsi_request_fn and make_request dropped off the profile radar entirely
and contention was basically down to low single digits.  Consider my
home server has 7 disks in a raid5 array, it certainly makes a
difference to me ;-)

4)  The last issue.  2.6 already has individual host locks for drivers.
The iorl patch for 2.4 adds the same thing.  So, adding the iorl patch
to 2.4 makes it easier to have drivers be the same between 2.4 and 2.6.
Right now it takes some fairly convoluted #ifdef statements to get the
locking right in a driver that supports both 2.4 and 2.6.  Adding the
iorl patch allows driver authors to basically state that they don't
support anything prior to whatever version of 2.4 it goes into and
remove a bunch of #ifdef crap.

>  which,
> as you said, get reviewed by Jens/James/others is OK.

That's the reason for the bk trees.  Anyone can check them out that way=
=2E

> What is this mlqueue patchset fixing ? To tell you the truth, I'm not
> aware of the SCSI stack problems.

OK.  This is a different problem entirely.  The current 2.4 scsi stack
has a problem handling QUEUE_FULL and BUSY status commands.  Amongst
other things, it retries the command immediately and will basically han=
g
the SCSI bus if the low level driver doesn't intervene.  Most well
written drivers have workaround code in them (including my aic7xxx_old
driver).  The mlqueue patch changes it so that the mid layer implements
delayed retries of QUEUE_FULL and BUSY commands.  It also makes the mid
layer recognize the situation where you get a QUEUE_FULL or BUSY comman=
d
status with 0 outstanding commands.  This used to cause the mid layer t=
o
hang on that device because there would be no command completion to kic=
k
the queue back into gear.  Now, with the mlqueue patch, it detects 0
outstanding commands and sets a 1/5 second timer that restarts command
flow after the delay.  This solved several IBM bugs in one go.  Again,
this is a problem that older drivers with workaround code didn't need,
but newer drivers such as the IBM zfcp (is that right?) and the open
source Emulex driver don't have the standard workarounds for the bug an=
d
were getting hit by it.  By fixing the problem properly, a lot of
drivers could actually remove their workaround code and use the mid
layer code.  The first version of this patch just solves the hang and
immediate retry problem.  Ongoing work will fix the patch to do more
things correctly, such as replaying commands in their original order,
stuff like that.

--
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606






-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

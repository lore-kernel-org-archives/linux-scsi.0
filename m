From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 13:24:05 -0700
Message-ID: <20070731132405.05b9cf06.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<46AE12B6.6090408@garzik.org>
	<46AED656.8070407@gmail.com>
	<1185891382.2750.8.camel@laptopd505.fenrus.org>
	<46AF4B05.4010700@gmail.com>
	<20070731091841.857d22bb.kristen.c.accardi@intel.com>
	<46AF75FA.5080502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61049 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764928AbXGaU1C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 16:27:02 -0400
In-Reply-To: <46AF75FA.5080502@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk

On Wed, 01 Aug 2007 02:48:42 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Hello, Kristen.
> 
> Kristen Carlson Accardi wrote:
> > On Tue, 31 Jul 2007 23:45:25 +0900
> > Tejun Heo <htejun@gmail.com> wrote:
> > 
> >> Anyways, I don't really think this attribute belongs to SCSI sysfs
> >> hierarchy.  There currently isn't any alternative but sysfs is part of
> >> userland visible interface and putting something into SCSI sysfs
> >> hierarchy just because libata doesn't have one doesn't look like a good
> >> idea.
> >>
> >> sysfs isn't far from being detached from kobject and driver model.  I
> >> think it would be best to wait a bit and build proper libata sysfs
> >> hierarchy which won't have to be changed later when libata departs from
> >> SCSI.  Well, it isn't really a good way but IMHO it's better than
> >> sticking ATA power saving node into SCSI sysfs hierarchy.
> > 
> > "Wait a bit" could be a very long time.  Who is working on building this
> > new libata sysfs support now?
> 
> I happen to be working on sysfs these days and guess why I started
> working on sysfs. :-)
> 
> Disassociating sysfs from driver model is probably one or two patchsets
> away.  It could have happened earlier but I wanted to pace things a bit
> so that the changes receive some testing through release cycles.  Check
> how many sysfs related changes went through .23-rc1 merge window and
> expect about the same influx during the next cycle; with some luck, it
> can be complete before .24-rc1 window.

So at current rate of development and kernel release schedule, the best
possible scenario is still 6 months away - whereas this patchset is already 
tested and ready for merging now.

> 
> > If the answer is "no one", which I think it 
> > may be, do you want to hold up a feature that actually helps many people
> > for possibly 6 months or more just because we have to go through scsi
> > right now for our sysfs interface?
> 
> I don't necessarily want to but delaying it might be the right thing to
> do.  Anyways, if we're going to do an interim solution, I don't think
> mainline SCSI sysfs hierarchy is the right place.  Do it with module
> parameter which carries large "to be deprecated sign" or maintain out of
> tree patches.

Out of tree patches don't work.  Nobody tests them.  A module parameter
will not work - we need to be able to expose the sysfs interface so that
users may chose to turn the feature off and on at will - mainly according
to their usage.  For example, at boot time - you want ALPM off to maximize
performance.  Lets say when you are plugged into the wall socket, you leave
it off, but then when you go on battery power you would want to enable it.


> 
> > on top of that, the last mail I 
> > got from James on this subject indicated that if we kept our granularity
> > large with the power savings levels, SCSI can actually take advantage of
> > this as well.  Sure, we may have to tweak things around later, but isn't
> > this what we do routinely?  Holding up valuable features from the kernel 
> > because things aren't perfect yet seems really broken.
> >
> > As far as your complaints about broken hardware go, keep in mind that
> > the patch set does provide a method of adding these disks to a blacklist,
> > so I don't see that as a problem.  And, the default for this feature is
> > "off", and user space would have to explicitly enable it.
> 
> This is gonna be a bit long.  Please be patient.
> 
> Due to the generosity of the ATA committee, we have, by default, at
> least two ways to achieve link PS - HIPS and DIPS.  I dunno why but
> someone thought we needed two.  And then, ahci people thought automatic

They thought we needed two because sometimes the device knows when it
will be idle faster than the host can. this is why ALPM can determine
idleness faster than any software algorithm on the host cpu can.  You
can use ALPM without having HIPM.  You can also use it without having 
DIPM.

> HIPS would be nice, which I fully agree, and added ALPM.  Unfortunately,
> they mandated ALPM to kick in the moment command engine becomes idle, so
> most current implementations suffer unnecessary performance hit when
> ALPM is active.

"unnecessary" is subjective and at the moment, untrue.  You 
have to make performance/power tradeoffs with anything, whether it's 
CPU or your AHCI controller.  It's the current cost of getting out of these 
sleep states even if you aren't using ALPM but just doing HIPM or DIPM 
manually.  But, this is why it's so critical to allow the user to 
control when ALPM is enabled dynamically - which this patchset does.
The medium power setting is provided for users who wish to not go to
SLUMBER and get the higher latency cost but still have some power savings.

> 
> We have this crazy number of combinations.  HIPS, DIPS,
> not-so-hot-looking ALPM and probably some number of broken devices which
> may be happy with some method but not with others.  Some might be happy
> with PARTIAL but vomit on SLUMBER.  I might be being too pessimistic but
> my last two years in IDE/ATA land taught me to be pessimistic about
> hardware quality.  Heck, I bet you some of non-intel ahci
> implementations which claim to support ALPM will crap themselves when
> actually told to do so.
> 
> If we're gonna do this like NCQ and gonna put knowledge about all the
> combinations into the driver.  The suggested interface is good enough.
> Heck, we probably don't even need three levels.  On and off should be
> enough if things are done right as link PS doesn't have to incur
> noticeable performance degradation.  But to do that, we'll need to test
> a lot of combinations and it's gonna be much harder than NCQ (some ahci
> implementations don't seem to actually enter PS mode when instructed to
> do so via SControl but turning off the controller saves a lot of power.
>  Maybe ALPM works better on such cases) and the blacklist will probably
> be longer.

I understand you are being cautious based on your prior experience, but
again we still have no data to show that we are going to have a lot of
problems.  Perhaps we should proceed optimistically and deal with problems
when they actually occur rather than block something on a bet.

> 
> The alternate way is to export flexible interface to userland and let
> userland decide and if we're gonna do that.  SCSI sysfs just isn't the
> place.

How about a patch? I'd love to have a flexible interface to userland,
it was my goal to provide this with the sysfs files.  The requirement
is that the users be able to turn ALPM off and on dynamically, and to
be able to chose the power savings level you want - i.e. SLUMBER vs.
PARTIAL - perferrably not using those terms since users really shouldn't
need to know AHCI terminology just to chose a power management level.
 

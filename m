From: Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 01 Aug 2007 02:48:42 +0900
Message-ID: <46AF75FA.5080502@gmail.com>
References: <20070705194909.337398431@intel.com>	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>	<46AE12B6.6090408@garzik.org>	<46AED656.8070407@gmail.com>	<1185891382.2750.8.camel@laptopd505.fenrus.org>	<46AF4B05.4010700@gmail.com> <20070731091841.857d22bb.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070731091841.857d22bb.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Hello, Kristen.

Kristen Carlson Accardi wrote:
> On Tue, 31 Jul 2007 23:45:25 +0900
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Anyways, I don't really think this attribute belongs to SCSI sysfs
>> hierarchy.  There currently isn't any alternative but sysfs is part of
>> userland visible interface and putting something into SCSI sysfs
>> hierarchy just because libata doesn't have one doesn't look like a good
>> idea.
>>
>> sysfs isn't far from being detached from kobject and driver model.  I
>> think it would be best to wait a bit and build proper libata sysfs
>> hierarchy which won't have to be changed later when libata departs from
>> SCSI.  Well, it isn't really a good way but IMHO it's better than
>> sticking ATA power saving node into SCSI sysfs hierarchy.
> 
> "Wait a bit" could be a very long time.  Who is working on building this
> new libata sysfs support now?

I happen to be working on sysfs these days and guess why I started
working on sysfs. :-)

Disassociating sysfs from driver model is probably one or two patchsets
away.  It could have happened earlier but I wanted to pace things a bit
so that the changes receive some testing through release cycles.  Check
how many sysfs related changes went through .23-rc1 merge window and
expect about the same influx during the next cycle; with some luck, it
can be complete before .24-rc1 window.

> If the answer is "no one", which I think it 
> may be, do you want to hold up a feature that actually helps many people
> for possibly 6 months or more just because we have to go through scsi
> right now for our sysfs interface?

I don't necessarily want to but delaying it might be the right thing to
do.  Anyways, if we're going to do an interim solution, I don't think
mainline SCSI sysfs hierarchy is the right place.  Do it with module
parameter which carries large "to be deprecated sign" or maintain out of
tree patches.

> on top of that, the last mail I 
> got from James on this subject indicated that if we kept our granularity
> large with the power savings levels, SCSI can actually take advantage of
> this as well.  Sure, we may have to tweak things around later, but isn't
> this what we do routinely?  Holding up valuable features from the kernel 
> because things aren't perfect yet seems really broken.
>
> As far as your complaints about broken hardware go, keep in mind that
> the patch set does provide a method of adding these disks to a blacklist,
> so I don't see that as a problem.  And, the default for this feature is
> "off", and user space would have to explicitly enable it.

This is gonna be a bit long.  Please be patient.

Due to the generosity of the ATA committee, we have, by default, at
least two ways to achieve link PS - HIPS and DIPS.  I dunno why but
someone thought we needed two.  And then, ahci people thought automatic
HIPS would be nice, which I fully agree, and added ALPM.  Unfortunately,
they mandated ALPM to kick in the moment command engine becomes idle, so
most current implementations suffer unnecessary performance hit when
ALPM is active.

We have this crazy number of combinations.  HIPS, DIPS,
not-so-hot-looking ALPM and probably some number of broken devices which
may be happy with some method but not with others.  Some might be happy
with PARTIAL but vomit on SLUMBER.  I might be being too pessimistic but
my last two years in IDE/ATA land taught me to be pessimistic about
hardware quality.  Heck, I bet you some of non-intel ahci
implementations which claim to support ALPM will crap themselves when
actually told to do so.

If we're gonna do this like NCQ and gonna put knowledge about all the
combinations into the driver.  The suggested interface is good enough.
Heck, we probably don't even need three levels.  On and off should be
enough if things are done right as link PS doesn't have to incur
noticeable performance degradation.  But to do that, we'll need to test
a lot of combinations and it's gonna be much harder than NCQ (some ahci
implementations don't seem to actually enter PS mode when instructed to
do so via SControl but turning off the controller saves a lot of power.
 Maybe ALPM works better on such cases) and the blacklist will probably
be longer.

The alternate way is to export flexible interface to userland and let
userland decide and if we're gonna do that.  SCSI sysfs just isn't the
place.

Thanks.

-- 
tejun

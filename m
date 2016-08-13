From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi
 disks?
Date: Sat, 13 Aug 2016 10:43:32 -0700
Message-ID: <1471110212.2397.39.camel@HansenPartnership.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
	 <1471047451.2407.95.camel@HansenPartnership.com>
	 <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
	 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
	 <1471101800.2397.9.camel@HansenPartnership.com>
	 <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-08-13 at 09:29 -0700, Dan Williams wrote:
> On Sat, Aug 13, 2016 at 8:23 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > It does?  The race is the fact that the parent can be removed 
> > before the child meaning if the parent name is re-registered before 
> > the child dies we get a duplicate name in bdi space.
> 
> No, the race is that the *name* of the parent isn't released until 
> the child is both unregistered and put.  The device core is already
> ensuring that the parent is not released until all descendants have
> been removed.

We're both saying the same thing: the problem is that, with
df08c32ce3be the bdi name lifetime is tied to the lifetime of the
gendisk.  However, the parent of the gendisk currently is only tied to
the visibility lifetime of the gendisk, not the final put lifetime, so
it doesn't see this.

> > 
> > > So I tried the attached and it makes the libnvdimm unit tests 
> > > start crashing.
> > 
> > Well, the attached is clearly buggy, isn't it?  You're trying to do 
> > a get on the parent before the parent is actually set.
> 
> Ah, yes, thank you.  Fixed up v2 attached that passes my tests.
> 
> > Why don't you just try the incremental patch I sent instead of 
> > trying to rework it?
> 
> I reworked it because it is the bdi that holds this extra dependency
> on the disk's parent, not the disk itself.

Philosophically I don't like this approach.  The dependency goes 

bdi->gendisk->parent

Making the bdi manage the parent lifetime is an unusual pattern. 
 Making the parent stay around until the last reference to gendisk is
put is the usual one.

> > >   A couple crash logs attached.  Not yet sure what assumption
> > > is getting violated, but how about that conversion of scsi to use
> > > dynamic devt? ;-)
> > 
> > It's completely orthogonal.  The problem is in hierarchy lifetimes:
> > switching from static to dynamic allocation won't change that at 
> > all.  You don't see this problem in nvme because the parent control
> > device's lifetime belongs to the controller not the disk.  In SCSI 
> > the parent is our representation of the SCSI device whose lifetime 
> > is governed at the SCSI level and effectively represents the disk.
> > 
> 
> No, it's only the name.  We could achieve the same by teaching the
> block core to manage the "sd_index_ida" instead of the sd driver
> itself, but the v2-patch attached works and does not introduce that
> layering violation.

Um, so this patch doesn't fix the problem. It merely makes the lifetime
rules correct so the problem can then be fixed at the scsi level.

James



From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Wed, 31 Dec 2008 11:25:15 -0800
Message-ID: <20081231112515.2d790d1c.akpm@linux-foundation.org>
References: <4947BFAA.4030208@panasas.com>
	<4947CA5C.50104@panasas.com>
	<20081229121423.efde9d06.akpm@linux-foundation.org>
	<495B8D90.1090004@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <495B8D90.1090004@panasas.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 31 Dec 2008 17:19:44 +0200 Boaz Harrosh <bharrosh@panasas.com> wrote:

> Andrew Morton wrote:
> > On Tue, 16 Dec 2008 17:33:48 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >> We need a mechanism to prepare the file system (mkfs).
> >> I chose to implement that by means of a couple of
> >> mount-options. Because there is no user-mode API for committing
> >> OSD commands. And also, all this stuff is highly internal to
> >> the file system itself.
> >>
> >> - Added two mount options mkfs=0/1,format=capacity_in_meg, so mkfs/format
> >>   can be executed by kernel code just before mount. An mkexofs utility
> >>   can now be implemented by means of a script that mounts and unmount the
> >>   file system with proper options.
> > 
> > Doing mkfs in-kernel is unusual.  I don't think the above description
> > sufficiently helps the uninitiated understand why mkfs cannot be done
> > in userspace as usual.  Please flesh it out a bit.
> 
> There are a few main reasons.
> - There is no user-mode API for initiating OSD commands. Such a subsystem
>   would be hundredfold bigger then the mkfs code submitted. I think it would be
>   hard and stupid to maintain a complex user-mode API just for creating
>   a couple of objects and writing a couple of on disk structures.
> - I intend to refactor the code further to make use of more super.c services,
>   so to make this addition even smaller. Also future direction of raid over
>   multiple objects will make even more kernel infrastructure needed which
>   will need even more user-mode code duplication.
> - I anticipate problems that are not yet addressed in this body of work
>   but will be in the future, mainly that a single OSD-target (lun) can
>   be shared by lots of FSs, and a single FS can span many OSD-targets.
>   Some central management is much easier to do in Kernel.

OK.  Please add the above info to the changelog for that patch.

> > 
> > What are the dependencies for this filesystem code?  I assume that it
> > depends on various block- and scsi-level patches?  Which ones, and
> > what is their status, and is this code even compileable without them?
> > 
> 
> This OSD-based file system is dependent on the open-osd initiator library
> code that I've submitted for inclusion for 2.6.29. It has been sitting
> in linux-next for a while now, and has not been receiving any comments
> for the last two updated patchsets I've sent to scsi-misc/lkml. However
> it has not yet been submitted into Jame's scsi-misc git tree, and James
> is the ultimate maintainer that should submit this work. I hope it will
> still be submitted into 2.6.29, as this code is totally self sufficient
> and does not endangers or changes any other Kernel subsystems.
> (All the needed ground work was already submitted to Linus since 2.6.26)
> So why should it not?
> 
> Once the open-osd initiator library is accepted this file system
> could be accepted. I was hoping as a 2.6.30 time frame. (One Kernel
> after the open-osd library)
> 
> > Thanks.
> 
> Thank you dear Andrew for your most valuable input.
> 
> I will constify all the const needed code. will fix the global name space
> litter, will inline the macros and lower case the inlines. Will remove
> the typedefs.
> 
> I will reply to individual patches, I have a couple of questions. But
> all your comments are right and I will take care of them.
> 
> When, if, all is fixed, through which tree/maintainer can exofs be submitted?

I can merge them.  Or you can run a git tree of your own, add it to
linux-next and ask Linus to pull it at the appropriate time.


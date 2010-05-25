From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 14/27] drivers/scsi: Use memdup_user
Date: Tue, 25 May 2010 15:23:23 -0700
Message-ID: <20100525152323.26652def.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.1005221022180.13021@ask.diku.dk>
	<1274538263.4410.38.camel@mulgrave.site>
	<4BF94B89.2050101@panasas.com>
	<1274631752.5894.24.camel@mulgrave.site>
	<4BFBDB83.2090807@panasas.com>
	<1274799513.5300.37.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1274799513.5300.37.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Julia Lawall <julia@diku.dk>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 25 May 2010 09:58:33 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Tue, 2010-05-25 at 17:15 +0300, Boaz Harrosh wrote:
> > On 05/23/2010 07:22 PM, James Bottomley wrote:
> > > On Sun, 2010-05-23 at 18:36 +0300, Boaz Harrosh wrote:
> > >>> This type of transformation has really no value at all.

kerrrrapp!!  There's always value in replacing open-coded straggles
with calls to well-understood, well-documented, well-tested library
code.

>  The code you're
> > >>> proposing to replace is already correct.  I'm fairly ambivalent on
> > >>> patterned APIs anyway but I accept they're useful way to prevent new
> > >>> code getting it wrong. However, it's completely bogus to force
> > >>> replacement of correctly functioning code throughout the kernel

Hello?  This is Linux.  We're continuously filtering through old code,
improving and updating it.  There's nothing which exempts
./drivers/scsi/ from our reasons for doing this.

> (unless
> > >>> you're going to argue that everyone who tries to copy from user into a
> > >>> kmalloc space does a cut and paste from sg?)
> > >>>
> > >>> Of infinitely greater service would be finding any places where the
> > >>> pattern is being incorrectly used.
> > >>>
> > >>
> > >> It looks like it is not done 100% kosher and calling memdup_user should
> > >> be better.
> > >>
> > >> - For 1 memdup_user does a GFP_KERNEL with a comment on how copy_from_user
> > >>   would eventually sleep, so what's the point of GFP_ATOMIC?
> > > 
> > > Well, since you've written a storage driver, I really hope that question
> > > is rhetorical ...
> > > 
> > 
> > Not really I do mean it in this case. It is not a storage-driver code
> > path. Is sg a storage-driver. I was not aware anyone used it for one.
> 
> by storage driver, I mean anything in the writeout path ... this
> includes ULDs, of which sg is one.
> 
> > > The reason for using GFP_ATOMIC from user context in storage drivers is
> > > to avoid writeout deadlock:  you don't want to trigger a swap write
> > > while you potentially occupy the writeout path.  In all older drivers
> > > this had to be GFP_ATOMIC because GFP_NOIO wasn't around.
> > > 
> > 
> > I confess my total swap ignorance. I was under the impression that
> > swap needs a block device. OK you could do a user-mode filesystem
> > over sg, under loop device. Does swap work over loop device=>ext2
> > for example? Or is there a way to directly swap over a filesystem
> > (Not block based)?
> 
> Well, swap can function above block devices or files.
> 
> However, it's not just swap, it's also triggerable via mmap (you do file
> backed mmap of a large area then have a process that joyfully dirties
> lots of it) ... and that's what can make it such a difficult problem.
> Basically you end up with a system with mostly dirty memory that it has
> to clean via writeout (either to swap or by flushing dirty pages).  The
> writeout path that these pages go down cannot ever wait on dirty pages
> being flushed (which is what a sleeping kmalloc does), because that can
> end up as a deadlock.

copy_from_user() can take a fault, take a zillion locks, perform
GFP_HIGHUSER allocations, enter page reclaim, enter filesystems, etc. 
View a pagefault as a syscall with a different calling convention -
it's that high level.

If this driver if correct in potentially taking a pagefault at this
place then the patch is correct and desirable.  Otherwise, well, the
driver already has problem and the patch did nothing to increase them.

And, of course, Julia's "no value" work caused us to identify those
problems.

From: Anders Henke <anders.henke@1und1.de>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in directory)
Date: Wed, 5 Dec 2007 11:14:41 +0100
Message-ID: <20071205101441.GO7697@1und1.de>
References: <20071204165738.48003b8a.akpm@linux-foundation.org> <20071205100403Y.fujita.tomonori@lab.ntt.co.jp> <20071204171155.33ea58c9.akpm@linux-foundation.org> <20071205103054B.fujita.tomonori@lab.ntt.co.jp> <20071204185152.880af2cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxintern.schlund.de ([212.227.126.201]:59327 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXLEKO4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Dec 2007 05:14:56 -0500
Content-Disposition: inline
In-Reply-To: <20071204185152.880af2cf.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, matthew@wil.cx, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 4 Dec 2007 Andrew Morton wrote:
> On Wed, 05 Dec 2007 10:30:54 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Tue, 4 Dec 2007 17:11:55 -0800
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > On Wed, 05 Dec 2007 10:04:03 +0900
> > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > > On Tue, 4 Dec 2007 16:57:38 -0800
> > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > On Thu, 29 Nov 2007 13:31:50 +0100
> > > > > Anders Henke <anders.henke@1und1.de> wrote:
> > > > > 
> > > > > > On November 28 2007, Anders Henke wrote:
> > > > > > > As "everything is reported as being zero" is quite odd an Jan took a
> > > > > > > guess that it might be block-layer or driver-related, I've assumed
> > > > > > > that the driver is responsible for this; just out of the curiousity, 
> > > > > > > I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
> > > > > > > driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
> > > > > > > vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.
> > > > > > > 
> > > > > > > I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
> > > > > > > behaves like this and spews out zeroed blocks when trying to mount
> > > > > > > the rootfs. Maybe this is just some timing issue.
> > > > > > 
> > > > > > I've started the fine-tests and can say so far that dpt_i2o from 
> > > > > > 2.6.22 is still fine. Test is simple:
> > > > > > 
> > > > > > anders@ista:/usr/src/linux-2.6.22/drivers/scsi/dpt$ cp -r dpt/ dpt_i2o.c dpti.h /usr/src/linux-2.6.23.1/drivers/scsi/
> > > > > > 
> > > > > > ... recompile the kernel, reboot: works.
> > > > > > 
> > > > > > 2.6.22 and 2.6.23 differ in terms of the dpt_i2o driver by two different
> > > > > > patch sets:
> > > > > > -one 2 Kb small set of patches from 2.6.22 to 2.6.22-rc1
> > > > > > -one 7 Kb set of patches from 2.6.23-rc2 to 2.6.23-rc3
> > > > > > -one 162 Kb set of patches from 2.6.23-rc9 to 2.6.23-rc10.
> > > > > > 
> > > > > > When applying the 2.6.23-rc1-based driver to "my" 2.6.31.1 kernel,
> > > > > > the "zero blocks"-symptom show up, so it's the "lucky" situation
> > > > > > that the smallest patch actually seams to be the broken one.
> > > > > > 
> > > > > > According to the 2.6.23-rc1 short-form changelog, there is
> > > > > > one major edit on the dpt_i2o driver:
> > > > > > 
> > > > > > FUJITA Tomonori 
> > > > > > 
> > > > > >       [SCSI] dpt_i2o: convert to use the data buffer accessors
> > > > > > 
> > > > > > Stephen Rothwell 
> > > > > >       dpt_i2o depends on virt_to_bus
> > > > > > 
> > > > > > Fujita, would you please take a look at this?
> > > > > 
> > > > > He won't have seen this.  cc's added.
> > > > > 
> > > > > > I think that something's broken in there, leading to the dpt_i2o 
> > > > > > sending out blocks of zeroes right after initialization, at least on
> > > > > > some specific controllers (in this case, Adaptec 2010S on Intel
> > > > > > SE7501WV2S-based boxes).
> > > > > > 
> > > > > > I don't have insight kernel driver development knowledge, so I'm
> > > > > > quite out of help right now. Nevertheless, I'll add the diff
> > > > > > from 2.6.22 to 2.6.23-rc1 in terms of dpt_i2o:
> > > > > > 
> > > > > 
> > > > > Can you please confirm that this revert (against 2.6.24-rc4) fixes the data
> > > > > corruption problems?
> > > > 
> > > > Anders said that my patch is fine and seems that Matthew's hotplug
> > > > conversion patch leads to the problem:
> > > > 
> > > > http://marc.info/?l=linux-kernel&m=119641892129732&w=2
> > > 
> > > Oh.  Jan broke message threading :(
> > > 
> > > So it's been nearly a week and nothing has happened?  Do we revert that
> > > change?
> > 
> > SCSI people really want this conversion...
> > 
> > Matthew, did you have a chance to look at it?
> 
> It seems pretty improbably that a change of that nature could cause data
> corruption.  Anders, are you able to determine whether the revert (against
> current Linus mainline or 2.6.24-rc4) fixes things?  Because it would be
> very strange...
> 
> This is a grave bug.  It's really quite urgent...
> 
> Thanks.
> 
>  drivers/scsi/dpt_i2o.c |  132 ++++++++++++++++++---------------------
>  drivers/scsi/dpti.h    |    9 ++
>  2 files changed, 68 insertions(+), 73 deletions(-)

I've done the following:

-untared a clean 2.6.24-rc4 and compiled it with my 2.6.23.1-settings in order
 to verify that the driver is still broken: checked, the box still won't 
 boot.

-patched the just compiled kernel source with your patch, "make dist-clean"
 (by means of "make-kpkg clean") and recompile: box boots fine.

I've put the captured console logs to
http://w.sysiphus.de/dpt_i2o/bootlog.2624-rc4-pristine
http://w.sysiphus.de/dpt_i2o/bootlog.2624-rc4-patched
... and the kernelconfig (which shouldn't matter) to
http://w.sysiphus.de/dpt_i2o/kernelconfig.2624-rc4


Regards,

Anders
-- 
1&1 Internet AG            Enter any 11-digit prime number to continue.
Brauerstrasse 48           v://49.721.91374.50
D-76135 Karlsruhe          f://49.721.91374.225

Amtsgericht Montabaur HRB 6484
Vorstand: Henning Ahlert, Ralph Dommermuth, Matthias Ehrlich, Andreas Gauger,
Thomas Gottschlich, Matthias Greve, Robert Hoffmann, Norbert Lang, Achim Weiss
Aufsichtsratsvorsitzender: Michael Scheeren

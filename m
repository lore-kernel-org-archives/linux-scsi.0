From: Dave Chinner <david@fromorbit.com>
Subject: Re: Thin provisioning & arrays
Date: Tue, 11 Nov 2008 09:18:07 +1100
Message-ID: <20081110221807.GI2373@disturbed>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1226311189.4367.30.camel@macbook.infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Black_David@emc.com, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, rwheeler@redhat.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 10, 2008 at 10:59:49AM +0100, David Woodhouse wrote:
> On Mon, 2008-11-10 at 19:31 +1100, Dave Chinner wrote:
> > On Sun, Nov 09, 2008 at 10:40:24PM -0500, Black_David@emc.com wrote:
> > > There will be a chunk size value available in a VPD page that can be
> > > used to determine minimum size/alignment.  For openers, I see
> > > essentially
> > > no point in a 512-byte UNMAP, even though it's allowed by the standard -
> > > I suspect most arrays (and many SSDs) will ignore it, and ignoring
> > > it is definitely within the spirit of the proposed T10 standard (hint:
> > > I'm one of the people directly working on that proposal).
> >
> > I think this is the crux of the issue. IMO, it's not much of a standard
> > when the spirit of the standard is to allow everyone to implement
> > different, non-deterministic behaviour....
> 
> I disagree. The discard request is a _hint_ from the upper layers, and
> the storage device can act on that hint as it sees fit. There's nothing
> wrong with that; it doesn't make it "not much of a standard".

If it's not reliable, then it is effectively useless from a
design persepctive. The fact that it is being treated as a hint
means that everyone is going to require "defrag" tools to clean
up the mess when the array runs out of space.

Treating it as a reliable command (i.e. it succeeds or returns
an error) means that we can implement filesystems that can do
unmapping in such a way that when the array reports that it is out
of space we *know* that there is no free space that can be unmapped.
i.e. no need for a "defrag" tool.

The defrag tool approach is a cop-out. It simply does not scale to
environments where you have hundreds of luns spread over hundreds of
machines, and each of them needs to be "defragged" individually to
find all the unmappable space in the array. It gets worse in the
virutalised space where you might have tens of virtual machines
using each lun.

This is why unmap as a hint is a fundamentally broken model from an
overall storage stack persepctive, no matter how appealing it is to
array vendors....

> Storage devices are complex enough that they _already_ exhibit behaviour
> which is fairly much non-deterministic in a number of ways. Especially
> if we're talking about SSDs or large arrays, rather than just disks.
> A standard needs to be clear about what _is_ guaranteed, and what is
> _not_ guaranteed. If it is explicit that the storage device is permitted
> to ignore the discard hint, and some storage devices do so under some
> circumstances, then that is just fine.

Right, it's non-deterministic even within a single device. That
makes it impossible to implement something reliable because the
higher layers are not provided with any guarantee they can rely
on. A hint is useless from a design perspective - guarantees are
required for reliable operation and if we are not designing new
storage features with reliability as a primary concern then we
are wasting our time...

> > Unmapping can and should be made reliable so that we don't have to
> > waste effort trying to fix up mismatches that shouldn't have occurred
> > in the first place...
> 
> Perhaps so. But remember, this can only really be considered a
> correctness issue on thin-provisioned arrays -- because they may run out
> of space sooner than they should. But that kind of failure mode is
> something that is explicitly accepted by those designing and using such
> thin-provisioned arrays. It's not as if we're introducing any _new_ kind
> of problem.

Very true. But this is not a justification for not providing a
reliable unmapping service. If anything it's justification for being
reliable; that when you finally run out of space, there really is no
more space available....

Defrag is not the answer here.

> So I think it's perfectly acceptable for the operating system to treat
> discard requests as a hint, with best-effort semantics. And any device
> which _really_ cares will need to make sure for _itself_ that it handles
> those hints reliably.

So how do you propose that a storage architect who is trying to
design a reliable thin provisioning storage stack finds out which
devices actually do reliable unmapping? Vendors are simply going
to say they support the unmap command, which currently means
anything from "ignore completely" to "always do the right thing".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

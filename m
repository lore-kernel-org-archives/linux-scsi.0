From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Thu, 23 May 2013 07:17:37 +0900
Message-ID: <20130522221737.GA12339@mtj.dyndns.org>
References: <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522143019.GA18541@mtj.dyndns.org>
 <519CDDA4.2050100@redhat.com>
 <20130522193009.GA23845@mtj.dyndns.org>
 <519D360D.4050309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519D360D.4050309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2013 at 11:18:05PM +0200, Paolo Bonzini wrote:
> Ok, so I can split it in 10 patches one per command, but at some point I
> wonder if it is overkill.  For example, for disks:
> 
> - WRITE AND VERIFY(16) is needed to support >2TB disks, and the
> corresponding 12-byte CDB is whitelisted already.  I didn't get reports
> about _these_ command but I do get bug reports about >2TB disks.
> SYNCHRONIZE CACHE(16) is similarly the 16-byte extension of another
> 10-byte command.
> 
> - I added ATA PASS-THROUGH(16) because ATA PASS-THROUGH(12) is present;
> using the (16) version is preferrable because (12) conflicts with the
> destructive MMC command BLANK, see the sg_sat_identify man page.
> 
> - WRITE SAME(16), WRITE SAME(10), UNMAP are needed for discard.
> 
> - COMPARE AND WRITE is used by cluster software.
> 
> Should this be four separate patches?  Or is it enough to write this in
> the commit message?  I honestly find this level of detail to be way way
> higher than the normal requirement of kernel patches, but I'm happy to
> comply.

I think the larger point is that it really is an extension of the
existing kludge.  As mentioned before, cdb filtering itself isn't
something desirable.  It was added as a kludge to work around CD
burning problem.  We should have limited to MMC devices from the
beginning but forgot that and it of course developed uses which were
never intended which in turn pushes the expansion of the kludge.

The primary point where we don't see eye-to-eye is how manageable we
find SG_IO to be.  I have deep seated distrust on exposing SG_IOs in
controlled way.  The drivers try really hard to avoid certain command
sequences or sub-operations.  We end up with all sorts of black and
white lists and careful code sequences grown over time to avoid
obscure issues.

If the userland is trusted enough to be responsible for all that, it's
fine and that's what "count me out" knob is about which makes sense to
me.  Per-cdb filtering to a lesser security domain, not so much.  An
argument could be made that, as a side effect of the misused cdb
filter, we already have it and might as well expand on it; however, as
Martin reiterated in this thread, this is a fundamentally broken
approach.  Well, it at least seems that way to me.

So, what I'm asking is not about splitting the patches in extreme
granularity or adding absurd amount of details, but more the general
discussion and justification of the approach taken for prospect use
cases and how the commands being added would be part of such approach.

> >>>   Why do you need this at all if
> >>>   you have the "count me out" knob in the first place?
> >>
> >> Because the "count me out" knob needs privileges.  It opens up way, way
> > 
> > So does giving out access to the device node itself.
> 
> No, it doesn't.  You can use SCM_RIGHTS, and pass a file descriptor for
> the device node to an unprivileged program.  You can choose the
> users/groups that are allowed to access the device.  In either case, the
> privileged action is limited in time or in scope.
> 
> The count-me-out knob affects all processes that use the device node,
> and won't be cleaned up properly if you SIGKILL the (privileged)
> process that sets it.  So if you can avoid it, you should.

Then let's make it fit the use case better.  I really can't see much
point in crafting the cdb filter when you basically have to entrust
the device to the user anyway.  Let's either trust the user with the
device or not.  I'm very doubtful that the filtered access via SG_IO
can be reliable or secure enough.  Let's please avoid extending a
broken thing.

> There are many use cases, I listed some in my reply to Martin.
> Sometimes you have trust over the guest and can use count-me-out.  But
> in some cases you don't, and yet the current whitelist is not enough
> (e.g. tapes).

Can you elaborate?  Why can't a tape device be entrusted to the user?

-- 
tejun

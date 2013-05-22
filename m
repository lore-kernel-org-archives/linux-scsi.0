From: Tejun Heo <tj@kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Thu, 23 May 2013 04:30:09 +0900
Message-ID: <20130522193009.GA23845@mtj.dyndns.org>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com>
 <519C674A.50700@redhat.com>
 <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522143019.GA18541@mtj.dyndns.org>
 <519CDDA4.2050100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519CDDA4.2050100@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2013 at 05:00:52PM +0200, Paolo Bonzini wrote:
> Il 22/05/2013 16:30, Tejun Heo ha scritto:
> > * Separate fixes from additions.  Transform existing code so that the
> >   visible behavior doesn't change but the required fix can be
> >   implemented on top.  Explicitly note what's going on in the commit
> >   messages.
> 
> Been there, done that.  Have you read the commit messages *at all*?

Yeah, I was summarizing all the points that I raised during the
review.  This part is almost there but still not quite there.

> Patch 2: "Right now, there is still just one bitmap and the mask is
> ignored, so there is no semantic change yet".
> 
> Patch 3: "This patch already introduces some semantic change, albeit
> very limited; [...] a few commands are now forbidden for devices of type
> other than TYPE_ROM, where they are reserved or vendor-specific".

The thing is that the behavior change is now implemented in an
inactive form by #2 and then flipped on by #3.  #2 both change the
format and the content of the table.  This should have been like the
following.

#2: Convert to the new table for mat but set all bits for all commands
    as that's what the old table looks like in the new format.

#3: Implement per-type filtering.  Now this wouldn't change any
    behavior as the new table is the same as the old one.  This can be
    rolled into #2.

#4: Update the filtering table to fix the security issue and *just*
    the identified security issue with UNMAP.  This way, the behavior
    change is limited to the identified security issue and distros can
    backport upto this to address the security issue.

#5: Update the filtering table further so that commands which don't
    make sense for the class are not allowed.  Note that this has some
    possibility of breaking existing users and we do want this in a
    separate patch from #4.

One thing I don't get is why you're saying the original patch 3
"introduces some semantic changes, albeit very limited" because the
update to the command table in the previous patch is rather extensive.
Why do you say it's very limited?

> > * Fix the frigging CVE bug that you've been waving around and do
> >   *just* that.
> 
> Perhaps you've missed that this is v2, not v27.  Tell me a place in the
> original review where you've told me to split the series.

Hmmmm.... so the thing is that it took us a lot of fighting and
bickering for the patchset to look like what it looks like right now
and I clearly recall talking about minimal fixes for the identified
security issue.  It's just exhausting that it still isn't split
properly after so much effort and to have to continue the same type of
point-by-point fight to get the rest of them across, especially when
none of these points are controversial at all.

> > * Add the frigging "count me out" feature that you want for your use
> >   case.  It isn't controversial and is what you need and the
> >   maintainer can apply to the point where [s]he thinks acceptable.
> 
> Sure.  Except I had sent it six months ago, and it lied unreviewed
> despite your acks for two months.  It is in the archives waiting to be
> picked up.

Yeah, well, probably Jens was busy at the moment or something and then
there were activities related to the changes, so it got delayed until
the whole series is resolved.  Anyways, my point was that you wanna
put that right after the security fix, not at the end of the series
with contentious changes in the middle.  That way, the security fix
and the part that your use case requires can be picked up separately.
In fact, at this point, it chould be helpful to make them separate
patchset.

> > * If for whatever reason you have to add more command codes to the
> >   exception table, do them with explicit justifications.  How the hell
> >   "the vast majority of the commands are added because Linux itself is
> >   using them" a proper justification?   How are they used for what
> >   reason and why is adding them beneficial?
> 
> For example, WRITE SAME is used to discard blocks.  If a Linux guest
> wants to discard blocks, it may send WRITE SAME.  If a disk advertises
> support for WRITE SAME, it is not nice if WRITE SAME then fails because
> of a stupid whitelist that was designed for CD-ROMs.

So, as I've said multiple times, let's *please* do this case-by-base -
build the command table gradually with explicit use cases at each
stage because SG_IO is very easy to get wrong for both the users and
the hardware devices and the kernel isn't policing the content of
what's being issued, because it is very nice to be able to know
exactly the intents behind such table contents later, and because we
wanna debate whether we even want to support specific use cases.  It's
one thing to allow WRITE SAME passthrough and it's a different thing
to try to allow all commands which may be issued by udev.

> >   Why do you need this at all if
> >   you have the "count me out" knob in the first place?
> 
> Because the "count me out" knob needs privileges.  It opens up way, way

So does giving out access to the device node itself.  While it could
be cumbersome, requiring privileges there for arbitration isn't a new
thing.

> more than what these patches do.

So, your use case wouldn't work with this?

> And the frigging patch to make the whole whitelisting
> userspace-configurable with finer-grain (but still with appropriate
> capabilities) was nacked.  By you, for God's sake.
> 
> http://permalink.gmane.org/gmane.linux.kernel/1378071

Yeah, that's still nack.

> >   You first
> >   built that command list by scanning the spec and just adding the
> >   commands that seemed "right" to you.
> 
> And then in v2 I stated that I removed some disk commands because of
> discussion with you.  But of course you don't know, because you've not
> read the damn commit messages.

I did read.  Here's the patch description from patch 5.

 Start cleaning up the table, moving out of the way four rare &
 obsolete device types: printers, communication devices (network
 cards) and scanners (both TYPE_PROCESSOR and TYPE_SCANNER).  Add
 missing commands for these four device types.

No real discussion or justifications for those "missing commands".
Similar deal for other patches.  If I argue about command X to make a
general point, what I get is "all - X".  Build from ground up, not the
other way around.

> >   I have near-zero confidence in
> >   your perception of the relationship between the specs and actual
> >   world.
> 
> Thankyouverymuch.  Perhaps you should have read the commit messages (oh
> sorry, have I said it already?) and seen that it's not about commands
> that seemed "right":
> 
>    Only commands that affect the medium are added.
>    Commands that affect other state of the LUN are all privileged, with
>    the sole exception of START STOP UNIT (which has always been
>    allowed for all file descriptors.  I do not really agree with that
>    and it's probably an artifact of when /dev/cdrom had
>    r--r--r-- permissions, but I'm not trying to change that.

Yeah, that one was better than others, but it still doesn't explain
and justify why those specific commands are being added.

-- 
tejun

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Thu, 13 Feb 2003 15:47:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030213154748.A1965@infradead.org>
References: <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E4AC0B5.9030208@splentec.com>; from luben@splentec.com on Wed, Feb 12, 2003 at 04:46:29PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Wed, Feb 12, 2003 at 04:46:29PM -0500, Luben Tuikov wrote:
> > The history is that in 2.4 the cli and BKL based serialization got replaced
> > with io_request_lock held over all entry points, in 2.5 that got changed
> > to the host lock.  So the purpose seems to be avoiding driver changes so
> > far.
> 
> I was trying to identify a clear and precise reason for the lock.
> (I know the history...)

I can't see any reason except the history of this lock.  And no this
reason is probably not clear and precise :)

> It doesn't seem to be purposeful enough (the lock), since the LLDD is
> allowed to sleep, and would most likely drop it. (see below)

*nod*

> Actually I think since it is a pointer which LLDD may set to their
> own lock, it looks like it's trying to prevent LLDD from being
> too simplistic (to be politically correct).

Once again I donm't thiuk this can be explained with anything but
history :)


> But the matter of the fact is that LLDD writers will have to
> be more ``vigilent'', and if they don't know how to make their
> driver functions re-entrant, they can read up on it, or take
> a gradute level OS course, or get their sorry a*ses fired.

Hey, that's a bit harsh (but ture..).  The real problem is that most
scsi drivers don't have a maintainer anymore, they're just odd fixed
by people who care enough for the hardware.

> If a LLDD drops the lock on entry and gains it again on exit, then clearly
> it doesn't need it.
> 
> Else if it doesn't, it then must be relying on it elsewhere, which is
> asking for trouble from eh_* point of view.  A search and replace
> will do ok, with a local lock,

right.

> unless it sets the pointer, in which case this is much easier.

which pointer?  the host lock?

> So, yes, I think that the host_lock can be eliminated from LLDD point of view.
> It will take a bit more time than the host, lun, target work but is doable.
> 
> I think I can find the time to start working on this, as long as I know
> that it's worthwhile.

I think it's absolutely worth the effort!

> [On new queuecommand() prototype]
> 
> Yes, I actually think that this is *more*/easier doable than the host_lock
> issue above.  Again, I'll wait for the powers that be to say
> nay or yea, I just don't like wasting my time.

James, any comments on this one?  I think it's something that is save for
2.5.

> > If you have anough time a prototype now won't hurt though - the scsi code
> > shouldn't really change during early 2.6.
> 
> Yes, I've been thinking of rewriting SCSI Core completely for 2.7, so maybe
> this prototype will be its embryonic state?

Maybe :)

> 
> Some features would be that target/lun scanning will be a completely *distinct*
> functionality and one can even move it to userspace.

James, outlined something similar on the last kernel summit.  I think it's
a worthwile change for 2.7 (let's hope initramfs is useable then)

> Another feature is that new-scsi-core will *not* do any memory allocation
> for sg lists for commands -- this is the task of the application client
> (block layer, app, scanning code, etc).

i.e. the scsi upper layer driver?

> BTW, what kind of prototype are you talking about, functional or non-functional?

limited functionality (i.e. just a single driver or so converted)

> BTW2, we can babble about this all we want here, the important
> thing is what the powers that be have to say about all this.

Yes, it would be interesting to hear from James on whether he ACKs the concept.
I think he has been travelling yesterday, so maybve he's still catching up
on mail.


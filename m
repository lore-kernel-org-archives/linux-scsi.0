From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Wed, 12 Feb 2003 16:46:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4AC0B5.9030208@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> 
> The history is that in 2.4 the cli and BKL based serialization got replaced
> with io_request_lock held over all entry points, in 2.5 that got changed
> to the host lock.  So the purpose seems to be avoiding driver changes so
> far.

I was trying to identify a clear and precise reason for the lock.
(I know the history...)

It doesn't seem to be purposeful enough (the lock), since the LLDD is
allowed to sleep, and would most likely drop it. (see below)

Actually I think since it is a pointer which LLDD may set to their
own lock, it looks like it's trying to prevent LLDD from being
too simplistic (to be politically correct).

But the matter of the fact is that LLDD writers will have to
be more ``vigilent'', and if they don't know how to make their
driver functions re-entrant, they can read up on it, or take
a gradute level OS course, or get their sorry a*ses fired.

For already existing LLDDs, a few nights overhaul might do
the trick.

> Agreed that they should.  The question on how to implement this
> without breaking drivers remains.  Do you volunteer to do add taking
> the lock into all these methods so the existing lock state remains until a
> maintainer ACKs that his driver doesn't need protection / and or makes
> it reenetrant?

[On eh_* functions.]

If a LLDD drops the lock on entry and gains it again on exit, then clearly
it doesn't need it.

Else if it doesn't, it then must be relying on it elsewhere, which is
asking for trouble from eh_* point of view.  A search and replace
will do ok, with a local lock, unless it sets the pointer, in which case
this is much easier.

So, yes, I think that the host_lock can be eliminated from LLDD point of view.
It will take a bit more time than the host, lun, target work but is doable.

I think I can find the time to start working on this, as long as I know
that it's worthwhile.

> That sounds nice to me.  But again, do you think you can do it for 2.5
> without breaking more drivers?  (i.e. fixing everything up)

[On new queuecommand() prototype]

Yes, I actually think that this is *more*/easier doable than the host_lock
issue above.  Again, I'll wait for the powers that be to say
nay or yea, I just don't like wasting my time.

> I don't particularly like that name, but having specifiers backed by
> standards has it's advantage, so I'm agnostic here.

[On ``result'' becoming ``status''.]

It's like the TCP/IP networking code -- you can read the RFCs and
look at the networking code and know exactly what is going on.

It's always a benefit to stick to names as they are in the
standards -- the implementation is so much clearer and one
can find their way around quickly just knowing what the standard
says.  (For nerds like me who read them.)

> It should be the same type as is used for luns in other places of the
> scsi midlayer (whatever that m,ay be when this gets in)

[On lun being 64 bit quantity.]

Actually, talking about standards, this is what a LUN is, a 64 bit quantity.

The fact that Linux SCSI Core uses unsigned int is unfortunate, and has slowly
grown to from 8 bit days when SCSI was just SPI.

> I think that's clearly 2.7 stuff, we've moved scsi a lot forward in 2.5,
> now we need to get most drivers working again and 2.6 out of the door.

Right.

So where do we draw the line? (Rhetorical.)

queuecommand() -> void queuecommand() I think is quite doable, with
microscopic changes to LLDD -- I just need the blessing of the powers
that be.

Getting rid of the host_lock is a bit of a stretch since more
thinking would have to be involved separately for each LLDD, as outlined
above.  This will need a double blessing from the powers that be.

> If you have anough time a prototype now won't hurt though - the scsi code
> shouldn't really change during early 2.6.

Yes, I've been thinking of rewriting SCSI Core completely for 2.7, so maybe
this prototype will be its embryonic state?

Some features would be that target/lun scanning will be a completely *distinct*
functionality and one can even move it to userspace.

Another feature is that new-scsi-core will *not* do any memory allocation
for sg lists for commands -- this is the task of the application client
(block layer, app, scanning code, etc).

I.e. the sole functionality of new-scsi-core will be that of *interfacing*
with the LLDD as specified by SAM-2/3, no more, no less. (I'm flexible
on this of course. :-) )

BTW, what kind of prototype are you talking about, functional or non-functional?

(( Probably non-functional since there's a lot of things which I don't know
    how to do -- i.e. how is ``TARGET'' represented?
    It's not an integer anymore, since SPI is gone.  This will also warrant
    new LLDD, who accept the SAM interface -- i.e. identifying a device
    by the tuple (TARGET, LUN), and ``host'' is really a ``portal'', etc...
    Target is most likely the scsi name, but this gets complicated...
    ``Oh, well...'' Capt. Kirk, oh his death, star date ????.?? ))

BTW2, we can babble about this all we want here, the important
thing is what the powers that be have to say about all this.

-- 
Luben




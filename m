From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI Core cmd allocation 3/3
Date: Mon, 13 Jan 2003 17:59:48 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113175948.A27650@infradead.org>
References: <3E1A2140.3000408@splentec.com> <20030111180355.B2225@infradead.org> <3E22F369.5080209@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E22F369.5080209@splentec.com>; from luben@splentec.com on Mon, Jan 13, 2003 at 12:12:09PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 13, 2003 at 12:12:09PM -0500, Luben Tuikov wrote:
> > We only have two callers of this, one is scsi_getset_command and the other
> > is used for allocating the freelist.  For the latter most of the code in
> > this function is superflous, it just needs the kmem_cache_alloc.
> 
> It will stay this way.  This abstractizes the allocator; we were discussing
> this some time ago, and another allocator could be put in, without disruption
> to SCSI Core.

Rules Nr 1:  Don't overabstract.

> There may be more callers. SCSI Core just shows two callers, but other
> subsystems/LLDD/ULDD may call it too. (There's a reason for this capability
> which I cannot discuss right now -- queuing model will improve considerably, etc.)

Introduce that abstraction when you need it, not beforehand.  Doing abstraction
before you actually need them leads to severe overdesign.

> > I'd suggest just using the kmem_cache_alloc directly for the freelist and
> > merging it into your current scsi_getset_command.  While at it the name
> > scsi_get_command should be transfered to it also :)
> 
> scsi_get_command() was provided in the case when we don't know the device.
> scsi_getset_command() was provided in the case when we know the device,
> which is most of the time, for this reason it's inlined.

Well, where do you actually _need_ scsi_get_command(), that's the question.

I see the purpose, but I don't see it actually used.

> No, it is NOT an obfuscation.
> 
> It's what object oriented paradigm (OOP) is all about.

Go and program in Smalltalk if you're a OOP fanatic.  Even if the kernel
uses OOP paradigms where they are useful it uses procedural interfaces
where they make more sense.  And in thjis case the OOP abstraction don't buy
us anything.

> There's plenty of books on the object oriented paradigm.

Sure there are, there are also papers on goto considered harmful and
people advocating pascal or java.

That doesn't mean the kernel follows them.

> It is my belief that such a struct will make things cleaner and clearer.

But it's not a paradigm used in the linux kernel usually.

> 
> All my inlines follow this style.  Any other code of mine, in .c files
> follows K&R style as it ever did, since my age of 14.

Kernel style is not just K&R.  i.e. your function descriptions should be
converted to the extractable kernel-doc comments and stuff like:

+       if (!dev) return NULL;
+       if (!dev->host) return NULL;

doesn't even seem to be K&R to me :)


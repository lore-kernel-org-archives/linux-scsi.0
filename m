From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Build error: `.exit.text' referenced in section `.rodata'
Date: Tue, 13 May 2008 09:59:17 -0500
Message-ID: <1210690758.3077.23.camel@localhost.localdomain>
References: <20080511151902.GA733@ds20.borg.net>
	 <1210524907.3199.6.camel@localhost.localdomain>
	 <20080511192007.GB724@ds20.borg.net> <20080512115255.GA16942@ds20.borg.net>
	 <1210600904.3078.1.camel@localhost.localdomain>
	 <20080513143112.GA21274@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <20080513143112.GA21274@jurassic.park.msu.ru>
Sender: linux-alpha-owner@vger.kernel.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: dl8bcu@dl8bcu.de, rth@twiddle.net, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-05-13 at 18:31 +0400, Ivan Kokshaysky wrote:
> On Mon, May 12, 2008 at 09:01:44AM -0500, James Bottomley wrote:
> > > With gcc 4.2.3 I get the same error. The noinline patch fixes it again.
> > > 
> > >    text    data     bss     dec     hex filename
> > > 6721720  624416  397508 7743644  76289c vmlinux-gcc-4.2.3
> > 
> > OK, so it's an unfixed bug in gcc, and it looks to be specific to the
> > alpha backend.
> 
> No, other architectures are just lucky that the compiler decides
> a) not to generate a jump table for switch statement in sd_major() and/or
> b) not to inline this function.
> 
> I have a similar test case that fails on x86 as well.

But if that's true then the whole basis for our section based discards
is bogus, because the statement generating the jump table could be
inside the actual function body instead of being inlined, so if it's
failing on x86 as well, we likely need it fixed there too.

> > if the compiler chooses to inline a function, it has to
> > respect the sectional (and other constraints) of the outer function.
> > Can someone file a bug report with the relevant compiler people?
> 
> It would be good, but in the meantime the 'noinline' fix seems to be
> a most sensible option...

We can certainly add it as a short term option.  However, given the push
in certain quarters to make even more use of sections as a means of
discarding code, we're going to have to ask someone to fix the compiler.

James



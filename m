From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: Build error: `.exit.text' referenced in section `.rodata'
Date: Tue, 13 May 2008 18:31:12 +0400
Message-ID: <20080513143112.GA21274@jurassic.park.msu.ru>
References: <20080511151902.GA733@ds20.borg.net> <1210524907.3199.6.camel@localhost.localdomain> <20080511192007.GB724@ds20.borg.net> <20080512115255.GA16942@ds20.borg.net> <1210600904.3078.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-alpha-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1210600904.3078.1.camel@localhost.localdomain>
Sender: linux-alpha-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: dl8bcu@dl8bcu.de, rth@twiddle.net, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, May 12, 2008 at 09:01:44AM -0500, James Bottomley wrote:
> > With gcc 4.2.3 I get the same error. The noinline patch fixes it again.
> > 
> >    text    data     bss     dec     hex filename
> > 6721720  624416  397508 7743644  76289c vmlinux-gcc-4.2.3
> 
> OK, so it's an unfixed bug in gcc, and it looks to be specific to the
> alpha backend.

No, other architectures are just lucky that the compiler decides
a) not to generate a jump table for switch statement in sd_major() and/or
b) not to inline this function.

I have a similar test case that fails on x86 as well.

> if the compiler chooses to inline a function, it has to
> respect the sectional (and other constraints) of the outer function.
> Can someone file a bug report with the relevant compiler people?

It would be good, but in the meantime the 'noinline' fix seems to be
a most sensible option...

Ivan.

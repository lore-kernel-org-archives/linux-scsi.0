From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Build error: `.exit.text' referenced in section `.rodata'
Date: Tue, 13 May 2008 15:51:14 -0500
Message-ID: <1210711874.3077.67.camel@localhost.localdomain>
References: <20080511151902.GA733@ds20.borg.net>
	 <1210524907.3199.6.camel@localhost.localdomain>
	 <20080511192007.GB724@ds20.borg.net> <20080512115255.GA16942@ds20.borg.net>
	 <1210600904.3078.1.camel@localhost.localdomain>
	 <20080513143112.GA21274@jurassic.park.msu.ru>
	 <1210690758.3077.23.camel@localhost.localdomain>
	 <20080513200649.GA23202@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-alpha-owner@vger.kernel.org>
In-Reply-To: <20080513200649.GA23202@jurassic.park.msu.ru>
Sender: linux-alpha-owner@vger.kernel.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: dl8bcu@dl8bcu.de, rth@twiddle.net, linux-scsi@vger.kernel.org, linux-alpha@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-05-14 at 00:06 +0400, Ivan Kokshaysky wrote:
> On Tue, May 13, 2008 at 09:59:17AM -0500, James Bottomley wrote:
> > But if that's true then the whole basis for our section based discards
> > is bogus, because the statement generating the jump table could be
> > inside the actual function body instead of being inlined, so if it's
> > failing on x86 as well, we likely need it fixed there too.
> 
> Correct.
> 
> > > It would be good, but in the meantime the 'noinline' fix seems to be
> > > a most sensible option...
> > 
> > We can certainly add it as a short term option.  However, given the push
> > in certain quarters to make even more use of sections as a means of
> > discarding code, we're going to have to ask someone to fix the compiler.
> 
> Then maybe building with -fno-jump-tables option would be better solution.
> I don't think that it will have a noticeable impact on code size or
> performance, especially on x86.
> 
> So we need something like this (assuming gcc eventually gets fixed,
> say gcc 4.5 ;)
> 
> KBUILD_CFLAGS	+= $(call cc-ifversion, -lt, 0405, \
> 			$(call cc-option, -fno-jump-tables))

This is way beyond a SCSI issue.  Time to take it to linux-arch I
think ... do you want to do the honours?

James



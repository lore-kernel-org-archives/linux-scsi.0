From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] intermediate SCSI updates
Date: Tue, 14 Oct 2008 08:49:11 -0400
Message-ID: <1223988551.12440.1.camel@localhost.localdomain>
References: <1223909115.5566.13.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0810131017030.3288@nehalem.linux-foundation.org>
	 <1223925606.5566.20.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757516AbYJNM6Y@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0810131416410.3288@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-10-13 at 14:22 -0700, Linus Torvalds wrote: 
> 
> On Mon, 13 Oct 2008, James Bottomley wrote:
> > 
> > Not exactly.  It has to be rebased to run as a postmerge tree, but it
> > does get tested by me (admittedly on my limited set of machines, which
> > don't include any actual devices that do block integrity) every time I
> > rebase.
> 
> What I'm upset about is that this has apparently gotten not even some 
> trivial testing of the _default_ build. I'm not talking about any odd 
> config options here. I'm literally talking about the only _sane_ config 
> option case.
> 
> You yourself admit that even you don't have any actual devices that can 
> support the block integrity stuff, yet you have apparently only compile- 
> tested the insane case of still enabling that thing and apparently nobody 
> else has bothered either.

Um, well, I wanted to compile the code to make sure it actually did
compile and that it didn't interfere with the normal operation of sd, so
for me it's a justifiable option.

> Was this in linux-next?

Yes ... all my trees feed into linux-next.  We just seem to have been
having a few teething problems with it recently.  Usually this type of
thing gets picked up by Ingo's random config checker which feeds from
linux-next.  However, I don't think linux-next has been built for a
while (Since 19 September according to the logs)

> Is linux-next coverage REALLY so weak that it doesn't even test the 
> default config options, much less any random options? What's the point of 
> linux-next then?
> 
> Again, the date on that thing is claimed to be September 19th, although it 
> was obviously committed later.

Right, which is, unfortunately, how it managed to avoid being in
anyone's test bed.

> > However, does this work for you?  It fixes the problem for me.
> 
> I could trivially have fixed the compile issue. That's not what upsets me. 
> What upsets me is that this set of patches apparently had almost nobody 
> looking at them at all before they got sent to me.

I agree, but unfortunately our infrastructure is all wrapped around
linux-next now ... even Andrew doesn't pull my trees directly, he gets
them from linux-next.  I can and do publish them on kernel.org, but it
takes a fairly superhuman effort to pull in all the kernel.org trees and
compile them.

> If it was some odd and unusual config option, I'd be less upset. hey, 
> stuff happens. But it sure as heck was nothing of the sort!

So I do test the trees, but I'm looking for unusual breakage, so my
three configs are ia64 (3hr build) parisc (6hr build) and x86 dual core
(about 40min) with all the options enabled.  However, my testing is
mostly runtime rather than compile/config time.  Sorry.  Once I get this
terrasoft box integrated (i.e. when benh gets remote power working) I
might be able to build faster and try different config options.

James

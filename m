From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Date: Sat, 02 Feb 2008 13:49:32 -0500
Message-ID: <47A4BB3C.6050709@garzik.org>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org> <20080202170828.GA12748@elte.hu> <47A4A96D.2040709@garzik.org> <20080202175738.GA26560@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33467 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYBBSts (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Feb 2008 13:49:48 -0500
In-Reply-To: <20080202175738.GA26560@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, pcihpd-discuss@lists.sourceforge.net, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>

Ingo Molnar wrote:
> * Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Ingo Molnar wrote:
>>> it would have been totally appropriate for me to just send a mail to lkml 
>>> with the proper subject line about the breakage. (I might even have 
>>> decided to stay completely silent about the issue and fix it for my own 
>>> build, letting you guys figure it out.)
>> Oh come on...  You are smart enough to know to at least CC the driver 
>> maintainer, the key POC who should be aware of breakage of their 
>> driver.  That is a standard courtesy.
> 
> is there any particular reason why you cut out the most relevant part of 
> my reply, which happens to answer all your questions AFAICS:
> 
>>> Instead i did a search of lkml (based on the function name in the 
>>> build error) and figured out where the pull request was on lkml: 
>>> Greg. I replied to that mail, he'll obviously know whom else to Cc 
>>> from that point on (if anyone). I really didnt want to (nor did i 
>>> need to) figure out whether this was some general driver level API 
>>> change that happen kernel-wide, or some SCSI specific change. I 
>>> simply replied to the pull request whose Cc: line seemed 
>>> well-populated to me already. I also took a look at the commit itself 
>>> and did a quick hack in a hurry to keep the tests rolling. It really 
>>> did not occur to me that i should have added anyone else to the Cc: 
>>> line, as linux-pci@atrey.karlin.mff.cuni.cz was Cc:-ed already so i 
>>> assumed the interest was from that angle.
> 
> had you read this portion you'd have realized that i did not search for 
> any "owner" of the file, i simply searched for the person who introduced 
> the change, and the on-lkml mail where the change was introduced.

And therein lies the problem.  The original submittor omitted relevant 
maintainers, you followed that [incorrect] example, and the end result 
was clear:  an obviously wrong change.

Thus, the problem is precisely what you stated:  you did not bother to 
search for people who care about that file.


> and that's all that should be needed, really. Believe me, i hit tons of 

Hardly.  What part of "this change requires knowledge of the hardware" 
is difficult to understand?

And if you do not have that knowledge, why is it so trying to CC people 
who actively maintain a driver, and have that knowledge?

It's simple common sense to -ask- or at least -notify- in such cases.

That the original submittor made the same mistake is no reason to repeat 
the mistake.


> bugs all across the kernel, often several bugs a day, and it's hard even 
> for me to figure out who "maintains" a file and when. (and in Linux 
> there's no "ownership" of files anyway) So as a general rule i go after 
> changes instead, and that's exactly what i did here too. I do 
> delta/regression QA - i.e. i watch for _changes_ that break the kernel 
> and hence the general 'owner' of a file is often irrelevant - it's the 
> maintainer who introduces a change who matters, and we do lots of 
> cross-maintain merges. Only if i do not manage to identify a change do i 
> try to figure out who maintains a file at that given moment. (But those 
> mails often go into black holes, they get bounced, subscriber-required 
> email lists, etc. etc.) It's also nontrivial to map the files to the 
> MAINTAINERS file, and it's also quite outdated in some portions. So the 
> MAINTAINERS file is the last resort i use.

That's a long list of excuses in an attempt to ignore the facts:

Fact 1:  The driver you modified is actively maintained

Fact 2:  The driver maintainer has respectfully indicated, through the 
standard community mechanism, the useful points of contact.

Fact 3:  The MAINTAINERS entry is correct and up-to-date.

Fact 4:  Even if you wanted to ignore MAINTAINERS, 'git log' on the 
relevant file could have told you who are useful parties to CC.

It's just common courtesy to CC a driver maintainer, ESPECIALLY when a 
change requires knowledge of the driver/hardware in question.


> so i'm still totally befuddled why you think that there was anything 
> particularly wrong or unhelpful about me replying to the specific pull 
> request that introduced a particular breakage into the kernel. Had i 
> mailed to lkml with a terse "kernel build broke" message with just an 
> URL to a config and the build breakage, you could rightfully have 
> complained that i should have done more to properly direct my bugreport. 
> But this breakage was about a PCI API change, the pull request had a PCI 
> mailing list Cc:-ed, why should i have thought that this needs the 
> attention of any other parties?

Because the change required knowledge not only of PCI, but of the 
hardware in question.  As your patch demonstrated.

And yes -- the original changes should have been CC'd to interested 
parties as well.  I'm still waiting to hear back from Alan or Bart 
whether the ATA/IDE changes in that PCI pile actually work...  the 
original changeset even noted that relevant parties had not yet been 
queried.

	Jeff




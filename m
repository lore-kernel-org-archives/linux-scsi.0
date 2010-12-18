From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Sat, 18 Dec 2010 18:16:30 +0300
Message-ID: <4D0CD04E.30806@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>	 <1292599364.2820.21.camel@mulgrave.site>  <4D0B8975.1040206@vlnb.net>	 <1292602908.2820.41.camel@mulgrave.site>  <4D0BBE40.6030000@vlnb.net>	 <1292617658.2820.80.camel@mulgrave.site>  <4D0BD79B.2010600@vlnb.net> <1292628398.16209.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292628398.16209.25.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

James Bottomley, on 12/18/2010 02:26 AM wrote:
> Look, let me try to make it simple:  It's not about the community you
> bring to the table, it's about the community you have to join when you
> become part of the linux kernel. The interactions in the wider
> community are critical to the success of an open source project.  You've
> had the opportunity to interact with a couple of them:  sysfs we've
> covered elsewhere, but in the STGT case you basically said, here's our
> interface, use it. LIO actually asked what they wanted and constructed
> something to fit.  Why are you amazed then when the STGT people seem to
> prefer LIO?
> 
> You've also spent a lot of time doing ad hominem attacks on people who
> you think disagree with you.  Christoph can be abrasive and sometimes a
> little tactless, but he's not often wrong on technical issues, and when
> he is he's usually amenable to technical argument.  He gave both LIO and
> SCST pointers about improvements.  LIO implemented enough that he felt
> comfortable sending in fairly radical cleanup patches ... again, it's no
> real surprise he prefers LIO to work with.
> 
> Basically, in the years we've been at this, you've failed to convince
> any of the key people I rely on to help maintain SCSI to advocate for
> SCST or even to send in patches for it ... they all seem to be either
> neutral or leaning towards LIO.

OK, then how those years looked from our side.

In the beginning decision to go on with STGT was done completely behind
my back. ChristophH and MikeC did review of SCST code, but from comments
I've seen and SCST patches Mike was preparing it was obvious for me that
Christoph and Mike not really understood all the tasks SCST is solving
and, hence why its code so complicated. Particularly, the goal of all
the code to provide 1:many pass-through was not understood. But nobody
asked me to explain. The need in the 1:many pass-through code was
understood only much later after
http://thread.gmane.org/gmane.linux.scsi/31288. The decision to go ahead
with STGT was just taken. I knew about it only after I accidentally saw
some related discussion
http://thread.gmane.org/gmane.linux.iscsi.iscsi-target.devel/1996/focus=2022.
When I tried to explain that it's wrong, I wasn't heard.

You were attracted by the STGT idea by 2 points:

1. Minimal in-kernel maintenance effort.

2. Believe that mmap'ing user space pages can provide similar
performance as fully in-kernel approach.

I disagreed with both. I wasn't heard. But it turned out that at least
one person in the Linux kernel community agreed with me: Linus Torvalds.
See http://lkml.org/lkml/2007/4/24/364 for (1) and
http://lkml.org/lkml/2008/2/4/253 for (2).

Then I kept sending SCST patches and they were ignored by you and "the
key people". We were told that STGT is "good enough" despite of all the
obvious problems it has.

Then suddenly NicholasB appeared with his LIO and suddenly what I was
writing for years was acknowledged correct: STGT isn't good enough and
must be replaced by the fully in-kernel approach.

So, it turned out that I was right all those years and convinced all the
key people at once by the NicholasB hands?

So, writing that I failed to convince any of the key people isn't quite
correct.

It looks like those years I've been staying a step ahead and wasn't
heard. What were the reasons for it? My limited English, which isn't my
native language, so I can't use it similarly correctly and clearly as
native Americans can? I'm working hard to improve it and, hopefully,
progress is noticeable. Similarly, I'm willing to improve in any other
area. Just tell me what should be done?

>> Are we in an absurd Kafka novel?
> 
> Yes, we are ... but I don't think you appreciate whose.

Definitely not. I don't like living in a place when rules are just
declarations and interpreted any way as key people want, even opposite
to what the rules supposed to mean.

>> Moreover, accepting LIO is against your own rules you declared.
>> Particularly:
>>
>> 1. It doesn't have user space backend.
> 
> Oh come on ... this one's been over the lists and Mike and Tomo have
> actually approved of the LIO solution for them

They approved the direction to move on, not the code implementing it.
There's no such code and has never been, while you declared that such
code is REQUIRED for an STGT drop in replacement.

>> 2. It exports some information via procfs, which was declared as a big
>> no-no.
> 
> I looked at the code fairly carefully and didn't find this ... where is
> it?

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob_plain;f=drivers/target/target_core_mib.c;hb=10eae38203a01a26fca3b2097f13e48a0ba2d38f

>> So I keep wondering, why does LIO have so much privileged treatment, so
>> what was forbidden for SCST allowed for LIO?
>>
>> Let's treat SCST equally and allow COMMUNITY, not particular BIASED
>> people to choose the best one!
>>
>> In this regard it looks to be a good idea to freeze accepting both LIO
>> and SCST until the end of the next year and then choose one with the
>> biggest activity in the related mailing lists, not counting me and
>> NicholasB.
>>
>> You want the best community, so let community choose!
> 
> Essentially, I did ... it has.

Which community do you mean? Few selected people on the invitation-only
storage summit?

Sorry, James, but all your arguments so far come to a single one: "I
like Nicholas Bellinger and the way he makes deals, so I want him here.
I'll do my best to push him in. I want it so much, so I'm willing to
alter any rules to suit him, even declare black white, if necessary.".

I'm not sure even in the quality of review of the NicholasB's code,
since somehow such big thing as the proc interface managed to slipped it.

Apparently, such preferred treatment leaves a lot of space for
conspiracy theories.

People believe that Linux kernel is a sane place free from dirty
undercover politics, where the best code wins, so it will be a huge
disappointment for everyone if this believe turns out be wrong.

Vlad

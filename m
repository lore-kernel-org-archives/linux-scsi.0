From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for multimedia
 devices
Date: Fri, 25 Jan 2013 19:47:47 +0100
Message-ID: <5102D353.8010305@redhat.com>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com> <1359039649-17734-7-git-send-email-pbonzini@redhat.com> <20130124225555.GC2373@mtj.dyndns.org> <51024FB1.3000206@redhat.com> <20130125170434.GC3081@htj.dyndns.org> <5102BDD4.2020501@redhat.com> <20130125172805.GG3081@htj.dyndns.org> <5102C780.3090402@redhat.com> <20130125181326.GK3081@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130125181326.GK3081@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Il 25/01/2013 19:13, Tejun Heo ha scritto:
> I'm not sure how well I can explain this but something being in the
> spec and something in wide use are two different things, and people,
> including the ones in hw vendors, tend not to pay too much attention /
> resources to stuff which aren't used widely and commands which aren't
> in wide use are much more likely to have errors in their
> implementation or be abused - e.g. overridden for vendor specific
> command as part of weird init sequence to select device mode or
> whatnot.

That doesn't happen.  There's plenty of vendor-specific opcodes and mode
pages, not to mention out-of-band channels, e.g. work directly at the
USB level like the mode select stuff.

IIRC IOMEGA ZIP drives had some egregious abuse in READ and WRITE of the
boot sector, presenting fake partition tables or something like that.
But it wasn't using strange commands for that.

> Another aspect is that sometimes opcodes are recycled and people of
> course don't try to recycle opcodes which are in wide use.  They
> choose the ones which failed to gain much traction and became
> obsolete.  The recycled command might not be suitable for exposing to
> userland.

No, that doesn't happen either.  There's plenty of reserved opcodes, and
this time you can count on the standards people which are more
reasonable than vendors.

> So, there are actual costs coming from exposing them, which is fine if
> the benefit can offset them enough, but what would be the benefit of
> exposing commands which aren't being used?

If it is not used, nobody will use it and nothing will break.

If it is used in a case we don't know, you'll have to add it later.

If it is little used and broken somewhere, you'll have to add it later
to the whitelist and implement the quirk.  Both of them.  Adding it now
saves a step.

The only case in which you save later work, is if someone bitches that X
doesn't work but nobody tells us.  Patch economy by obscurity. :)

> The only thing I can think
> of is that of avoiding the annoyance of expanding the list later?
> But, as you said, exposing commands by default mean that we're more
> likely to need blacklists in the future

I disagree.  It does not change anything.

If it is something really serious (i.e. it crashes the firmware), we'd
need a quirk anyway.  If it is something only slightly less stupid,
userspace can deal with broken hardware itself.  It is somewhat expected
with SG_IO anyway.  For virt, the guest would treat it the same as on
bare metal; for anything else, the program would already have to deal
with it if run as root.

> , so that doesn't seem like
> that much of winning to me.  Discovering use cases is actually much
> easier than finding broken devices for some obscure commands.

Not if many of your uses are proprietary (Windows, AIX on PPC, z/OS on
s390, Oracle, SAP, you name it).

>>> and can you please stop labeling reviews as "useless"?
>>
>> Reviews are not useless, but championing the inclusion of two obsolete
>> commands in a list is not a good use of bandwidth.  Because the choice
>> is arbitrary, the discussion can degenerate too easily into repeatedly
>> saying the same thing over and over.  All I'm trying to do is avoid it.
> 
> Seems like I was too twitchy.  My apologies.

No problem.

Paolo

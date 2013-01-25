From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/13] sg_io: whitelist a few more commands for
 multimedia devices
Date: Fri, 25 Jan 2013 10:13:26 -0800
Message-ID: <20130125181326.GK3081@htj.dyndns.org>
References: <1359039649-17734-1-git-send-email-pbonzini@redhat.com>
 <1359039649-17734-7-git-send-email-pbonzini@redhat.com>
 <20130124225555.GC2373@mtj.dyndns.org>
 <51024FB1.3000206@redhat.com>
 <20130125170434.GC3081@htj.dyndns.org>
 <5102BDD4.2020501@redhat.com>
 <20130125172805.GG3081@htj.dyndns.org>
 <5102C780.3090402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5102C780.3090402@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, pmatouse@redhat.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@kernel.org, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Hey, Paolo.

On Fri, Jan 25, 2013 at 06:57:20PM +0100, Paolo Bonzini wrote:
> And because someone _will_ use it from my point of view, I can only give
> justification to leave stuff _out_.  In general I did so if the command
> can disrupt someone else, as would be the case for persistent
> reservations.  It was not really always respected for the existing
> table, for example I'd have left out LOG SELECT, but the series is
> already controversial enough, so one thing at a time.

I'm not sure how well I can explain this but something being in the
spec and something in wide use are two different things, and people,
including the ones in hw vendors, tend not to pay too much attention /
resources to stuff which aren't used widely and commands which aren't
in wide use are much more likely to have errors in their
implementation or be abused - e.g. overridden for vendor specific
command as part of weird init sequence to select device mode or
whatnot.

Another aspect is that sometimes opcodes are recycled and people of
course don't try to recycle opcodes which are in wide use.  They
choose the ones which failed to gain much traction and became
obsolete.  The recycled command might not be suitable for exposing to
userland.

So, there are actual costs coming from exposing them, which is fine if
the benefit can offset them enough, but what would be the benefit of
exposing commands which aren't being used?  The only thing I can think
of is that of avoiding the annoyance of expanding the list later?
But, as you said, exposing commands by default mean that we're more
likely to need blacklists in the future, so that doesn't seem like
that much of winning to me.  Discovering use cases is actually much
easier than finding broken devices for some obscure commands.

> > and can you please stop labeling reviews as "useless"?
> 
> Reviews are not useless, but championing the inclusion of two obsolete
> commands in a list is not a good use of bandwidth.  Because the choice
> is arbitrary, the discussion can degenerate too easily into repeatedly
> saying the same thing over and over.  All I'm trying to do is avoid it.

Seems like I was too twitchy.  My apologies.

Thanks.

-- 
tejun

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block: Free queue resources at blk_release_queue()
Date: Tue, 27 Sep 2011 23:10:38 -0500
Message-ID: <1317183038.17578.9.camel@dabdike.hansenpartnership.com>
References: <201109221318.p8MDIXPP020015@pentland.suse.de>
	 <20110928004722.GA27421@kernel.dk>
	 <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>
	 <4E82751C.9050908@kernel.dk>
	 <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-09-27 at 18:59 -0700, Linus Torvalds wrote:
> On Tue, Sep 27, 2011 at 6:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> But if you forward the actual patch to me (the one I see on lkml seems
> >> to be broken and doesn't compile cleanly because it's assiging a
> >> structure to a pointer), I'll try it out anyway.
> >
> > Thanks, that would be great. It's inlined below.
> 
> Well, I did several USB eject events, and nothing bad happened.
> 
> But as mentioned, I don't think that means much. Have you tried this
> with slub debugging and poisoning? It might be worth some extra
> testing that way.

I've been testing a simpler version:

http://marc.info/?l=linux-kernel&m=131300594629839

For a long time now with great success.  The only difference is the
locking cleanup, but SCSI doesn't need that since it doesn't supply its
own lock, so I've been voting for this as the final fix for a while now.

James

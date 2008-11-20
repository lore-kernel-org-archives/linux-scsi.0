From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Thu, 20 Nov 2008 10:13:03 +0100
Message-ID: <20081120091303.GF26308@kernel.dk>
References: <49232232.10604@oracle.com> <4923237B.9090707@xenotime.net> <4923347D.8000205@oracle.com> <20081119085227.GQ26308@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77884EACB7986A@GVW0547EXC.americas.hpqcorp.net> <49244B69.80903@oracle.com> <0F5B06BAB751E047AB5C87D1F77A77884EACB798C4@GVW0547EXC.americas.hpqcorp.net> <20081119172919.GT26308@kernel.dk> <0F5B06BAB751E047AB5C87D1F77A77884EACB799CC@GVW0547EXC.americas.hpqcorp.net> <20081119204624.GW26308@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:53905 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbYKTJOy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2008 04:14:54 -0500
Content-Disposition: inline
In-Reply-To: <20081119204624.GW26308@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>

On Wed, Nov 19 2008, Jens Axboe wrote:
> On Wed, Nov 19 2008, Miller, Mike (OS Dev) wrote:
> > Jens wrote:
> > 
> > >
> > > Yeah, kexec is definitely a clue. My guess is that we got
> > > some sort of left over completion. Regardless of the status
> > > of this particular bug or not, I think it would be a good
> > > idea to add some checks for when a command is attempted
> > > removed from a queue it isn't currently on.
> > >
> > 
> > I agree, I'll fix.
> 
> I'd propose just converting it to list_head instead of doing it
> manually. Heck, that should be a 5 minute job, let me just do it...
> 
> OK, here it is, totally untested (it compiles, must be golden...)

It was missing a list_entry() in fail_all_cmds(), apart from that it was
fine. I changed it to use hlist instead, as that is more appropriate and
similar to how it worked before. It also means there's no extra space
usage in the controller structure. I've tested it and it works fine for
me.

Mike, can you give this a look-over and give me a Reviewed-by or
similar? As an extra bonus, it also gets rid of some code.

 3 files changed, 33 insertions(+), 46 deletions(-)

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=e303054e55acd1b6478b8859a5f8648bfaf69a44

-- 
Jens Axboe


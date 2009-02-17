From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [osd-dev] [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Tue, 17 Feb 2009 10:10:15 +0200
Message-ID: <499A70E7.4000405@panasas.com>
References: <49992F99.1060404@panasas.com>	<20090216183750H.fujita.tomonori@lab.ntt.co.jp>	<49993FF2.9050200@panasas.com> <20090217092042C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8324 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbZBQIKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 03:10:22 -0500
In-Reply-To: <20090217092042C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org, avishay@gmail.com, osd-dev@open-osd.org, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org

FUJITA Tomonori wrote:
> 
> Can you stop the argument, "exofs is similar to the existing
> traditional file systems hence it should be treated equally". It's
> simply untrue. Does anyone except for panasas people insist the same
> argument?
> 

No I will not, it is true. exofs is just a regular old filesystem
nothing different.

> We are talking about the design of exofs, which also affects the
> design of OSD ULD (including the library) living in SCSI
> mid-layer. 

The ULD belongs to scsi but the library could sit else where, how
is that an argument?

> It's something completely different from existing
> traditional file systems that work nicely on the top of the block
> layer.
> 

Nicely is a matter of opinion. I think that building a bio in stages
in the background, then at the point of execution build a request-from-bio
and execute is a nice design that makes sure nothing is duplicated, copied,
and wheels are not re-invented. Current Kernel design is nice, why change
it?

> As discussed in another thread, now OSD ULD reinvents the bio handling
> infrastructure because of the design of exofs. 

Not true, show me where? You keep saying that. Where in the code is it
reinvented?

> But OSD ULD can use the
> block layer helper functions to avoid the re-invention if we change
> the exofs design to take pages instead of bios.

That, above is exactly a re-invention of block layer. What was all that
scatterlist pointers and scsi_execute_async() cleanup that you worked
so hard to get rid off. It was a list of pages+offsets+lengths, that's what
it was. Now you ask me to do the same, keep an external structure of
pages+offsets+lengths. pass them three layers down and at some point in
time force new block_layer interfaces, which do not fully exist today,
to prepare a request for submission.

No! the decision was, keep preparation of request local and submit it
in place, without intermediate structures. From-memory-to-request
in one stage.

That's what I want. The bio lets me do that yesterday, lots of file
systems do that yesterday.

All I'm asking for is one small blk_make_request() that is a parallel
of generic_make_request() of the BLOCK_FS, for the BLOCK_PC requests

If someone wanted a filesystem over tape drives, over st.c or osst.c.
He would design it similar. collect bios in background, point and shoot.
The blk_map_xxx functions where made to satisfy user-mode interfaces, for
filesystems it was bio for ages.

> For now, it works

> perfectly for exofs. In the future, we might change it but we don't
> know until you submit patches (or the performance results) that show
> taking pages doesn't work for exofs nicely.
> 

I don't know about you, but me, I don't have to do some work to know
it's bad. I can imagine before hand that it is bad. I usually run
hundreds of simulations in my head, discarding any bad options until I
find the one way I like. Usually the short easiest way is also the best.
(Since I'm very lazy)
Like with bidi for example, Why not just take two requests instead of
one? But I was sent to do all that gigantic work so everyone will see
that.

> I guess that we need to evolve the block layer to support OSD stuff
> cleanly than we've discussed recently. But again we can do when we
> definitely need to do.

It's not that big and long evolution. It is a simple:

struct request *blk_make_request(struct bio*, gfp_t gfp);

And we are done. more simple then that? I don't know

Boaz

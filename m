From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/2] Putting bio_list into struct request?
Date: Sun, 19 Apr 2009 19:44:59 +0200
Message-ID: <20090419174459.GL4593@kernel.dk>
References: <20090419161234.GA12105@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:34827 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZDSRpA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2009 13:45:00 -0400
Content-Disposition: inline
In-Reply-To: <20090419161234.GA12105@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Sun, Apr 19 2009, Jeff Garzik wrote:
> 
> Now that we have bio_list in include/linux/bio.h, I wanted to see what
> would happen when I replaced rq->{bio,biotail} with rq->bio_list.
> 
> Personally, I think the result is more readable, and indicates to all
> users that rq->bio is really a list (even if a list with one entry).
> Also, it highlights some bio users in downstream drivers, and hopefully
> serves to increase the amount of bio-related review in those drivers.

Well, I disagree, but perhaps I'm just used to it... Plus the patch
actually adds more lines than it deletes, and the resulting code is
larger. I think that's a pretty good hint not to use helpers, at least
for core code. It's more important in drivers, where we want
easy-to-use and understand helpers, since it minimizes bugs in code
written by people who may not be intimate with the block layer etc.

> The first patch is a straightforward replacement, with no code or
> behavior changes (any such is a bug in the patch...):
> 
> 	- null/not-null tests become bio_list_empty()
> 	- rq->bio becomes rq->bio_list.head
> 	- rq->biotail becomes rq->bio_list.tail
> 	- in a few cases, bio_list_xxx functions are called
> 	  as appropriate
> 
> The second patch are fixes to what I believe are minor bugs in the
> bio-list-aware block core.  Even if patch #1 is not accepted, these
> fixes are likely needed regardless.  Typically the bugs are of the type
> "we forgot to update rq->biotail".

It's not bugs, as soon as you clear ->bio there's no list to begin with.
->biotail is only ever used for back merging checks. If we didn't do
back merging, we would not need to access the tail element ever. I
suspect the reason why the resulting code is larger is exactly because
it's not a 1:1 transition. When we do a back merge, we don't have to
check of ->tail is set. It always is.

-- 
Jens Axboe


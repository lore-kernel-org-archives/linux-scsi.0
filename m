From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/2] Putting bio_list into struct request?
Date: Sun, 19 Apr 2009 12:12:34 -0400
Message-ID: <20090419161234.GA12105@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:58747 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758919AbZDSQMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Apr 2009 12:12:35 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, hch@lst.de


Now that we have bio_list in include/linux/bio.h, I wanted to see what
would happen when I replaced rq->{bio,biotail} with rq->bio_list.

Personally, I think the result is more readable, and indicates to all
users that rq->bio is really a list (even if a list with one entry).
Also, it highlights some bio users in downstream drivers, and hopefully
serves to increase the amount of bio-related review in those drivers.

The first patch is a straightforward replacement, with no code or
behavior changes (any such is a bug in the patch...):

	- null/not-null tests become bio_list_empty()
	- rq->bio becomes rq->bio_list.head
	- rq->biotail becomes rq->bio_list.tail
	- in a few cases, bio_list_xxx functions are called
	  as appropriate

The second patch are fixes to what I believe are minor bugs in the
bio-list-aware block core.  Even if patch #1 is not accepted, these
fixes are likely needed regardless.  Typically the bugs are of the type
"we forgot to update rq->biotail".

But maybe some of those are on purpose.  Who knows, give it a
look... it is quite muddled which block core functions want 'bio'
as a list, or just a singleton 'bio'.  Maybe I just got confused.

If nothing else, it helps to give this area of block another look, IMO.

	Jeff





From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCHSET  0/2] Don't let blk_put_request leak BIOs
Date: Thu, 19 Mar 2009 12:20:10 +0200
Message-ID: <49C21C5A.6030105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:47503 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZCSKV0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 06:21:26 -0400
Received: by nf-out-0910.google.com with SMTP id d21so79016nfb.21
        for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2009 03:21:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Hi Jens

You never commented on these patches. Please have a look?

The issue is that if we map some memory into a request but then
do not execute it. Then calling blk_put_request() will leak the bio(s)
unless one does an ugly code like:
-	struct bio *bio;
-
-	while ((bio = rq->bio) != NULL) {
-		rq->bio = bio->bi_next;
-		bio_endio(bio, 0);
-	}

This problem arise in OSD when we can fail to setup the write
or the read side and then we must cleanup the other half.
Same problem exist in bsg, on bidi commands. But there the bio
is just leaked on the error path, it does not do the ugly loop above.

My proposed solution is that blk_put_request() should see if
there is a left-over bio and do the deallocation of the bio's

A side effect of this is if before, do to some bugs, drivers failed
to complete the request fully, the bio would leak. Now it will not
any more.

All above is the theory, in practice some code was abusing the use
of request->bio and it needed fixing. I tried to audit all code path
that call blk_put_request() and fix them.

But it is still dangerous and we should run with this patch in
linux-next and the block tree and see if the WARN_ON at patch [PATCH 1/2]
does not trigger. I have marked this patch as TESTING. The final patch
submitted to Linus should be Minus this WARN_ON.

James
I'm also sending the osd patch through Jens's tree. So there will not
be ordering dependency problems from two trees. Is that OK? do I need
your ACK-BY?

The patches are:
[PATCH 1/2] TESTING: Don't let blk_put_request leak BIOs
    This is for linux-next. Before final submission to Linus a patch
    minus the WARN_ON (and TESTING:) should be submitted.

[PATCH 2/2] libosd: Don't let osd abuse block internals, now that it's fixed
    This can go through Jens tree, I will make sure it will not conflict
    with any scsi-misc patches.

Thank you in advance
Boaz

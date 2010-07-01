From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: (unknown)
Date: Thu,  1 Jul 2010 19:49:16 +0900
Message-ID: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33212 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217Ab0GAKu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 06:50:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org

This patchset fixes page leak issue in discard commands with unprep
facility that James posted:

http://marc.info/?l=linux-scsi&m=127791727508214&w=2

The 1/3 patch adds unprep facility to the block layer (identical to
what James posted).

The 2/3 patch frees a page for discard commands by using the unprep
facility. James' original patch doesn't work since it accesses to
rq->bio in q->unprep_rq_fn. We hit oops since q->unprep_rq_fn is
called when all the data buffer (req->bio and scsi_data_buffer) in the
request is freed.

I use rq->buffer to keep track of an allocated page as the block layer
sets rq->buffer to the address of bio's page. scsi-ml (and llds) don't
use rq->buffer (rq->buffer is set to NULL). So I can't say that I like
it lots. Any other way to do that?

The 3/3 path just removes the dead code.

This is against Jens' for-2.6.36.

The git tree is also available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git unprep

I'll update the discard FS request conversion on the top of this soon. But this can be applied independently (and fixes the memory leak).

=
 block/blk-core.c        |   25 +++++++++++++++++++++++++
 block/blk-settings.c    |   17 +++++++++++++++++
 drivers/scsi/scsi_lib.c |    2 +-
 drivers/scsi/sd.c       |   25 +++++++++++++++----------
 include/linux/blkdev.h  |    4 ++++
 5 files changed, 62 insertions(+), 11 deletions(-)




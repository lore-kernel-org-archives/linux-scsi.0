From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 0/2] use q->prep_rq_fn for flush requests instead of q->prepare_flush_fn()
Date: Fri,  2 Jul 2010 16:33:23 +0900
Message-ID: <1278056005-25438-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41489 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0GBHeS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jul 2010 03:34:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, axboe@kernel.dk
Cc: hch@lst.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

scsi-ml builds flush requests via q->prepare_flush_fn(), however,
builds discard requests via q->prep_rq_fn.

Using two different mechnisms for the similar requests (building
commands in SCSI ULD) doesn't make sense.

Handing both via q->prep_rq_fn makes the code simpler.

We could kill q->prepare_flush_fn(). Except for ide, all the users
just mark flush requests. They can use REQ_FLUSH flag instead. Ide can
do like SCSI.

==
 block/blk-barrier.c |   12 ++++--------
 drivers/scsi/sd.c   |   26 ++++++++++++++++----------
 include/linux/bio.h |    2 ++
 3 files changed, 22 insertions(+), 18 deletions(-)

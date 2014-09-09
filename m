From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 0/8] block: per-distpatch_queue flush machinery
Date: Tue,  9 Sep 2014 21:05:41 +0800
Message-ID: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:33413 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756621AbaIINGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 09:06:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Hi,

As recent discussion, especially suggested by Christoph, this patchset
implements per-distpatch_queue flush machinery, so that:

	- current init_request and exit_request callbacks can
	cover flush request too, then the ugly and buggy copying
	way of initializing flush request's pdu can be fixed
    
	- flushing performance gets improved in case of multi hw-queue

About 70% throughput improvement is observed in sync write/randwrite
over multi dispatch-queue virtio-blk, see details in commit log
of patch 8/8.

This patchset can be pulled from below tree too:

	git://kernel.ubuntu.com/ming/linux.git v3.17-block-dev


 block/blk-core.c       |   11 +--
 block/blk-flush.c      |  239 +++++++++++++++++++++++++++++++++++++++---------
 block/blk-mq.c         |   27 +++---
 block/blk-mq.h         |    1 -
 block/blk-sysfs.c      |    4 +-
 block/blk.h            |   35 ++++++-
 include/linux/blk-mq.h |    2 +
 include/linux/blkdev.h |   10 +-
 8 files changed, 251 insertions(+), 78 deletions(-)

Thanks,
--
Ming Lei


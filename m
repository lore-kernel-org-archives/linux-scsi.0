From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/17] SCSI data path micro-optimizations
Date: Wed, 05 Feb 2014 04:39:30 -0800
Message-ID: <20140205123930.150608699@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaBEMkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:40:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

This series contains various optimizations for the SCSI data I/O path.
They increase the number of IOPS seen with iSCSI or SRP between 2%
and 3.5% in workloads that previously hit the host_lock hard.  While this
isn't a lot it now fully shifts the contention to the queue_lock, which
will get out of the way later when the SCSI midlayer is converted to
use the blk-mq infrastructure.

Testing has been limited on virtio_scsi, libata, iscsi and srp and more
feedback is as always welcome.

This work was sponsored by the ION division of Fusion IO.

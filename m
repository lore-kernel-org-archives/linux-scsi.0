From: Christoph Hellwig <hch@lst.de>
Subject: expose queue the queue mapping for SCSI drivers V2
Date: Tue,  1 Nov 2016 08:12:46 -0600
Message-ID: <1478009569-19026-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34174 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966238AbcKAOMx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 10:12:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, don.brace@microsemi.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

In 4.9 I've added support in the interrupt layer to automatically
assign the interrupt affinity at interrupt allocation time, and
expose that information to blk-mq.

This series extents that so that SCSI driver can pass on the information
as well.  The SCSI part is fairly trivial, although we need to also
export the default queue mapping function in blk-mq to keep things simple.

I've also converted over the smartpqi driver as an example as it's the
easiest of the multiqueue SCSI drivers to convert.

Changes since V1:
 - move the EXPORT_SYMBOL of blk_mq_map_queues to the right patch
 - added Reviewed-by, Acked-by and Tested-by tags

From: Christoph Hellwig <hch@lst.de>
Subject: blk-mq timeout handling fixes
Date: Sat, 13 Sep 2014 16:40:07 -0700
Message-ID: <1410651613-1993-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series fixes various issues with timeout handling that Robert
ran into when testing scsi-mq heavily.  He tested an earlier version,
and couldn't reproduce the issues anymore, although the series changed
quite significantly since and should probably be retested.

In summary we not only start the blk-mq timer inside the drivers
->queue_rq method after the request has been fully setup, and we
also tell the drivers if we're timing out a reserved (internal)
request or a real one.  Many drivers including will need to handle
those internal ones differently, e.g. for scsi-mq we don't even
have a scsi command structure allocated for the reserved commands.

From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 0/3] Show all commands in debugfs
Date: Tue,  5 Dec 2017 16:57:50 -0800
Message-ID: <20171206005753.28734-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Hello Jens,

While debugging an issue with the SCSI error handler I noticed that commands
that got stuck in that error handler are not shown in debugfs. That is very
annoying for anyone who relies on the information in debugfs for root-causing
such an issue. Hence this patch series that makes sure that commands that got
stuck in a block driver timeout handler are also shown in debugfs. Please
consider these patches for kernel v4.16.

Thanks,

Bart.

Changes compared to v1:
- Split the SCSI patch into two patches.
- Added the tag "Cc: stable" to two of the three patches.
- Included a change for the SCSI sd driver.

Bart Van Assche (3):
  scsi: Fix a scsi_show_rq() NULL pointer dereference
  blk-mq-debugfs: Also show requests that have not yet been started
  scsi-mq-debugfs: Show more information

 block/blk-mq-debugfs.c      |  2 +-
 drivers/scsi/scsi_debugfs.c | 47 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/sd.c           |  4 +++-
 3 files changed, 46 insertions(+), 7 deletions(-)

-- 
2.15.0

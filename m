From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V4 00/16] scsi-mq support for ZBC disks
Date: Sun, 24 Sep 2017 18:36:20 +0200
Message-ID: <3cf1913a-99fe-2d0f-b28a-ac40d4c84ee7@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
 <20170924150234.GE14806@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2485 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752474AbdIXQge (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2017 12:36:34 -0400
In-Reply-To: <20170924150234.GE14806@lst.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>

On 9/24/17 17:02, Christoph Hellwig wrote:
>>  Documentation/block/zoned-iosched.txt |  48 ++
>>  block/Kconfig.iosched                 |  12 +
>>  block/Makefile                        |   1 +
>>  block/blk-mq-debugfs.h                |  14 +-
>>  block/blk-mq-sched.h                  |  11 +-
>>  block/zoned-iosched.c                 | 925 ++++++++++++++++++++++++++++++++++
>>  drivers/scsi/scsi_lib.c               |   5 +-
>>  drivers/scsi/sd_zbc.c                 | 267 +++++++---
>>  include/linux/blk-mq-debugfs.h        |  23 +
>>  include/linux/blk-mq-sched.h          |  14 +
>>  include/linux/blkdev.h                |  24 +
>>  include/scsi/scsi_proto.h             |  45 +-
>>  12 files changed, 1283 insertions(+), 106 deletions(-)
>>  create mode 100644 Documentation/block/zoned-iosched.txt
>>  create mode 100644 block/zoned-iosched.c
>>  create mode 100644 include/linux/blk-mq-debugfs.h
>>  create mode 100644 include/linux/blk-mq-sched.h
> 
> This still seems to document the previous version.  Did it get
> any smaller by merging the zoned schedule into mq-deadline?

Ooops... Sorry. I messed up the cover letter. Here are the changes:

Damien Le Moal (16):

  scsi: sd_zbc: Move ZBC declarations to scsi_proto.h

  scsi: sd_zbc: Fix comments and indentation

  scsi: sd_zbc: Rearrange code

  scsi: sd_zbc: Use well defined macros

  scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()

  block: Add zoned block device information to request queue

  scsi: sd_zbc: Initialize device request queue zoned data

  scsi: sd_zbc: Limit zone write locking to sequential zones

  scsi: sd_zbc: Disable zone write locking with scsi-mq

  block: mq-deadline: Add zoned block device data

  block: mq-deadline: Introduce zones_wlock attribute

  blokc: mq-deadline: Introduce dispatch helpers

  block: mq-deadline: Introduce zone locking support

  block: mq-deadline: Limit write dispatch for zoned block devices

  block: do not set mq defaulte scheduler

  block: mq-deadline: Update documentation



 Documentation/block/deadline-iosched.txt |  17 ++

 block/elevator.c                         |  17 +-

 block/mq-deadline.c                      | 302
+++++++++++++++++++++++++++-
 drivers/scsi/scsi_lib.c                  |   5 +-

 drivers/scsi/sd_zbc.c                    | 325
++++++++++++++++++++++++-------
 include/linux/blkdev.h                   |  48 +++++

 include/scsi/scsi_proto.h                |  45 +++--

 7 files changed, 656 insertions(+), 103 deletions(-)

I resent the cover letter.

-- 
Damien Le Moal
Western Digital Research

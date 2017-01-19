From: Hannes Reinecke <hare@suse.de>
Subject: requeue failure with blk-mq-sched
Date: Thu, 19 Jan 2017 13:27:04 +0100
Message-ID: <fb509d83-c895-ba78-e181-145c77542eac@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Jens,

upon further testing with your blk-mq-sched branch I hit a queue stall
during requeing:

[  202.340959] sd 3:0:4:1: tag#473 Send: scmd 0xffff880422e7a440
[  202.340962] sd 3:0:4:1: tag#473 CDB: Test Unit Ready 00 00 00 00 00 00
[  202.341161] sd 3:0:4:1: tag#473 Done: ADD_TO_MLQUEUE Result:
hostbyte=DID_OK driverbyte=DRIVER_OK
[  202.341164] sd 3:0:4:1: tag#473 CDB: Test Unit Ready 00 00 00 00 00 00
[  202.341167] sd 3:0:4:1: tag#473 Sense Key : Unit Attention [current]
[  202.341171] sd 3:0:4:1: tag#473 Add. Sense: Power on, reset, or bus
device reset occurred
[  202.341173] sd 3:0:4:1: tag#473 scsi host busy 1 failed 0
[  202.341176] sd 3:0:4:1: tag#473 Inserting command ffff880422e7a440
into mlqueue

... and that is the last ever heard of that device.
The 'device_busy' count remains at '1' and no further commands will be
sent to the device.

Debugging continues.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

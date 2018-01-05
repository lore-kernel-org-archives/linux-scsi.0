From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V9 0/7] blk-mq support for ZBC disks
Date: Fri, 5 Jan 2018 09:21:52 -0700
Message-ID: <20180105162150.GA16978@kernel.dk>
References: <20171221064344.6228-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171221064344.6228-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 21 2017, Damien Le Moal wrote:
> This series, formerly titled "scsi-mq support for ZBC disks", implements
> support for ZBC disks for system using the scsi-mq I/O path.
> 
> The current scsi level support of ZBC disks guarantees write request ordering
> using a per-zone write lock which prevents issuing simultaneously multiple
> write commands to a zone, doing so avoid reordering of sequential writes to
> sequential zones. This method is however ineffective when scsi-mq is used with
> zoned block devices. This is due to the different execution model of blk-mq
> which passes a request to the scsi layer for dispatching after the request has
> been removed from the I/O scheduler queue. That is, when the scsi layer tries
> to lock the target zone of the request, the request may already be out of
> order and zone write locking fails to prevent that.
> 
> Various approaches have been tried to solve this problem directly from the core
> code of blk-mq. All of them had the serious disadvantage of cluttering blk-mq
> code with zoned block device specific conditions and processing, making
> maintenance and testing difficult.
> 
> This series adds blk-mq support for zoned block devices at the I/O scheduler
> level with simple modifications of the mq-deadline scheduler. Implementation
> is done with reusable helpers defined in the zoned block device support file
> (blk-zoned.c). These helpers provide per zone write locking control functions
> similar to what was implemented directly in the SCSI layer in sd_zbc.c.
> The zone write locking mechanism is used by mq-deadline for the exact same
> purpose, that is, to limit writes per zone to at most one request to avoid
> reordering.
> 
> The changes to mq-deadline do not affect its operation with regular disks. The
> same scheduling behavior is maintained for these devices. Compared to the SCSI
> layer zone locking implementation, this series optimizes avoids locking
> conventional zones which result in a use of these zone that is comparable to a
> regular disk.
> 
> This series also implements changes to the legacy deadline-iosched. Doing so,
> the zone locking code at the SCSI layer in sd.c and sd_zbc.c can be removed.
> This results in a significant simplification of the sd driver command handling.
> 
> Patch 1 to 5 introduce the zone locking helpers in the block layer and modify
> the deadline and mq-deadline schedulers.
> Patch 6 and 7 remove the SCSI layer zone locking and initialize the device
> request queue zone information.
> 
> All patches apply without conflicts to the scsi tree branch 4.16/scsi-queue, to
> the block tree branch for-linus as well as to the current 4.15-rc4 tree.
> 
> Of note is that this series imposes the use of the deadline and mq-deadline
> schedulers with zoned block devices. A system can trivialy enforce this using
> a udev rule such as:
> 
> ACTION=="add|change", KERNEL=="sd[a-z]", ATTRS{queue/zoned}=="host-managed", \
> ATTR{queue/scheduler}="deadline"
> 
> This rules applies equally for the legacy SCSI path as well as the scsi-mq path
> thanks to "mq-deadline" being aliased to "deadline".
> 
> Comments are as always very much appreciated.

This looks OK for me for 4.16. I can grab all of them, or I can leave
the last two for Martin to apply if he prefers that, though that will
add a block tree dependency for SCSI.

Martin?

-- 
Jens Axboe

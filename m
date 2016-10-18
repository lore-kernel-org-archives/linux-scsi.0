From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v8 0/7] ZBC / Zoned block device support
Date: Tue, 18 Oct 2016 09:58:00 -0600
Message-ID: <2a80d950-c831-9ac6-1969-dc6386e58236@kernel.dk>
References: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1476772835-18541-1-git-send-email-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

On 10/18/2016 12:40 AM, Damien Le Moal wrote:
> This series introduces support for zoned block devices. It integrates
> earlier submissions by Hannes Reinecke and Shaun Tancheff. Compared to the
> previous series version, the code was significantly simplified by limiting
> support to zoned devices satisfying the following conditions:
> 1) All zones of the device are the same size, with the exception of an
>    eventual last smaller runt zone.
> 2) For host-managed disks, reads must be unrestricted (read commands do not
>    fail due to zone or write pointer alignement constraints).
> Zoned disks that do not satisfy these 2 conditions are ignored.
>
> These 2 conditions allowed dropping the zone information cache implemented
> in the previous version. This simplifies the code and also reduces the memory
> consumption at run time. Support for zoned devices now only require one bit
> per zone (less than 8KB in total). This bit field is used to write-lock
> zones and prevent the concurrent execution of multiple write commands in
> the same zone. This avoids write ordering problems at dispatch time, for
> both the simple queue and scsi-mq settings.
>
> The new operations introduced to suport zone manipulation was reduced to
> only the two main ZBC/ZAC defined commands: REPORT ZONES (REQ_OP_ZONE_REPORT)
> and RESET WRITE POINTER (REQ_OP_ZONE_RESET). This brings the total number of
> operations defined to 8, which fits in the 3 bits (REQ_OP_BITS) reserved for
> operation code in bio->bi_opf and req->cmd_flags.
>
> Most of the ZBC specific code is kept out of sd.c and implemented in the
> new file sd_zbc.c. Similarly, at the block layer, most of the zoned block
> device code is implemented in the new blk-zoned.c.
>
> For host-managed zoned block devices, the sequential write constraint of
> write pointer zones is exposed to the user. Users of the disk (applications,
> file systems or device mappers) must sequentially write to zones. This means
> that for raw block device accesses from applications, buffered writes are
> unreliable and direct I/Os must be used (or buffered writes with O_SYNC).
>
> Access to zone manipulation operations is also provided to applications
> through a set of new ioctls. This allows applications operating on raw
> block devices (e.g. mkfs.xxx) to discover a device zone layout and
> manipulate zone state.

This is starting to look mergeable to me. Any objections in getting this
applied for 4.10? Looks like 6/7 should go through the SCSI tree, but I
can queue up the rest.

-- 
Jens Axboe


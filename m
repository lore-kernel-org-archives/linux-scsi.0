From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 0/9] block/scsi: Implement SMR drive support
Date: Sat, 9 Apr 2016 01:35:07 +0700
Message-ID: <CAJVOszAp_u2JQcDxbVatPKkFN7TKp7kxqauBBvSrmcWjeuSYDg@mail.gmail.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:63608 "EHLO
	mx0b-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265AbcDHSf2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2016 14:35:28 -0400
Received: from pps.filterd (m0075028.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u38IYXAx042656
	for <linux-scsi@vger.kernel.org>; Fri, 8 Apr 2016 14:35:27 -0400
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com [209.85.161.177])
	by mx0b-00003501.pphosted.com with ESMTP id 226j0tr0gb-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2016 14:35:27 -0400
Received: by mail-yw0-f177.google.com with SMTP id t10so144702582ywa.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2016 11:35:27 -0700 (PDT)
In-Reply-To: <1459764020-126038-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On Mon, Apr 4, 2016 at 5:00 PM, Hannes Reinecke <hare@suse.de> wrote:
> Hi all,
>
> here's a patchset implementing SMR (shingled magnetic recording)
> device support for the block and SCSI layer.
>
> There are two main parts to it:
> - mapping the 'RESET WRITE POINTER' command to the 'discard' functionality.
>   The 'RESET WRITE POINTER' operation is pretty close to the existing
>   'discard' functionality with the 'discard_zeroes_blocks' bit set.
>   So I've added a new 'reset_wp' provisioning mode for this.

Completely agree with the REQ_OP_DISCARD -> Reset WP translation
seems like a good idea. I have tried something similar and ended up
essentially adding a 'reset wp' flag instead.
Now I am optimistic to see if I can use you patch to get the
discard -> reset wp working in my device mapper.

> - Adding a 'zone' pointer to the request queue. This pointer holds an
>   RB-tree with the zone information, which can be used by other layers
>   to access the write pointer.

Here is where I have some concerns. Having a common in-kernel
shadow of the drive's zone state seems problematic to me.

Also if I am understanding the direction here it is to hold the zone
information in an rbtree. Since that comes to just under 30,000
entries I think it would be better to shift to an array of
write pointer offsets.

At the moment my translation layer keeps track of activity and state
of all the zones on the drive so that is how I have been handling
the zone data up to this point.

> This is the third part of a larger patchset for ZAC/ZBC support;
> it requires the scsi trace fixes queued for in mkp/4.7/scsi-queue and
> the patchsets 'libata: SATL update' and 'libata: ZAC support' I've
> posted earlier.
> The full patchset can be found at:
>
> git.kernel.org/hare/scsi-devel/h/zbc.v3
>
> As usual, comments and reviews are welcome.
>
> Hannes Reinecke (9):
>   blk-sysfs: Add 'chunk_sectors' to sysfs attributes
>   block: update chunk_sectors in blk_stack_limits()
>   sd: configure ZBC devices
>   sd: Implement new RESET_WP provisioning mode
>   block: Implement support for zoned block devices
>   block: Add 'zoned' sysfs queue attribute
>   block: Introduce BLKPREP_DONE
>   block: Add 'BLK_MQ_RQ_QUEUE_DONE' return value
>   sd: Implement support for ZBC devices
>
>  block/Kconfig           |   9 ++
>  block/Makefile          |   1 +
>  block/blk-core.c        |  11 +-
>  block/blk-mq.c          |   1 +
>  block/blk-settings.c    |   3 +
>  block/blk-sysfs.c       |  74 +++++++++
>  block/blk-zoned.c       |  70 +++++++++
>  drivers/scsi/Kconfig    |   8 +
>  drivers/scsi/Makefile   |   1 +
>  drivers/scsi/scsi_lib.c |   4 +
>  drivers/scsi/sd.c       | 267 ++++++++++++++++++++++++++++---
>  drivers/scsi/sd.h       |  44 ++++++
>  drivers/scsi/sd_zbc.c   | 411 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/blk-mq.h  |   1 +
>  include/linux/blkdev.h  |  48 ++++++
>  15 files changed, 933 insertions(+), 20 deletions(-)
>  create mode 100644 block/blk-zoned.c
>  create mode 100644 drivers/scsi/sd_zbc.c
>
> --
> 1.8.5.6
>



-- 
Shaun Tancheff

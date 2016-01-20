From: Ewan Milne <emilne@redhat.com>
Subject: Re: scsi-debug regression with 4.5-rc?
Date: Wed, 20 Jan 2016 10:17:31 -0500
Message-ID: <1453303051.22112.110.camel@localhost.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934133AbcATPRc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 10:17:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Alasdair G Kergon <agk@redhat.com>

So I have a report from our test people that the optimal_io_size sysfs
value is now different by a factor of 512 from what it used to be...

>Here is what is executed:
>
>modprobe scsi_debug dev_size_mb=32 sector_size=4096 opt_blks=64
>num_tgts=1
>
>And here is what our test is capturing:
>
>/sys/dev/block/8:0/queue/optimal_io_size = 512 differs from expected
>value 
>1048576!
>
>
>(So with 64 it's 512,  with opt_blks=256 it's 2048,  but it used to be
>1048576)

This looks like it might be due to commit:

commit ca369d51b3e1649be4a72addd6d6a168cfb3f537
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Fri Nov 13 16:46:48 2015 -0500

    block/sd: Fix device-imposed transfer length limits

It would appear that this commit has changed the meaning of
the queue limits io_opt field to be 512-byte normalized
sectors instead of bytes.  Parts of the diff:

-       blk_queue_io_opt(sdkp->disk->queue,
-                        get_unaligned_be32(&buffer[12]) * sector_sz);

...

+       sdkp->opt_xfer_blocks = get_unaligned_be32(&buffer[12]);

...

+       if (sdkp->opt_xfer_blocks && sdkp->opt_xfer_blocks <= dev_max &&
+           sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS)
+               rw_max = q->limits.io_opt =
+                       logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
+       else
+               rw_max = BLK_DEF_MAX_SECTORS;


---

Was this intentional?  I would have thought we would not want to change
the usermode meaning of this field.

-Ewan



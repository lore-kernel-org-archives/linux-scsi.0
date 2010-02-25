From: scameron@beardog.cce.hp.com
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 11:18:26 -0600
Message-ID: <20100225171826.GC30797@beardog.cce.hp.com>
References: <20100225165901.GZ30797@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:1059 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab0BYRPS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 12:15:18 -0500
Content-Disposition: inline
In-Reply-To: <20100225165901.GZ30797@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, axboe@kernel.dk, scameron@beardog.cce.hp.com


BLK_DEF_MAX_SECTORS seems to act as a cap, as a MAXIMUM possible value for
q->limits->max_sectors in blk_queue_max_sectors,
but as a MINIMUM for q->limits.max_hw_sectors in blk_queue_max_hw_sectors.

Is that intentional?

Is this code in block/blk-settings.c correct?

void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
{
        if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
                max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
                printk(KERN_INFO "%s: set to minimum %d\n",
                       __func__, max_sectors);
        }

        if (BLK_DEF_MAX_SECTORS > max_sectors)
                q->limits.max_hw_sectors = q->limits.max_sectors = max_sectors;
        else {
                q->limits.max_sectors = BLK_DEF_MAX_SECTORS;
                q->limits.max_hw_sectors = max_sectors;
        }
}
EXPORT_SYMBOL(blk_queue_max_sectors);

void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
{
        if (BLK_DEF_MAX_SECTORS > max_sectors)
                q->limits.max_hw_sectors = BLK_DEF_MAX_SECTORS;
        else
                q->limits.max_hw_sectors = max_sectors;
}
EXPORT_SYMBOL(blk_queue_max_hw_sectors);



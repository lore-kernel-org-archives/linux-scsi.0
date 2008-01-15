From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Actually using the sg table/chain code
Date: Tue, 15 Jan 2008 09:52:17 -0600
Message-ID: <1200412337.9273.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58374 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbYAOPwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2008 10:52:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <Jens.Axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

I thought, now we had this new shiny code to increase the scatterlist
table size I'd try it out.  It turns out there's a pretty vast block
conspiracy that prevents us going over 128 entries in a scatterlist.

The first problems are in SCSI:  The host parameters sg_tablesize and
max_sectors are used to set the queue limits max_hw_segments and
max_sectors respectively (the former is the maximum number of entries
the HBA can tolerate in a scatterlist for each transaction, the latter
is a total transfer cap on the maxiumum number of 512 byte sectors).
The default settings, assuming the HBA doesn't vary them are
sg_tablesize at SG_ALL (255) and max_sectors at SCSI_DEFAULT_MAX_SECTORS
(1024).  A quick calculation shows the latter is actually 512k or 128
pages (at 4k pages), hence the persistent 128 entry limit.

However, raising max_sectors and sg_tablesize together still doesn't
help:  There's actually an insidious limit sitting in the block layer as
well.  This is what blk_queue_max_sectors says:

void blk_queue_max_sectors(struct request_queue *q, unsigned int
max_sectors)
{
	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
		printk("%s: set to minimum %d\n", __FUNCTION__, max_sectors);
	}

	if (BLK_DEF_MAX_SECTORS > max_sectors)
		q->max_hw_sectors = q->max_sectors = max_sectors;
 	else {
		q->max_sectors = BLK_DEF_MAX_SECTORS;
		q->max_hw_sectors = max_sectors;
	}
}

So it imposes a maximum possible setting of BLK_DEF_MAX_SECTORS which is
defined in blkdev.h to .... 1024, thus also forcing the queue down to
128 scatterlist entries.

Once I raised this limit as well, I was able to transfer over 128
scatterlist elements during benchmark test runs of normal I/O (actually
kernel compiles seem best, they hit 608 scatterlist entries).

So my question, is there any reason not to raise this limit to something
large (like 65536) or even eliminate it altogether?

James



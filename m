From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: Write cache on SATA drives?
Date: Sun, 03 Jul 2005 19:03:48 +0200
Message-ID: <m3hdfbizyj.fsf@merlin.emma.line.org>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com>
	<20050701062416.GQ2243@suse.de> <m3acl7ym7f.fsf@merlin.emma.line.org>
	<20050701083308.GZ2243@suse.de>
	<20050701084717.GA18306@merlin.emma.line.org>
	<20050701085412.GA2243@suse.de> <m38y0qnlt7.fsf@merlin.emma.line.org>
	<20050702070750.GL2243@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:5063 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261472AbVGCRD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jul 2005 13:03:57 -0400
In-Reply-To: <20050702070750.GL2243@suse.de> (Jens Axboe's message of "Sat, 2
	Jul 2005 09:07:55 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Matthias Andree <matthias.andree@gmx.de>, "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>, linux-scsi@vger.kernel.org

Jens Axboe <axboe@suse.de> writes:

>> Hm. Any buzz^Wkeywords to look for? "barrier" doesn't seem to be the
>> right word, it yields only memory barriers and an as-iosched fix in
>> 2.6.7.  I checked ChangeLog-2.6.[56789].
>
> Grep for blk_queue_ordered or similar in the patch.

patch-2.6.9 adds this function -- and a call to it to ide-disk.c. Have
reiserfs and ext3fs supported this from the very beginning (i. e. 2.6.9)
or is this an issue that affected only the lower layers anyhow?

/**
 * blk_queue_ordered - does this queue support ordered writes
 * @q:     the request queue
 * @flag:  see below
 *
 * Description:
 *   For journalled file systems, doing ordered writes on a commit
 *   block instead of explicitly doing wait_on_buffer (which is bad
 *   for performance) can be a big win. Block drivers supporting this
 *   feature should call this function and indicate so.
 *
 **/
void blk_queue_ordered(request_queue_t *q, int flag)
...

-- 
Matthias Andree

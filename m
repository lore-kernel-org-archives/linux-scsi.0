From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/1] random vs blk-mq
Date: Fri, 25 Apr 2014 08:22:51 -0600
Message-ID: <535A6FBB.6010902@kernel.dk>
References: <20140425073610.GA2143@infradead.org> <20140425140344.GG11124@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35692 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaDYOWy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2014 10:22:54 -0400
Received: by mail-pa0-f51.google.com with SMTP id fb1so2570110pad.24
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2014 07:22:53 -0700 (PDT)
In-Reply-To: <20140425140344.GG11124@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 04/25/2014 08:03 AM, Theodore Ts'o wrote:
> On Fri, Apr 25, 2014 at 12:36:10AM -0700, Christoph Hellwig wrote:
>> But this also brings up an interesting question:  blk-mq currently
>> does not set QUEUE_FLAG_ADD_RANDOM in the default queue flags, so
>> simply converting a driver to blk-mq will mean it stops contributing
>> to the random pool.  Do we need a more fine grained way to control
>> this, especially for SCSI?
> 
> In general, more fine grained control is always good.
> 
> But getting the defaults right is even more important.  It occurs to
> me that what might make sense is to turn on QUEUE_FLAG_ADD_RANDOM if
> we know that it is a rotational disk.  But in the case where we know
> it's a SSD or a NVMe, it's likely that add_disk_randomness() is not
> going to do much in the way that's useful, since we estimate entropy
> credits based on the jiffies delta, so if we interrupts more
> frequently than the 10ms, we're not going to get any entropy credit
> anyway.

This is exactly why the flag was added in the first place:

commit e2e1a148bc45855816ae6b4692ce29d0020fa22e
Author: Jens Axboe <jaxboe@fusionio.com>
Date:   Wed Jun 9 10:42:09 2010 +0200

    block: add sysfs knob for turning off disk entropy contributions

    There are two reasons for doing this:

    - On SSD disks, the completion times aren't as random as they
      are for rotational drives. So it's questionable whether they
      should contribute to the random pool in the first place.

    - Calling add_disk_randomness() has a lot of overhead.

-- 
Jens Axboe


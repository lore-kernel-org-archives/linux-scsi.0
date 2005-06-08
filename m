From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests	and simplify hw handlers
Date: Wed, 08 Jun 2005 08:59:01 -0400
Message-ID: <1118235541.5042.16.camel@mulgrave>
References: <1117847972.23638.62.camel@mina> <20050607180716.GA8172@suse.de>
	 <1118173118.4791.17.camel@mulgrave>  <42A65F5D.6060805@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26291 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261176AbVFHM7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jun 2005 08:59:17 -0400
In-Reply-To: <42A65F5D.6060805@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Jens Axboe <axboe@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Kai.Makisara@kolumbus.fi

On Wed, 2005-06-08 at 13:00 +1000, Douglas Gilbert wrote:
> A "char_uld" library that st, sg, ch and the proposed OSD
> ULDs could tap into, would cut the duplication. As you can
> see, Kai and I have shared implementations in this area but
> had no mechanism for sharing the actual code.

Well, yes, I've been asking for something like this for ages.  However,
with the new block APIs it seems that the character read and write paths
become very short, so it may no longer be worth it.

Also, I really don't think OSD should be a character device.  It's
definitely a block device, it just happens to have a two dimensional
address space instead of a one dimensional one.

> An idea I had was to flag what mechanism inserted a
> command onto a request queue and when a blk_pc_request()
> follows a blk_pc_request() then use FIFO order for
> the second one.

Really, I think it's cleaner for head or tail insertion to be handled at
the time the request is generated.  However, the block queues of
character taps are special; we certainly don't need all the elevator
merging machinery, so perhaps we should have a way of setting them up as
noop elevator?

James



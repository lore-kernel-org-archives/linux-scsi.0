From: Tejun Heo <htejun@gmail.com>
Subject: Re: [OOPS] 2.6.11 - NMI lockup with CFQ scheduler
Date: Wed, 06 Apr 2005 22:38:59 +0900
Message-ID: <4253E673.2000001@gmail.com>
References: <20050329122226.94666.qmail@web52902.mail.yahoo.com> <20050329122635.GP16636@suse.de> <20050406123147.GD9417@suse.de> <1112791930.6275.69.camel@laptopd505.fenrus.org> <20050406125536.GG9417@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.198]:10374 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262201AbVDFNjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2005 09:39:06 -0400
Received: by rproxy.gmail.com with SMTP id a41so166501rng
        for <linux-scsi@vger.kernel.org>; Wed, 06 Apr 2005 06:39:06 -0700 (PDT)
In-Reply-To: <20050406125536.GG9417@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 06 2005, Arjan van de Ven wrote:
> 
>>>@@ -324,6 +334,7 @@
>>> 	issue_flush_fn		*issue_flush_fn;
>>> 	prepare_flush_fn	*prepare_flush_fn;
>>> 	end_flush_fn		*end_flush_fn;
>>>+	release_queue_data_fn	*release_queue_data_fn;
>>> 
>>> 	/*
>>> 	 * Auto-unplugging state
>>
>>where does this function method actually get called?
> 
> 
> I missed the hunk in ll_rw_blk.c, rmk pointed the same thing out not 5
> minutes ago :-)
> 
> The patch would not work anyways, as scsi_sysfs.c clears queuedata
> unconditionally. This is a better work-around, it just makes the queue
> hold a reference to the device as well only killing it when the queue is
> torn down.
> 
> Still not super happy with it, but I don't see how to solve the circular
> dependency problem otherwise.
> 

  Hello, Jens.

  I've been thinking about it for a while.  The problem is that we're 
reference counting two different objects to track lifetime of one 
entity.  This happens in both SCSI upper and mid layers.  In the upper 
layer, genhd and scsi_disk (or scsi_cd, ...) are ref'ed separately while 
they share their destiny together (not really different entity) and in 
the middle layer scsi_device and request_queue does the same thing. 
Circular dependency is occuring because we separate one entity into two 
and reference counting them separately.  Two are actually one and 
necessarily want each other. (until death aparts.  Wow, serious. :-)

  IMHO, what we need to do is consolidate ref counting such that in each 
layer only one object is reference counted, and the other object is 
freed when the ref counted object is released.  The object of choice 
would be genhd in upper layer and request_queue in mid layer.  All 
ref-counting should be updated to only ref those objects.  We'll need to 
add a release callback to genhd and make request_queue properly 
reference counted.

  Conceptually, scsi_disk extends genhd and scsi_device extends 
request_queue.  So, to go one step further, as what UL represents is 
genhd (disk device) and ML request_queue (request-based device), 
embedding scsi_disk into genhd and scsi_device into request_queue will 
make the architecture clearer.  To do this, we'll need something like 
alloc_disk_with_udata(int minors, size_t udata_len) and the equivalent 
for request_queue.

  I've done this half-way and then doing it without fixing the SCSI 
model seemed silly so got into working on the state model.  (BTW, the 
state model is almost done, I'm about to run tests.)

  What do you think?  Jens?

-- 
tejun


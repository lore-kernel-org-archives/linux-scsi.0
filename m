From: "lk" <linux_kernel@patni.com>
Subject: Re:When & how is the SCSI strategy routine called?
Date: Tue, 22 Mar 2005 23:58:54 -0800
Message-ID: <01a701c52f7e$290d9d30$5e91a8c0@patni.com>
Reply-To: "lk" <linux_kernel@patni.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Received: from pcsmail.patni.com ([203.124.139.197]:47514 "EHLO
	pcsmail.patni.com") by vger.kernel.org with ESMTP id S261246AbVCWH6p
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 02:58:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, rajatj@noida.hcltech.com, linux-newbie@vger.kernel.org

This is my understanding.
scsi_request_fn is the scsi's request function which performs the actual
data
transfer. clean up the queue and loop back to fetch next request.

About the Question:WHEN and HOW is the strategy routine "scsi_request_fn()"
called ?

Every request queue have a few members to decide whether to call
scsi_request_fn() or not. scsi_request_fn is called after the queue is
unplugged.

  request_queue_t->unplug_thresh
  Whenever request queue is about to get full. which is the number of
  requests after which the queue should be unplugged. unplugging of request
  will in turn call scsi_request_fn().

  request_queue_t->unplug_timer
  After this much time the queue will be unplugged to rip the IO in turn
  it will call scsi_request_fn().

  Also in case of Async Direct IO the block layer will unplug the queue
after
  submission of  bios to queue by calling blk_run_address_space function.

  scsi_request_fn will be called whenever the block layer calls queue unplug
or
  queue is about to get full or after a certain unplug timer value.

   Hope it helps.


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Rajat Jain, Noida
Sent: Tuesday, March 22, 2005 8:31 AM
To: linux-scsi@vger.kernel.org; linux-newbie@vger.kernel.org
Cc: Rajat Jain, Noida
Subject: When & how is the SCSI strategy routine called?


Hi list,

Tracing the kernel 2.6.8 code I found that scsi_mod maintains separate
request queues for each SCSI device. It uses the block layer queuing
facility to do this. What I could not find out was that once a request is
queued into a queue (for a particular device), WHEN and HOW is the strategy
routine "scsi_request_fn()" called ?

All I could find on the net was that "The kernel calls the strategy routine
when ever it believes that it is appropriate to invoke it."

Please help ... Any pointers will be highly appreciated.

TIA,

Rajat




From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: RE: When & how is the SCSI strategy routine called?
Date: Wed, 23 Mar 2005 14:19:25 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB06043621@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-newbie-owner@vger.kernel.org
To: lk <linux_kernel@patni.com>, linux-scsi@vger.kernel.org, rajatj@noida.hcltech.com, linux-newbie@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 

Thanks lk.

It cleared a lot of things.

How ever, what I am wondering is:

- Does each device queue have a corresponding thread that is woken up when
it is time to call the request function? And the request function is called
in the context of this thread?

- I explored and found that there is some "worker thread" kblockd that does
this task of monitoring the queue and calling the request function. I want
to know whether there is a separate thread for each queue (device) , or just
one for all the block devices?

TIA,

Rajat


-----Original Message-----
From: lk [mailto:linux_kernel@patni.com] 
Sent: Wednesday, March 23, 2005 1:29 PM
To: linux-scsi@vger.kernel.org; rajatj@noida.hcltech.com;
linux-newbie@vger.kernel.org
Subject: Re:When & how is the SCSI strategy routine called?

This is my understanding.
scsi_request_fn is the scsi's request function which performs the actual
data transfer. clean up the queue and loop back to fetch next request.

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




Disclaimer: 

This message and any attachment(s) contained here are information that is
confidential,proprietary to HCL Technologies and its customers, privileged
or otherwise protected by law.The information is solely intended for the
individual or the entity it is addressed to. If you are not the intended
recipient of this message, you are not authorized to read, forward,
print,retain, copy or disseminate this message or any part of it. If you
have received this e-mail in error, please notify the sender immediately by
return e-mail and delete it from your computer.


-
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs

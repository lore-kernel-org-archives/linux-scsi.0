From: Luben Tuikov <luben@splentec.com>
Subject: [RFC]: 64 bit LUN/Tags, dummy device in host_queue, host_lock <-> LLDD
 reentrancy
Date: Fri, 23 Aug 2002 16:27:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D669AC2.4C5D522A@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7NKRh123027
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2002 16:27:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Here's some of the things which have been looming in my mind for
some time now. Nothing important really, but I felt at least to
share it with you guys, just to keep in mind, that's all.
Comment at will.


* SAM-3 specifies that a LUN is 64 bit. While there may not
be any devices which actually even come close to using this
huge space, it provides different _addressing__modes_.

This very nicely fits LUN virtualization (iSCSI, LUN masking, etc),
and would allow one to do magic for storage devices (IP SANs, etc).

A 64 bit LUN could be presented to userspace which may/can then
present a nice ``picture'' (GUI or what not) of the underlying
physical/virtual (depending on the SCSI port name/id) storage
network.

(E.g. iSCSI communicates 64 bit LUNs only...)


* SAM-3 specifies that tags are 64 bit. It is not inconcievable that
a Task Manager (LUN structure, SAM-3, 4.8, 4.12) would use
those tags to order/id/whatnot the tasks it receives for
execution.

A really, leally long shot: Now that they are being moved up to
the block layer, it may be convenient to define them as such.


* In scsi_scan.c :: void scan_scsis(), select_queue_depths() is called
when there is a _dummy_ device in host_queue. This comes from
doing that juggle with SDpnt and oldSDpnt, allocating it in one
place and freeing it in another...

So when select_queue_depths() is called, in the host_queue, there's
_one__more_ device than there really should be, because of that SDpnt/oldSDpnt.

I filter the dummy SDpnt in select_queue_depths() by checking
vendor, model, rev and attached. But I'd rather
just get only the _actual_ devices in the host_queue, by
probably getting rid of that SDpnt/oldSDpnt juggle logic.


* It seems to me that the host_lock exists just to indirectly
impose/hint/etc. reentrancy of the LLDD methods exposed to the kernel.

Isn't the next step to stipulate that all methods of LLDDs should
be renentrant in and of themselves (which are exposed to the kernel
of course). That is, they'll have to achieve their own reentrancy
via their own locks and queues. Wouldn't this be a cleaner approach?

The kernel will have one less thing to worry about.

I realize that some LLDD will be really easy to convert and
other will have to undergo deep surgery, but this kind
of reentrancy seems to be implied by the host lock.

-- 
Luben

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Q] In sg_io_v4 what to use as flag for "queue at_head"
Date: Wed, 21 Jan 2009 14:31:29 +0900
Message-ID: <20090121143109A.fujita.tomonori@lab.ntt.co.jp>
References: <49746197.200@panasas.com>
	<4974BBC5.3080001@interlog.com>
	<497577C5.6080604@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48486 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbZAUFbx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jan 2009 00:31:53 -0500
In-Reply-To: <497577C5.6080604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: dgilbert@interlog.com, dougg@torque.net, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

On Tue, 20 Jan 2009 09:05:41 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Douglas Gilbert wrote:
> > 
> > or (adding "_TA_" for task attribute):
> >    enum {
> >          BSG_TA_DEFAULT = 0,  // lk 2.4, 2.6 series: head of queue
> >          BSG_TA_HEAD_OF_Q = 0x1000,
> >          BSG_TA_SIMPLE,
> >          BSG_TA_ORDERED,
> >          BSG_TA_ACA,
> >          ....
> 
> BSG_TA_HEAD_OF_Q I understand that's like today. What are the meaning
> of the other values? Anyway I only have 2 values to implement I don't want
> to add more values then I use, and have to comment NOT SUPPORTED next
> to them. When used I can add them later.

No, as Doug said, the request_attr is for SCSI task attribute. Other
protocols could use the protocol specific purpose. It's not for
Linux's request queue.


> Please Note that I was asking about the at_head=0/1 of the
> blk_execute_rq_xxx calls. This means that it is not transport
> specific at all, it is a Boolean behavior common to all transports,
> governed by the request submission layer.

Does 'at_head' matter? I think that blk_execute_rq_nowait inserts a
request and plugs a queue either way with queue_lock held.


> If task_attribute is something related to SAM-4 then surly that is not it, because
> I'm looking for a flag that is independent of scsi. If later I will need that SAM-4
> thing it will be taken.
> 
> > 
> > I would prefer using the request_attr field.
> > 
> > Tomo, what do you think?
> > 
> > 
> > Doug Gilbert
> 
> And please, you never explained, what is "request_priority" for?
> What was your original intention?

Wasn't it obvious? :)

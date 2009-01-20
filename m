From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Q] In sg_io_v4 what to use as flag for "queue at_head"
Date: Tue, 20 Jan 2009 14:27:55 -0500
Message-ID: <497625BB.4020609@interlog.com>
References: <49746197.200@panasas.com> <4974BBC5.3080001@interlog.com> <497577C5.6080604@panasas.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:41771 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZATT2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 14:28:05 -0500
In-Reply-To: <497577C5.6080604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Douglas Gilbert <dougg@torque.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Boaz Harrosh wrote:
> Douglas Gilbert wrote:
>> or (adding "_TA_" for task attribute):
>>    enum {
>>          BSG_TA_DEFAULT = 0,  // lk 2.4, 2.6 series: head of queue
>>          BSG_TA_HEAD_OF_Q = 0x1000,
>>          BSG_TA_SIMPLE,
>>          BSG_TA_ORDERED,
>>          BSG_TA_ACA,
>>          ....
> 
> BSG_TA_HEAD_OF_Q I understand that's like today. What are the meaning
> of the other values? Anyway I only have 2 values to implement I don't want
> to add more values then I use, and have to comment NOT SUPPORTED next
> to them. When used I can add them later.
> 
> Please Note that I was asking about the at_head=0/1 of the blk_execute_rq_xxx
> calls. This means that it is not transport specific at all, it is a Boolean behavior
> common to all transports, governed by the request submission layer.
> If task_attribute is something related to SAM-4 then surly that is not it, because
> I'm looking for a flag that is independent of scsi. If later I will need that SAM-4
> thing it will be taken.
> 
>> I would prefer using the request_attr field.
>>
>> Tomo, what do you think?
>>
>>
>> Doug Gilbert
> 
> And please, you never explained, what is "request_priority" for?
> What was your original intention?

Boaz,
As my comment indicates "request_priority" is "task priority" in
SCSI. I should have added "... in SAM-3" because the good folks
at t10 changed that to "command priority" in SAM-4 (sam4r14.pdf
section 8.7). [I didn't like the term "task ..." either which is
one reason why I used "request ...".]

So the "queue" that I'm talking about is the one on the device
(target or LU, take your pick). A SCSI pass-through wants the
thinnest possible layer between itself and the SCSI initiator,
so in that context I view a queue in the scsi mid-level or
a LLD as evil.

Note also that several SCSI commands have an implicit "head of
queue" attribute (e.g. INQUIRY and REPORT LUNS) within the
device.

Doug Gilbert



From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Wed, 13 Oct 2004 12:10:21 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416C8E8D.7050000@torque.net>
References: <20041012000058.GA26569@osdl.org>	<eada2a07041012092973d35415@mail.gmail.com> 	<20041012165919.GA27526@osdl.org> <1097601199.2044.91.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:30476 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S268294AbUJMDoL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 23:44:11 -0400
In-Reply-To: <1097601199.2044.91.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Dave Olien <dmo@osdl.org>, Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Tue, 2004-10-12 at 11:59, Dave Olien wrote:
> 
>>Thanks for the feedback.  Yes, Automatic volume transfer is on, and I
>>was expecting there'd be poor performance as a result.  I just
>>didn't expect to get IO errors.  The odd thing is that the "bus reset"
>>leads to the SCSI request being requeued.  But every once in a while,
>>the requeue fails with errors and the request is failed.  I'll look at
>>these cases a little more closely, try to understand why the requeues fail.
> 
> 
> Hang on a minute ... if you're ping pong'ing the drives using AVT, those
> transfers take time to achieve.  The device is probably returning UNIT
> ATTENTION, NOT_READY while the transfer is in progress.  This is
> probably the source of the requeue.

UNIT ATTENTION and NOT READY are both sense keys so a
device can't yield both on one command. However you may be
on the right track as there is an ever increasing number of
reasons a device could issue a UNIT ATTENTION. [See SPC-3
rev 21 and I believe these ASC codes (and all their associated
ASCQ codes) occur with a sense key of UNIT ATTENTION:
0x28, 0x29, 0x2a, 0x3f, 0x5b/0x1 and 0x5d.]

Unlikely in this case but a sense key of UNIT ATTENTION
(or perhaps RECOVERED ERROR)  with an additional sense
of "Hardware impending failure, seek error rate too high"
may slip by without even a log entry.

> As for the error, I still don't understand that, but it looks like
> something went wrong in setting up or tearing down the dma mapping, so
> that it was incorrectly described when this happened a second time.

I hope to address the code in the scsi_io_completion() error/warning
processing paths with the descriptor_sense cleanup. There seems to
be a missing scsi_print_sense() call on the UNIT ATTENTION path.

Dave, does your log show a bus error (ASC/ASCQ=0x29/0x2) has occurred?

Doug Gilbert


From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: 12 Oct 2004 12:13:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097601199.2044.91.camel@mulgrave>
References: <20041012000058.GA26569@osdl.org>
	<eada2a07041012092973d35415@mail.gmail.com>
	<20041012165919.GA27526@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45968 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266349AbUJLRNa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 13:13:30 -0400
In-Reply-To: <20041012165919.GA27526@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Dave Olien <dmo@osdl.org>
Cc: Tim Pepper <tpepper@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-12 at 11:59, Dave Olien wrote:
> Thanks for the feedback.  Yes, Automatic volume transfer is on, and I
> was expecting there'd be poor performance as a result.  I just
> didn't expect to get IO errors.  The odd thing is that the "bus reset"
> leads to the SCSI request being requeued.  But every once in a while,
> the requeue fails with errors and the request is failed.  I'll look at
> these cases a little more closely, try to understand why the requeues fail.

Hang on a minute ... if you're ping pong'ing the drives using AVT, those
transfers take time to achieve.  The device is probably returning UNIT
ATTENTION, NOT_READY while the transfer is in progress.  This is
probably the source of the requeue.

As for the error, I still don't understand that, but it looks like
something went wrong in setting up or tearing down the dma mapping, so
that it was incorrectly described when this happened a second time.

James



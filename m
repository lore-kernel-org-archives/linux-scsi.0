From: Dave Olien <dmo@osdl.org>
Subject: Re: Question about Request Sense case in scsi_lib.c
Date: Tue, 12 Oct 2004 09:59:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041012165919.GA27526@osdl.org>
References: <20041012000058.GA26569@osdl.org> <eada2a07041012092973d35415@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:16003 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266221AbUJLQ7W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Oct 2004 12:59:22 -0400
Content-Disposition: inline
In-Reply-To: <eada2a07041012092973d35415@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: Tim Pepper <tpepper@gmail.com>, linux-scsi@vger.kernel.org


Tim,

Thanks for the feedback.  Yes, Automatic volume transfer is on, and I
was expecting there'd be poor performance as a result.  I just
didn't expect to get IO errors.  The odd thing is that the "bus reset"
leads to the SCSI request being requeued.  But every once in a while,
the requeue fails with errors and the request is failed.  I'll look at
these cases a little more closely, try to understand why the requeues fail.

I think the dm multipathing software will soon have hooks to
support manual volume transfer in these situations.

Dave

On Tue, Oct 12, 2004 at 09:29:30AM -0700, Tim Pepper wrote:
> I thought on FAStT's while there are dual-active controllers, for a
> given lun they weren't active-active, but rather active-passive with
> either manual or automatic volume transfer.  Assuming automatic volume
> transfer is on and you send IOs to both controllers simultaneously you
> would ping-pong the cache, drive IO rates lower and possibly see that
> manifest itself in interesting behaviour in the linux scsi stack. 
> With manual volume transfer you should get IO errors from the
> controller which is not active or preferred for the given lun.  Maybe
> somebody involved with their RDAC multipathing driver follows this
> list and can comment on their intentions for the 2.6 kernel and dm
> multipathing.

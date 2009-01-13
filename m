From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] sg: fix races during device removal (v2)
Date: Wed, 14 Jan 2009 01:24:40 +0900
Message-ID: <20090114012436T.fujita.tomonori@lab.ntt.co.jp>
References: <49625A67.3000304@cybernetics.com>
	<20090111022525I.fujita.tomonori@lab.ntt.co.jp>
	<496BB185.7080008@cybernetics.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33962 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbZAMQZF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2009 11:25:05 -0500
In-Reply-To: <496BB185.7080008@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Mon, 12 Jan 2009 16:09:25 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> So we can accomplish the same effect with my patch just by removing the
> wait_event() in sg_remove() and the other code associated with it.  Now
> the question is - do we still want to use krefs for the sg_fd?  I had
> considered it when coming up with my patch, but I decided not to add the
> overhead of two extra atomic ops per command.  Atomic ops for opening
> and closing fds are OK, but I didn't want to slow down the command
> processing critical paths.  I haven't measured the overhead, so maybe it
> isn't too bad, but it is something to consider.

kref_get() adds nothing. We already have lots of atomic_inc per scsi
command. Compared with the rest of the overhead of scsi command
processing, kref_get is simply nothing.


> Also, I spent a lot of time analyzing locks and potential races with my
> patch, and your patch reverts some of the fixes that I incorporated in
> my patch.  Just to point out one example that I spotted quickly:
> sg_rq_end_io() needs to check srp->orphan and set srp->done = 1 while
> holding sfp->rq_list_lock to avoid races with sg_ioctl(SG_IO) (see my
> [PATCH 2/2] sg: fix races with ioctl(SG_IO)).

Yeah, I know that sg has other races but let's fix the most critical
one first.

BTW, I think that we can do better about srp->done too.


>  But if you really want to
> go with a kref on sg_fd and get/put on every command, let me know and I
> will check and test everything again in detail.  If not, I will resubmit
> my patch with the wait_event and associated code removed.

Using kref for lifetime management is pretty common in Linux
kernel. Other developers can easily understand the code. For example,
scsi mid-layer calls get_device() on every command, which is similar
to what we need to solve about sg_fd and commands. So I like this way
but if you can fix the lifetime of sg_dev and sg_fd in a simpler way
than my patch (less lines), then we need to consider about it.

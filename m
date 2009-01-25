From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] sg: fix races with ioctl(SG_IO) (v2)
Date: Sun, 25 Jan 2009 21:46:23 +0900
Message-ID: <20090125214644O.fujita.tomonori@lab.ntt.co.jp>
References: <497506AF.6040109@cybernetics.com>
	<20090120100451Q.fujita.tomonori@lab.ntt.co.jp>
	<49764969.5090708@cybernetics.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46941 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148AbZAYMqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2009 07:46:47 -0500
In-Reply-To: <49764969.5090708@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, dgilbert@interlog.com, hch@infradead.org, linux-scsi@vger.kernel.org

On Tue, 20 Jan 2009 17:00:09 -0500
Tony Battersby <tonyb@cybernetics.com> wrote:

> sg_io_owned needs to be set before the command is sent to the midlevel;
> otherwise, a quickly-completing command may cause a different CPU
> to see "srp->done == 1 && !srp->sg_io_owned", which would lead to
> incorrect behavior.
> 
> Check srp->done and set srp->orphan while holding rq_list_lock to
> prevent races with sg_rq_end_io().
> 
> There is no need to check sfp->closed from read/write/ioctl/poll/etc.
> since the kernel guarantees that this won't happen.
> 
> The usefulness of sg_srp_done() was questionable before; now it is
> definitely not needed.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> 
> Compared to the previous version of this patch, this version removes
> sg_srp_done() and the unnecessary check for sfp->closed.
> 
>  sg.c |   39 ++++++++++++++-------------------------

It looks ok to me. Better (simpler) than the first version.

I guess that we could simplify 'done' and 'orphan' stuff a bit more
but we can do later on.

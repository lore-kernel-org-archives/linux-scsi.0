From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: fix q->queue_lock on scsi_error_handler path
Date: Fri, 03 Apr 2009 11:11:52 -0400
Message-ID: <49D62738.9010807@interlog.com>
References: <20090403192745E.fujita.tomonori@lab.ntt.co.jp>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:51345 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759984AbZDCPL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 11:11:59 -0400
In-Reply-To: <20090403192745E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> This is a fix for another fallout of the block layer conversion (sorry
> again).
> 
> This should be go into 2.6.28.y and 2.6.29.y.
> 
> However, this should go with patches that I sent for 2.6.29.1 and
> were dropped. So I don't use 'stable@kernel.org' tag.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] [PATCH] sg: fix q->queue_lock on scsi_error_handler path
> 
> sg_rq_end_io() is called via rq->end_io. In some rare cases,
> sg_rq_end_io calls blk_put_request/blk_rq_unmap_user (when a program
> issuing a command has gone before the command completion; e.g. by
> interrupting a program issuing a command before the command
> completes).
> 
> We can't call blk_put_request/blk_rq_unmap_user in interrupt so the
> commit c96952ed7031e7c576ecf90cf95b8ec099d5295a uses
> execute_in_process_context().
> 
> The problem is that scsi_error_handler() calls rq->end_io too. We
> can't call blk_put_request/blk_rq_unmap_user too in this path (we hold
> q->queue_lock).
> 
> To avoid the above problem, in these rare cases, this patch always
> uses schedule_work() instead of execute_in_process_context().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

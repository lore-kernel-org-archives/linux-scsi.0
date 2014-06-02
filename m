From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove two cancel_delayed_work() calls from the mid-layer
Date: Mon, 2 Jun 2014 04:32:51 -0700
Message-ID: <20140602113251.GB26951@infradead.org>
References: <538C48FC.5000803@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBLc6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 07:32:58 -0400
Content-Disposition: inline
In-Reply-To: <538C48FC.5000803@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Jun 02, 2014 at 11:50:52AM +0200, Bart Van Assche wrote:
> scsi_put_command() is either invoked before blk_start_request() or
> after block layer processing has completed.  scsi_cmnd.abort_work
> is scheduled from inside the SCSI timeout handler.  The block layer
> guarantees that either the regular completion handler
> (softirq_done_fn()) or the timeout handler (rq_timed_out_fn()) is
> invoked but not both. This means that scsi_put_command() is never
> invoked while abort_work is scheduled.  Hence remove the
> cancel_delayed_work() call from scsi_put_command().
> 
> Similarly, scsi_abort_command() is only invoked from the SCSI
> timeout handler. If scsi_abort_command() is invoked for a SCSI
> command with the SCSI_EH_ABORT_SCHEDULED flag set this means that
> scmd_eh_abort_handler() has already invoked scsi_queue_insert() and
> hence that scsi_cmnd.abort_work is no longer pending. Hence also
> remove the cancel_delayed_work() call from scsi_abort_command().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

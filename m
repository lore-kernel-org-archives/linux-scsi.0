From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Fri, 07 Feb 2014 11:30:55 -0800
Message-ID: <1391801455.1155.26.camel@haakon3.risingtidesystems.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124021.286457268@bombadil.infradead.org>
	 <1391705819.22335.8.camel@dabdike> <52F3C21F.70409@acm.org>
	 <1391723900.14985.3.camel@haakon3.risingtidesystems.com>
	 <52F4B622.1070900@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50613 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaBGT2R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 14:28:17 -0500
In-Reply-To: <52F4B622.1070900@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On Fri, 2014-02-07 at 11:32 +0100, Bart Van Assche wrote:
> On 02/06/14 22:58, Nicholas A. Bellinger wrote:
> > Starting with a baseline using scsi_debug that NOPs REQ_TYPE_FS commands
> > to measure improvements would be a better baseline vs. scsi_request_fn()
> > existing code that what your doing above.
> > 
> > That way at least it's easier to measure specific scsi-core overhead
> > down to the LLD's queuecommand without everything else in the way.
> 
> Running initiator and target workload on the same system makes initiator
> and target code share CPUs and hence makes it hard to analyze which
> performance change is caused by initiator optimizations and which
> performance change is caused by interactions between initiator and
> target workloads.
> 

Huh..?  There is no 'target workload' involved.

All that scsi_debug with NOP'ed REQ_TYPE_FS commands is doing is calling
scsi_cmd->done() as soon as the descriptor has been dispatched into LLD
->queuecommand() code.

It's useful for determining an absolute performance ceiling between
scsi_mq vs. scsi_request_fn() based codepaths without involving any
other LLD specific overheads.

--nab


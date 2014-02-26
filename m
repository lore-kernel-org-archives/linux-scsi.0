From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into scsi_{host,target}_queue_ready
Date: Wed, 26 Feb 2014 16:39:49 +0100
Message-ID: <530E0AC5.60101@acm.org>
References: <20140205123930.150608699@bombadil.infradead.org> <20140205124021.286457268@bombadil.infradead.org> <1391705819.22335.8.camel@dabdike> <20140210113932.GA31405@infradead.org> <20140210200934.GA4096@kernel.dk> <5301D814.5070100@acm.org> <20140217220057.GB30101@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.6]:41174 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaBZPjx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 10:39:53 -0500
In-Reply-To: <20140217220057.GB30101@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On 02/17/14 23:00, Christoph Hellwig wrote:
> Most of the scsi multiqueue work so far has been about modifying the
> block layer, so I'm definitively now shy about doing that were needed.
> And I think we will eventually need to be able to have n:m queue to hctx
> mapping instead of the current 1:n one.

I think it would be great if the blk-mq core would support an n:m queue
to hctx mapping. One of the advantages of that approach would be that
the blk-mq layer already keeps track of how many commands are queued per
hctx and hence that would allow to eliminate the host_busy counter from
the SCSI mid-layer. However, this involves a change in semantics. I hope
it's fine to change the semantics of the hosts->can_queue parameter from
"maximum number of commands queued per SCSI host" into "maximum number
of commands queued per hctx" ?

Bart.

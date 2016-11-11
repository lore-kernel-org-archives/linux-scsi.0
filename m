From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] hpsa: scsi-mq support
Date: Fri, 11 Nov 2016 08:35:32 -0800
Message-ID: <20161111163532.GA14922@infradead.org>
References: <1478879194-32529-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60340 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbcKKQfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2016 11:35:38 -0500
Content-Disposition: inline
In-Reply-To: <1478879194-32529-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>

On Fri, Nov 11, 2016 at 04:46:34PM +0100, Hannes Reinecke wrote:
> This patch enables full scsi-mq support for the hpsa driver.
> Due to some reports of performance regressions this patch
> also adds a parameter 'use_blk_mq' which can be used to
> disable multiqueue support if required.

This patch looks odd to me.  The hardware does not seem to support
multiple submission queues, which makes exposing nr_hw_queues > 1
rather pointless given that the block layer (using blk-mq or the legacy
path) can already steer completions to the submitting cpu.

You also mention there are performance regressions, but don't talk
about any benefits.  I also think per-driver module parameters for this
are generally a rather bad idea.

So what exactly are the benefits of this MQ-mode for a single submission
queue device, and what do we need to do to get these without lying about
the number of submission queues?

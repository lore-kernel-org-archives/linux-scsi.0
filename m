From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] virtio_scsi: support multi hw queue of blk-mq
Date: Mon, 10 Nov 2014 17:05:06 +0100
Message-ID: <20141110160506.GB15315@lst.de>
References: <1415552224-31145-1-git-send-email-ming.lei@canonical.com> <1415552224-31145-3-git-send-email-ming.lei@canonical.com> <54609667.8030702@redhat.com> <20141110133930.GA3115@lst.de> <CACVXFVMdUVfXNoC0FDhmaQtxehCBgG3xnTx-PJ3BmoQaT1LsoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36208 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaKJQFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 11:05:09 -0500
Content-Disposition: inline
In-Reply-To: <CACVXFVMdUVfXNoC0FDhmaQtxehCBgG3xnTx-PJ3BmoQaT1LsoQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, Linux SCSI List <linux-scsi@vger.kernel.org>

On Mon, Nov 10, 2014 at 10:25:43PM +0800, Ming Lei wrote:
> It depends on how long the transition period is, and other drivers
> with multi hwq support might be in the same situation with virtio-scsi. If
> the period is a bit long, it would be painful for these drivers to support
> both blk-mq and non-mq.

If it's too long we need to find better ways to control the behavior.  But
honestly I'd rather prefer to keep selected drivers on the old code for
that case than the other way around.

We currently still have two big blockers for having any sort of real
blk-mq by default decision for scsi:

 a) there is no multiath support for it, and we simply can't break existing
    setups that use.
 b) there is no support for I/O schedulers at all.  This might be okay
    for virtio-scsi, where in general you have a host scheduler, but for
    real hardware that still has to deal with more spinning rust than
    solid state it's a blocker.  Fortuntely Jens is working on that one.

> Also with force_blk_mq on virtio-scsi, people can test scsi-mq with
> default setting, then it should be helpful to collect more test reports, :-)

I think between the config and the module/boot option we've already got
ways to get reports.  Improvements welcome.

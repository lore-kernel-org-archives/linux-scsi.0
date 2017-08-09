From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/4]  mylex: Replace DAC960 block driver
Date: Wed, 9 Aug 2017 16:23:08 +0200
Message-ID: <20170809142308.GA28945@lst.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53795 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753010AbdHIOXJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 10:23:09 -0400
Content-Disposition: inline
In-Reply-To: <1501683208-5240-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Aug 02, 2017 at 04:13:24PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> as we're trying to get rid of the remaining request_fn drivers here's
> a patchset to move the DAC960 driver to the SCSI stack.
> The new driver is called 'mylex'.
> 
> The Mylex/DAC960 HBA comes in two flavours; the later one (V2) already
> has a pretty complete SCSI emulation layer, so we just have to reformat
> the command.
> For for earlier ones (V1) we don't have a SCSI emulation layer for the
> logical drives, so I've added a (pretty rudimentary, admittedly) SCSI
> translation for them.
> And the weird proc interface has been converted to sysfs attributes.

It seems like V1 and V2 basically don't share any code at all, so it seems
like they should be separate drivers.  And for V1 it seems like it might
even be better off as a blk-mq driver - which could then reuse the DAC960
name and device nodes?

For the V2 firmware your approach looks great, though.

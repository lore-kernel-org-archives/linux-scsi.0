From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: add support for legacy boards
Date: Wed, 12 Jul 2017 09:11:21 +0200
Message-ID: <20170712071121.GA5545@lst.de>
References: <1499755744-79217-1-git-send-email-hare@suse.de> <alpine.LRH.2.20.1707111547060.31569@math.ut.ee> <4993A297653ECB4581FA5C3C31323D19533CE9D1@avsrvexchmbx2.microsemi.net> <alpine.LRH.2.20.1707111853330.9598@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56020 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751378AbdGLHLX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jul 2017 03:11:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.1707111853330.9598@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Don Brace <don.brace@microsemi.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

On Tue, Jul 11, 2017 at 06:58:36PM +0300, Meelis Roos wrote:
> > The 5i controller is probably too old for the hpsa driver to support. 
> > The hpsa driver is looking for information to determine if the drive is online/offline and
> > this information is not available.
> > 
> > What was the original issue you were having with the cciss driver?
> 
> Christoph Hellwig updated block layer with "block: Make most 
> scsi_req_init() calls implicit" and at first try, cciss was left without 
> the needed initialization. This caused OOPS in udev probing but the 
> system worked. The issue was fixed by Christoph quickly.

The original patch is from Bart, but otherwise correct.

> But he suggested it might be worth trying hpsa driver instead of cciss, 
> with a longer term goal to to move users of cciss over to hpsa if 
> possible. Now that I have tested it, it seems not all older cards are 
> supported in hpsa - it's more than ID-s and interrupt masks.

Seems like it.  And the idea behind this game is that we'd like to slowly
get rid of old request_fn based drivers.  Given that hpsa supports very
similar hardware cciss is a target for removal once that hardware is
switched over.  But it seems like we'll need more work in this area..

> 
> -- 
> Meelis Roos (mroos@linux.ee)
---end quoted text---

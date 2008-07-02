From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 2 Jul 2008 20:45:27 +0200
Message-ID: <20080702184526.GM20055@kernel.dk>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local> <1214963700.3316.41.camel@localhost.localdomain> <87zlp0n4p8.fsf@denkblock.local> <20080702115030.GK20055@kernel.dk> <1215010189.3330.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:8448 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYGBSpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2008 14:45:30 -0400
Content-Disposition: inline
In-Reply-To: <1215010189.3330.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, linux-scsi@vger.kernel.org, stable@kernel.org

On Wed, Jul 02 2008, James Bottomley wrote:
> On Wed, 2008-07-02 at 13:50 +0200, Jens Axboe wrote:
> > On Wed, Jul 02 2008, Elias Oltmanns wrote:
> > > > The blk_plug_queue change looks reasonable ... however, blk_plug_queue
> > > > itself looks like it might not entirely need the queue lock ... I need
> > > > to investigate more closely.
> > > 
> > > Well, I rather think it does. We have to serialise access to the
> > > unplug_timer and there is a call to __set_bit() which, as I understand,
> > > requires the calling function to ensure atomicity.
> > 
> > Yep, blk_plug_device() needs to be called with the queue lock held.
> 
> That's what the comment says ... but if you replaced the test_bit with
> an atomic operation then the rest of it does look to be in no need of
> serialisation ... unless there's something I missed?

Indeed, but then you would have to use atomic bitops everywhere and that
is the bit we moved away from.

-- 
Jens Axboe


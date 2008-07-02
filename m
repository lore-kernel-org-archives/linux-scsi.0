From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 2 Jul 2008 13:50:31 +0200
Message-ID: <20080702115030.GK20055@kernel.dk>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local> <1214963700.3316.41.camel@localhost.localdomain> <87zlp0n4p8.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764071AbYGBLud (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jul 2008 07:50:33 -0400
Content-Disposition: inline
In-Reply-To: <87zlp0n4p8.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, stable@kernel.org

On Wed, Jul 02 2008, Elias Oltmanns wrote:
> > The blk_plug_queue change looks reasonable ... however, blk_plug_queue
> > itself looks like it might not entirely need the queue lock ... I need
> > to investigate more closely.
> 
> Well, I rather think it does. We have to serialise access to the
> unplug_timer and there is a call to __set_bit() which, as I understand,
> requires the calling function to ensure atomicity.

Yep, blk_plug_device() needs to be called with the queue lock held.

-- 
Jens Axboe


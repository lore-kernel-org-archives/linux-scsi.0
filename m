From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi_allocate_request() reference
Date: Tue, 22 Mar 2005 12:17:22 +0100
Message-ID: <20050322111721.GV19037@suse.de>
References: <20050321132604.GA25452@suse.de> <1111417798.5504.8.camel@mulgrave> <20050321165751.GJ25452@suse.de> <20050321235146.GA7994@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:14015 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262627AbVCVLR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 06:17:28 -0500
Content-Disposition: inline
In-Reply-To: <20050321235146.GA7994@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Mar 22 2005, Tejun Heo wrote:
>  Hello, Jens.
>  Hello, James.
> 
> On Mon, Mar 21, 2005 at 05:57:52PM +0100, Jens Axboe wrote:
> > On Mon, Mar 21 2005, James Bottomley wrote:
> > > On Mon, 2005-03-21 at 14:26 +0100, Jens Axboe wrote:
> > > > scsi_allocate_request() doesn't hold a reference to the device that it
> > > > points to, that is not good. This patch fixes that up.
> > > 
> > > Actually, I don't think this is correct.  The reference is taken when
> > > the command is attached to a request in the scsi_request_fn function
> > > after first checking that the entity is in a condition to have this
> > > happen.
> > 
> > Where does this happen, specifically? I can verify that this patch
> > solves at least one of the oopses I am seeing with hotplug. IMHO, the
> > reference should be taken when you reference the device (ie ->sr_device
> > is assigned in scsi_allocate_request()).
> 
>  I've been working on scsi hot plug/unplugging for a few days now but
> I haven't seen any oops caused by reference count problems.  The only

You need to have io in progress. The one ref problem with
scsi_allocate_request() is easy to trigger, if you just open/close the
device repeatedly while inserting and removing it.

>  So, please let me know about the reference counting problem you're
> encountering.  I will incorporate it in the new state machine /
> flushing patches.

See my two recent postings on this list!

-- 
Jens Axboe


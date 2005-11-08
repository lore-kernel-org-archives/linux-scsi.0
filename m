From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2/10] seperate max sectors and max hw sectors
Date: Tue, 8 Nov 2005 18:57:07 +0100
Message-ID: <20051108175707.GL3699@suse.de>
References: <1131444395.23111.62.camel@max> <20051108174723.GK3699@suse.de> <4370E5ED.60901@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:50282 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932498AbVKHR4H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 12:56:07 -0500
Content-Disposition: inline
In-Reply-To: <4370E5ED.60901@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 08 2005, Mike Christie wrote:
> Jens Axboe wrote:
> >On Tue, Nov 08 2005, Mike Christie wrote:
> >
> >>Seperate max_hw_sectors and max_sectors.
> >>
> >>LLDs call blk_queue_max_hw_sectors() to set max_hw_sectors.
> >>blk_queue_max_sectors will also set max_sectors to a safe
> >>default value.
> >>
> >>blk_init_queue still calls blk_queue_max_sectors so if there
> >>are any LLDs that do not call blk_queue_max_hw_sectors() and
> >>were expecting both the max_sectors and max_hw_sectors to be
> >>255 they do not have to do anything.
> >>
> >>I was not able to test every driver I touched, but I think the
> >>only place I may have messed up is MD so some testing is needed.
> >
> >
> >->max_sectors will become less of a driver property and more of a
> >block/vm propery, so I think the best way to do this is just to have
> >blk_queue_max_sectors() set ->max_hw_sectors directly and lower
> >->max_sectors appropriately if it is lower. That also comes with the
> >bonus of not having to modify drivers.
> >
> 
> Ugggh. I did this in reverse to make the naming nicer. So I added a 
> blk_queue_max_hw_sectors() which sets ->max_sectors to some Block layer 
> default and ->max_hw_sectors to the hw limit (for SCSI this is the scsi 
> host template ->max_sectors). Is this ok? It is more clear for driver 
> writers that they are setting max_hw_sectors when calling 
> blk_queue_max_hw_sectors(). I also converted all the 
> blk_queue_max_sectors() to blk_queue_max_hw_sectors().

Driver writers need not know. They call blk_queue_max_sectors() to set
the maximum value of a request they can handle, they could not care less
what internal field in the queue is actually used for that. From their
perspective, blk_queue_max_sectors() defines their hard limit. We may
(and will) adjust the soft limit behind their back - which is ok, as
long as we honor the value they defined by calling
blk_queue_max_sectors().

-- 
Jens Axboe


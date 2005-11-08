From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2/10] seperate max sectors and max hw sectors
Date: Tue, 8 Nov 2005 18:47:23 +0100
Message-ID: <20051108174723.GK3699@suse.de>
References: <1131444395.23111.62.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:30818 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S965156AbVKHRq0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 12:46:26 -0500
Content-Disposition: inline
In-Reply-To: <1131444395.23111.62.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 08 2005, Mike Christie wrote:
> Seperate max_hw_sectors and max_sectors.
> 
> LLDs call blk_queue_max_hw_sectors() to set max_hw_sectors.
> blk_queue_max_sectors will also set max_sectors to a safe
> default value.
> 
> blk_init_queue still calls blk_queue_max_sectors so if there
> are any LLDs that do not call blk_queue_max_hw_sectors() and
> were expecting both the max_sectors and max_hw_sectors to be
> 255 they do not have to do anything.
> 
> I was not able to test every driver I touched, but I think the
> only place I may have messed up is MD so some testing is needed.

->max_sectors will become less of a driver property and more of a
block/vm propery, so I think the best way to do this is just to have
blk_queue_max_sectors() set ->max_hw_sectors directly and lower
->max_sectors appropriately if it is lower. That also comes with the
bonus of not having to modify drivers.


-- 
Jens Axboe


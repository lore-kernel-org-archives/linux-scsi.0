From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2/6] scsi tgt: kill length alignment test in bin_map_user
Date: Thu, 16 Feb 2006 21:00:10 +0100
Message-ID: <20060216200010.GZ4203@suse.de>
References: <1140119617.20193.49.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:284 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S964890AbWBPUAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 15:00:11 -0500
Content-Disposition: inline
In-Reply-To: <1140119617.20193.49.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 16 2006, Mike Christie wrote:
> Subject: [PATCH] block layer: kill length alignment test in bin_map_user
> 
> The tgt project is mapping in bios using bio_map_user. The current targets
> do not need their len to be aligned with a queue limit so this check is
> causing some problems. Note: pointers passed into the kernel are properly
> aligned by usersapace tgt code so the uaddr check in bio_map_user is ok.
> 
> 
> The major user, blk_bio_map_user checks for the len before mapping
> so it is not affected by this patch.
> 
> And the semi-newly added user blk_rq_map_user_iov has been failing
> out when the len is not aligned properly so maybe people have been
> good and not sending misaligned lens or that path is not used very
> often and this change will not be very dangerous. st and sg do not
> check the length and we have not seen any problem reports from those
> wider used paths so this patch should be fairly safe - for mm 
> and wider testing at least.

As previously discussed, this is fine with me. It's a mixed check
anyways, if we need length check in the future it should be a seperate
attribute.

-- 
Jens Axboe


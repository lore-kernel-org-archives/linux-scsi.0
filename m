From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 3/6] scsi tgt: add partial mappings support to bio_map_user
Date: Thu, 16 Feb 2006 20:59:17 +0100
Message-ID: <20060216195917.GY4203@suse.de>
References: <1140119620.20193.51.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:28187 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S964888AbWBPT7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 14:59:20 -0500
Content-Disposition: inline
In-Reply-To: <1140119620.20193.51.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Feb 16 2006, Mike Christie wrote:
> Subject: [PATCH] block layer: add partial mappings support to bio_map_user
> 
> For target mode we could end up with the case where we get very large
> request from the initiator. The request could be so large that we
> cannot transfer all the data in one operation. For example the
> HBA's segment or max_sector limits might limit us to a 1 MB transfer.
> To send a 5 MB command then we need to transfer the command chunk by chunk.
> 
> To do this, tgt core will map in as much data as possible into a bio,
> send this off, then when that transfer is completed we send off another
> request/bio. To be able to pack as much data into a bio as possible
> we need bio_map_user to support partially mapped bios. The attached patch
> just adds a new argument to the those functions and if set will not
> return a failure if the bio is partially mapped.

Drop the partial flag and just always allow it, fixing up the few
in-kernel users we have.

-- 
Jens Axboe


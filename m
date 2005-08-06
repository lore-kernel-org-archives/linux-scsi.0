From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] allow bio code to unmap sg io requests and have blk_execute_rq_nowait
 bounce bios
Date: Sat, 06 Aug 2005 11:25:00 -0500
Message-ID: <42F4E45C.90106@cs.wisc.edu>
References: <1122628800.8900.22.camel@max> <20050802084905.GC22569@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2442 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S263242AbVHFQZU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Aug 2005 12:25:20 -0400
In-Reply-To: <20050802084905.GC22569@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jens Axboe wrote:
> On Fri, Jul 29 2005, Mike Christie wrote:
> 
>>Hey Jens and James,
>>
>>The inlined patch moves the bounce buffer handling to blk_execute_rq_nowait
>>so the scsi, sg io and cdrom code does not have to handle it. To accomplish
>>this I moved the bio_uncopy_user to a bi_end_io function and bio_unmap_user
>>to a work struct that is schedule from a bi_end_io functions. Did you say
>>you disliked the idea of calling bio_unmap_user from a work struct - don't
>>remember and I lost my emails when I moved? :(
> 
> 
> It's probably alright, it cleans up the code a lot. It will cost some
> extra context switches, but I'm naively hoping that for busy io we will
> have good batching of the processing anyways.
> 

Doh! I ported sg.c and noticed I messed up. copy_to_user must be called
from user context so my patch does not work for that path.

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC] allow bio code to unmap sg io requests and have	blk_execute_rq_nowait
 bounce bios
Date: Fri, 29 Jul 2005 04:28:11 -0500
Message-ID: <42E9F6AB.5090008@cs.wisc.edu>
References: <1122628800.8900.22.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:21133 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262492AbVG2J2Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 05:28:16 -0400
In-Reply-To: <1122628800.8900.22.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Jens Axboe <axboe@suse.de>

Mike Christie wrote:
> And, as I work on the adding of BLKERR_* error values in replacement
> of the dm-multupath/bio sense patch, I was thinking about your comment
> about having one true make_request function. It seems like if we extended
> bios to handle more request stuff (like what is needed for SG IO) we could
> just pass the bio to __make_request - with some modifications to __make_request -
> instead of doing it request based and moving the blk_queue_bounce call to
> blk_execute_rq_nowait  like I did in my patch. Is this what you were thinking when
> adding the bio sense code?

I mean doing things like sg io and dm-multipath HW handler's manual
failover with bios instead of requests could simplify those things, but
I am guessing bios were not meant to handle some of the lower level
details like SCSI things. Or maybe they are or should be done in a more
generic way?

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: More information on scsi_cmd_cache leak... (bisect)
Date: Fri, 27 Jan 2006 13:20:16 -0600
Message-ID: <1138389616.3293.13.camel@mulgrave>
References: <200601270410.06762.chase.venters@clientec.com>
	 <17369.65530.747867.844964@cse.unsw.edu.au> <20060127112352.GF4311@suse.de>
	 <20060127112837.GG4311@suse.de>  <43DA6F33.3070101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:26305 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932436AbWA0TVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 14:21:03 -0500
In-Reply-To: <43DA6F33.3070101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@suse.de>, Neil Brown <neilb@suse.de>, Chase Venters <chase.venters@clientec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@osdl.org, a.titov@host.bg, askernel2615@dsgml.com, jamie@audible.transient.net

On Fri, 2006-01-27 at 13:06 -0600, Mike Christie wrote:
> It does not have anything to do with this in scsi_io_completion does it?
> 
>          if (blk_complete_barrier_rq(q, req, good_bytes >> 9))
>                  return;
> 
> For that case the scsi_cmnd does not get freed. Does it come back around 
> again and get released from a different path?

It looks such a likely candidate, doesn't it.  Unfortunately, Tejun Heo
removed that code around 6 Jan (in [BLOCK] update SCSI to use new
blk_ordered for barriers), so if it is that, then the latest kernels
should now not be leaking.

However, all the avaliable evidence does seem to point to the write
barrier enforcement.  I'll take another look over those code paths.

James



From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 04/04] scsi: remove unnecessary
	scsi_wait_req_end_io()
Date: Mon, 16 May 2005 11:07:32 -0500
Message-ID: <1116259652.5040.17.camel@mulgrave>
References: <20050514135610.81030F26@htj.dyndns.org>
	 <20050514135610.50606F9C@htj.dyndns.org>
	 <1116084383.5049.18.camel@mulgrave> <20050514154733.GA5557@htj.dyndns.org>
	 <1116087547.5049.25.camel@mulgrave> <20050515011532.GA26421@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:60589 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261723AbVEPQHq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 12:07:46 -0400
In-Reply-To: <20050515011532.GA26421@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, 2005-05-15 at 10:15 +0900, Tejun Heo wrote:
>  I've made two new versions of the same patch.  The first one just
> BUG() such cases, and the second one makes scsi_prep_fn() tell
> scsi_request_fn() to kill requests instead of doing itself w/
> BLKPREP_KILL.  In both cases, I made req->flags error case a BUG().
> If you don't like it, feel free to drop that part.
> 
>  Oh... one more thing.  I forgot to mention the scsi_kill_requests()
> path.  As it's a temporary fix, I just left it as it is (terminate
> commands w/ end_that_*).  I guess this patch should be pushed after
> removal of that kludge.  But with or without this patch, that path
> will leak resources.

I suppose it's not surprising that I don't like either.

You remove the code that handles the BLKPREP_KILL case and then contort
the request functions to try not to do it.  We have to handle this case,
it's not optional, so just leave the code that does it in.

James



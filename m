From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 04/04] scsi: remove unnecessary
	scsi_wait_req_end_io()
Date: Sat, 14 May 2005 11:26:23 -0400
Message-ID: <1116084383.5049.18.camel@mulgrave>
References: <20050514135610.81030F26@htj.dyndns.org>
	 <20050514135610.50606F9C@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13707 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261401AbVENP0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2005 11:26:42 -0400
In-Reply-To: <20050514135610.50606F9C@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sat, 2005-05-14 at 22:57 +0900, Tejun Heo wrote:
> 	As all requests are now terminated via scsi midlayer, we don't
> 	need to set end_io for special reqs, remove it.

This statement is untrue as long as the prep function can return
BLKPREP_KILL, which it still does even after your patch set, so the
scsi_wait_req_end_io() is still necessary to catch this case.

James



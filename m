From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 04/04] scsi: remove unnecessary
	scsi_wait_req_end_io()
Date: Sat, 14 May 2005 12:19:07 -0400
Message-ID: <1116087547.5049.25.camel@mulgrave>
References: <20050514135610.81030F26@htj.dyndns.org>
	 <20050514135610.50606F9C@htj.dyndns.org>
	 <1116084383.5049.18.camel@mulgrave>  <20050514154733.GA5557@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56971 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262791AbVENQTO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2005 12:19:14 -0400
In-Reply-To: <20050514154733.GA5557@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, 2005-05-15 at 00:47 +0900, Tejun Heo wrote:
>  BLKPREP_KILL is only used to kill illegal (unpreparable, way-off)
> requests.  Actually, for special requests, the only tests performed
> are req->flags and CDB_SIZE tests.  I don't think anyone does/will
> submit that illegal requests via scsi_wait_req().  And if so, it will
> be a bug.

True, but without the code you're removing it will simply hang the
system, which isn't a correct response to a detected bug.  And if I had
a shilling for every time someone's predicated a code change on "oh,
users will never do this" ... I'd be reasonably rich.

This also leads naturally into the next observation:  Checking in the
request function should be done.  However, it makes little sense wasting
resources preparing requests we know are going to be killed, so the
correct thing to do seems to be to abstract the checks and do them in
both prep_fn and request_fn.

James



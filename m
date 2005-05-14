From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 04/04] scsi: remove unnecessary scsi_wait_req_end_io()
Date: Sun, 15 May 2005 00:47:33 +0900
Message-ID: <20050514154733.GA5557@htj.dyndns.org>
References: <20050514135610.81030F26@htj.dyndns.org> <20050514135610.50606F9C@htj.dyndns.org> <1116084383.5049.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.193]:63611 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262787AbVENPrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 May 2005 11:47:41 -0400
Received: by rproxy.gmail.com with SMTP id a41so528127rng
        for <linux-scsi@vger.kernel.org>; Sat, 14 May 2005 08:47:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1116084383.5049.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

 Hello, James.

On Sat, May 14, 2005 at 11:26:23AM -0400, James Bottomley wrote:
> On Sat, 2005-05-14 at 22:57 +0900, Tejun Heo wrote:
> > 	As all requests are now terminated via scsi midlayer, we don't
> > 	need to set end_io for special reqs, remove it.
> 
> This statement is untrue as long as the prep function can return
> BLKPREP_KILL, which it still does even after your patch set, so the
> scsi_wait_req_end_io() is still necessary to catch this case.

 BLKPREP_KILL is only used to kill illegal (unpreparable, way-off)
requests.  Actually, for special requests, the only tests performed
are req->flags and CDB_SIZE tests.  I don't think anyone does/will
submit that illegal requests via scsi_wait_req().  And if so, it will
be a bug.

 I don't feel strong against keeping the end_io routine but, if you
decide to keep the routine, please consider adding a comment
explaining the peculiar path the routine might be used, such that
other people don't have to wander through the code.

 Thanks.

-- 
tejun

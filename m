From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] improvement of fastfail operation
Date: Thu, 1 Apr 2004 08:47:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401064703.GS24370@suse.de>
References: <1080696593.2075.120.camel@mulgrave> <Pine.LNX.4.44.0403302108550.7851-200000@dyn319701.beaverton.ibm.com> <20040331220416.GQ24370@suse.de> <1080771068.2071.48.camel@mulgrave> <20040331221241.GR24370@suse.de> <406B512F.9090004@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:60073 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262743AbUDAGsb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2004 01:48:31 -0500
Content-Disposition: inline
In-Reply-To: <406B512F.9090004@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 31 2004, Mike Christie wrote:
> Jens Axboe wrote:
> >On Wed, Mar 31 2004, James Bottomley wrote:
> >
> >>On Wed, 2004-03-31 at 17:04, Jens Axboe wrote:
> >>
> >>>So the new patch you sent with this mail is no good. Your previous one
> >>>should be adopted ;-)
> >>
> >>And the:
> >>
> >>
> >>		if (blk_pc_request(req))
> >>			leftover = req->data_len - bytes;
> >>
> >>Since end_that_request chunk won't muck with that, is that OK?
> >
> >
> >It's a bit messy right now really, but it's up to the drivers to modify
> >that one. So for partial completions, it should be updated to be
> >
> >	leftover = req->data_len;
> >
> >as well.
> >
> 
> Is that a typo? If drivers are to account for it, scsi should do
> 	leftover = req->data_len - bytes;
> ?

No, scsi_io_completion() should already have done it.

-- 
Jens Axboe


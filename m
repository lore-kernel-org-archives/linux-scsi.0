From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 09:57:04 -0600
Message-ID: <1173023824.3372.53.camel@mulgrave.il.steeleye.com>
References: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>
	 <1173018667.3372.36.camel@mulgrave.il.steeleye.com>
	 <45EAE91F.5070206@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52352 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932893AbXCDP5d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 10:57:33 -0500
In-Reply-To: <45EAE91F.5070206@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Sun, 2007-03-04 at 09:43 -0600, Mike Christie wrote:
> There are trying to do a scsi level multipath driver for RDAC support.
> And they are trying to do something similar to request based multipath
> (route requests instead of bios but in their case they are routing
> scsi_cmnds instead of requests).

I guessed it might be something like that ... 

The SCSI driver layer wasn't designed to stack like that ... hence the
problems of setup and teardown of the sg list.  Wouldn't it just be
easier to make request based multi-path work?  Unfortunately, you can't
avoid the request system because what you want to do is resubmit an I/O
without having the mid-layer execute the prepare function (which is
where it's mapped) so you need the REQ_DONTPREP flag.

James


James



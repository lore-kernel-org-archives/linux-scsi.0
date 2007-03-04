From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 12:14:21 -0600
Message-ID: <1173032061.3372.67.camel@mulgrave.il.steeleye.com>
References: <A67893E24596534CB03DD02157A7FBF7018D16BB@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53646 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752006AbXCDSOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 13:14:35 -0500
In-Reply-To: <A67893E24596534CB03DD02157A7FBF7018D16BB@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Sun, 2007-03-04 at 11:00 -0700, Dachepalli, Sudhir wrote:
> Do you think the following could work If I used blk layer functions
> instead of "scsi_execute_async":
> 
> Blk_get_request()
> Req->flags |= REQ_DONTPREP

There's additional complexity here:  if the request isn't prepared, no
command is allocated.  You can't use the one you have because it belongs
to a different device (plus it would be freed by this request in the
completion path).

> Blk_rq_map_kern()
> Blk_execute_req_nowait()

If the request is already mapped, you don't want to be mapping it again.

> Blk_put_request() 

Without seeing the code it's hard to say definitively whether all this
is correct.

James



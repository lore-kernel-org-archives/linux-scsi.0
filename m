From: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 4 Mar 2007 12:06:36 -0700
Message-ID: <A67893E24596534CB03DD02157A7FBF7018D16C7@NAMAIL2.ad.lsil.com>
References: <1173032061.3372.67.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:38654 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbXCDTHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 14:07:05 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1173032061.3372.67.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

James,

How about the following:

1. Cmd= Scsi_get_command( on physical device )  
2. Clone the scsi_cmnd fields of the virtual cmnd( command received by
failover driver) to physical cmnd (the command allocated by
scsi_get_command )
3. blk_get_request()
4. fill the request fields, req->special = Cmd ( point the special field
to allocated scsi_cmnd )
5. set the request flags to REQ_DONTPREP
6. blk_execute_req_nowait()
7. once the command comes back call the blk_put_request()


Sudhir

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Sunday, March 04, 2007 12:14 PM
To: Dachepalli, Sudhir
Cc: Mike Christie; Benny Halevy; Jens Axboe; Boaz Harrosh;
linux-scsi@vger.kernel.org
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()

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



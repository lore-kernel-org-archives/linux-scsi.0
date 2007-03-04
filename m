From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 08:31:07 -0600
Message-ID: <1173018667.3372.36.camel@mulgrave.il.steeleye.com>
References: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51573 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932798AbXCDObl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 09:31:41 -0500
In-Reply-To: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Sun, 2007-03-04 at 00:36 -0700, Dachepalli, Sudhir wrote:
> Our driver gets called in with the following fashion through the
> queuecommand.
> 
> scsi_request_fn() -> scsi_dispatch_cmd() -> rtn =
> host->hostt->queuecommand(cmd, scsi_done);
> 
> We are using the "cmd" ( scsi_cmnd) as a pass through with out touching
> the "request_buffer" and "request_bufflen".
> 
> We do not allocate memory similar to sg or st for page allocations.
> 
> The request_buffer should already contain the scatter gather list built.

We're trying not to wrapper pass throughs in SCSI commands (unless
defined by standard like the ATA ones).  However, I'm not entirely sure
what you're trying to do ... can you post a link to the driver so that
we can see if there's a better way?

Thanks,

James



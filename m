From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 04 Mar 2007 09:43:27 -0600
Message-ID: <45EAE91F.5070206@cs.wisc.edu>
References: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com> <1173018667.3372.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46663 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbXCDPoh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 10:44:37 -0500
In-Reply-To: <1173018667.3372.36.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2007-03-04 at 00:36 -0700, Dachepalli, Sudhir wrote:
>> Our driver gets called in with the following fashion through the
>> queuecommand.
>>
>> scsi_request_fn() -> scsi_dispatch_cmd() -> rtn =
>> host->hostt->queuecommand(cmd, scsi_done);
>>
>> We are using the "cmd" ( scsi_cmnd) as a pass through with out touching
>> the "request_buffer" and "request_bufflen".
>>
>> We do not allocate memory similar to sg or st for page allocations.
>>
>> The request_buffer should already contain the scatter gather list built.
> 
> We're trying not to wrapper pass throughs in SCSI commands (unless
> defined by standard like the ATA ones).  However, I'm not entirely sure
> what you're trying to do ... can you post a link to the driver so that
> we can see if there's a better way?
> 

There are trying to do a scsi level multipath driver for RDAC support.
And they are trying to do something similar to request based multipath
(route requests instead of bios but in their case they are routing
scsi_cmnds instead of requests).

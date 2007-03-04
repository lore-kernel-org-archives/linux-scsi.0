From: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>
Subject: RE: Possible bug in scsi_lib.c:scsi_req_map_sg()
Date: Sun, 4 Mar 2007 00:36:03 -0700
Message-ID: <A67893E24596534CB03DD02157A7FBF7018D1691@NAMAIL2.ad.lsil.com>
References: <45EA0CFA.8090101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63375 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXCDHge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Mar 2007 02:36:34 -0500
Content-class: urn:content-classes:message
In-Reply-To: <45EA0CFA.8090101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Benny Halevy <bhalevy@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Mike ,

Our driver gets called in with the following fashion through the
queuecommand.

scsi_request_fn() -> scsi_dispatch_cmd() -> rtn =
host->hostt->queuecommand(cmd, scsi_done);

We are using the "cmd" ( scsi_cmnd) as a pass through with out touching
the "request_buffer" and "request_bufflen".

We do not allocate memory similar to sg or st for page allocations.

The request_buffer should already contain the scatter gather list built.


Regards,
Sudhir 

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Saturday, March 03, 2007 6:04 PM
To: Dachepalli, Sudhir
Cc: Benny Halevy; Jens Axboe; Boaz Harrosh; linux-scsi@vger.kernel.org;
James Bottomley
Subject: Re: Possible bug in scsi_lib.c:scsi_req_map_sg()

Dachepalli, Sudhir wrote:
> Where is the depricated warning that you mentioned about ?
> I tried to look in scsi_lib.c and scsi_device.h
> 

I meant in the first versions of the patches there was a warning. Did
you also try the workarounds mentioned in the bugzilla, to allocate
memory like sg and st?

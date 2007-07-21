From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] dm-mpath-rdac: don't stomp on a request's transfer bit.
Date: Fri, 20 Jul 2007 22:56:35 -0700
Message-ID: <1184997395.5146.98.camel@linuxchandra>
References: <4696D6CB.6050504@csupomona.edu>
	 <1184292400.5146.45.camel@linuxchandra> <20070713023743.GA5350@us.ibm.com>
	 <20070717210706.GA2277@plap.qlogic.org>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:46345 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193AbXGUF4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Jul 2007 01:56:37 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6L5ubiA001090
	for <linux-scsi@vger.kernel.org>; Sat, 21 Jul 2007 01:56:37 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6L5ubX9257312
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jul 2007 23:56:37 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6L5uaGU016541
	for <linux-scsi@vger.kernel.org>; Fri, 20 Jul 2007 23:56:37 -0600
In-Reply-To: <20070717210706.GA2277@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>, torvalds@linux-foundation.org
Cc: Brian De Wolf <bldewolf@csupomona.edu>, linux-scsi@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mike Anderson <andmike@us.ibm.com>

ACK'd. This patch is needed for rdac to work properly.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Tue, 2007-07-17 at 14:07 -0700, Andrew Vasquez wrote:
> Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> ---
> 
> 	On Thu, 12 Jul 2007, Mike Anderson wrote:
> 
> 	> Copying this mail to linux-scsi and Ccing Andrew Vasquez to possibly
> 	> provide input on the Qlogic behavior.
> 	...
> 
> 	> > > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: ISP System Error - mbx1=0h
> 	> > > mbx2=8012h mbx3=8002h.
> 	> > > Jul 12 17:11:15 jimbo kernel: qla2xxx 0000:02:01.1: Firmware has been previously
> 	> > > dumped (ffffc2000171d000) -- ignoring request...
> 	> > > Jul 12 17:11:16 jimbo kernel: qla2xxx 0000:02:01.1: Performing ISP error
> 	> > > recovery - ha= ffff81007e85c530.
> 
> 	So what's happening here is the firmware is detecting a Xfer-ready
> 	from the storage when in fact the data-direction for a mode-select
> 	should be a write (DATA_OUT).
> 
> 	The following patch fixes the problem (typo).  Verified by Brian, as
> 	well.
> 
> diff --git a/drivers/md/dm-mpath-rdac.c b/drivers/md/dm-mpath-rdac.c
> index 8b776b8..16b1613 100644
> --- a/drivers/md/dm-mpath-rdac.c
> +++ b/drivers/md/dm-mpath-rdac.c
> @@ -292,7 +292,7 @@ static struct request *get_rdac_req(struct rdac_handler *h,
>  	rq->end_io_data = h;
>  	rq->timeout = h->timeout;
>  	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> -	rq->cmd_flags = REQ_FAILFAST | REQ_NOMERGE;
> +	rq->cmd_flags |= REQ_FAILFAST | REQ_NOMERGE;
>  	return rq;
>  }
> 
> 
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------



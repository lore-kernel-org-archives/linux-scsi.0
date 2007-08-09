From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold
 structure
Date: Thu, 9 Aug 2007 22:43:59 +0900
Message-ID: <20070809155735T.tomof@acm.org>
References: <20070808073801U.fujita.tomonori@lab.ntt.co.jp>
	<46B9F626.9020200@cs.wisc.edu>
	<46B9FB6B.70501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:57739 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759609AbXHINtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Aug 2007 09:49:14 -0400
In-Reply-To: <46B9FB6B.70501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com

On Wed, 08 Aug 2007 12:20:43 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> Mike Christie wrote:
> > For drivers like sg and st, do mean the the sg list that is passed to 
> > functions like scsi_execute_async? If we kill that argument, and instead 
> > have sg.c and other scsi_execute_async callers just call blk helpers 
> > like blk_rq_map_user then we would not have to worry about drivers like 
> > sg needing to know about chaining right? I mean sg.c would not every 
> > interact with a scatterlist. It would just interact with a request and 
> > the blk helpers map data for it.
> 
> There should be a return there.
> 
>   The scatterlist that sg and st interact
> > with is bogus. It gets thrown away in scsi_execute_async and is only 
> > used for book keeping.
> 
> I mean currently the scatterlist that sg and st use is bogus and gets 
> thrown away. If we convert sg and st to use blk_rq_map_user then those 
> drivers will not have to interact with a scatterlist at all.

Yeah, we should kill scsi_execute_async. sg should not be the consumer
even if the block layer has functions to allocate chaining sg.

Right now I'm happy as long as scsi-ml has the simple routine to
allocate chaining sg like Jens's branch. So we might easily move it to
the block layer or the block layer might just take care of the sg list
for scsi-ml, etc in the future.

From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold structure
Date: Wed, 08 Aug 2007 12:20:43 -0500
Message-ID: <46B9FB6B.70501@cs.wisc.edu>
References: <46B600F4.7020601@torque.net>	<20070806130944R.fujita.tomonori@lab.ntt.co.jp>	<46B8A845.4080106@cs.wisc.edu> <20070808073801U.fujita.tomonori@lab.ntt.co.jp> <46B9F626.9020200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44669 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937466AbXHHRVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Aug 2007 13:21:46 -0400
In-Reply-To: <46B9F626.9020200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com

Mike Christie wrote:
> For drivers like sg and st, do mean the the sg list that is passed to 
> functions like scsi_execute_async? If we kill that argument, and instead 
> have sg.c and other scsi_execute_async callers just call blk helpers 
> like blk_rq_map_user then we would not have to worry about drivers like 
> sg needing to know about chaining right? I mean sg.c would not every 
> interact with a scatterlist. It would just interact with a request and 
> the blk helpers map data for it.

There should be a return there.

  The scatterlist that sg and st interact
> with is bogus. It gets thrown away in scsi_execute_async and is only 
> used for book keeping.

I mean currently the scatterlist that sg and st use is bogus and gets 
thrown away. If we convert sg and st to use blk_rq_map_user then those 
drivers will not have to interact with a scatterlist at all.

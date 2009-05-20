From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH version 2] [SQUASHME] "FC Pass Thru support" fixed for
 block/for-2.6.31 tree
Date: Wed, 20 May 2009 19:59:04 +0300
Message-ID: <4A1436D8.4050004@panasas.com>
References: <4A12797B.2060901@panasas.com> <4A12AC23.30808@panasas.com>	 <20090520111619.87f815b1.sfr@canb.auug.org.au>	 <1242830240.2881.10.camel@localhost.localdomain>	 <20090521004251.9160e228.sfr@canb.auug.org.au>	 <1242830865.2881.13.camel@localhost.localdomain>	 <1242836425.2881.44.camel@localhost.localdomain>	 <4A14322A.4000709@panasas.com> <1242837810.2881.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:3958 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754181AbZETQ7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2009 12:59:08 -0400
In-Reply-To: <1242837810.2881.47.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>, James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <tomof@acm.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>

On 05/20/2009 07:43 PM, James Bottomley wrote:
> If you actually just ask scsi-post-merge-2.6 where this line is, it will
> tell you:
> 
> static void blk_finish_request(struct request *req, int error)
> {
>         BUG_ON(blk_queued_rq(req));
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
>         if (blk_rq_tagged(req))
>                 blk_queue_end_tag(req->q, req);
> 
> James
> 
> 

This is a new BUG_ON from:
    block: implement and enforce request peek/start/fetch

It looks like there is one more sight of the old usage that
was not converted.

Tejun?
 

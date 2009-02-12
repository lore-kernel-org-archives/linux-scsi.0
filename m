From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] block: unexport blk_rq_append_bio
Date: Thu, 12 Feb 2009 18:51:28 +0200
Message-ID: <49945390.3050905@panasas.com>
References: <4992E9A4.9080303@panasas.com>	 <20090212002105A.fujita.tomonori@lab.ntt.co.jp>	 <4992F1AF.9060702@panasas.com>	 <20090212010454J.fujita.tomonori@lab.ntt.co.jp>	 <1234369838.3295.31.camel@localhost.localdomain>	 <49931113.3090701@panasas.com> <1234450129.3295.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35183 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759703AbZBLQvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 11:51:39 -0500
Received: by ewy14 with SMTP id 14so667938ewy.13
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2009 08:51:37 -0800 (PST)
In-Reply-To: <1234450129.3295.75.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> 
> bios are supposed to be used by filesystems ... they represent the input
> to block.  In principle, it seems nicer that PC requests deal with pages
> as their natural input ... that way we don't have to worry about
> exporting the block interfaces for bio->request construction.
> 

This is my point. I'm a filesystem and I want a natural route from
bio to request, only with a paradigm shift as you call it.
For a filesystem the most natural and comfortable vehicle is a bio.

So the interface I would like to have is:

    struct request *blk_make_request(struct request_queue *, struct bio *, gfp_t);

And let block layer take care of it's internals. Off course when crafting above
the generic_make_request will use above API so there is absolutely no duplication
of code and block layer is free to change as it feels like, only in a single place.

>> I will try the blk_rq_map_user, I'm sure it will not be pretty, though.
> 
> Great, thanks ... we can also adjust block interfaces to help.
> 
> James
> 

I'm on it. It's not as bad as I thought, and it should work for what I have now.
I'm touching fast-path block layer code though, so we'll have to test it for a long
while.

I have a gut feeling that I will regret it some day, but we'll cross that bridge when
we get there.

Thank you for your help and concern.
Boaz

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET  0/2] Don't let blk_put_request leak BIOs
Date: Thu, 19 Mar 2009 16:50:47 +0200
Message-ID: <49C25BC7.1020900@panasas.com>
References: <49C21C5A.6030105@panasas.com> <20090319113343.GF27476@kernel.dk> <49C24B55.3040609@panasas.com> <20090319134500.GO27476@kernel.dk> <49C24D1E.6000105@panasas.com> <20090319135630.GP27476@kernel.dk> <49C2542B.70604@panasas.com> <20090319142419.GS27476@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:10518 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753460AbZCSOwE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:52:04 -0400
In-Reply-To: <20090319142419.GS27476@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Jens Axboe wrote:
>> So current (above) code in osd_initiator.c is correct and should stay
>> as it is? that's fine by me.
> 
> It's still not pretty, any reason you can't just use blk_end_request()?
> Why do you need to unroll the bios manually?
> 

I have stared at blk_end_request() multiple times, and I'm afraid to call it
it does to many things. accounting, end_that_request_last, lots of not needed
stuff. This is a request that was never on any submission Q, it is scary.
Also I'm not sure what is the request state it can be very partially built
at this stage.

But mainly I do not want that bio->bi_end_io(bio, error); will be called.
I don't want any read bouncing to happen, just return them to free store.

I will try the blk_end_request(,-EIO) and see if it works for all cases

Thanks
Boaz

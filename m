From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
   count
Date: Fri, 07 Mar 2008 09:07:23 +0900
Message-ID: <47D0873B.6090705@gmail.com>
References: <47CEA40F.6050903@gmail.com> <20080305135121.GK6704@kernel.dk> <1204730484.3047.10.camel@localhost.localdomain> <20080306134146A.fujita.tomonori@lab.ntt.co.jp> <20080306134138.GF17940@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:52240 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbYCGAHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 19:07:37 -0500
Received: by rn-out-0910.google.com with SMTP id v46so278904rnb.15
        for <linux-scsi@vger.kernel.org>; Thu, 06 Mar 2008 16:07:33 -0800 (PST)
In-Reply-To: <20080306134138.GF17940@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, efault@gmx.de, tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

Jens Axboe wrote:
>>> If we want the use paradigm shared between block and driver, then I
>>> think the best approach is to keep all the bios the same (so not adjust
>>> for padding), but do adjust in the blk_rq_map_sg().  That way we have
>>> the padding and draining unwind information by comparing with the bio.
>> Adjusting only sg in blk_rq_map_sg (like drain) looks much
>> better. This works with libata for me.
> 
> Looks like a much better solution to me. Anyone have any valid
> objections against moving the padding to the sg map time?

Not necessarily objections but some concerns.

* As completion is done in bio terms, it makes completion from LLDs a
bit cumbersome, but this is unavoidable if we break sum(bio) == sum(sg).

* I've been wondering why we are not using sg chain / table or whatever
directly in bios and maybe rq_map_sg can go away in future.

How about separating out the padding / draining adjustment into a
separate interface?  Say, blk_rq_apply_extra() and blk_rq_undo_extra()
and make it the responsibility of the LLD which requested
padding/draining to apply and undo the adjustments?  It can undo the
adjustments when it returns the the request to its upper layer.  If rq
completion is handled by upper layer, it will do the right thing.  If rq
completion is handled by LLD, it can see the bio it wants to see.

Thanks.

-- 
tejun

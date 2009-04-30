From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] block: add rq->resid_len
Date: Thu, 30 Apr 2009 16:19:29 +0900
Message-ID: <49F95101.3010004__33490.0916241624$1241076174$gmane$org@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-4-git-send-email-tj@kernel.org> <1241016114.3369.9.camel@mulgrave.int.hansenpartnership.com> <49F905EE.2020407@kernel.org> <20090430064549.GC6725@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbZD3HWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 03:22:10 -0400
In-Reply-To: <20090430064549.GC6725@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.

Borislav Petkov wrote:
>> Fancy words aside, it basically boils down to allowing llds to do
>> either "rq->resid_len = blk_rq_bytes() - xferred" on completion or
>> "rq->resid_len = blk_rq_bytes()" on issue and "rq->resid_len -=
>> increments" while processing.
> 
> Actually, the second one sounds more natural: resid_len == data_len on
> issue and decrementing while travelling through block layer and LLDD,
> while resid_len == 0 in issue might get confused somewhere.

Yeap, it depends on how the specific low level driver is doing it.

> And I like it too, we've been coming up with all sorts of hacks in
> ide-atapi wrt to residual completion and accounting of what got xferred
> already and rq->resid_len is much more cleaner, IMHO.
> 
> /me testing...

AFAICT, residual count handling in ide was most broken.  This patch
doesn't fix anything other than making it report 0 resid_len on SG_IO
which is usually better than reporting full residual count.  The only
place inside ide where residual count is used in the tape driver to
determine actually transferred size.  That part works okay with the
patch applied.

Hmmm... maybe it's about time to finally clean up residual count
handling in ide and libata, which BTW doesn't do anything about it at
the moment.

Thanks.

-- 
tejun

From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to	blk_rq_bytes()
 on issue
Date: Sat, 16 May 2009 22:52:24 +0900
Message-ID: <4A0EC518.3030401@gmail.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <20090516071305.GA4921@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:25473 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZEPNw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2009 09:52:28 -0400
In-Reply-To: <20090516071305.GA4921@liondog.tnic>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Borislav Petkov <petkovbb@gmail.com>, Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh>

Hello, Borislav.

Borislav Petkov wrote:
> On Sat, May 16, 2009 at 12:18:42AM +0900, Tejun Heo wrote:
>> In commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f, while introducing
>> rq->resid_len, the default value of residue count was changed from
>> full count to zero.  The conversion was done under the assumption that
>> when a request fails residue count wasn't defined.  However, Boaz and
>> James pointed out that this wasn't true and the residue count should
>> be preserved for failed requests too.
>>
>> This patchset restores the original behavior by setting rq->resid_len
>> to blk_rq_bytes(rq) on issue and restoring explicit clearing in
>> affected drivers.  While at it, take advantage of the fact that
>> rq->resid_len is set to full count where applicable.
>>
>> * ide-cd: rq->resid_len cleared on pc success
>>
>> * mptsas: req->resid_len cleared on success
>>
>> * sas_expander: rsp/req->resid_len cleared on success
>>
>> * mpt2sas_transport: req->resid_len cleared on success
>>
>> * ide-cd, ide-tape, mptsas, sas_host_smp, mpt2sas_transport, ub: take
>>   advantage of initial full count to simplify code
> 
> ACK the ide-{cd,tape} bits.
> 
> Acked-by: Borislav Petkov <petkovbb@gmail.com>
> 
> I've converted the ide-atapi part to rq->resid_len and from what I see,

Sorry it changed underneath your changes.

> the changes are compatible with the latest semantics of rq->resid_len
> but it won't hurt if you could take a look too :) :
>
> http://git.kernel.org/?p=linux/kernel/git/bp/bp.git;a=commit;h=077e6dba20e74a455a0452379d2a965c7e1b01ad

Yeap, I'll take a look.

> On a side note, ide_pc_intr() does some transfer padding but that
> doesn't affect rq->resid_len returning the remaining bytecount back up
> to block layer.

Hmmm... telling the issuer the actual number of transferred bytes sans
padding is the correct behavior, I think.

Thanks.

-- 
tejun

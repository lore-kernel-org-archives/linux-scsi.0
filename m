From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Wed, 05 Mar 2008 08:33:05 +0900
Message-ID: <47CDDC31.4070806@gmail.com>
References: <47CD53BA.5040908@gmail.com>	<47CD7611.2030606@gmail.com>	<47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080305041914V.tomof@acm.org>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> Hmm, does SCSI mid-layer need to care about how many bytes the block
> layer allocates? I don't think that extra_len is NOT good_bytes.
> 
> I think that the block layer had better take care about it (fix
> __end_that_request_first?).

Yeah, probably calling completion functions w/o bytes count is the right
thing to do but what I was talking about was what could break when the
semantics of rq->data_len changed.  If we keep rq->data_len() ==
sum(sg), we keep it business as usual for all the rest except for the
device application layer if we don't we do the reverse and SCSI midlayer
completion was a good example, I think.

Things going the other way is fine with me but I at least want to hear a
valid rationale.  Till now all I got is "because that's the true size"
which doesn't really make much sense to me.

Thanks.

-- 
tejun

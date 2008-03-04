From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Wed, 05 Mar 2008 08:54:18 +0900
Message-ID: <47CDE12A.2010109@gmail.com>
References: <47CD53BA.5040908@gmail.com>	<47CD7611.2030606@gmail.com>	<47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47CDDC31.4070806@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: efault@gmx.de, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> FUJITA Tomonori wrote:
>> Hmm, does SCSI mid-layer need to care about how many bytes the block
>> layer allocates? I don't think that extra_len is NOT good_bytes.
>>
>> I think that the block layer had better take care about it (fix
>> __end_that_request_first?).
> 
> Yeah, probably calling completion functions w/o bytes count is the right
> thing to do but what I was talking about was what could break when the
> semantics of rq->data_len changed.  If we keep rq->data_len() ==
> sum(sg), we keep it business as usual for all the rest except for the
> device application layer if we don't we do the reverse and SCSI midlayer
> completion was a good example, I think.
> 
> Things going the other way is fine with me but I at least want to hear a
> valid rationale.  Till now all I got is "because that's the true size"
> which doesn't really make much sense to me.

I'm giving it another shot.  When the padding / draining thing was in
libata (or IDE) in that matter.  The whole thing looked like this.

  user - blk - SCSI - libata - LLD - controller - device
  <---------------------><----------------------><----->
            a                       b               c

a: Uses the 'true' request size and matching sg
b: Requires adjusted request size and matching sg
c: Don't really care about sg, but sometimes needs the true size.  For
   anything which gets attached behind ATA and which may require
   padding, transfer size is also sent in the CDB as well, which not
   all devices honor and that's one of the reasons why size adjustment
   is necessary.

If we move the adjustment to block layer and keep data_len == sum(sg),
it looks like.

  user - blk - SCSI - libata - LLD - controller - device
  <------><-------------------------------------><----->
      a                      b                      c

And a, b and c stay the same.  If we keep the requested size in
data_len.  Whole b gets inconsistent values in the middle while c gets
the value it wants in data_len, so we're risking much more to keep the
true size in rq->data_len when we could simply make it mean sum(sg).

Before the only thing which need updating was to correctly determine
the transfer size to feed to device.  Now we need to audit whole b.
In addition, such adjustments are made only when the driver explicitly
requested it, so for all others it doesn't really matter.

Thanks.

-- 
tejun

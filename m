From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Wed, 13 May 2009 15:30:10 +0900
Message-ID: <4A0A68F2.1040600@kernel.org>
References: <1241423927-11871-4-git-send-email-tj@kernel.org>	 <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org>	 <20090511145024B.fujita.tomonori@lab.ntt.co.jp>	 <1242051500.3338.9.camel@mulgrave.int.hansenpartnership.com>	 <4A08C094.2060602@kernel.org>	 <1242099783.19949.8.camel@mulgrave.int.hansenpartnership.com>	 <4A09115D.3080009@kernel.org>	 <1242137329.3308.6.camel@mulgrave.int.hansenpartnership.com>	 <4A0992ED.4090200@kernel.org> <1242143126.3308.20.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242143126.3308.20.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, dgilbert@interlog.com, djwong@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

Hello, James.

James Bottomley wrote:
>> Shouldn't those be request successful w/ sense data?  Please note that
>> the term "error" in this context means failure of block layer request
>> not SCSI layer CHECK SENSE.
> 
> Heh, well, this is where we get into interpretations.  For SG_IO
> requests, we have three separate ways of returning error.  The error
> return to the block layer, the results return and the sense code.  The
> error to block is a somewhat later addition to the layer, so not all
> cases are handled right or agreed (for instance we just altered BLOCK_PC
> with recovered error from -EIO to no error).  So hopefully we've just
> decided that deferred and current but recovered all fall into the no
> error to block, but results and sense to the user.
> 
> Note that the error to block is basically discarded from SG_IO before we
> return to the user, so the user *only* has results and sense to go by,
> thus the concept of residual not valid on error to block is something
> the user can't check.  That's why a consistent definition in all cases
> (i.e. the amount of data the HBA transferred) is the correct one and
> allows userspace to make the determination of what it should do based on
> the returns it gets.

Okay, I was thinking SG_IO will return error for rq failures and I
remember pretty clearly following the failure path recently while
debugging eject problem but my memory is pretty unreliable.
Checking... oops, yeap, you're right.

>> I'm still reluctant to do it because...
>>
>> * Its definition still isn't clear (well, at least to me) and if it's
>>   defined as the number of valid bytes on request success and the
>>   number of bytes HBA transferred on request failure, I don't think
>>   it's all that useful.
> 
> It's not valid bytes in either case ... it's number transferred.  One
> can infer from a successful SCSI status code that number transferred ==
> valid bytes, but I'd rather we didn't say that.
> 
>> * Seen from userland, residue count on request failure has never been
>>   guaranteed and there doesn't seem to be any valid in kernel user.
> 
> But that's the point ... we don't define for userland what request
> failure is very well.
> 
>> * It would be extra code explicitly setting the residue count to full
>>   on failure path.  If it's something necessary, full residue count on
>>   failure needs to be made default.  If not, it will only add more
>>   confusion.
> 
> OK, so if what you're asking is that we can regard the residue as
> invalid if SG_IO itself returns an error, then I can agree ... but not
> if blk_end_request() returns error, because that error gets ignored by
> SG_IO.

I was confused that rq failure would cause error return from SG_IO.
Sorry about that.  There still is a problem tho.  Buffer for a bounced
SG_IO request is copied back on failure but when a bounced kernel PC
request fails, the data is not copied back in bio_copy_kern_endio().
This is what would break Boaz's code.

So, it seems what we should do is

1. Always copy back bounced buffer whether the request failed or not.
   Whether resid_len should be considered while copying back, I'm not
   sure about given that resid_len isn't properly implemented in some
   drivers.

2. Revert the original behavior of setting resid_len to full on
   request issue and audit the affected code paths.

How does it sound?

Thanks.

-- 
tejun

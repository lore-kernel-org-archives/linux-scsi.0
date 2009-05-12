From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 18:07:32 +0900
Message-ID: <4A093C54.2060706@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:42120 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZELJJu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 05:09:50 -0400
In-Reply-To: <4A093782.80701@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>

Hello, Boaz.

Boaz Harrosh wrote:
>> When a request failed, the whole buffer is garbage.
> 
> ret is the transferred size, right? I don't see any check for  
> success/failure in below code.
> 
>> There's no
>> partial transfer.  There shouldn't be.  I don't think residual count
>> on request failure means anything. 
> 
> That's not true, there are many cases when transfer failed eventually
> but some bytes are valid. Even the simple read/write case. Imagine a 
> very large transfer with last sector encounter a "bad sector". that can
> be critical, (trying to rescue a disk). And many other examples.

No, it doesn't work like that.  As I wrote before, those partial
transfers are returned to the issuer as partial _SUCCESS_ not partial
failure.  ie. it's successful request w/ positive residual count not
the other way around.  The error is communicated to the issuer when
the leftover is re-issued.  There's no such thing as partial failure.

Please consider write failing after successfully writing certain
number of bytes.  A failed write command MUST NOT cause any actual
write on the device.

Residual count is not about how many bytes have been transferred.  The
number of transferred bytes itself doesn't mean a thing because it
changes depending on which transfer protocol is used regardless of
where the actual failure is.  Residual count is about how many bytes
have been actually produced or consumed and when a command fails none
should have been.

>> Also, the 'whenever possible'
>> doesn't mean much when the issuer can't determine whether the value is
>> valid or not.  On success, we should guarantee resid count is valid,
>> on failure, I don't see a way we can.
>>
> 
> Code is as strong as it's weakest link, right? If lower
> driver/firmware is brain-dead, what can we do? But why give up where
> you can do better?
>
> The scsi standard is very clear about what every one should do with
> the residual and what it means at every stage, everyone should do
> his part. Here at the middle layer we need to correctly translate
> what lower level returned and pass it up the chain.
> 
> Must stacks are amateuristic in regard to error handling but some
> are not, what
>
> should we strive for, if we can? 

No it's not about being good or bad.  It's about being plain
undefined.  There is no value in setting an inherently undefined value
to certain values in certain corner cases.

>>> I know that in iscsi a negative residual is possible which means
>>> over-flow. That is: the target had more data to give then the buffer
>>> had space for. (which is not an error at all)
>> Hmm... I've never seen negative residual in use.  Is it even defined?
> 
> It is defined, as I explained before. But yes no one uses it in Kernel.
> The "good" low-level drivers fix it up by setting resid to zero, in that
> case. (other wise the upper layers might crash)

If the upper layer might crash if the value is negative, I think it's
quite understandable to call negative values to be undefined.  Or
should we call it unsupported?

Thanks.

-- 
tejun

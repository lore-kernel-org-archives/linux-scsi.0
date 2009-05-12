From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 19:06:09 +0900
Message-ID: <4A094A11.2030300@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com> <4A093C54.2060706@kernel.org> <4A0946D6.4010405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760383AbZELKHW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 06:07:22 -0400
In-Reply-To: <4A0946D6.4010405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>

Hello, Boaz.

Boaz Harrosh wrote:
>> Please consider write failing after successfully writing certain
>> number of bytes.  A failed write command MUST NOT cause any actual
>> write on the device.
>>
> 
> I know for sure that scsi has other cases. The above is a
> per-command per-sense-information. Some commands might write/read
> some bytes and still return CHECK-CONDITION with some
> sense-info+residual pertaining what was actually executed.

I see, so we're talking about two different layers here.  At least at
the block layer, there's nothing like partial failure.  I highly doubt
it would work with buffer bouncing and etc.  A failed request is a
failed request.  It may have sense request but doesn't have any
meaningful actual data.

>> Residual count is not about how many bytes have been transferred.  The
>> number of transferred bytes itself doesn't mean a thing because it
>> changes depending on which transfer protocol is used regardless of
>> where the actual failure is.  Residual count is about how many bytes
>> have been actually produced or consumed and when a command fails none
>> should have been.
>>
> See above. I know for a fact that this is not always the case, and
> that it is a per command. In fact I relay on such behaviour in the
> osd filesystems.  If the midlayer would filter such cases for me I
> would have had data corruptions.
> 
> [Read passed end of osd-object will read up to end, and return a
>  warning check condition. With a choice of returning zero-bytes at
>  invalid bytes or returning residual]

Umm... If it's going through block layer, it should be split in such a
way that the initial partial part is completed successuflly and then
the latter part fails when re-issued.  Not sure whether that would be
possible for your code tho.

>> Please note that in the above 'command' and 'residual count' are not
>> as defined in SCSI.  Those terms refer to how those concepts are used
>> in the kernel and via SG_IO interface.
> 
> I do have Kernel code that relays on this. I do use bsg's SG_IO
> successfully that has above behaviour.
> 
> That is: total transparency of residual count and sense information
> communicated between user-code and target. Then user-code can make
> intelligent decisions based on what he's done. And this is what the
> Kernel policy should be. No more, no less.

I'm not sure the said code is safe with regard to buffer bouncing and
all.

...
>> No it's not about being good or bad.  It's about being plain
>> undefined.  There is no value in setting an inherently undefined value
>> to certain values in certain corner cases.
>>
> 
> Again. With some commands/subsystems these are undefined, with some
> like SCSI, they are very well defined in all cases. (Even in the
> undefined cases). So please keep them intact, some code might want
> to relay on this.
> 
> (On the undefined cases Kernel should set a policy on what is
> returned)

IIUC, it's undefined at the block layer, well, at least till now and
it working for your code could just be dumb luck (bouncing not
happened or data transfer direction is to device or whatever).

So, basically, your code which depends on residual count on failure is
broken.  :-(

Thanks.

-- 
tejun

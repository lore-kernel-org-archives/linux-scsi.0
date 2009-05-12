From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
Date: Tue, 12 May 2009 14:08:10 +0300
Message-ID: <4A09589A.5030800@panasas.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com> <4A093C54.2060706@kernel.org> <4A0946D6.4010405@panasas.com> <4A094A11.2030300@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A094A11.2030300@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, Doug Gilbert <dgilbert@interlog.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/12/2009 01:06 PM, Tejun Heo wrote:
> Hello, Boaz.
> 
> Boaz Harrosh wrote:
>>> Please consider write failing after successfully writing certain
>>> number of bytes.  A failed write command MUST NOT cause any actual
>>> write on the device.
>>>
>> I know for sure that scsi has other cases. The above is a
>> per-command per-sense-information. Some commands might write/read
>> some bytes and still return CHECK-CONDITION with some
>> sense-info+residual pertaining what was actually executed.
> 
> I see, so we're talking about two different layers here.  At least at
> the block layer, there's nothing like partial failure.  I highly doubt
> it would work with buffer bouncing and etc.  A failed request is a
> failed request.  It may have sense request but doesn't have any
> meaningful actual data.
> 

You are right, on reads I might be screwed.

>>> Residual count is not about how many bytes have been transferred.  The
>>> number of transferred bytes itself doesn't mean a thing because it
>>> changes depending on which transfer protocol is used regardless of
>>> where the actual failure is.  Residual count is about how many bytes
>>> have been actually produced or consumed and when a command fails none
>>> should have been.
>>>
>> See above. I know for a fact that this is not always the case, and
>> that it is a per command. In fact I relay on such behaviour in the
>> osd filesystems.  If the midlayer would filter such cases for me I
>> would have had data corruptions.
>>
>> [Read passed end of osd-object will read up to end, and return a
>>  warning check condition. With a choice of returning zero-bytes at
>>  invalid bytes or returning residual]
> 
> Umm... If it's going through block layer, it should be split in such a
> way that the initial partial part is completed successuflly and then
> the latter part fails when re-issued.  Not sure whether that would be
> possible for your code tho.
> 
>>> Please note that in the above 'command' and 'residual count' are not
>>> as defined in SCSI.  Those terms refer to how those concepts are used
>>> in the kernel and via SG_IO interface.
>> I do have Kernel code that relays on this. I do use bsg's SG_IO
>> successfully that has above behaviour.
>>
>> That is: total transparency of residual count and sense information
>> communicated between user-code and target. Then user-code can make
>> intelligent decisions based on what he's done. And this is what the
>> Kernel policy should be. No more, no less.
> 
> I'm not sure the said code is safe with regard to buffer bouncing and
> all.
> 
> ...
>>> No it's not about being good or bad.  It's about being plain
>>> undefined.  There is no value in setting an inherently undefined value
>>> to certain values in certain corner cases.
>>>
>> Again. With some commands/subsystems these are undefined, with some
>> like SCSI, they are very well defined in all cases. (Even in the
>> undefined cases). So please keep them intact, some code might want
>> to relay on this.
>>
>> (On the undefined cases Kernel should set a policy on what is
>> returned)
> 
> IIUC, it's undefined at the block layer, well, at least till now and
> it working for your code could just be dumb luck (bouncing not
> happened or data transfer direction is to device or whatever).
> 
> So, basically, your code which depends on residual count on failure is
> broken.  :-(
> 

Yes, you are unfortunately, totally right. As I sent the last patches
(blk_make_request) I realized that current osd code has a bug in that
it does not bounce properly, all of the buffers. Since there is only
iscsi transports, which are byte-aligned, and the network does it's
own highmem bouncing, in practice there is no such bug.

But you are right, not thanks to block policy.

> Thanks.
> 

The solution to this, I think, is that the bouncing layer should receive a
residual count, and not bounce anything beyond what's transferred. (On reads,
writes does nothing), and zero-out the rest. This of course means that all
block drivers make sure residual is properly set, the way it should as explained
in this thread. (SCSI does the right thing where it can, for example
see scsi_execute())

Thanks for bringing this up. Another unfortunate item on my todo list.
Boaz

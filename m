From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Debugging scsi abort handling ?
Date: Tue, 26 Aug 2014 21:19:51 +0200
Message-ID: <53FCDDD7.1020608@redhat.com>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>		 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>		 <53FB1ACD.1040208@redhat.com> <53FB1D4F.5070606@redhat.com>		 <53FB2083.9000208@redhat.com> <1408981299.17968.27.camel@jarvis.lan>	 <53FC4193.4010808@redhat.com> <1409078078.3812.25.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaHZTT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 15:19:56 -0400
In-Reply-To: <1409078078.3812.25.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

Hi,

On 08/26/2014 08:34 PM, James Bottomley wrote:
> On Tue, 2014-08-26 at 10:13 +0200, Hans de Goede wrote:
>> Hi,
>>
>> On 08/25/2014 05:41 PM, James Bottomley wrote:
>>> On Mon, 2014-08-25 at 13:39 +0200, Paolo Bonzini wrote:
>>>> Il 25/08/2014 13:26, Hans de Goede ha scritto:
>>>>> Thanks Bart and Paolo, your insights into this are greatly appreciated.
>>>>>
>>>>> So with uas there are separate usb transaction for cmd, data in, data out
>>>>> and sense for each tag. At the time of abort, usually one of data in / data
>>>>> out and a sense usb transaction will be outstanding.
>>>>>
>>>>> There already is logic in the driver to kill the data in / out transactions
>>>>> if a sense gets returned (usually with an error) before they are done.
>>>>>
>>>>> So if I'm reading this correctly, then on a successful abort, the sense
>>>>> transaction (if not already completed by the target) should be cancelled as
>>>>> it will never complete, correct ?
>>>>
>>>> Yes.  More precisely, once the response IU comes back for the abort,
>>>> there should be no more IUs for that task.  Figure 13 ("Multiple Command
>>>> Example") in the UAS spec actually shows that.
>>>>
>>>> At least, that's what it should be like in theory.  I suspect firmware
>>>> bugs will abound in this area, but at least you shouldn't be actively
>>>> expecting an IU for an aborted task.
>>>
>>> Just a note on this.  The abort area in all devices is where we have
>>> scope for spec compliance issues.  Also in the old days abort itself
>>> could trigger a firmware crash on some devices (including arrays).  The
>>> problem is actually that the system is usually groaning because it's out
>>> of memory within the controller.  That actually means that sending in
>>> another task (the abort) causes greater pressure.  For this reason, some
>>> device drivers choose to skip the abort step and head straight to reset.
>>> For reset, you guarantee that all outstanding tasks for the unit are
>>> killed.
>>
>> Hmm, I like this idea, given the finickiness of the abort path in the uas
>> driver, and that:
>>
>> 1) We really have no proper way to test this
>> 2) We already have some known issues there (we don't kill sense urbs atm,
>>     and I've a note somewhere about a double free on some corner case
>>     where an urb submit fails)
>> 3)
>> 3) In all the cases where I've managed to trip op an uas device the only
>>     thing which actually worked to recover things was doing a usb reset
>> 4) Aborts should not happen in the first place, so using a big hammer
>>     when they do is not really a big problem, instead we should focus
>>     on figuring out why they happen and fix the cause
>>
>> I think that just dropping abort handling altogether is a good idea actually,
>> so if there are no objections I'm just going to do that.
>>
>> I can simply not set eh_abort_handler (aka set it to NULL), right ?
>
> Just so you know, if you do this, error handling becomes much more
> painful.  The abort handler can now handle aborting and retrying without
> pausing the host.  The reset definitely stops the host and causes a big
> and noticeable burp in processing.  However, there are hosts which have
> to do it.

I understand, but shouldn't aborts be something which rarely happens.
I guess that with a faulty drive they happen more often, but at this
point in time the uas driver's error handling problems are mostly with
dealing with timeouts during probing, which are likely caused by
the device not grokking some command we've send, and responding to
this in a bad manner (hanging mostly).

So I'm tempted to just remove the abort handling, and first focus on
getting uas stable under all conditions. Once it is stable we can
look into making it deal more graciously with errors.


>
>> ###
>>
>> What about a logical unit reset ? Is that worth trying first? Or is that
>> likely to just trip up more firmware bugs (uas == usb == cheap == lots of
>> those) ?
>>
>> Going straight to an usb device reset would significantly simplify the code,
>> but is not really friendly toward other usb drivers for a multi-function
>> uas device (of which I've seen no so far, but they are bound to happen).
>>
>> So I guess that trying a logical unit reset first would probably be a good
>> idea.
>
> Yes, that's the eh_device_reset_handler() callback.
>
>> I know that it works in non error conditions as I've inserted one (in my
>> local tree only) in the probe path to test task management functions in
>> general. It has never really been tested under error conditions since the
>> uas code can only run one task management function at a time (there is 1
>> tag reserved for task management functions)
>
> Wait, could this also be your abort problem?  In the running abort
> handler, we could get a scenario where we abort a bunch of commands at
> the same time.

I don't think so, the uas code does not return from eh_abort_handler
until the abort has either succeeded or timedout (for which a 3 second
timeout is used). AFAIK the scsi core will always issue multiple aborts
sequentially, right. And if the abort succeeds then the tag is free
again for the next abort. Only if an abort fails (times out, which is
what I've seen in all the error conditions which I've encountered so far),
then will subsequent aborts, and the logical unit reset, fail due to
there not being a free tag to use for them.

Thanks for answering all my other questions.

Regards,

Hans

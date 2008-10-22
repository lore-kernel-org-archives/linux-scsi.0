From: "Fabio Comolli" <fabio.comolli@gmail.com>
Subject: Re: Possible bug in SCSI Kconfig
Date: Wed, 22 Oct 2008 21:29:37 +0200
Message-ID: <b637ec0b0810221229n636ef47er78f119617ef93085@mail.gmail.com>
References: <b637ec0b0810220929r2c889423ma92bef0ec7f9b3b0@mail.gmail.com>
	 <48FF726D.9060504@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40158 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315AbYJVT3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 15:29:39 -0400
Received: by gxk9 with SMTP id 9so58305gxk.13
        for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2008 12:29:37 -0700 (PDT)
In-Reply-To: <48FF726D.9060504@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, sam@ravnborg.org, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

Hi.

On Wed, Oct 22, 2008 at 8:35 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> (adding Cc: LSML and author)
>
> On 10/22/2008, Fabio Comolli wrote at LKML:
>> Hi.
>> In kernel 2.6.27.2 - drivers/scsi/Kconfig we have:
>>
>> config SCSI_WAIT_SCAN
>>         tristate
>>         default m
>>         depends on SCSI
>>         depends on MODULES
>>
>> The tristate field is empty. This has the effect that this option is
>> not visible in menuconfig and so it's always selected. The default is
>> "m" for all architectures and so this module is always compiled if
>> SCSI and MODULES are both enabled.
>>
>> I'm using a patch like this one:
>>
>>  config SCSI_WAIT_SCAN
>> -     tristate
>> +     tristate "Wait until all the async scans are complete"
>>       default m
>>       depends on SCSI
>>       depends on MODULES
>>
>> to get rid of that module.
>>
>> Of course, I have no idea if this is correct or the current behavior
>> is the expected one.
>>
>> Regards,
>> Fabio
>
> What's the correct behaviour is contentious.  There have been complaints
> that it shouldn't be built if it is not needed.  However, how it
> currently works is how those who added and merged that feature thought
> that it should be.
>
> Notes on your suggestion:
>
>  - If you make it a visible prompt, you should also add a help text.
>    No Kconfig prompts without good help text, please!
>
>  - The suggested prompt text doesn't describe the matter too well.
>    scsi_wait_scan rather is a module which userland can use to get
>    a signal for when scans (by some but not all transports) are done.
>    (The signal is the end of module initialization of the
>    scsi_wait_scan module.)  I.e. the kernel as a whole doesn't
>    necessarily wait, just this module does.
>

Well, I didn't mean to have the patch merged. My point was just to
understand if the Kconfig was correct.

> You could use the comment in drivers/scsi/scsi_wait_scan.c and the
> changelog of
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3e082a910d217b2e7b186077ebf5a1126a68c62f
> as a basis for the Kconfig help text.  You could actually add a help
> text even to invisible prompts, just for documentation purposes.

Well, the first line of comment in that file reads "This is a simple
module to wait until all the async scans are complete." More or less
the text I added to the tristate.

> --
> Stefan Richter
> -=====-==--- =-=- =-==-
> http://arcgraph.de/sr/
>

Regards,
Fabio

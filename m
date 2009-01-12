From: "linux linux" <linux.tina@gmail.com>
Subject: Re: need fusion driver guide
Date: Mon, 12 Jan 2009 21:43:18 +0530
Message-ID: <e7b7bf130901120813x3e7a178cwbd17435d669b0e78@mail.gmail.com>
References: <20090106214538.GA18370@uranus.ravnborg.org>
	 <1231278625.10475.28.camel@localhost.localdomain>
	 <e7b7bf130901062002ke59c0dkd7ca0ed73352066f@mail.gmail.com>
	 <1231302074.19352.12.camel@localhost.localdomain>
	 <e7b7bf130901062124r18d93598jabcd5628f3cdca41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:40513 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZALQNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 11:13:22 -0500
In-Reply-To: <e7b7bf130901062124r18d93598jabcd5628f3cdca41@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

HI James,

I got some idea about fusion driver from this link
http://bugzilla.kernel.org/show_bug.cgi?id=12195

And i found there is bug in fusion driver (kernel version 2.6.10) from this link
http://www.nabble.com/MPT-fusion-driver,-better-but-still-buggy-at-errors-handling-under-2.6-td1095505.html



On Wed, Jan 7, 2009 at 10:54 AM, linux linux <linux.tina@gmail.com> wrote:
> Hi James,.
> Now it should be received by all...
> Many many thanks for the help.
>
> I am sending the kernel log.
>
>
> On Wed, Jan 7, 2009 at 9:51 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>>
>> You still need to turn off html email attachments, otherwise your
>> messages won't be accepted by the mailing lists.  It will be an option
>> like recipient wants text/plain only or something.
>>
>> On Wed, 2009-01-07 at 09:32 +0530, linux linux wrote:
>> > Hi,
>> >
>> > Sam many thanks for ur help.
>> >
>> > Hi James,
>> >
>> > I am getting some error on for fusion device driver.
>> > The error message look like this
>> >
>> >
>> >        2F240F4C226078: 19/12/2008 EST 04:42:45, mptscsih: ioc1: >>
>> > Attempting task abort! (sc=e40df080)
>> >        2F240F6E8C2E00: 19/12/2008 EST 04:42:45, mptbase: ioc1:
>> > IOCStatus(0x0048): SCSI Task Terminated
>> >        2F240F6E905A98: 19/12/2008 EST 04:42:45, mptscsih: ioc1: >>
>> > Attempting task abort! (sc=f7e23680)
>> >
>> > 2F24117BDA2438: 19/12/2008 EST 04:42:50, mptscsih: ioc1: >>
>> > Attempting bus reset! (sc=e40df080)
>> >
>> > After then the server has been rebooted.
>> >
>> > I can see the code is written inside /drivers/message/fussion/
>> > mptscsih.c
>> > The responsible function is
>> > mptscsih_host_reset()
>> > i am very new in SCSI fusion device driver. read some help guide from
>> > google but still i do not understand when the mptscsih_host_reset() is
>> > called by kernel. I normal situation i am not able to see this message
>> > in kernel log.
>> > Can any one help me to understand when these type of kernel message
>> > are comming, is it foe SCSI hardware problem ?
>> > when mptscsih_host_reset() will be executed?
>>
>> It looks like a standard error handling escalation sequence.  Why is
>> very hard to tell without the entire kernel log.  Why there wasn't a
>> recovery is also not clear.
>>
yes its error handler sequence. But as describe into the above
link(http://www.nabble.com/MPT-fusion-driver,-better-but-still-buggy-at-errors-handling-under-2.6-td1095505.html)
that
2.6.xx  xx <= 11, enters an infinit loop attempting to reset the SCSI
        so the box gets unusable and requires a rough power cycle to recover.

So i think that is  the reason to restart the server(after "Attempting host
reset! )as a power cycle is required to recover.

when next time server was booting i got  some kernel messages on
recovery of SCSI. So recovery is done after reboot the server.

Still i do not know how to over come this bug fo infinite loop. If you
have any suggestion please let me know.







>
> Pls let me know when this kind of error handler is happened?
> is it for SCSI hard ware failure?
>
>> > Only one time i show this message in my kernel log, is there any way
>> > to reproduce this message manually?
>> >
>> > where i get much info regarding this issue and SCSI fusion kernel
>> > driver except kernel code itself?
>> >
>> > I am writting this after reading help doc from
>> > http://www.lsi.com/insight_center/tech_trends/advanced_architectures/fusionmpt/index.html
>> >
>> > But still i am very few knowledge to solve it.
>> >
>> > waiting for your help.
>>
>> There's not much else I can do.  If you post the entire kernel log, the
>> fusion people hang out on this list and might see something that
>> indicates what the problem is.
>>
>> James
>>
>>
>

Thanks
Tina
http://teachmeembedded.blogspot.com/

From: Grant Grundler <grundler@google.com>
Subject: Re: READ CAPACITY 16
Date: Wed, 17 Dec 2008 10:57:20 -0800
Message-ID: <da824cf30812171057m2ba07cabh9c54591600493ee0@mail.gmail.com>
References: <20081217164210.GC19967@parisc-linux.org>
	 <da824cf30812170950p393be2fq729e98e93edef5dc@mail.gmail.com>
	 <20081217180640.GE19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:29524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYLQS6n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2008 13:58:43 -0500
Received: from spaceape9.eur.corp.google.com (spaceape9.eur.corp.google.com [172.28.16.143])
	by smtp-out.google.com with ESMTP id mBHIwg9g010738
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 10:58:42 -0800
Received: from bwz8 (bwz8.prod.google.com [10.188.26.8])
	by spaceape9.eur.corp.google.com with ESMTP id mBHIweer030155
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 10:58:40 -0800
Received: by bwz8 with SMTP id 8so95611bwz.14
        for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2008 10:58:40 -0800 (PST)
In-Reply-To: <20081217180640.GE19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 17, 2008 at 10:06 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Dec 17, 2008 at 09:50:52AM -0800, Grant Grundler wrote:
>> > Algorithm A (a perfect world):
>> >
>> > Issue RC16
>> >  -> If it fails, issue RC10
>> >  -> If it times out, reset the device, issue RC10
>> >
>> > Algorithm B:
>> >
>> > Issue RC10
>> > Issue RC16
>> >  -> If it succeeds, use its results in preference to those from RC10
>> >  -> If it fails, carry on with the results from RC10
>> >  -> If it times out, reset the device, carry on with the results from RC10
>>
>> I fail to see an effective difference between Algo A and B.
>
> Whether to issue an RC10 before issuing an RC16 or not.  It matches what
> we currently do better (we currently issue an RC10 and then issue an
> RC16 if RC10 reports we have 0xffffffff LBAs).

Sorry, I was thinking the case of RC16 timing out.
We end up timing out on the RC16 for the given device in both Algo.
Current behavior is shaped by device behaviors and the need to get a
valid LBA count.
New behavior will be shaped by the same thing PLUS additional fields
you pointed out.

>
>> The question really is one you already asked:
>> > ...The question is what to do about devices that either
>> > hang or take a long time to respond to an RC16 command.
>>
>> A few ideas:
>> 1) maintain a blacklist
>
> Which is obviously what we're trying to avoid doing.

Yes.  But it won't be the first blacklist linux kernel has.
Similarly, adding a kernel command line flag to modify behavior also sucks.

>> 2) anything in RC10 or IDENTIFY that would clue us about RC16 functionality?
>>     If so, then something like B or C would make sense.
>
> RC10 only returns number of LBAs and how many bytes per LBA.  I don't
> see anything in the INQUIRY data (other than the protection bit, which
> we already use to know that RC16 is supported).  We could maybe key off
> scsi_level > SCSI_2 like scsi_device_protection() does.  This would work
> for ATA SSDs because libata reports SCSI ANSI revision 05, but it won't
> work for USB devices because they get mangled down to SCSI_2, no matter
> what they support.

Ugh. So fixing this for USB would require sorting out why USB devices
get "down graded".

>
>> 3) How long does Read Capacity16 normally take?  e.g. at boot time with drive
>>    that isn't spun up yet or equivalent from RAID device.
>>    If it's not that long (e.g < 1sec or so) then just use a shorter
>> timeout in general?
>>    With parallel scanning, it should be tolerably painful.
>
> I don't know how long it'll take.  I was hoping people with experience
> in this matter would chime in.

Since this is forward looking, I'd think someone would need to ping HD
and other storage vendors. Are any subscribed to linux-scsi?

thanks,
grant

From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Any known issues to cause data miscompares on sg read/write on
 2.6.15.4 and 2.6.18-rc2?
Date: Sun, 20 Aug 2006 21:22:18 -0400
Message-ID: <44E90ACA.4090402@torque.net>
References: <8202f4270608200230s34aa9505s2426f3f3b90fa7ec@mail.gmail.com>	 <20060820104255.25c88623.akpm@osdl.org> <8202f4270608201619p7906c7b8yf3f9b6e311acd31c@mail.gmail.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8202f4270608201619p7906c7b8yf3f9b6e311acd31c@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com, htejun@gmail.com, alan@lxorguk.ukuu.org.uk, rmk@arm.linux.org.uk
List-Id: linux-scsi@vger.kernel.org

Fajun Chen wrote:
> Hi Andrew,
> 
> The part of the puzzle is that I have not found a baseline where it
> works. I do need to do more controlled and comparative testing. One on
> my list is to test the same code on i386 hardware.  It's also a good
> idea to test without using SG as you suggested. But what are my
> alternatives to get both PATA and SATA support without sg? sd
> interface, sg read/write instead of sg ioctl (probably little code

Fajun,
I assume you meant "_sd_ read/write instead of sg ioctl". If
so, then FYI, the SG_IO ioctl is available on all block devices
that accept SCSI commands in the lk 2.6 series. There are
some small differences (see www.torque.net/sg/sg_io.html )
but I would think that your test programs using the sg
driver should work ok with the sd driver. Direct and
mmap()-ed IO are done differently.

> difference here).  For PATA, IDE path may be worthy of testing, but it
> would require quite extensive change to my test application.

>From Russell King's earlier response it sounds like
it could be an architecture issue. Quite a few
folks use the sg driver for SCSI and SATA device
bashing.

Doug Gilbert

> On 8/20/06, Andrew Morton <akpm@osdl.org> wrote:
>> On Sun, 20 Aug 2006 03:30:56 -0600
>> "Fajun Chen" <fajunchen@gmail.com> wrote:
>>
>> > Hi Folks,
>> >
>> > I use ATA pass through via sg ioctl interface for data read/write. Two
>> > kernels were tested:
>> > Linux 2.6.15.4 with Jeff Garzik's libata patch (pata support)
>> > Linux 2.6.18-rc2 with Jeff Garzik's git libata patch (new EH, hotplug,
>> > pata support)
>> > Hardware: ARM IOP80321 with PCI-X
>> > Host adapters: sata Sil3124 and pata Sil680
>> > Test algorithm: random write-read-compare (same range)
>> >
>> > I've tried sg mmap, direct and indirect IO on both 2.6.18-rc2 and
>> > 2.6.15.4 release, none of the combinations survived data compare
>> > overnight test.  I also tried to change cache policy to write through
>> > on 2.6.15.4,  no luck either.  Several different symptoms were
>> > observed among the failures:
>> > 1. A few bytes in a data pattern were not written correctly to the
>> > disc (low data miscompare rate)
>> > 2. Pretty much none of the data were written correctly to the disc
>> > (high data miscompare rate)
>> > 3. Data were written to the disc correctly but miscompares when read
>> > it back. What's weird is that when the read buffer was printed out
>> > right after data miscompare , it contains the correct data!
>> > Sg write failures (symptom #1 and #2) are more typical than read
>> > failure (symptom #3).  This problem has been observed on many
>> > different test machines with both pata and sata drives.
>> >
>> > I don't know of a good way to trace and isolate the problem yet. Since
>> > data miscompare issue can be caused by issues from different
>> > subsystems, I cc'ed some subsystem maintainers here.  Any information
>> > or suggestions are greatly appreciated.
>> >
>>
>> Have you tested the same hardware to the same extent without using the SG
>> interface?  Say, using read() and write()?  That'll help us determine
>> whether the problem is related to the sg stuff, or to something else,
>> like
>> a hardware failure.
>>
> 


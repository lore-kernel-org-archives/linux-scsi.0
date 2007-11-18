From: Mark Lord <liml@rtr.ca>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Sun, 18 Nov 2007 18:07:11 -0500
Message-ID: <4740C59F.50709@rtr.ca>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>	 <473E6E62.9090309@rtr.ca>	 <8202f4270711162320s2eb1d48dwb1430f4a779809a9@mail.gmail.com>	 <473F15E1.5030601@rtr.ca>	 <8202f4270711171120nddf24a8m8d1ece8c41b6c1ab@mail.gmail.com>	 <473F4724.6010107@rtr.ca>	 <8202f4270711172248x5d7abb0aq7a6e1bf2dad44e5e@mail.gmail.com>	 <47404CFC.7050405@rtr.ca>	 <8202f4270711181114w67632260la995daf65f507313@mail.gmail.com>	 <47409872.3060500@rtr.ca> <8202f4270711181429x13782fc4x4db3568607f7f23e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8202f4270711181429x13782fc4x4db3568607f7f23e@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Fajun Chen wrote:
>
> As a matter of fact, I'm using /dev/sg*.  Due to the size of my test
> application, I have not be able to compress it into a small and
> publishable form. However, this issue can be easily reproduced on my
> ARM XScale target using sg3_util code as follows:
> 1. Run printtime.c attached,  which prints message to console in a loop.
> 2. Run sgm_dd (part of sg3_util package, source code attached) on the
> same system as follows:
>> sgm_dd if=/dev/sg0 of=/dev/null count=10M bpt=1
> The print task can be delayed for as many as 25 seconds. Surprisingly,
> I can't reproduce the problem in an i386 test system with a more
> powerful processor.
> 
> Some clarification to MAP_ANONYMOUS option in mmap(). After fixing a
> bug and more testing, this option seems to make no difference to cpu
> load. Sorry about previous report. Back to the drawing board now :-)
..

Okay, I don't see anything unusual here.  The code is on a slow CPU,
and is triggering 10MBytes of PIO over a (probably) slow bus to an ATA device.

This *will* tie up the CPU at 100% for the duration of the I/O,
because the I/O happens in interrupt handlers, which are outside
of the realm of the CPU scheduler.

This is a known shortcoming of Linux for real-time uses.

When the I/O uses DMA transfers, it *may* still have a similar effect,
depending upon the caching in the ATA device, and on how the DMA shares
the memory bus with the CPU.

Again, no surprise here.

One way to deal with it in an embedded device, is to force the
application that's generating the I/O to self-throttle.
Or modify the device driver to self-throttle.

You may want to find an embedded Linux consultant to help out
with this situation if it's beyond your expertise.

Cheers

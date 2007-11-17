From: James Chapman <jchapman@katalix.com>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Sat, 17 Nov 2007 17:13:56 +0000
Message-ID: <473F2154.3010201@katalix.com>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>	 <473E59D1.2010903@gmail.com> <8202f4270711162214oe4da2dfx90a5bfd1b644d009@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <8202f4270711162214oe4da2dfx90a5bfd1b644d009@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fajun Chen wrote:
> On 11/16/07, Tejun Heo <htejun@gmail.com> wrote:
>> Fajun Chen wrote:
>>> I use sg/libata and ata pass through for read/writes. Linux 2.6.18-rc2
>>> and libata version 2.00 are loaded on ARM XScale board.  Under heavy
>>> cpu load (e.g. when blocks per transfer/sector count is set to 1),
>>> I've observed that the test application can suck cpu away for long
>>> time (more than 20 seconds) and other processes including high
>>> priority shell can not get the time slice to run.  What's interesting
>>> is that if the application is under heavy IO load (e.g. when blocks
>>> per transfer/sector count is set to 256),  the problem goes away. I
>>> also tested with open source code sg_utils and got the same result, so
>>> this is not a problem specific to my user-space application.
>>>
>>> Since user preemption is checked when the kernel is about to return to
>>> user-space from a system call,  process scheduler should be invoked
>>> after each system call. Something seems to be broken here.  I found a
>>> similar issue below:
>>> http://marc.info/?l=linux-arm-kernel&m=103121214521819&w=2
>>> But that turns out to be an issue with MTD/JFFS2 drivers, which are
>>> not used in my system.
>>>
>>> Has anyone experienced similar issues with sg/libata? Any information
>>> would be greatly appreciated.
>> That's one weird story.  Does kernel say anything during that 20 seconds?
>>
> No. Nothing in kernel log.
> 
> Fajun

Have you considered using oprofile to find out what the CPU is doing
during the 20 seconds?

Does the problem occur when you put it under load using another method?
What are the ATA and network drivers here? I've seen some awful
out-of-tree device drivers hog the CPU with busy-waits and other crap.
Oprofile results should show the culprit.

-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development


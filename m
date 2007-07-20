From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Subject: Re: ESP SCSI and QLGC,ISP SCSI drivers not finding attached devices
Date: Fri, 20 Jul 2007 16:22:37 +0100 (BST)
Message-ID: <Pine.LNX.4.61.0707201602080.7721@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707201404250.7470@mtfhpc.demon.co.uk>
 <1184941136.3455.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <1184941136.3455.8.camel@localhost.localdomain>
Sender: sparclinux-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi James,

Thansk for the info. I will try some experiments and see if I can work 
out where the scsi commands/responses are getting lost.

I do not beleave the issue with the ESP is a hardware problem. The PROM 
and SunOS-4.1.1 have no problem finding/accessing the disk on the ESP and 
I did not observe any issues prior to testing Linux v2.6.22. The V1 ESP 
SCSI driver never failed to find the ESP disk (on kernels that got that 
far) but I have not done as much testing with the V2 ESP driver as memory 
problems post v2.6.21 needed to be fixed to get things up and running.

Regards
 	Mark Fortescue.

On Fri, 20 Jul 2007, James Bottomley wrote:

> On Fri, 2007-07-20 at 14:26 +0100, Mark Fortescue wrote:
>> I have been having intermittant issues with the QLGC,isp driver
>> (qlogicpti.c) not finding any attached devices on my sun4c. Having now
>> moved on to Linux-2.6.22 this problem is now also affecting the ESP SCSI
>> driver and is nolonger intermittant.
>>
>> My test setup uses an NFS root so it is currently independent of the SCSI
>> drivers/subsystem. I am hoping to change this in the near future so that
>> my sun4c boots into linux by default.
>>
>> What kernel options can I use to try to work out why the drivers are
>> ignoring disks (there are no other types of attached device at present).
>> Are any special options needed to force the scsi subsystem to spin the
>> disk up and wait untill they become ready (The disk [target 0:0:3] on the
>> ESP auto-spins down if it is idle for too long and now that booting takes
>> longer ...) ?
>
> nothing in the driver ... that's a firmware issue.  What all SPI drivers
> do is address the device and wait 250ms for a response (as per the
> standard).  If nothing comes back, they assume there's nothing on the
> bus.  You might be able to increase the no connect timeout, but it looks
> to be a firmware property of both qlogicpti and esp (and if you do this,
> scanning will take longer).  250ms is a huge amount of time in SPI, so
> I'd suspect there was some type of bus or device problem.
>
>> Is there a way to get a NON-moduler scsi driver to re-scan its SCSI bus
>> from shell prompt (writing to a sysfs/procfs file)?
>
> /sys/class/scsi_host/host<n>/scan
>
>>> From my point of view, it looks like the command timeout is very much too
>> short. Is there a simple way of testing this theory on the ESP driver?
>
> See above, but really 250ms should be more than adequate.
>
> James
>
>
>
>

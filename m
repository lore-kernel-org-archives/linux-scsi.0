From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2.6.13 2/14] sas-class: README
Date: Tue, 13 Sep 2005 20:13:09 +1000
Message-ID: <4326A635.3020400@torque.net>
References: <4321E4DD.7070405@adaptec.com> <432543C6.1020403@torque.net> <4325CB10.1020902@adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750723AbVIMKMg@vger.kernel.org>
In-Reply-To: <4325CB10.1020902@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 09/12/05 05:00, Douglas Gilbert wrote:

<snip>

>>Putting distributed state information in sysfs and then
>>passing off the responsibility for maintaining its state
>>(because it is a difficult problem) brings into question
>>the wisdom of the strategy.
> 
> 
> No Doug, not true at all.
> 
> Sorry that "sg" isn't going to be used to communicate with
> expanders, but this is just part of evolution.

That is a relief, retired at last.

> If I removed "ready_led_meaning" and a couple of other
> such entries: you would have NO argument.

less ...

> If I left only the directory entries representing the
> object and the "smp_portal" you argument falls apart.
> 
> Instead, you should've been saying how easy and
> _elegant_ it is communicating with expanders on the
> domain:
> 	* open(2) the "smp_portal" in the expander
>           directory you want to talk to,
> 	* write(2) the SMP frame you want to send,
> 	* read(2) the amount of information you
> 	  expect to get,
> 	* close(2).
> 
> Done!  No addressing to figure out, no memory problems, etc.
> The easiest interface: read(2)/write(2), _and_ the simplest
> format to use: pure SMP frames, easy and straightforward.

It is impressive how elegant a passthrough can be when
one dispenses with a bit of metadata such as per command
timeouts and 3 levels of error messages (i.e. from the
driver, from the link layer and from the SMP target).
I always enjoy getting EIO in errno.

This all seems so frustrating; a LLD injects a
command/frame/whatever into an initiator and waits for
a response or something to happen. Networking code faces
the same scenario and presents it "as is" to the user
space (for any application that cares). Yes, there are
messy details. However in the SCSI subsystem we want to
hide this simple reality with all these wierd and
wonderful abstractions.

Doug Gilbert

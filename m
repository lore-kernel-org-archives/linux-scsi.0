From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Fri, 24 Sep 2010 00:41:48 -0400
Message-ID: <4C9C2C0C.4070506@interlog.com>
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com> <4C9C129E.5050504@teksavvy.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C9C129E.5050504@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10-09-23 10:53 PM, Mark Lord wrote:
> On 10-09-23 08:05 PM, Douglas Gilbert wrote:
>> Mark,
>> If you issued the SG_IO ioctl with a timeout of at
>> least 66 minutes (expressed in milliseconds) then
>> it looks like ata_scsi_queuecmd() has a problem.
> ..
>
> Mmm.. more like blk_execute_rq() perhaps.
> That's where the wait_for_completion(&wait) call is at.
>
> Perhaps I should change it to wait in smaller increments,
> so that the lockup detection doesn't trigger on it..
>
> Doing that seems rather wasteful, though.
>
> Note that this is the ATA "SECURITY ERASE" command,
> which doesn't have an "immed" bit to toggle.
> So one must wait for it to complete.

And I have seen another issue with long (SCSI) commands.
During a FORMAT UNIT another pesky program might
have nothing better to do than periodically send out
things like TEST UNIT READY (check a disk is ready
for IO) which will have a normal timeout on it (e.g.
60 seconds). With a format underway, the HBA or the device
may not accept the TEST UNIT READY so its timeout expires
and the error handling code thinks the device is unwell
and decides to reset it.

There is a useful flag in the scsi_device structure called
no_uld_attach which hides a device from the sd driver
(assuming it is a disk). Then the disk can only be accessed
via the bsg or sg driver. And those other pesky programs
can't find the disk in question. I'm not aware of a way
to control that flag from the user space.

Doug Gilbert

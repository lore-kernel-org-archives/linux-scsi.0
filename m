From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Tue, 20 Apr 2010 13:48:17 -0400
Message-ID: <4BCDE8E1.3040509@interlog.com>
References: <Pine.LNX.4.44L0.1004201045180.1837-100000@iolanthe.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:57241 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab0DTRsb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2010 13:48:31 -0400
In-Reply-To: <Pine.LNX.4.44L0.1004201045180.1837-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Mark Lord <mlord@pobox.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>

Alan Stern wrote:
> On Mon, 19 Apr 2010, Sarah Sharp wrote:
> 
>> Updated description
>> -------------------
>>
>> Summary:
>>
>> The Buffalo USB3 hard drive fails to mount after being sent an ATA_16
>> IDENTIFY command.  It does not fail when the device is connected via a
>> USB 2.0 cable and the same command is sent.
> 
> I don't like this summary.  The failure to mount is caused by a defect
> in the earlier versions of xhci-hcd (no support for USB port reset),
> not by a bug in the drive.  I don't recall seeing a test using the old
> version of hdparm and an updated xhci-hcd, but presumably such a 
> combination would work okay.
> 
> The real problem with the Buffalo drive is that it responds with a
> phase error when it receives an ATA_16 IDENTIFY DEVICE command with the
> Sector Count field set to 0.
> 
>> Details:
>>
>> There seems to be an issue with how the Buffalo USB3 hard drive handles
>> the SCSI ATA pass through commands.  We found this issue with the Linux
>> userspace program hdparm, using the Ubuntu Linux Karmic distribution.
>> The device responds correctly to an IDENTIFY DEVICE via the ATA_12
>> tunnel, but it responds with a Phase Error when it's sent an IDENTIFY
>> DEVICE via the ATA_16 tunnel, and then stalls.
> 
> You should not say anything about the drive stalling.  For one thing,
> it's misleading: The drive doesn't stall but rather it sends a STALL
> token to indicate that the bulk-IN endpoint is halted.  For another,
> the STALL is sent _before_ the phase error is reported, not after.  
> Lastly, there's absolutely nothing wrong with halting the endpoint like
> this; in fact, the Bulk-Only Transport specification requires it under
> these circumstances.
> 
>> The hdparm program thinks the Phase Error is an invalid response:
>>
>> sudo hdparm --verbose /dev/sdb
>>
>> /dev/sdb:
>> outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
>> SG_IO: ATA_16 status=0x0, host_status=0x7, driver_status=0x0
>> SG_IO: bad response (not CHECK_CONDITION)
>> outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 a1 00
>> SG_IO: ATA_16 status=0x0, host_status=0x7, driver_status=0x0
>> SG_IO: bad response (not CHECK_CONDITION)
>>  HDIO_DRIVE_CMD(identify) failed: Invalid exchange
>>  readonly      =  0 (off)
>>  readahead     = 256 (on)
>>  geometry      = 36365/64/32, sectors = 0, start = 0
> 
> Why include two separate commands here?  I thought you were interested
> only in the response to the ATA_16 IDENTIFY DEVICE (the first outgoing
> cdb above).
> 
>> Stalling on the ATA_16 IDENTIFY device is fine, but the invalid response
>> is not.
> 
> Again, don't mention stalling.  Notice that the information from hdparm
> does not show the exact nature of the problem (i.e., that the drive
> responded with a phase error), only that a problem occurred.  This 
> makes it less useful than you might like.
> 
>> The hard drive does not seem to work after this command is sent, and
>> cannot be mounted.  If we inhibit udev from running hdparm (by stopping
>> the udev daemon) then the drive can be mounted successfully.
> 
> First, this is true only if the drive is attached using USB 3.0.  
> Second, after this command the drive still works fine -- xhci-hcd is
> what doesn't work.
> 
>> If the drive is plugged in via a USB 2.0 cable, then the drive works
>> correctly, even though it gets issued the same commands.
> 
> Right.  That's because the larger problem is in xhci-hcd, not in the
> drive.
> 
>> The command before the ATA_16 IDENTIFY DEVICE was a SET FEATURES via the
>> ATA_16 tunnel, and it was responded to properly, so we think it should
>> support the ATA_16 commands.
> 
> This is wrong.  The first command shown above is ATA_16 IDENTIFY 
> DEVICE.  The second command is ATA_16 IDENTIFY PACKET DEVICE.
> 
> To summarize: 0xef is SET FEATURES, 0xec is IDENTIFY DEVICE, and 0xa1 
> is IDENTIFY PACKET DEVICE.  The command byte is the second-to-last in 
> each cdb.
> 
>> The full kernel log is here:
>> http://minilop.net/~sarah/buffalo-hd-ata-16-issue.log
> 
> I just tried to view that page and got a "403 Forbidden" error.  Does 
> it contain the kernel log for the hdparm test shown above, or is it a 
> log for a different test?  My guess is that it's a different test -- 
> you should mention that fact and describe the commands sent in the 
> other test.
> 
>> The ATA_12 IDENTIFY command
> 
> You mean IDENTIFY DEVICE.  There is no ATA IDENTIFY command.
> 
>>  starts at line 8816.  (It says the command
>> is a BLANK command, but it's incorrectly identified that command.)

Picking up an earlier point, SCSI opcode A1h is both:
    - BLANK  (for optical devices: CD/DVD/BD)
    - ATA PASS THROUGH (12)  (for disks [both
      normal (SBC) and RBC])

Only SCSI primary commands (SPC) have a 1 to 1 mapping
with an opcode (ignoring service actions). So debug
code in the kernel can be slightly misleading when
trying to decode a SCSI command opcode that is not a
"primary" command.

Doug Gilbert

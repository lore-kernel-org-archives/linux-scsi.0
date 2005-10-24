From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: infinite loop with 36 Byte inquiry (sbp2 regression in	2.6.14-rcX)
Date: Mon, 24 Oct 2005 08:58:02 +0200
Message-ID: <435C85FA.3000409@s5r6.in-berlin.de>
References: <435ADA6D.4040705@s5r6.in-berlin.de> <1130107402.3437.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:7067 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751037AbVJXG6f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 02:58:35 -0400
In-Reply-To: <1130107402.3437.54.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.org>

James Bottomley wrote:
> On Sun, 2005-10-23 at 02:33 +0200, Stefan Richter wrote:
> 
>>I just noticed that devices which require sbp2's inquiry hack are not 
>>usable anymore. I don't know when the regression crept in since I don't 
>>remember when I used the affected device successfully the last time. One 
>>thing is for sure: The code change which triggered the regression took 
>>not place in sbp2 itself.
>>
>>The device in question is an older 2.5" FireWire disk, DViCO Momobay 
>>CX-1. What happens under Linux 2.6.14-rc5 is this: Without debug logging 
>>turned on, it seems as if the process which started the sbp2 probe 
>>(knodemgrd or modprobe) is hanging in D state. But debug logging enabled 
>>in sbp2 reveals that it isn't locked up but rather caught in a loop, 
>>sending inquiry commands:
>>
>>
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_module_init
>>>Oct 23 01:26:59 shuttle kernel: sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_probe
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_alloc_device
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_alloc_device: allocated hostinfo
>>>Oct 23 01:26:59 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_parse_unit_directory
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_management_agent_addr = f0010000
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_unit_characteristics = a08
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_command_set_spec_id = 609e
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_command_set = 104d8
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_firmware_revision = 2800
>>>Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: Node 1-01:1023: Using 36byte inquiry workaround
> 
> 
> I don't see any looping in the traces, could you characterise what's
> going on for those of us who haven't fully explored the sbp2 driver?

I cut the log. The portion

	kernel: ieee1394: sbp2: sbp2scsi_queuecommand
	[...]
	kernel: ieee1394: sbp2: SBP2_SCSI_STATUS_CHECK_CONDITION
	kernel: scsi0 : destination target 0, lun 0
	kernel:         command: Inquiry: 12 00 00 00 24 00
	kernel: bh: Current: sense key: Unit Attention

is repeated over and over. I would have digged deeper but ran out of time.
I will look further into it during the week.

> However, at a brief examination it looks like you do quite a lot of
> response snooping.  This always was broken for commands from userspace,
> but it's completely broken now we only use scatter/gather commands from
> block.
> 
> Secondly, I don't think your inquiry hack is effective any more, because
> you try to alter request_bufflen, which doesn't carry the length of a
> s/g command.
> 
> We have a device flag: BLIST_INQUIRY_36 which restricts the named
> devices only to having 36 byte inquiries sent.  Could your internal
> table be migrated up to the mid-layer list to avoid the issue
> altogether?

Yes, that would certainly be better.

But what about the note in scsi_devinfo.c?

  * Do not add to this list, use the command line or proc interface to add
  * to the scsi_dev_info_list. This table will eventually go away.

Thanks,
-- 
Stefan Richter
-=====-=-=-= =-=- ==---
http://arcgraph.de/sr/

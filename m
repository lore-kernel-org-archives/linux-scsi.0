From: Douglas Gilbert <dougg@torque.net>
Subject: Re: READ CAPACITY failed on ia64
Date: Thu, 30 Aug 2007 16:48:48 -0400
Message-ID: <46D72D30.2000903@torque.net>
References: <20070814115005.GA31094@bsd.hu> <20070814120808.GM16277@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbXH3UtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Aug 2007 16:49:18 -0400
In-Reply-To: <20070814120808.GM16277@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Robert Nagy <robert.nagy@gmail.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Aug 14, 2007 at 01:50:05PM +0200, Robert Nagy wrote:
>> In this box I get the following error message:
> 
> If you turn on CONFIG_SCSI_CONSTANTS, you'll get the error message
> decoded for you, but ...
> 
>> sd 0:0:2:0: [sdb] READ CAPACITY failed
>> sd 0:0:2:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
>> sd 0:0:2:0: [sdb] Sense Key : 0x3 [current]
> 
>         "Medium Error",     /* 3: Data error detected on the medium */
> 
>> sd 0:0:2:0: [sdb] ASC=0x31 ASCQ=0x0
> 
>         {0x3100, "Medium format corrupted"},
> 
>> I am currently running 2.6.22 but I've also tried with serveral other
>> (and older) kernels and it still can't get the capacity of the disk.
> 
> Looks like the disc is broken.  Given that a scsiformat doesn't fix it,
> it's probably irretrievable.

When a disk is formatted to a different sector size (say
from 528 bytes to 512) then a MODE SELECT followed by a
FORMAT is required. If the format fails or is interrupted
(say someone powers off the machine) then the disk is said
to be in "medium format corrupted" state.
Any attempt to access the media when the disk is in this
state will yield the reported error.

May I suggest that you try sg_format in sg3_utils.
Using sg_format without the '--format' option may show
you what is happening. For a healthy disk you would see
something like this:

# sg_format /dev/sda
    Linux     scsi_debug        1.82   peripheral_type: disk [0x0]
Mode sense (block descriptor) data, prior to changes:
  Number of blocks=16384 [0x4000]
  Block size=512 [0x200]
Read Capacity (10) results:
   Number of blocks=16384
   Block size=512 bytes
No changes made. To format use '--format'. To resize use '--resize'


You will probably see the same error in response to
the Read Capacity. The block size reported by
the Mode Sense (block descriptor) most likely doesn't
match some or all of your media.

Doug Gilbert


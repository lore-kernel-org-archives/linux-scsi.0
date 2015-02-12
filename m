From: Nate Dailey <nate.dailey@stratus.com>
Subject: Re: raid1 narrow_write_error with 4K disks, sd "bad block number
 requested" messages
Date: Thu, 12 Feb 2015 11:46:21 -0500
Message-ID: <54DCD8DD.7080103@stratus.com>
References: <54C9006A.2030807@stratus.com> <20150205155953.64e9b1e4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o147.mxlogic.net ([208.65.144.80]:45495 "EHLO
	p02c11o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbbBLQzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2015 11:55:07 -0500
In-Reply-To: <20150205155953.64e9b1e4@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

On 02/04/2015 11:59 PM, NeilBrown wrote:
> On Wed, 28 Jan 2015 10:29:46 -0500 Nate Dailey <nate.dailey@stratus.com>
> wrote:
>
>> I'm writing about something that appears to be an issue with raid1's
>> narrow_write_error, particular to non-512-byte-sector disks. Here's what
>> I'm doing:
>>
>> - 2 disk raid1, 4K disks, each connected to a different SAS HBA
>> - mount a filesystem on the raid1, run a test that writes to it
>> - remove one of the SAS HBAs (echo 1 >
>> /sys/bus/pci/devices/0000\:45\:00.0/remove)
>>
>> At this point, writes fail and narrow_write_error breaks them up and
>> retries, one sector at a time. But these are 512-byte sectors, and sd
>> doesn't like it:
>>
>> [ 2645.310517] sd 3:0:1:0: [sde] Bad block number requested
>> [ 2645.310610] sd 3:0:1:0: [sde] Bad block number requested
>> [ 2645.310690] sd 3:0:1:0: [sde] Bad block number requested
>> ...
>>
>> There appears to be no real harm done, but there can be a huge number of
>> these messages in the log.
>>
>> I can avoid this by disabling bad block tracking, but it looks like
>> maybe the superblock's bblog_shift is intended to address this exact
>> issue. However, I don't see a way to change it. Presumably this is
>> something mdadm should be setting up? I don't see bblog_shift ever set
>> to anything other than 0.
>>
>> This is on a RHEL 7.1 kernel, version 3.10.0-221.el7. I took a look at
>> upstream sd and md changes and nothing jumps out at me that would have
>> affected this (but I have not tested to see if the bad block messages do
>> or do not happen on an upstream kernel).
>>
>> I'd appreciate any advice re: how to handle this. Thanks!
>
> Thanks for the report.
>
> narrow_write_error() should use bdev_logical_block_size() and round up to
> that.
> Possibly mdadm should get the same information and set bblog_shift
> accordingly when creating a bad block log.
>
> I've made a note to fix that, but I'm happy to review  patches too :-)
>
> thanks,
> NeilBrown
>

I will post a narrow_write_error patch shortly.

I did some experimentation with setting the bblog_shift in mdadm, but it 
didn't work out the way I expected. It turns out that the value is only 
loaded from the superblock if:

1453        if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS) &&
1454            rdev->badblocks.count == 0) {
...
1473                rdev->badblocks.shift = sb->bblog_shift;

And this feature bit is only set if any bad blocks have actually been 
recorded.

It also appears to me that the shift is used when loading the bad blocks 
from the superblock, but not when storing the bad block list in the 
superblock.

Seems like these are bugs, but I'm not certain how the code is supposed 
to work (and am getting in a bit over my head with this).

In any case, it doesn't appear to me that there's any harm in having the 
bblog_shift not match the disk's block size (right?).

Nate Dailey


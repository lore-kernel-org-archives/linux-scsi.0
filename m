From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: Add udev-md-raid-safe-timeouts.rules
Date: Tue, 17 Apr 2018 07:28:42 -0400
Message-ID: <b6c08475-136d-b95c-61d1-c8776e6f4284@gmail.com>
References: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
 <5425366f-f339-d6f3-26d1-d02c3ba80671@gmail.com>
 <CAJCQCtRzmBys+eYsd=zsAK1deYQt47nysHQBdn3CreOmObz59g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRzmBys+eYsd=zsAK1deYQt47nysHQBdn3CreOmObz59g@mail.gmail.com>
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-lvm@redhat.com, Linux-RAID <linux-raid@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-04-16 13:10, Chris Murphy wrote:
> Adding linux-usb@ and linux-scsi@
> (This email does contain the thread initiating email, but some replies
> are on the other lists.)
> 
> On Mon, Apr 16, 2018 at 5:43 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2018-04-15 21:04, Chris Murphy wrote:
>>>
>>> I just ran into this:
>>>
>>> https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec
>>>
>>> This solution is inadequate, can it be made more generic? This isn't
>>> an md specific problem, it affects Btrfs and LVM as well. And in fact
>>> raid0, and even none raid setups.
>>>
>>> There is no good reason to prevent deep recovery, which is what
>>> happens with the default command timer of 30 seconds, with this class
>>> of drive. Basically that value is going to cause data loss for the
>>> single device and also raid0 case, where the reset happens before deep
>>> recovery has a chance. And even if deep recovery fails to return user
>>> data, what we need to see is the proper error message: read error UNC,
>>> rather than a link reset message which just obfuscates the problem.
>>
>>
>> This has been discussed at least once here before (probably more times, hard
>> to be sure since it usually comes up as a side discussion in an only
>> marginally related thread).  Last I knew, the consensus here was that it
>> needs to be changed upstream in the kernel, not by adding a udev rule
>> because while the value is technically system policy, the default policy is
>> brain-dead for anything but the original disks it was i9ntended for (30
>> seconds works perfectly fine for actual SCSI devices because they behave
>> sanely in the face of media errors, but it's horribly inadequate for ATA
>> devices).
>>
>> To re-iterate what I've said before on the subject:
>>
>> For ATA drives it should probably be 150 seconds.  That's 30 seconds beyond
>> the typical amount of time most consumer drives will keep retrying a sector,
>> so even if it goes the full time to try and recover a sector this shouldn't
>> trigger.  The only people this change should negatively impact are those who
>> have failing drives which support SCT ERC and have it enabled, but aren't
>> already adjusting this timeout.
>>
>> For physical SCSI devices, it should continue to be 30 seconds.  SCSI disks
>> are sensible here and don't waste your time trying to recover a sector.  For
>> PV-SCSI devices, it should probably be adjusted too, but I don't know what a
>> reasonable value is.
>>
>> For USB devices it should probably be higher than 30 seconds, but again I
>> have no idea what a reasonable value is.
> 
> I don't know how all of this is designed but it seems like there's
> only one location for the command timer, and the SCSI driver owns it,
> and then everyone else (ATA and USB and for all I know SAN) are on top
> of that and lack any ability to have separate timeouts.
On the note of SAN, iSCSI is part of the SCSI subsystem, so it gets 
applied directly there.  I'm pretty sure NBD has it's own thing, and I 
think the same is true of ATAoE.

As far as USB, UMS is essentially a stripped down version of SCSI with 
it's own limitations, and UAS _is_ SCSI, with both of those having 
pretty much always been routed through the SCSI subsystem.
> 
> The nice thing about the udev rule is that it tests for SCT ERC before
> making a change. There certainly are enterprise and almost enterprise
> "NAS" SATA drives that have short SCT ERC times enabled out of the box
> - and the udev method makes them immune to the change.
The kernel could just as easily look for that too though.  From what 
I've seen however, other failure sources that wouldn't trigger SCT ERC 
on SATA drives are really rare, usually it means a bad cable, bad drive 
electronics, or a bad storage controller, so i don't think having it set 
really high for SCT ERC enabled drives is likely to be much of an issue 
most of the time.

From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED
 OPERATION CODES
Date: Mon, 16 Dec 2013 09:42:28 -0500
Message-ID: <52AF1154.1020509@interlog.com>
References: <20121125184525.0b7967c4@stein>	<yq18v9nsz3q.fsf@sermon.lab.mkp.net>	<20121202191654.59117ac2@stein> <20131215155238.6016b038@stein>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50588 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab3LPOmv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 09:42:51 -0500
In-Reply-To: <20131215155238.6016b038@stein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux1394-devel@lists.sourceforge.net
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On 13-12-15 09:52 AM, Stefan Richter wrote:
> On Dec 02 2012 Stefan Richter wrote:
>> On Nov 26 Martin K. Petersen wrote:
>>>>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:
>>> Stefan> I did not try "sg_write_same" on any of the devices; but since
>>> Stefan> the two SPC-3 devices are correctly identified as "fully
>>> Stefan> provisioned", won't issue WRITE SAME to them either.
>>                         ^[the kernel]
>>>
>>> What if you have an SSD behind one of them?
>>
>> At the moment I only have a single old SSD available which does not
>> implement ATA TRIM as far as I recall.
>>
>> And the two mentioned OXUF936QSE based SPC-3 devices are four-bay SATA disk
>> enclosures whose firmwares only support various RAID modes and require at
>> least two bays to be populated.  I.e. I can't test them with the SSD for
>> now.  But I suspect that they don't implement thin provisioning anyway,
>> particularly translation of WRITE SAME with UNMAP to ATA TRIM.
>>
>> But now I found another SPC-3 compliant device in my stash; a dual SATA
>> bridge based on OXUF934DSB which supports JBOD with 1...2 disks
>> alternatively to striping/ spanning/ mirroring over 2 disks.  I attached
>> the old SSD to it, and its thin_provisioning sysfs attribute was shown as
>> 0 as well.  "sg_write_same -U ..." on this device in the 10 and 16 byte
>> variants ended with Illegal Request/ Invalid command operation code, but
>> otherwise without discernible malfunction.
>>
>>> Stefan> Hence let's remove the no_report_opcodes and no_write_same
>>> Stefan> blacklist flags so that these commands can be used on
>>> Stefan> respectively capable targets.
>>>
>>> I just erred on the side of caution. If you are happy without belt and
>>> suspenders that's perfectly ok with me :)
>>
>> Blacklisting at first was definitely the right approach.  But now that I
>> looked at a variety of older and newer devices, I am confident that the
>> general Inquiry_Data.Version >= SPC-3 test keeps the wackier among the
>> SBP-2 devices safe enough.
>
> (I followed up with https://git.kernel.org/linus/b0ea5f19d3d8.)
>
>> Of course it remains to be seen what happens with ATA TRIM enabled SSDs
>> behind the newer SPC-3 compliant bridges, but at this time the risk with
>> those seems low.
>
> I now tested
>    - ONNTO dataTale RSM4QO (OXUF936QSE) with two Samsung 840 Pro in RAID 0,
>    - ONNTO dataTale RSM4QO (OXUF936QSE) with two Samsung 840 Pro in RAID 1,
>    - IOI FWBU2-DSATA12 (OXUF934DSB) with one Samsung 840 Pro
> and kernel 3.9.
>
> $ grep . /sys/class/scsi_disk/42\:0\:0\:0/*prov*
> /sys/class/scsi_disk/42:0:0:0/provisioning_mode:full
> /sys/class/scsi_disk/42:0:0:0/thin_provisioning:0
> # sg_opcodes /dev/sdg
>    Ext Hard   Disk
>    Peripheral device type: disk
> Report supported operation codes: operation not supported
> # sg_write_same --10 --lba=1 /dev/sdg
> Write same(10) command not supported
> # sg_write_same --16 --lba=1 /dev/sdg
> Write same(16) command not supported
> # sg_write_same --32 --lba=1 /dev/sdg
> Write same: pass through os error: Invalid argument
> Write same(32) command failed

The sg driver does not support SCSI commands of greater
than 16 bytes. That is the reason for the "pass-through
os error" on your '--32' variant above. For now you need
to send the '--32' variant to the bsg driver instead.

I have presented a patch to relax the 16 byte cdb limit
on the sg driver:
   http://www.spinics.net/lists/linux-scsi/msg70283.html
Like most of my patches that one seems to be residing
in James' /dev/null file for later consideration.

Doug Gilbert

> I will send a patch which reverts the drivers/firewire/sbp2.c hunk of
> https://git.kernel.org/linus/54b2b50c20a6 "[SCSI] Disable WRITE SAME for
> RAID and virtual host adapter drivers".  (As an aside, sbp2.c implements a
> transport, not a virtual host adapter.)
>


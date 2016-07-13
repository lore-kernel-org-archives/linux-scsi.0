From: Gernot Hillier <gernot.hillier@siemens.com>
Subject: Re: unexpected sync delays in dpkg for small pre-allocated files on
 ext4
Date: Wed, 13 Jul 2016 15:57:18 +0200
Message-ID: <578648BE.8020708@siemens.com>
References: <57448A5D.4050805@siemens.com> <20160524231328.GB387@thunk.org>
 <574BF988.5050202@siemens.com> <20160531002152.GQ26977@dastard>
 <574EAE69.5040003@siemens.com> <574EE05A.9070302@siemens.com>
 <20160601141218.GE5357@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lizzard.sbs.de ([194.138.37.39]:53594 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbcGMOLG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2016 10:11:06 -0400
In-Reply-To: <20160601141218.GE5357@thunk.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-ext4@vger.kernel.org, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: SCHILD HENNING Z003BPMR <henning.schild@siemens.com>

Dear Ted,

On 01.06.2016 16:12, Theodore Ts'o wrote:
> On Wed, Jun 01, 2016 at 03:17:14PM +0200, Gernot Hillier wrote:
>> I repeated the discussed tests and found comparable results on this machine:
>>
>> - 3 seconds dpkg install time on ext3 vs. 80 seconds for ext4
>>   on same partition for same package
>> - 40 ms for fallocate+write+sync_file_range for writing a few bytes
>> - 15 ms for write+fdatasync vs. 45 ms for BLKZEROOUT on raw device
>>
>> So this seems to be not bound to one specific disk+controller setup, but
>> it still can't be a common problem affecting many people as then we
>> would see more reports about it...

Sorry for 2nd follow-up and the long delay (caused by vacation +
illness), but we went over the whole discussion again and can now likely
confirm your assumption of a bad SCSI WRITE SAME implementation on our
hardware.

We found that by issuing "echo 0 >
/sys/devices/.../scsi_disk/0:0:0:0/max_write_same_blocks" we can also
fix our issue, reducing dpkg installation time for e.g. linux-headers
from minutes to seconds.

Did you already have time to look into my old btrace from June, 2nd, did
it help somehow?

If not, please find updated btraces from two machines, for slow and fast
case, on each one below.

Does this provide enough details to blacklist our devices for SCSI WRITE
SAME?

> OK, so let's try to get common baseline, shall we?  I'm using as my
> test package:
> 
> http://debug.mirrors.debian.org/debian-debug/pool/main/e/e2fsprogs/e2fsprogs-dbgsym_1.43-2_amd64.deb

This time, I decided to use a test package with a bit more files to make
the issue more obvious:

http://snapshot.debian.org/archive/debian/20160712T042309Z/pool/main/m/manpages/manpages_4.06-1_all.deb

# md5sum manpages_4.06-1_all.deb
251aadf9a0117cac8248343a9f09d74b  manpages_4.06-1_all.deb

On machine 1, a Supermicro X8DTH board with Xeon E5520 CPU, equipped
with a SEAGATE ST973451SS disk connected to an LSI SAS2008 controller
(mpt3sas.ko):

(If you do this at home, please note that this will overwrite your local
manpages, so you need to go back to original package afterwards!)

# /usr/bin/time dpkg --no-triggers --force-depends --unpack
manpages_4.06-1_all.deb
[...]
0.13user 0.07system 0:03.38elapsed 6%CPU (0avgtext+0avgdata
15132maxresident)k
0inputs+4040outputs (0major+6066minor)pagefaults 0swaps

# echo 0 >
/sys/devices/pci0000:00/0000:00:09.0/0000:05:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/scsi_disk/0:0:0:0/max_write_same_blocks

# /usr/bin/time dpkg --no-triggers --force-depends --unpack
manpages_4.06-1_all.deb
[...]
0.11user 0.08system 0:00.55elapsed 35%CPU (0avgtext+0avgdata
15168maxresident)k
0inputs+4056outputs (0major+6219minor)pagefaults 0swaps

So disabling SCSI WRITE SAME reduced installation time for a package
with ~300 files from 3.5 s to 1 s.

On machine 2, a Supermicro X9DR3-F board with Xeon E5-2620, SEAGATE
ST300MM0006 disk connected to an Intel C606 SAS controller, default
installation time for manpages_4.06-1_all.deb was 9s, dropping to 1s
after "echo 0 > .../max_write_same_blocks".

For "real" packages like linux-headers, disabling SCSI WRITE SAME
reduced installation time from minutes to seconds.

(For sure, I repeated those measurements several times with switching
back and forth between both cases, rebooting etc.)

I followed your instructions, assured that btrace output ends up on
tmpfs and recorded four new btraces. As installation of manpages.deb
results in a 350k btrace (40k compressed), I decided to provide URLs
instead of attachments this time:

https://github.com/gernot-h/slow-dpkg/blob/master/btrace-machine1-write_same.out.bz2?raw=true
-> btrace for default (slow) case on machine1 (i.e. after reboot or
   "echo 65535 > .../max_write_same_blocks"

https://github.com/gernot-h/slow-dpkg/blob/master/btrace-machine1-no_write_same.out.bz2?raw=true
-> btrace for fast case on machine1 (i.e. after "echo 0 >
   .../max_write_same_blocks"

https://github.com/gernot-h/slow-dpkg/blob/master/btrace-machine2-write_same.out.bz2?raw=true
-> btrace for default (slow) case on machine2 (i.e. after reboot or
   "echo 65535 > .../max_write_same_blocks"

https://github.com/gernot-h/slow-dpkg/blob/master/btrace-machine2-no_write_same.out.bz2?raw=true
-> btrace for fast case on machine1 (i.e. after "echo 0 >
   .../max_write_same_blocks"

Thanks again and please let me know if you need any additional traces,
test results, measurements, bug report, etc.!

-- 
With kind regards,
Gernot Hillier

Siemens AG, Corporate Technology
Corporate Competence Center Embedded Linux


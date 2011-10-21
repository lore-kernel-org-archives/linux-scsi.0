From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 22:14:39 -0600
Message-ID: <4EA0F1AF.8090008@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com> <4EA04201.1050702@cs.utah.edu> <4EA044A9.6070406@redhat.com> <4EA05072.10107@cs.utah.edu> <4EA05D0A.7030909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rio.cs.utah.edu ([155.98.64.241]:52971 "EHLO
	mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1JUEOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2011 00:14:46 -0400
In-Reply-To: <4EA05D0A.7030909@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

Hi Bryn,

I compiled a fresh kernel and enabled flakey and delay modules. Now am 
able to create disks but
it fails to mount.

dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay 
/dev/sdb 0 500"
dmsetup create f0 --table="0 `blockdev --getsize /dev/mapper/d0` flakey 
/dev/mapper/d0 0 9 1"
mkfs -t ext3 /dev/mapper/f0
...
...
ext2fs_mkdir: Attempt to read block from filesystem resulted in short 
read while creating root dir

Can we even mount such a device ?

Thanks,
Yathi



On 10/20/2011 11:40 AM, Bryn M. Reeves wrote:
> On 10/20/2011 05:46 PM, Yathindra wrote:
>> >dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay
>> /dev/sdb 0 500"
>> device-mapper: reload ioctl failed: Invalid argument
>> Command failed
>>
>> In /var/log/messages I see this,
>> device-mapper: ioctl: error adding target to table
>
> I don't see this here:
>
> # dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay 
> /dev/sdb 0 500"
> # dmsetup info -c d0
> Name             Maj Min Stat Open Targ Event  UUID
> d0               253   3 L--w    1    1      0
> # dmsetup create f0 --table="0 `blockdev --getsize /dev/mapper/d0` 
> flakey /dev/mapper/d0 0 9 1"
> # dmsetup info -c f0
> Name             Maj Min Stat Open Targ Event  UUID
> f0               253   4 L--w    0    1      0
>
> This is using the f15 2.6.40.3 (aka kernel-3.0) with a locally 
> compiled dm-delay since it's not enabled in the Fedora kernels.
>
> Might want to move this thread over to dm-devel if you're having 
> trouble with it.
>
> Regards,
> Bryn.


From: Yathindra <ydev@cs.utah.edu>
Subject: Re: Simulating faulty disk
Date: Thu, 20 Oct 2011 10:46:42 -0600
Message-ID: <4EA05072.10107@cs.utah.edu>
References: <4E9F9321.8090704@cs.utah.edu> <4E9FE97E.4030209@redhat.com> <4EA04201.1050702@cs.utah.edu> <4EA044A9.6070406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:37006 "EHLO
	mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1JTQqt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2011 12:46:49 -0400
In-Reply-To: <4EA044A9.6070406@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org

Hi Bryn,

Sorry to disturb you again. I tried to create a delay device below but 
it failed.

 >dmsetup create d0 --table="0 `blockdev --getsize /dev/sdb` delay 
/dev/sdb 0 500"
device-mapper: reload ioctl failed: Invalid argument
Command failed

In /var/log/messages I see this,
  device-mapper: ioctl: error adding target to table

 >uname -r
2.6.32-24-generic-pae

 >dmsetup --version
Library version:   1.02.39 (2009-10-26)
Driver version:    4.15.0

Am I doing something wrong.

Thanks,
Yathi

On 10/20/2011 9:56 AM, Bryn M. Reeves wrote:
> On 10/20/2011 04:45 PM, Yathindra wrote:
>> Hi Bryn,
>>
>> Thanks for that info. Could you please tell me where I can find more
>> details about using it.
>>
>> Thanks again,
>> Yathi
>
> There's a couple of brief files describing the targets in the 
> Documentation/device-mapper directory:
>
> http://www.kernel.org/doc/Documentation/device-mapper/dm-flakey.txt
> http://www.kernel.org/doc/Documentation/device-mapper/delay.txt
>
> They both work like the linear target (except that they introduce the 
> specified faults according to their parameters).
>
> To set up a device with both you'd need to use a pair of stacked 
> devices so something like:
>
> dmsetup create d0 --table="0 $SECTORS delay $DEVICE 0 500"
> dmsetup create f0 --table="0 $SECTORS flakey /dev/mapper/d0 0 9 1"
>
> This will create a device /dev/mapper/f0 that is drops out for 1s in 
> every 10 and has a 500ms delay on reads and writes. SECTORS is the 
> size of the underlying device in sectors (use e.g. $(blockdev 
> --getsize)).
>
> You can optionally specify separate delays/device for writes to the 
> delay layer and write loss / write corruption for the flakey layer - 
> see the doc files and also the comments above flakey_ctr and delay_ctr 
> for more details.
>
> Regards,
> Bryn.


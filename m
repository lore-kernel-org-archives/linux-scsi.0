From: Douglas Gilbert <dougg@torque.net>
Subject: Re: no utility / method to show association between HBA &	non-sg
 BLOCK (scsi) devices - register_blkdev()
Date: Wed, 17 Jan 2007 16:04:36 -0500
Message-ID: <45AE8F64.9080504@torque.net>
References: <8260533.post@talk.nabble.com> <45A53290.1060400@torque.net> <45A62C32.8E7F.00B8.0@novell.com> <45A69AD6.60207@torque.net> <45AE22E0.DB3A.00B8.0@novell.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33968 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXAQVEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jan 2007 16:04:51 -0500
In-Reply-To: <45AE22E0.DB3A.00B8.0@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thayne Harmon <tharmon@novell.com>
Cc: linux-scsi@vger.kernel.org

Thayne Harmon wrote:
>>>> On Thu, Jan 11, 2007 at  1:15 PM, in message <45A69AD6.60207@torque.net>,
> Douglas Gilbert <dougg@torque.net> wrote: 
>> Thayne Harmon wrote:
>>> Gentlemen,
>>>
>>> hwinfo, lshal, sysfs do not show the relationship for non- sg BLOCK devices 
>> with there 
>>> associated Host Bus Adapter.
>> All devices (i.e. logical units) have a 4 element tuple
>> associated with them and the first element is the host
>> number. A HBA contains one or more hosts. Then you can
>> datamine in /sys/class/scsi_host/host<n> for whatever
>> information you want.
>>
>>> Do you know of a utility or method that can show this?
>> May I suggest lsscsi. That won't help you in the lk 2.4
>> series and earlier though There are other methods by
>> which the sg device corresponding to a "non- sg" block
>> device (e.g. /dev/sdc) can be found.
> 
> [context - Linux testserver 2.6.16.21-0.8-smp i586]
> 
> There is no corresponding sg device. The device file is
> /dev/cciss/c0d1.

Ok, I'm not familiar with the cciss driver. It looks like
it lives outside the linux scsi subsystem but according
to Documentation/cciss.txt it can subsequently "engage"
the scsi subsystem??

If it is outside the scsi subsystem then it doesn't
get corresponding sg devices. However as part of the
block subsystem it might accept the SG_IO ioctl (if
it accepts SCSI commands and it is implemented).

> I tried lsscsi, however it would not print out the non-sg block devices.
> 
> I have attached the output of tree /sys and the output of lsscsi and uname.
> One can search for cciss to find the devices and the driver.
> I still cannot see a relationship.

<snip sysfs dump>

> [0:0:0:0]    storage COMPAQ   MSA1000          4.32  -       
> [0:0:0:3]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sda
> [0:0:0:4]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdb
> [0:0:0:5]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdc
> [0:0:0:6]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdd
> [0:0:0:7]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sde
> [1:0:0:0]    storage COMPAQ   MSA1000          4.32  -       
> [1:0:0:3]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdf
> [1:0:0:4]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdg
> [1:0:0:5]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdh
> [1:0:0:6]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdi
> [1:0:0:7]    disk    COMPAQ   MSA1000 VOLUME   4.32  /dev/sdj

Well this looks like output from lsscsi. And those devices look
like they could be associated with cciss, especially the
compaq "storage" devices. These devices should have corresponding
sg device nodes. Try "lsscsi -g".

Still a bit unclear as hosts 0 and 1 are Fibre Channel
judging from the sysfs output for them.

Doug Gilbert



From: Douglas Gilbert <dougg@torque.net>
Subject: Re: With kernel 2.6.19 no sg devices for devices that return PQ=1,
 PDT=0x1f
Date: Wed, 06 Aug 2008 11:06:20 +0200
Message-ID: <4899698C.4050308@torque.net>
References: <48984A20.2050002@linux.vnet.ibm.com> <1217955090.9923.22.camel@localhost.localdomain> <200808061043.35229.swen@vnet.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:35647 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYHFJGe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 05:06:34 -0400
In-Reply-To: <200808061043.35229.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Martin Petermann <martin@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Swen Schillig wrote:
> On Tuesday 05 August 2008 18:51, James Bottomley wrote:
>> On Tue, 2008-08-05 at 14:40 +0200, Martin Petermann wrote:
>>> With kernel 2.6.19 a change was introduced that no sg device was 
>>> generated if PQ=1, PDT=0x1f was returned from the particular device:
>>>
>>> commit 84961f28e9d13a4b193d0c8545f3c060c1890ff3
>>> Author: dave wysochanski <davidw@netapp.com>
>>> Date:   Wed Aug 9 14:56:32 2006 -0400
>>>
>>>      [SCSI] Don't add scsi_device for devices that return PQ=1, PDT=0x1f
>>>
>>> Before it was possible on Linux 390 in user space to a e.g. LUN 0 to a 
>>> port and to receive a generic device:
>>>
>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
>>> total 0
>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
>>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
>>> --w------- 1 root root 4096 Aug  4 12:07 uevent
>>> --w------- 1 root root    0 Aug  4 13:46 unit_add
>>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # echo 0 > 
>>> unit_add
>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
>>> total 0
>>> drwxr-xr-x 2 root root    0 Aug  5 14:25 0x0000000000000000
>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
>>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
>>> --w------- 1 root root 4096 Aug  4 12:07 uevent
>>> --w------- 1 root root    0 Aug  5 14:25 unit_add
>>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # lsscsi -g
>>> [0:0:0:0]    no dev  IBM      2107900          2.27  -         /dev/sg0
>>>
>>> After this fix there is no /dev/sg0 device generated.
>>>
>>> We are utilizing the possibility to create such a device for the 
>>> sg_utils commands in the case no other LUN has been attached to a port.
>>>
>>> I do not want to put this fix into question. I would like to know if 
>>> someone has an idea how to workaround this problem and to generate a 
>>> generic device in user space using kernel 2.6.19 or a later version.
>> First of all, why is the device returning PQ=1 PTD=0x1f? this should
>> mean its not connected and probably doesn't exist... ie inaccessible
>> without some unspecified action being taken.  If you can use it, it's
>> clearly not behaving like a PQ=1 LUN.  Perhaps the simplest thing would
>> be for something in s390 to fix up the inquiry data ... or we could
>> allow you could have a script to force it to appear (as in if you send a
>> specific scan for this one LUN we could override the catch in the code
>> that throws it out again).
>>
>> James
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> James
> 
> I think Martin is saying that this LUN is a non existent one which is just used for scanning
> all available (existing) LUNs on the remote storage port.
> That's why PQ=1 PTD=0x1f are returned and correct !
> 
> So what's required here is the possibility to add a "dummy" LUN which can be used just for this purpose.
> Not sure whether this is covered by anything in the standard

That sounds like a job for the REPORT LUNS well known logical
unit (WLUN or W-LUN). I implemented one in the scsi_debug driver.
See the description of the "no_lun_0" parameter in
http://sg.torque.net/sg/sdebug26.html

You might try:
   echo "- - 49409" > /sys/class/scsi_host/host<n>/scan
where "host<n>" is the controller in question. Then
see if a WLUN has appeared as a sg device node.

Doug Gilbert



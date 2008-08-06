From: Martin Petermann <martin@linux.vnet.ibm.com>
Subject: Re: With kernel 2.6.19 no sg devices for devices that return PQ=1,
 PDT=0x1f
Date: Wed, 06 Aug 2008 19:47:04 +0200
Message-ID: <4899E398.10802@linux.vnet.ibm.com>
References: <48984A20.2050002@linux.vnet.ibm.com> <1217955090.9923.22.camel@localhost.localdomain> <200808061043.35229.swen@vnet.ibm.com> <4899698C.4050308@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30945 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYHFRqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 13:46:40 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id m76HkLQG086698
	for <linux-scsi@vger.kernel.org>; Wed, 6 Aug 2008 17:46:21 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m76HkLKj3727390
	for <linux-scsi@vger.kernel.org>; Wed, 6 Aug 2008 19:46:21 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m76HkKIP031442
	for <linux-scsi@vger.kernel.org>; Wed, 6 Aug 2008 19:46:21 +0200
In-Reply-To: <4899698C.4050308@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Swen Schillig <swen@vnet.ibm.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Swen Schillig wrote:
>> On Tuesday 05 August 2008 18:51, James Bottomley wrote:
>>> On Tue, 2008-08-05 at 14:40 +0200, Martin Petermann wrote:
>>>> With kernel 2.6.19 a change was introduced that no sg device was 
>>>> generated if PQ=1, PDT=0x1f was returned from the particular device:
>>>>
>>>> commit 84961f28e9d13a4b193d0c8545f3c060c1890ff3
>>>> Author: dave wysochanski <davidw@netapp.com>
>>>> Date:   Wed Aug 9 14:56:32 2006 -0400
>>>>
>>>>      [SCSI] Don't add scsi_device for devices that return PQ=1, 
>>>> PDT=0x1f
>>>>
>>>> Before it was possible on Linux 390 in user space to a e.g. LUN 0 to 
>>>> a port and to receive a generic device:
>>>>
>>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
>>>> total 0
>>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
>>>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
>>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
>>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
>>>> --w------- 1 root root 4096 Aug  4 12:07 uevent
>>>> --w------- 1 root root    0 Aug  4 13:46 unit_add
>>>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
>>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # echo 0 > 
>>>> unit_add
>>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # ll
>>>> total 0
>>>> drwxr-xr-x 2 root root    0 Aug  5 14:25 0x0000000000000000
>>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 access_denied
>>>> -rw-r--r-- 1 root root 4096 Aug  4 12:07 failed
>>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 in_recovery
>>>> -r--r--r-- 1 root root 4096 Aug  4 12:07 status
>>>> --w------- 1 root root 4096 Aug  4 12:07 uevent
>>>> --w------- 1 root root    0 Aug  5 14:25 unit_add
>>>> --w------- 1 root root    0 Aug  5 14:24 unit_remove
>>>> t6345056:/sys/bus/ccw/devices/0.0.5922/0x500507630313c562 # lsscsi -g
>>>> [0:0:0:0]    no dev  IBM      2107900          2.27  -         /dev/sg0
>>>>
>>>> After this fix there is no /dev/sg0 device generated.
>>>>
>>>> We are utilizing the possibility to create such a device for the 
>>>> sg_utils commands in the case no other LUN has been attached to a port.
>>>>
>>>> I do not want to put this fix into question. I would like to know if 
>>>> someone has an idea how to workaround this problem and to generate a 
>>>> generic device in user space using kernel 2.6.19 or a later version.
>>> First of all, why is the device returning PQ=1 PTD=0x1f? this should
>>> mean its not connected and probably doesn't exist... ie inaccessible
>>> without some unspecified action being taken.  If you can use it, it's
>>> clearly not behaving like a PQ=1 LUN.  Perhaps the simplest thing would
>>> be for something in s390 to fix up the inquiry data ... or we could
>>> allow you could have a script to force it to appear (as in if you send a
>>> specific scan for this one LUN we could override the catch in the code
>>> that throws it out again).
>>>
>>> James
>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> James
>>
>> I think Martin is saying that this LUN is a non existent one which is 
>> just used for scanning
>> all available (existing) LUNs on the remote storage port.
>> That's why PQ=1 PTD=0x1f are returned and correct !
>>
>> So what's required here is the possibility to add a "dummy" LUN which 
>> can be used just for this purpose.
>> Not sure whether this is covered by anything in the standard
> 
> That sounds like a job for the REPORT LUNS well known logical
> unit (WLUN or W-LUN). I implemented one in the scsi_debug driver.
> See the description of the "no_lun_0" parameter in
> http://sg.torque.net/sg/sdebug26.html
> 
> You might 
>   echo "- - 49409" > /sys/class/scsi_host/host<n>/scan
> where "host<n>" is the controller in question. Then
> see if a WLUN has appeared as a sg device node.
> 
> Doug Gilbert
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm not so familiar with SCSI on x86 Linux: the command you propose 
seems to initiate a scan on the specific host/port or the LUN. This is 
not implemented on s390 Linux. The reason for this difference probably 
(I need to speculate here since I'm quite new here) are related that on 
s390 different virtual machines share the same FC adapter and and a 
automatically detection and attachment of LUNs is not desired: different 
VMs can see the same LUNs if they share the same adapter. If I run the 
'echo "- - 49409" > /sys/class/scsi_host/host<n>/scan' command on x86 
Linux LUNs are automatically attached. On s390 Linux a manually 
attachment has been implemented by writing the LUN number to

/sys/bus/ccw/devices/<adapter ID>/<port ID>/unit_add

To find out the LUNs available to a specific port it should be 
sufficient to run the REPORT_LUNS SCSI command to any of the available 
generic devices of the port of interest. If there is no LUN added so far 
  the idea was to add a LUN 0 and run this command to it's generic 
device.    Because of the fix in the Linux kernel this is not possible 
anymore.


Regards
    Martin


From: Brian King <brking@us.ibm.com>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Fri, 10 Feb 2006 17:21:04 -0600
Message-ID: <43ED1FE0.1000805@us.ibm.com>
References: <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57044 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750791AbWBJXV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 18:21:27 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1ANLQQ0026400
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 18:21:26 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1ANLQkP226786
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 18:21:26 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1ANLQxS012411
	for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2006 18:21:26 -0500
In-Reply-To: <20060210230140.GA26423@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Olaf Hering wrote:
>  On Fri, Feb 10, Olaf Hering wrote:
> 
>> On Fri, Feb 10, James Bottomley wrote:
>>
>>>On Fri, 2006-02-10 at 11:11 +0100, Olaf Hering wrote:
>>>>550 reboots without crash, with this patch reverted.
>>>>Will try the execute_in_process_context thing now.
>>>I wouldn't bother ... because of the structure, the
>>>execute_in_process_context() patch must have the same bug, but the
>>>context check will make it much more difficult to hit.
>>Ok, will revert to the -git7 status and poke around once it crashes.
> 
> this is struct scsi_target in scsi_target_reap_work()
> 

>     release = 0xd0000000002190c0}, reap_ref = 0, channel = 255, id = 100, create = 0, scsi_level = 0 '\0', hostdata = 0x0, starget_data = 0x1ffffffec60}
                                                    ^^^^^^^^^^^^^

This is interesting.. This means that it is on ipr's logical scsi bus (255). Assuming this is
happening at boot time and not due to a user initiated scan through sysfs, this
means we are going through the scsi_add_device path, rather than the scsi_scan_host
path...

Brian


> (gdb) p/x st

>     dma_mem = 0x0, release = 0xd0000000002190c0}, reap_ref = 0x0, channel = 0xff, id = 0x64, create = 0x0, scsi_level = 0x0, hostdata = 0x0, 
>   starget_data = 0x1ffffffec60}
> 
> 1:mon> d c0000000024caca0 666
> c0000000024caca0 0000000000000000 c0000000024caca8  |.............L..|
> c0000000024cacb0 c0000000024caca8 c0000000024cacb8  |.....L.......L..|
> c0000000024cacc0 c0000000024cacb8 00000000dead4ead  |.....L........N.|
> c0000000024cacd0 ffffffff00000000 ffffffffffffffff  |................|
> c0000000024cace0 c0000000024cace0 c0000000024cace0  |.....L.......L..|
> c0000000024cacf0 c000000000614f68 c000000000614f38  |.....aOh.....aO8|
> c0000000024cad00 0000000000000000 0000000000000000  |................|
> c0000000024cad10 0000000000000000 0000000000000000  |................|
> c0000000024cad20 0000000000000000 0000000000000000  |................|
> c0000000024cad30 0000000000000000 0000000000000000  |................|
> c0000000024cad40 0000000000000000 0000000000000000  |................|
> c0000000024cad50 0000000000000000 0000000000000000  |................|
> c0000000024cad60 0000000000000000 0000000000000000  |................|
> c0000000024cad70 0000000000000000 0000000000000000  |................|
> c0000000024cad80 0000000000000000 0000000000000000  |................|
> c0000000024cad90 0000000000000000 0000000000000000  |................|
> c0000000024cada0 0000000000000000 0000000000000000  |................|
> c0000000024cadb0 0000000000000000 0000000000000000  |................|
> c0000000024cadc0 0000000000000000 0000000000000000  |................|
> c0000000024cadd0 0000000000000000 0000000000000000  |................|
> c0000000024cade0 0000000000000000 0000000000000000  |................|
> c0000000024cadf0 c00000000303a1a8 c0000000024cae00  |.............L..|
> c0000000024cae00 746172676574303a 3235353a31303000  |target0:255:100.|
> c0000000024cae10 0000000000000006 c0000000024cae18  |.............L..|
> c0000000024cae20 c0000000024cae18 c00000000303a2d8  |.....L..........|
> c0000000024cae30 c000000000500c88 0000000000000000  |.....P..........|
> c0000000024cae40 0000000000000000 746172676574303a  |........target0:|
> c0000000024cae50 3235353a31303000 0000000000000000  |255:100.........|
> c0000000024cae60 0000000000000000 0000000000000000  |................|
> c0000000024cae70 0000000000000000 0000000000000000  |................|
> c0000000024cae80 0000000000000000 0000000100000000  |................|
> c0000000024cae90 00000000dead4ead ffffffff00000000  |......N.........|
> c0000000024caea0 ffffffffffffffff c0000000024caea8  |.............L..|
> c0000000024caeb0 c0000000024caea8 0000000000000000  |.....L..........|
> c0000000024caec0 0000000000000000 0000000000000000  |................|
> c0000000024caed0 0000000000000000 0000000000000000  |................|
> c0000000024caee0 0000000000000000 0000000000000000  |................|
> c0000000024caef0 0000000000000000 c0000000024caef8  |.............L..|
> c0000000024caf00 c0000000024caef8 0000000000000000  |.....L..........|
> c0000000024caf10 d0000000002190c0 00000000000000ff  |.....!..........|
> c0000000024caf20 0000006400000000 0000000000000000  |...d............|
> c0000000024caf30 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024caf40 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024caf50 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024caf60 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024caf70 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024caf80 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024caf90 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024cafa0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024cafb0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024cafc0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024cafd0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> c0000000024cafe0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
> ....
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

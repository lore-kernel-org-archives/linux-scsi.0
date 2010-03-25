From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15623] doesn't allow SMART-passthrough on Adaptec Series 5
 controller
Date: Thu, 25 Mar 2010 21:42:20 GMT
Message-ID: <201003252142.o2PLgKrq000607@demeter.kernel.org>
References: <bug-15623-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:51834 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0CYVmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2010 17:42:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2PLgKDZ000608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2010 21:42:20 GMT
In-Reply-To: <bug-15623-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15623





--- Comment #3 from Anonymous Emailer <anonymous@kernel-bugs.osdl.org>  2010-03-25 21:42:14 ---
Reply-To: dgilbert@interlog.com

bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=15623
> 
> 
> 
> 
> 
> --- Comment #2 from lkolbe@techfak.uni-bielefeld.de  2010-03-24 18:45:10 ---
>> So in lk 2.6.32 aacraid driver version 24900 was used
>> successfully but with lk 2.6.33 the aacraid driver
>> version reverted to 24702 and didn't work. It might be
>> interesting to find the aacraid changelog between those
>> two versions.
> 
> I wonder as well. Vanilla 2.6.32 has aacraid version 2461 (IIRC), vanilla
> 2.6.33 has 24702, and Adaptec upstream has 24900, which is what they recommend
> for using for the 'enterprise'. I have no idea about the politics side of this,
> if there is any. There must be some reason why vanilla doesn't include 24900 by
> default, though - it was released in 9/2009 IIRC.
> 
>> Anyway the kernel messages shown by dmesg are just
>> noise and should disappear in lk 2.6.34 .
>> IOW "ATA pass through information available" indicates
>> normal operation of SAT.
> 
> Great, less noise ;)
> 
>> smartctl will provide more debug information if a
>> '-r ioctl,3' option is added.
> 
> good to know, output follows:
> 
> smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 Bruce
> Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> 
> REPORT-IOCTL: DeviceFD=3 Command=IDENTIFY DEVICE
>  [ata pass-through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00 ]
>   scsi_status=0x0, host_status=0x0, driver_status=0x0
>   info=0x0  duration=12 milliseconds  resid=0
>   Incoming data, len=512 [only first 256 bytes shown]:

<snip>

> REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS
>  [ata pass-through(16): 85 06 2c 00 da 00 00 00 00 00 4f 00 c2 00 b0 00 ]
>   scsi_status=0x2, host_status=0x7, driver_status=0x8

The aacraid driver could not handle this command.
host_status=0x7 is DID_ERROR which is an internal
driver (aacraid) error.

What is being done by smartmontools is defined in
the SAT standard.

>   info=0x1  duration=104 milliseconds  resid=0
> sat_command_interface: do_scsi_cmnd_io() failed, status=-5
> REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned -1
> SMART Disabled. Use option -s with argument 'on' to enable it.

Doug Gilbert

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

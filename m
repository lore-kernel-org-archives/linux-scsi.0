From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Bug 15623] doesn't allow SMART-passthrough on Adaptec Series
 5 controller
Date: Thu, 25 Mar 2010 17:41:33 -0400
Message-ID: <4BABD88D.8030002@interlog.com>
References: <bug-15623-11613@https.bugzilla.kernel.org/> <201003241845.o2OIjmNv014049@demeter.kernel.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44620 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab0CYVlg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2010 17:41:36 -0400
In-Reply-To: <201003241845.o2OIjmNv014049@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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




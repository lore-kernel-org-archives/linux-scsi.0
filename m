From: Steven Dake <sdake@mvista.com>
Subject: Re: SCSI Hang 2.4.22 kernel, Help
Date: Thu, 02 Oct 2003 11:20:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065118800.4779.162.camel@persist.az.mvista.com>
References: <20030930214412.4775.qmail@web14502.mail.yahoo.com>
Reply-To: sdake@mvista.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rav-az.mvista.com ([65.200.49.157]:55049 "EHLO
	zipcode.az.mvista.com") by vger.kernel.org with ESMTP
	id S263438AbTJBSUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 14:20:04 -0400
In-Reply-To: <20030930214412.4775.qmail@web14502.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: donj@asaca.com
Cc: linux-scsi@vger.kernel.org

Don,

scsi add and remove are not safe in SMP systems because the locking in
the kernel is broken (or rather, non-existent) in the 2.4 kernel (and I
believe also in 2.6).

I think it is unlikely to be fixed in 2.4.X but someone may provide a
patch.  I posted a patch some time ago that fixes the problem, but
during SCSI error handling and add/removes, the system would not respond
properly so that patch was abondoned.  You could try it though..

Thanks
--steve

On Tue, 2003-09-30 at 14:44, Don Jessup wrote:
> 
>   
>   As stated in the header I'm using the 2.4.22 SMP kernel and I have 3 SATA
> Disk attached
>  to a 3ware card.  I have set up a script that just does 
>   echo "scsi remove-single-device 3 0 1 0" 
>   echo "scsi remove-single-device 3 0 5 0"
>   echo "scsi remove-single-device 3 0 7 0"
>   echo "scsi add-single-device 3 0 1 0"
>   echo "scsi add-single-device 3 0 5 0"
>   echo "scsi add-single-device 3 0 7 0"
> 
>   It sleeps for one second then repeats the above steps.  
> 
>     
> 
>    After about two hours of running this script the system just hangs.   This
>  is not a problem in UP only in SMP.   I have turned on SCSI Debug information
>   for this test and have included it below.  Does anyone have any idea why this
>   would be happening and if there are currently any fixes for this hang.  By
>   the way the system is Dual Xeon System with a  1G of ram and hyperthreading
>    turned ON.    
> 
>   I'm doing this because I'm working on the system that is always 
>   adding and removing scsi devices although not nearly as fast as this script
>   is doing.  After several days it seems to hang and always hangs on adding or
>    removing a device.  As I stated above with the script I can make it happen
>   in a few hours.
> 
>   There is a lot of debugging information.  Here it is.  I hope someone has
>   some idea of what the problem might be and how to fix it.   
> 
> 
>   Thank You  ahead time.
> 
> 
> Sep 30 12:06:47 beowulf kernel: scsi singledevice 3 0 1 0
> Sep 30 12:06:47 beowulf kernel: blk: queue f5b71218, I/O limit 4095Mb (mask
> 0xffffffff)
> Sep 30 12:06:47 beowulf kernel: scsi: performing INQUIRY
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 1,
> buffer =efa63dd0, bufflen = 256, done = f880d090, timeout = 600, retries = 3)
> Sep 30 12:06:47 beowulf kernel: command : 12  00  00  00  ff  00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 1 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd8ee00 at 600
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 1, command = efd8ee58, buffer = efa63dd0, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 256, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd8ee00 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 1 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 1 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: scsi: INQUIRY successful with code 0x0
> Sep 30 12:06:47 beowulf kernel:   Vendor: 3ware     Model: Logical Disk 1   
> Rev: 1.0 
> Sep 30 12:06:47 beowulf kernel:   Type:   Direct-Access                     
> ANSI SCSI revision: 00
> Sep 30 12:06:47 beowulf kernel: blk: queue efd8ee18, I/O limit 4095Mb (mask
> 0xffffffff)
> Sep 30 12:06:47 beowulf kernel: Attached scsi disk sda at scsi3, channel 0, id
> 1, lun 0
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 1,
> buffer =c0388000, bufflen = 0, done = f880d090, timeout = 3000, retries = 5)
> Sep 30 12:06:47 beowulf kernel: command : 00  00  00  00  00  00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 1 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c400 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 1, command = efd7c458, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 0, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c400 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 1 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 1 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 1,
> buffer =c0388000, bufflen = 8, done = f880d090, timeout = 3000, retries = 5)
> Sep 30 12:06:47 beowulf kernel: command : 25  00  00  00  00  00  00  00  00 
> 00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 1 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c400 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 1, command = efd7c458, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 8, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c400 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 1 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 1 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: SCSI device sda: 488397168 512-byte hdwr
> sectors (250059 MB)
> Sep 30 12:06:47 beowulf kernel:  sda:Activating command for device 1 (1)
> Sep 30 12:06:47 beowulf kernel: Doing sd request, dev = 0x800, block = 0
> Sep 30 12:06:47 beowulf kernel: sda : real dev = /dev/0, block = 0
> Sep 30 12:06:47 beowulf kernel: sda : reading 8/8 512 byte blocks.
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c400 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 1, command = efd7c458, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 4096, done = f8829c30)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c400 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 1 0
> Sep 30 12:06:47 beowulf kernel: sda : rw_intr(3, 0 [0 0])
> Sep 30 12:06:47 beowulf kernel: 8 sectors total, 8 sectors done.
> Sep 30 12:06:47 beowulf kernel: use_sg is 1
> Sep 30 12:06:47 beowulf kernel:  Deactivating command for device 1 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel:  sda1
> Sep 30 12:06:47 beowulf kernel: Host status for host f3d4c000:
> Sep 30 12:06:47 beowulf kernel: Device 1 f5b71200: efd7c400 efd4ce00 efd4c000
> f7807600 f7807200 f7807c00 f7807e00 f7807800 f7807400 f7807a00 f7807000
> efd7f600 efd7f200 efd7f000 efd7fe00 efd7fc00 efd7f400 efd7f800 efd7fa00
> efd81600 efd81200 efd81c00 efd81400 efd81800 efd81000 efd81e00 efd81a00
> efd59c00 efd59e00 efd59a00 efd59200 efd59400 efd59800 efd59600 efd59000
> efd5e400 efd5e200 efd5ea00 efd5e800 efd5ee00 efd5e000 efd5ec00 efd5e600
> efd3d200 efd3d400 efd3dc00 efd3da00 efd3d000 efd3de00 efd3d600 efd3d800
> efd8f200 efd8f600 efd8f400 efd8f000 efd8fa00 efd8fc00 efd8f800 efd8fe00
> f7132000 f7132e00 f7132c00 f7132a00 f1ce2400 f1ce2a00 f1c24600 f1c24000
> f1c24c00 f1c24800 f1c24200 f1c24400 efd62c00 efd62e00 efd62400 efd62000
> efd62800 efd62600 efd62200 efd62a00 efd34a00 efd34400 efd34c00 efd34800
> efd34e00 efd34200 efd34000 efd34600 efd66a00 efd66c00 efd66600 efd66200
> efd66800 efd66000 efd66400 efd66e00 efd63e00 efd63200 efd63600 efd63c00
> efd63000 efd63800 efd63400 efd63a00 efd60a00 efd60e00 efd60000 efd60600
> efd60200 efd6
> Sep 30 12:06:47 beowulf kernel: c00 efd60400 efd60800 efd37400 efd37c00
> efd37000 efd37600 efd37200 efd37a00 efd37e00 efd37800 efd4c800 efd4c200
> efd4c400 efd4cc00 efd4c600 efd4ca00 efd4d600 efd4d000 efd4d200 efd4da00
> efd4dc00 efd4de00 efd56a00 efd56200 efd56600 efd56400 efd74c00 efd74600
> efd8e000 efd8ea00 efd8ec00 f505fc00 efd77800 efd77c00 efd77600 efd77200
> efd77000 efd77e00 efd77a00 f79d8200 f79d8a00 f79d8800 f79d8400 f79d8600
> f79d8000 f2580e00 f2580c00 f6588e00 f6588800 f6588c00 f1e4f800 f1e4f000
> f26e5000 f26e5600 f26e5200 f26e5a00 f26e5400 f26e5800 f79c8a00 f79c8200
> f79c8400 f79c8c00 f79c8000 f2901800 f2901000 f5b71a00 f5b71000 f5b71e00
> f5b71800 f5b71c00 f5b71600 f5b71400 efd89a00 efd89400 efd89800 efd89000
> f1ce2000 f1ce2200 efd56800 efd56e00 efd56000 efd56c00 f1c1c800 f1c1c600
> f1c1cc00 f1c1c200 f1c1c400 f1c1ca00 f1c1c000 f1c1ce00 efd5a400 efd5a200
> efd5a000 efd5ae00 efd5ac00 efd5a800 efd5a600 efd5aa00 efd5f400 efd5fc00
> efd5f200 efd5fe00 efd5f800 efd5f000 efd5f600 efd5fa00 efd6bc00 efd6be00
> efd6b000 efd6ba00 e
> Sep 30 12:06:47 beowulf kernel: 800 efd6b400 efd6b600 efd6b200 efd55600
> efd55a00 efd55c00 efd55400 efd55200 efd55e00 efd55000 efd55800 efd74200
> efd74400 efd74800 efd74a00 efd6fa00 efd6f400 efd6fe00 efd6f000 efd47000
> efd47600 efd47e00 efd47c00 efd47800 efd47a00 efd47200 efd47400 f1c24a00
> f1c24e00 efd4d800 efd4d400 efd8e800 efd8e200 efd8e600 
> ######### Adding /dev/sdb
> Sep 30 12:06:47 beowulf kernel: scsi singledevice 3 0 5 0
> Sep 30 12:06:47 beowulf kernel: scsi: performing INQUIRY
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 5,
> buffer =efa63dd0, bufflen = 256, done = f880d090, timeout = 600, retries = 3)
> Sep 30 12:06:47 beowulf kernel: command : 12  00  00  00  ff  00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 5 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd74e00 at 600
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 5, command = efd74e58, buffer = efa63dd0, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 256, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd74e00 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 5 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 5 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: scsi: INQUIRY successful with code 0x0
> Sep 30 12:06:47 beowulf kernel:   Vendor: 3ware     Model: Logical Disk 5   
> Rev: 1.0 
> Sep 30 12:06:47 beowulf kernel:   Type:   Direct-Access                     
> ANSI SCSI revision: 00
> Sep 30 12:06:47 beowulf kernel: blk: queue efd74e18, I/O limit 4095Mb (mask
> 0xffffffff)
> Sep 30 12:06:47 beowulf kernel: Attached scsi disk sdb at scsi3, channel 0, id
> 5, lun 0
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 5,
> buffer =c0388000, bufflen = 0, done = f880d090, timeout = 3000, retries = 5)
> Sep 30 12:06:47 beowulf kernel: command : 00  00  00  00  00  00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 5 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd8a800 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 5, command = efd8a858, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 0, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd8a800 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 5 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 5 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 5,
> buffer =c0388000, bufflen = 8, done = f880d090, timeout = 3000, retries = 5)
> Sep 30 12:06:47 beowulf kernel: command : 25  00  00  00  00  00  00  00  00 
> 00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 5 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd8a800 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 5, command = efd8a858, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 8, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd8a800 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 5 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 5 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: SCSI device sdb: 488397168 512-byte hdwr
> sectors (250059 MB)
> Sep 30 12:06:47 beowulf kernel:  sdb:Activating command for device 5 (1)
> Sep 30 12:06:47 beowulf kernel: Doing sd request, dev = 0x810, block = 0
> Sep 30 12:06:47 beowulf kernel: sdb : real dev = /dev/1, block = 0
> Sep 30 12:06:47 beowulf kernel: sdb : reading 8/8 512 byte blocks.
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd8a800 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 5, command = efd8a858, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 4096, done = f8829c30)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd8a800 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 5 0
> Sep 30 12:06:47 beowulf kernel: sdb : rw_intr(3, 0 [0 0])
> Sep 30 12:06:47 beowulf kernel: 8 sectors total, 8 sectors done.
> Sep 30 12:06:47 beowulf kernel: use_sg is 1
> Sep 30 12:06:47 beowulf kernel:  Deactivating command for device 5 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel:  sdb1
> Sep 30 12:06:47 beowulf kernel: Host status for host f3d4c000:
> Sep 30 12:06:47 beowulf kernel: Device 1 f5b71200: efd7c400 efd4ce00 efd4c000
> f7807600 f7807200 f7807c00 f7807e00 f7807800 f7807400 f7807a00 f7807000
> efd7f600 efd7f200 efd7f000 efd7fe00 efd7fc00 efd7f400 efd7f800 efd7fa00
> efd81600 efd81200 efd81c00 efd81400 efd81800 efd81000 efd81e00 efd81a00
> efd59c00 efd59e00 efd59a00 efd59200 efd59400 efd59800 efd59600 efd59000
> efd5e400 efd5e200 efd5ea00 efd5e800 efd5ee00 efd5e000 efd5ec00 efd5e600
> efd3d200 efd3d400 efd3dc00 efd3da00 efd3d000 efd3de00 efd3d600 efd3d800
> efd8f200 efd8f600 efd8f400 efd8f000 efd8fa00 efd8fc00 efd8f800 efd8fe00
> f7132000 f7132e00 f7132c00 f7132a00 f1ce2400 f1ce2a00 f1c24600 f1c24000
> f1c24c00 f1c24800 f1c24200 f1c24400 efd62c00 efd62e00 efd62400 efd62000
> efd62800 efd62600 efd62200 efd62a00 efd34a00 efd34400 efd34c00 efd34800
> efd34e00 efd34200 efd34000 efd34600 efd66a00 efd66c00 efd66600 efd66200
> efd66800 efd66000 efd66400 efd66e00 efd63e00 efd63200 efd63600 efd63c00
> efd63000 efd63800 efd63400 efd63a00 efd60a00 efd60e00 efd60000 efd60600
> efd60200 efd6
> Sep 30 12:06:47 beowulf kernel: c00 efd60400 efd60800 efd37400 efd37c00
> efd37000 efd37600 efd37200 efd37a00 efd37e00 efd37800 efd4c800 efd4c200
> efd4c400 efd4cc00 efd4c600 efd4ca00 efd4d600 efd4d000 efd4d200 efd4da00
> efd4dc00 efd4de00 efd56a00 efd56200 efd56600 efd56400 efd74c00 efd74600
> efd8e000 efd8ea00 efd8ec00 f505fc00 efd77800 efd77c00 efd77600 efd77200
> efd77000 efd77e00 efd77a00 f79d8200 f79d8a00 f79d8800 f79d8400 f79d8600
> f79d8000 f2580e00 f2580c00 f6588e00 f6588800 f6588c00 f1e4f800 f1e4f000
> f26e5000 f26e5600 f26e5200 f26e5a00 f26e5400 f26e5800 f79c8a00 f79c8200
> f79c8400 f79c8c00 f79c8000 f2901800 f2901000 f5b71a00 f5b71000 f5b71e00
> f5b71800 f5b71c00 f5b71600 f5b71400 efd89a00 efd89400 efd89800 efd89000
> f1ce2000 f1ce2200 efd56800 efd56e00 efd56000 efd56c00 f1c1c800 f1c1c600
> f1c1cc00 f1c1c200 f1c1c400 f1c1ca00 f1c1c000 f1c1ce00 efd5a400 efd5a200
> efd5a000 efd5ae00 efd5ac00 efd5a800 efd5a600 efd5aa00 efd5f400 efd5fc00
> efd5f200 efd5fe00 efd5f800 efd5f000 efd5f600 efd5fa00 efd6bc00 efd6be00
> efd6b000 efd6ba00 e
> Sep 30 12:06:47 beowulf kernel: 800 efd6b400 efd6b600 efd6b200 efd55600
> efd55a00 efd55c00 efd55400 efd55200 efd55e00 efd55000 efd55800 efd74200
> efd74400 efd74800 efd74a00 efd6fa00 efd6f400 efd6fe00 efd6f000 efd47000
> efd47600 efd47e00 efd47c00 efd47800 efd47a00 efd47200 efd47400 f1c24a00
> f1c24e00 efd4d800 efd4d400 efd8e800 efd8e200 efd8e600 
> Sep 30 12:06:47 beowulf kernel: Device 5 efd8ee00: efd8a800 efd8ac00 efd8ae00
> efd8a600 efd8a400 efd8a200 efd8aa00 efd8a000 efd83200 efd83a00 efd83400
> efd83800 efd83e00 efd83000 efd83c00 efd83600 efd7d400 efd7de00 efd7d800
> efd7da00 efd7d200 efd7dc00 efd7d000 efd7d600 efd5ba00 efd5b600 efd5bc00
> efd5b400 efd5b200 efd5b800 efd5be00 efd5b000 efd65a00 efd65e00 efd65600
> efd65400 efd65000 efd65800 efd65c00 efd65200 efd6d200 efd6de00 efd6d400
> efd6d000 efd6da00 efd6d800 efd6dc00 efd6d600 efd71200 efd71000 efd5ca00
> efd5c400 efd46000 efd46400 efd46800 efd46e00 efd46600 efd46a00 efd46200
> efd46c00 efd53600 efd53800 efd53c00 efd53e00 efd53000 efd53400 efd53a00
> efd53200 efd6c400 efd6ca00 efd6c800 efd6c600 efd6cc00 efd6c200 efd6c000
> efd6ce00 efd80600 efd80a00 efd80200 efd80e00 efd80c00 efd80800 efd80000
> efd80400 efd69a00 efd69400 efd69e00 efd69c00 efd69000 efd69200 efd69800
> efd69600 efd32c00 efd32600 efd32e00 efd32800 efd32200 efd32a00 efd32400
> efd32000 efd40200 efd40c00 efd40800 efd40e00 efd40400 efd40600 efd40a00
> efd40000 efd4
> Sep 30 12:06:47 beowulf kernel: e00 efd4ba00 efd4b400 efd4b600 efd41600
> efd41000 efd41400 efd41a00 efd41c00 efd41e00 efd41200 efd41800 efe23800
> efe23000 efe23e00 efe23200 efe23a00 efe23600 efe23400 efe23c00 efd3c200
> efd3c000 efd3cc00 efd3ce00 efd3c400 efd3ca00 efd3c600 efd3c800 efd91c00
> efd91a00 efd91200 efd91000 efd91600 efd91400 efd91e00 efd91800 efd64c00
> efd64e00 efd64600 efd64200 efd64400 efd64800 efd64a00 efd64000 efd31c00
> efd31a00 efd31600 efd31800 efd31200 efd31000 efd31e00 efd31400 efd88e00
> efd88000 efd88200 efd88800 efd88a00 efd88c00 efd88400 efd88600 efd5ce00
> efd5c000 efd5c200 efd5cc00 efd5c800 efd5c600 efd7ca00 efd7c200 efd7cc00
> efd7c000 efd7ce00 efd7c600 efd54000 efd54e00 efd54800 efd54200 efd54a00
> efd54c00 efd54600 efd54400 efd82600 efd82e00 efd82200 efd82800 efd82c00
> efd82000 efd82400 efd82a00 efd58600 efd58200 efd58a00 efd58400 efd58000
> efd58800 efd58c00 efd58e00 efd3e600 efd3e200 efd3ee00 efd3ea00 efd3ec00
> efd3e000 efd3e400 efd3e800 efd3ae00 efd3ac00 efd3a400 efd3a200 efd3a600
> efd3a000 efd3a800 e
> Sep 30 12:06:47 beowulf kernel: a00 efd72600 efd72a00 efd72e00 efd72c00
> efd72400 efd72000 efd72200 efd72800 efd57000 efd57a00 efd57200 efd57c00
> efd57400 efd57e00 efd57800 efd57600 efd89200 efd89600 efd89e00 efd89c00
> efd67000 efd67a00 efd67c00 efd67600 efd67400 efd67e00 efd67800 efd67200
> efd6fc00 efd6f600 efd6f800 efd6f200 efd74000 efd8e400 
> ########### adding device /dev/sdc
> Sep 30 12:06:47 beowulf kernel: scsi singledevice 3 0 7 0
> Sep 30 12:06:47 beowulf kernel: scsi: performing INQUIRY
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 7,
> buffer =efa63dd0, bufflen = 256, done = f880d090, timeout = 600, retries = 3)
> Sep 30 12:06:47 beowulf kernel: command : 12  00  00  00  ff  00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 7 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c800 at 600
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 7, command = efd7c858, buffer = efa63dd0, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 256, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c800 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 7 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 7 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: scsi: INQUIRY successful with code 0x0
> Sep 30 12:06:47 beowulf kernel:   Vendor: 3ware     Model: Logical Disk 7   
> Rev: 1.0 
> Sep 30 12:06:47 beowulf kernel:   Type:   Direct-Access                     
> ANSI SCSI revision: 00
> Sep 30 12:06:47 beowulf kernel: blk: queue efd7c818, I/O limit 4095Mb (mask
> 0xffffffff)
> Sep 30 12:06:47 beowulf kernel: Attached scsi disk sdc at scsi3, channel 0, id
> 7, lun 0
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 7,
> buffer =c0388000, bufflen = 0, done = f880d090, timeout = 3000, retries = 5)
> Sep 30 12:06:47 beowulf kernel: command : 00  00  00  00  00  00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 7 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd75400 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 7, command = efd75458, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 0, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd75400 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 7 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 7 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target = 7,
> buffer =c0388000, bufflen = 8, done = f880d090, timeout = 3000, retries = 5)
> Sep 30 12:06:47 beowulf kernel: command : 25  00  00  00  00  00  00  00  00 
> 00  
> Sep 30 12:06:47 beowulf kernel: Activating command for device 7 (1)
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd75400 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 7, command = efd75458, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 8, done = f880d090)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd75400 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 7 0
> Sep 30 12:06:47 beowulf kernel: Deactivating command for device 7 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel: SCSI device sdc: 488397168 512-byte hdwr
> sectors (250059 MB)
> Sep 30 12:06:47 beowulf kernel:  sdc:Activating command for device 7 (1)
> Sep 30 12:06:47 beowulf kernel: Doing sd request, dev = 0x820, block = 0
> Sep 30 12:06:47 beowulf kernel: sdc : real dev = /dev/2, block = 0
> Sep 30 12:06:47 beowulf kernel: sdc : reading 8/8 512 byte blocks.
> Sep 30 12:06:47 beowulf kernel: Adding timer for command efd75400 at 3000
> (f8812240)
> Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> target = 7, command = efd75458, buffer = c0388000, 
> Sep 30 12:06:47 beowulf kernel: bufflen = 4096, done = f8829c30)
> Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd75400 1
> Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for device
> 7 0
> Sep 30 12:06:47 beowulf kernel: sdc : rw_intr(3, 0 [0 0])
> Sep 30 12:06:47 beowulf kernel: 8 sectors total, 8 sectors done.
> Sep 30 12:06:47 beowulf kernel: use_sg is 1
> Sep 30 12:06:47 beowulf kernel:  Deactivating command for device 7 (active=0,
> failed=0)
> Sep 30 12:06:47 beowulf kernel:  sdc1
> Sep 30 12:06:47 beowulf kernel: Host status for host f3d4c000:
> Sep 30 12:06:47 beowulf kernel: Device 1 f5b71200: efd7c400 efd4ce00 efd4c000
> f7807600 f7807200 f7807c00 f7807e00 f7807800 f7807400 f7807a00 f7807000
> efd7f600 efd7f200 efd7f000 efd7fe00 efd7fc00 efd7f400 efd7f800 efd7fa00
> efd81600 efd81200 efd81c00 efd81400 efd81800 efd81000 efd81e00 efd81a00
> efd59c00 efd59e00 efd59a00 efd59200 efd59400 efd59800 efd59600 efd59000
> efd5e400 efd5e200 efd5ea00 efd5e800 efd5ee00 efd5e000 efd5ec00 efd5e600
> efd3d200 efd3d400 efd3dc00 efd3da00 efd3d000 efd3de00 efd3d600 efd3d800
> efd8f200 efd8f600 efd8f400 efd8f000 efd8fa00 efd8fc00 efd8f800 efd8fe00
> f7132000 f7132e00 f7132c00 f7132a00 f1ce2400 f1ce2a00 f1c24600 f1c24000
> f1c24c00 f1c24800 f1c24200 f1c24400 efd62c00 efd62e00 efd62400 efd62000
> efd62800 efd62600 efd62200 efd62a00 efd34a00 efd34400 efd34c00 efd34800
> efd34e00 efd34200 efd34000 efd34600 efd66a00 efd66c00 efd66600 efd66200
> efd66800 efd66000 efd66400 efd66e00 efd63e00 efd63200 efd63600 efd63c00
> efd63000 efd63800 efd63400 efd63a00 efd60a00 efd60e00 efd60000 efd60600
> efd60200 efd6
> Sep 30 12:06:47 beowulf kernel: c00 efd60400 efd60800 efd37400 efd37c00
> efd37000 efd37600 efd37200 efd37a00 efd37e00 efd37800 efd4c800 efd4c200
> efd4c400 efd4cc00 efd4c600 efd4ca00 efd4d600 efd4d000 efd4d200 efd4da00
> efd4dc00 efd4de00 efd56a00 efd56200 efd56600 efd56400 efd74c00 efd74600
> efd8e000 efd8ea00 efd8ec00 f505fc00 efd77800 efd77c00 efd77600 efd77200
> efd77000 efd77e00 efd77a00 f79d8200 f79d8a00 f79d8800 f79d8400 f79d8600
> f79d8000 f2580e00 f2580c00 f6588e00 f6588800 f6588c00 f1e4f800 f1e4f000
> f26e5000 f26e5600 f26e5200 f26e5a00 f26e5400 f26e5800 f79c8a00 f79c8200
> f79c8400 f79c8c00 f79c8000 f2901800 f2901000 f5b71a00 f5b71000 f5b71e00
> f5b71800 f5b71c00 f5b71600 f5b71400 efd89a00 efd89400 efd89800 efd89000
> f1ce2000 f1ce2200 efd56800 efd56e00 efd56000 efd56c00 f1c1c800 f1c1c600
> f1c1cc00 f1c1c200 f1c1c400 f1c1ca00 f1c1c000 f1c1ce00 efd5a400 efd5a200
> efd5a000 efd5ae00 efd5ac00 efd5a800 efd5a600 efd5aa00 efd5f400 efd5fc00
> efd5f200 efd5fe00 efd5f800 efd5f000 efd5f600 efd5fa00 efd6bc00 efd6be00
> efd6b000 efd6ba00 e
> Sep 30 12:06:47 beowulf kernel: 800 efd6b400 efd6b600 efd6b200 efd55600
> efd55a00 efd55c00 efd55400 efd55200 efd55e00 efd55000 efd55800 efd74200
> efd74400 efd74800 efd74a00 efd6fa00 efd6f400 efd6fe00 efd6f000 efd47000
> efd47600 efd47e00 efd47c00 efd47800 efd47a00 efd47200 efd47400 f1c24a00
> f1c24e00 efd4d800 efd4d400 efd8e800 efd8e200 efd8e600 
> Sep 30 12:06:47 beowulf kernel: Device 5 efd8ee00: efd8a800 efd8ac00 efd8ae00
> efd8a600 efd8a400 efd8a200 efd8aa00 efd8a000 efd83200 efd83a00 efd83400
> efd83800 efd83e00 efd83000 efd83c00 efd83600 efd7d400 efd7de00 efd7d800
> efd7da00 efd7d200 efd7dc00 efd7d000 efd7d600 efd5ba00 efd5b600 efd5bc00
> efd5b400 efd5b200 efd5b800 efd5be00 efd5b000 efd65a00 efd65e00 efd65600
> efd65400 efd65000 efd65800 efd65c00 efd65200 efd6d200 efd6de00 efd6d400
> efd6d000 efd6da00 efd6d800 efd6dc00 efd6d600 efd71200 efd71000 efd5ca00
> efd5c400 efd46000 efd46400 efd46800 efd46e00 efd46600 efd46a00 efd46200
> efd46c00 efd53600 efd53800 efd53c00 efd53e00 efd53000 efd53400 efd53a00
> efd53200 efd6c400 efd6ca00 efd6c800 efd6c600 efd6cc00 efd6c200 efd6c000
> efd6ce00 efd80600 efd80a00 efd80200 efd80e00 efd80c00 efd80800 efd80000
> efd80400 efd69a00 efd69400 efd69e00 efd69c00 efd69000 efd69200 efd69800
> efd69600 efd32c00 efd32600 efd32e00 efd32800 efd32200 efd32a00 efd32400
> efd32000 efd40200 efd40c00 efd40800 efd40e00 efd40400 efd40600 efd40a00
> efd40000 efd4
> Sep 30 12:06:47 beowulf kernel: e00 efd4ba00 efd4b400 efd4b600 efd41600
> efd41000 efd41400 efd41a00 efd41c00 efd41e00 efd41200 efd41800 efe23800
> efe23000 efe23e00 efe23200 efe23a00 efe23600 efe23400 efe23c00 efd3c200
> efd3c000 efd3cc00 efd3ce00 efd3c400 efd3ca00 efd3c600 efd3c800 efd91c00
> efd91a00 efd91200 efd91000 efd91600 efd91400 efd91e00 efd91800 efd64c00
> efd64e00 efd64600 efd64200 efd64400 efd64800 efd64a00 efd64000 efd31c00
> efd31a00 efd31600 efd31800 efd31200 efd31000 efd31e00 efd31400 efd88e00
> efd88000 efd88200 efd88800 efd88a00 efd88c00 efd88400 efd88600 efd5ce00
> efd5c000 efd5c200 efd5cc00 efd5c800 efd5c600 efd7ca00 efd7c200 efd7cc00
> efd7c000 efd7ce00 efd7c600 efd54000 efd54e00 efd54800 efd54200 efd54a00
> efd54c00 efd54600 efd54400 efd82600 efd82e00 efd82200 efd82800 efd82c00
> efd82000 efd82400 efd82a00 efd58600 efd58200 efd58a00 efd58400 efd58000
> efd58800 efd58c00 efd58e00 efd3e600 efd3e200 efd3ee00 efd3ea00 efd3ec00
> efd3e000 efd3e400 efd3e800 efd3ae00 efd3ac00 efd3a400 efd3a200 efd3a600
> efd3a000 efd3a800 e
> Sep 30 12:06:47 beowulf kernel: a00 efd72600 efd72a00 efd72e00 efd72c00
> efd72400 efd72000 efd72200 efd72800 efd57000 efd57a00 efd57200 efd57c00
> efd57400 efd57e00 efd57800 efd57600 efd89200 efd89600 efd89e00 efd89c00
> efd67000 efd67a00 efd67c00 efd67600 efd67400 efd67e00 efd67800 efd67200
> efd6fc00 efd6f600 efd6f800 efd6f200 efd74000 efd8e400 
> Sep 30 12:06:47 beowulf kernel: Device 7 efd74e00: efd75400 efd75000 efd75800
> efd75600 efd75e00 efd75c00 efd70e00 efd70a00 efd39800 efd39400 efd78e00
> efd78400 efd78200 efd78a00 efd78800 efd78000 efd78c00 efd78600 efd6aa00
> efd6a200 efd6a000 efd6a800 efd6a400 efd6ae00 efd6a600 efd6ac00 efd7b000
> efd7b200 efd7bc00 efd7b600 efd7ba00 efd7b800 efd7b400 efd7be00 efd76000
> efd76200 efd76800 efd76600 efd76c00 efd76a00 efd76400 efd76e00 efd79a00
> efd79e00 efd79200 efd79400 efd79c00 efd79800 efd79000 efd79600 efd4f400
> efd4fe00 efd4f200 efd4fc00 efd4fa00 efd4f000 efd4f800 efd4f600 efd44c00
> efd44000 efd44a00 efd44e00 efd44800 efd44200 efd44600 efd44400 efd73600
> efd73c00 efd73a00 efd73e00 efd43e00 efd43400 efd43600 efd43a00 efd43c00
> efd43800 efd43000 efd43200 efc5e000 efc5e200 efc5ee00 efc5e800 efc5e400
> efc5ec00 efc5e600 efc5ea00 efd38800 efd38600 efd38200 efd38000 efd38e00
> efd38c00 efd38400 efd38a00 efd45a00 efd45c00 efd45200 efd45400 efd45600
> efd45000 efd45e00 efd45800 efd36a00 efd36800 efd36000 efd36c00 efd36600
> efd36400 efd3
> Sep 30 12:06:47 beowulf kernel: 200 efd36e00 efd8ce00 efd8c200 efd8c000
> efd8ca00 efd8c400 efd8c600 efd8cc00 efd8c800 ee573800 ee573200 ee573e00
> ee573000 ee573400 ee573a00 ee573c00 ee573600 efd39c00 efd39200 efd39a00
> efd39600 efd39e00 efd39000 efd71800 efd71400 efd71a00 efd71e00 efd71600
> efd71c00 efd8d600 efd8dc00 efd8d400 efd8d200 efd8da00 efd8de00 efd8d800
> efd8d000 efd86800 efd86600 efd86400 efd86a00 efd86000 efd86e00 efd86c00
> efd86200 f1cdec00 f1cde400 f1cde800 f1cde600 f1cdea00 f1cdee00 f1cde200
> f1cde000 efd6e200 efd6ea00 efd6e800 efd6ec00 efd6ee00 efd6e600 efd6e400
> efd6e000 efd4ea00 efd4ec00 efd4e000 efd4ee00 efd4e200 efd4e600 efd4e400
> efd4e800 efd52a00 efd52400 efd52800 efd52200 efd52000 efd52e00 efd52600
> efd52c00 efd68c00 efd68600 efd68800 efd68400 efd68a00 efd68000 efd68200
> efd68e00 f7132800 f7132600 f7132400 f7132200 efe4f600 efe4fc00 efe4f400
> efe4fe00 efe4f800 efe4f200 efe4f000 efe4fa00 efd49600 efd49c00 efd49200
> efd49800 efd49e00 efd49000 efd49400 efd49a00 efd4aa00 efd4ae00 efd4a800
> efd4a400 efd4ac00 e
> Sep 30 12:06:47 beowulf kernel: 600 efd4a000 efd4a200 f2d4a800 f2d4a200
> f2d4a600 f2d4a000 f2d4ae00 f2d4ac00 f2d4a400 f2d4aa00 efd3b000 efd3b600
> efd3b400 efd3b800 efd3be00 efd3bc00 efd3b200 efd3ba00 efd33a00 efd33600
> efd33c00 efd33e00 efd33200 efd33800 efd33000 efd33400 efd51800 efd51e00
> efd51c00 efd51600 efd51a00 efd51200 efd51000 efd51400 
> 
> Sep 30 12:06:48 beowulf kernel: scsi singledevice 3 0 1 0
> Sep 30 12:06:48 beowulf kernel: blk: queue efd74e18, I/O limit 4095Mb (mask
> 0xffffffff)
> 
>   At this point system had to be rebooted. 
> 
> 
> 
>   
> 
> 
> =====
> Don Jessup
> Asaca/Shibasoku Corp. of America
> 400 Corporate Circle, Unit G
> Golden, CO  80401
> 303-278-1111 X232
> donj@asaca.com
> http://www.asaca.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


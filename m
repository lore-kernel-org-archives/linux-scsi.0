From: Don Jessup <donj@asaca.com>
Subject: Re: SCSI Hang 2.4.22 kernel, Help
Date: Fri, 3 Oct 2003 08:36:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031003153619.64437.qmail@web14507.mail.yahoo.com>
References: <1065118800.4779.162.camel@persist.az.mvista.com>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web14507.mail.yahoo.com ([216.136.224.70]:38924 "HELO
	web14507.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263751AbTJCPgU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2003 11:36:20 -0400
In-Reply-To: <1065118800.4779.162.camel@persist.az.mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: sdake@mvista.com
Cc: linux-scsi@vger.kernel.org


  Thanks for responding.   I would like to give the patch a try.  Were
  can I get it?  Are you aware of any more information on the problem?
  Is there a thread on any of mailing list that I can read about this 
  problem? Is there a work around?  

  Thank You
  
--- Steven Dake <sdake@mvista.com> wrote:
> Don,
> 
> scsi add and remove are not safe in SMP systems because the locking in
> the kernel is broken (or rather, non-existent) in the 2.4 kernel (and I
> believe also in 2.6).
> 
> I think it is unlikely to be fixed in 2.4.X but someone may provide a
> patch.  I posted a patch some time ago that fixes the problem, but
> during SCSI error handling and add/removes, the system would not respond
> properly so that patch was abondoned.  You could try it though..
> 
> Thanks
> --steve
> 
> On Tue, 2003-09-30 at 14:44, Don Jessup wrote:
> > 
> >   
> >   As stated in the header I'm using the 2.4.22 SMP kernel and I have 3 SATA
> > Disk attached
> >  to a 3ware card.  I have set up a script that just does 
> >   echo "scsi remove-single-device 3 0 1 0" 
> >   echo "scsi remove-single-device 3 0 5 0"
> >   echo "scsi remove-single-device 3 0 7 0"
> >   echo "scsi add-single-device 3 0 1 0"
> >   echo "scsi add-single-device 3 0 5 0"
> >   echo "scsi add-single-device 3 0 7 0"
> > 
> >   It sleeps for one second then repeats the above steps.  
> > 
> >     
> > 
> >    After about two hours of running this script the system just hangs.  
> This
> >  is not a problem in UP only in SMP.   I have turned on SCSI Debug
> information
> >   for this test and have included it below.  Does anyone have any idea why
> this
> >   would be happening and if there are currently any fixes for this hang. 
> By
> >   the way the system is Dual Xeon System with a  1G of ram and
> hyperthreading
> >    turned ON.    
> > 
> >   I'm doing this because I'm working on the system that is always 
> >   adding and removing scsi devices although not nearly as fast as this
> script
> >   is doing.  After several days it seems to hang and always hangs on adding
> or
> >    removing a device.  As I stated above with the script I can make it
> happen
> >   in a few hours.
> > 
> >   There is a lot of debugging information.  Here it is.  I hope someone has
> >   some idea of what the problem might be and how to fix it.   
> > 
> > 
> >   Thank You  ahead time.
> > 
> > 
> > Sep 30 12:06:47 beowulf kernel: scsi singledevice 3 0 1 0
> > Sep 30 12:06:47 beowulf kernel: blk: queue f5b71218, I/O limit 4095Mb (mask
> > 0xffffffff)
> > Sep 30 12:06:47 beowulf kernel: scsi: performing INQUIRY
> > Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target =
> 1,
> > buffer =efa63dd0, bufflen = 256, done = f880d090, timeout = 600, retries =
> 3)
> > Sep 30 12:06:47 beowulf kernel: command : 12  00  00  00  ff  00  
> > Sep 30 12:06:47 beowulf kernel: Activating command for device 1 (1)
> > Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> > Sep 30 12:06:47 beowulf kernel: Adding timer for command efd8ee00 at 600
> > (f8812240)
> > Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> > target = 1, command = efd8ee58, buffer = efa63dd0, 
> > Sep 30 12:06:47 beowulf kernel: bufflen = 256, done = f880d090)
> > Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> > Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> > Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> > Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd8ee00 1
> > Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> > Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for
> device
> > 1 0
> > Sep 30 12:06:47 beowulf kernel: Deactivating command for device 1
> (active=0,
> > failed=0)
> > Sep 30 12:06:47 beowulf kernel: scsi: INQUIRY successful with code 0x0
> > Sep 30 12:06:47 beowulf kernel:   Vendor: 3ware     Model: Logical Disk 1  
> 
> > Rev: 1.0 
> > Sep 30 12:06:47 beowulf kernel:   Type:   Direct-Access                    
> 
> > ANSI SCSI revision: 00
> > Sep 30 12:06:47 beowulf kernel: blk: queue efd8ee18, I/O limit 4095Mb (mask
> > 0xffffffff)
> > Sep 30 12:06:47 beowulf kernel: Attached scsi disk sda at scsi3, channel 0,
> id
> > 1, lun 0
> > Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target =
> 1,
> > buffer =c0388000, bufflen = 0, done = f880d090, timeout = 3000, retries =
> 5)
> > Sep 30 12:06:47 beowulf kernel: command : 00  00  00  00  00  00  
> > Sep 30 12:06:47 beowulf kernel: Activating command for device 1 (1)
> > Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> > Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c400 at 3000
> > (f8812240)
> > Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> > target = 1, command = efd7c458, buffer = c0388000, 
> > Sep 30 12:06:47 beowulf kernel: bufflen = 0, done = f880d090)
> > Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> > Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> > Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> > Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c400 1
> > Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> > Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for
> device
> > 1 0
> > Sep 30 12:06:47 beowulf kernel: Deactivating command for device 1
> (active=0,
> > failed=0)
> > Sep 30 12:06:47 beowulf kernel: scsi_do_req (host = 3, channel = 0 target =
> 1,
> > buffer =c0388000, bufflen = 8, done = f880d090, timeout = 3000, retries =
> 5)
> > Sep 30 12:06:47 beowulf kernel: command : 25  00  00  00  00  00  00  00 
> 00 
> > 00  
> > Sep 30 12:06:47 beowulf kernel: Activating command for device 1 (1)
> > Sep 30 12:06:47 beowulf kernel: Leaving scsi_init_cmd_from_req()
> > Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c400 at 3000
> > (f8812240)
> > Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> > target = 1, command = efd7c458, buffer = c0388000, 
> > Sep 30 12:06:47 beowulf kernel: bufflen = 8, done = f880d090)
> > Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> > Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> > Sep 30 12:06:47 beowulf kernel: Leaving scsi_do_req()
> > Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c400 1
> > Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> > Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for
> device
> > 1 0
> > Sep 30 12:06:47 beowulf kernel: Deactivating command for device 1
> (active=0,
> > failed=0)
> > Sep 30 12:06:47 beowulf kernel: SCSI device sda: 488397168 512-byte hdwr
> > sectors (250059 MB)
> > Sep 30 12:06:47 beowulf kernel:  sda:Activating command for device 1 (1)
> > Sep 30 12:06:47 beowulf kernel: Doing sd request, dev = 0x800, block = 0
> > Sep 30 12:06:47 beowulf kernel: sda : real dev = /dev/0, block = 0
> > Sep 30 12:06:47 beowulf kernel: sda : reading 8/8 512 byte blocks.
> > Sep 30 12:06:47 beowulf kernel: Adding timer for command efd7c400 at 3000
> > (f8812240)
> > Sep 30 12:06:47 beowulf kernel: scsi_dispatch_cmnd (host = 3, channel = 0,
> > target = 1, command = efd7c458, buffer = c0388000, 
> > Sep 30 12:06:47 beowulf kernel: bufflen = 4096, done = f8829c30)
> > Sep 30 12:06:47 beowulf kernel: queuecommand : routine at f885e6f0
> > Sep 30 12:06:47 beowulf kernel: leaving scsi_dispatch_cmnd()
> > Sep 30 12:06:47 beowulf kernel: Clearing timer for command efd7c400 1
> > Sep 30 12:06:47 beowulf kernel: Command finished 1 0 0x0
> > Sep 30 12:06:47 beowulf kernel: Notifying upper driver of completion for
> device
> > 1 0
> > Sep 30 12:06:47 beowulf kernel: sda : rw_intr(3, 0 [0 0])
> > Sep 30 12:06:47 beowulf kernel: 8 sectors total, 8 sectors done.
> > Sep 30 12:06:47 beowulf kernel: use_sg is 1
> > Sep 30 12:06:47 beowulf kernel:  Deactivating command for device 1
> (active=0,
> > failed=0)
> > Sep 30 12:06:47 beowulf kernel:  sda1
> > Sep 30 12:06:47 beowulf kernel: Host status for host f3d4c000:
> > Sep 30 12:06:47 beowulf kernel: Device 1 f5b71200: efd7c400 efd4ce00
> efd4c000
> > f7807600 f7807200 f7807c00 f7807e00 f7807800 f7807400 f7807a00 f7807000
> > efd7f600 efd7f200 efd7f000 efd7fe00 efd7fc00 efd7f400 efd7f800 efd7fa00
> > efd81600 efd81200 efd81c00 efd81400 efd81800 efd81000 efd81e00 efd81a00
> > efd59c00 efd59e00 efd59a00 efd59200 efd59400 efd59800 efd59600 efd59000
> > efd5e400 efd5e200 efd5ea00 efd5e800 efd5ee00 efd5e000 efd5ec00 efd5e600
> > efd3d200 efd3d400 efd3dc00 efd3da00 efd3d000 efd3de00 efd3d600 efd3d800
> > efd8f200 efd8f600 efd8f400 efd8f000 efd8fa00 efd8fc00 efd8f800 efd8fe00
> > f7132000 f7132e00 f7132c00 f7132a00 f1ce2400 f1ce2a00 f1c24600 f1c24000
> > f1c24c00 f1c24800 f1c24200 f1c24400 efd62c00 efd62e00 efd62400 efd62000
> > efd62800 efd62600 efd62200 efd62a00 efd34a00 efd34400 efd34c00 efd34800
> > efd34e00 efd34200 efd34000 efd34600 efd66a00 efd66c00 efd66600 efd66200
> > efd66800 efd66000 efd66400 efd66e00 efd63e00 efd63200 efd63600 efd63c00
> > efd63000 efd63800 efd63400 efd63a00 efd60a00 efd60e00 efd60000 efd60600
> > efd60200 efd6
> > Sep 30 12:06:47 beowulf kernel: c00 efd60400 efd60800 efd37400 efd37c00
> > efd37000 efd37600 efd37200 efd37a00 efd37e00 efd37800 efd4c800 efd4c200
> > efd4c400 efd4cc00 efd4c600 efd4ca00 efd4d600 efd4d000 efd4d200 efd4da00
> > efd4dc00 efd4de00 efd56a00 efd56200 efd56600 efd56400 efd74c00 efd74600
> > efd8e000 efd8ea00 efd8ec00 f505fc00 efd77800 efd77c00 efd77600 efd77200
> > efd77000 efd77e00 efd77a00 f79d8200 f79d8a00 f79d8800 f79d8400 f79d8600
> > f79d8000 f2580e00 f2580c00 f6588e00 f6588800 f6588c00 f1e4f800 f1e4f000
> > f26e5000 f26e5600 f26e5200 f26e5a00 f26e5400 f26e5800 f79c8a00 f79c8200
> > f79c8400 f79c8c00 f79c8000 f2901800 f2901000 f5b71a00 f5b71000 f5b71e00
> > f5b71800 f5b71c00 f5b71600 f5b71400 efd89a00 efd89400 efd89800 efd89000
> > f1ce2000 f1ce2200 efd56800 efd56e00 efd56000 efd56c00 f1c1c800 f1c1c600
> > f1c1cc00 f1c1c200 f1c1c400 f1c1ca00 f1c1c000 f1c1ce00 efd5a400 efd5a200
> > efd5a000 efd5ae00 efd5ac00 efd5a800 efd5a600 efd5aa00 efd5f400 efd5fc00
> 
=== message truncated ===


=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com

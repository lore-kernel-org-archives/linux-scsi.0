From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Sat, 11 Feb 2006 00:01:40 +0100
Message-ID: <20060210230140.GA26423@suse.de>
References: <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de> <20060206220434.GA11732@suse.de> <1139265890.3022.63.camel@mulgrave.il.steeleye.com> <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:9442 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932230AbWBJXBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 18:01:47 -0500
Content-Disposition: inline
In-Reply-To: <20060210141012.GA12147@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 On Fri, Feb 10, Olaf Hering wrote:

>  On Fri, Feb 10, James Bottomley wrote:
> 
> > On Fri, 2006-02-10 at 11:11 +0100, Olaf Hering wrote:
> > > 550 reboots without crash, with this patch reverted.
> > > Will try the execute_in_process_context thing now.
> > 
> > I wouldn't bother ... because of the structure, the
> > execute_in_process_context() patch must have the same bug, but the
> > context check will make it much more difficult to hit.
> 
> Ok, will revert to the -git7 status and poke around once it crashes.

this is struct scsi_target in scsi_target_reap_work()

(gdb) p st
$1 = {starget_sdev_user = 0x0, siblings = {next = 0xc0000000024caca8, prev = 0xc0000000024caca8}, devices = {next = 0xc0000000024cacb8, prev = 0xc0000000024cacb8}, 
  dev = {klist_children = {k_lock = {raw_lock = {slock = 0}, magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff}, k_list = {
        next = 0xc0000000024cace0, prev = 0xc0000000024cace0}, get = 0xc000000000614f68, put = 0xc000000000614f38}, knode_parent = {n_klist = 0x0, n_node = {
        next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0}}, n_removed = {done = 0, wait = {lock = {raw_lock = {slock = 0}, magic = 0, owner_cpu = 0, 
            owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, knode_driver = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {refcount = {
          counter = 0}}, n_removed = {done = 0, wait = {lock = {raw_lock = {slock = 0}, magic = 0, owner_cpu = 0, owner = 0x0}, task_list = {next = 0x0, 
            prev = 0x0}}}}, knode_bus = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0}}, n_removed = {done = 0, wait = {
          lock = {raw_lock = {slock = 0}, magic = 0, owner_cpu = 0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, parent = 0xc00000000303a1a8, kobj = {
      k_name = 0xc0000000024cae00 <Address 0xc0000000024cae00 out of bounds>, name = "target0:255:100\000\000\000\000", kref = {refcount = {counter = 6}}, entry = {
        next = 0xc0000000024cae18, prev = 0xc0000000024cae18}, parent = 0xc00000000303a2d8, kset = 0xc000000000500c88, ktype = 0x0, dentry = 0x0}, 
    bus_id = "target0:255:100\000\000\000\000", uevent_attr = {attr = {name = 0x0, owner = 0x0, mode = 0}, show = 0, store = 0}, sem = {count = {counter = 1}, 
      wait = {lock = {raw_lock = {slock = 0}, magic = 3735899821, owner_cpu = 4294967295, owner = 0xffffffffffffffff}, task_list = {next = 0xc0000000024caea8, 
          prev = 0xc0000000024caea8}}}, bus = 0x0, driver = 0x0, driver_data = 0x0, platform_data = 0x0, firmware_data = 0x0, power = {power_state = {event = 0}, 
      can_wakeup = 0}, dma_mask = 0x0, coherent_dma_mask = 0, dma_pools = {next = 0xc0000000024caef8, prev = 0xc0000000024caef8}, dma_mem = 0x0, 
    release = 0xd0000000002190c0}, reap_ref = 0, channel = 255, id = 100, create = 0, scsi_level = 0 '\0', hostdata = 0x0, starget_data = 0x1ffffffec60}
(gdb) p/x st
$2 = {starget_sdev_user = 0x0, siblings = {next = 0xc0000000024caca8, prev = 0xc0000000024caca8}, devices = {next = 0xc0000000024cacb8, prev = 0xc0000000024cacb8}, 
  dev = {klist_children = {k_lock = {raw_lock = {slock = 0x0}, magic = 0xdead4ead, owner_cpu = 0xffffffff, owner = 0xffffffffffffffff}, k_list = {
        next = 0xc0000000024cace0, prev = 0xc0000000024cace0}, get = 0xc000000000614f68, put = 0xc000000000614f38}, knode_parent = {n_klist = 0x0, n_node = {
        next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0x0}}, n_removed = {done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, 
            owner_cpu = 0x0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, knode_driver = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {
        refcount = {counter = 0x0}}, n_removed = {done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, owner_cpu = 0x0, owner = 0x0}, task_list = {
            next = 0x0, prev = 0x0}}}}, knode_bus = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0x0}}, n_removed = {
        done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, owner_cpu = 0x0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, 
    parent = 0xc00000000303a1a8, kobj = {k_name = 0xc0000000024cae00, name = {0x74, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3a, 0x32, 0x35, 0x35, 0x3a, 0x31, 0x30, 
        0x30, 0x0, 0x0, 0x0, 0x0, 0x0}, kref = {refcount = {counter = 0x6}}, entry = {next = 0xc0000000024cae18, prev = 0xc0000000024cae18}, 
      parent = 0xc00000000303a2d8, kset = 0xc000000000500c88, ktype = 0x0, dentry = 0x0}, bus_id = {0x74, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3a, 0x32, 0x35, 
      0x35, 0x3a, 0x31, 0x30, 0x30, 0x0, 0x0, 0x0, 0x0, 0x0}, uevent_attr = {attr = {name = 0x0, owner = 0x0, mode = 0x0}, show = 0x0, store = 0x0}, sem = {
      count = {counter = 0x1}, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0xdead4ead, owner_cpu = 0xffffffff, owner = 0xffffffffffffffff}, task_list = {
          next = 0xc0000000024caea8, prev = 0xc0000000024caea8}}}, bus = 0x0, driver = 0x0, driver_data = 0x0, platform_data = 0x0, firmware_data = 0x0, power = {
      power_state = {event = 0x0}, can_wakeup = 0x0}, dma_mask = 0x0, coherent_dma_mask = 0x0, dma_pools = {next = 0xc0000000024caef8, prev = 0xc0000000024caef8}, 
    dma_mem = 0x0, release = 0xd0000000002190c0}, reap_ref = 0x0, channel = 0xff, id = 0x64, create = 0x0, scsi_level = 0x0, hostdata = 0x0, 
  starget_data = 0x1ffffffec60}

1:mon> d c0000000024caca0 666
c0000000024caca0 0000000000000000 c0000000024caca8  |.............L..|
c0000000024cacb0 c0000000024caca8 c0000000024cacb8  |.....L.......L..|
c0000000024cacc0 c0000000024cacb8 00000000dead4ead  |.....L........N.|
c0000000024cacd0 ffffffff00000000 ffffffffffffffff  |................|
c0000000024cace0 c0000000024cace0 c0000000024cace0  |.....L.......L..|
c0000000024cacf0 c000000000614f68 c000000000614f38  |.....aOh.....aO8|
c0000000024cad00 0000000000000000 0000000000000000  |................|
c0000000024cad10 0000000000000000 0000000000000000  |................|
c0000000024cad20 0000000000000000 0000000000000000  |................|
c0000000024cad30 0000000000000000 0000000000000000  |................|
c0000000024cad40 0000000000000000 0000000000000000  |................|
c0000000024cad50 0000000000000000 0000000000000000  |................|
c0000000024cad60 0000000000000000 0000000000000000  |................|
c0000000024cad70 0000000000000000 0000000000000000  |................|
c0000000024cad80 0000000000000000 0000000000000000  |................|
c0000000024cad90 0000000000000000 0000000000000000  |................|
c0000000024cada0 0000000000000000 0000000000000000  |................|
c0000000024cadb0 0000000000000000 0000000000000000  |................|
c0000000024cadc0 0000000000000000 0000000000000000  |................|
c0000000024cadd0 0000000000000000 0000000000000000  |................|
c0000000024cade0 0000000000000000 0000000000000000  |................|
c0000000024cadf0 c00000000303a1a8 c0000000024cae00  |.............L..|
c0000000024cae00 746172676574303a 3235353a31303000  |target0:255:100.|
c0000000024cae10 0000000000000006 c0000000024cae18  |.............L..|
c0000000024cae20 c0000000024cae18 c00000000303a2d8  |.....L..........|
c0000000024cae30 c000000000500c88 0000000000000000  |.....P..........|
c0000000024cae40 0000000000000000 746172676574303a  |........target0:|
c0000000024cae50 3235353a31303000 0000000000000000  |255:100.........|
c0000000024cae60 0000000000000000 0000000000000000  |................|
c0000000024cae70 0000000000000000 0000000000000000  |................|
c0000000024cae80 0000000000000000 0000000100000000  |................|
c0000000024cae90 00000000dead4ead ffffffff00000000  |......N.........|
c0000000024caea0 ffffffffffffffff c0000000024caea8  |.............L..|
c0000000024caeb0 c0000000024caea8 0000000000000000  |.....L..........|
c0000000024caec0 0000000000000000 0000000000000000  |................|
c0000000024caed0 0000000000000000 0000000000000000  |................|
c0000000024caee0 0000000000000000 0000000000000000  |................|
c0000000024caef0 0000000000000000 c0000000024caef8  |.............L..|
c0000000024caf00 c0000000024caef8 0000000000000000  |.....L..........|
c0000000024caf10 d0000000002190c0 00000000000000ff  |.....!..........|
c0000000024caf20 0000006400000000 0000000000000000  |...d............|
c0000000024caf30 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf40 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf50 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf60 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf70 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf80 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024caf90 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafa0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafb0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafc0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafd0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
c0000000024cafe0 5a5a5a5a5a5a5a5a 5a5a5a5a5a5a5a5a  |ZZZZZZZZZZZZZZZZ|
....

-- 
short story of a lazy sysadmin:
 alias appserv=wotan

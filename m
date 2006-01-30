From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.15-git12, slab corruption in ipr
Date: Mon, 30 Jan 2006 17:49:54 +0100
Message-ID: <20060130164954.GA4711@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:16543 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932327AbWA3Qt5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 11:49:57 -0500
Content-Disposition: inline
In-Reply-To: <20060130104613.GA26551@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Brian J King <bjking1@us.ibm.com>

 On Mon, Jan 30, Olaf Hering wrote:

> I see it not only on ipr systems, also on JS20 with the media tray
> assigned. It doesnt reproduce all the time. I'm currently down to 'only
> 20 patches applied from our CVS'. The symptoms differ, I suspect the bug
> is also present in mainline.
> 
> Just to let you know. Still looking.

I guess you dont use the latest udev technology...

This is what I got with only 10 (unrelated) patches applied:

TCP reno registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Freeing unused kernel memory: 260k freed
Starting udevd
Creating devices
Loading sd_mod
SCSI subsystem initialized
Loading loop
loop: loaded (max 255 devices)
Loading ipr
ipr: IBM Power RAID SCSI Device Driver version: 2.1.1 (November 15, 2005)
ipr 0000:c0:01.0: Found IOA with IRQ: 99
ipr 0000:c0:01.0: Starting IOA initialization sequence.
ipr 0000:c0:01.0: Adapter firmware version: 020A004E
ipr 0000:c0:01.0: IOA initialized.
scsi0 : IBM 570B Storage Adapter
  Vendor: IBM       Model: ST373453LC        Rev: C51A
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 143374000 512-byte hdwr sectors (73407 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
SCSI device sda: 143374000 512-byte hdwr sectors (73407 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through w/ FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:3:0: Attached scsi disk sda
  Vendor: IBM       Model: VSBPD3E   U4SCSI  Rev: 4812
  Type:   Enclosure                          ANSI SCSI revision: 02
Unable to handle kernel paging request for data at address 0x00000004
Faulting instruction address: 0xc0000000001dcc98
cpu 0x0: Vector: 300 (Data Access) at [c0000000ebcd37e0]
    pc: c0000000001dcc98: ._raw_spin_lock+0x28/0x17c
    lr: c000000000388b40: ._spin_lock+0x10/0x24
    sp: c0000000ebcd3a60
   msr: 8000000000009032
   dar: 4
 dsisr: 40000000
  current = 0xc0000000ebcc1000
  paca    = 0xc0000000004a6e00
    pid   = 26, comm = events/0
enter ? for help
0:mon> t
[c0000000ebcd3af0] c000000000388b40 ._spin_lock+0x10/0x24
[c0000000ebcd3b70] c000000000385380 .klist_del+0x28/0x58
[c0000000ebcd3c00] c000000000262bb0 .device_del+0x50/0x120
[c0000000ebcd3ca0] d00000000007ac18 .scsi_target_reap_work+0xe0/0x12c [scsi_mod]
[c0000000ebcd3d30] c000000000077bdc .run_workqueue+0x108/0x19c
[c0000000ebcd3dd0] c000000000077dc0 .worker_thread+0x150/0x1c0
[c0000000ebcd3ed0] c00000000007d72c .kthread+0x140/0x190
[c0000000ebcd3f90] c000000000025d1c .kernel_thread+0x4c/0x68


knode_parent is all zeros.

device_del():
(gdb) p/x dev
$1 = {klist_children = {k_lock = {raw_lock = {slock = 0x0}, magic = 0xdead4ead, owner_cpu = 0xffffffff, owner = 0xffffffffffffffff}, k_list = {
      next = 0xc00000006f033710, prev = 0xc00000006f033710}, get = 0xc000000000620a20, put = 0xc0000000006209f0}, knode_parent = {n_klist = 0x0, n_node = {
      next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0x0}}, n_removed = {done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, 
          owner_cpu = 0x0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, knode_driver = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {
      refcount = {counter = 0x0}}, n_removed = {done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, owner_cpu = 0x0, owner = 0x0}, task_list = {
          next = 0x0, prev = 0x0}}}}, knode_bus = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0x0}}, n_removed = {done = 0x0, 
      wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, owner_cpu = 0x0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, parent = 0xc00000000fc7e1a8, 
  kobj = {k_name = 0xc00000006f033830, name = {0x74, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3a, 0x32, 0x35, 0x35, 0x3a, 0x33, 0x38, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 
    kref = {refcount = {counter = 0x1}}, entry = {next = 0xc00000006f033848, prev = 0xc00000006f033848}, parent = 0xc00000000fc7e2d8, kset = 0xc000000000509508, 
    ktype = 0x0, dentry = 0x0}, bus_id = {0x74, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3a, 0x32, 0x35, 0x35, 0x3a, 0x33, 0x38, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 
  uevent_attr = {attr = {name = 0x0, owner = 0x0, mode = 0x0}, show = 0x0, store = 0x0}, sem = {count = {counter = 0x1}, wait = {lock = {raw_lock = {slock = 0x0}, 
        magic = 0xdead4ead, owner_cpu = 0xffffffff, owner = 0xffffffffffffffff}, task_list = {next = 0xc00000006f0338d8, prev = 0xc00000006f0338d8}}}, bus = 0x0, 
  driver = 0x0, driver_data = 0x0, platform_data = 0x0, firmware_data = 0x0, power = {power_state = {event = 0x0}, can_wakeup = 0x0}, dma_mask = 0x0, 
  coherent_dma_mask = 0x0, dma_pools = {next = 0xc00000006f033928, prev = 0xc00000006f033928}, dma_mem = 0x0, release = 0xd0000000000a4d38}



-- 
short story of a lazy sysadmin:
 alias appserv=wotan

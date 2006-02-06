From: Olaf Hering <olh@suse.de>
Subject: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Mon, 6 Feb 2006 23:04:34 +0100
Message-ID: <20060206220434.GA11732@suse.de>
References: <20060117000533.GA27473@suse.de> <43CE8C26.4000202@us.ibm.com> <20060119210514.GA7118@suse.de> <20060130104613.GA26551@suse.de> <20060130164954.GA4711@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:37602 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932167AbWBFWEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 17:04:36 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 377CEEBAB
	for <linux-scsi@vger.kernel.org>; Mon,  6 Feb 2006 23:04:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20060130164954.GA4711@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 On Mon, Jan 30, Olaf Hering wrote:

> Unable to handle kernel paging request for data at address 0x00000004
> Faulting instruction address: 0xc0000000001dcc98
> cpu 0x0: Vector: 300 (Data Access) at [c0000000ebcd37e0]
>     pc: c0000000001dcc98: ._raw_spin_lock+0x28/0x17c
>     lr: c000000000388b40: ._spin_lock+0x10/0x24
>     sp: c0000000ebcd3a60
>    msr: 8000000000009032
>    dar: 4
>  dsisr: 40000000
>   current = 0xc0000000ebcc1000
>   paca    = 0xc0000000004a6e00
>     pid   = 26, comm = events/0
> enter ? for help
> 0:mon> t
> [c0000000ebcd3af0] c000000000388b40 ._spin_lock+0x10/0x24
> [c0000000ebcd3b70] c000000000385380 .klist_del+0x28/0x58
> [c0000000ebcd3c00] c000000000262bb0 .device_del+0x50/0x120
> [c0000000ebcd3ca0] d00000000007ac18 .scsi_target_reap_work+0xe0/0x12c [scsi_mod]
> [c0000000ebcd3d30] c000000000077bdc .run_workqueue+0x108/0x19c
> [c0000000ebcd3dd0] c000000000077dc0 .worker_thread+0x150/0x1c0
> [c0000000ebcd3ed0] c00000000007d72c .kthread+0x140/0x190
> [c0000000ebcd3f90] c000000000025d1c .kernel_thread+0x4c/0x68
> 
> 
> knode_parent is all zeros.
> 
> device_del():
> (gdb) p/x dev
> $1 = {klist_children = {k_lock = {raw_lock = {slock = 0x0}, magic = 0xdead4ead, owner_cpu = 0xffffffff, owner = 0xffffffffffffffff}, k_list = {
>       next = 0xc00000006f033710, prev = 0xc00000006f033710}, get = 0xc000000000620a20, put = 0xc0000000006209f0}, knode_parent = {n_klist = 0x0, n_node = {
>       next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0x0}}, n_removed = {done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, 
>           owner_cpu = 0x0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, knode_driver = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {
>       refcount = {counter = 0x0}}, n_removed = {done = 0x0, wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, owner_cpu = 0x0, owner = 0x0}, task_list = {
>           next = 0x0, prev = 0x0}}}}, knode_bus = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0}, n_ref = {refcount = {counter = 0x0}}, n_removed = {done = 0x0, 
>       wait = {lock = {raw_lock = {slock = 0x0}, magic = 0x0, owner_cpu = 0x0, owner = 0x0}, task_list = {next = 0x0, prev = 0x0}}}}, parent = 0xc00000000fc7e1a8, 
>   kobj = {k_name = 0xc00000006f033830, name = {0x74, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3a, 0x32, 0x35, 0x35, 0x3a, 0x33, 0x38, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 
>     kref = {refcount = {counter = 0x1}}, entry = {next = 0xc00000006f033848, prev = 0xc00000006f033848}, parent = 0xc00000000fc7e2d8, kset = 0xc000000000509508, 
>     ktype = 0x0, dentry = 0x0}, bus_id = {0x74, 0x61, 0x72, 0x67, 0x65, 0x74, 0x30, 0x3a, 0x32, 0x35, 0x35, 0x3a, 0x33, 0x38, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}, 
>   uevent_attr = {attr = {name = 0x0, owner = 0x0, mode = 0x0}, show = 0x0, store = 0x0}, sem = {count = {counter = 0x1}, wait = {lock = {raw_lock = {slock = 0x0}, 
>         magic = 0xdead4ead, owner_cpu = 0xffffffff, owner = 0xffffffffffffffff}, task_list = {next = 0xc00000006f0338d8, prev = 0xc00000006f0338d8}}}, bus = 0x0, 
>   driver = 0x0, driver_data = 0x0, platform_data = 0x0, firmware_data = 0x0, power = {power_state = {event = 0x0}, can_wakeup = 0x0}, dma_mask = 0x0, 
>   coherent_dma_mask = 0x0, dma_pools = {next = 0xc00000006f033928, prev = 0xc00000006f033928}, dma_mem = 0x0, release = 0xd0000000000a4d38}

I need help on this one.
What I have so far (via git-bisect) is:

f62870db3c73683fe566a05efa2a05f3faeb44f5 is a bad 

But the/a good one is 5e03e2c48fc2952f6a9e986cfa194fe905d0f569. So the
remaining ones are all docu.
Maybe I just dont use git-bisect correctly, and maybe the changes are all that linear.

I started with:
 git-bisect bad 7a0268fa1a3613f2c526a9b3058701b277f6abe1
 git-bisect good a020ff412f0ecbb1e4aae1681b287e5785dd77b5

 2006-02-05 14:07 .git/refs/bisect/good-a020ff412f0ecbb1e4aae1681b287e5785dd77b5
 2006-02-05 21:25 .git/refs/bisect/good-f61ea1b0c825a20a1826bb43a226387091934586
 2006-02-06 07:02 .git/refs/bisect/good-f2e46561cc1afa82b18b2fc6efc8510ec57c7d7d
 2006-02-06 10:24 .git/refs/bisect/good-d779188d2baf436e67fe8816fca2ef53d246900f
 2006-02-06 14:37 .git/refs/bisect/good-1cb9e8e01d2c73184e2074f37cd155b3c4fdaae6
 2006-02-06 17:43 .git/refs/bisect/good-54e08a2392e99ba9e48ce1060e0b52a39118419c
 2006-02-06 19:52 .git/refs/bisect/bad
 2006-02-06 21:57 .git/refs/bisect/good-4a4efbdee278b2f4ed91aad2db5c006ff754276e

    142 Starting Linux PPC64 #23 SMP Sun Feb 5 14:14:14 CET 2006  good
     96 Starting Linux PPC64 #24 SMP Sun Feb 5 16:48:11 CET 2006  bad
    234 Starting Linux PPC64 #25 SMP Sun Feb 5 18:21:23 CET 2006  bad
    744 Starting Linux PPC64 #26 SMP Sun Feb 5 21:32:57 CET 2006  good
    270 Starting Linux PPC64 #27 SMP Mon Feb 6 07:10:00 CET 2006  good
    298 Starting Linux PPC64 #28 SMP Mon Feb 6 10:42:03 CET 2006  good
    234 Starting Linux PPC64 #29 SMP Mon Feb 6 14:43:20 CET 2006  good
     54 Starting Linux PPC64 #30 SMP Mon Feb 6 17:50:49 CET 2006  good ?
     18 Starting Linux PPC64 #31 SMP Mon Feb 6 18:56:07 CET 2006
    154 Starting Linux PPC64 #32 SMP Mon Feb 6 19:56:10 CET 2006  bad
     50 Starting Linux PPC64 #33 SMP Mon Feb 6 22:03:54 CET 2006  still going
     ^^ #boots / 2

One of the good ones did not reproduce within 370 reboots. Usually,
it crashes in less than 80.
Looking back through the git-commit mails, I'm past a huge pile of
unrelated network driver changes. Will continue with git-bisect.

-- 
short story of a lazy sysadmin:
 alias appserv=wotan

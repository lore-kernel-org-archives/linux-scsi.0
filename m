From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13311] mptsas: ioc0: removing ssp device, kernel oops
Date: Tue, 9 Jun 2009 21:53:10 GMT
Message-ID: <200906092153.n59LrABk017355@demeter.kernel.org>
References: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:56661 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbZFIVxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:53:07 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n59LrAtC017356
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2009 21:53:10 GMT
In-Reply-To: <bug-13311-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13311





--- Comment #5 from Andrew Morton <akpm@linux-foundation.org>  2009-06-09 21:53:09 ---
On Tue, 9 Jun 2009 15:27:05 -0600
Mike Loseke <mike.tummy@gmail.com> wrote:

> On Thu, May 28, 2009 at 2:00 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > (switched to email. __Please respond via emailed reply-to-all, not via the
> > bugzilla web interface).
> >
> > On Thu, 14 May 2009 18:17:10 GMT bugzilla-daemon@bugzilla.kernel.org wrote:
> >
> > > http://bugzilla.kernel.org/show_bug.cgi?id=13311
> > >
> > > __ __ __ __ __ __Summary: mptsas: ioc0: removing ssp device, kernel oops
> >
> > I'd have thought that the severity of this problem is not matched by
> > the response.
> >
> > > __ __ __ __ __ __Product: SCSI Drivers
> > > __ __ __ __ __ __Version: 2.5
> > > __ __ Kernel Version: 2.6.27.21
> >
> > Is it reproducible? __If so, is there any change that it can be retested
> > under a 2.6.29-based kernel?
> 
> We've put a 2.6.29 kernel on these two systems and experienced another
> kernel oops yesterday.  So far, we haven't been able to reproduce it
> on demand, but it has occurred under a heavier system load each time
> (load average of 16 with 2,000 blocks/sec every 5 seconds writes to
> the devices attached using the mptsas driver.
> 
> The oops from yesterday isn't identical to the previous oops, but the
> end result is the same where the system has to be rebooted.  I've
> attached that the log capture of the oops.
> 
> The system is identical to the original specs, just the kernel has changed:
> 
> # cat /proc/version
> Linux version 2.6.29.4-0.1-default (root@tile01-primary) (gcc version
> 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue May
> 26 22:50:58 CDT 2009
> 
> Hopefully this is helpful.
> 

So we have two issues here.  One is the IO errors - are they unexpected?

The other of course is that mptscsih_bus_reset() oopsed when trying to
handle those errors.


> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Unhandled error code
> Jun  8 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> Jun  8 17:06:10 tile01-secondary kernel: end_request: I/O error, dev sda, sector 207
> Jun  8 17:06:10 tile01-secondary kernel: device-mapper: multipath: Failing path 8:0.
> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Unhandled error code
> Jun  8 17:06:10 tile01-secondary kernel: sd 2:0:0:0: [sda] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> Jun  8 17:06:10 tile01-secondary kernel: end_request: I/O error, dev sda, sector 65679
> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:10 tile01-secondary kernel: mptbase: ioc0: LogInfo(0x31140000): Originator={PL}, Code={IO Executed}, SubCode(0x0000)
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attempting task abort! (sc=ffff88021e08e880)
> Jun  8 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 f0 87 00 04 00 00
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff88021e08e880)
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attempting task abort! (sc=ffff880106684dc0)
> Jun  8 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 f4 87 00 04 00 00
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff880106684dc0)
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8803b0a131c0)
> Jun  8 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 f8 87 00 04 00 00
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8803b0a131c0)
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8803b0a13ec0)
> Jun  8 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 fc 87 00 00 08 00
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8803b0a13ec0)
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attempting task abort! (sc=ffff8803b0a13cc0)
> Jun  8 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 fc 8f 00 04 00 00
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: task abort: SUCCESS (sc=ffff8803b0a13cc0)
> Jun  8 17:06:11 tile01-secondary kernel: mptscsih: ioc0: attempting bus reset! (sc=ffff88021e08e880)
> Jun  8 17:06:11 tile01-secondary kernel: scsi 2:0:0:0: [sda] CDB: Write(10): 2a 00 00 00 f0 87 00 04 00 00
> Jun  8 17:06:11 tile01-secondary kernel: BUG: unable to handle kernel NULL pointer dereference at (null)
> Jun  8 17:06:11 tile01-secondary kernel: IP: [<ffffffffa008cc98>] mptscsih_bus_reset+0x97/0xfa [mptscsih]
> Jun  8 17:06:11 tile01-secondary kernel: PGD 82944c067 PUD 82e4e9067 PMD 0 
> Jun  8 17:06:11 tile01-secondary kernel: Oops: 0000 [#1] SMP 
> Jun  8 17:06:11 tile01-secondary kernel: last sysfs file: /sys/kernel/uevent_seqnum
> Jun  8 17:06:11 tile01-secondary kernel: CPU 1 
> Jun  8 17:06:11 tile01-secondary kernel: Modules linked in: reiserfs dm_round_robin ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter dm_multipath scsi_dh ip_tables iscsi_trgt crc32c x_tables 8021q garp stp bonding ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 ext3 jbd mbcache loop dm_mod qla4xxx scsi_transport_iscsi qla3xxx rtc_cmos i2c_nforce2 rtc_core rtc_lib shpchp forcedeth pcspkr joydev serio_raw mptctl pci_hotplug i2c_core button sr_mod sg cdrom usbhid hid ohci_hcd ehci_hcd sd_mod crc_t10dif usbcore edd xfs exportfs fan 3w_9xxx ide_pci_generic amd74xx ide_core ata_generic thermal processor thermal_sys hwmon sata_nv mptsas mptscsih mptbase scsi_transport_sas pata_amd libata scsi_mod
> Jun  8 17:06:11 tile01-secondary kernel: Pid: 175, comm: scsi_eh_2 Not tainted 2.6.29.4-0.1-default #1 H8DM3-2
> Jun  8 17:06:11 tile01-secondary kernel: RIP: 0010:[<ffffffffa008cc98>]  [<ffffffffa008cc98>] mptscsih_bus_reset+0x97/0xfa [mptscsih]
> Jun  8 17:06:11 tile01-secondary kernel: RSP: 0018:ffff88083354ddb0  EFLAGS: 00010203
> Jun  8 17:06:11 tile01-secondary kernel: RAX: ffff8804359cb002 RBX: ffff88043368a560 RCX: ffff88021e08e880
> Jun  8 17:06:11 tile01-secondary kernel: RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff88043368a560
> Jun  8 17:06:11 tile01-secondary kernel: RBP: ffff88083354dde0 R08: 0000000000000002 R09: 0000000000000000
> Jun  8 17:06:11 tile01-secondary kernel: R10: ffffffff80d7e600 R11: 0000000000000010 R12: ffff88021e08e880
> Jun  8 17:06:11 tile01-secondary kernel: R13: ffff8804335a3000 R14: ffff8804335a3008 R15: ffff88083354dee0
> Jun  8 17:06:11 tile01-secondary kernel: FS:  00007f66c7122740(0000) GS:ffff88043596edc0(0000) knlGS:0000000000000000
> Jun  8 17:06:11 tile01-secondary kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> Jun  8 17:06:11 tile01-secondary kernel: CR2: 0000000000000000 CR3: 000000082d955000 CR4: 00000000000006e0
> Jun  8 17:06:11 tile01-secondary kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Jun  8 17:06:11 tile01-secondary kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Jun  8 17:06:11 tile01-secondary kernel: Process scsi_eh_2 (pid: 175, threadinfo ffff88083354c000, task ffff8808331082c0)
> Jun  8 17:06:11 tile01-secondary kernel: Stack:
> Jun  8 17:06:11 tile01-secondary kernel:  ffff8804337b4810 0000000000000000 ffff88021e08e880 0000000000002003
> Jun  8 17:06:11 tile01-secondary kernel:  ffff8804359cb000 0000000000000000 ffff88083354de00 ffffffffa00034ee
> Jun  8 17:06:11 tile01-secondary kernel:  ffff88021e08e880 0000000000000000 ffff88083354de60 ffffffffa000441f
> Jun  8 17:06:11 tile01-secondary kernel: Call Trace:
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffffa00034ee>] scsi_try_bus_reset+0x52/0xde [scsi_mod]
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffffa000441f>] scsi_eh_ready_devs+0x4c3/0x737 [scsi_mod]
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffffa0004bfe>] scsi_error_handler+0x37d/0x51b [scsi_mod]
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffff8022f2ea>] ? __wake_up_common+0x46/0x76
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffffa0004881>] ? scsi_error_handler+0x0/0x51b [scsi_mod]
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffff80251952>] kthread+0x49/0x76
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffff8020d03a>] child_rip+0xa/0x20
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffff80251909>] ? kthread+0x0/0x76
> Jun  8 17:06:11 tile01-secondary kernel:  [<ffffffff8020d030>] ? child_rip+0x0/0x20
> Jun  8 17:06:11 tile01-secondary kernel: Code: 00 48 83 f8 ff 74 0a 48 ff c0 48 89 83 b0 00 00 00 49 8b 04 24 48 89 df be 04 00 00 00 48 8b 90 88 00 00 00 41 8a 85 98 00 00 00 <48> 8b 12 3c 01 19 c0 45 31 c9 45 31 c0 83 e0 1e 31 c9 0f b6 52 
> Jun  8 17:06:11 tile01-secondary kernel: RIP  [<ffffffffa008cc98>] mptscsih_bus_reset+0x97/0xfa [mptscsih]
> Jun  8 17:06:11 tile01-secondary kernel:  RSP <ffff88083354ddb0>
> Jun  8 17:06:11 tile01-secondary kernel: CR2: 0000000000000000
> Jun  8 17:06:11 tile01-secondary kernel: ---[ end trace 54f83dcc0f7b0b26 ]---
> 
>

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

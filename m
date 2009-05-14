From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13311] New: mptsas: ioc0: removing ssp device, kernel oops
Date: Thu, 14 May 2009 18:17:10 GMT
Message-ID: <bug-13311-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49417 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZENSRJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2009 14:17:09 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4EIHAlf020878
	for <linux-scsi@vger.kernel.org>; Thu, 14 May 2009 18:17:10 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13311

           Summary: mptsas: ioc0: removing ssp device, kernel oops
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.27.21
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
        AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
        ReportedBy: mike.tummy@gmail.com
        Regression: No


Created an attachment (id=21358)
 --> (http://bugzilla.kernel.org/attachment.cgi?id=21358)
System information

Distribution: openSUSE 11.1 (x86_64)

SCSI storage controller: LSI Logic / Symbios Logic SAS1068E PCI-Express 
Fusion-MPT SAS (rev 08)

This system had a kernel oops with the mptsas driver, the result of which
caused the port to be detached.  This removed the disks from the system causing
processes like hald and umount to permanently block.

I've attached the system information.

Here are the syslog messages for the oops:
------------------------>8 Cut Here 8<------------------------
May 12 05:19:59 tile01-primary kernel: mptsas: ioc0: removing ssp device:
fw_channel 0, fw_id 9, phy 8, sas_addr 0x5000155356664400
May 12 05:19:59 tile01-primary kernel:  phy-6:0:16: mptsas: ioc0: delete phy 8,
phy-obj (0xffff8804367ed400)
May 12 05:19:59 tile01-primary kernel:  phy-6:0:17: mptsas: ioc0: delete phy 9,
phy-obj (0xffff8804367f0400)
May 12 05:19:59 tile01-primary kernel:  phy-6:0:18: mptsas: ioc0: delete phy
10, phy-obj (0xffff8804367f0c00)
May 12 05:19:59 tile01-primary kernel:  phy-6:0:19: mptsas: ioc0: delete phy
11, phy-obj (0xffff8804367f4400)
May 12 05:19:59 tile01-primary kernel:  port-6:0:1: mptsas: ioc0: delete port
1, sas_addr (0x5000155356664400)
May 12 05:19:59 tile01-primary kernel: end_request: I/O error, dev sdc, sector
10975
May 12 05:19:59 tile01-primary kernel: REISERFS abort (device sdc1): Journal
write error in flush_commit_list
May 12 05:20:20 tile01-primary kernel: mptsas: ioc0: removing ssp device:
fw_channel 0, fw_id 9, phy 9, sas_addr 0x5000155356664400
May 12 05:20:20 tile01-primary kernel:  phy-6:0:16: mptsas: ioc0: delete phy 8,
phy-obj (0xffff8804367ed400)
May 12 05:20:20 tile01-primary kernel:  phy-6:0:17: mptsas: ioc0: delete phy 9,
phy-obj (0xffff8804367f0400)
May 12 05:20:20 tile01-primary kernel:  phy-6:0:18: mptsas: ioc0: delete phy
10, phy-obj (0xffff8804367f0c00)
May 12 05:20:20 tile01-primary kernel:  phy-6:0:19: mptsas: ioc0: delete phy
11, phy-obj (0xffff8804367f4400)
May 12 05:20:20 tile01-primary kernel:  port-6:0:1: mptsas: ioc0: delete port
1, sas_addr (0x5000155356664400)
May 12 05:20:20 tile01-primary kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000028
May 12 05:20:20 tile01-primary kernel: IP: [<ffffffff802fe7c2>]
sysfs_find_dirent+0x9/0x2f
May 12 05:20:20 tile01-primary kernel: PGD 8350bd067 PUD 831964067 PMD 0 
May 12 05:20:20 tile01-primary kernel: Oops: 0000 [1] SMP 
May 12 05:20:20 tile01-primary kernel: last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
May 12 05:20:20 tile01-primary kernel: CPU 5 
May 12 05:20:20 tile01-primary kernel: Modules linked in: reiserfs ip6t_LOG
xt_tcpudp xt_pkttype ipt_LOG xt_limit 8021q garp stp bonding ip6t_REJECT
nf_conntrack_ipv6 
ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack
ip_tables ip6table_filter
 ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_userspace
cpufreq_powersave powernow_k8 ext3 jbd mbcache loop dm_mod cfi_cmdset_0002(N)
cfi_util(N) jedec_probe(
N) cfi_probe(N) gen_probe(N) ck804xrom(N) mtd sr_mod qla3xxx rtc_cmos joydev
button i2c_nforce2 shpchp cdrom forcedeth rtc_core chipreg(N) mptctl i2c_core
map_funcs(N)
 pcspkr rtc_lib sg pci_hotplug usbhid hid ff_memless ohci_hcd ehci_hcd sd_mod
crc_t10dif usbcore qla4xxx scsi_transport_iscsi edd xfs fan 3w_9xxx
ide_pci_generic amd74
xx ide_core ata_generic pata_amd mptsas mptscsih mptbase scsi_transport_sas
sata_nv libata scsi_mod dock thermal processor thermal_sys hwmon [last
unloaded: libcrc32c]
May 12 05:20:20 tile01-primary kernel: Supported: No
May 12 05:20:20 tile01-primary kernel: Pid: 210, comm: mpt/0 Tainted: G        
 2.6.27.21-0.1-default #1
May 12 05:20:20 tile01-primary kernel: RIP: 0010:[<ffffffff802fe7c2>] 
[<ffffffff802fe7c2>] sysfs_find_dirent+0x9/0x2f
May 12 05:20:20 tile01-primary kernel: RSP: 0018:ffff880434479c00  EFLAGS:
00010286
May 12 05:20:20 tile01-primary kernel: RAX: ffff8804367edda8 RBX:
ffffffff805b9885 RCX: ffff8804367edda8
May 12 05:20:20 tile01-primary kernel: RDX: ffff8804367edda8 RSI:
ffffffff805b9885 RDI: 0000000000000000
May 12 05:20:20 tile01-primary kernel: RBP: ffffffff805b9885 R08:
ffff880400000030 R09: ffff880400000030
May 12 05:20:20 tile01-primary kernel: R10: 0000000000000010 R11:
0000000000018620 R12: 0000000000000000
May 12 05:20:20 tile01-primary kernel: R13: ffff8804367edcf0 R14:
ffff8804367edcf0 R15: ffff8804367ede60
May 12 05:20:20 tile01-primary kernel: FS:  00007f9eb74ce6f0(0000)
GS:ffff88083657c2c0(0000) knlGS:0000000000000000
May 12 05:20:20 tile01-primary kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
May 12 05:20:20 tile01-primary kernel: CR2: 0000000000000028 CR3:
0000000834c1d000 CR4: 00000000000006e0
May 12 05:20:20 tile01-primary kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
May 12 05:20:20 tile01-primary kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
May 12 05:20:20 tile01-primary kernel: Process mpt/0 (pid: 210, threadinfo
ffff880434478000, task ffff880434f0e3c0)
May 12 05:20:20 tile01-primary kernel: Stack:  ffff880434479c40
ffffffff805b9885 0000000000000000 ffffffff802fe8be
May 12 05:20:20 tile01-primary kernel:  ffff8804365278a0 ffff8804367edc00
ffffffff807032a0 ffffffff802ffd64
May 12 05:20:20 tile01-primary kernel:  ffff880436527778 ffff8804367edc00
ffff8804367edc00 ffff880435cc0038
May 12 05:20:20 tile01-primary kernel: Call Trace:
May 12 05:20:20 tile01-primary kernel:  [<ffffffff802fe8be>]
sysfs_get_dirent+0x24/0x59
May 12 05:20:20 tile01-primary kernel:  [<ffffffff802ffd64>]
sysfs_remove_group+0x24/0xce
May 12 05:20:20 tile01-primary kernel:  [<ffffffff803e3b07>]
device_del+0x1b/0x1ad
May 12 05:20:20 tile01-primary kernel:  [<ffffffffa008591d>]
sas_port_delete+0x10d/0x129 [scsi_transport_sas]
May 12 05:20:20 tile01-primary kernel:  [<ffffffffa00b3a6a>]
mptsas_delete_expander_siblings+0x3f/0xb5 [mptsas]
May 12 05:20:20 tile01-primary kernel:  [<ffffffffa00b38d2>]
mptsas_expander_delete+0xb6/0x20f [mptsas]
May 12 05:20:20 tile01-primary kernel:  [<ffffffffa00b3b8e>]
mptsas_send_expander_event+0xae/0xc2 [mptsas]
May 12 05:20:20 tile01-primary kernel:  [<ffffffffa00b5fd4>]
mptsas_firmware_event_work+0x1dc/0x200 [mptsas]
May 12 05:20:20 tile01-primary kernel:  [<ffffffff8024c88d>]
run_workqueue+0x7a/0x100
May 12 05:20:20 tile01-primary kernel:  [<ffffffff8024c9eb>]
worker_thread+0xd8/0xe7
May 12 05:20:20 tile01-primary kernel:  [<ffffffff8024f9e7>] kthread+0x47/0x73
May 12 05:20:20 tile01-primary kernel:  [<ffffffff8020cf79>] child_rip+0xa/0x11
May 12 05:20:20 tile01-primary kernel: 
May 12 05:20:20 tile01-primary kernel: 
May 12 05:20:20 tile01-primary kernel: Code: c7 10 0d 6f 80 e8 bf c8 19 00 5a
5b 5d 41 5c 41 5d 41 5e 31 c0 41 5f c3 48 c7 45 38 ff ff ff 7f eb dc 55 48 89
f5 53 48 83
 ec 08 <48> 8b 5f 28 eb 14 48 8b 7b 18 48 89 ee e8 50 52 06 00 85 c0 74 
May 12 05:20:20 tile01-primary kernel: RIP  [<ffffffff802fe7c2>]
sysfs_find_dirent+0x9/0x2f
May 12 05:20:20 tile01-primary kernel:  RSP <ffff880434479c00>
May 12 05:20:20 tile01-primary kernel: CR2: 0000000000000028
------------------------>8 Cut Here 8<------------------------

The system needed a reset to recover due to so many processes blocking trying
to access the devices and related processes.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.

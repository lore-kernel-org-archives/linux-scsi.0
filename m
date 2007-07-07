From: Alex Winawer <alex.winawer@oucs.ox.ac.uk>
Subject: Problem: NULL pointer dereference when disconnecting SAS expander-expander link
Date: Sat, 7 Jul 2007 18:08:27 +0100
Message-ID: <200707071808.28012.alex.winawer@oucs.ox.ac.uk>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Mi8jGJiyB4hCnR6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sysdev.oucs.ox.ac.uk ([163.1.2.12]:50125 "EHLO
	sysdev.oucs.ox.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbXGGR3l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jul 2007 13:29:41 -0400
Received: from serious-callers-only.oucs.ox.ac.uk (serious-callers-only.oucs.ox.ac.uk [129.67.100.44])
	by sysdev.oucs.ox.ac.uk (Postfix) with ESMTP id D0FC9B904D
	for <linux-scsi@vger.kernel.org>; Sat,  7 Jul 2007 18:08:28 +0100 (BST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Boundary-00=_Mi8jGJiyB4hCnR6
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

While testing some new SAS hardware, I have encountered an issue that results 
in an "Unable to handle kernel NULL pointer dereference" message from the 
kernel. The stack trace taken from syslog output is attached.

The problem occurs when connecting then disconnecting an external cable 
between two JBOD disk boxes. The problem does not seem to occur when 
connecting and disconnecting a single disk box directly to the HBA.

To reproduce:
1. Boot with the hardware connected as pictured below. All 32 external disks
   are found and no problems are noticed.
2. Disconnect cable B. The 16 disks and enclosure target from disk box 2 are
   removed with no errors noticed. There are some 'failed to synchronize
   cache' messages if the disks are not removed through /sys first but the
   the error will occur either way.
3. Reconnect cable B. No indications that anything has happened from the OS. I 
   have tried waiting for over 2 minutes after connecting the cable.
4. Disconnect cable B again and the attached messages are logged. A hard reset
   is then required to recover.

+---Host w/LSI3801E HBA------------+
|  LSI1068E                        |
+-####-####------------------------+
  ||||     < Cable A
+-####--Disk box 1-----------------+
| ||||                             |
| LSISASx12A                       |
| ||||  ||\`== LSISASx12A < 8 HDDs |
| ||||  ||                         |
| ||||  \`==== LSISASx12A < 8 HDDs |
+-####-----------------------------+
  ||||     < Cable B
+-####--Disk box 2-----------------+
| ||||                             |
| LSISASx12A                       |
| ||||  ||\`== LSISASx12A < 8 HDDs |
| ||||  ||                         |
| ||||  \`==== LSISASx12A < 8 HDDs |
+-####-----------------------------+


For the attached error, the disk boxes were full of SATA disks and the system 
was running the Debian backports.org 2.6.21-1-amd64 (2.6.21-4~bpo.1) kernel. 
The problem also seems to exist with the Debian etch 2.6.18-4-amd64 kernel. 
Happy to try any kernel versions and configs that would be useful.

The diagram represents my current understanding of the expander setup in the 
disk boxes but I could be mistaken. I can provide further details of the view 
of the hardware from the host if it is of interest.

The server also has an on-board LSI1064 connected to 4 internal SAS HDDs:
$ cat /proc/mpt/summary
ioc0: LSISAS1068E, FwRev=01120000h, Ports=1, MaxQ=511, IRQ=19
ioc1: LSISAS1064, FwRev=01102800h, Ports=1, MaxQ=511, IRQ=58

I will continue to investigate and will report any findings but any help in 
resolving the issue would be greatly appreciated.

-- 
Alex Winawer, Unix Systems Programmer
Systems Development & Support, Oxford University Computing Services

--Boundary-00=_Mi8jGJiyB4hCnR6
Content-Type: text/plain;
  charset="us-ascii";
  name="syslog_extract"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="syslog_extract"

Jul  6 09:46:05 just-read-the-instructions kernel: mptbase: ioc0: LogInfo(0=
x30050000): Originator=3D{IOP}, Code=3D{Task Terminated}, SubCode(0x0000)
Jul  6 09:48:09 just-read-the-instructions kernel: Unable to handle kernel =
NULL pointer dereference at 00000000000002c0 RIP:=20
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff8025a762>] mu=
tex_lock+0x0/0xb
Jul  6 09:48:09 just-read-the-instructions kernel: PGD 10ce07067 PUD 10ea3e=
067 PMD 0=20
Jul  6 09:48:09 just-read-the-instructions kernel: Oops: 0002 [1] SMP=20
Jul  6 09:48:09 just-read-the-instructions kernel: CPU 0=20
Jul  6 09:48:09 just-read-the-instructions kernel: Modules linked in: raid4=
56 xor ipv6 iptable_mangle iptable_nat nf_nat xt_tcpudp nf_conntrack_ipv4 x=
t_state nf_conntrack nfnetlink ipt_owner ipt_REJECT xt_limit ipt_LOG xt_has=
hlimit ip6_tables ipt_addrtype iptable_filter ip_tables x_tables 8021q seri=
o_raw psmouse i2c_nforce2 shpchp i2c_core pci_hotplug pcspkr k8temp sg sr_m=
od cdrom joydev evdev ext3 jbd mbcache dm_mirror dm_snapshot dm_mod raid1 m=
d_mod ide_generic ata_generic sata_nv libata sd_mod generic usb_storage usb=
hid hid mptsas mptscsih mptbase scsi_transport_sas amd74xx e1000 scsi_mod f=
orcedeth ide_core ohci_hcd ehci_hcd thermal processor fan
Jul  6 09:48:09 just-read-the-instructions kernel: Pid: 14, comm: events/0 =
Not tainted 2.6.21-1-amd64 #1
Jul  6 09:48:09 just-read-the-instructions kernel: RIP: 0010:[<ffffffff8025=
a762>]  [<ffffffff8025a762>] mutex_lock+0x0/0xb
Jul  6 09:48:09 just-read-the-instructions kernel: RSP: 0018:ffff810120201c=
88  EFLAGS: 00010246
Jul  6 09:48:09 just-read-the-instructions kernel: RAX: 0000000000000000 RB=
X: ffff81011b1f3000 RCX: 0000000000000000
Jul  6 09:48:09 just-read-the-instructions kernel: RDX: ffff81011a9784c0 RS=
I: ffff81011b1f3000 RDI: 00000000000002c0
Jul  6 09:48:09 just-read-the-instructions kernel: RBP: 0000000000000004 R0=
8: 000000000000000c R09: ffff81011b3392a0
Jul  6 09:48:09 just-read-the-instructions kernel: R10: 00000000fffffff4 R1=
1: ffff810120201ca8 R12: 0000000000000000
Jul  6 09:48:09 just-read-the-instructions kernel: R13: 00000000000002c0 R1=
4: 0000000000000000 R15: 00000000000005b0
Jul  6 09:48:09 just-read-the-instructions kernel: FS:  00002b86508c56d0(00=
00) GS:ffffffff804d9000(0000) knlGS:0000000000000000
Jul  6 09:48:09 just-read-the-instructions kernel: CS:  0010 DS: 0018 ES: 0=
018 CR0: 000000008005003b
Jul  6 09:48:09 just-read-the-instructions kernel: CR2: 00000000000002c0 CR=
3: 0000000101c9e000 CR4: 00000000000006e0
Jul  6 09:48:09 just-read-the-instructions kernel: Process events/0 (pid: 1=
4, threadinfo ffff810120200000, task ffff81011c0d2100)
Jul  6 09:48:09 just-read-the-instructions kernel: Stack:  ffffffff880b8cca=
 ffff81011bcb29c0 ffff81011bc8a000 ffff81011ad99d80
Jul  6 09:48:09 just-read-the-instructions kernel:  ffffffff880dc789 ffff81=
011bc8a5e8 ffff810120201cb8 ffff810120201cb8
Jul  6 09:48:09 just-read-the-instructions kernel:  0000000000000000 000000=
0000000000 ffff81011bc8a000 ffff81011ad99d80
Jul  6 09:48:09 just-read-the-instructions kernel: Call Trace:
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880b8cca>] :s=
csi_transport_sas:sas_port_delete_phy+0x1a/0x5e
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880dc789>] :m=
ptsas:mptsas_setup_wide_ports+0x72/0x20d
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880dd097>] :m=
ptsas:mptsas_probe_expander_phys+0x3d0/0x427
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880c7265>] :m=
ptbase:mpt_timer_expired+0x0/0x24
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880dd969>] :m=
ptsas:__mptsas_discovery_work+0x16f/0x18a
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880dd984>] :m=
ptsas:mptsas_discovery_work+0x0/0x39
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff880dd9a8>] :m=
ptsas:mptsas_discovery_work+0x24/0x39
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff80246fa3>] ru=
n_workqueue+0x8f/0x137
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff80243bcf>] wo=
rker_thread+0x0/0x14a
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff80243ce3>] wo=
rker_thread+0x114/0x14a
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff8027a990>] de=
fault_wake_function+0x0/0xe
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff8022f236>] kt=
hread+0xd1/0x100
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff80255f38>] ch=
ild_rip+0xa/0x12
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff8022f165>] kt=
hread+0x0/0x100
Jul  6 09:48:09 just-read-the-instructions kernel:  [<ffffffff80255f2e>] ch=
ild_rip+0x0/0x12
Jul  6 09:48:09 just-read-the-instructions kernel:=20
Jul  6 09:48:09 just-read-the-instructions kernel:=20
Jul  6 09:48:09 just-read-the-instructions kernel: Code: f0 ff 0f 79 05 e8 =
27 01 00 00 c3 f0 ff 07 7f 05 e8 e9 00 00=20
Jul  6 09:48:09 just-read-the-instructions kernel: RIP  [<ffffffff8025a762>=
] mutex_lock+0x0/0xb
Jul  6 09:48:09 just-read-the-instructions kernel:  RSP <ffff810120201c88>
Jul  6 09:48:09 just-read-the-instructions kernel: CR2: 00000000000002c0

--Boundary-00=_Mi8jGJiyB4hCnR6--

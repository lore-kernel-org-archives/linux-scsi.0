From: Daniel Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: scsi_host_alloc does not check for used shost->host_no
Date: Tue, 15 Jul 2008 18:39:48 -0300
Message-ID: <487D1924.7070502@linux.vnet.ibm.com>
References: <48775DCD.5010202@linux.vnet.ibm.com> <487D059C.60400@linux.vnet.ibm.com> <20080715202507.GI14894@parisc-linux.org> <1216154055.3312.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from igw1.br.ibm.com ([32.104.18.24]:41167 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbYGOVk4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 17:40:56 -0400
Received: from mailhub3.br.ibm.com (mailhub3 [9.18.232.110])
	by igw1.br.ibm.com (Postfix) with ESMTP id EBCF532C1B9
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 18:13:18 -0300 (BRT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.18.232.46])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m6FLeYvg2637988
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 18:40:40 -0300
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FLeTQP028186
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 18:40:29 -0300
In-Reply-To: <1216154055.3312.129.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Tue, 2008-07-15 at 14:25 -0600, Matthew Wilcox wrote:
>>> Do we need to worry about a host in the SHOST_DEL state? In that case, it will still
>>> exist to some degree, but scsi_host_get will fail. For example, what happens if a
>>> shell is in /sys/class/scsi_host/host5/ and you delete host 5 and try to add another.
>>> Couldn't you run into the same problem? In that case the scsi_host_get will fail.
>>> I suppose you could check specifically for -ENXIO getting returned...
>> Or we could make the host_no a u64 and avoid the problem ever happening
>> in our lifetimes.  I'm amazed that anyone's had the time to do 4 billion
>> add/removes, to be honest.  Assuming it takes 1 second per add/remove
>> cycle, and there's not even time to scan a bus in that time, that's
>> still 136 years.
> 
> Actually, right at the moment, a lot of the udev stuff is conditioned on
> a non repeating host number (which is why we don't use idr like we do
> for the other things).  I'm really reluctant to go to a u64 host
> number ... what was the use case that produced this problem?
> 
> James

All of it started in some functional tests against pata_pdc2027x module 
which includes some rmmod/modprobe (around 10000). Before I start to 
work on it, this functional test started to fail, sometimes with at 
different points.

Just to make clear, I am adding some kernel messages and mon info to 
help some additional comments.

We can see that on the first and Third times (on rmmod) a panic happened 
far to the short int border (around 19741 and 9887). On the Second we 
can see that it happens on modprobe when going from 65355 to 0. This 
pointed me to the patch I summited and which I used to check if all of 
it would be "fixed". After that patch (I know it is far away from a good 
patch) I got this rmmod/modprobe loop running for more then 4 days with 
no kernel panic. It made me believe that somehow it avoids the First and 
Third panics to happen.

I am pretty knew to this peaces of code and I probably don't have a full 
overview of it. That is way I would like to have your input and opinions.

I really appreciate that.
Daniel Debonzi

First occurrence:
**********************************************
    Vendor: IBM       Model: DROM00205         Rev: NR36
   Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 61x/61x cd/rw xa/form2 cdda tray
sr 19740:0:0:0: Attached scsi generic sg4 type 5
ata19739.00: disabled
   Vendor: IBM       Model: DROM00205         Rev: NR36
   Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 61x/61x cd/rw xa/form2 cdda tray
sr 19742:0:0:0: Attached scsi generic sg4 type 5
ata19741.00: disabled
Unable to handle kernel paging request for data at address 
0xd0000000008c3e98
Faulting instruction address: 0xd0000000001db250
cpu 0x3: Vector: 300 (Data Access) at [c0000000391173c0]
     pc: d0000000001db250: .scsi_target_reap_usercontext+0x90/0x114 
[scsi_mod]
     lr: d0000000001db244: .scsi_target_reap_usercontext+0x84/0x114 
[scsi_mod]
     sp: c000000039117640
    msr: 8000000000001032
    dar: d0000000008c3e98
  dsisr: 40000000
   current = 0xc00000007182dc60
   paca    = 0xc000000000475400
     pid   = 535, comm = udevd


3:mon> t
[c0000000391176e0] c00000000007f35c .execute_in_process_context+0x54/0xa0
[c000000039117760] d0000000001da190 .scsi_target_reap+0xc8/0x100 [scsi_mod]
[c0000000391177f0] d0000000001db5c8 
.scsi_device_dev_release_usercontext+0xc8/0x
120 [scsi_mod]
[c0000000391178a0] c00000000007f35c .execute_in_process_context+0x54/0xa0
[c000000039117920] d0000000001db4e8 .scsi_device_dev_release+0x24/0x3c 
[scsi_mod
]
[c0000000391179a0] c00000000022580c .device_release+0x4c/0x78
[c000000039117a20] c0000000001b2388 .kobject_cleanup+0x90/0xf0
[c000000039117ac0] c0000000001b3470 .kref_put+0x84/0xa0
[c000000039117b40] c0000000001b22e0 .kobject_put+0x28/0x40
[c000000039117bc0] c00000000014dbe8 .sysfs_release+0x48/0xe0
[c000000039117c50] c0000000000eca1c .__fput+0x108/0x25c
[c000000039117d00] c0000000000e8fa4 .filp_close+0xac/0xd4
[c000000039117d90] c0000000000eacf4 .sys_close+0xc4/0x110
[c000000039117e30] c0000000000086a4 syscall_exit+0x0/0x40
--- Exception: c00 (System Call) at 0000000007e7d7d0
SP (ff8dc360) is in userspace

**********************************************

Second occurrence:
**********************************************
*  Vendor: IBM       Model: DROM00205         Rev: NR38
   Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
sr 65529:0:0:0: Attached scsi generic sg11 type 5
ata65529.00: disabled
   Vendor: IBM       Model: DROM00205         Rev: NR38
   Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
sr 65531:0:0:0: Attached scsi generic sg11 type 5
ata65531.00: disabled
   Vendor: IBM       Model: DROM00205         Rev: NR38
   Type:   CD-ROM                             ANSI SCSI revision: 02
sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
sr 65533:0:0:0: Attached scsi generic sg11 type 5
ata65533.00: disabled
kobject_add failed for host0 with -EEXIST, don't try to register things 
with the
same name in the same directory.
Call Trace:
[C0000000B565B1A0] [C00000000000FFDC] .show_stack+0x68/0x1b0 (unreliable)
[C0000000B565B240] [C0000000001B28E0] .kobject_add+0x1a4/0x1fc
[C0000000B565B2E0] [C000000000229EE0] .class_device_add+0xb4/0x4e4
[C0000000B565B3B0] [D0000000001D1F2C] .scsi_add_host+0xf8/0x208 [scsi_mod]
[C0000000B565B450] [D00000000052B52C] .ata_scsi_add_hosts+0xa4/0x160 
[libata]
[C0000000B565B500] [D000000000527C0C] .ata_host_register+0xec/0x368 [libata]
[C0000000B565B5D0] [D000000000527F1C] .ata_host_activate+0x94/0xe0 [libata]
[C0000000B565B680] [D0000000007D11B0] .pdc2027x_init_one+0x36c/0x39c 
[pata_pdc2027x]
[C0000000B565B730] [C0000000001C3530] .pci_device_probe+0x13c/0x1dc
[C0000000B565B7F0] [C0000000002287F0] .driver_probe_device+0xa0/0x16c
[C0000000B565B890] [C000000000228A58] .__driver_attach+0xb4/0x138
[C0000000B565B920] [C000000000227F14] .bus_for_each_dev+0x7c/0xd4
[C0000000B565B9E0] [C000000000228694] .driver_attach+0x28/0x40
[C0000000B565BA60] [C00000000022797C] .bus_add_driver+0x98/0x18c
[C0000000B565BB00] [C000000000228E58] .driver_register+0xa8/0xc4
[C0000000B565BB80] [C0000000001C3838] .__pci_register_driver+0x5c/0xa4
[C0000000B565BC10] [D0000000007D14D4] .pdc2027x_init+0x20/0x45c 
[pata_pdc2027x]
[C0000000B565BC90] [C000000000090B50] .sys_init_module+0x1764/0x1998
[C0000000B565BE30] [C0000000000086A4] syscall_exit+0x0/0x40
slab error in kmem_cache_destroy(): cache `scsi_cmd_cache': Can't free 
all objects
Call Trace:
[C0000000B565B070] [C00000000000FFDC] .show_stack+0x68/0x1b0 (unreliable)
[C0000000B565B110] [C0000000000E4020] .kmem_cache_destroy+0x94/0x1b0
[C0000000B565B1A0] [D0000000001D12D8] 
.scsi_destroy_command_freelist+0xa0/0xcc
[scsi_mod]
[C0000000B565B230] [D0000000001D1720] .scsi_host_dev_release+0x80/0xe0 
[scsi_mod]
[C0000000B565B2C0] [C00000000022580C] .device_release+0x4c/0x78
[C0000000B565B340] [C0000000001B2388] .kobject_cleanup+0x90/0xf0
[C0000000B565B3E0] [C0000000001B3470] .kref_put+0x84/0xa0
[C0000000B565B460] [C0000000001B22E0] .kobject_put+0x28/0x40
[C0000000B565B4E0] [C000000000225968] .put_device+0x1c/0x30
[C0000000B565B560] [D0000000001D168C] .scsi_host_put+0x14/0x28 [scsi_mod]
[C0000000B565B5E0] [D000000000528058] .ata_host_release+0xf0/0x14c [libata]
[C0000000B565B680] [C00000000022C720] .release_nodes+0x1c8/0x22c
[C0000000B565B750] [C00000000022CB98] .devres_release_all+0x58/0xd4
[C0000000B565B7F0] [C000000000228860] .driver_probe_device+0x110/0x16c
[C0000000B565B890] [C000000000228A58] .__driver_attach+0xb4/0x138
[C0000000B565B920] [C000000000227F14] .bus_for_each_dev+0x7c/0xd4
[C0000000B565B9E0] [C000000000228694] .driver_attach+0x28/0x40
[C0000000B565BA60] [C00000000022797C] .bus_add_driver+0x98/0x18c
[C0000000B565BB00] [C000000000228E58] .driver_register+0xa8/0xc4
[C0000000B565BB80] [C0000000001C3838] .__pci_register_driver+0x5c/0xa4
[C0000000B565BC10] [D0000000007D14D4] .pdc2027x_init+0x20/0x45c 
[pata_pdc2027x]
[C0000000B565BC90] [C000000000090B50] .sys_init_module+0x1764/0x1998
[C0000000B565BE30] [C0000000000086A4] syscall_exit+0x0/0x40
Unable to handle kernel paging request for data at address 
0x3a30322e332f3040
Faulting instruction address: 0xc0000000000843e4
cpu 0x4: Vector: 300 (Data Access) at [c0000000b565af10]
     pc: c0000000000843e4: .kthread_stop+0x3c/0xfc
     lr: c0000000000843e0: .kthread_stop+0x38/0xfc
     sp: c0000000b565b190
    msr: 8000000000009032
    dar: 3a30322e332f3040
  dsisr: 40000000
   current = 0xc0000000ea1294d0
   paca    = 0xc000000000475600
     pid   = 15221, comm = modprobe
*********************************************



Third occurrence:
**********************************************
  <7>pata_pdc2027x 0001:cc:01.0: version 0.74-ac5
<6>pata_pdc2027x 0001:cc:01.0: PLL input clock 32758 kHz
<6>ata9887: PATA max UDMA/133 cmd 0xD000080084DC07C0 ctl 0xD000080084DC0FDA
bmdma 0xD000080084DC0000 irq 166
<6>ata9888: PATA max UDMA/133 cmd 0xD000080084DC05C0 ctl 0xD000080084DC0DDA
bmdma 0xD000080084DC0008 irq 166
<6>scsi9887 : pata_pdc2027x
<6>ata9887.00: ATAPI, max UDMA/33
<6>ata9887.00: configured for UDMA/33
<6>scsi9888 : pata_pdc2027x
<4>ATA: abnormal status 0x8 on port 0xD000080084DC05DF
<5>  Vendor: IBM       Model: DROM00205         Rev: NR36
<5>  Type:   CD-ROM                             ANSI SCSI revision: 02
<4>sr0: scsi3-mmc drive: 61x/61x cd/rw xa/form2 cdda tray
<7>sr 9887:0:0:0: Attached scsi CD-ROM sr0
<5>sr 9887:0:0:0: Attached scsi generic sg0 type 5
<4>ata9887.00: disabled
<1>Unable to handle kernel paging request for data at address 
0xd000000000047878
<1>Faulting instruction address: 0xd0000000000821f0
cpu 0x1: Vector: 300 (Data Access) at [c000000070f03580]
     pc: d0000000000821f0: 
.scsi_device_dev_release_usercontext+0x40/0x1ac [scsi_mod]
     lr: c000000000077394: .execute_in_process_context+0x54/0xa0
     sp: c000000070f03800
    msr: 8000000000009032
    dar: d000000000047878
  dsisr: 40000000
   current = 0xc000000002cacad0
   paca    = 0xc0000000004a3780
     pid   = 2086, comm = hald


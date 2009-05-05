From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: KVM x86_64 with SR-IOV..? (device passthrough with LIO-Target
	v3.0)
Date: Tue, 05 May 2009 03:43:46 -0700
Message-ID: <1241520226.32740.1051.camel@haakon2.linux-iscsi.org>
References: <1241122974.32740.539.camel@haakon2.linux-iscsi.org>
	 <200905041620.24308.sheng@linux.intel.com>
	 <1241428319.32740.862.camel@haakon2.linux-iscsi.org>
	 <200905041749.29338.sheng@linux.intel.com>
	 <1241433636.32740.879.camel@haakon2.linux-iscsi.org>
	 <20090505014230.GB30419@yzhao-otc.sh.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-2unmVJQnCJrWfY81qS3c"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:48712 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754575AbZEEKnw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 May 2009 06:43:52 -0400
In-Reply-To: <20090505014230.GB30419@yzhao-otc.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yu Zhao <yu.zhao@intel.com>
Cc: Sheng Yang <sheng@linux.intel.com>, kvm-devel <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


--=-2unmVJQnCJrWfY81qS3c
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-05-05 at 09:42 +0800, Yu Zhao wrote:
> Hi,
> 
> The VF also works in the host if the VF driver is programed properly.
> So it would be easier to develop the VF driver in the host and then
> verify the VF driver in the guest.
> 
> BTW, I didn't see the SR-IOV is enabled in your dmesg, did you select
> the CONFIG_PCI_IOV in the kernel .config?
> 
> Thanks,
> Yu
> 

Greetings Yu and Sheng,

So the original attachment was for the v2.6.29-fc11 host kernel output,
I ended up jumping to v2.6.30-rc3 (and making sure CONFIG_PCI_IOV was
enabled) for KVM host with kvm-85 and now things are looking quite
stable for me.

So far I have been able to successfully push LIO-Target v3.0 traffic
*inside* a v2.6.29.2 KVM guest via the onboard e1000e (02:00.0) port
from another Linux/iSCSI Initiator machine using a Intel 1 Gb/sec port.
I am running badblocks tests to iSCSI Logical Units for RAMDISK_DR and
FILEIO storage objects (in the KVM Guest), and they are passing
validation and I am seeing ~500 Mb/sec of throughput and very low CPU
usage in the KVM guests.

One issue I did notice while using the pci-stub method of
device-assignment with same e1000 port (02:00.0) was while using an
iSCSI Initiator (Open-iSCSI) on the KVM Host machine and doing sustained
traffic into the LIO-Target KVM Guest on the same local KVM host to max
out traffic between the other onboard e1000e port (03.00.0), I see the
following:

pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
assign device: host bdf = 2:0:0
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
scsi4 : iSCSI Initiator over TCP/IP
scsi 4:0:0:0: Direct-Access     LIO-ORG  RAMDISK-DR       3.0  PQ: 0 ANSI: 5
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 4:0:0:1: Direct-Access     LIO-ORG  RAMDISK-DR       3.0  PQ: 0 ANSI: 5
sd 4:0:0:1: Attached scsi generic sg2 type 0
sd 4:0:0:0: [sdb] 262144 512-byte hardware sectors: (134 MB/128 MiB)
sd 4:0:0:1: [sdc] 262144 512-byte hardware sectors: (134 MB/128 MiB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 2f 00 00 00
sd 4:0:0:1: [sdc] Write Protect is off
sd 4:0:0:1: [sdc] Mode Sense: 2f 00 00 00
sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:1: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb:<6> sdc: unknown partition table
sd 4:0:0:0: [sdb] Attached SCSI disk
 unknown partition table
sd 4:0:0:1: [sdc] Attached SCSI disk
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:260 enable_irq+0x36/0x50()
Hardware name: empty
Unbalanced enable for IRQ 59
Modules linked in: ipt_REJECT xt_tcpudp bridge stp sunrpc iptable_filter ip_tables xt_state nf_conntrack ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq freq_table ext3 jbd loop dm_multipath scsi_dh kvm_intel kvm uinput i2c_i801 firewire_ohci joydev firewire_core sg i2c_core 8250_pnp crc_itu_t e1000e 8250 serial_core rtc_cmos pcspkr serio_raw rtc_core rtc_lib button sd_mod dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd ohci_hcd ehci_hcd ata_piix libata scsi_mod [last unloaded: microcode]
Pid: 51, comm: events/0 Tainted: G        W  2.6.30-rc3 #11
Call Trace:
 [<ffffffff80235fee>] ? warn_slowpath+0xcb/0xe8
 [<ffffffff80253a7c>] ? generic_exec_single+0x6a/0x88
 [<ffffffff8022acec>] ? update_curr+0x67/0xeb
 [<ffffffffa0198748>] ? vcpu_kick_intr+0x0/0x1 [kvm]
 [<ffffffff8020a5d8>] ? __switch_to+0xb6/0x274
 [<ffffffff8022b70a>] ? __dequeue_entity+0x1b/0x2f
 [<ffffffffa01ac7e4>] ? kvm_irq_delivery_to_apic+0xb3/0xf7 [kvm]
 [<ffffffffa01aa4d4>] ? __apic_accept_irq+0x15a/0x173 [kvm]
 [<ffffffffa01ac883>] ? kvm_set_msi+0x5b/0x60 [kvm]
 [<ffffffff80266d97>] ? enable_irq+0x36/0x50
 [<ffffffffa0195ab5>] ? kvm_assigned_dev_interrupt_work_handler+0x6d/0xbc [kvm]
 [<ffffffff802449fa>] ? worker_thread+0x182/0x223
 [<ffffffff8024820b>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff80244878>] ? worker_thread+0x0/0x223
 [<ffffffff80244878>] ? worker_thread+0x0/0x223
 [<ffffffff80247e72>] ? kthread+0x54/0x7e
 [<ffffffff8020cb0a>] ? child_rip+0xa/0x20
 [<ffffffff804d0af5>] ? _spin_lock+0x5/0x8
 [<ffffffff80247e1e>] ? kthread+0x0/0x7e
 [<ffffffff8020cb00>] ? child_rip+0x0/0x20
---[ end trace 3fbc2dd20bf89ef1 ]---
 connection1:0: ping timeout of 5 secs expired, last rx 4295286327, last ping 4295285518, now 4295286768
 connection1:0: detected conn error (1011)

Attached are the v2.6.30-rc3 KVM host and v2.6.29.2 KVM guest dmesg
output.  When the 'Unbalanced enable for IRQ 59' happens on the KVM
host, I do not see any exceptions in KVM guest (other than the iSCSI
connections drop), but it requires a restart of KVM+qemu-system-x86_64
to get the e1000e port back up.

Other than that loopback scenario, things are looking good quite good
with this combination of kvm-85 kernel+guest so far for me.  I did end
up taking out the two 8x function 2x Path/Function PCIe IOV adapters for
now, as it seemed to have an effect on stability with all of MSI-X
interrupts enabled on the KVM host for 16 virtual adapters.

I will keep testing with e1000e ports and let the list know the
progress.  Thanks for your comments!

--nab

> On Mon, May 04, 2009 at 06:40:36PM +0800, Nicholas A. Bellinger wrote:
> > On Mon, 2009-05-04 at 17:49 +0800, Sheng Yang wrote:
> > > On Monday 04 May 2009 17:11:59 Nicholas A. Bellinger wrote:
> > > > On Mon, 2009-05-04 at 16:20 +0800, Sheng Yang wrote:
> > > > > On Monday 04 May 2009 12:36:04 Nicholas A. Bellinger wrote:
> > > > > > On Mon, 2009-05-04 at 10:09 +0800, Sheng Yang wrote:
> > > > > > > On Monday 04 May 2009 08:53:07 Nicholas A. Bellinger wrote:
> > > > > > > > On Sat, 2009-05-02 at 18:22 +0800, Sheng Yang wrote:
> > > > > > > > > On Thu, Apr 30, 2009 at 01:22:54PM -0700, Nicholas A. Bellinger
> > > wrote:
> > > > > > > > > > Greetings KVM folks,
> > > > > > > > > >
> > > > > > > > > > I wondering if any information exists for doing SR-IOV on the
> > > > > > > > > > new VT-d capable chipsets with KVM..?  From what I understand
> > > > > > > > > > the patches for doing this with KVM are floating around, but I
> > > > > > > > > > have been unable to find any user-level docs for actually
> > > > > > > > > > making it all go against a upstream v2.6.30-rc3 code..
> > > > > > > > > >
> > > > > > > > > > So far I have been doing IOV testing with Xen 3.3 and
> > > > > > > > > > 3.4.0-pre, and I am really hoping to be able to jump to KVM for
> > > > > > > > > > single-function and and then multi-function SR-IOV.  I know
> > > > > > > > > > that the VM migration stuff for IOV in Xen is up and running,
> > > > > > > > > > and I assume it is being worked in for KVM instance migration
> > > > > > > > > > as well..? This part is less important (at least for me :-)
> > > > > > > > > > than getting a stable SR-IOV setup running under the KVM
> > > > > > > > > > hypervisor..  Does anyone have any pointers for this..?
> > > > > > > > > >
> > > > > > > > > > Any comments or suggestions are appreciated!
> > > > > > > > >
> > > > > > > > > Hi Nicholas
> > > > > > > > >
> > > > > > > > > The patches are not floating around now. As you know, SR-IOV for
> > > > > > > > > Linux have been in 2.6.30, so then you can use upstream KVM and
> > > > > > > > > qemu-kvm(or recent released kvm-85) with 2.6.30-rc3 as host
> > > > > > > > > kernel. And some time ago, there are several SRIOV related
> > > > > > > > > patches for qemu-kvm, and now they all have been checked in.
> > > > > > > > >
> > > > > > > > > And for KVM, the extra document is not necessary, for you can
> > > > > > > > > simple assign a VF to guest like any other devices. And how to
> > > > > > > > > create VF is specific for each device driver. So just create a VF
> > > > > > > > > then assign it to KVM guest is fine.
> > > > > > > >
> > > > > > > > Greetings Sheng,
> > > > > > > >
> > > > > > > > So, I have been trying the latest kvm-85 release on a v2.6.30-rc3
> > > > > > > > checkout from linux-2.6.git on a CentOS 5u3 x86_64 install on Intel
> > > > > > > > IOH-5520 based dual socket Nehalem board.  I have enabled DMAR and
> > > > > > > > Interrupt Remapping my KVM host using v2.6.30-rc3 and from what I
> > > > > > > > can tell, the KVM_CAP_* defines from libkvm are enabled with
> > > > > > > > building kvm-85 after './configure
> > > > > > > > --kerneldir=/usr/src/linux-2.6.git' and the PCI passthrough code is
> > > > > > > > being enabled in
> > > > > > > > kvm-85/qemu/hw/device-assignment.c AFAICT..
> > > > > > > >
> > > > > > > > >From there, I use the freshly installed qemu-x86_64-system binary
> > > > > > > > > to
> > > > > > > >
> > > > > > > > start a Debian 5 x86_64 HVM (that previously had been moving
> > > > > > > > network packets under Xen for PCIe passthrough). I see the MSI-X
> > > > > > > > interrupt remapping working on the KVM host for the passed
> > > > > > > > -pcidevice, and the MMIO mappings from the qemu build that I also
> > > > > > > > saw while using Xen/qemu-dm built with PCI passthrough are there as
> > > > > > > > well..
> > > > > > >
> > > > > > > Hi Nicholas
> > > > > > >
> > > > > > > > But while the KVM guest is booting, I see the following
> > > > > > > > exception(s) from qemu-x86_64-system for one of the VFs for a
> > > > > > > > multi-function PCIe device:
> > > > > > > >
> > > > > > > > BUG: kvm_destroy_phys_mem: invalid parameters (slot=-1)
> > > > > > >
> > > > > > > This one is mostly harmless.
> > > > > >
> > > > > > Ok, good to know..  :-)
> > > > > >
> > > > > > > > I try with one of the on-board e1000e ports (02:00.0) and I see the
> > > > > > > > same exception along with some MSI-X exceptions from
> > > > > > > > qemu-x86_64-system in KVM guest.. However, I am still able to see
> > > > > > > > the e1000e and the other vxge multi-function device with lspci, but
> > > > > > > > I am unable to dhcp or ping with the e1000e and VF from
> > > > > > > > multi-function device fails to register the MSI-X interrupt in the
> > > > > > > > guest..
> > > > > > >
> > > > > > > Did you see the interrupt in the guest and host side?
> > > > > >
> > > > > > Ok, I am restarting the e1000e test with a fresh Fedora 11 install and
> > > > > > KVM host kernel 2.6.29.1-111.fc11.x86_64.   After unbinding and
> > > > > > attaching the e1000e single-function device at 02:00.0 to pci-stub
> > > > > > with:
> > > > > >
> > > > > >    echo "8086 10d3" > /sys/bus/pci/drivers/pci-stub/new_id
> > > > > >    echo 0000:02:00.0 > /sys/bus/pci/devices/0000:02:00.0/driver/unbind
> > > > > >    echo 0000:02:00.0 > /sys/bus/pci/drivers/pci-stub/bind
> > > > > >
> > > > > > I see the following the KVM host kernel ring buffer:
> > > > > >
> > > > > >    e1000e 0000:02:00.0: PCI INT A disabled
> > > > > >    pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > > > > >    pci-stub 0000:02:00.0: irq 58 for MSI/MSI-X
> > > > > >
> > > > > > >  I think you can try on-
> > > > > > > board e1000e for MSI-X first. And please ensure correlated driver
> > > > > > > have been loaded correctly.
> > > > > >
> > > > > > <nod>..
> > > > > >
> > > > > > >  And what do you mean by "some MSI-X exceptions"? Better with
> > > > > > > the log.
> > > > > >
> > > > > > Ok, with the Fedora 11 installed qemu-kemu, I see the expected
> > > > > > kvm_destroy_phys_mem() statements:
> > > > > >
> > > > > > #kvm-host qemu-kvm -m 2048 -smp 8 -pcidevice host=02:00.0
> > > > > > lenny64guest1-orig.img BUG: kvm_destroy_phys_mem: invalid parameters
> > > > > > (slot=-1)
> > > > > > BUG: kvm_destroy_phys_mem: invalid parameters (slot=-1)
> > > > > >
> > > > > > However I still see the following in the KVM guest kernel ring buffer
> > > > > > running v2.6.30-rc in the HVM guest.
> > > > > >
> > > > > > [    5.523790] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> > > > > > [    5.524582] e1000e 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10
> > > > > > (level, high) -> IRQ 10 [    5.525710] e1000e 0000:00:05.0: setting
> > > > > > latency timer to 64
> > > > > > [    5.526048] 0000:00:05.0: 0000:00:05.0: Failed to initialize MSI-X
> > > > > > interrupts.  Falling back to MSI interrupts. [    5.527200]
> > > > > > 0000:00:05.0: 0000:00:05.0: Failed to initialize MSI interrupts.
> > > > > > Falling back to legacy interrupts. [    5.829988] 0000:00:05.0: eth0:
> > > > > > (PCI Express:2.5GB/s:Width x1) 00:e0:81:c0:90:b2 [    5.830672]
> > > > > > 0000:00:05.0: eth0: Intel(R) PRO/1000 Network Connection [    5.831240]
> > > > > > 0000:00:05.0: eth0: MAC: 3, PHY: 8, PBA No: ffffff-0ff
> > > > >
> > > > > Hi Nicholas
> > > > >
> > > > > I think something need to be clarify:
> > > > > 1. For SRIOV, you need 2.6.30 as host kernel... But it's better to know
> > > > > if normal device assignment work in your environment at first.
> > > > > 2. The Fedora's userspace is even more old... You'd better try qemu-kvm
> > > > > upstream, which is more convenient for us to track the problem(and kvm-85
> > > > > is also ok). And as you see above, your QEmu don't support MSI/MSIX...
> > > >
> > > > Ok, got it..
> > > >
> > > > > So you can:
> > > > > 1. Use latest qemu-kvm or kvm-85's QEmu. As well as latest KVM.
> > > >
> > > > Ok, I am now updated on in the FC 11 Host with kvm-85 kernel modules and
> > > > am using the built qemu-system-x86_64 from the kvm-85 source package:
> > > >
> > > > loaded kvm module (kvm-85)
> > > > QEMU PC emulator version 0.10.0 (kvm-85), Copyright (c) 2003-2008 Fabrice
> > > > Bellard
> > > >
> > > > > 2. Your host kernel is Fedora 11 Preview, that should be fine with device
> > > > > assignment at first(and let's solve it first, SRIOV the next step).
> > > >
> > > > Ok, yeah I will stick with the v2.6.29 fc11 kernel on the KVM host for
> > > > the momemt to get e1000e working.  But I will start building a
> > > > v2.6.30-rc3 kernel again for my fc11 host kernel as I do need SR-IOV at
> > > > some point... :-)
> > > >
> > > > > 3. Your KVM version seems like kvm-85, you may provide some dmesg on host
> > > > > side(I think you didn't use the KVM come along with kernel).
> > > >
> > > > Ok, now within the KVM guest running v2.6.29.2, I see the following:
> > > >
> > > > [    2.669243] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> > > > [    2.672931] e1000e: Copyright (c) 1999-2008 Intel Corporation.
> > > > [    2.674932] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> > > > [    2.675181] 8139too Fast Ethernet driver 0.9.28
> > > > [    2.676783] e1000e 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10
> > > > (level, high) -> IRQ 10
> > > > [    2.678143] e1000e 0000:00:05.0: setting latency timer to 64
> > > > [    2.679539] e1000e 0000:00:05.0: irq 24 for MSI/MSI-X
> > > > [    2.679603] e1000e 0000:00:05.0: irq 25 for MSI/MSI-X
> > > > [    2.679659] e1000e 0000:00:05.0: irq 26 for MSI/MSI-X
> > > > [    2.698039] FDC 0 is a S82078B
> > > > [    2.801673] 0000:00:05.0: eth0: (PCI Express:2.5GB/s:Width x1)
> > > > 00:e0:81:c0:90:b2
> > > > [    2.802811] 0000:00:05.0: eth0: Intel(R) PRO/1000 Network Connection
> > > > [    2.803697] 0000:00:05.0: eth0: MAC: 3, PHY: 8, PBA No: ffffff-0ff
> > > >
> > > > And the folllowing from /proc/interrupts inside of the KVM guest:
> > > >
> > > >  24:        117          0          0          0          0          0
> > > >     0          0          0          0   PCI-MSI-edge      eth1-rx-0 25:
> > > >       0          0          0          0          0          0          0
> > > >        0          0          0   PCI-MSI-edge      eth1-tx-0 26:          2
> > > >          0          0          0          0          0          0
> > > > 0          0          0   PCI-MSI-edge      eth1
> > > >
> > > > ethtool eth1 reports that Link is detected, but I am still unable to get
> > > > a dhcp to work.
> > >
> > > It's a little strange that I checked all the log you posted, but can't find
> > > anything suspicious...(Except you got a MCE log in your dmesg, but I don't
> > > think it would relate to this).
> > >
> > > You also already have interrupts in the guest for eth1-rx-0 and eth1, so at
> > > least part of interrupts can be delivered to the guest.
> > >
> > > You can try to connect the port to another NIC port directly. Set fixed ip for
> > > each, then ping each other.
> > >
> > > You can also try to disable MSI-X capability in QEmu. Just using "#if
> > > 0/#endif" to wrap "#ifdef KVM_CAP_DEVICE_MSIX/#endif" in
> > > hw/assigned_device_pci_cap_init(). Then the device would use MSI.
> > >
> > > If I am lucky enough to find a 82574L card by hand, I would give it a try...
> > >
> > > --
> > > regards
> > > Yang, Sheng
> > >
> > 
> > Greetings Sheng,
> > 
> > So I updated my FC11 Host to kernel v2.6.30-rc3 (and enabled ext4 of
> > course) and rebuilt the kvm-85 source kernel module and
> > qemu-system-x86_64 and I am now able to get dhcp and IP ops from the
> > 02:00.0 device on my IOH-5520 board with the KVM guest using a v2.6.29.2
> > kernel!!  Everything is looking good with the v2.6.29.2, but after a
> > quick reboot back into my v2.6.30-rc3 KVM guest kernel build e1000e it
> > looks like I am unable to get dhcp.
> > 
> > Rebooting back into KVM Guest kernel v2.6.29.2 brings the pci-stub
> > assigned e1000e 82574L assigned with dhcp and everything looks
> > good!  :-)
> > 
> > I will keep poking at the v2.6.30-rc KVM guests (I am going to do a
> > complete rebuild) and see if it does not start move IP packets as well..
> > 
> > Thanks for all of your help in getting setup!
> > 
> > --nab
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--=-2unmVJQnCJrWfY81qS3c
Content-Disposition: attachment; filename=2.6.30-rc3-kvm-host
Content-Type: text/plain; name=2.6.30-rc3-kvm-host; charset=UTF-8
Content-Transfer-Encoding: 7bit

Linux version 2.6.30-rc3 (root@barret.risingtidesystems.com) (gcc version 4.4.0 20090427 (Red Hat 4.4.0-3) (GCC) ) #11 SMP Mon May 4 03:01:10 PDT 2009
Command line: ro root=/dev/mapper/vg_barret-lv_root rhgb pci=resource_alignment=06:00.0;06:00.1;06:00.2;06:00.3;06:00.4;06:00.5;06:00.6;06:00.7;07:00.0;07:00.1;07:00.2;07:00.3;07:00.4;07:00.5;07:00.6;07:00.7
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
 BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
 BIOS-e820: 00000000bf780000 - 00000000bf78e000 (ACPI data)
 BIOS-e820: 00000000bf78e000 - 00000000bf7d0000 (ACPI NVS)
 BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
 BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffa00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
DMI present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x240000 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-DFFFF uncachable
  E0000-E3FFF write-protect
  E4000-EFFFF write-through
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 0000000000 mask FE00000000 write-back
  1 base 0200000000 mask FFC0000000 write-back
  2 base 00C0000000 mask FFC0000000 uncachable
  3 base 00BF800000 mask FFFF800000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf780 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000bf780000
 0000000000 - 00bf600000 page 2M
 00bf600000 - 00bf780000 page 4k
kernel direct mapping tables up to bf780000 @ 10000-15000
init_memory_mapping: 0000000100000000-0000000240000000
 0100000000 - 0240000000 page 2M
kernel direct mapping tables up to 240000000 @ 13000-1d000
RAMDISK: 37c91000 - 37fefb43
ACPI: RSDP 00000000000fa420 00024 (v02 ACPIAM)
ACPI: XSDT 00000000bf780100 00064 (v01 042109 XSDT1027 20090421 MSFT 00000097)
ACPI: FACP 00000000bf780290 000F4 (v04 042109 FACP1027 20090421 MSFT 00000097)
ACPI: DSDT 00000000bf7804b0 05E8E (v02  7010_ 7010_001 00000001 INTL 20051117)
ACPI: FACS 00000000bf78e000 00040
ACPI: APIC 00000000bf780390 000DE (v02 042109 APIC1027 20090421 MSFT 00000097)
ACPI: MCFG 00000000bf780470 0003C (v01 042109 OEMMCFG  20090421 MSFT 00000097)
ACPI: OEMB 00000000bf78e040 0007A (v01 042109 OEMB1027 20090421 MSFT 00000097)
ACPI: HPET 00000000bf78a4b0 00038 (v01 042109 OEMHPET  20090421 MSFT 00000097)
ACPI: SRAT 00000000bf78a4f0 001D0 (v01 042109 OEMSRAT  00000001 INTL 00000001)
ACPI: DMAR 00000000bf78e0c0 00128 (v01    AMI  OEMDMAR 00000001 MSFT 00000097)
ACPI: SSDT 00000000bf791e00 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
ACPI: Local APIC address 0xfee00000
(8 early reservations) ==> bootmem [0000000000 - 0240000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000d038f0]    TEXT DATA BSS ==> [0000200000 - 0000d038f0]
  #3 [0037c91000 - 0037fefb43]          RAMDISK ==> [0037c91000 - 0037fefb43]
  #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
  #5 [0000d04000 - 0000d04158]              BRK ==> [0000d04000 - 0000d04158]
  #6 [0000010000 - 0000013000]          PGTABLE ==> [0000010000 - 0000013000]
  #7 [0000013000 - 0000018000]          PGTABLE ==> [0000013000 - 0000018000]
 [ffffe20000000000-ffffe20007dfffff] PMD -> [ffff880028200000-ffff88002fffffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00240000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009e
    0: 0x00000100 -> 0x000bf780
    0: 0x00100000 -> 0x00240000
On node 0 totalpages: 2094862
  DMA zone: 56 pages used for memmap
  DMA zone: 2927 pages reserved
  DMA zone: 999 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765880 pages, LIFO batch:31
  Normal zone: 17920 pages used for memmap
  Normal zone: 1292800 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x16] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x17] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] high dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec8a000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 0, address 0xfec8a000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
SMP: Allowing 16 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 48
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
NR_CPUS:255 nr_cpumask_bits:255 nr_cpu_ids:16 nr_node_ids:1
PERCPU: Embedded 24 pages at ffff880030000000, static data 68768 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2059679
Kernel command line: ro root=/dev/mapper/vg_barret-lv_root rhgb pci=resource_alignment=06:00.0;06:00.1;06:00.2;06:00.3;06:00.4;06:00.5;06:00.6;06:00.7;07:00.0;07:00.1;07:00.2;07:00.3;07:00.4;07:00.5;07:00.6;07:00.7
Initializing CPU#0
NR_IRQS:4352
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2266.696 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
No AGP bridge found
Memory: 8220660k/9437184k available (2906k kernel code, 1057736k absent, 157960k reserved, 1829k data, 452k init)
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 4533.39 BogoMIPS (lpj=9066784)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
using mwait in idle threads.
ACPI: Core revision 20090320
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4533.20 BogoMIPS (lpj=9066400)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU1: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 2 APIC 0x4 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4533.19 BogoMIPS (lpj=9066384)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU2: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 3 APIC 0x6 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4533.20 BogoMIPS (lpj=9066404)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU3: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 4 APIC 0x10 ip 0x6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 4533.24 BogoMIPS (lpj=9066490)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU4: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 5 APIC 0x12 ip 0x6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 4533.24 BogoMIPS (lpj=9066488)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU5: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 6 APIC 0x14 ip 0x6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 4533.24 BogoMIPS (lpj=9066485)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU6: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 7 APIC 0x16 ip 0x6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 4533.24 BogoMIPS (lpj=9066483)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU7: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 8 APIC 0x1 ip 0x6000
Initializing CPU#8
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066471)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU8: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 9 APIC 0x3 ip 0x6000
Initializing CPU#9
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066474)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU9: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 10 APIC 0x5 ip 0x6000
Initializing CPU#10
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066470)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU10: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 11 APIC 0x7 ip 0x6000
Initializing CPU#11
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066476)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU11: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 12 APIC 0x11 ip 0x6000
Initializing CPU#12
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066478)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU12: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 13 APIC 0x13 ip 0x6000
Initializing CPU#13
Calibrating delay using timer specific routine.. 4533.24 BogoMIPS (lpj=9066482)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU13: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 14 APIC 0x15 ip 0x6000
Initializing CPU#14
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066470)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU14: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Booting processor 15 APIC 0x17 ip 0x6000
Initializing CPU#15
Calibrating delay using timer specific routine.. 4533.23 BogoMIPS (lpj=9066474)
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 256K
CPU: L3 cache: 8192K
CPU15: Intel(R) Xeon(R) CPU           E5520  @ 2.27GHz stepping 05
Skipping synchronization checks as TSC is reliable.
Brought up 16 CPUs
Total of 16 processors activated (72531.85 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 0 1 2 3 8 9 10 11
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU1 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 1 2 3 8 9 10 11 0
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU2 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 2 3 8 9 10 11 0 1
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU3 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 3 8 9 10 11 0 1 2
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU4 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 4 5 6 7 12 13 14 15
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU5 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 5 6 7 12 13 14 15 4
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU6 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 6 7 12 13 14 15 4 5
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU7 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 7 12 13 14 15 4 5 6
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU8 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 8 9 10 11 0 1 2 3
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU9 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 9 10 11 0 1 2 3 8
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU10 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 10 11 0 1 2 3 8 9
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU11 attaching sched-domain:
 domain 0: span 0-3,8-11 level MC
  groups: 11 0 1 2 3 8 9 10
  domain 1: span 0-15 level CPU
   groups: 0-3,8-11 4-7,12-15
CPU12 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 12 13 14 15 4 5 6 7
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU13 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 13 14 15 4 5 6 7 12
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU14 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 14 15 4 5 6 7 12 13
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
CPU15 attaching sched-domain:
 domain 0: span 4-7,12-15 level MC
  groups: 15 4 5 6 7 12 13 14
  domain 1: span 0-15 level CPU
   groups: 4-7,12-15 0-3,8-11
net_namespace: 1824 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - 9A, should be 97 [20090320]
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
pci 0000:00:05.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:13.0: reg 10 32bit mmio: [0xfec8a000-0xfec8afff]
pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
pci 0000:00:13.0: PME# disabled
pci 0000:00:16.0: reg 10 64bit mmio: [0xfaed4000-0xfaed7fff]
pci 0000:00:16.1: reg 10 64bit mmio: [0xfaed8000-0xfaedbfff]
pci 0000:00:16.2: reg 10 64bit mmio: [0xfaedc000-0xfaedffff]
pci 0000:00:16.3: reg 10 64bit mmio: [0xfaee0000-0xfaee3fff]
pci 0000:00:16.4: reg 10 64bit mmio: [0xfaee4000-0xfaee7fff]
pci 0000:00:16.5: reg 10 64bit mmio: [0xfaee8000-0xfaeebfff]
pci 0000:00:16.6: reg 10 64bit mmio: [0xfaeec000-0xfaeeffff]
pci 0000:00:16.7: reg 10 64bit mmio: [0xfaef0000-0xfaef3fff]
pci 0000:00:1a.0: reg 20 io port: [0x9400-0x941f]
pci 0000:00:1a.1: reg 20 io port: [0x9480-0x949f]
pci 0000:00:1a.2: reg 20 io port: [0x9800-0x981f]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xfaef6000-0xfaef63ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xfaef8000-0xfaefbfff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x9880-0x989f]
pci 0000:00:1d.1: reg 20 io port: [0x9c00-0x9c1f]
pci 0000:00:1d.2: reg 20 io port: [0xa000-0xa01f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xfaefc000-0xfaefc3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at f700 (mask 000f)
pci 0000:00:1f.2: reg 10 io port: [0xac00-0xac07]
pci 0000:00:1f.2: reg 14 io port: [0xa880-0xa883]
pci 0000:00:1f.2: reg 18 io port: [0xa800-0xa807]
pci 0000:00:1f.2: reg 1c io port: [0xa480-0xa483]
pci 0000:00:1f.2: reg 20 io port: [0xa400-0xa40f]
pci 0000:00:1f.2: reg 24 io port: [0xa080-0xa08f]
pci 0000:00:1f.3: reg 10 64bit mmio: [0xfaefe000-0xfaefe0ff]
pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
pci 0000:00:1f.5: reg 10 io port: [0xbc00-0xbc07]
pci 0000:00:1f.5: reg 14 io port: [0xb880-0xb883]
pci 0000:00:1f.5: reg 18 io port: [0xb800-0xb807]
pci 0000:00:1f.5: reg 1c io port: [0xb480-0xb483]
pci 0000:00:1f.5: reg 20 io port: [0xb400-0xb40f]
pci 0000:00:1f.5: reg 24 io port: [0xb080-0xb08f]
pci 0000:03:00.0: reg 10 32bit mmio: [0xfbee0000-0xfbefffff]
pci 0000:03:00.0: reg 18 io port: [0xec00-0xec1f]
pci 0000:03:00.0: reg 1c 32bit mmio: [0xfbedc000-0xfbedffff]
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.4: bridge io port: [0xe000-0xefff]
pci 0000:00:1c.4: bridge 32bit mmio: [0xfbe00000-0xfbefffff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xfbde0000-0xfbdfffff]
pci 0000:02:00.0: reg 18 io port: [0xdc00-0xdc1f]
pci 0000:02:00.0: reg 1c 32bit mmio: [0xfbddc000-0xfbddffff]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.5: bridge io port: [0xd000-0xdfff]
pci 0000:00:1c.5: bridge 32bit mmio: [0xfbd00000-0xfbdfffff]
pci 0000:01:00.0: reg 10 32bit mmio: [0xfb000000-0xfb7fffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xfafe0000-0xfaffffff]
pci 0000:01:00.0: reg 18 io port: [0xc880-0xc8ff]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:01:05.0: reg 10 32bit mmio: [0xfbcfe000-0xfbcfe7ff]
pci 0000:01:05.0: reg 14 io port: [0xcc00-0xcc7f]
pci 0000:01:05.0: supports D2
pci 0000:01:05.0: PME# supported from D2 D3hot D3cold
pci 0000:01:05.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xfaf00000-0xfbcfffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:Host address width 40
DMAR:DRHD (flags: 0x00000001)base: 0x00000000fbffe000
DMAR:RMRR base: 0x00000000000ec000 end: 0x00000000000effff
DMAR:RMRR base: 0x00000000bf7ec000 end: 0x00000000bf7fffff
DMAR:Unknown DMAR structure type
IOAPIC id 8 under DRHD base 0xfbffe000
IOAPIC id 9 under DRHD base 0xfbffe000
IOMMU 0xfbffe000: using Queued invalidation
IOMMU: Setting identity map for device 0000:00:1d.0 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xbf7ec000 - 0xbf800000]
IOMMU: Setting identity map for device 0000:00:1d.0 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1d.1 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1d.2 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1d.7 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.0 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.1 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.2 [0xec000 - 0xf0000]
IOMMU: Setting identity map for device 0000:00:1a.7 [0xec000 - 0xf0000]
IOMMU: gfx device 0000:01:00.0 1-1 mapping
IOMMU: Setting identity map for device 0000:01:00.0 [0x10000 - 0x9e000]
IOMMU: Setting identity map for device 0000:01:00.0 [0x100000 - 0xbf780000]
IOMMU: Setting identity map for device 0000:01:00.0 [0x100000000 - 0x240000000]
IOMMU: Prepare 0-16M unity mapping for LPC
IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0x1000000]
PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
Multi-level page-table translation for DMAR.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
alloc irq_2_iommu on cpu 0 node 0
alloc irq_2_iommu on cpu 0 node 0
alloc irq_2_iommu on cpu 0 node 0
alloc irq_2_iommu on cpu 0 node 0
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfbf00000-0xfbffffff has been reserved
system 00:01: iomem range 0xfc000000-0xfcffffff has been reserved
system 00:01: iomem range 0xfd000000-0xfdffffff has been reserved
system 00:01: iomem range 0xfe000000-0xfebfffff has been reserved
system 00:01: iomem range 0xfec8a000-0xfec8afff has been reserved
system 00:01: iomem range 0xfed10000-0xfed10fff has been reserved
system 00:08: ioport range 0xa00-0xa0f has been reserved
system 00:08: ioport range 0xa10-0xa1f has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x800-0x87f has been reserved
system 00:09: ioport range 0x500-0x57f could not be reserved
system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:09: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:09: iomem range 0xfed40000-0xfed8ffff has been reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0xc0000-0xcffff has been reserved
system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
system 00:0d: iomem range 0x100000-0xbfffffff could not be reserved
system 00:0d: iomem range 0xfed90000-0xffffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:08
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: disabled
pci 0000:00:01.0:   PREFETCH window: disabled
pci 0000:00:03.0: PCI bridge, secondary bus 0000:07
pci 0000:00:03.0:   IO window: disabled
pci 0000:00:03.0:   MEM window: disabled
pci 0000:00:03.0:   PREFETCH window: disabled
pci 0000:00:05.0: PCI bridge, secondary bus 0000:06
pci 0000:00:05.0:   IO window: disabled
pci 0000:00:05.0:   MEM window: disabled
pci 0000:00:05.0:   PREFETCH window: disabled
pci 0000:00:07.0: PCI bridge, secondary bus 0000:05
pci 0000:00:07.0:   IO window: disabled
pci 0000:00:07.0:   MEM window: disabled
pci 0000:00:07.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.4:   IO window: 0xe000-0xefff
pci 0000:00:1c.4:   MEM window: 0xfbe00000-0xfbefffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
pci 0000:00:1c.5:   MEM window: 0xfbd00000-0xfbdfffff
pci 0000:00:1c.5:   PREFETCH window: disabled
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xfaf00000-0xfbcfffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:05.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:08: resource 0 mem: [0x0-0x0]
pci_bus 0000:08: resource 1 mem: [0x0-0x0]
pci_bus 0000:08: resource 2 mem: [0x0-0x0]
pci_bus 0000:08: resource 3 mem: [0x0-0x0]
pci_bus 0000:07: resource 0 mem: [0x0-0x0]
pci_bus 0000:07: resource 1 mem: [0x0-0x0]
pci_bus 0000:07: resource 2 mem: [0x0-0x0]
pci_bus 0000:07: resource 3 mem: [0x0-0x0]
pci_bus 0000:06: resource 0 mem: [0x0-0x0]
pci_bus 0000:06: resource 1 mem: [0x0-0x0]
pci_bus 0000:06: resource 2 mem: [0x0-0x0]
pci_bus 0000:06: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 mem: [0x0-0x0]
pci_bus 0000:05: resource 1 mem: [0x0-0x0]
pci_bus 0000:05: resource 2 mem: [0x0-0x0]
pci_bus 0000:05: resource 3 mem: [0x0-0x0]
pci_bus 0000:04: resource 0 mem: [0x0-0x0]
pci_bus 0000:04: resource 1 mem: [0x0-0x0]
pci_bus 0000:04: resource 2 mem: [0x0-0x0]
pci_bus 0000:04: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:03: resource 1 mem: [0xfbe00000-0xfbefffff]
pci_bus 0000:03: resource 2 mem: [0x0-0x0]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:02: resource 1 mem: [0xfbd00000-0xfbdfffff]
pci_bus 0000:02: resource 2 mem: [0x0-0x0]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:01: resource 0 io:  [0xc000-0xcfff]
pci_bus 0000:01: resource 1 mem: [0xfaf00000-0xfbcfffff]
pci_bus 0000:01: resource 2 mem: [0x0-0x0]
pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...
rootfs image is initramfs; unpacking...
Freeing initrd memory: 3450k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1241513600.604:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 16064
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:01.0: irq 49 for MSI/MSI-X
pcieport-driver 0000:00:01.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:03.0: irq 50 for MSI/MSI-X
pcieport-driver 0000:00:03.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:05.0: irq 51 for MSI/MSI-X
pcieport-driver 0000:00:05.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:07.0: irq 52 for MSI/MSI-X
pcieport-driver 0000:00:07.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:1c.0: irq 53 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:1c.4: irq 54 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
pcieport-driver 0000:00:1c.5: irq 55 for MSI/MSI-X
pcieport-driver 0000:00:1c.5: setting latency timer to 64
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:05.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: SSDT 00000000bf78e1f0 02B94 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
ACPI: SSDT 00000000bf790d90 00980 (v01  PmRef  P001Cst 00003001 INTL 20051117)
ACPI: SSDT 00000000bf791710 006E2 (v01  PmRef  Cpu0Tst 00003000 INTL 20051117)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [P001] (supports 8 throttling states)
ACPI: CPU1 (power states: C1[C1] C2[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [P002] (supports 8 throttling states)
ACPI: CPU2 (power states: C1[C1] C2[C3])
processor ACPI_CPU:02: registered as cooling_device2
ACPI: Processor [P003] (supports 8 throttling states)
ACPI: CPU3 (power states: C1[C1] C2[C3])
processor ACPI_CPU:03: registered as cooling_device3
ACPI: Processor [P004] (supports 8 throttling states)
ACPI: CPU4 (power states: C1[C1] C2[C3])
processor ACPI_CPU:04: registered as cooling_device4
ACPI: Processor [P005] (supports 8 throttling states)
ACPI: CPU5 (power states: C1[C1] C2[C3])
processor ACPI_CPU:05: registered as cooling_device5
ACPI: Processor [P006] (supports 8 throttling states)
ACPI: CPU6 (power states: C1[C1] C2[C3])
processor ACPI_CPU:06: registered as cooling_device6
ACPI: Processor [P007] (supports 8 throttling states)
ACPI: CPU7 (power states: C1[C1] C2[C3])
processor ACPI_CPU:07: registered as cooling_device7
ACPI: Processor [P008] (supports 8 throttling states)
ACPI: CPU8 (power states: C1[C1] C2[C3])
processor ACPI_CPU:08: registered as cooling_device8
ACPI: Processor [P009] (supports 8 throttling states)
ACPI: CPU9 (power states: C1[C1] C2[C3])
processor ACPI_CPU:09: registered as cooling_device9
ACPI: Processor [P010] (supports 8 throttling states)
ACPI: CPU10 (power states: C1[C1] C2[C3])
processor ACPI_CPU:0a: registered as cooling_device10
ACPI: Processor [P011] (supports 8 throttling states)
ACPI: CPU11 (power states: C1[C1] C2[C3])
processor ACPI_CPU:0b: registered as cooling_device11
ACPI: Processor [P012] (supports 8 throttling states)
ACPI: CPU12 (power states: C1[C1] C2[C3])
processor ACPI_CPU:0c: registered as cooling_device12
ACPI: Processor [P013] (supports 8 throttling states)
ACPI: CPU13 (power states: C1[C1] C2[C3])
processor ACPI_CPU:0d: registered as cooling_device13
ACPI: Processor [P014] (supports 8 throttling states)
ACPI: CPU14 (power states: C1[C1] C2[C3])
processor ACPI_CPU:0e: registered as cooling_device14
ACPI: Processor [P015] (supports 8 throttling states)
ACPI: CPU15 (power states: C1[C1] C2[C3])
processor ACPI_CPU:0f: registered as cooling_device15
ACPI: Processor [P016] (supports 8 throttling states)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 452k freed
Write protecting the kernel read-only data: 4036k
SCSI subsystem initialized
libata version 3.00 loaded.
ata_piix 0000:00:1f.2: version 2.12
alloc irq_2_iommu on cpu 0 node 0
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 19
ata2: SATA max UDMA/133 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 19
ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
ata4: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
ata3: SATA link down (SStatus 0 SControl 300)
ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.01: SATA link down (SStatus 0 SControl 300)
ata1.00: ATA-6: ST380817AS, 3.42, max UDMA/133
ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (not used)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST380817AS       3.42 PQ: 0 ANSI: 5
ata2.00: SATA link down (SStatus 0 SControl 300)
ata2.01: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
alloc irq_2_iommu on cpu 0 node 0
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfaef6000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
alloc irq_2_iommu on cpu 0 node 0
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfaefc000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009400
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
alloc irq_2_iommu on cpu 0 node 0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009480
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009800
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009c00
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a000
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
EXT4-fs: barriers enabled
kjournald2 starting: pid 883, dev dm-0:8, commit interval 5 seconds
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem dm-0 with ordered data mode
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1241513604.336:2): selinux=0 auid=4294967295 ses=4294967295
usb 2-5: new high speed USB device using ehci_hcd and address 2
usb 2-5: config 1 interface 0 altsetting 0 endpoint 0x81 has an invalid bInterval 255, changing to 11
usb 2-5: configuration #1 chosen from 1 choice
hub 2-5:1.0: USB hub found
hub 2-5:1.0: 3 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
hub 3-1:1.0: USB hub found
hub 3-1:1.0: 2 ports detected
usb 3-2: new low speed USB device using uhci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
input: Sony Computer Entertainment Inc. SCE USB MOUSE as /class/input/input0
generic-usb 0003:054C:0061.0001: input: USB HID v1.00 Mouse [Sony Computer Entertainment Inc. SCE USB MOUSE] on usb-0000:00:1a.0-2/input0
usb 2-5.1: new high speed USB device using ehci_hcd and address 3
usb 2-5.1: configuration #1 chosen from 1 choice
input: American Megatrends Inc. Virtual Keyboard and Mouse as /class/input/input1
generic-usb 0003:046B:FF10.0002: input: USB HID v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input0
input: American Megatrends Inc. Virtual Keyboard and Mouse as /class/input/input2
generic-usb 0003:046B:FF10.0003: input: USB HID v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-0000:00:1d.7-5.1/input1
usb 3-1.1: new full speed USB device using uhci_hcd and address 4
usb 3-1.1: configuration #1 chosen from 1 choice
input: Sony Computer Entertainment Inc. SCE USB Keyboard as /class/input/input3
generic-usb 0003:054C:005C.0004: input: USB HID v1.00 Keyboard [Sony Computer Entertainment Inc. SCE USB Keyboard] on usb-0000:00:1a.0-1.1/input0
udev: starting version 141
udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
input: Power Button as /class/input/input4
ACPI: Power Button [PWRF]
input: Power Button as /class/input/input5
ACPI: Power Button [PWRB]
input: PC Speaker as /class/input/input6
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:03:00.0: Disabling L1 ASPM
e1000e 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:03:00.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
e1000e 0000:03:00.0: irq 56 for MSI/MSI-X
alloc irq_2_iommu on cpu 0 node 0
e1000e 0000:03:00.0: irq 57 for MSI/MSI-X
alloc irq_2_iommu on cpu 0 node 0
e1000e 0000:03:00.0: irq 58 for MSI/MSI-X
0000:03:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:e0:81:c0:90:b3
0000:03:00.0: eth0: Intel(R) PRO/1000 Network Connection
0000:03:00.0: eth0: MAC: 3, PHY: 8, PBA No: ffffff-0ff
e1000e 0000:02:00.0: Disabling L1 ASPM
e1000e 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
e1000e 0000:02:00.0: setting latency timer to 64
alloc irq_2_iommu on cpu 0 node 0
e1000e 0000:02:00.0: irq 59 for MSI/MSI-X
alloc irq_2_iommu on cpu 0 node 0
e1000e 0000:02:00.0: irq 60 for MSI/MSI-X
alloc irq_2_iommu on cpu 0 node 0
e1000e 0000:02:00.0: irq 61 for MSI/MSI-X
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:e0:81:c0:90:b2
0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
0000:02:00.0: eth1: MAC: 3, PHY: 8, PBA No: ffffff-0ff
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
sd 0:0:0:0: Attached scsi generic sg0 type 0
firewire_ohci 0000:01:05.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
firewire_ohci: Added fw-ohci device 0000:01:05.0, OHCI version 1.10
loaded kvm module (kvm-85)
firewire_core: created device fw0: GUID 00e0810000310bb8, S400
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT4 FS on dm-0, internal journal on dm-0:8
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Adding 10158072k swap on /dev/mapper/vg_barret-lv_swap.  Priority:-1 extents:1 across:10158072k 
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
platform microcode: firmware: requesting intel-ucode/06-1a-05
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Microcode Update Driver: v2.00 removed.
Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
iscsi: registered transport (iser)
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
can't load conntrack support for proto=10
ip_tables: (C) 2000-2006 Netfilter Core Team
can't load conntrack support for proto=2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Bridge firewalling registered
virbr0: starting userspace STP failed, starting kernel STP
mtrr: type mismatch for fb000000,800000 old: write-back new: write-combining
can't load conntrack support for proto=2
ADDRCONF(NETDEV_UP): eth1: link is not ready
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
e1000e 0000:02:00.0: PCI INT A disabled
pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
assign device: host bdf = 2:0:0
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
pci-stub 0000:02:00.0: PCI INT A disabled
pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
assign device: host bdf = 2:0:0
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:260 enable_irq+0x36/0x50()
Hardware name: empty
Unbalanced enable for IRQ 59
Modules linked in: ipt_REJECT xt_tcpudp bridge stp sunrpc iptable_filter ip_tables xt_state nf_conntrack ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq freq_table ext3 jbd loop dm_multipath scsi_dh kvm_intel kvm uinput i2c_i801 firewire_ohci joydev firewire_core sg i2c_core 8250_pnp crc_itu_t e1000e 8250 serial_core rtc_cmos pcspkr serio_raw rtc_core rtc_lib button sd_mod dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd ohci_hcd ehci_hcd ata_piix libata scsi_mod [last unloaded: microcode]
Pid: 55, comm: events/4 Not tainted 2.6.30-rc3 #11
Call Trace:
 [<ffffffff80235fee>] ? warn_slowpath+0xcb/0xe8
 [<ffffffff80248214>] ? autoremove_wake_function+0x9/0x2a
 [<ffffffff80229392>] ? __wake_up_common+0x41/0x78
 [<ffffffff8022acec>] ? update_curr+0x67/0xeb
 [<ffffffff8020a5d8>] ? __switch_to+0xb6/0x274
 [<ffffffffa01ac7e4>] ? kvm_irq_delivery_to_apic+0xb3/0xf7 [kvm]
 [<ffffffffa01aa4d4>] ? __apic_accept_irq+0x15a/0x173 [kvm]
 [<ffffffffa01ac883>] ? kvm_set_msi+0x5b/0x60 [kvm]
 [<ffffffff80266d97>] ? enable_irq+0x36/0x50
 [<ffffffffa0195ab5>] ? kvm_assigned_dev_interrupt_work_handler+0x6d/0xbc [kvm]
 [<ffffffff802449fa>] ? worker_thread+0x182/0x223
 [<ffffffff8024820b>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff80244878>] ? worker_thread+0x0/0x223
 [<ffffffff80244878>] ? worker_thread+0x0/0x223
 [<ffffffff80247e72>] ? kthread+0x54/0x7e
 [<ffffffff8020cb0a>] ? child_rip+0xa/0x20
 [<ffffffff804d0af5>] ? _spin_lock+0x5/0x8
 [<ffffffff80247e1e>] ? kthread+0x0/0x7e
 [<ffffffff8020cb00>] ? child_rip+0x0/0x20
---[ end trace 3fbc2dd20bf89ef0 ]---
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: PCI INT A disabled
pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
assign device: host bdf = 2:0:0
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
pci-stub 0000:02:00.0: PCI INT A disabled
pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
assign device: host bdf = 2:0:0
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
scsi4 : iSCSI Initiator over TCP/IP
scsi 4:0:0:0: Direct-Access     LIO-ORG  RAMDISK-DR       3.0  PQ: 0 ANSI: 5
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 4:0:0:1: Direct-Access     LIO-ORG  RAMDISK-DR       3.0  PQ: 0 ANSI: 5
sd 4:0:0:1: Attached scsi generic sg2 type 0
sd 4:0:0:0: [sdb] 262144 512-byte hardware sectors: (134 MB/128 MiB)
sd 4:0:0:1: [sdc] 262144 512-byte hardware sectors: (134 MB/128 MiB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 2f 00 00 00
sd 4:0:0:1: [sdc] Write Protect is off
sd 4:0:0:1: [sdc] Mode Sense: 2f 00 00 00
sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:1: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb:<6> sdc: unknown partition table
sd 4:0:0:0: [sdb] Attached SCSI disk
 unknown partition table
sd 4:0:0:1: [sdc] Attached SCSI disk
------------[ cut here ]------------
WARNING: at kernel/irq/manage.c:260 enable_irq+0x36/0x50()
Hardware name: empty
Unbalanced enable for IRQ 59
Modules linked in: ipt_REJECT xt_tcpudp bridge stp sunrpc iptable_filter ip_tables xt_state nf_conntrack ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq freq_table ext3 jbd loop dm_multipath scsi_dh kvm_intel kvm uinput i2c_i801 firewire_ohci joydev firewire_core sg i2c_core 8250_pnp crc_itu_t e1000e 8250 serial_core rtc_cmos pcspkr serio_raw rtc_core rtc_lib button sd_mod dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd ohci_hcd ehci_hcd ata_piix libata scsi_mod [last unloaded: microcode]
Pid: 51, comm: events/0 Tainted: G        W  2.6.30-rc3 #11
Call Trace:
 [<ffffffff80235fee>] ? warn_slowpath+0xcb/0xe8
 [<ffffffff80253a7c>] ? generic_exec_single+0x6a/0x88
 [<ffffffff8022acec>] ? update_curr+0x67/0xeb
 [<ffffffffa0198748>] ? vcpu_kick_intr+0x0/0x1 [kvm]
 [<ffffffff8020a5d8>] ? __switch_to+0xb6/0x274
 [<ffffffff8022b70a>] ? __dequeue_entity+0x1b/0x2f
 [<ffffffffa01ac7e4>] ? kvm_irq_delivery_to_apic+0xb3/0xf7 [kvm]
 [<ffffffffa01aa4d4>] ? __apic_accept_irq+0x15a/0x173 [kvm]
 [<ffffffffa01ac883>] ? kvm_set_msi+0x5b/0x60 [kvm]
 [<ffffffff80266d97>] ? enable_irq+0x36/0x50
 [<ffffffffa0195ab5>] ? kvm_assigned_dev_interrupt_work_handler+0x6d/0xbc [kvm]
 [<ffffffff802449fa>] ? worker_thread+0x182/0x223
 [<ffffffff8024820b>] ? autoremove_wake_function+0x0/0x2a
 [<ffffffff80244878>] ? worker_thread+0x0/0x223
 [<ffffffff80244878>] ? worker_thread+0x0/0x223
 [<ffffffff80247e72>] ? kthread+0x54/0x7e
 [<ffffffff8020cb0a>] ? child_rip+0xa/0x20
 [<ffffffff804d0af5>] ? _spin_lock+0x5/0x8
 [<ffffffff80247e1e>] ? kthread+0x0/0x7e
 [<ffffffff8020cb00>] ? child_rip+0x0/0x20
---[ end trace 3fbc2dd20bf89ef1 ]---
 connection1:0: ping timeout of 5 secs expired, last rx 4295286327, last ping 4295285518, now 4295286768
 connection1:0: detected conn error (1011)
 session1: session recovery timed out after 120 secs
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 138240
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
Buffer I/O error on device sdb, logical block 1
Buffer I/O error on device sdb, logical block 2
Buffer I/O error on device sdb, logical block 3
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
Buffer I/O error on device sdb, logical block 1
Buffer I/O error on device sdb, logical block 2
Buffer I/O error on device sdb, logical block 3
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0
sd 4:0:0:0: [sdb] Unhandled error code
sd 4:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
end_request: I/O error, dev sdb, sector 0
pci-stub 0000:02:00.0: PCI INT A disabled
pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
assign device: host bdf = 2:0:0
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X

--=-2unmVJQnCJrWfY81qS3c
Content-Disposition: attachment; filename=2.6.29.2-kvm-guest-lio
Content-Type: text/plain; name=2.6.29.2-kvm-guest-lio; charset=UTF-8
Content-Transfer-Encoding: 7bit

May  5 02:28:32 lenny64guest1 kernel: imklog 3.18.6, log source = /proc/kmsg started.
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Initializing cgroup subsys cpuset
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Initializing cgroup subsys cpu
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Linux version 2.6.29.2 (root@lenny64guest1) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #2 SMP Mon May 4 01:22:53 PDT 2009
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Command line: root=/dev/hda1 ro
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] KERNEL supported cpus:
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   Intel GenuineIntel
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   AMD AuthenticAMD
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   Centaur CentaurHauls
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] BIOS-provided physical RAM map:
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (ACPI data)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] DMI 2.4 present.
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] last_pfn = 0x7fff0 max_arch_pfn = 0x100000000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] init_memory_mapping: 0000000000000000-000000007fff0000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] last_map_addr: 7fff0000 end: 7fff0000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] RAMDISK: 379c8000 - 37fef480
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: RSDP 000FBE50, 0014 (r0 QEMU  )
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: RSDT 7FFF0000, 002C (r1 QEMU   QEMURSDT        1 QEMU        1)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: FACP 7FFF002C, 0074 (r1 QEMU   QEMUFACP        1 QEMU        1)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: DSDT 7FFF0100, 2540 (r1   BXPC   BXDSDT        1 INTL 20061109)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: FACS 7FFF00C0, 0040
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: APIC 7FFF2640, 00E0 (r1 QEMU   QEMUAPIC        1 QEMU        1)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] No NUMA configuration found
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Faking a node at 0000000000000000-000000007fff0000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Bootmem setup node 0 0000000000000000-000000007fff0000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   bootmap [000000000000a000 -  0000000000019fff] pages 10
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007fff0000]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   #2 [0000200000 - 000070493c]    TEXT DATA BSS ==> [0000200000 - 000070493c]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   #3 [00379c8000 - 0037fef480]          RAMDISK ==> [00379c8000 - 0037fef480]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] found SMP MP-table at [ffff8800000fbd10] 000fbd10
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Zone PFN ranges:
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   DMA32    0x00001000 -> 0x00100000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]   Normal   0x00100000 -> 0x00100000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Movable zone start PFN for each node
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] early_node_map[2] active PFN ranges
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]     0: 0x00000000 -> 0x0000009f
May  5 02:28:32 lenny64guest1 kernel: [    0.000000]     0: 0x00000100 -> 0x0007fff0
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: PM-Timer IO Port: 0xb008
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Using ACPI (MADT) for SMP configuration information
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] SMP: Allowing 16 CPUs, 14 hotplug CPUs
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ffbc000)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:16 nr_node_ids:1
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515620
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Policy zone: DMA32
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Kernel command line: root=/dev/hda1 ro
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Initializing CPU#0
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Fast TSC calibration using PIT
May  5 02:28:32 lenny64guest1 kernel: [    0.000000] Detected 2266.606 MHz processor.
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] Console: colour VGA+ 80x25
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] console [tty0] enabled
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] Checking aperture...
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] No AGP bridge found
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] Memory: 2055644k/2097088k available (2463k kernel code, 388k absent, 41056k reserved, 1259k data, 464k init)
May  5 02:28:32 lenny64guest1 kernel: [    0.004014] Calibrating delay loop (skipped), value calculated using timer frequency.. 4533.21 BogoMIPS (lpj=9066424)
May  5 02:28:32 lenny64guest1 kernel: [    0.004982] Security Framework initialized
May  5 02:28:32 lenny64guest1 kernel: [    0.005410] SELinux:  Disabled at boot.
May  5 02:28:32 lenny64guest1 kernel: [    0.005987] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.007713] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.008000] Mount-cache hash table entries: 256
May  5 02:28:32 lenny64guest1 kernel: [    0.008000] Initializing cgroup subsys ns
May  5 02:28:32 lenny64guest1 kernel: [    0.008000] Initializing cgroup subsys cpuacct
May  5 02:28:32 lenny64guest1 kernel: [    0.008010] Initializing cgroup subsys devices
May  5 02:28:32 lenny64guest1 kernel: [    0.008489] CPU: L1 I cache: 32K, L1 D cache: 32K
May  5 02:28:32 lenny64guest1 kernel: [    0.009040] CPU: L2 cache: 2048K
May  5 02:28:32 lenny64guest1 kernel: [    0.009426] CPU 0/0x0 -> Node 0
May  5 02:28:32 lenny64guest1 kernel: [    0.009860] ACPI: Core revision 20081204
May  5 02:28:32 lenny64guest1 kernel: [    0.011340] Setting APIC routing to flat
May  5 02:28:32 lenny64guest1 kernel: [    0.013152] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
May  5 02:28:32 lenny64guest1 kernel: [    0.053457] CPU0: Intel QEMU Virtual CPU version 0.10.0 stepping 03
May  5 02:28:32 lenny64guest1 kernel: [    0.063563] Booting processor 1 APIC 0x1 ip 0x6000
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] Initializing CPU#1
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] Calibrating delay using timer specific routine.. 4553.99 BogoMIPS (lpj=9107983)
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] CPU: L2 cache: 2048K
May  5 02:28:32 lenny64guest1 kernel: [    0.004000] CPU 1/0x1 -> Node 0
May  5 02:28:32 lenny64guest1 kernel: [    0.180153] CPU1: Intel QEMU Virtual CPU version 0.10.0 stepping 03
May  5 02:28:32 lenny64guest1 kernel: [    0.184027] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
May  5 02:28:32 lenny64guest1 kernel: [    0.192055] Brought up 2 CPUs
May  5 02:28:32 lenny64guest1 kernel: [    0.192480] Total of 2 processors activated (9087.20 BogoMIPS).
May  5 02:28:32 lenny64guest1 kernel: [    0.193288] net_namespace: 1888 bytes
May  5 02:28:32 lenny64guest1 kernel: [    0.193288] NET: Registered protocol family 16
May  5 02:28:32 lenny64guest1 kernel: [    0.196058] ACPI: bus type pci registered
May  5 02:28:32 lenny64guest1 kernel: [    0.196484] PCI: Using configuration type 1 for base access
May  5 02:28:32 lenny64guest1 kernel: [    0.200239] bio: create slab <bio-0> at 0
May  5 02:28:32 lenny64guest1 kernel: [    0.206341] ACPI: Interpreter enabled
May  5 02:28:32 lenny64guest1 kernel: [    0.206773] ACPI: (supports S0 S3 S4 S5)
May  5 02:28:32 lenny64guest1 kernel: [    0.208479] ACPI: Using IOAPIC for interrupt routing
May  5 02:28:32 lenny64guest1 kernel: [    0.212843] ACPI: No dock devices found.
May  5 02:28:32 lenny64guest1 kernel: [    0.212843] ACPI: PCI Root Bridge [PCI0] (0000:00)
May  5 02:28:32 lenny64guest1 kernel: [    0.216782] pci 0000:00:01.3: quirk: region b000-b03f claimed by PIIX4 ACPI
May  5 02:28:32 lenny64guest1 kernel: [    0.217309] pci 0000:00:01.3: quirk: region b100-b10f claimed by PIIX4 SMB
May  5 02:28:32 lenny64guest1 kernel: [    0.244182] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
May  5 02:28:32 lenny64guest1 kernel: [    0.246185] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
May  5 02:28:32 lenny64guest1 kernel: [    0.248084] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
May  5 02:28:32 lenny64guest1 kernel: [    0.249660] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
May  5 02:28:32 lenny64guest1 kernel: [    0.252165] usbcore: registered new interface driver usbfs
May  5 02:28:32 lenny64guest1 kernel: [    0.252715] usbcore: registered new interface driver hub
May  5 02:28:32 lenny64guest1 kernel: [    0.252751] usbcore: registered new device driver usb
May  5 02:28:32 lenny64guest1 kernel: [    0.256060] PCI: Using ACPI for IRQ routing
May  5 02:28:32 lenny64guest1 kernel: [    0.292029] pnp: PnP ACPI init
May  5 02:28:32 lenny64guest1 kernel: [    0.326776] ACPI: bus type pnp registered
May  5 02:28:32 lenny64guest1 kernel: [    0.329364] pnp: PnP ACPI: found 7 devices
May  5 02:28:32 lenny64guest1 kernel: [    0.329980] ACPI: ACPI bus type pnp unregistered
May  5 02:28:32 lenny64guest1 kernel: [    0.337062] NET: Registered protocol family 2
May  5 02:28:32 lenny64guest1 kernel: [    0.384400] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.424264] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.428894] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.430439] TCP: Hash tables configured (established 262144 bind 65536)
May  5 02:28:32 lenny64guest1 kernel: [    0.431153] TCP reno registered
May  5 02:28:32 lenny64guest1 kernel: [    0.440570] NET: Registered protocol family 1
May  5 02:28:32 lenny64guest1 kernel: [    0.441388] checking if image is initramfs... it is
May  5 02:28:32 lenny64guest1 kernel: [    0.926395] Freeing initrd memory: 6301k freed
May  5 02:28:32 lenny64guest1 kernel: [    0.930547] audit: initializing netlink socket (disabled)
May  5 02:28:32 lenny64guest1 kernel: [    0.931023] type=2000 audit(1241515668.928:1): initialized
May  5 02:28:32 lenny64guest1 kernel: [    0.933622] HugeTLB registered 2 MB page size, pre-allocated 0 pages
May  5 02:28:32 lenny64guest1 kernel: [    0.934503] VFS: Disk quotas dquot_6.5.2
May  5 02:28:32 lenny64guest1 kernel: [    0.934991] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
May  5 02:28:32 lenny64guest1 kernel: [    0.935593] msgmni has been set to 4027
May  5 02:28:32 lenny64guest1 kernel: [    0.936416] alg: No test for stdrng (krng)
May  5 02:28:32 lenny64guest1 kernel: [    0.938660] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
May  5 02:28:32 lenny64guest1 kernel: [    0.939371] io scheduler noop registered
May  5 02:28:32 lenny64guest1 kernel: [    0.939797] io scheduler anticipatory registered
May  5 02:28:32 lenny64guest1 kernel: [    0.940286] io scheduler deadline registered
May  5 02:28:32 lenny64guest1 kernel: [    0.940780] io scheduler cfq registered (default)
May  5 02:28:32 lenny64guest1 kernel: [    0.941243] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
May  5 02:28:32 lenny64guest1 kernel: [    0.941726] pci 0000:00:01.0: PIIX3: Enabling Passive Release
May  5 02:28:32 lenny64guest1 kernel: [    0.942212] pci 0000:00:01.0: Activating ISA DMA hang workarounds
May  5 02:28:32 lenny64guest1 kernel: [    0.951852] Linux agpgart interface v0.103
May  5 02:28:32 lenny64guest1 kernel: [    0.952359] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
May  5 02:28:32 lenny64guest1 kernel: [    0.953144] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
May  5 02:28:32 lenny64guest1 kernel: [    0.954426] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
May  5 02:28:32 lenny64guest1 kernel: [    0.958929] brd: module loaded
May  5 02:28:32 lenny64guest1 kernel: [    0.959769] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
May  5 02:28:32 lenny64guest1 kernel: [    0.981859] serio: i8042 KBD port at 0x60,0x64 irq 1
May  5 02:28:32 lenny64guest1 kernel: [    0.982333] serio: i8042 AUX port at 0x60,0x64 irq 12
May  5 02:28:32 lenny64guest1 kernel: [    0.982954] mice: PS/2 mouse device common for all mice
May  5 02:28:32 lenny64guest1 kernel: [    0.984137] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
May  5 02:28:32 lenny64guest1 kernel: [    0.984730] rtc0: alarms up to one day, 114 bytes nvram
May  5 02:28:32 lenny64guest1 kernel: [    0.985235] input: AT Translated Set 2 keyboard as /class/input/input0
May  5 02:28:32 lenny64guest1 kernel: [    0.985248] cpuidle: using governor ladder
May  5 02:28:32 lenny64guest1 kernel: [    0.985250] cpuidle: using governor menu
May  5 02:28:32 lenny64guest1 kernel: [    0.985258] No iBFT detected.
May  5 02:28:32 lenny64guest1 kernel: [    0.987658] TCP cubic registered
May  5 02:28:32 lenny64guest1 kernel: [    0.988031] NET: Registered protocol family 17
May  5 02:28:32 lenny64guest1 kernel: [    0.988871] registered taskstats version 1
May  5 02:28:32 lenny64guest1 kernel: [    0.989482] rtc_cmos 00:01: setting system clock to 2009-05-05 09:27:50 UTC (1241515670)
May  5 02:28:32 lenny64guest1 kernel: [    0.990244] Freeing unused kernel memory: 464k freed
May  5 02:28:32 lenny64guest1 kernel: [    1.065959] processor ACPI_CPU:00: registered as cooling_device0
May  5 02:28:32 lenny64guest1 kernel: [    1.066943] processor ACPI_CPU:01: registered as cooling_device1
May  5 02:28:32 lenny64guest1 kernel: [    1.325754] Uniform Multi-Platform E-IDE driver
May  5 02:28:32 lenny64guest1 kernel: [    1.330236] 8139too Fast Ethernet driver 0.9.28
May  5 02:28:32 lenny64guest1 kernel: [    1.330892] 8139too 0000:00:03.0: This (id 10ec:8139 rev 20) is an enhanced 8139C+ chip, use 8139cp
May  5 02:28:32 lenny64guest1 kernel: [    1.353440] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
May  5 02:28:32 lenny64guest1 kernel: [    1.354133] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI 11 (level, high) -> IRQ 11
May  5 02:28:32 lenny64guest1 kernel: [    1.357625] 8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
May  5 02:28:32 lenny64guest1 kernel: [    1.358629] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
May  5 02:28:32 lenny64guest1 kernel: [    1.359325] 8139cp 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, high) -> IRQ 10
May  5 02:28:32 lenny64guest1 kernel: [    1.364546] eth0: RTL-8139C+ at 0xffffc2000095a000, 52:54:00:12:34:56, IRQ 10
May  5 02:28:32 lenny64guest1 kernel: [    1.376837] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
May  5 02:28:32 lenny64guest1 kernel: [    1.377531] e1000e: Copyright (c) 1999-2008 Intel Corporation.
May  5 02:28:32 lenny64guest1 kernel: [    1.379590] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
May  5 02:28:32 lenny64guest1 kernel: [    1.380312] e1000e 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, high) -> IRQ 10
May  5 02:28:32 lenny64guest1 kernel: [    1.412931] FDC 0 is a S82078B
May  5 02:28:32 lenny64guest1 kernel: [    1.501860] 0000:00:05.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:e0:81:c0:90:b2
May  5 02:28:32 lenny64guest1 kernel: [    1.507930] 0000:00:05.0: eth1: Intel(R) PRO/1000 Network Connection
May  5 02:28:32 lenny64guest1 kernel: [    1.508792] 0000:00:05.0: eth1: MAC: 3, PHY: 8, PBA No: ffffff-0ff
May  5 02:28:32 lenny64guest1 kernel: [    1.509678] piix 0000:00:01.1: IDE controller (0x8086:0x7010 rev 0x00)
May  5 02:28:32 lenny64guest1 kernel: [    1.510771] piix 0000:00:01.1: not 100% native mode: will probe irqs later
May  5 02:28:32 lenny64guest1 kernel: [    1.511888]     ide0: BM-DMA at 0xc000-0xc007
May  5 02:28:32 lenny64guest1 kernel: [    1.512829]     ide1: BM-DMA at 0xc008-0xc00f
May  5 02:28:32 lenny64guest1 kernel: [    1.836303] hda: QEMU HARDDISK, ATA DISK drive
May  5 02:28:32 lenny64guest1 kernel: [    2.508387] hda: MWDMA2 mode selected
May  5 02:28:32 lenny64guest1 kernel: [    2.908184] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
May  5 02:28:32 lenny64guest1 kernel: [    3.580648] hdc: MWDMA2 mode selected
May  5 02:28:32 lenny64guest1 kernel: [    3.581712] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
May  5 02:28:32 lenny64guest1 kernel: [    3.582555] isa bounce pool size: 16 pages
May  5 02:28:32 lenny64guest1 kernel: [    3.583217] ide1 at 0x170-0x177,0x376 on irq 15
May  5 02:28:32 lenny64guest1 kernel: [    3.598520] SCSI subsystem initialized
May  5 02:28:32 lenny64guest1 kernel: [    3.647764] ide-gd driver 1.18
May  5 02:28:32 lenny64guest1 kernel: [    3.648715] hda: max request size: 512KiB
May  5 02:28:32 lenny64guest1 kernel: [    3.649620] hda: 16384000 sectors (8388 MB) w/256KiB Cache, CHS=16253/255/63
May  5 02:28:32 lenny64guest1 kernel: [    3.654805] ide-cd driver 5.00
May  5 02:28:32 lenny64guest1 kernel: [    3.656393] hda: cache flushes supported
May  5 02:28:32 lenny64guest1 kernel: [    3.657128]  hda: hda1 hda2 < hda5 >
May  5 02:28:32 lenny64guest1 kernel: [    3.660108] ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
May  5 02:28:32 lenny64guest1 kernel: [    3.663306] Uniform CD-ROM driver Revision: 3.20
May  5 02:28:32 lenny64guest1 kernel: [    3.782707] PM: Starting manual resume from disk
May  5 02:28:32 lenny64guest1 kernel: [    3.803032] EXT3-fs: INFO: recovery required on readonly filesystem.
May  5 02:28:32 lenny64guest1 kernel: [    3.803751] EXT3-fs: write access will be enabled during recovery.
May  5 02:28:32 lenny64guest1 kernel: [    5.302058] kjournald starting.  Commit interval 5 seconds
May  5 02:28:32 lenny64guest1 kernel: [    5.302090] EXT3-fs: recovery complete.
May  5 02:28:32 lenny64guest1 kernel: [    5.308821] EXT3-fs: mounted filesystem with ordered data mode.
May  5 02:28:32 lenny64guest1 kernel: [    5.532342] udevd version 125 started
May  5 02:28:32 lenny64guest1 kernel: [    5.925537] input: Power Button (FF) as /class/input/input1
May  5 02:28:32 lenny64guest1 kernel: [    5.956326] ACPI: Power Button (FF) [PWRF]
May  5 02:28:32 lenny64guest1 kernel: [    5.966591] parport_pc 00:05: reported by Plug and Play ACPI
May  5 02:28:32 lenny64guest1 kernel: [    5.967403] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
May  5 02:28:32 lenny64guest1 kernel: [    6.090639] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, revision 0
May  5 02:28:32 lenny64guest1 kernel: [    6.092050] input: PC Speaker as /class/input/input2
May  5 02:28:32 lenny64guest1 kernel: [    6.246113] input: ImExPS/2 Generic Explorer Mouse as /class/input/input3
May  5 02:28:32 lenny64guest1 kernel: [   37.729720] Adding 393552k swap on /dev/hda5.  Priority:-1 extents:1 across:393552k 
May  5 02:28:32 lenny64guest1 kernel: [   37.771561] EXT3 FS on hda1, internal journal
May  5 02:28:32 lenny64guest1 kernel: [   38.776656] loop: module loaded
May  5 02:28:32 lenny64guest1 kernel: [   39.898636] eth0: link up, 100Mbps, full-duplex, lpa 0x05E1
May  5 02:28:32 lenny64guest1 rsyslogd: [origin software="rsyslogd" swVersion="3.18.6" x-pid="1860" x-info="http://www.rsyslog.com"] restart
May  5 02:28:32 lenny64guest1 kernel: [   42.938673] NET: Registered protocol family 10
May  5 02:28:32 lenny64guest1 kernel: [   42.940835] lo: Disabled Privacy Extensions
May  5 02:28:32 lenny64guest1 /usr/sbin/gpm[2164]: *** info [daemon/startup.c(131)]: 
May  5 02:28:32 lenny64guest1 /usr/sbin/gpm[2164]: Started gpm successfully. Entered daemon mode.
May  5 02:28:51 lenny64guest1 kernel: [   62.496984] ADDRCONF(NETDEV_UP): eth1_rename: link is not ready
May  5 02:28:54 lenny64guest1 kernel: [   65.456923] e1000e: eth1_rename NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
May  5 02:28:54 lenny64guest1 kernel: [   65.458496] ADDRCONF(NETDEV_CHANGE): eth1_rename: link becomes ready
May  5 02:29:09 lenny64guest1 kernel: [   79.929586] TARGET_CORE[0]: Loading Generic Kernel Storage Engine: v3.0.0 on Linux/x86_64 on 2.6.29.2
May  5 02:29:09 lenny64guest1 kernel: [   79.931101] TARGET_CORE[0]: Initialized ConfigFS Fabric Infrastructure: v1.0.0 on Linux/x86_64 on 2.6.29.2
May  5 02:29:09 lenny64guest1 kernel: [   79.932245] SE_PC[0] - Registered Plugin Class: TRANSPORT
May  5 02:29:09 lenny64guest1 kernel: [   79.932912] PLUGIN_TRANSPORT[1] - pscsi registered
May  5 02:29:09 lenny64guest1 kernel: [   79.933553] PLUGIN_TRANSPORT[2] - stgt registered
May  5 02:29:09 lenny64guest1 kernel: [   79.934258] CORE_STGT[0]: Bus Initalization complete
May  5 02:29:09 lenny64guest1 kernel: [   79.934258] PLUGIN_TRANSPORT[4] - iblock registered
May  5 02:29:09 lenny64guest1 kernel: [   79.934258] PLUGIN_TRANSPORT[5] - rd_dr registered
May  5 02:29:09 lenny64guest1 kernel: [   79.937936] PLUGIN_TRANSPORT[6] - rd_mcp registered
May  5 02:29:09 lenny64guest1 kernel: [   79.938882] PLUGIN_TRANSPORT[7] - fileio registered
May  5 02:29:09 lenny64guest1 kernel: [   79.939821] SE_PC[1] - Registered Plugin Class: OBJ
May  5 02:29:09 lenny64guest1 kernel: [   79.940767] PLUGIN_OBJ[1] - dev registered
May  5 02:29:09 lenny64guest1 kernel: [   79.945344] Target_Core_ConfigFS: Located se_plugin: ffff88007c0998e0 plugin_name: iblock hba_type: 4 plugin_dep_id: 0
May  5 02:29:09 lenny64guest1 kernel: [   79.947103] CORE_HBA[0] - Linux-iSCSI.org iBlock HBA Driver 3.0 on Generic Target Core Stack v3.0
May  5 02:29:09 lenny64guest1 kernel: [   79.948871] CORE_HBA[0] - Attached iBlock HBA: 0 to Generic Target Core TCQ Depth: 512
May  5 02:29:09 lenny64guest1 kernel: [   79.950432] CORE_HBA[0] - Attached HBA to Generic Target Core
May  5 02:29:09 lenny64guest1 kernel: [   79.951431] IBLOCK: Allocated ib_dev for lvm_test0
May  5 02:29:09 lenny64guest1 kernel: [   79.952349] Target_Core_ConfigFS: Allocated se_subsystem_dev_t: ffff880037815000 se_dev_su_ptr: ffff88007d07c400
May  5 02:29:09 lenny64guest1 kernel: [   79.952849] Target_Core_ConfigFS: Set emulated VPD Unit Serial: a97e4ce21c0711de829b000c2943d57b
May  5 02:29:09 lenny64guest1 kernel: [   79.957608] Target_Core_ConfigFS: Located se_plugin: ffff88007c099918 plugin_name: rd_dr hba_type: 5 plugin_dep_id: 0
May  5 02:29:09 lenny64guest1 kernel: [   79.958789] CORE_HBA[1] - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0
May  5 02:29:09 lenny64guest1 kernel: [   79.959887] CORE_HBA[1] - Attached Ramdisk HBA: 0 to Generic Target Core TCQ Depth: 256 MaxSectors: 1024
May  5 02:29:09 lenny64guest1 kernel: [   79.961070] CORE_HBA[1] - Attached HBA to Generic Target Core
May  5 02:29:09 lenny64guest1 kernel: [   79.961978] Target_Core_ConfigFS: Allocated se_subsystem_dev_t: ffff88007c9df000 se_dev_su_ptr: ffff88007bc0c6c0
May  5 02:29:09 lenny64guest1 kernel: [   79.963398] RAMDISK: Referencing Page Count: 32768
May  5 02:29:09 lenny64guest1 kernel: [   79.976051] CORE_RD[0] - Built Ramdisk Device ID: 0 space of 32768 pages in 17 tables
May  5 02:29:09 lenny64guest1 kernel: [   79.976051] rd_dr: Using SPC3_PERSISTENT_RESERVATIONS emulation
May  5 02:29:09 lenny64guest1 kernel: [   79.976051] rd_dr: Enabling ALUA Emulation for SPC-3 device
May  5 02:29:09 lenny64guest1 kernel: [   79.980565] rd_dr: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
May  5 02:29:09 lenny64guest1 kernel: [   79.982113] CORE_RD[0] - Activating Device with TCQ: 0 at Ramdisk Device ID: 0
May  5 02:29:09 lenny64guest1 kernel: [   79.983881]   Vendor: LIO-ORG   Model: RAMDISK-DR        Revision: 3.0 
May  5 02:29:09 lenny64guest1 kernel: [   79.991110]   Type:   Direct-Access                      ANSI SCSI revision: 05
May  5 02:29:09 lenny64guest1 kernel: [   79.993190] T10 VPD Unit Serial Number: 1234567890:1_0
May  5 02:29:09 lenny64guest1 kernel: [   79.994236] T10 VPD Page Length: 38
May  5 02:29:09 lenny64guest1 kernel: [   79.995091] T10 VPD Identifer Length: 34
May  5 02:29:09 lenny64guest1 kernel: [   79.995778] T10 VPD Identifier Association: addressed logical unit
May  5 02:29:09 lenny64guest1 kernel: [   79.996560] T10 VPD Identifier Type: T10 Vendor ID based
May  5 02:29:09 lenny64guest1 kernel: [   79.997212] T10 VPD ASCII Device Identifier: LIO-ORG
May  5 02:29:09 lenny64guest1 kernel: [   79.997920] CORE_RD[0] - Added LIO DIRECT Ramdisk Device ID: 0 of 32768 pages in 17 tables, 134217728 total bytes
May  5 02:29:09 lenny64guest1 kernel: [   79.999089] Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: ffff88007d0a2c00
May  5 02:29:09 lenny64guest1 kernel: [   80.001332] Target_Core_ConfigFS: Located se_plugin: ffff88007c099918 plugin_name: rd_dr hba_type: 5 plugin_dep_id: 1
May  5 02:29:09 lenny64guest1 kernel: [   80.002518] CORE_HBA[2] - Linux-iSCSI.org Ramdisk HBA Driver v3.0 on Generic Target Core Stack v3.0
May  5 02:29:09 lenny64guest1 kernel: [   80.003617] CORE_HBA[2] - Attached Ramdisk HBA: 1 to Generic Target Core TCQ Depth: 256 MaxSectors: 1024
May  5 02:29:09 lenny64guest1 kernel: [   80.006041] CORE_HBA[2] - Attached HBA to Generic Target Core
May  5 02:29:09 lenny64guest1 kernel: [   80.007061] Target_Core_ConfigFS: Allocated se_subsystem_dev_t: ffff88007d1c4000 se_dev_su_ptr: ffff88007d098340
May  5 02:29:09 lenny64guest1 kernel: [   80.009412] RAMDISK: Referencing Page Count: 32768
May  5 02:29:09 lenny64guest1 kernel: [   80.020030] CORE_RD[1] - Built Ramdisk Device ID: 0 space of 32768 pages in 17 tables
May  5 02:29:09 lenny64guest1 kernel: [   80.020030] rd_dr: Using SPC3_PERSISTENT_RESERVATIONS emulation
May  5 02:29:09 lenny64guest1 kernel: [   80.020030] rd_dr: Enabling ALUA Emulation for SPC-3 device
May  5 02:29:09 lenny64guest1 kernel: [   80.024538] rd_dr: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
May  5 02:29:09 lenny64guest1 kernel: [   80.026042] CORE_RD[1] - Activating Device with TCQ: 0 at Ramdisk Device ID: 0
May  5 02:29:09 lenny64guest1 kernel: [   80.027331]   Vendor: LIO-ORG   Model: RAMDISK-DR        Revision: 3.0 
May  5 02:29:09 lenny64guest1 kernel: [   80.033340]   Type:   Direct-Access                      ANSI SCSI revision: 05
May  5 02:29:09 lenny64guest1 kernel: [   80.034768] T10 VPD Unit Serial Number: 1234567890:2_0
May  5 02:29:09 lenny64guest1 kernel: [   80.035481] T10 VPD Page Length: 38
May  5 02:29:09 lenny64guest1 kernel: [   80.036056] T10 VPD Identifer Length: 34
May  5 02:29:09 lenny64guest1 kernel: [   80.038286] T10 VPD Identifier Association: addressed logical unit
May  5 02:29:09 lenny64guest1 kernel: [   80.039292] T10 VPD Identifier Type: T10 Vendor ID based
May  5 02:29:09 lenny64guest1 kernel: [   80.040024] T10 VPD ASCII Device Identifier: LIO-ORG
May  5 02:29:09 lenny64guest1 kernel: [   80.040822] CORE_RD[1] - Added LIO DIRECT Ramdisk Device ID: 0 of 32768 pages in 17 tables, 134217728 total bytes
May  5 02:29:09 lenny64guest1 kernel: [   80.041995] Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: ffff88007d0a2800
May  5 02:29:09 lenny64guest1 kernel: [   80.044313] Target_Core_ConfigFS: Located se_plugin: ffff88007c099988 plugin_name: fileio hba_type: 7 plugin_dep_id: 0
May  5 02:29:09 lenny64guest1 kernel: [   80.045498] CORE_HBA[3] - Linux-iSCSI.org FILEIO HBA Driver 3.0 on Generic Target Core Stack v3.0
May  5 02:29:09 lenny64guest1 kernel: [   80.046583] CORE_HBA[3] - Attached FILEIO HBA: 0 to Generic Target Core with TCQ Depth: 256 MaxSectors: 1024
May  5 02:29:09 lenny64guest1 kernel: [   80.047703] CORE_HBA[3] - Attached HBA to Generic Target Core
May  5 02:29:09 lenny64guest1 kernel: [   80.048833] FILEIO: Allocated fd_dev for ffff88007cd1cce0
May  5 02:29:09 lenny64guest1 kernel: [   80.049485] Target_Core_ConfigFS: Allocated se_subsystem_dev_t: ffff88007d14b800 se_dev_su_ptr: ffff88007d147a00
May  5 02:29:09 lenny64guest1 kernel: [   80.050974] FILEIO: Referencing Path: /tmp/fileio
May  5 02:29:09 lenny64guest1 kernel: [   80.051621] FILEIO: Referencing Size: 134217728 bytes
May  5 02:29:09 lenny64guest1 kernel: [   80.673775] fileio: Using SPC3_PERSISTENT_RESERVATIONS emulation
May  5 02:29:09 lenny64guest1 kernel: [   80.674485] fileio: Enabling ALUA Emulation for SPC-3 device
May  5 02:29:09 lenny64guest1 kernel: [   80.712769] fileio: Adding to default ALUA LU Group: core/alua/lu_gps/default_lu_gp
May  5 02:29:10 lenny64guest1 kernel: [   80.714302] CORE_FILE[0] - Activating Device with TCQ: 0 at FILEIO Device ID: 0
May  5 02:29:10 lenny64guest1 kernel: [   80.716272]   Vendor: LIO-ORG   Model: FILEIO            Revision: 3.0 
May  5 02:29:10 lenny64guest1 kernel: [   80.720275]   Type:   Direct-Access                      ANSI SCSI revision: 05
May  5 02:29:10 lenny64guest1 kernel: [   80.722177] T10 VPD Unit Serial Number: 1234567890:3_0
May  5 02:29:10 lenny64guest1 kernel: [   80.722949] T10 VPD Page Length: 34
May  5 02:29:10 lenny64guest1 kernel: [   80.723541] T10 VPD Identifer Length: 30
May  5 02:29:10 lenny64guest1 kernel: [   80.725526] T10 VPD Identifier Association: addressed logical unit
May  5 02:29:10 lenny64guest1 kernel: [   80.726558] T10 VPD Identifier Type: T10 Vendor ID based
May  5 02:29:10 lenny64guest1 kernel: [   80.726946] T10 VPD ASCII Device Identifier: LIO-ORG
May  5 02:29:10 lenny64guest1 kernel: [   80.728696] CORE_FILE[0] - Added LIO FILEIO Device ID: 0 at /tmp/fileio, 134217728 total bytes
May  5 02:29:10 lenny64guest1 kernel: [   80.730293] Target_Core_ConfigFS: Registered se_dev->se_dev_ptr: ffff88007d0a2400
May  5 02:29:10 lenny64guest1 kernel: [   80.733419] Target_Core_ConfigFS: REGISTER -> group: ffffffffa026c100 name: iscsi
May  5 02:29:10 lenny64guest1 kernel: [   80.748954] Linux-iSCSI.org iSCSI Target Core Stack v3.0.0 on Linux/x86_64 on 2.6.29.2
May  5 02:29:10 lenny64guest1 kernel: [   80.750055] <<<<<<<<<<<<<<<<<<<<<< BEGIN FABRIC API >>>>>>>>>>>>>>>>>>>>>>
May  5 02:29:10 lenny64guest1 kernel: [   80.750791] Initialized struct target_fabric_configfs: ffff88007d147800 for iscsi
May  5 02:29:10 lenny64guest1 kernel: [   80.751827] <<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>>>>>>
May  5 02:29:10 lenny64guest1 kernel: [   80.752601] LIO_TARGET[0] - Set fabric -> lio_target_fabric_configfs
May  5 02:29:10 lenny64guest1 kernel: [   80.753873] iscsi_allocate_thread_sets:195: ***OPS*** Spawned 4 thread set(s) (8 total threads).
May  5 02:29:10 lenny64guest1 kernel: [   80.755251] TARGET_CORE[iSCSI]: Allocated Discovery se_portal_group_t for endpoint: None, Portal Tag: 0
May  5 02:29:10 lenny64guest1 kernel: [   80.757870] CORE[0] - Allocated Discovery TPG
May  5 02:29:10 lenny64guest1 kernel: [   80.757870] Loading Complete.
May  5 02:29:10 lenny64guest1 kernel: [   80.759798] Target_Core_ConfigFS: REGISTER -> Located fabric: iscsi
May  5 02:29:10 lenny64guest1 kernel: [   80.760549] Target_Core_ConfigFS: REGISTER -> ffffffffa02a9bb0
May  5 02:29:10 lenny64guest1 kernel: [   80.761237] Target_Core_ConfigFS: REGISTER -> Allocated Fabric: iscsi
May  5 02:29:10 lenny64guest1 kernel: [   80.761932] Target_Core_ConfigFS: REGISTER -> Set tf->tf_fabric for iscsi
May  5 02:29:10 lenny64guest1 kernel: [   80.762679] lio_target_call_coreaddtiqn(): name: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:10 lenny64guest1 kernel: [   80.763893] CORE[0] - Added iSCSI Target IQN: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:10 lenny64guest1 kernel: [   80.764541] LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:10 lenny64guest1 kernel: [   80.764541] LIO_Target_ConfigFS: REGISTER -> Allocated Node: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:10 lenny64guest1 kernel: [   80.764541] lio_target_tiqn_addtpg() called: name tpgt_1
May  5 02:29:10 lenny64guest1 kernel: [   80.768137] lio_target_tiqn_addtpg() parent name: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:10 lenny64guest1 kernel: [   80.769307] lio_target_tiqn_addtpg() Using TPGT: 1
May  5 02:29:10 lenny64guest1 kernel: [   80.770009] TARGET_CORE[iSCSI]: Allocated Normal se_portal_group_t for endpoint: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6, Portal Tag: 1
May  5 02:29:10 lenny64guest1 kernel: [   80.771648] CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6]_TPG[1] - Added iSCSI Target Portal Group
May  5 02:29:10 lenny64guest1 kernel: [   80.772875] LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:10 lenny64guest1 kernel: [   80.774023] LIO_Target_ConfigFS: REGISTER -> Allocated TPG: tpgt_1
May  5 02:29:10 lenny64guest1 kernel: [   80.774757] LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1 PORTAL: 192.168.0.117:3260
May  5 02:29:10 lenny64guest1 kernel: [   80.776859] CORE[0] - Added Network Portal: 192.168.0.117:3260 on TCP on network device: None
May  5 02:29:10 lenny64guest1 kernel: [   80.776867] CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6] - Added Network Portal: 192.168.0.117:3260,1 on TCP on network device: None
May  5 02:29:10 lenny64guest1 kernel: [   80.776867] CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6]_TPG[1] - Incremented np_exports to 1
May  5 02:29:10 lenny64guest1 kernel: [   80.780812] LIO_Target_ConfigFS: addnptotpg done!
May  5 02:29:10 lenny64guest1 kernel: [   80.850607] SCTP: Hash tables configured (established 65536 bind 65536)
May  5 02:29:10 lenny64guest1 kernel: [   80.941016] CORE[0] - Added Network Portal: 192.168.0.117:3260 on SCTP on network device: None
May  5 02:29:10 lenny64guest1 kernel: [   80.942266] CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6] - Added Network Portal: 192.168.0.117:3260,1 on SCTP on network device: None
May  5 02:29:10 lenny64guest1 kernel: [   80.943884] CORE[iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6]_TPG[1] - Incremented np_exports to 1
May  5 02:29:10 lenny64guest1 kernel: [   80.946683] LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1 LUN: 0
May  5 02:29:10 lenny64guest1 kernel: [   80.949105] rd_dr/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
May  5 02:29:10 lenny64guest1 kernel: [   80.950587] iSCSI_TPG[1]_LUN[0] - Activated iSCSI Logical Unit from CORE HBA: 1
May  5 02:29:10 lenny64guest1 kernel: [   80.951611] LIO_Target_ConfigFS: Created Port Symlink ramdisk -> lun_0
May  5 02:29:10 lenny64guest1 kernel: [   80.953594] LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1 LUN: 1
May  5 02:29:10 lenny64guest1 kernel: [   80.955813] rd_dr/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
May  5 02:29:10 lenny64guest1 kernel: [   80.958695] iSCSI_TPG[1]_LUN[1] - Activated iSCSI Logical Unit from CORE HBA: 2
May  5 02:29:10 lenny64guest1 kernel: [   80.959736] LIO_Target_ConfigFS: Created Port Symlink ramdisk -> lun_1
May  5 02:29:10 lenny64guest1 kernel: [   80.960956] Disabling iSCSI Authentication Methods for TPG: 1.
May  5 02:29:10 lenny64guest1 kernel: [   80.962059] iSCSI_TPG[1] - Generate Initiator Portal Group ACLs: Enabled
May  5 02:29:10 lenny64guest1 kernel: [   80.962684] iSCSI_TPG[1] - Demo Mode Write Protect bit: OFF
May  5 02:29:10 lenny64guest1 kernel: [   80.962684] iSCSI_TPG[1] - Set Default CmdSN TCQ Depth to 4
May  5 02:29:10 lenny64guest1 kernel: [   80.964587] iSCSI_TPG[1] - Enabled iSCSI Target Portal Group
May  5 02:29:11 lenny64guest1 kernel: [   82.024298] Received iSCSI login request from 192.168.0.113 on TCP Network Portal 192.168.0.117:3260
May  5 02:29:11 lenny64guest1 kernel: [   82.025462] Located Storage Object: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:11 lenny64guest1 kernel: [   82.026588] Located Portal Group Object: 1
May  5 02:29:11 lenny64guest1 kernel: [   82.027224] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:29:11 lenny64guest1 kernel: [   82.028240] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:29:11 lenny64guest1 kernel: [   82.028240] iSCSI_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 4 for iSCSI Initiator Node: iqn.1994-05.com.fedora:8a8f1b7baf9b
May  5 02:29:11 lenny64guest1 kernel: [   82.028240] ------------------------------------------------------------------
May  5 02:29:11 lenny64guest1 kernel: [   82.028240] HeaderDigest:                 None
May  5 02:29:11 lenny64guest1 kernel: [   82.032492] DataDigest:                   None
May  5 02:29:11 lenny64guest1 kernel: [   82.033124] MaxRecvDataSegmentLength:     131072
May  5 02:29:11 lenny64guest1 kernel: [   82.033752] IFMarker:                     No
May  5 02:29:11 lenny64guest1 kernel: [   82.034368] OFMarker:                     No
May  5 02:29:11 lenny64guest1 kernel: [   82.034979] ------------------------------------------------------------------
May  5 02:29:11 lenny64guest1 kernel: [   82.036003] ------------------------------------------------------------------
May  5 02:29:11 lenny64guest1 kernel: [   82.036467] MaxConnections:               1
May  5 02:29:11 lenny64guest1 kernel: [   82.036467] TargetName:                   iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:11 lenny64guest1 kernel: [   82.036467] InitiatorName:                iqn.1994-05.com.fedora:8a8f1b7baf9b
May  5 02:29:11 lenny64guest1 kernel: [   82.036467] TargetAlias:                  LIO Target
May  5 02:29:11 lenny64guest1 kernel: [   82.041606] InitiatorAlias:               barret.risingtidesystems.com
May  5 02:29:11 lenny64guest1 kernel: [   82.042303] TargetPortalGroupTag:         1
May  5 02:29:11 lenny64guest1 kernel: [   82.042900] InitialR2T:                   Yes
May  5 02:29:11 lenny64guest1 kernel: [   82.043515] ImmediateData:                Yes
May  5 02:29:11 lenny64guest1 kernel: [   82.044127] MaxBurstLength:               262144
May  5 02:29:11 lenny64guest1 kernel: [   82.044755] FirstBurstLength:             65536
May  5 02:29:11 lenny64guest1 kernel: [   82.045387] DefaultTime2Wait:             2
May  5 02:29:11 lenny64guest1 kernel: [   82.045597] DefaultTime2Retain:           0
May  5 02:29:11 lenny64guest1 kernel: [   82.045597] MaxOutstandingR2T:            1
May  5 02:29:11 lenny64guest1 kernel: [   82.045597] DataPDUInOrder:               Yes
May  5 02:29:11 lenny64guest1 kernel: [   82.045597] DataSequenceInOrder:          Yes
May  5 02:29:11 lenny64guest1 kernel: [   82.048504] ErrorRecoveryLevel:           0
May  5 02:29:11 lenny64guest1 kernel: [   82.049117] SessionType:                  Normal
May  5 02:29:11 lenny64guest1 kernel: [   82.049745] ------------------------------------------------------------------
May  5 02:29:11 lenny64guest1 kernel: [   82.050770] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr: ffff8800684eae00
May  5 02:29:11 lenny64guest1 kernel: [   82.051506] iSCSI Login successful on CID: 0 from 192.168.0.113 to 192.168.0.117:3260,1
May  5 02:29:11 lenny64guest1 kernel: [   82.052497] Incremented iSCSI Connection count to 1 from node: iqn.1994-05.com.fedora:8a8f1b7baf9b
May  5 02:29:11 lenny64guest1 kernel: [   82.052497] Established iSCSI session from node: iqn.1994-05.com.fedora:8a8f1b7baf9b
May  5 02:29:11 lenny64guest1 kernel: [   82.052497] Incremented number of active iSCSI sessions to 1 on iSCSI Target Portal Group: 1
May  5 02:29:15 lenny64guest1 kernel: [   86.372863] Received iSCSI login request from 192.168.0.111 on TCP Network Portal 192.168.0.117:3260
May  5 02:29:15 lenny64guest1 kernel: [   86.375964] Located Storage Object: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:15 lenny64guest1 kernel: [   86.377124] Located Portal Group Object: 1
May  5 02:29:15 lenny64guest1 kernel: [   86.377746] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:29:15 lenny64guest1 kernel: [   86.378832] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:29:15 lenny64guest1 kernel: [   86.379914] iSCSI_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 4 for iSCSI Initiator Node: iqn.1993-08.org.debian:01:2dadf92d0ef
May  5 02:29:15 lenny64guest1 kernel: [   86.381340] ------------------------------------------------------------------
May  5 02:29:15 lenny64guest1 kernel: [   86.382383] HeaderDigest:                 None
May  5 02:29:15 lenny64guest1 kernel: [   86.383006] DataDigest:                   None
May  5 02:29:15 lenny64guest1 kernel: [   86.383631] MaxRecvDataSegmentLength:     131072
May  5 02:29:15 lenny64guest1 kernel: [   86.384299] IFMarker:                     No
May  5 02:29:15 lenny64guest1 kernel: [   86.386330] OFMarker:                     No
May  5 02:29:15 lenny64guest1 kernel: [   86.387210] ------------------------------------------------------------------
May  5 02:29:15 lenny64guest1 kernel: [   86.388855] ------------------------------------------------------------------
May  5 02:29:15 lenny64guest1 kernel: [   86.390364] MaxConnections:               1
May  5 02:29:15 lenny64guest1 kernel: [   86.391253] TargetName:                   iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:29:15 lenny64guest1 kernel: [   86.392956] InitiatorName:                iqn.1993-08.org.debian:01:2dadf92d0ef
May  5 02:29:15 lenny64guest1 kernel: [   86.394463] TargetAlias:                  LIO Target
May  5 02:29:15 lenny64guest1 kernel: [   86.395392] InitiatorAlias:               ubuntu
May  5 02:29:15 lenny64guest1 kernel: [   86.396342] TargetPortalGroupTag:         1
May  5 02:29:15 lenny64guest1 kernel: [   86.397233] InitialR2T:                   Yes
May  5 02:29:15 lenny64guest1 kernel: [   86.398123] ImmediateData:                Yes
May  5 02:29:15 lenny64guest1 kernel: [   86.399022] MaxBurstLength:               262144
May  5 02:29:15 lenny64guest1 kernel: [   86.399931] FirstBurstLength:             65536
May  5 02:29:15 lenny64guest1 kernel: [   86.400883] DefaultTime2Wait:             2
May  5 02:29:15 lenny64guest1 kernel: [   86.401765] DefaultTime2Retain:           0
May  5 02:29:15 lenny64guest1 kernel: [   86.402651] MaxOutstandingR2T:            1
May  5 02:29:15 lenny64guest1 kernel: [   86.403530] DataPDUInOrder:               Yes
May  5 02:29:15 lenny64guest1 kernel: [   86.404488] DataSequenceInOrder:          Yes
May  5 02:29:15 lenny64guest1 kernel: [   86.405396] ErrorRecoveryLevel:           0
May  5 02:29:15 lenny64guest1 kernel: [   86.406292] SessionType:                  Normal
May  5 02:29:15 lenny64guest1 kernel: [   86.407194] ------------------------------------------------------------------
May  5 02:29:15 lenny64guest1 kernel: [   86.408831] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr: ffff8800684ea000
May  5 02:29:15 lenny64guest1 kernel: [   86.409885] iSCSI Login successful on CID: 0 from 192.168.0.111 to 192.168.0.117:3260,1
May  5 02:29:15 lenny64guest1 kernel: [   86.411396] Incremented iSCSI Connection count to 1 from node: iqn.1993-08.org.debian:01:2dadf92d0ef
May  5 02:29:15 lenny64guest1 kernel: [   86.412540] Established iSCSI session from node: iqn.1993-08.org.debian:01:2dadf92d0ef
May  5 02:29:15 lenny64guest1 kernel: [   86.413606] Incremented number of active iSCSI sessions to 2 on iSCSI Target Portal Group: 1
May  5 02:36:08 lenny64guest1 kernel: [  499.471422] Received iSCSI login request from 192.168.0.116 on TCP Network Portal 192.168.0.117:3260
May  5 02:36:08 lenny64guest1 kernel: [  499.472848] ------------------------------------------------------------------
May  5 02:36:08 lenny64guest1 kernel: [  499.474097] HeaderDigest:                 None
May  5 02:36:08 lenny64guest1 kernel: [  499.474888] DataDigest:                   None
May  5 02:36:08 lenny64guest1 kernel: [  499.475521] MaxRecvDataSegmentLength:     8192
May  5 02:36:08 lenny64guest1 kernel: [  499.476154] IFMarker:                     No
May  5 02:36:08 lenny64guest1 kernel: [  499.476769] OFMarker:                     No
May  5 02:36:08 lenny64guest1 kernel: [  499.477515] ------------------------------------------------------------------
May  5 02:36:08 lenny64guest1 kernel: [  499.478703] ------------------------------------------------------------------
May  5 02:36:08 lenny64guest1 kernel: [  499.479745] InitiatorName:                iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:08 lenny64guest1 kernel: [  499.480845] TargetAlias:                  LIO Target
May  5 02:36:08 lenny64guest1 kernel: [  499.481612] InitiatorAlias:               subjekt
May  5 02:36:08 lenny64guest1 kernel: [  499.482249] TargetPortalGroupTag:         1
May  5 02:36:08 lenny64guest1 kernel: [  499.482870] DefaultTime2Wait:             2
May  5 02:36:08 lenny64guest1 kernel: [  499.483481] DefaultTime2Retain:           0
May  5 02:36:08 lenny64guest1 kernel: [  499.484122] ErrorRecoveryLevel:           0
May  5 02:36:08 lenny64guest1 kernel: [  499.484744] SessionType:                  Discovery
May  5 02:36:08 lenny64guest1 kernel: [  499.485461] ------------------------------------------------------------------
May  5 02:36:08 lenny64guest1 kernel: [  499.486714] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr: ffff8800684ea800
May  5 02:36:08 lenny64guest1 kernel: [  499.487451] iSCSI Login successful on CID: 0 from 192.168.0.116 to 192.168.0.117:3260,0
May  5 02:36:08 lenny64guest1 kernel: [  499.488654] Incremented iSCSI Connection count to 1 from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:08 lenny64guest1 kernel: [  499.489930] Established iSCSI session from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:08 lenny64guest1 kernel: [  499.491234] Incremented number of active iSCSI sessions to 1 on iSCSI Target Portal Group: 0
May  5 02:36:08 lenny64guest1 kernel: [  499.492724] iscsi_allocate_thread_sets:195: ***OPS*** Spawned 1 thread set(s) (2 total threads).
May  5 02:36:10 lenny64guest1 kernel: [  501.689089] Decremented iSCSI connection count to 0 from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:10 lenny64guest1 kernel: [  501.690948] TARGET_CORE[iSCSI]: Deregistered fabric_sess
May  5 02:36:10 lenny64guest1 kernel: [  501.691656] Released iSCSI session from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:10 lenny64guest1 kernel: [  501.692786] Decremented number of active iSCSI Sessions on iSCSI TPG: 0 to 0
May  5 02:36:30 lenny64guest1 kernel: [  521.627616] Received iSCSI login request from 192.168.0.116 on TCP Network Portal 192.168.0.117:3260
May  5 02:36:30 lenny64guest1 kernel: [  521.628783] Located Storage Object: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:36:30 lenny64guest1 kernel: [  521.629991] Located Portal Group Object: 1
May  5 02:36:30 lenny64guest1 kernel: [  521.630686] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:36:30 lenny64guest1 kernel: [  521.631786] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:36:30 lenny64guest1 kernel: [  521.632880] iSCSI_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 4 for iSCSI Initiator Node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:30 lenny64guest1 kernel: [  521.634266] ------------------------------------------------------------------
May  5 02:36:30 lenny64guest1 kernel: [  521.635322] HeaderDigest:                 None
May  5 02:36:30 lenny64guest1 kernel: [  521.635954] DataDigest:                   None
May  5 02:36:30 lenny64guest1 kernel: [  521.636584] MaxRecvDataSegmentLength:     131072
May  5 02:36:30 lenny64guest1 kernel: [  521.637222] IFMarker:                     No
May  5 02:36:30 lenny64guest1 kernel: [  521.637863] OFMarker:                     No
May  5 02:36:30 lenny64guest1 kernel: [  521.638562] ------------------------------------------------------------------
May  5 02:36:30 lenny64guest1 kernel: [  521.639665] ------------------------------------------------------------------
May  5 02:36:30 lenny64guest1 kernel: [  521.641312] MaxConnections:               1
May  5 02:36:30 lenny64guest1 kernel: [  521.643701] TargetName:                   iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:36:30 lenny64guest1 kernel: [  521.644866] InitiatorName:                iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:30 lenny64guest1 kernel: [  521.646013] TargetAlias:                  LIO Target
May  5 02:36:30 lenny64guest1 kernel: [  521.658853] InitiatorAlias:               subjekt
May  5 02:36:30 lenny64guest1 kernel: [  521.659506] TargetPortalGroupTag:         1
May  5 02:36:30 lenny64guest1 kernel: [  521.660109] InitialR2T:                   Yes
May  5 02:36:30 lenny64guest1 kernel: [  521.660733] ImmediateData:                Yes
May  5 02:36:30 lenny64guest1 kernel: [  521.661393] MaxBurstLength:               262144
May  5 02:36:30 lenny64guest1 kernel: [  521.662079] FirstBurstLength:             65536
May  5 02:36:30 lenny64guest1 kernel: [  521.662722] DefaultTime2Wait:             2
May  5 02:36:30 lenny64guest1 kernel: [  521.663354] DefaultTime2Retain:           0
May  5 02:36:30 lenny64guest1 kernel: [  521.663971] MaxOutstandingR2T:            1
May  5 02:36:30 lenny64guest1 kernel: [  521.664603] DataPDUInOrder:               Yes
May  5 02:36:30 lenny64guest1 kernel: [  521.665256] DataSequenceInOrder:          Yes
May  5 02:36:30 lenny64guest1 kernel: [  521.666121] ErrorRecoveryLevel:           0
May  5 02:36:30 lenny64guest1 kernel: [  521.666736] SessionType:                  Normal
May  5 02:36:30 lenny64guest1 kernel: [  521.667373] ------------------------------------------------------------------
May  5 02:36:30 lenny64guest1 kernel: [  521.668445] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr: ffff8800684ea200
May  5 02:36:30 lenny64guest1 kernel: [  521.669193] iSCSI Login successful on CID: 0 from 192.168.0.116 to 192.168.0.117:3260,1
May  5 02:36:30 lenny64guest1 kernel: [  521.670354] Incremented iSCSI Connection count to 1 from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:30 lenny64guest1 kernel: [  521.671467] Established iSCSI session from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:36:30 lenny64guest1 kernel: [  521.672538] Incremented number of active iSCSI sessions to 3 on iSCSI Target Portal Group: 1
May  5 02:48:48 lenny64guest1 kernel: [ 1259.452732] LIO_Target_ConfigFS: REGISTER -> iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6 TPGT: 1 LUN: 2
May  5 02:49:01 lenny64guest1 kernel: [ 1272.273663] fileio/iSCSI: Adding to default ALUA Target Port Group: core/alua/tg_pt_gps/default_tg_pt_gp
May  5 02:49:01 lenny64guest1 kernel: [ 1272.274807] iSCSI_TPG[1]_LUN[2] - Activated iSCSI Logical Unit from CORE HBA: 3
May  5 02:49:01 lenny64guest1 kernel: [ 1272.275889] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.276846] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.276846] TARGET_CORE[iSCSI]->TPG[1]_LUN[2] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.276846] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.280397] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.281504] TARGET_CORE[iSCSI]->TPG[1]_LUN[2] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.282607] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.283740] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.284377] TARGET_CORE[iSCSI]->TPG[1]_LUN[2] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:01 lenny64guest1 kernel: [ 1272.284377] LIO_Target_ConfigFS: Created Port Symlink fileio -> lun_2
May  5 02:49:21 lenny64guest1 kernel: [ 1291.750986] Decremented iSCSI connection count to 0 from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:49:21 lenny64guest1 kernel: [ 1291.752197] TARGET_CORE[iSCSI]: Deregistered fabric_sess
May  5 02:49:21 lenny64guest1 kernel: [ 1291.752924] Released iSCSI session from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:49:21 lenny64guest1 kernel: [ 1291.753986] Decremented number of active iSCSI Sessions on iSCSI TPG: 1 to 2
May  5 02:49:22 lenny64guest1 kernel: [ 1293.680754] Received iSCSI login request from 192.168.0.116 on TCP Network Portal 192.168.0.117:3260
May  5 02:49:22 lenny64guest1 kernel: [ 1293.681922] Located Storage Object: iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:49:22 lenny64guest1 kernel: [ 1293.683034] Located Portal Group Object: 1
May  5 02:49:22 lenny64guest1 kernel: [ 1293.683653] TARGET_CORE[iSCSI]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:22 lenny64guest1 kernel: [ 1293.684800] TARGET_CORE[iSCSI]->TPG[1]_LUN[1] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:22 lenny64guest1 kernel: [ 1293.685904] TARGET_CORE[iSCSI]->TPG[1]_LUN[2] - Adding READ-WRITE access for LUN in Demo Mode
May  5 02:49:22 lenny64guest1 kernel: [ 1293.686994] iSCSI_TPG[1] - Added DYNAMIC ACL with TCQ Depth: 4 for iSCSI Initiator Node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:49:22 lenny64guest1 kernel: [ 1293.688298] ------------------------------------------------------------------
May  5 02:49:22 lenny64guest1 kernel: [ 1293.689418] HeaderDigest:                 None
May  5 02:49:22 lenny64guest1 kernel: [ 1293.690047] DataDigest:                   None
May  5 02:49:22 lenny64guest1 kernel: [ 1293.690676] MaxRecvDataSegmentLength:     131072
May  5 02:49:22 lenny64guest1 kernel: [ 1293.691310] IFMarker:                     No
May  5 02:49:22 lenny64guest1 kernel: [ 1293.691931] OFMarker:                     No
May  5 02:49:22 lenny64guest1 kernel: [ 1293.692618] ------------------------------------------------------------------
May  5 02:49:22 lenny64guest1 kernel: [ 1293.693661] ------------------------------------------------------------------
May  5 02:49:22 lenny64guest1 kernel: [ 1293.694691] MaxConnections:               1
May  5 02:49:22 lenny64guest1 kernel: [ 1293.695303] TargetName:                   iqn.2003-01.org.linux-iscsi.lenny64guest1.x86_64:sn.35c620374de6
May  5 02:49:22 lenny64guest1 kernel: [ 1293.696444] InitiatorName:                iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:49:22 lenny64guest1 kernel: [ 1293.697903] TargetAlias:                  LIO Target
May  5 02:49:22 lenny64guest1 kernel: [ 1293.698560] InitiatorAlias:               subjekt
May  5 02:49:22 lenny64guest1 kernel: [ 1293.699198] TargetPortalGroupTag:         1
May  5 02:49:22 lenny64guest1 kernel: [ 1293.699818] InitialR2T:                   Yes
May  5 02:49:22 lenny64guest1 kernel: [ 1293.712835] ImmediateData:                Yes
May  5 02:49:23 lenny64guest1 kernel: [ 1293.713596] MaxBurstLength:               262144
May  5 02:49:23 lenny64guest1 kernel: [ 1293.714227] FirstBurstLength:             65536
May  5 02:49:23 lenny64guest1 kernel: [ 1293.714859] DefaultTime2Wait:             2
May  5 02:49:23 lenny64guest1 kernel: [ 1293.715481] DefaultTime2Retain:           0
May  5 02:49:23 lenny64guest1 kernel: [ 1293.716105] MaxOutstandingR2T:            1
May  5 02:49:23 lenny64guest1 kernel: [ 1293.716801] DataPDUInOrder:               Yes
May  5 02:49:23 lenny64guest1 kernel: [ 1293.717559] DataSequenceInOrder:          Yes
May  5 02:49:23 lenny64guest1 kernel: [ 1293.718191] ErrorRecoveryLevel:           0
May  5 02:49:23 lenny64guest1 kernel: [ 1293.718812] SessionType:                  Normal
May  5 02:49:23 lenny64guest1 kernel: [ 1293.719448] ------------------------------------------------------------------
May  5 02:49:23 lenny64guest1 kernel: [ 1293.720574] TARGET_CORE[iSCSI]: Registered fabric_sess_ptr: ffff8800684ea800
May  5 02:49:23 lenny64guest1 kernel: [ 1293.721456] iSCSI Login successful on CID: 0 from 192.168.0.116 to 192.168.0.117:3260,1
May  5 02:49:23 lenny64guest1 kernel: [ 1293.722523] Incremented iSCSI Connection count to 1 from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:49:23 lenny64guest1 kernel: [ 1293.723635] Established iSCSI session from node: iqn.1993-08.org.debian:01.2fed72c26a4c
May  5 02:49:23 lenny64guest1 kernel: [ 1293.724770] Incremented number of active iSCSI sessions to 3 on iSCSI Target Portal Group: 1
May  5 03:20:41 lenny64guest1 kernel: [ 3172.321826] Clocksource tsc unstable (delta = 4687268810 ns)

--=-2unmVJQnCJrWfY81qS3c--


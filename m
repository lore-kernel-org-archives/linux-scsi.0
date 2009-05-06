From: Sheng Yang <sheng@linux.intel.com>
Subject: Re: KVM x86_64 with SR-IOV..? (device passthrough with LIO-Target v3.0)
Date: Wed, 6 May 2009 11:14:46 +0800
Message-ID: <200905061114.47010.sheng@linux.intel.com>
References: <1241122974.32740.539.camel@haakon2.linux-iscsi.org> <20090505014230.GB30419@yzhao-otc.sh.intel.com> <1241520226.32740.1051.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1241520226.32740.1051.camel@haakon2.linux-iscsi.org>
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Yu Zhao <yu.zhao@intel.com>, kvm-devel <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 05 May 2009 18:43:46 Nicholas A. Bellinger wrote:
> On Tue, 2009-05-05 at 09:42 +0800, Yu Zhao wrote:
> > Hi,
> >
> > The VF also works in the host if the VF driver is programed properly.
> > So it would be easier to develop the VF driver in the host and then
> > verify the VF driver in the guest.
> >
> > BTW, I didn't see the SR-IOV is enabled in your dmesg, did you select
> > the CONFIG_PCI_IOV in the kernel .config?
> >
> > Thanks,
> > Yu
>
> Greetings Yu and Sheng,
>
> So the original attachment was for the v2.6.29-fc11 host kernel output,
> I ended up jumping to v2.6.30-rc3 (and making sure CONFIG_PCI_IOV was
> enabled) for KVM host with kvm-85 and now things are looking quite
> stable for me.
>
> So far I have been able to successfully push LIO-Target v3.0 traffic
> *inside* a v2.6.29.2 KVM guest via the onboard e1000e (02:00.0) port
> from another Linux/iSCSI Initiator machine using a Intel 1 Gb/sec port.
> I am running badblocks tests to iSCSI Logical Units for RAMDISK_DR and
> FILEIO storage objects (in the KVM Guest), and they are passing
> validation and I am seeing ~500 Mb/sec of throughput and very low CPU
> usage in the KVM guests.
>
> One issue I did notice while using the pci-stub method of
> device-assignment with same e1000 port (02:00.0) was while using an
> iSCSI Initiator (Open-iSCSI) on the KVM Host machine and doing sustained
> traffic into the LIO-Target KVM Guest on the same local KVM host to max
> out traffic between the other onboard e1000e port (03.00.0), I see the
> following:
>
> pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> assign device: host bdf = 2:0:0
> pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
> pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
> pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
> pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
> pci-stub 0000:02:00.0: irq 59 for MSI/MSI-X
> pci-stub 0000:02:00.0: irq 60 for MSI/MSI-X
> pci-stub 0000:02:00.0: irq 61 for MSI/MSI-X
> scsi4 : iSCSI Initiator over TCP/IP
> scsi 4:0:0:0: Direct-Access     LIO-ORG  RAMDISK-DR       3.0  PQ: 0 ANSI:
> 5 sd 4:0:0:0: Attached scsi generic sg1 type 0
> scsi 4:0:0:1: Direct-Access     LIO-ORG  RAMDISK-DR       3.0  PQ: 0 ANSI:
> 5 sd 4:0:0:1: Attached scsi generic sg2 type 0
> sd 4:0:0:0: [sdb] 262144 512-byte hardware sectors: (134 MB/128 MiB)
> sd 4:0:0:1: [sdc] 262144 512-byte hardware sectors: (134 MB/128 MiB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 2f 00 00 00
> sd 4:0:0:1: [sdc] Write Protect is off
> sd 4:0:0:1: [sdc] Mode Sense: 2f 00 00 00
> sd 4:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
> support DPO or FUA sd 4:0:0:1: [sdc] Write cache: disabled, read cache:
> enabled, doesn't support DPO or FUA sdb:<6> sdc: unknown partition table
> sd 4:0:0:0: [sdb] Attached SCSI disk
>  unknown partition table
> sd 4:0:0:1: [sdc] Attached SCSI disk
> ------------[ cut here ]------------
> WARNING: at kernel/irq/manage.c:260 enable_irq+0x36/0x50()
> Hardware name: empty
> Unbalanced enable for IRQ 59
> Modules linked in: ipt_REJECT xt_tcpudp bridge stp sunrpc iptable_filter
> ip_tables xt_state nf_conntrack ip6table_filter ip6_tables x_tables ib_iser
> rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr ipv6 iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq
> freq_table ext3 jbd loop dm_multipath scsi_dh kvm_intel kvm uinput i2c_i801
> firewire_ohci joydev firewire_core sg i2c_core 8250_pnp crc_itu_t e1000e
> 8250 serial_core rtc_cmos pcspkr serio_raw rtc_core rtc_lib button sd_mod
> dm_snapshot dm_zero dm_mirror dm_region_hash dm_log dm_mod uhci_hcd
> ohci_hcd ehci_hcd ata_piix libata scsi_mod [last unloaded: microcode] Pid:
> 51, comm: events/0 Tainted: G        W  2.6.30-rc3 #11
> Call Trace:
>  [<ffffffff80235fee>] ? warn_slowpath+0xcb/0xe8
>  [<ffffffff80253a7c>] ? generic_exec_single+0x6a/0x88
>  [<ffffffff8022acec>] ? update_curr+0x67/0xeb
>  [<ffffffffa0198748>] ? vcpu_kick_intr+0x0/0x1 [kvm]
>  [<ffffffff8020a5d8>] ? __switch_to+0xb6/0x274
>  [<ffffffff8022b70a>] ? __dequeue_entity+0x1b/0x2f
>  [<ffffffffa01ac7e4>] ? kvm_irq_delivery_to_apic+0xb3/0xf7 [kvm]
>  [<ffffffffa01aa4d4>] ? __apic_accept_irq+0x15a/0x173 [kvm]
>  [<ffffffffa01ac883>] ? kvm_set_msi+0x5b/0x60 [kvm]
>  [<ffffffff80266d97>] ? enable_irq+0x36/0x50
>  [<ffffffffa0195ab5>] ? kvm_assigned_dev_interrupt_work_handler+0x6d/0xbc
> [kvm] [<ffffffff802449fa>] ? worker_thread+0x182/0x223
>  [<ffffffff8024820b>] ? autoremove_wake_function+0x0/0x2a
>  [<ffffffff80244878>] ? worker_thread+0x0/0x223
>  [<ffffffff80244878>] ? worker_thread+0x0/0x223
>  [<ffffffff80247e72>] ? kthread+0x54/0x7e
>  [<ffffffff8020cb0a>] ? child_rip+0xa/0x20
>  [<ffffffff804d0af5>] ? _spin_lock+0x5/0x8
>  [<ffffffff80247e1e>] ? kthread+0x0/0x7e
>  [<ffffffff8020cb00>] ? child_rip+0x0/0x20
> ---[ end trace 3fbc2dd20bf89ef1 ]---
>  connection1:0: ping timeout of 5 secs expired, last rx 4295286327, last
> ping 4295285518, now 4295286768 connection1:0: detected conn error (1011)
>
> Attached are the v2.6.30-rc3 KVM host and v2.6.29.2 KVM guest dmesg
> output.  When the 'Unbalanced enable for IRQ 59' happens on the KVM
> host, I do not see any exceptions in KVM guest (other than the iSCSI
> connections drop), but it requires a restart of KVM+qemu-system-x86_64
> to get the e1000e port back up.

Yeah, there is a bug. And Marcelo has fix for it, please wait a while for 
check in.

> Other than that loopback scenario, things are looking good quite good
> with this combination of kvm-85 kernel+guest so far for me.  I did end
> up taking out the two 8x function 2x Path/Function PCIe IOV adapters for
> now, as it seemed to have an effect on stability with all of MSI-X
> interrupts enabled on the KVM host for 16 virtual adapters.

That's great! :)

-- 
regards
Yang, Sheng

>
> I will keep testing with e1000e ports and let the list know the
> progress.  Thanks for your comments!
>
> --nab
>
> > On Mon, May 04, 2009 at 06:40:36PM +0800, Nicholas A. Bellinger wrote:
> > > On Mon, 2009-05-04 at 17:49 +0800, Sheng Yang wrote:
> > > > On Monday 04 May 2009 17:11:59 Nicholas A. Bellinger wrote:
> > > > > On Mon, 2009-05-04 at 16:20 +0800, Sheng Yang wrote:
> > > > > > On Monday 04 May 2009 12:36:04 Nicholas A. Bellinger wrote:
> > > > > > > On Mon, 2009-05-04 at 10:09 +0800, Sheng Yang wrote:
> > > > > > > > On Monday 04 May 2009 08:53:07 Nicholas A. Bellinger wrote:
> > > > > > > > > On Sat, 2009-05-02 at 18:22 +0800, Sheng Yang wrote:
> > > > > > > > > > On Thu, Apr 30, 2009 at 01:22:54PM -0700, Nicholas A.
> > > > > > > > > > Bellinger
> > > >
> > > > wrote:
> > > > > > > > > > > Greetings KVM folks,
> > > > > > > > > > >
> > > > > > > > > > > I wondering if any information exists for doing SR-IOV
> > > > > > > > > > > on the new VT-d capable chipsets with KVM..?  From what
> > > > > > > > > > > I understand the patches for doing this with KVM are
> > > > > > > > > > > floating around, but I have been unable to find any
> > > > > > > > > > > user-level docs for actually making it all go against a
> > > > > > > > > > > upstream v2.6.30-rc3 code..
> > > > > > > > > > >
> > > > > > > > > > > So far I have been doing IOV testing with Xen 3.3 and
> > > > > > > > > > > 3.4.0-pre, and I am really hoping to be able to jump to
> > > > > > > > > > > KVM for single-function and and then multi-function
> > > > > > > > > > > SR-IOV.  I know that the VM migration stuff for IOV in
> > > > > > > > > > > Xen is up and running, and I assume it is being worked
> > > > > > > > > > > in for KVM instance migration as well..? This part is
> > > > > > > > > > > less important (at least for me :-) than getting a
> > > > > > > > > > > stable SR-IOV setup running under the KVM hypervisor.. 
> > > > > > > > > > > Does anyone have any pointers for this..?
> > > > > > > > > > >
> > > > > > > > > > > Any comments or suggestions are appreciated!
> > > > > > > > > >
> > > > > > > > > > Hi Nicholas
> > > > > > > > > >
> > > > > > > > > > The patches are not floating around now. As you know,
> > > > > > > > > > SR-IOV for Linux have been in 2.6.30, so then you can use
> > > > > > > > > > upstream KVM and qemu-kvm(or recent released kvm-85) with
> > > > > > > > > > 2.6.30-rc3 as host kernel. And some time ago, there are
> > > > > > > > > > several SRIOV related patches for qemu-kvm, and now they
> > > > > > > > > > all have been checked in.
> > > > > > > > > >
> > > > > > > > > > And for KVM, the extra document is not necessary, for you
> > > > > > > > > > can simple assign a VF to guest like any other devices.
> > > > > > > > > > And how to create VF is specific for each device driver.
> > > > > > > > > > So just create a VF then assign it to KVM guest is fine.
> > > > > > > > >
> > > > > > > > > Greetings Sheng,
> > > > > > > > >
> > > > > > > > > So, I have been trying the latest kvm-85 release on a
> > > > > > > > > v2.6.30-rc3 checkout from linux-2.6.git on a CentOS 5u3
> > > > > > > > > x86_64 install on Intel IOH-5520 based dual socket Nehalem
> > > > > > > > > board.  I have enabled DMAR and Interrupt Remapping my KVM
> > > > > > > > > host using v2.6.30-rc3 and from what I can tell, the
> > > > > > > > > KVM_CAP_* defines from libkvm are enabled with building
> > > > > > > > > kvm-85 after './configure
> > > > > > > > > --kerneldir=/usr/src/linux-2.6.git' and the PCI passthrough
> > > > > > > > > code is being enabled in
> > > > > > > > > kvm-85/qemu/hw/device-assignment.c AFAICT..
> > > > > > > > >
> > > > > > > > > >From there, I use the freshly installed qemu-x86_64-system
> > > > > > > > > > binary to
> > > > > > > > >
> > > > > > > > > start a Debian 5 x86_64 HVM (that previously had been
> > > > > > > > > moving network packets under Xen for PCIe passthrough). I
> > > > > > > > > see the MSI-X interrupt remapping working on the KVM host
> > > > > > > > > for the passed -pcidevice, and the MMIO mappings from the
> > > > > > > > > qemu build that I also saw while using Xen/qemu-dm built
> > > > > > > > > with PCI passthrough are there as well..
> > > > > > > >
> > > > > > > > Hi Nicholas
> > > > > > > >
> > > > > > > > > But while the KVM guest is booting, I see the following
> > > > > > > > > exception(s) from qemu-x86_64-system for one of the VFs for
> > > > > > > > > a multi-function PCIe device:
> > > > > > > > >
> > > > > > > > > BUG: kvm_destroy_phys_mem: invalid parameters (slot=-1)
> > > > > > > >
> > > > > > > > This one is mostly harmless.
> > > > > > >
> > > > > > > Ok, good to know..  :-)
> > > > > > >
> > > > > > > > > I try with one of the on-board e1000e ports (02:00.0) and I
> > > > > > > > > see the same exception along with some MSI-X exceptions
> > > > > > > > > from qemu-x86_64-system in KVM guest.. However, I am still
> > > > > > > > > able to see the e1000e and the other vxge multi-function
> > > > > > > > > device with lspci, but I am unable to dhcp or ping with the
> > > > > > > > > e1000e and VF from multi-function device fails to register
> > > > > > > > > the MSI-X interrupt in the guest..
> > > > > > > >
> > > > > > > > Did you see the interrupt in the guest and host side?
> > > > > > >
> > > > > > > Ok, I am restarting the e1000e test with a fresh Fedora 11
> > > > > > > install and KVM host kernel 2.6.29.1-111.fc11.x86_64.   After
> > > > > > > unbinding and attaching the e1000e single-function device at
> > > > > > > 02:00.0 to pci-stub with:
> > > > > > >
> > > > > > >    echo "8086 10d3" > /sys/bus/pci/drivers/pci-stub/new_id
> > > > > > >    echo 0000:02:00.0 >
> > > > > > > /sys/bus/pci/devices/0000:02:00.0/driver/unbind echo
> > > > > > > 0000:02:00.0 > /sys/bus/pci/drivers/pci-stub/bind
> > > > > > >
> > > > > > > I see the following the KVM host kernel ring buffer:
> > > > > > >
> > > > > > >    e1000e 0000:02:00.0: PCI INT A disabled
> > > > > > >    pci-stub 0000:02:00.0: PCI INT A -> GSI 17 (level, low) ->
> > > > > > > IRQ 17 pci-stub 0000:02:00.0: irq 58 for MSI/MSI-X
> > > > > > >
> > > > > > > >  I think you can try on-
> > > > > > > > board e1000e for MSI-X first. And please ensure correlated
> > > > > > > > driver have been loaded correctly.
> > > > > > >
> > > > > > > <nod>..
> > > > > > >
> > > > > > > >  And what do you mean by "some MSI-X exceptions"? Better with
> > > > > > > > the log.
> > > > > > >
> > > > > > > Ok, with the Fedora 11 installed qemu-kemu, I see the expected
> > > > > > > kvm_destroy_phys_mem() statements:
> > > > > > >
> > > > > > > #kvm-host qemu-kvm -m 2048 -smp 8 -pcidevice host=02:00.0
> > > > > > > lenny64guest1-orig.img BUG: kvm_destroy_phys_mem: invalid
> > > > > > > parameters (slot=-1)
> > > > > > > BUG: kvm_destroy_phys_mem: invalid parameters (slot=-1)
> > > > > > >
> > > > > > > However I still see the following in the KVM guest kernel ring
> > > > > > > buffer running v2.6.30-rc in the HVM guest.
> > > > > > >
> > > > > > > [    5.523790] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ
> > > > > > > 10 [    5.524582] e1000e 0000:00:05.0: PCI INT A -> Link[LNKA]
> > > > > > > -> GSI 10 (level, high) -> IRQ 10 [    5.525710] e1000e
> > > > > > > 0000:00:05.0: setting latency timer to 64
> > > > > > > [    5.526048] 0000:00:05.0: 0000:00:05.0: Failed to initialize
> > > > > > > MSI-X interrupts.  Falling back to MSI interrupts. [   
> > > > > > > 5.527200] 0000:00:05.0: 0000:00:05.0: Failed to initialize MSI
> > > > > > > interrupts. Falling back to legacy interrupts. [    5.829988]
> > > > > > > 0000:00:05.0: eth0: (PCI Express:2.5GB/s:Width x1)
> > > > > > > 00:e0:81:c0:90:b2 [    5.830672] 0000:00:05.0: eth0: Intel(R)
> > > > > > > PRO/1000 Network Connection [    5.831240] 0000:00:05.0: eth0:
> > > > > > > MAC: 3, PHY: 8, PBA No: ffffff-0ff
> > > > > >
> > > > > > Hi Nicholas
> > > > > >
> > > > > > I think something need to be clarify:
> > > > > > 1. For SRIOV, you need 2.6.30 as host kernel... But it's better
> > > > > > to know if normal device assignment work in your environment at
> > > > > > first. 2. The Fedora's userspace is even more old... You'd better
> > > > > > try qemu-kvm upstream, which is more convenient for us to track
> > > > > > the problem(and kvm-85 is also ok). And as you see above, your
> > > > > > QEmu don't support MSI/MSIX...
> > > > >
> > > > > Ok, got it..
> > > > >
> > > > > > So you can:
> > > > > > 1. Use latest qemu-kvm or kvm-85's QEmu. As well as latest KVM.
> > > > >
> > > > > Ok, I am now updated on in the FC 11 Host with kvm-85 kernel
> > > > > modules and am using the built qemu-system-x86_64 from the kvm-85
> > > > > source package:
> > > > >
> > > > > loaded kvm module (kvm-85)
> > > > > QEMU PC emulator version 0.10.0 (kvm-85), Copyright (c) 2003-2008
> > > > > Fabrice Bellard
> > > > >
> > > > > > 2. Your host kernel is Fedora 11 Preview, that should be fine
> > > > > > with device assignment at first(and let's solve it first, SRIOV
> > > > > > the next step).
> > > > >
> > > > > Ok, yeah I will stick with the v2.6.29 fc11 kernel on the KVM host
> > > > > for the momemt to get e1000e working.  But I will start building a
> > > > > v2.6.30-rc3 kernel again for my fc11 host kernel as I do need
> > > > > SR-IOV at some point... :-)
> > > > >
> > > > > > 3. Your KVM version seems like kvm-85, you may provide some dmesg
> > > > > > on host side(I think you didn't use the KVM come along with
> > > > > > kernel).
> > > > >
> > > > > Ok, now within the KVM guest running v2.6.29.2, I see the
> > > > > following:
> > > > >
> > > > > [    2.669243] e1000e: Intel(R) PRO/1000 Network Driver -
> > > > > 0.3.3.3-k6 [    2.672931] e1000e: Copyright (c) 1999-2008 Intel
> > > > > Corporation. [    2.674932] ACPI: PCI Interrupt Link [LNKA] enabled
> > > > > at IRQ 10 [    2.675181] 8139too Fast Ethernet driver 0.9.28
> > > > > [    2.676783] e1000e 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI
> > > > > 10 (level, high) -> IRQ 10
> > > > > [    2.678143] e1000e 0000:00:05.0: setting latency timer to 64
> > > > > [    2.679539] e1000e 0000:00:05.0: irq 24 for MSI/MSI-X
> > > > > [    2.679603] e1000e 0000:00:05.0: irq 25 for MSI/MSI-X
> > > > > [    2.679659] e1000e 0000:00:05.0: irq 26 for MSI/MSI-X
> > > > > [    2.698039] FDC 0 is a S82078B
> > > > > [    2.801673] 0000:00:05.0: eth0: (PCI Express:2.5GB/s:Width x1)
> > > > > 00:e0:81:c0:90:b2
> > > > > [    2.802811] 0000:00:05.0: eth0: Intel(R) PRO/1000 Network
> > > > > Connection [    2.803697] 0000:00:05.0: eth0: MAC: 3, PHY: 8, PBA
> > > > > No: ffffff-0ff
> > > > >
> > > > > And the folllowing from /proc/interrupts inside of the KVM guest:
> > > > >
> > > > >  24:        117          0          0          0          0        
> > > > >  0 0          0          0          0   PCI-MSI-edge      eth1-rx-0
> > > > > 25: 0          0          0          0          0          0       
> > > > >   0 0          0          0   PCI-MSI-edge      eth1-tx-0 26:      
> > > > >    2 0          0          0          0          0          0 0    
> > > > >      0          0   PCI-MSI-edge      eth1
> > > > >
> > > > > ethtool eth1 reports that Link is detected, but I am still unable
> > > > > to get a dhcp to work.
> > > >
> > > > It's a little strange that I checked all the log you posted, but
> > > > can't find anything suspicious...(Except you got a MCE log in your
> > > > dmesg, but I don't think it would relate to this).
> > > >
> > > > You also already have interrupts in the guest for eth1-rx-0 and eth1,
> > > > so at least part of interrupts can be delivered to the guest.
> > > >
> > > > You can try to connect the port to another NIC port directly. Set
> > > > fixed ip for each, then ping each other.
> > > >
> > > > You can also try to disable MSI-X capability in QEmu. Just using "#if
> > > > 0/#endif" to wrap "#ifdef KVM_CAP_DEVICE_MSIX/#endif" in
> > > > hw/assigned_device_pci_cap_init(). Then the device would use MSI.
> > > >
> > > > If I am lucky enough to find a 82574L card by hand, I would give it a
> > > > try...
> > > >
> > > > --
> > > > regards
> > > > Yang, Sheng
> > >
> > > Greetings Sheng,
> > >
> > > So I updated my FC11 Host to kernel v2.6.30-rc3 (and enabled ext4 of
> > > course) and rebuilt the kvm-85 source kernel module and
> > > qemu-system-x86_64 and I am now able to get dhcp and IP ops from the
> > > 02:00.0 device on my IOH-5520 board with the KVM guest using a
> > > v2.6.29.2 kernel!!  Everything is looking good with the v2.6.29.2, but
> > > after a quick reboot back into my v2.6.30-rc3 KVM guest kernel build
> > > e1000e it looks like I am unable to get dhcp.
> > >
> > > Rebooting back into KVM Guest kernel v2.6.29.2 brings the pci-stub
> > > assigned e1000e 82574L assigned with dhcp and everything looks
> > > good!  :-)
> > >
> > > I will keep poking at the v2.6.30-rc KVM guests (I am going to do a
> > > complete rebuild) and see if it does not start move IP packets as
> > > well..
> > >
> > > Thanks for all of your help in getting setup!
> > >
> > > --nab
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html



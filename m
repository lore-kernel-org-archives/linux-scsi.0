From: Thomas Lange <lange@jc-embedded.com>
Subject: aic94xx driver very slow / low writing speed on sata-discs
Date: Mon, 11 May 2009 15:52:33 +0200
Message-ID: <4A082DA1.9090805@jc-embedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZEKNwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2009 09:52:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi all,

this is my second post to LKML regarding the issue with aic94xx driver.
In the meantime I have some additional information to share:
We did some more testing and found out that partitions on the discs 
attached to the controller sometimes are not recognized during boot.
That leads to the problem that they cannot be mounted at all.
I would be happy to get some hints on the issue
as well as provide some of my spare time and our company's hardware to 
do some testing.

Here is the description of my first observation of the problem:
We have a couple of supermicro servers in our company that have adaptec
aic94xx onboard, and there is the following issue that
the aic94xx writing speed is very slow for sata disks connected.
writing speed 5-6MB/s
(tested with dd if=/dev/zero of=/dev/partition on aic9410w)
reading speed: above 70MB/s
(tested with dd if=/dev/partition of=/dev/zero on aic9410w)
Another observation is that the LED showing disc activity
continuously glows as soon as the driver has been loaded and that it
does not stop to glow from then on. Also the hard disks connected to the
aic9410w are not recognized every time after booting the system. In most
cases a second boot resolves the issue.
With other operating sytem there is no such problem i.e. hardware itself 
is okay.

I send relevant output information of the aic94xx driver attached with this
mail. Please CC answers to this post to me (langeATjc-embedded.com) as 
I'm not
in the kernel-list.

Regards

Thomas Lange

system:
dual xeon 2,8Ghz, Supermicro-MB x6da3-g2 with onboard adaptec aic9410w
controller
tested with opensuse 10.3, opensuse 11.0 and opensuse 11.1
kernels are standard kernel opensuse 10.3/11.0/11.1 and vanilla-Kernel
2.6.25/2.6.29 from kernel.org

Attachments
========


output from boot.msg:

Inspecting /boot/System.map
Loaded 34118 symbols from /boot/System.map.
Symbols match kernel version 2.6.25.
No module symbols loaded - kernel modules not enabled.

5>aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
<7>bus: 'pci': add driver aic94xx
<7>device: 'event4': device_add
<7>PM: Adding info for No Bus:event4
<6>ACPI: Power Button (CM) [PWRB]
<7>driver: 'PNP0C0C:00': driver_bound: bound to device 'button'
<7>bus: 'acpi': really_probe: bound device PNP0C0C:00 to driver button
<7>driver: '2-0:1.0': driver_bound: bound to device 'hub'
<7>bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
<7>device: 'usbdev2.1_ep81': device_add
<7>PM: Adding info for No Bus:usbdev2.1_ep81
<7>device: 'usbdev2.1': device_add
<7>PM: Adding info for No Bus:usbdev2.1
<7>driver: 'usb2': driver_bound: bound to device 'usb'
<7>bus: 'usb': really_probe: bound device usb2 to driver usb
<7>driver: '0000:00:1d.1': driver_bound: bound to device 'uhci_hcd'
<7>bus: 'pci': really_probe: bound device 0000:00:1d.1 to driver uhci_hcd
<7>bus: 'pci': driver_probe_device: matched device 0000:00:1d.2 with
driver uhci_hcd
<7>bus: 'pci': really_probe: probing driver uhci_hcd with device
0000:00:1d.2
<6>ACPI: PCI Interrupt 0000:00:1d.2[C] -> <7>parport_pc 00:0d: driver
attached
<7>driver: '00:0d': driver_bound: bound to device 'parport_pc'
<7>bus: 'pnp': really_probe: bound device 00:0d to driver parport_pc
<7>Registering platform device 'parport_pc.956'. Parent at platform
<7>device: 'parport_pc.956': device_add
<7>PM: Adding info for platform:parport_pc.956
<7>bus: 'platform': add device parport_pc.956
<7>bus: 'platform': driver_probe_device: matched device parport_pc.956
with driver parport_pc
<7>bus: 'platform': really_probe: probing driver parport_pc with device
parport_pc.956
<7>driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
<7>bus: 'platform': really_probe: bound device parport_pc.956 to driver
parport_pc
<7>PM: Removing info for platform:parport_pc.956
<7>bus: 'platform': remove device parport_pc.956
<7>Registering platform device 'parport_pc.888'. Parent at platform
<7>device: 'parport_pc.888': device_add
<7>PM: Adding info for platform:parport_pc.888
<7>bus: 'platform': add device parport_pc.888
<7>bus: 'platform': driver_probe_device: matched device parport_pc.888
with driver parport_pc
<7>bus: 'platform': really_probe: probing driver parport_pc with device
parport_pc.888
<7>driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
<7>bus: 'platform': really_probe: bound device parport_pc.888 to driver
parport_pc
<7>PM: Removing info for platform:parport_pc.888
<7>bus: 'platform': remove device parport_pc.888
<7>Registering platform device 'parport_pc.632'. Parent at platform
<7>device: 'parport_pc.632': device_add
<7>PM: Adding info for platform:parport_pc.632
<7>bus: 'platform': add device parport_pc.632
<7>bus: 'platform': driver_probe_device: matched device parport_pc.632
with driver parport_pc
<7>bus: 'platform': really_probe: probing driver parport_pc with device
parport_pc.632
<7>driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
<7>bus: 'platform': really_probe: bound device parport_pc.632 to driver
parport_pc
<7>PM: Removing info for platform:parport_pc.632
<7>bus: 'platform': remove device parport_pc.632
<7>bus: 'pci': add driver parport_pc
<4>GSI 18 (level, low) -> IRQ 18
<7>PCI: Setting latency timer of device 0000:00:1d.2 to 64
<6>uhci_hcd 0000:00:1d.2: UHCI Host Controller
<7>device: 'usb_host3': device_add
<7>bus: 'i2c': add driver tveeprom
<7>PM: Adding info for No Bus:usb_host3
<6>uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
<6>uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001440
<7>device: 'usb3': device_add
<7>PM: Adding info for usb:usb3
<7>bus: 'usb': add device usb3
<7>bus: 'usb': driver_probe_device: matched device usb3 with driver usb
<7>bus: 'usb': really_probe: probing driver usb with device usb3
<7>device: 'usbdev3.1_ep00': device_add
<7>PM: Adding info for No Bus:usbdev3.1_ep00
<6>usb usb3: configuration #1 chosen from 1 choice
<7>device: '3-0:1.0': device_add
<7>PM: Adding info for usb:3-0:1.0
<7>bus: 'usb': add device 3-0:1.0
<7>bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
<7>bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
<6>hub 3-0:1.0: USB hub found
<6>hub 3-0:1.0: 2 ports detected
<7>bus: 'pci': add driver Emu10k1_gameport
<7>bus: 'acpi': add driver thermal
<7>bus: 'acpi': driver_probe_device: matched device LNXTHERM:00 with
driver thermal
<7>bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:00
<7>device class 'ppdev': registering
<7>device: 'parport0': device_add
<7>PM: Adding info for No Bus:parport0
<6>ppdev: user-space parallel port driver
<7>driver: '3-0:1.0': driver_bound: bound to device 'hub'
<7>bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
<7>device: 'usbdev3.1_ep81': device_add
<7>PM: Adding info for No Bus:usbdev3.1_ep81
<7>device: 'usbdev3.1': device_add
<7>PM: Adding info for No Bus:usbdev3.1
<7>driver: 'usb3': driver_bound: bound to device 'usb'
<7>bus: 'usb': really_probe: bound device usb3 to driver usb
<7>driver: '0000:00:1d.2': driver_bound: bound to device 'uhci_hcd'
<7>bus: 'pci': really_probe: bound device 0000:00:1d.2 to driver uhci_hcd
<7>bus: 'pci': driver_probe_device: matched device 0000:00:1d.3 with
driver uhci_hcd
<7>bus: 'pci': really_probe: probing driver uhci_hcd with device
0000:00:1d.3
<6>ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16
<7>PCI: Setting latency timer of device 0000:00:1d.3 to 64
<6>uhci_hcd 0000:00:1d.3: UHCI Host Controller
<7>device: 'usb_host4': device_add
<7>PM: Adding info for No Bus:usb_host4
<6>uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
<6>uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001460
<7>device: 'usb4': device_add
<7>PM: Adding info for usb:usb4
<7>bus: 'usb': add device usb4
<7>bus: 'usb': driver_probe_device: matched device usb4 with driver usb
<7>bus: 'usb': really_probe: probing driver usb with device usb4
<7>device: 'usbdev4.1_ep00': device_add
<7>PM: Adding info for No Bus:usbdev4.1_ep00
<6>usb usb4: configuration #1 chosen from 1 choice
<7>device: '4-0:1.0': device_add
<6>usb 2-2: new full speed USB device using uhci_hcd and address 2
<7>PM: Adding info for usb:4-0:1.0
<7>bus: 'usb': add device 4-0:1.0
<7>bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
<7>bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
<6>hub 4-0:1.0: USB hub found
<6>hub 4-0:1.0: 2 ports detected
<7>driver: '4-0:1.0': driver_bound: bound to device 'hub'
<7>bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
<7>device: 'usbdev4.1_ep81': device_add
<7>PM: Adding info for No Bus:usbdev4.1_ep81
<7>device: 'usbdev4.1': device_add
<7>PM: Adding info for No Bus:usbdev4.1
<7>driver: 'usb4': driver_bound: bound to device 'usb'
<7>bus: 'usb': really_probe: bound device usb4 to driver usb
<7>driver: '0000:00:1d.3': driver_bound: bound to device 'uhci_hcd'
<7>bus: 'pci': really_probe: bound device 0000:00:1d.3 to driver uhci_hcd
<7>bus: 'pci': driver_probe_device: matched device 0000:00:1d.7 with
driver ehci_hcd
<7>bus: 'pci': driver_probe_device: matched device 0000:03:03.2 with
driver ohci1394
<7>bus: 'pci': really_probe: probing driver ohci1394 with device
0000:03:03.2
<7>bus: 'pci': really_probe: probing driver ehci_hcd with device
0000:00:1d.7
<6>ACPI: PCI Interrupt 0000:03:03.2[B] -> <6>ACPI: PCI Interrupt
0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23
<7>PCI: Setting latency timer of device 0000:00:1d.7 to 64
<6>ehci_hcd 0000:00:1d.7: EHCI Host Controller
<7>device: 'usb_host5': device_add
<7>PM: Adding info for No Bus:usb_host5
<6>ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
<6>ehci_hcd 0000:00:1d.7: debug port 1
<7>PCI: cache line size of 128 is not supported by device 0000:00:1d.7
<6>ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc8000000
<3>usb 2-2: unable to read config index 0 descriptor/all
<3>usb 2-2: can't read configurations, error -71
<6>ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
<7>device: 'usb5': device_add
<7>PM: Adding info for usb:usb5
<7>bus: 'usb': add device usb5
<7>bus: 'usb': driver_probe_device: matched device usb5 with driver usb
<7>bus: 'usb': really_probe: probing driver usb with device usb5
<7>device: 'usbdev5.1_ep00': device_add
<7>PM: Adding info for No Bus:usbdev5.1_ep00
<6>usb usb5: configuration #1 chosen from 1 choice
<7>device: '5-0:1.0': device_add
<7>PM: Adding info for usb:5-0:1.0
<7>bus: 'usb': add device 5-0:1.0
<7>bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
<7>bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
<6>hub 5-0:1.0: USB hub found
<6>hub 5-0:1.0: 8 ports detected
<3>hub 2-0:1.0: unable to enumerate USB device on port 2
<4>nvidia: module license 'NVIDIA' taints kernel.
<4>nvidia: no version for "agp_bind_memory" found: kernel tainted.
<4>GSI 29 (level, low) -> IRQ 29
<7>device: 'fw-host0': device_add
<7>driver: '5-0:1.0': driver_bound: bound to device 'hub'
<7>bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
<7>PM: Adding info for ieee1394:fw-host0
<7>bus: 'ieee1394': add device fw-host0
<7>device: 'usbdev5.1_ep81': device_add
<7>driver: 'fw-host0': driver_bound: bound to device 'nodemgr'
<7>device: 'fw-host0': device_add
<7>PM: Adding info for No Bus:usbdev5.1_ep81
<7>PM: Adding info for No Bus:fw-host0
<7>device: 'usbdev5.1': device_add
<7>PM: Adding info for No Bus:usbdev5.1
<7>driver: 'usb5': driver_bound: bound to device 'usb'
<7>bus: 'usb': really_probe: bound device usb5 to driver usb
<7>driver: '0000:00:1d.7': driver_bound: bound to device 'ehci_hcd'
<7>bus: 'pci': really_probe: bound device 0000:00:1d.7 to driver ehci_hcd
<7>bus: 'pci': add driver nvidia
<6>ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[29]
MMIO=[c8204000-c82047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
<7>driver: '0000:03:03.2': driver_bound: bound to device 'ohci1394'
<7>bus: 'pci': really_probe: bound device 0000:03:03.2 to driver ohci1394
<7>bus: 'pci': driver_probe_device: matched device 0000:03:02.0 with
driver aic94xx
<7>bus: 'pci': really_probe: probing driver aic94xx with device 0000:03:02.0
<6>ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 32 (level, low) -> IRQ 32
<5>aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device
0000:03:02.0
<6>scsi10 : aic94xx
<7>device: 'host10': device_add
<7>PM: Adding info for No Bus:host10
<7>CLASS: registering class device: ID = 'host10'
<7>class_uevent - name = host10
<7>CLASS: registering class device: ID = 'host10'
<7>class_uevent - name = host10
<7>device: '0000:03:02.0': device_add
<7>PM: Adding info for No Bus:0000:03:02.0
<6>Linux video capture interface: v2.00
<7>device class 'video4linux': registering
<7>device: '0000:03:02.0': device_unregister
<7>PM: Removing info for No Bus:0000:03:02.0
<5>aic94xx: Found sequencer Firmware version 1.1 (V32)
<5>aic94xx: device 0000:03:02.0: SAS addr 5003048000009260, PCBA SN ORG,
8 phys, 8 enabled phys, flash present, BIOS build 1665
<7>device: 'phy-10:0': device_add
<7>PM: Adding info for No Bus:phy-10:0
<7>CLASS: registering class device: ID = 'phy-10:0'
<7>class_uevent - name = phy-10:0
<7>device: 'phy-10:1': device_add
<7>PM: Adding info for No Bus:phy-10:1
<7>CLASS: registering class device: ID = 'phy-10:1'
<7>class_uevent - name = phy-10:1
<7>device: 'phy-10:2': device_add
<7>PM: Adding info for No Bus:phy-10:2
<7>CLASS: registering class device: ID = 'phy-10:2'
<7>class_uevent - name = phy-10:2
<7>device: 'phy-10:3': device_add
<7>PM: Adding info for No Bus:phy-10:3
<7>CLASS: registering class device: ID = 'phy-10:3'
<7>class_uevent - name = phy-10:3
<7>device: 'phy-10:4': device_add
<7>PM: Adding info for No Bus:phy-10:4
<7>CLASS: registering class device: ID = 'phy-10:4'
<7>class_uevent - name = phy-10:4
<7>device: 'phy-10:5': device_add
<7>PM: Adding info for No Bus:phy-10:5
<7>CLASS: registering class device: ID = 'phy-10:5'
<7>class_uevent - name = phy-10:5
<7>device: 'phy-10:6': device_add
<7>PM: Adding info for No Bus:phy-10:6
<7>CLASS: registering class device: ID = 'phy-10:6'
<7>class_uevent - name = phy-10:6
<7>device: 'phy-10:7': device_add
<7>PM: Adding info for No Bus:phy-10:7
<7>CLASS: registering class device: ID = 'phy-10:7'
<7>class_uevent - name = phy-10:7
<6>cx2388x alsa driver version 0.0.6 loaded
<7>bus: 'pci': add driver cx88_audio
<7>device: 'port-10:0': device_add
<7>PM: Adding info for No Bus:port-10:0
<7>CLASS: registering class device: ID = 'port-10:0'
<7>class_uevent - name = port-10:0
<5>sas: phy-10:0 added to port-10:0, phy_mask:0x1 (5003048000009270)
<7>device: 'port-10:1': device_add
<7>PM: Adding info for No Bus:port-10:1
<7>CLASS: registering class device: ID = 'port-10:1'
<7>class_uevent - name = port-10:1
<5>sas: phy-10:1 added to port-10:1, phy_mask:0x2 (5003048000009271)
<5>sas: DOING DISCOVERY on port 0, pid:1712
<6>cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
<7>device: 'end_device-10:0': device_add
<7>PM: Adding info for No Bus:end_device-10:0
<7>CLASS: registering class device: ID = 'end_device-10:0'
<7>class_uevent - name = end_device-10:0
<7>CLASS: registering class device: ID = 'end_device-10:0'
<7>class_uevent - name = end_device-10:0
<7>device: 'target10:0:0': device_add
<7>PM: Adding info for No Bus:target10:0:0
<7>bus: 'pci': add driver cx88-mpeg driver manager
<6>cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
<7>bus: 'pci': add driver cx8800
<3>hub 5-0:1.0: unable to enumerate USB device on port 4
<6>usb 2-2: new full speed USB device using uhci_hcd and address 4
<7>device: '2-2': device_add
<7>PM: Adding info for usb:2-2
<7>bus: 'usb': add device 2-2
<7>bus: 'usb': driver_probe_device: matched device 2-2 with driver usb
<7>bus: 'usb': really_probe: probing driver usb with device 2-2
<7>device: 'usbdev2.4_ep00': device_add
<7>PM: Adding info for No Bus:usbdev2.4_ep00
<6>usb 2-2: configuration #1 chosen from 1 choice
<7>device: '2-2:1.0': device_add
<7>PM: Adding info for usb:2-2:1.0
<7>bus: 'usb': add device 2-2:1.0
<7>device: 'usbdev2.4_ep82': device_add
<7>PM: Adding info for No Bus:usbdev2.4_ep82
<7>device: '2-2:1.1': device_add
<7>PM: Adding info for usb:2-2:1.1
<7>bus: 'usb': add device 2-2:1.1
<7>device: 'usbdev2.4': device_add
<7>PM: Adding info for No Bus:usbdev2.4
<7>driver: '2-2': driver_bound: bound to device 'usb'
<7>bus: 'usb': really_probe: bound device 2-2 to driver usb
<5>sas: sas_ata_phy_reset: Found ATA device.
<4>ata11.00: native sectors (1) is smaller than sectors (488397168)
<6>ata11.00: ATA-7: HDT722525DLA380, V44OA96A, max UDMA/133
<6>ata11.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
<7>bus: 'usb': add driver cdc_ether
<7>bus: 'usb': driver_probe_device: matched device 2-2:1.0 with driver
cdc_ether
<7>bus: 'usb': really_probe: probing driver cdc_ether with device 2-2:1.0
<7>driver: '2-2:1.1': driver_bound: bound to device 'cdc_ether'
<6>ata11.00: configured for UDMA/133
<7>device: 'usbdev2.4_ep01': device_add
<7>PM: Adding info for No Bus:usbdev2.4_ep01
<5>scsi 10:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0
ANSI: 5
<7>device: 'usbdev2.4_ep81': device_add
<7>PM: Adding info for No Bus:usbdev2.4_ep81
<7>device: '10:0:0:0': device_add
<7>PM: Adding info for scsi:10:0:0:0
<7>bus: 'scsi': add device 10:0:0:0
<7>bus: 'scsi': driver_probe_device: matched device 10:0:0:0 with driver sd
<7>bus: 'scsi': really_probe: probing driver sd with device 10:0:0:0
<7>CLASS: registering class device: ID = '10:0:0:0'
<7>class_uevent - name = 10:0:0:0
<5>sd 10:0:0:0: [sde] 488397168 512-byte hardware sectors (250059 MB)
<7>device: 'eth0': device_add
<5>sd 10:0:0:0: [sde] Write Protect is off
<7>PM: Adding info for No Bus:eth0
<6>eth0: register 'cdc_ether' at usb-0000:00:1d.1-2, CDC Ethernet
Device, 00:04:0e:46:87:31
<7>driver: '2-2:1.0': driver_bound: bound to device 'cdc_ether'
<7>bus: 'usb': really_probe: bound device 2-2:1.0 to driver cdc_ether
<6>usbcore: registered new interface driver cdc_ether
<7>sd 10:0:0:0: [sde] Mode Sense: 00 3a 00 00
<5>sd 10:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
<7>device: 'sde': device_add
<7>PM: Adding info for No Bus:sde
<5>sd 10:0:0:0: [sde] 488397168 512-byte hardware sectors (250059 MB)
<5>sd 10:0:0:0: [sde] Write Protect is off
<7>sd 10:0:0:0: [sde] Mode Sense: 00 3a 00 00
<5>sd 10:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
<6> sde: sde1 sde2 sde3 < sde5 >
<7>device: 'sde1': device_add
<7>PM: Adding info for No Bus:sde1
<7>device: 'sde2': device_add
<7>PM: Adding info for No Bus:sde2
<7>device: 'sde3': device_add
<7>PM: Adding info for No Bus:sde3
<7>device: 'sde5': device_add
<7>PM: Adding info for No Bus:sde5
<5>sd 10:0:0:0: [sde] Attached SCSI disk
<7>driver: '10:0:0:0': driver_bound: bound to device 'sd'
<7>bus: 'scsi': really_probe: bound device 10:0:0:0 to driver sd
<7>CLASS: registering class device: ID = '10:0:0:0'
<7>class_uevent - name = 10:0:0:0
<7>CLASS: registering class device: ID = 'sg7'
<7>class_uevent - name = sg7
<7>class_device_create_uevent called for sg7
<5>sd 10:0:0:0: Attached scsi generic sg7 type 0
<5>sas: DONE DISCOVERY on port 0, pid:1712, result:0
<5>sas: DOING DISCOVERY on port 1, pid:1712
<7>device: 'end_device-10:1': device_add
<7>PM: Adding info for No Bus:end_device-10:1
<7>CLASS: registering class device: ID = 'end_device-10:1'
<7>class_uevent - name = end_device-10:1
<7>CLASS: registering class device: ID = 'end_device-10:1'
<7>class_uevent - name = end_device-10:1
<7>device: 'target10:0:1': device_add
<7>PM: Adding info for No Bus:target10:0:1
<7>device: '00023c00210218a4': device_add
<7>PM: Adding info for ieee1394:00023c00210218a4
<7>bus: 'ieee1394': add device 00023c00210218a4
<7>device: '00023c00210218a4': device_add
<7>PM: Adding info for No Bus:00023c00210218a4
<7>ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00023c00210218a4]
<5>sas: sas_ata_phy_reset: Found ATA device.
<4>ata12.00: native sectors (1) is smaller than sectors (976773168)
<6>ata12.00: ATA-7: Hitachi HDT725050VLA360, V56OA7EA, max UDMA/133
<6>ata12.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
<6>ata12.00: configured for UDMA/133
<5>scsi 10:0:1:0: Direct-Access     ATA      Hitachi HDT72505 V56O PQ: 0
ANSI: 5
<7>device: '10:0:1:0': device_add
<7>PM: Adding info for scsi:10:0:1:0
<7>bus: 'scsi': add device 10:0:1:0
<7>bus: 'scsi': driver_probe_device: matched device 10:0:1:0 with driver sd
<7>bus: 'scsi': really_probe: probing driver sd with device 10:0:1:0
<7>CLASS: registering class device: ID = '10:0:1:0'
<7>class_uevent - name = 10:0:1:0
<5>sd 10:0:1:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
<5>sd 10:0:1:0: [sdf] Write Protect is off
<7>sd 10:0:1:0: [sdf] Mode Sense: 00 3a 00 00
<5>sd 10:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
<7>device: 'sdf': device_add
<7>PM: Adding info for No Bus:sdf
<5>sd 10:0:1:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
<5>sd 10:0:1:0: [sdf] Write Protect is off
<7>sd 10:0:1:0: [sdf] Mode Sense: 00 3a 00 00
<5>sd 10:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
<6> sdf: sdf1 sdf2
<7>device: 'sdf1': device_add
<7>PM: Adding info for No Bus:sdf1
<7>device: 'sdf2': device_add
<7>PM: Adding info for No Bus:sdf2
<5>sd 10:0:1:0: [sdf] Attached SCSI disk
<7>driver: '10:0:1:0': driver_bound: bound to device 'sd'
<7>bus: 'scsi': really_probe: bound device 10:0:1:0 to driver sd
<7>CLASS: registering class device: ID = '10:0:1:0'
<7>class_uevent - name = 10:0:1:0
<7>CLASS: registering class device: ID = 'sg8'
<7>class_uevent - name = sg8
<7>class_device_create_uevent called for sg8
<5>sd 10:0:1:0: Attached scsi generic sg8 type 0
<5>sas: DONE DISCOVERY on port 1, pid:1712, result:0
<5>sas: sas_form_port: phy0 belongs to port0 already(1)!
<5>sas: sas_form_port: phy1 belongs to port1 already(1)!
<7>driver: '0000:03:02.0': driver_bound: bound to device 'aic94xx'
<7>bus: 'pci': really_probe: bound device 0000:03:02.0 to driver aic94xx
<7>bus: 'pci': driver_probe_device: matched device 0000:06:00.0 with
driver nvidia
<7>bus: 'pci': really_probe: probing driver nvidia with device 0000:06:00.0
<6>ACPI: PCI Interrupt 0000:06:00.0[A] -> <7>bus: 'pci':
driver_probe_device: matched device 0000:03:03.1 with driver
Emu10k1_gameport
<7>bus: 'pci': really_probe: probing driver Emu10k1_gameport with device
0000:03:03.1
<7>driver: '0000:03:03.1': driver_bound: bound to device 'Emu10k1_gameport'
<7>bus: 'pci': really_probe: bound device 0000:03:03.1 to driver
Emu10k1_gameport
<6>gameport: EMU10K1 is pci0000:03:03.1/gameport0, io 0x2420, speed 451kHz


output from dmesg:

Kernel: 2.6.25.4-bigsmp #15 SMP

aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
bus: 'pci': add driver aic94xx
device: 'event4': device_add
PM: Adding info for No Bus:event4
ACPI: Power Button (CM) [PWRB]
driver: 'PNP0C0C:00': driver_bound: bound to device 'button'
bus: 'acpi': really_probe: bound device PNP0C0C:00 to driver button
driver: '2-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 2-0:1.0 to driver hub
device: 'usbdev2.1_ep81': device_add
PM: Adding info for No Bus:usbdev2.1_ep81
device: 'usbdev2.1': device_add
PM: Adding info for No Bus:usbdev2.1
driver: 'usb2': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb2 to driver usb
driver: '0000:00:1d.1': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.1 to driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.2 with driver
uhci_hcd
bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> <7>parport_pc 00:0d: driver attached
driver: '00:0d': driver_bound: bound to device 'parport_pc'
bus: 'pnp': really_probe: bound device 00:0d to driver parport_pc
Registering platform device 'parport_pc.956'. Parent at platform
device: 'parport_pc.956': device_add
PM: Adding info for platform:parport_pc.956
bus: 'platform': add device parport_pc.956
bus: 'platform': driver_probe_device: matched device parport_pc.956 with
driver parport_pc
bus: 'platform': really_probe: probing driver parport_pc with device
parport_pc.956
driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
bus: 'platform': really_probe: bound device parport_pc.956 to driver
parport_pc
PM: Removing info for platform:parport_pc.956
bus: 'platform': remove device parport_pc.956
Registering platform device 'parport_pc.888'. Parent at platform
device: 'parport_pc.888': device_add
PM: Adding info for platform:parport_pc.888
bus: 'platform': add device parport_pc.888
bus: 'platform': driver_probe_device: matched device parport_pc.888 with
driver parport_pc
bus: 'platform': really_probe: probing driver parport_pc with device
parport_pc.888
driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
bus: 'platform': really_probe: bound device parport_pc.888 to driver
parport_pc
PM: Removing info for platform:parport_pc.888
bus: 'platform': remove device parport_pc.888
Registering platform device 'parport_pc.632'. Parent at platform
device: 'parport_pc.632': device_add
PM: Adding info for platform:parport_pc.632
bus: 'platform': add device parport_pc.632
bus: 'platform': driver_probe_device: matched device parport_pc.632 with
driver parport_pc
bus: 'platform': really_probe: probing driver parport_pc with device
parport_pc.632
driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
bus: 'platform': really_probe: bound device parport_pc.632 to driver
parport_pc
PM: Removing info for platform:parport_pc.632
bus: 'platform': remove device parport_pc.632
bus: 'pci': add driver parport_pc
GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
device: 'usb_host3': device_add
bus: 'i2c': add driver tveeprom
PM: Adding info for No Bus:usb_host3
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001440
device: 'usb3': device_add
PM: Adding info for usb:usb3
bus: 'usb': add device usb3
bus: 'usb': driver_probe_device: matched device usb3 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb3
device: 'usbdev3.1_ep00': device_add
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
device: '3-0:1.0': device_add
PM: Adding info for usb:3-0:1.0
bus: 'usb': add device 3-0:1.0
bus: 'usb': driver_probe_device: matched device 3-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
bus: 'pci': add driver Emu10k1_gameport
bus: 'acpi': add driver thermal
bus: 'acpi': driver_probe_device: matched device LNXTHERM:00 with driver
thermal
bus: 'acpi': really_probe: probing driver thermal with device LNXTHERM:00
device class 'ppdev': registering
device: 'parport0': device_add
PM: Adding info for No Bus:parport0
ppdev: user-space parallel port driver
driver: '3-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 3-0:1.0 to driver hub
device: 'usbdev3.1_ep81': device_add
PM: Adding info for No Bus:usbdev3.1_ep81
device: 'usbdev3.1': device_add
PM: Adding info for No Bus:usbdev3.1
driver: 'usb3': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb3 to driver usb
driver: '0000:00:1d.2': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.2 to driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.3 with driver
uhci_hcd
bus: 'pci': really_probe: probing driver uhci_hcd with device 0000:00:1d.3
ACPI: PCI Interrupt 0000:00:1d.3[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
device: 'usb_host4': device_add
PM: Adding info for No Bus:usb_host4
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001460
device: 'usb4': device_add
PM: Adding info for usb:usb4
bus: 'usb': add device usb4
bus: 'usb': driver_probe_device: matched device usb4 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb4
device: 'usbdev4.1_ep00': device_add
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
device: '4-0:1.0': device_add
usb 2-2: new full speed USB device using uhci_hcd and address 2
PM: Adding info for usb:4-0:1.0
bus: 'usb': add device 4-0:1.0
bus: 'usb': driver_probe_device: matched device 4-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
driver: '4-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 4-0:1.0 to driver hub
device: 'usbdev4.1_ep81': device_add
PM: Adding info for No Bus:usbdev4.1_ep81
device: 'usbdev4.1': device_add
PM: Adding info for No Bus:usbdev4.1
driver: 'usb4': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb4 to driver usb
driver: '0000:00:1d.3': driver_bound: bound to device 'uhci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.3 to driver uhci_hcd
bus: 'pci': driver_probe_device: matched device 0000:00:1d.7 with driver
ehci_hcd
bus: 'pci': driver_probe_device: matched device 0000:03:03.2 with driver
ohci1394
bus: 'pci': really_probe: probing driver ohci1394 with device 0000:03:03.2
bus: 'pci': really_probe: probing driver ehci_hcd with device 0000:00:1d.7
ACPI: PCI Interrupt 0000:03:03.2[B] -> <6>ACPI: PCI Interrupt
0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
device: 'usb_host5': device_add
PM: Adding info for No Bus:usb_host5
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xc8000000
usb 2-2: unable to read config index 0 descriptor/all
usb 2-2: can't read configurations, error -71
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
device: 'usb5': device_add
PM: Adding info for usb:usb5
bus: 'usb': add device usb5
bus: 'usb': driver_probe_device: matched device usb5 with driver usb
bus: 'usb': really_probe: probing driver usb with device usb5
device: 'usbdev5.1_ep00': device_add
PM: Adding info for No Bus:usbdev5.1_ep00
usb usb5: configuration #1 chosen from 1 choice
device: '5-0:1.0': device_add
PM: Adding info for usb:5-0:1.0
bus: 'usb': add device 5-0:1.0
bus: 'usb': driver_probe_device: matched device 5-0:1.0 with driver hub
bus: 'usb': really_probe: probing driver hub with device 5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
hub 2-0:1.0: unable to enumerate USB device on port 2
nvidia: module license 'NVIDIA' taints kernel.
nvidia: no version for "agp_bind_memory" found: kernel tainted.
GSI 29 (level, low) -> IRQ 29
device: 'fw-host0': device_add
driver: '5-0:1.0': driver_bound: bound to device 'hub'
bus: 'usb': really_probe: bound device 5-0:1.0 to driver hub
PM: Adding info for ieee1394:fw-host0
bus: 'ieee1394': add device fw-host0
device: 'usbdev5.1_ep81': device_add
driver: 'fw-host0': driver_bound: bound to device 'nodemgr'
device: 'fw-host0': device_add
PM: Adding info for No Bus:usbdev5.1_ep81
PM: Adding info for No Bus:fw-host0
device: 'usbdev5.1': device_add
PM: Adding info for No Bus:usbdev5.1
driver: 'usb5': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device usb5 to driver usb
driver: '0000:00:1d.7': driver_bound: bound to device 'ehci_hcd'
bus: 'pci': really_probe: bound device 0000:00:1d.7 to driver ehci_hcd
bus: 'pci': add driver nvidia
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[29]
MMIO=[c8204000-c82047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
driver: '0000:03:03.2': driver_bound: bound to device 'ohci1394'
bus: 'pci': really_probe: bound device 0000:03:03.2 to driver ohci1394
bus: 'pci': driver_probe_device: matched device 0000:03:02.0 with driver
aic94xx
bus: 'pci': really_probe: probing driver aic94xx with device 0000:03:02.0
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 32 (level, low) -> IRQ 32
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:03:02.0
scsi10 : aic94xx
device: 'host10': device_add
PM: Adding info for No Bus:host10
CLASS: registering class device: ID = 'host10'
class_uevent - name = host10
CLASS: registering class device: ID = 'host10'
class_uevent - name = host10
device: '0000:03:02.0': device_add
PM: Adding info for No Bus:0000:03:02.0
Linux video capture interface: v2.00
device class 'video4linux': registering
device: '0000:03:02.0': device_unregister
PM: Removing info for No Bus:0000:03:02.0
aic94xx: Found sequencer Firmware version 1.1 (V32)
aic94xx: device 0000:03:02.0: SAS addr 5003048000009260, PCBA SN ORG, 8
phys, 8 enabled phys, flash present, BIOS build 1665
device: 'phy-10:0': device_add
PM: Adding info for No Bus:phy-10:0
CLASS: registering class device: ID = 'phy-10:0'
class_uevent - name = phy-10:0
device: 'phy-10:1': device_add
PM: Adding info for No Bus:phy-10:1
CLASS: registering class device: ID = 'phy-10:1'
class_uevent - name = phy-10:1
device: 'phy-10:2': device_add
PM: Adding info for No Bus:phy-10:2
CLASS: registering class device: ID = 'phy-10:2'
class_uevent - name = phy-10:2
device: 'phy-10:3': device_add
PM: Adding info for No Bus:phy-10:3
CLASS: registering class device: ID = 'phy-10:3'
class_uevent - name = phy-10:3
device: 'phy-10:4': device_add
PM: Adding info for No Bus:phy-10:4
CLASS: registering class device: ID = 'phy-10:4'
class_uevent - name = phy-10:4
device: 'phy-10:5': device_add
PM: Adding info for No Bus:phy-10:5
CLASS: registering class device: ID = 'phy-10:5'
class_uevent - name = phy-10:5
device: 'phy-10:6': device_add
PM: Adding info for No Bus:phy-10:6
CLASS: registering class device: ID = 'phy-10:6'
class_uevent - name = phy-10:6
device: 'phy-10:7': device_add
PM: Adding info for No Bus:phy-10:7
CLASS: registering class device: ID = 'phy-10:7'
class_uevent - name = phy-10:7
cx2388x alsa driver version 0.0.6 loaded
bus: 'pci': add driver cx88_audio
device: 'port-10:0': device_add
PM: Adding info for No Bus:port-10:0
CLASS: registering class device: ID = 'port-10:0'
class_uevent - name = port-10:0
sas: phy-10:0 added to port-10:0, phy_mask:0x1 (5003048000009270)
device: 'port-10:1': device_add
PM: Adding info for No Bus:port-10:1
CLASS: registering class device: ID = 'port-10:1'
class_uevent - name = port-10:1
sas: phy-10:1 added to port-10:1, phy_mask:0x2 (5003048000009271)
sas: DOING DISCOVERY on port 0, pid:1712
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
device: 'end_device-10:0': device_add
PM: Adding info for No Bus:end_device-10:0
CLASS: registering class device: ID = 'end_device-10:0'
class_uevent - name = end_device-10:0
CLASS: registering class device: ID = 'end_device-10:0'
class_uevent - name = end_device-10:0
device: 'target10:0:0': device_add
PM: Adding info for No Bus:target10:0:0
bus: 'pci': add driver cx88-mpeg driver manager
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
bus: 'pci': add driver cx8800
hub 5-0:1.0: unable to enumerate USB device on port 4
usb 2-2: new full speed USB device using uhci_hcd and address 4
device: '2-2': device_add
PM: Adding info for usb:2-2
bus: 'usb': add device 2-2
bus: 'usb': driver_probe_device: matched device 2-2 with driver usb
bus: 'usb': really_probe: probing driver usb with device 2-2
device: 'usbdev2.4_ep00': device_add
PM: Adding info for No Bus:usbdev2.4_ep00
usb 2-2: configuration #1 chosen from 1 choice
device: '2-2:1.0': device_add
PM: Adding info for usb:2-2:1.0
bus: 'usb': add device 2-2:1.0
device: 'usbdev2.4_ep82': device_add
PM: Adding info for No Bus:usbdev2.4_ep82
device: '2-2:1.1': device_add
PM: Adding info for usb:2-2:1.1
bus: 'usb': add device 2-2:1.1
device: 'usbdev2.4': device_add
PM: Adding info for No Bus:usbdev2.4
driver: '2-2': driver_bound: bound to device 'usb'
bus: 'usb': really_probe: bound device 2-2 to driver usb
sas: sas_ata_phy_reset: Found ATA device.
ata11.00: native sectors (1) is smaller than sectors (488397168)
ata11.00: ATA-7: HDT722525DLA380, V44OA96A, max UDMA/133
ata11.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
bus: 'usb': add driver cdc_ether
bus: 'usb': driver_probe_device: matched device 2-2:1.0 with driver
cdc_ether
bus: 'usb': really_probe: probing driver cdc_ether with device 2-2:1.0
driver: '2-2:1.1': driver_bound: bound to device 'cdc_ether'
ata11.00: configured for UDMA/133
device: 'usbdev2.4_ep01': device_add
PM: Adding info for No Bus:usbdev2.4_ep01
scsi 10:0:0:0: Direct-Access     ATA      HDT722525DLA380  V44O PQ: 0
ANSI: 5
device: 'usbdev2.4_ep81': device_add
PM: Adding info for No Bus:usbdev2.4_ep81
device: '10:0:0:0': device_add
PM: Adding info for scsi:10:0:0:0
bus: 'scsi': add device 10:0:0:0
bus: 'scsi': driver_probe_device: matched device 10:0:0:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 10:0:0:0
CLASS: registering class device: ID = '10:0:0:0'
class_uevent - name = 10:0:0:0
sd 10:0:0:0: [sde] 488397168 512-byte hardware sectors (250059 MB)
device: 'eth0': device_add
sd 10:0:0:0: [sde] Write Protect is off
PM: Adding info for No Bus:eth0
eth0: register 'cdc_ether' at usb-0000:00:1d.1-2, CDC Ethernet Device,
00:04:0e:46:87:31
driver: '2-2:1.0': driver_bound: bound to device 'cdc_ether'
bus: 'usb': really_probe: bound device 2-2:1.0 to driver cdc_ether
usbcore: registered new interface driver cdc_ether
sd 10:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
device: 'sde': device_add
PM: Adding info for No Bus:sde
sd 10:0:0:0: [sde] 488397168 512-byte hardware sectors (250059 MB)
sd 10:0:0:0: [sde] Write Protect is off
sd 10:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
  sde: sde1 sde2 sde3 < sde5 >
device: 'sde1': device_add
PM: Adding info for No Bus:sde1
device: 'sde2': device_add
PM: Adding info for No Bus:sde2
device: 'sde3': device_add
PM: Adding info for No Bus:sde3
device: 'sde5': device_add
PM: Adding info for No Bus:sde5
sd 10:0:0:0: [sde] Attached SCSI disk
driver: '10:0:0:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 10:0:0:0 to driver sd
CLASS: registering class device: ID = '10:0:0:0'
class_uevent - name = 10:0:0:0
CLASS: registering class device: ID = 'sg7'
class_uevent - name = sg7
class_device_create_uevent called for sg7
sd 10:0:0:0: Attached scsi generic sg7 type 0
sas: DONE DISCOVERY on port 0, pid:1712, result:0
sas: DOING DISCOVERY on port 1, pid:1712
device: 'end_device-10:1': device_add
PM: Adding info for No Bus:end_device-10:1
CLASS: registering class device: ID = 'end_device-10:1'
class_uevent - name = end_device-10:1
CLASS: registering class device: ID = 'end_device-10:1'
class_uevent - name = end_device-10:1
device: 'target10:0:1': device_add
PM: Adding info for No Bus:target10:0:1
device: '00023c00210218a4': device_add
PM: Adding info for ieee1394:00023c00210218a4
bus: 'ieee1394': add device 00023c00210218a4
device: '00023c00210218a4': device_add
PM: Adding info for No Bus:00023c00210218a4
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00023c00210218a4]
sas: sas_ata_phy_reset: Found ATA device.
ata12.00: native sectors (1) is smaller than sectors (976773168)
ata12.00: ATA-7: Hitachi HDT725050VLA360, V56OA7EA, max UDMA/133
ata12.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata12.00: configured for UDMA/133
scsi 10:0:1:0: Direct-Access     ATA      Hitachi HDT72505 V56O PQ: 0
ANSI: 5
device: '10:0:1:0': device_add
PM: Adding info for scsi:10:0:1:0
bus: 'scsi': add device 10:0:1:0
bus: 'scsi': driver_probe_device: matched device 10:0:1:0 with driver sd
bus: 'scsi': really_probe: probing driver sd with device 10:0:1:0
CLASS: registering class device: ID = '10:0:1:0'
class_uevent - name = 10:0:1:0
sd 10:0:1:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 10:0:1:0: [sdf] Write Protect is off
sd 10:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 10:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
device: 'sdf': device_add
PM: Adding info for No Bus:sdf
sd 10:0:1:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 10:0:1:0: [sdf] Write Protect is off
sd 10:0:1:0: [sdf] Mode Sense: 00 3a 00 00
sd 10:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
  sdf: sdf1 sdf2
device: 'sdf1': device_add
PM: Adding info for No Bus:sdf1
device: 'sdf2': device_add
PM: Adding info for No Bus:sdf2
sd 10:0:1:0: [sdf] Attached SCSI disk
driver: '10:0:1:0': driver_bound: bound to device 'sd'
bus: 'scsi': really_probe: bound device 10:0:1:0 to driver sd
CLASS: registering class device: ID = '10:0:1:0'
class_uevent - name = 10:0:1:0
CLASS: registering class device: ID = 'sg8'
class_uevent - name = sg8
class_device_create_uevent called for sg8
sd 10:0:1:0: Attached scsi generic sg8 type 0
sas: DONE DISCOVERY on port 1, pid:1712, result:0
sas: sas_form_port: phy0 belongs to port0 already(1)!
sas: sas_form_port: phy1 belongs to port1 already(1)!
driver: '0000:03:02.0': driver_bound: bound to device 'aic94xx'
bus: 'pci': really_probe: bound device 0000:03:02.0 to driver aic94xx
bus: 'pci': driver_probe_device: matched device 0000:06:00.0 with driver
nvidia
bus: 'pci': really_probe: probing driver nvidia with device 0000:06:00.0
ACPI: PCI Interrupt 0000:06:00.0[A] -> <7>bus: 'pci':
driver_probe_device: matched device 0000:03:03.1 with driver
Emu10k1_gameport
bus: 'pci': really_probe: probing driver Emu10k1_gameport with device
0000:03:03.1
driver: '0000:03:03.1': driver_bound: bound to device 'Emu10k1_gameport'


-- 
Dipl.-Ing. Thomas Lange

JC-Embedded Systems GmbH
Lise-Meitner-Str. 1-9
42119 Wuppertal
Tel.  +49 (202)  31713161
Fax  +49 (202)  31713180
www.jc-embedded.com


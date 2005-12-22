From: Michael Reed <mdr@sgi.com>
Subject: More FC Transport Issues
Date: Thu, 22 Dec 2005 17:29:00 -0600
Message-ID: <43AB36BC.8000003@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:44976 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030372AbVLVX33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 18:29:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James.Smart@Emulex.Com, James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Hello,

I installed 2.6.15-rc6-git3 on my ia64 test system and the system hung during
startup.  There were "recursion depth exceeded" messages.

The fabric was coming online at the time of hba startup and the targets
hadn't yet been discovered by the switch.  Consequently, the hbas saw
loop up but no targets, then the switch generates a state change notification
and the driver for the hbas discovers the targets in parallel.

So, there appears to be another recursion issue with the new fc transport.

I then try rebooting the system again.  Discovery happens as expected
at the time the driver initializes each card.  Then the system takes an
OOPS.

It's possible the OOPS is related to the qla2xxx serialization issue I reported
earlier.

http://marc.theaimsgroup.com/?l=linux-scsi&m=113380446825841&w=2
http://marc.theaimsgroup.com/?l=linux-scsi&m=113458339109319&w=2

I tried a third time and got the same OOPS.  Repeatable.


Mike

******************
* recursion issue
******************

QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0002:01:04.0[A]: no GSI
qla2300 0002:01:04.0: Found an ISP2312, irq 74, iobase 0xc00000080fd00000
qla2300 0002:01:04.0: Configuring PCI space...
PCI: slot 0002:01:04.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.0: Configure NVRAM parameters...
qla2300 0002:01:04.0: Verifying loaded RISC code...
qla2300 0002:01:04.0: LIP reset occured (f7f7).
qla2300 0002:01:04.0: Waiting for LIP to complete...
qla2300 0002:01:04.0: LIP reset occured (f800).
qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.0: Topology - (F_Port), Host Loop address 0xffff
scsi2 : qla2xxx
qla2300 0002:01:04.0:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:04.0 hdma+, host#=2, fw=3.03.18 IPX
ACPI: PCI Interrupt 0002:01:04.1[B]: no GSI
qla2300 0002:01:04.1: Found an ISP2312, irq 75, iobase 0xc00000080fd20000
qla2300 0002:01:04.1: Configuring PCI space...
PCI: slot 0002:01:04.1 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.1: Configure NVRAM parameters...
qla2300 0002:01:04.1: Verifying loaded RISC code...
qla2300 0002:01:04.1: LIP reset occured (f7f7).
qla2300 0002:01:04.1: Waiting for LIP to complete...
qla2300 0002:01:04.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.1: Topology - (F_Port), Host Loop address 0xffff
scsi3 : qla2xxx
qla2300 0002:01:04.1:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:04.1 hdma+, host#=3, fw=3.03.18 IPX
ACPI: PCI Interrupt 0002:01:06.0[A]: no GSI
qla2300 0002:01:06.0: Found an ISP2312, irq 74, iobase 0xc00000080fd40000
qla2300 0002:01:06.0: Configuring PCI space...
PCI: slot 0002:01:06.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:06.0: Configure NVRAM parameters...
qla2300 0002:01:06.0: Verifying loaded RISC code...
qla2300 0002:01:06.0: Waiting for LIP to complete...
qla2300 0002:01:06.0: LIP reset occured (f800).
qla2300 0002:01:06.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.0: Topology - (F_Port), Host Loop address 0xffff
scsi4 : qla2xxx
qla2300 0002:01:06.0:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:06.0 hdma+, host#=4, fw=3.03.18 IPX
ACPI: PCI Interrupt 0002:01:06.1[B]: no GSI
qla2300 0002:01:06.1: Found an ISP2312, irq 75, iobase 0xc00000080fd60000
qla2300 0002:01:06.1: Configuring PCI space...
PCI: slot 0002:01:06.1 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:06.1: Configure NVRAM parameters...
qla2300 0002:01:06.1: Verifying loaded RISC code...
qla2300 0002:01:06.1: Waiting for LIP to complete...
qla2300 0002:01:06.1: LIP reset occured (f7f7).
qla2300 0002:01:06.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.1: Topology - (F_Port), Host Loop address 0xffff
scsi5 : qla2xxx
qla2300 0002:01:06.1:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:06.1 hdma+, host#=5, fw=3.03.18 IPX
ACPI: PCI Interrupt 0012:00:01.0[A]: no GSI
qla2300 0012:00:01.0: Found an ISP2312, irq 60, iobase 0xc00000880fe00000
qla2300 0012:00:01.0: Configuring PCI space...
qla2300 0012:00:01.0: Configure NVRAM parameters...
qla2300 0012:00:01.0: Verifying loaded RISC code...
qla2300 0012:00:01.0: LIP reset occured (f7f7).
qla2300 0012:00:01.0: Waiting for LIP to complete...
qla2300 0012:00:01.0: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi6 : qla2xxx
qla2300 0012:00:01.0:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:01.0 hdma+, host#=6, fw=3.03.18 IPX
ACPI: PCI Interrupt 0012:00:01.1[B]: no GSI
qla2300 0012:00:01.1: Found an ISP2312, irq 61, iobase 0xc00000880fe01000
qla2300 0012:00:01.1: Configuring PCI space...
qla2300 0012:00:01.1: Configure NVRAM parameters...
qla2300 0012:00:01.1: Verifying loaded RISC code...
qla2300 0012:00:01.1: LIP reset occured (f800).
qla2300 0012:00:01.1: Waiting for LIP to complete...
qla2300 0012:00:01.1: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.1: Topology - (F_Port), Host Loop address 0xffff
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0012:00:01.1: Waiting for LIP to complete...
qla2300 0012:00:01.1: Topology - (F_Port), Host Loop address 0xffff
qla2300 0012:00:01.1: Waiting for LIP to complete...
qla2300 0012:00:01.1: Topology - (F_Port), Host Loop address 0xffff
scsi7 : qla2xxx
run_workqueue: recursion depth exceeded: 4
qla2300 0012:00:01.1:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:01.1 hdma+, host#=7, fw=3.03.18 IPX

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e0000034f7be7990 bsp=e0000034f7be12c0
 [<a000000100013af0>] dump_stack+0x30/0x60
                                sp=e0000034f7be7b60 bsp=e0000034f7be12a8
 [<a0000001000d3e70>] flush_cpu_workqueue+0xb0/0x440
                                sp=e0000034f7be7b60 bsp=e0000034f7be1260
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1238
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1220
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be11d0
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1188
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7be0 bsp=e0000034f7be1168
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7be0 bsp=e0000034f7be1120
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7c40 bsp=e0000034f7be10f8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7c40 bsp=e0000034f7be10e0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1098
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1050
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7c60 bsp=e0000034f7be1030
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7c60 bsp=e0000034f7be0fe0
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fb8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fa0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f58
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f10
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ef0
 [<a0000001000d3ca0>] worker_thread+0x380/0x4a0
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ea8
 [<a0000001000df460>] kthread+0x240/0x2c0
                                sp=e0000034f7be7d50 bsp=e0000034f7be0e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
run_workqueue: recursion depth exceeded: 5

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e0000034f7be7910 bsp=e0000034f7be1400
 [<a000000100013af0>] dump_stack+0x30/0x60
                                sp=e0000034f7be7ae0 bsp=e0000034f7be13e0
 [<a0000001000d3e70>] flush_cpu_workqueue+0xb0/0x440
                                sp=e0000034f7be7ae0 bsp=e0000034f7be1398
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7b40 bsp=e0000034f7be1370
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7b40 bsp=e0000034f7be1358
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7b40 bsp=e0000034f7be1310
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7b40 bsp=e0000034f7be12c8
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7b60 bsp=e0000034f7be12a8
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7b60 bsp=e0000034f7be1260
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1238
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1220
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be11d0
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1188
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7be0 bsp=e0000034f7be1168
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7be0 bsp=e0000034f7be1120
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7c40 bsp=e0000034f7be10f8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7c40 bsp=e0000034f7be10e0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1098
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1050
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7c60 bsp=e0000034f7be1030
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7c60 bsp=e0000034f7be0fe0
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fb8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fa0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f58
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f10
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ef0
 [<a0000001000d3ca0>] worker_thread+0x380/0x4a0
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ea8
 [<a0000001000df460>] kthread+0x240/0x2c0
                                sp=e0000034f7be7d50 bsp=e0000034f7be0e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access     run_workqueue: recursion depth exceeded: 6

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e0000034f7be7890 bsp=e0000034f7be1538
 [<a000000100013af0>] dump_stack+0x30/0x60
                                sp=e0000034f7be7a60 bsp=e0000034f7be1520
 [<a0000001000d3e70>] flush_cpu_workqueue+0xb0/0x440
                                sp=e0000034f7be7a60 bsp=e0000034f7be14d8
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7ac0 bsp=e0000034f7be14b0
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7ac0 bsp=e0000034f7be1498
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7ac0 bsp=e0000034f7be1450
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7ac0 bsp=e0000034f7be1408
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7ae0 bsp=e0000034f7be13e0
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7ae0 bsp=e0000034f7be1398
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7b40 bsp=e0000034f7be1370
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7b40 bsp=e0000034f7be1358
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7b40 bsp=e0000034f7be1310
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7b40 bsp=e0000034f7be12c8
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7b60 bsp=e0000034f7be12a8
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7b60 bsp=e0000034f7be1260
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1238
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1220
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be11d0
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1188
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7be0 bsp=e0000034f7be1168
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7be0 bsp=e0000034f7be1120
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7c40 bsp=e0000034f7be10f8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7c40 bsp=e0000034f7be10e0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1098
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1050
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7c60 bsp=e0000034f7be1030
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7c60 bsp=e0000034f7be0fe0
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fb8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fa0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f58
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f10
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ef0
 [<a0000001000d3ca0>] worker_thread+0x380/0x4a0
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ea8
 [<a0000001000df460>] kthread+0x240/0x2c0
                                sp=e0000034f7be7d50 bsp=e0000034f7be0e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
run_workqueue: recursion depth exceeded: 7

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e0000034f7be7810 bsp=e0000034f7be1678
 [<a000000100013af0>] dump_stack+0x30/0x60
                                sp=e0000034f7be79e0 bsp=e0000034f7be1660
 [<a0000001000d3e70>] flush_cpu_workqueue+0xb0/0x440
                                sp=e0000034f7be79e0 bsp=e0000034f7be1618
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7a40 bsp=e0000034f7be15e8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7a40 bsp=e0000034f7be15d0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7a40 bsp=e0000034f7be1588
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7a40 bsp=e0000034f7be1540
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7a60 bsp=e0000034f7be1520
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7a60 bsp=e0000034f7be14d8
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7ac0 bsp=e0000034f7be14b0
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7ac0 bsp=e0000034f7be1498
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7ac0 bsp=e0000034f7be1450
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7ac0 bsp=e0000034f7be1408
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7ae0 bsp=e0000034f7be13e0
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7ae0 bsp=e0000034f7be1398
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7b40 bsp=e0000034f7be1370
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7b40 bsp=e0000034f7be1358
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7b40 bsp=e0000034f7be1310
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7b40 bsp=e0000034f7be12c8
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7b60 bsp=e0000034f7be12a8
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7b60 bsp=e0000034f7be1260
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1238
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1220
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be11d0
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7bc0 bsp=e0000034f7be1188
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7be0 bsp=e0000034f7be1168
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7be0 bsp=e0000034f7be1120
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7c40 bsp=e0000034f7be10f8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7c40 bsp=e0000034f7be10e0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1098
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7c40 bsp=e0000034f7be1050
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7c60 bsp=e0000034f7be1030
 [<a0000001000d3fb0>] flush_cpu_workqueue+0x1f0/0x440
                                sp=e0000034f7be7c60 bsp=e0000034f7be0fe0
 [<a0000001000d43f0>] flush_workqueue+0x1f0/0x280
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fb8
 [<a0000001000d45c0>] flush_scheduled_work+0x20/0x40
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0fa0
 [<a000000100528260>] fc_remote_port_rolechg+0x1a0/0x1e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f58
 [<a000000100542100>] qla2x00_reg_remote_port+0x360/0x3e0
                                sp=e0000034f7be7cc0 bsp=e0000034f7be0f10
 [<a000000100542710>] qla2x00_rport_add+0x30/0x60
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ef0
 [<a0000001000d3ca0>] worker_thread+0x380/0x4a0
                                sp=e0000034f7be7ce0 bsp=e0000034f7be0ea8
 [<a0000001000df460>] kthread+0x240/0x2c0
                                sp=e0000034f7be7d50 bsp=e0000034f7be0e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f7be7e30 bsp=e0000034f7be0e40



*************
* oops
*************

ACPI: PCI Interrupt 0011:00:03.0[A]: no GSI
scsi(1): Enabling SN2 PCI DMA dual channel lockup workaround
scsi(1): Enabling SN2 PCI DMA workaround
scsi(1:0): Resetting SCSI BUS
scsi(1:1): Resetting SCSI BUS
scsi1 : QLogic QLA12160 PCI to SCSI Host Adapter
       Firmware version: 10.04.42, Driver version 3.25
  Vendor: SGI       Model: ST373307LC        Rev: 2743
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(1:0:1:0): Sync: period 9, offset 14, Wide, DT
  Vendor: SGI       Model: ST373307LC        Rev: 2743
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi(1:0:2:0): Sync: period 9, offset 14, Wide, DT
QLogic Fibre Channel HBA Driver
ACPI: PCI Interrupt 0002:01:04.0[A]: no GSI
qla2300 0002:01:04.0: Found an ISP2312, irq 74, iobase 0xc00000080fd00000
qla2300 0002:01:04.0: Configuring PCI space...
PCI: slot 0002:01:04.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.0: Configure NVRAM parameters...
qla2300 0002:01:04.0: Verifying loaded RISC code...
qla2300 0002:01:04.0: LIP reset occured (f7f7).
qla2300 0002:01:04.0: Waiting for LIP to complete...
qla2300 0002:01:04.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:04.0: Topology - (F_Port), Host Loop address 0xffff
BUG: soft lockup detected on CPU#0!
Modules linked in:

Pid: 1, CPU 0, comm:              swapper
psr : 00001210081a6018 ifs : 8000000000000286 ip  : [<a0000001006c77c1>]    Not tainted
ip is at _spin_unlock_irqrestore+0x41/0xa0
unat: 0000000000000000 pfs : 0000000000000691 rsc : 0000000000000003
rnat: 0000000000000286 bsps: 0000000000000003 pr  : 00000001502a9a55
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a0000001005537f0 b6  : e0000030023e5490 b7  : a000000100553260
f6  : 1003e00000000000003e8 f7  : 0ffe4c000000000000000
f8  : 1003e0000000000002710 f9  : 1003e000000000000000a
f10 : 10000bffffffff4000000 f11 : 1003e0000000000000003
r1  : a000000100cc2100 r2  : 0000000000000001 r3  : a000000100ac2850
r8  : 0000000000004000 r9  : 0000000000004000 r10 : e000003003104232
r11 : 0000000000000000 r12 : e00000b07bb279f0 r13 : e00000b07bb20000
r14 : e000003014d48000 r15 : 0000000000000011 r16 : e000003014d49370
r17 : 0000000000000000 r18 : e000003014d49378 r19 : 0000000000000000
r20 : 0000000000000020 r21 : 0000000000000000 r22 : e000003003104231
r23 : ffffffffffff4230 r24 : 0000000000000078 r25 : 0000000000000000
r26 : 0000000000000012 r27 : c00000080fe30000 r28 : c00000080fa00200
r29 : e000003014d49370 r30 : 0000000000000088 r31 : a0000001007648d8

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e00000b07bb27640 bsp=e00000b07bb21660
 [<a000000100013a90>] show_regs+0x7d0/0x800
                                sp=e00000b07bb27810 bsp=e00000b07bb21610
 [<a0000001000fa020>] softlockup_tick+0x140/0x180
                                sp=e00000b07bb27810 bsp=e00000b07bb215d8
 [<a0000001000c3f30>] do_timer+0x9f0/0xa20
                                sp=e00000b07bb27820 bsp=e00000b07bb21598
 [<a0000001000353f0>] timer_interrupt+0x1d0/0x380
                                sp=e00000b07bb27820 bsp=e00000b07bb21558
 [<a0000001000fa1f0>] handle_IRQ_event+0x90/0x120
                                sp=e00000b07bb27820 bsp=e00000b07bb21518
 [<a0000001000fa3a0>] __do_IRQ+0x120/0x360
                                sp=e00000b07bb27820 bsp=e00000b07bb214c8
 [<a000000100010160>] ia64_handle_irq+0xa0/0x140
                                sp=e00000b07bb27820 bsp=e00000b07bb21498
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
                                sp=e00000b07bb27820 bsp=e00000b07bb21498
 [<a0000001006c77c0>] _spin_unlock_irqrestore+0x40/0xa0
                                sp=e00000b07bb279f0 bsp=e00000b07bb21468
 [<a0000001005537f0>] qla2300_intr_handler+0x590/0x6c0
                                sp=e00000b07bb279f0 bsp=e00000b07bb21400
 [<a00000010054a570>] qla2x00_mailbox_command+0x5b0/0xb60
                                sp=e00000b07bb27a00 bsp=e00000b07bb21368
 [<a00000010054b430>] qla2x00_login_fabric+0x150/0x240
                                sp=e00000b07bb27a40 bsp=e00000b07bb21310
 [<a000000100541970>] qla2x00_fabric_login+0x90/0x3a0
                                sp=e00000b07bb27aa0 bsp=e00000b07bb212b0
 [<a0000001005423d0>] qla2x00_fabric_dev_login+0x30/0x160
                                sp=e00000b07bb27ae0 bsp=e00000b07bb21280
 [<a000000100544ec0>] qla2x00_configure_loop+0x25a0/0x27e0
                                sp=e00000b07bb27ae0 bsp=e00000b07bb211e0
 [<a000000100546160>] qla2x00_initialize_adapter+0x4a0/0x6a0
                                sp=e00000b07bb27ba0 bsp=e00000b07bb21170
 [<a00000010053c2f0>] qla2x00_probe_one+0x16b0/0x1f60
                                sp=e00000b07bb27ba0 bsp=e00000b07bb21078
 [<a0000001005685d0>] qla2300_probe_one+0x30/0x60
                                sp=e00000b07bb27c50 bsp=e00000b07bb21050
 [<a0000001003f3df0>] pci_device_probe+0x290/0x3c0
                                sp=e00000b07bb27c50 bsp=e00000b07bb21008
 [<a0000001004a75c0>] driver_probe_device+0xe0/0x180
                                sp=e00000b07bb27d20 bsp=e00000b07bb20fc8
 [<a0000001004a76d0>] __driver_attach+0x70/0xc0
                                sp=e00000b07bb27d20 bsp=e00000b07bb20f98
 [<a0000001004a6910>] bus_for_each_dev+0x90/0x120
                                sp=e00000b07bb27d20 bsp=e00000b07bb20f58
 [<a0000001004a72d0>] driver_attach+0x30/0x60
                                sp=e00000b07bb27d40 bsp=e00000b07bb20f38
 [<a0000001004a5de0>] bus_add_driver+0xe0/0x2c0
                                sp=e00000b07bb27d40 bsp=e00000b07bb20ef8
 [<a0000001004a78e0>] driver_register+0xa0/0xc0
                                sp=e00000b07bb27d40 bsp=e00000b07bb20ed8
 [<a0000001003f3800>] __pci_register_driver+0x140/0x1e0
                                sp=e00000b07bb27d50 bsp=e00000b07bb20ea8
 [<a00000010081a5f0>] qla2300_init+0x30/0x60
                                sp=e00000b07bb27d60 bsp=e00000b07bb20e90
 [<a000000100009850>] init+0x590/0x8e0
                                sp=e00000b07bb27d60 bsp=e00000b07bb20e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e00000b07bb27e30 bsp=e00000b07bb20e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e00000b07bb27e30 bsp=e00000b07bb20e40
scsi2 : qla2xxx
qla2300 0002:01:04.0:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:04.0 hdma+, host#=2, fw=3.03.18 IPX
  Vendor: SGI       Model: U<4>ACPI: PCI Interrupt 0002:01:04.1[B]: no GSI
qla2300 0002:01:04.1: Found an ISP2312, irq 75, iobase 0xc00000080fd20000
qla2300 0002:01:04.1: Configuring PCI space...
PCI: slot 0002:01:04.1 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:04.1: Configure NVRAM parameters...
niversal Xport   Rev: 0614
  Type:   Direct-Access     <6>qla2300 0002:01:04.1: Verifying loaded RISC code...
                 ANSI SCSI revision: 03
qla2300 0002:01:04.1: LIP reset occured (f7f7).
  Vendor: <6>qla2300 0002:01:04.1: Waiting for LIP to complete...
SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access     <6>qla2300 0002:01:04.1: LOOP UP detected (2 Gbps).
                 ANSI SCSI revision: 03<6>qla2300 0002:01:04.1: Topology - (F_Port), Host Loop address 0xffff

  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi3 : qla2xxx
qla2300 0002:01:04.1:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:04.1 hdma+, host#=3, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0002:01:06.0[A]: no GSI
qla2300 0002:01:06.0: Found an ISP2312, irq 74, iobase 0xc00000080fd40000
qla2300 0002:01:06.0: Configuring PCI space...
PCI: slot 0002:01:06.0 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:06.0: Configure NVRAM parameters...
Universal Xport   Rev: 0614
  Type:   Direct-Access     <6>qla2300 0002:01:06.0: Verifying loaded RISC code...
                 ANSI SCSI revision: 03
  Vendor: SGI       Model: <6>qla2300 0002:01:06.0: LIP reset occured (f7f7).
qla2300 0002:01:06.0: Waiting for LIP to complete...
Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03<6>qla2300 0002:01:06.0: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.0: Topology - (F_Port), Host Loop address 0xffff

  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
BUG: soft lockup detected on CPU#0!
Modules linked in:

Pid: 1, CPU 0, comm:              swapper
psr : 00001010081a6018 ifs : 8000000000000286 ip  : [<a000000100035190>]    Not tainted
ip is at udelay+0xd0/0x160
unat: 0000000000000000 pfs : 0000000000000286 rsc : 0000000000000003
rnat: 00000001502a9a55 bsps: a0000001005537f0 pr  : 00000001502a5955
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000100035100 b6  : e0000030023e5490 b7  : a000000100553260
f6  : 1003e00000000000003e8 f7  : 0ffe4c000000000000000
f8  : 1003e0000000000002710 f9  : 1003e000000000000000a
f10 : 10000bffffffff4000000 f11 : 1003e0000000000000003
r1  : a000000100cc2100 r2  : 0000000000000006 r3  : 000000163e84b229
r8  : 00000000000003e8 r9  : ffffffffffff0070 r10 : ffffffffffff0030
r11 : a000000100ac2328 r12 : e00000b07bb27a00 r13 : e00000b07bb20000
r14 : e000003014d48000 r15 : 000000163e84b223 r16 : 0000000000002710
r17 : 0000000000002464 r18 : 000000163e84d6ad r19 : 0000000000000002
r20 : 0000000000000020 r21 : 0000000000000000 r22 : e000003003104231
r23 : ffffffffffff4230 r24 : 0000000000000078 r25 : 0000000000000000
r26 : 0000000000000012 r27 : c00000080fe30000 r28 : c00000080fa00200
r29 : e000003014d49370 r30 : 0000000000000088 r31 : a0000001007648d8

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e00000b07bb27650 bsp=e00000b07bb215f0
 [<a000000100013a90>] show_regs+0x7d0/0x800
                                sp=e00000b07bb27820 bsp=e00000b07bb215a0
 [<a0000001000fa020>] softlockup_tick+0x140/0x180
                                sp=e00000b07bb27820 bsp=e00000b07bb21570
 [<a0000001000c3f30>] do_timer+0x9f0/0xa20
                                sp=e00000b07bb27830 bsp=e00000b07bb21530
 [<a0000001000353f0>] timer_interrupt+0x1d0/0x380
                                sp=e00000b07bb27830 bsp=e00000b07bb214f0
 [<a0000001000fa1f0>] handle_IRQ_event+0x90/0x120
                                sp=e00000b07bb27830 bsp=e00000b07bb214b0
 [<a0000001000fa3a0>] __do_IRQ+0x120/0x360
                                sp=e00000b07bb27830 bsp=e00000b07bb21460
 [<a000000100010160>] ia64_handle_irq+0xa0/0x140
                                sp=e00000b07bb27830 bsp=e00000b07bb21430
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
                                sp=e00000b07bb27830 bsp=e00000b07bb21430
 [<a000000100035190>] udelay+0xd0/0x160
                                sp=e00000b07bb27a00 bsp=e00000b07bb21400
 [<a00000010054a580>] qla2x00_mailbox_command+0x5c0/0xb60
                                sp=e00000b07bb27a00 bsp=e00000b07bb21368
 [<a00000010054b430>] qla2x00_login_fabric+0x150/0x240
                                sp=e00000b07bb27a40 bsp=e00000b07bb21310
 [<a000000100541970>] qla2x00_fabric_login+0x90/0x3a0
                                sp=e00000b07bb27aa0 bsp=e00000b07bb212b0
 [<a0000001005423d0>] qla2x00_fabric_dev_login+0x30/0x160
                                sp=e00000b07bb27ae0 bsp=e00000b07bb21280
 [<a000000100544ec0>] qla2x00_configure_loop+0x25a0/0x27e0
                                sp=e00000b07bb27ae0 bsp=e00000b07bb211e0
 [<a000000100546160>] qla2x00_initialize_adapter+0x4a0/0x6a0
                                sp=e00000b07bb27ba0 bsp=e00000b07bb21170
 [<a00000010053c2f0>] qla2x00_probe_one+0x16b0/0x1f60
                                sp=e00000b07bb27ba0 bsp=e00000b07bb21078
 [<a0000001005685d0>] qla2300_probe_one+0x30/0x60
                                sp=e00000b07bb27c50 bsp=e00000b07bb21050
 [<a0000001003f3df0>] pci_device_probe+0x290/0x3c0
                                sp=e00000b07bb27c50 bsp=e00000b07bb21008
 [<a0000001004a75c0>] driver_probe_device+0xe0/0x180
                                sp=e00000b07bb27d20 bsp=e00000b07bb20fc8
 [<a0000001004a76d0>] __driver_attach+0x70/0xc0
                                sp=e00000b07bb27d20 bsp=e00000b07bb20f98
 [<a0000001004a6910>] bus_for_each_dev+0x90/0x120
                                sp=e00000b07bb27d20 bsp=e00000b07bb20f58
 [<a0000001004a72d0>] driver_attach+0x30/0x60
                                sp=e00000b07bb27d40 bsp=e00000b07bb20f38
 [<a0000001004a5de0>] bus_add_driver+0xe0/0x2c0
                                sp=e00000b07bb27d40 bsp=e00000b07bb20ef8
 [<a0000001004a78e0>] driver_register+0xa0/0xc0
                                sp=e00000b07bb27d40 bsp=e00000b07bb20ed8
 [<a0000001003f3800>] __pci_register_driver+0x140/0x1e0
                                sp=e00000b07bb27d50 bsp=e00000b07bb20ea8
 [<a00000010081a5f0>] qla2300_init+0x30/0x60
                                sp=e00000b07bb27d60 bsp=e00000b07bb20e90
 [<a000000100009850>] init+0x590/0x8e0
                                sp=e00000b07bb27d60 bsp=e00000b07bb20e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e00000b07bb27e30 bsp=e00000b07bb20e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e00000b07bb27e30 bsp=e00000b07bb20e40
scsi4 : qla2xxx
qla2300 0002:01:06.0:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:06.0 hdma+, host#=4, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0002:01:06.1[B]: no GSI
qla2300 0002:01:06.1: Found an ISP2312, irq 75, iobase 0xc00000080fd60000
qla2300 0002:01:06.1: Configuring PCI space...
PCI: slot 0002:01:06.1 has incorrect PCI cache line size of 0 bytes, correcting to 128
qla2300 0002:01:06.1: Configure NVRAM parameters...
Universal Xport   Rev: 0614
  Type:   Direct-Access     <6>qla2300 0002:01:06.1: Verifying loaded RISC code...
qla2300 0002:01:06.1: LIP reset occured (f7f7).
qla2300 0002:01:06.1: Waiting for LIP to complete...
                 ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xp<6>qla2300 0002:01:06.1: LOOP UP detected (2 Gbps).
qla2300 0002:01:06.1: Topology - (F_Port), Host Loop address 0xffff
ort   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST33<5>  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access     6753FC        Rev:                  ANSI SCSI revision: 03
2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access     ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
                 ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI    <5>  Vendor: SGI       Model:    Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03

  Vendor: <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access     ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
                 ANSI SCSI revision: 03
  Vendor: SGI   <5>  Vendor: SGI       Model:     Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access     ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03                 ANSI SCSI revision: 03

  Vendor: S<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
GI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI    <5>  Vendor: SGI       Model:    Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03

  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST33<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
6753FC        Rev: 2701<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03

  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST33<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
6753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
753FC        Rev: 2701
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
       Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03

  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST3367<5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
53FC        Rev: 2701
  Type:   Direct-Access     <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
                 ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: <5>  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access     ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
                 ANSI SCSI revision: 03
scsi5 : qla2xxx
qla2300 0002:01:06.1:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QLA2344 -
  ISP2312: PCI-X (133 MHz) @ 0002:01:06.1 hdma+, host#=5, fw=3.03.18 IPX
ACPI: PCI Interrupt 0012:00:01.0[A]: no GSI
qla2300 0012:00:01.0: Found an ISP2312, irq 60, iobase 0xc00000880fe00000
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
qla2300 0012:00:01.0: Configuring PCI space...
qla2300 0012:00:01.0: Configure NVRAM parameters...
qla2300 0012:00:01.0: Verifying loaded RISC code...
qla2300 0012:00:01.0: LIP reset occured (f7f7).
qla2300 0012:00:01.0: Waiting for LIP to complete...
qla2300 0012:00:01.0: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.0: Topology - (F_Port), Host Loop address 0xffff
scsi6 : qla2xxx
qla2300 0012:00:01.0:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:01.0 hdma+, host#=6, fw=3.03.18 IPX
  Vendor: SGI       Model: <4>ACPI: PCI Interrupt 0012:00:01.1[B]: no GSI
qla2300 0012:00:01.1: Found an ISP2312, irq 61, iobase 0xc00000880fe01000
qla2300 0012:00:01.1: Configuring PCI space...
qla2300 0012:00:01.1: Configure NVRAM parameters...
Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: <6>qla2300 0012:00:01.1: Verifying loaded RISC code...
SGI       Model: Universal Xport   Rev: 061<6>qla2300 0012:00:01.1: Waiting for LIP to complete...
4
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: Universal Xport   Rev: 0614
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03<6>qla2300 0012:00:01.1: LIP reset occured (f7f7).
qla2300 0012:00:01.1: LOOP UP detected (2 Gbps).
qla2300 0012:00:01.1: Topology - (F_Port), Host Loop address 0xffff

  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SGI       Model: ST336753FC        Rev: 2701
  Type:   Direct-Access                      ANSI SCSI revision: 03
scsi7 : qla2xxx
qla2300 0012:00:01.1:
 QLogic Fibre Channel HBA Driver: 8.01.03-k
  QLogic QCP2340 -
  ISP2312: PCI-X (100 MHz) @ 0012:00:01.1 hdma+, host#=7, fw=3.03.18 IPX
Badness in kref_get at lib/kref.c:32

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e0000034f7befaf0 bsp=e0000034f7be90e8
 [<a000000100013af0>] dump_stack+0x30/0x60
                                sp=e0000034f7befcc0 bsp=e0000034f7be90d0
 [<a0000001003da010>] kref_get+0x70/0xa0
                                sp=e0000034f7befcc0 bsp=e0000034f7be90b0
 [<a0000001003d80f0>] kobject_get+0x30/0x60
                                sp=e0000034f7befcc0 bsp=e0000034f7be9090
 [<a0000001004a2f90>] get_device+0x30/0x60
                                sp=e0000034f7befcc0 bsp=e0000034f7be9070
 [<a000000100509d20>] scsi_device_get+0x60/0x1a0
                                sp=e0000034f7befcc0 bsp=e0000034f7be9040
 [<a00000010050a0a0>] __scsi_iterate_devices+0x80/0x100
                                sp=e0000034f7befcc0 bsp=e0000034f7be8fe8
 [<a00000010050a270>] starget_for_each_device+0x150/0x180
                                sp=e0000034f7befcc0 bsp=e0000034f7be8fa8
 [<a0000001005150f0>] target_block+0x50/0x80
                                sp=e0000034f7befcc0 bsp=e0000034f7be8f88
 [<a0000001004a2de0>] device_for_each_child+0x60/0xe0
                                sp=e0000034f7befcc0 bsp=e0000034f7be8f58
 [<a000000100515300>] scsi_target_block+0x80/0xa0
                                sp=e0000034f7befce0 bsp=e0000034f7be8f38
 [<a000000100528470>] fc_remote_port_delete+0x70/0xe0
                                sp=e0000034f7befce0 bsp=e0000034f7be8f10
 [<a000000100541d70>] qla2x00_rport_del+0x30/0x60
                                sp=e0000034f7befce0 bsp=e0000034f7be8ef0
 [<a0000001000d3ca0>] worker_thread+0x380/0x4a0
                                sp=e0000034f7befce0 bsp=e0000034f7be8ea8
 [<a0000001000df460>] kthread+0x240/0x2c0
                                sp=e0000034f7befd50 bsp=e0000034f7be8e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e0000034f7befe30 bsp=e0000034f7be8e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f7befe30 bsp=e0000034f7be8e40
Unable to handle kernel paging request at virtual address 00000000001005e8
events/2[16]: Oops 11012296146944 [1]
Modules linked in:

Pid: 16, CPU 2, comm:             events/2
psr : 0000121008022018 ifs : 8000000000000307 ip  : [<a000000100509ce1>]    Not tainted
ip is at scsi_device_get+0x21/0x1a0
unat: 0000000000000000 pfs : 000000000000050c rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000029645
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a00000010050a0a0 b6  : e00000b0023e5490 b7  : a00000010000b4e0
f6  : 0fffbe38e38e381b23800 f7  : 0ffe5e259881000000000
f8  : 1000a8080000000000000 f9  : 100029000000000000000
f10 : 10006e471c71c6533ea38 f11 : 1003e00000000000000e4
r1  : a000000100cc2100 r2  : 0000000000100100 r3  : 0000000000100100
r8  : 00000000001005e8 r9  : e00000b003acebd4 r10 : 00000000000000f4
r11 : 0000000000000001 r12 : e0000034f7befcc0 r13 : e0000034f7be8000
r14 : e0000034f7befbf0 r15 : e00000b0038ec054 r16 : e0000034f7be8df0
r17 : 0000000000000000 r18 : e00000b003acebd8 r19 : 0000000040000000
r20 : 00000034f7be8000 r21 : a0000001006c5220 r22 : ffffffffffff48c0
r23 : e00000b003020000 r24 : a000000100ac2850 r25 : 0000000000000000
r26 : 0000000000000000 r27 : e0000034f7be8028 r28 : 0000000000000000
r29 : 0000000000000000 r30 : 0000000000000000 r31 : ffffffffffff0008

Call Trace:
 [<a000000100013260>] show_stack+0x40/0xa0
                                sp=e0000034f7bef850 bsp=e0000034f7be9168
 [<a000000100013a90>] show_regs+0x7d0/0x800
                                sp=e0000034f7befa20 bsp=e0000034f7be9118
 [<a000000100036210>] die+0x210/0x2a0
                                sp=e0000034f7befa20 bsp=e0000034f7be90d0
 [<a000000100059ac0>] ia64_do_page_fault+0x8e0/0xa40
                                sp=e0000034f7befa40 bsp=e0000034f7be9078
 [<a00000010000bce0>] ia64_leave_kernel+0x0/0x290
                                sp=e0000034f7befaf0 bsp=e0000034f7be9078
 [<a000000100509ce0>] scsi_device_get+0x20/0x1a0
                                sp=e0000034f7befcc0 bsp=e0000034f7be9040
 [<a00000010050a0a0>] __scsi_iterate_devices+0x80/0x100
                                sp=e0000034f7befcc0 bsp=e0000034f7be8fe8
 [<a00000010050a270>] starget_for_each_device+0x150/0x180
                                sp=e0000034f7befcc0 bsp=e0000034f7be8fa8
 [<a0000001005150f0>] target_block+0x50/0x80
                                sp=e0000034f7befcc0 bsp=e0000034f7be8f88
 [<a0000001004a2de0>] device_for_each_child+0x60/0xe0
                                sp=e0000034f7befcc0 bsp=e0000034f7be8f58
 [<a000000100515300>] scsi_target_block+0x80/0xa0
                                sp=e0000034f7befce0 bsp=e0000034f7be8f38
 [<a000000100528470>] fc_remote_port_delete+0x70/0xe0
                                sp=e0000034f7befce0 bsp=e0000034f7be8f10
 [<a000000100541d70>] qla2x00_rport_del+0x30/0x60
                                sp=e0000034f7befce0 bsp=e0000034f7be8ef0
 [<a0000001000d3ca0>] worker_thread+0x380/0x4a0
                                sp=e0000034f7befce0 bsp=e0000034f7be8ea8
 [<a0000001000df460>] kthread+0x240/0x2c0
                                sp=e0000034f7befd50 bsp=e0000034f7be8e68
 [<a000000100011720>] kernel_thread_helper+0xe0/0x100
                                sp=e0000034f7befe30 bsp=e0000034f7be8e40
 [<a000000100009120>] start_kernel_thread+0x20/0x40
                                sp=e0000034f7befe30 bsp=e0000034f7be8e40
 <6>note: events/2[16] exited with preempt_count 1


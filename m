From: Catalin Muresan <catalin.muresan@astral.ro>
Subject: qla2312 kernel 2.6.14-1.1653_FC4smp (FC4) warmless (so far) debug warning
Date: Tue, 3 Jan 2006 10:04:34 +0200
Message-ID: <20060103080434.GA3635@astral.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.astral.ro ([193.230.240.11]:11702 "EHLO mail.astral.ro")
	by vger.kernel.org with ESMTP id S1751303AbWACIEl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 03:04:41 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi@vger.kernel.org


	Hello,

	I'm seeing the following messages on FC4, kernel 2.6.14-1.1653_FC4smp:

Dec 27 20:55:13 uber1 kernel:
Debug: sleeping function called from invalid context at kernel/workqueue.c:264 in_atomic():1, irqs_disabled():1
 [<c013013c>] flush_workqueue+0x13/0x71
 [<f8831945>] fc_remote_port_unblock+0x5f/0x81 [scsi_transport_fc]
 [<f889e9b9>] qla2x00_send_login_iocb_cb+0x22f/0x772 [qla2xxx]
 [<c0128dc3>] try_to_del_timer_sync+0x45/0x4d
 [<f889f535>] qla2x00_process_iodesc+0x74/0x110 [qla2xxx]
 [<f8896e41>] qla2x00_process_response_queue+0xa3/0x1a9 [qla2xxx]
 [<f8896282>] qla2300_intr_handler+0x291/0x2d4 [qla2xxx]
 [<c012946d>] do_timer+0x43/0xea
 [<c01434bd>] handle_IRQ_event+0x2e/0x5a
 [<c0143574>] __do_IRQ+0x8b/0xe7
 [<c0105ade>] do_IRQ+0x4e/0x86
 =======================
 [<c0319bdc>] schedule+0x53c/0xc83
 [<c01043da>] common_interrupt+0x1a/0x20
 [<c0101b81>] mwait_idle+0x25/0x43
 [<c021474b>] acpi_processor_idle+0xf0/0x291
 [<c0101a14>] cpu_idle+0x4e/0x63
Dec 27 20:55:53 uber1 kernel:
Debug: sleeping function called from invalid context at kernel/workqueue.c:264 in_atomic():1, irqs_disabled():1
 [<c013013c>] flush_workqueue+0x13/0x71
 [<f8831945>] fc_remote_port_unblock+0x5f/0x81 [scsi_transport_fc]
 [<f889e9b9>] qla2x00_send_login_iocb_cb+0x22f/0x772 [qla2xxx]
 [<c0128dc3>] try_to_del_timer_sync+0x45/0x4d
 [<f889f535>] qla2x00_process_iodesc+0x74/0x110 [qla2xxx]
 [<f8896e41>] qla2x00_process_response_queue+0xa3/0x1a9 [qla2xxx]
 [<f8896282>] qla2300_intr_handler+0x291/0x2d4 [qla2xxx]
 [<c012946d>] do_timer+0x43/0xea
 [<c01434bd>] handle_IRQ_event+0x2e/0x5a
 [<c0143574>] __do_IRQ+0x8b/0xe7
 [<c0105ade>] do_IRQ+0x4e/0x86
 =======================
 [<c011616c>] smp_apic_timer_interrupt+0xc1/0xca
 [<c01043da>] common_interrupt+0x1a/0x20
 [<c0101b81>] mwait_idle+0x25/0x43
 [<c021474b>] acpi_processor_idle+0xf0/0x291
 [<c0101a14>] cpu_idle+0x4e/0x63
Dec 27 20:55:58 uber1 kernel:
Debug: sleeping function called from invalid context at kernel/workqueue.c:264 in_atomic():1, irqs_disabled():1
 [<c013013c>] flush_workqueue+0x13/0x71
 [<f8831945>] fc_remote_port_unblock+0x5f/0x81 [scsi_transport_fc]
 [<f889e9b9>] qla2x00_send_login_iocb_cb+0x22f/0x772 [qla2xxx]
 [<c0128dc3>] try_to_del_timer_sync+0x45/0x4d
 [<f889f535>] qla2x00_process_iodesc+0x74/0x110 [qla2xxx]
 [<f8896e41>] qla2x00_process_response_queue+0xa3/0x1a9 [qla2xxx]
 [<f8896282>] qla2300_intr_handler+0x291/0x2d4 [qla2xxx]
 [<c012946d>] do_timer+0x43/0xea
 [<c01434bd>] handle_IRQ_event+0x2e/0x5a
 [<c0143574>] __do_IRQ+0x8b/0xe7
 [<c0105ade>] do_IRQ+0x4e/0x86
 =======================
 [<c011616c>] smp_apic_timer_interrupt+0xc1/0xca
 [<c01043da>] common_interrupt+0x1a/0x20
 [<c0101b81>] mwait_idle+0x25/0x43
 [<c021474b>] acpi_processor_idle+0xf0/0x291
 [<c0101a14>] cpu_idle+0x4e/0x63

	hardware is IBM HS20 blade on FC SAN, actually 2 of them, both have the same debug messages in dmesg.

[root@uber2 ~]# lspci -tv
-[0000:00]-+-00.0  Intel Corporation E7520 Memory Controller Hub
           +-00.1  Intel Corporation E7525/E7520 Error Reporting Registers
           +-03.0-[0000:04-06]--+-00.0-[0000:06]--+-01.0  QLogic Corp. QLA2312 Fibre Channel Adapter
           |                    |                 \-01.1  QLogic Corp. QLA2312 Fibre Channel Adapter
           |                    \-00.2-[0000:05]--+-01.0  Broadcom Corporation NetXtreme BCM5704S Gigabit Ethernet
           |                                      \-01.1  Broadcom Corporation NetXtreme BCM5704S Gigabit Ethernet
           +-08.0  Intel Corporation E7525/E7520/E7320 Extended Configuration Registers
           +-1c.0-[0000:02]--
           +-1d.0  Intel Corporation 6300ESB USB Universal Host Controller
           +-1d.1  Intel Corporation 6300ESB USB Universal Host Controller
           +-1d.4  Intel Corporation 6300ESB Watchdog Timer
           +-1d.5  Intel Corporation 6300ESB I/O Advanced Programmable Interrupt Controller
           +-1e.0-[0000:01]----01.0  ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
           +-1f.0  Intel Corporation 6300ESB LPC Interface Controller
           +-1f.1  Intel Corporation 6300ESB PATA Storage Controller
           \-1f.3  Intel Corporation 6300ESB SMBus Controller
[root@uber2 ~]# lsmod
Module                  Size  Used by
iptable_filter          7105  1
ip_tables              25409  1 iptable_filter
lock_dlm               46052  1
gfs                   277764  1
lock_harness            8360  2 lock_dlm,gfs
dlm                   122188  5 lock_dlm
cman                  138144  18 lock_dlm,dlm
ipv6                  270753  60
8021q                  24649  0
joydev                 13569  0
usb_storage            78857  0
video                  20165  0
button                 10705  0
battery                13509  0
ac                      8901  0
uhci_hcd               36817  0
i6300esb               11237  0
i2c_i801               13133  0
i2c_core               26177  1 i2c_i801
shpchp                 97285  0
tg3                   102469  0
dm_snapshot            21741  0
dm_zero                 6081  0
dm_mirror              26389  0
ext3                  135241  2
jbd                    61909  1 ext3
dm_mod                 60893  7 dm_snapshot,dm_zero,dm_mirror
qla2300               128449  0
qla2xxx               128029  6 qla2300
scsi_transport_fc      31937  1 qla2xxx
sd_mod                 22593  7
scsi_mod              139753  4 usb_storage,qla2xxx,scsi_transport_fc,sd_mod
[root@uber2 ~]# modinfo qla2300|grep -v parm
filename:
/lib/modules/2.6.14-1.1653_FC4smp/kernel/drivers/scsi/qla2xxx/qla2300.ko
author:         QLogic Corporation
description:    QLogic ISP23xx FC-SCSI Host Bus Adapter driver
license:        GPL
version:        8.01.00-k
vermagic:       2.6.14-1.1653_FC4smp SMP 686 REGPARM 4KSTACKS gcc-4.0
depends:        qla2xxx
alias:          pci:v00001077d00002300sv*sd*bc*sc*i*
alias:          pci:v00001077d00002312sv*sd*bc*sc*i*
srcversion:     A6E429254F038C2CF57F042
[root@uber2 ~]# modinfo qla2xxx|grep -v parm
filename:
/lib/modules/2.6.14-1.1653_FC4smp/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
author:         QLogic Corporation
description:    QLogic Fibre Channel HBA Driver
license:        GPL
version:        8.01.00-k
vermagic:       2.6.14-1.1653_FC4smp SMP 686 REGPARM 4KSTACKS gcc-4.0
depends:        scsi_mod,scsi_transport_fc
alias:          pci:v00001077d00002422sv*sd*bc*sc*i*
alias:          pci:v00001077d00002432sv*sd*bc*sc*i*
srcversion:     885A179A1C9B0CDBDB1CC1C
[root@uber2 ~]#
	
	I cannot reproduce what happened (no idea how) but I'm willing to
help you debug this in any way I can. Please CC me as I'm not on the list.

	Thank you,

-- 
 Catalin Muresan
 ASTRAL Internet NOC
 gpg --keyserver subkeys.pgp.net --recv-keys 0xFA75D55C


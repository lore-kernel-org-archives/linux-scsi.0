From: Ricky Beam <jfbeam@bluetronic.net>
Subject: qla2xxx (2100) vs. qlogicfc [again]
Date: Thu, 6 May 2004 13:46:16 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.33.0405061335150.14297-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sweetums.bluetronic.net ([24.199.150.42]:4335 "EHLO
	sweetums.bluetronic.net") by vger.kernel.org with ESMTP
	id S261752AbUEFRun (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 13:50:43 -0400
Received: from localhost (jfbeam@localhost)
	by sweetums.bluetronic.net (8.11.7/8.11.7) with ESMTP id i46HkHd11811
	for <linux-scsi@vger.kernel.org>; Thu, 6 May 2004 13:46:17 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

Once again, we're back to the never ending battle between qlogicfc and
qla2100 -- qla2100, to date, has never worked correctly.

 -- Read on --

Kernel: 2.6.6-rc3 SMP (BK[20040505153603])

[options qla2xxx
  ql2xlogintimeout=30 qlport_down_retry=10 ql2xplogiabsentdevice=1
  ql2xdoinitscan=1 ql2xloginretrycount=100]

(qla2100)
QLogic Fibre Channel HBA Driver (f8c16000)
qla2100 0000:06:03.0: Found an ISP2100, irq 24, iobase 0xf8b15000
qla2100 0000:06:03.0: Configuring PCI space...
qla2100 0000:06:03.0: Configure NVRAM parameters...
qla2100 0000:06:03.0: Verifying loaded RISC code...
qla2100 0000:06:03.0: Waiting for LIP to complete...
qla2100 0000:06:03.0: Cable is unplugged...
 [no it isn't. the hub shows it active and the switch shows it logged in.]
scsi0 : qla2xxx
qla2100 0000:06:03.0:
 QLogic Fibre Channel HBA Driver: 8.00.00b11-k
  QLogic QLA2100 -
  ISP2100: PCI (33 MHz) @ 0000:06:03.0 hdma-, host#=0, fw=1.19.24 TP
qla2100 0000:06:03.0: LIP reset occured (f8f7).
qla2100 0000:06:03.0: LIP occured (f8f7).
qla2100 0000:06:03.0: LIP reset occured (f7f7).
qla2100 0000:06:03.0: LIP occured (f7f7).

(qlogicfc)
qlogicfc0 : link is not up
 [wait for it...]
scsi1 : QLogic ISP2100 SCSI on PCI bus 06 device 18 irq 24 base 0xd800
qlogicfc0 : Loop Reinitialized
qlogicfc0 : Link is Up
qlogicfc0 : Port Database
wwn: 200000e08b014419  scsi_id: 0  loop_id: 0
wwn: 210000203732c427  scsi_id: 1  loop_id: 1
wwn: 210000203732bf6a  scsi_id: 2  loop_id: 2
wwn: 210000203732867e  scsi_id: 3  loop_id: 3
wwn: 2100002037329a24  scsi_id: 4  loop_id: 4
wwn: 210000203732c135  scsi_id: 5  loop_id: 5
wwn: 210000203732b1b0  scsi_id: 6  loop_id: 6
wwn: 2100002037322a58  scsi_id: 7  loop_id: 7
wwn: 21000020371205da  scsi_id: 8  loop_id: 8
wwn: 210000203732bee5  scsi_id: 9  loop_id: 9
wwn: 2100002037324c48  scsi_id: a  loop_id: a
wwn: 210000203732b31a  scsi_id: b  loop_id: b
wwn: 210000203732c03c  scsi_id: c  loop_id: c
wwn: 210000203732bfca  scsi_id: d  loop_id: d
wwn: 210000203732c10a  scsi_id: e  loop_id: e

Topology:
Gadzoox GS FC Hub Port 1 - QLA2100 (HSSDC)
Gadzoox GS FC Hub Port 6 - link to QLogic SANbox-8 Port 1 (SX)
QLogic SANbox-8 Port 1 - Link to Hub [TL-Port] (SX)
QLogic SANbox-8 Port 5 - Eurologic FC7 shelf (7 drives) [TL-Port] (HSSDC)
QLogic SANbox-8 Port 7 - Eurologic FC7 shelf (7 drives) [TL-Port] (HSSDC)

The card's BIOS can see all the disks.  The old qlogicfc driver can see
all the drives.  However, the new qla2xxx driver will never see the
loop as active.  Keep in mind, it takes a few seconds (2) for the hub to
re-enable the port and put the HBA back in the loop.

[root@dev-sensor root]# modprobe qlogicfc_d
qlogicfc0 : Loop Reinitialized
qlogicfc0 : Link is Up
scsi2 : QLogic ISP2100 SCSI on PCI bus 06 device 18 irq 24 base 0xd800
qlogicfc0 : Port Database
wwn: 200000e08b014419  scsi_id: 0  loop_id: 0
wwn: 210000203732c427  scsi_id: 1  loop_id: 1
wwn: 210000203732bf6a  scsi_id: 2  loop_id: 2
wwn: 210000203732867e  scsi_id: 3  loop_id: 3
wwn: 2100002037329a24  scsi_id: 4  loop_id: 4
wwn: 210000203732c135  scsi_id: 5  loop_id: 5
wwn: 210000203732b1b0  scsi_id: 6  loop_id: 6
wwn: 2100002037322a58  scsi_id: 7  loop_id: 7
wwn: 21000020371205da  scsi_id: 8  loop_id: 8
wwn: 210000203732bee5  scsi_id: 9  loop_id: 9
wwn: 2100002037324c48  scsi_id: a  loop_id: a
wwn: 210000203732b31a  scsi_id: b  loop_id: b
wwn: 210000203732c03c  scsi_id: c  loop_id: c
wwn: 210000203732bfca  scsi_id: d  loop_id: d
wwn: 210000203732c10a  scsi_id: e  loop_id: e
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST118202FC        Rev: NA27
  Type:   Direct-Access                      ANSI SCSI revision: 02

(ventana log)
05/05/04 22:45:19,Loop down, , [0]
05/05/04 22:45:19,Loop up, , [0]
05/05/04 22:45:24,Port bypassed, 192.168.55.251, [0], 1
05/05/04 22:45:28,Loop down, , [0]
05/05/04 22:45:28,Loop up, , [0]
05/05/04 22:45:31,Port enabled, 192.168.55.251, [0], 1

I've not tried removing the "fabric" and running directly to the drives.
However, even if that were to work, it's not a usable solution.

If the guys at Qlogic want to watch what I'm seeing, all they have to do
is ask.

--Ricky

PS: If someone wants to give me a QLA2300, I won't complain :-)



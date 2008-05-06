From: Gerhard Mack <gmack@innerfire.net>
Subject: Re: [2.6.25.1] qla2xxx can't see more than 4 drives
Date: Tue, 6 May 2008 10:28:23 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805061022120.5741@mtl.rackplans.net>
References: <alpine.DEB.1.10.0805031458050.2330@mtl.rackplans.net> <20080506135118.GA46493@plap4.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtl.rackplans.net ([69.90.0.18]:40452 "EHLO mtl.rackplans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbYEFO20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2008 10:28:26 -0400
In-Reply-To: <20080506135118.GA46493@plap4.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 6 May 2008, Andrew Vasquez wrote:

> Date: Tue, 6 May 2008 06:51:18 -0700
> From: Andrew Vasquez <andrew.vasquez@qlogic.com>
> To: Gerhard Mack <gmack@innerfire.net>
> Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [2.6.25.1] qla2xxx can't see more than 4 drives
> 
> On Sat, 03 May 2008, Gerhard Mack wrote:
> 
> > I have an array witjh 6 drives in it and if use the card's utilities on 
> > boot it sees all of them but for some reason Linux only sees 4 drives.
> > 
> > Am I running into a limit?  I can see both drives if I remove other drives 
> > from the array.
> > 
> > [0:0:0:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sda
> > [0:0:1:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sdb
> > [0:0:2:0]    disk    MAXTOR   ATLAS10K4_36SCA  DFM0  /dev/sdc
> > [0:0:6:0]    process PE/PV    1x3 SCSI BP      0.28  -
> > fiber channel drives:
> > [2:0:0:0]    disk    SEAGATE  ST314680 CLAR146 7A0A  /dev/sdd
> > [2:0:1:0]    disk    SEAGATE  ST314680 CLAR146 7A04  /dev/sde
> > [2:0:2:0]    disk    SEAGATE  ST314680 CLAR146 7A0A  /dev/sdf
> > [2:0:3:0]    disk    SEAGATE  ST314680 CLAR146 7A04  /dev/sdg
> > 
> > QLogic Fibre Channel HBA Driver
> > qla2xxx 0000:02:0a.0: Found an ISP2312, irq 24, iobase 0xf88cc000
> > qla2xxx 0000:02:0a.0: Configuring PCI space...
> > qla2xxx 0000:02:0a.0: Configure NVRAM parameters...
> > qla2xxx 0000:02:0a.0: Verifying loaded RISC code...
> > qla2xxx 0000:02:0a.0: Allocated (412 KB) for firmware dump...
> > scsi3 : qla2xxx
> > qla2xxx 0000:02:0a.0: LIP reset occured (f8f7).
> > qla2xxx 0000:02:0a.0: LIP occured (f8f7).
> > qla2xxx 0000:02:0a.0: LOOP UP detected (1 Gbps).
> 
> Could you load the driver with the ql2xextended_error_logging module
> parameter set to 1 and send the resultant driver logs?  Also, it would
> could you also send the output of the following after the driver is
> loaded:
> 
> $ cat /sys/class/fc_host/host<host_no>
> $ cat /sys/class/scsi_host/host<host_no>/*
> $ cat /sys/class/fc_remote_ports/*
> 
> where host_no corresponds to the SCSI host-number assigned to the HBA.
> 
Of course.. 

QLogic Fibre Channel HBA Driver
qla2xxx 0000:02:0a.0: Found an ISP2312, irq 24, iobase 0xf88cc000
qla2xxx 0000:02:0a.0: Configuring PCI space...
qla2xxx 0000:02:0a.0: Configure NVRAM parameters...
qla2xxx 0000:02:0a.0: Verifying loaded RISC code...
scsi(4): **** Load RISC code ****
scsi(4): Verifying Checksum of loaded RISC code.
scsi(4): Checksum OK, start firmware.
qla2xxx 0000:02:0a.0: Allocated (412 KB) for firmware dump...
scsi(4): Issue init firmware.
DEBUG: detect hba 4 at address = f5da2278
scsi4 : qla2xxx
scsi(4): Asynchronous LIP RESET (f8f7).
qla2xxx 0000:02:0a.0: LIP reset occured (f8f7).
scsi(4): LIP occured (f8f7).
qla2xxx 0000:02:0a.0: LIP occured (f8f7).
scsi(4): Asynchronous LOOP UP (1 Gbps).
qla2xxx 0000:02:0a.0: LOOP UP detected (1 Gbps).
scsi(4): Asynchronous PORT UPDATE.
scsi(4): Port database changed ffff 0006 0000.
scsi(4): qla2x00_reset_marker()
scsi(4): qla2x00_loop_resync()
scsi(4): F/W Ready - OK 
scsi(4): fw_state=3 curr time=1371fd39.
scsi(4): Configure loop -- dpc flags =0x40800e0
qla2x00_mailbox_command(4): **** FAILED. mbx0=4006, mbx1=7e, mbx2=0, cmd=6a ****
qla2x00_get_port_name(4): failed=102.
scsi(4): MBC_GET_PORT_NAME Failed, No FL Port
scsi(4): LOOP READY
scsi(4): qla2x00_loop_resync - end
qla2xxx 0000:02:0a.0: scsi(4:0:0:0): Queue depth adjusted-up to 4.
scsi 4:0:0:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A0A PQ: 0 ANSI: 3
sd 4:0:0:0: [sdd] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: a7 00 10 08
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 4:0:0:0: [sdd] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: a7 00 10 08
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdd:<6>qla2xxx 0000:02:0a.0: 
 QLogic Fibre Channel HBA Driver: 8.02.00-k9-debug
  QLogic QLA2340 - 133MHz PCI-X to 2Gb FC, Single Channel
  ISP2312: PCI (66 MHz) @ 0000:02:0a.0 hdma-, host#=4, fw=3.03.20 IPX
 unknown partition table
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 4:0:0:0: Embedded Enclosure Device
sd 4:0:0:0: Failed to get diagnostic page 0x6000000
sd 4:0:0:0: Failed to bind enclosure -19
qla2xxx 0000:02:0a.0: scsi(4:0:1:0): Queue depth adjusted-up to 4.
scsi 4:0:1:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A04 PQ: 0 ANSI: 3
sd 4:0:1:0: [sde] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:1:0: [sde] Write Protect is off
sd 4:0:1:0: [sde] Mode Sense: a7 00 10 08
sd 4:0:1:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 4:0:1:0: [sde] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:1:0: [sde] Write Protect is off
sd 4:0:1:0: [sde] Mode Sense: a7 00 10 08
sd 4:0:1:0: [sde] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sde: unknown partition table
sd 4:0:1:0: [sde] Attached SCSI disk
sd 4:0:1:0: Attached scsi generic sg5 type 0
sd 4:0:1:0: Embedded Enclosure Device
sd 4:0:1:0: Failed to get diagnostic page 0x6000000
sd 4:0:1:0: Failed to bind enclosure -19
qla2xxx 0000:02:0a.0: scsi(4:0:2:0): Queue depth adjusted-up to 4.
scsi 4:0:2:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A0A PQ: 0 ANSI: 3
sd 4:0:2:0: [sdf] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:2:0: [sdf] Write Protect is off
sd 4:0:2:0: [sdf] Mode Sense: a7 00 10 08
sd 4:0:2:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 4:0:2:0: [sdf] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:2:0: [sdf] Write Protect is off
sd 4:0:2:0: [sdf] Mode Sense: a7 00 10 08
sd 4:0:2:0: [sdf] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdf: unknown partition table
sd 4:0:2:0: [sdf] Attached SCSI disk
sd 4:0:2:0: Attached scsi generic sg6 type 0
sd 4:0:2:0: Embedded Enclosure Device
qla2xxx_eh_abort(4): aborting sp f7fce920 from RISC. pid=95.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:2:0): Abort command issued -- 1 5f 2002.
qla2xxx_eh_abort(4): aborting sp f7fce920 from RISC. pid=110.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:2:0): Abort command issued -- 1 6e 2002.
qla2xxx_eh_abort(4): aborting sp f7fce920 from RISC. pid=112.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:2:0): Abort command issued -- 1 70 2002.
qla2xxx_eh_abort(4): aborting sp f7fce920 from RISC. pid=115.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:2:0): Abort command issued -- 1 73 2002.
sd 4:0:2:0: Failed to get diagnostic page 0x80000
sd 4:0:2:0: Failed to bind enclosure -19
qla2xxx 0000:02:0a.0: scsi(4:0:3:0): Queue depth adjusted-up to 4.
scsi 4:0:3:0: Direct-Access     SEAGATE  ST314680 CLAR146 7A04 PQ: 0 ANSI: 3
sd 4:0:3:0: [sdg] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:3:0: [sdg] Write Protect is off
sd 4:0:3:0: [sdg] Mode Sense: a7 00 10 08
sd 4:0:3:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
sd 4:0:3:0: [sdg] 286749476 512-byte hardware sectors (146816 MB)
sd 4:0:3:0: [sdg] Write Protect is off
sd 4:0:3:0: [sdg] Mode Sense: a7 00 10 08
sd 4:0:3:0: [sdg] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdg: unknown partition table
sd 4:0:3:0: [sdg] Attached SCSI disk
sd 4:0:3:0: Attached scsi generic sg7 type 0
sd 4:0:3:0: Embedded Enclosure Device
qla2xxx_eh_abort(4): aborting sp f6ddb160 from RISC. pid=137.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:3:0): Abort command issued -- 1 89 2002.
qla2xxx_eh_abort(4): aborting sp f73c4a80 from RISC. pid=149.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:3:0): Abort command issued -- 1 95 2002.
qla2xxx_eh_abort(4): aborting sp f6ddb080 from RISC. pid=158.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:3:0): Abort command issued -- 1 9e 2002.
qla2xxx_eh_abort(4): aborting sp f6ddb080 from RISC. pid=161.
scsi(4): ABORT status detected 0x5-0x0.
qla2xxx 0000:02:0a.0: scsi(4:3:0): Abort command issued -- 1 a1 2002.
sd 4:0:3:0: Failed to get diagnostic page 0x80000
sd 4:0:3:0: Failed to bind enclosure -19

cat /sys/class/fc_host/host4/* :
0x200000e08b127d20
0
0x200000e08b127d20
0
0x000001
0x210000e08b127d20
Online
LPort (private loop)
1 Gbit
Class 3
QLA2340 FW:v3.03.20 DVR:v8.02.00-k9-debug

wwpn (World Wide Port Name)

cat /sys/class/scsi_host/host4/* :
Initiator
Disabled
2176
3
8.02.00-k9-debug
3.03.20 IPX
0
4953 5020 2020 0002
ISP2312
133MHz PCI-X to 2Gb FC, Single Channel
QLA2340
1.54
0.00
0.00
0.00.00 0
PCI (66 MHz)
<NULL>
L87965
128
Link Up - Loop
Initiator
0
0
Disabled
200 us

cat /sys/class/fc_remote_ports/rport-4\:0-0/*  :
35
0x2000000c507ce546
0x0000e2
0x2200000c507ce546
Online
FCP Target
0
Class 3

cat /sys/class/fc_remote_ports/rport-4\:0-1/*
35
0x20000004cf69c688
0x0000e1
0x22000004cf69c688
Online
FCP Target
1
Class 3

cat /sys/class/fc_remote_ports/rport-4\:0-2/* | log
35
0x2000000c507ce809
0x00000f
0x2200000c507ce809
Online
FCP Target
2
Class 3

cat /sys/class/fc_remote_ports/rport-4\:0-3/* :
35
0x20000004cf69b98f
0x000008
0x22000004cf69b98f
Online
FCP Target
3
Class 3

--
Gerhard Mack

gmack@innerfire.net

<>< As a computer I find your faith in technology amusing.

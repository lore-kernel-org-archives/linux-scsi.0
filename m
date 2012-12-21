From: CrashPlan Pro <linux-scsi@crashplan.pro>
Subject: mpt2sas: SATA Initialization Failed - Linux does not create any block
 devices for PUIS drives behind SAS expander
Date: Fri, 21 Dec 2012 22:27:06 +0100
Message-ID: <50D4D42A.4080506@crashplan.pro>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52587 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2LUV1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Dec 2012 16:27:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-scsi@crashplan.pro

kernel 2.6.32-5-amd64
linux	/boot/vmlinuz-2.6.32-5-amd64=20
root=3DUUID=3D61dd0022-387c-4fb8-9532-a4af17aa4af3 ro clocksource=3Dhpe=
t=20
hpet=3Dforce raid=3Dnoautodetect scsi_mod.scan=3Dasync selinux=3D0 nois=
apnp verbose

MPT2BIOS-07.29.00.00 (loading of this BIOS is disabled in Ami PC BIOS)
SAS2008-IT 15.00.00.00
LSI driver mpt2sas-15.00.00.00
HP SAS Expander 2.06 (2 pieces)

Note: With SAS2008-IR firmware returns =93port enable: FAILED with time=
out=20
(timeout=3D300s)=94 messages and freezes 3450-3500 seconds after boot.

Before
After reboot when having set all drives to Power Up In Standby (PUIS)=20
using "/sbin/hdparm -s1 --yes-i-know-what-i-am-doing /dev/sdX" not any=20
drive is being detected by the mpt2sas kernel module. In verbose loggin=
g=20
console prints "detecting: handle", "REPORT_LUNS", "TEST_UNIT_READY",=20
"SATA Initialization Timeout,sending a retry", "TEST_UNIT_READY" and=20
finally a "SATA Initialization Failed" for each drive.

The PHY connections are visible at the expander (see smp_discover outpu=
t=20
below).
The drives have an affiliated initiator (see smp_rep_phy_sata output be=
low).

How to further debug this issue?


PS As I am a Linux novice, when suggesting things to do, please be so=20
kind to include an example command.

=3D=3D=3D
# smp_discover /dev/bsg/expander-6:0
   phy   0:D:attached:[50014380182cf0c0:00  t(SATA)]  3 Gbps
   phy   1:D:attached:[50014380182cf0c1:00  t(SATA)]  3 Gbps
   phy   2:D:attached:[50014380182cf0c2:00  t(SATA)]  3 Gbps
   phy   3:D:attached:[50014380182cf0c3:00  t(SATA)]  3 Gbps
   phy   4:D:attached:[50014380182cf0c4:00  t(SATA)]  3 Gbps
   phy   5:D:attached:[50014380182cf0c5:00  t(SATA)]  3 Gbps
   phy   6:D:attached:[50014380182cf0c6:00  t(SATA)]  3 Gbps
   phy   7:D:attached:[50014380182cf0c7:00  t(SATA)]  3 Gbps
   phy   8:D:attached:[50014380182cf0c8:00  t(SATA)]  3 Gbps
   phy   9:D:attached:[50014380182cf0c9:00  t(SATA)]  3 Gbps
   phy  10:D:attached:[50014380182cf0ca:00  t(SATA)]  3 Gbps
   phy  11:D:attached:[50014380182cf0cb:00  t(SATA)]  3 Gbps
   phy  12:D:attached:[50014380182cf0cc:00  t(SATA)]  3 Gbps
   phy  13:D:attached:[50014380182cf0cd:00  t(SATA)]  3 Gbps
   phy  14:D:attached:[50014380182cf0ce:00  t(SATA)]  3 Gbps
   phy  15:D:attached:[50014380182cf0cf:00  t(SATA)]  3 Gbps
   phy  16:D:attached:[50014380182cf0d0:00  t(SATA)]  3 Gbps
   phy  17:D:attached:[50014380182cf0d1:00  t(SATA)]  3 Gbps
   phy  18:D:attached:[50014380182cf0d2:00  t(SATA)]  3 Gbps
   phy  19:D:attached:[50014380182cf0d3:00  t(SATA)]  3 Gbps
   phy  20:D:attached:[50014380182cf0d4:00  t(SATA)]  3 Gbps
   phy  21:D:attached:[50014380182cf0d5:00  t(SATA)]  3 Gbps
   phy  22:D:attached:[50014380182cf0d6:00  t(SATA)]  3 Gbps
   phy  23:D:attached:[50014380182cf0d7:00  t(SATA)]  3 Gbps
   phy  24:T:attached:[5003048007abbc00:00  i(SSP+STP+SMP)]  6 Gbps
   phy  25:T:attached:[5003048007abbc00:01  i(SSP+STP+SMP)]  6 Gbps
   phy  26:T:attached:[5003048007abbc00:02  i(SSP+STP+SMP)]  6 Gbps
   phy  27:T:attached:[5003048007abbc00:03  i(SSP+STP+SMP)]  6 Gbps
   phy  28:S:attached:[50014380182cf0dc:00  t(SATA)]  3 Gbps
   phy  29:S:attached:[50014380182cf0dd:00  t(SATA)]  3 Gbps
   phy  30:S:attached:[50014380182cf0de:00  t(SATA)]  3 Gbps
   phy  31:S:attached:[50014380182cf0df:00  t(SATA)]  3 Gbps
   phy  32:S:attached:[50014380182cf0e0:00  t(SATA)]  3 Gbps
   phy  33:S:attached:[50014380182cf0e1:00  t(SATA)]  3 Gbps
   phy  34:S:attached:[50014380182cf0e2:00  t(SATA)]  3 Gbps
   phy  35:S:attached:[50014380182cf0e3:00  t(SATA)]  3 Gbps
   phy  36:D:attached:[50014380182cf0e5:36  V i(SSP) t(SSP)]  6 Gbps

# smp_rep_exp_route_tbl /dev/bsg/expander-6\:0
Report expander route table response header:
   expander change count: 468
   expander route table change count: 1
   self configuring: 0
   zone configuring: 0
   configuring: 0
   zone enabled: 0
   expander route table descriptor length: 4 dwords
   number of expander route table descriptors: 0
   first routed SAS address index: 0
   last routed SAS address index: 0
   starting phy id: 0

Device details
# smp_rep_phy_sata --phy=3D1 /dev/bsg/expander-6:0
Report phy SATA response:
   expander change count: 468
   phy identifier: 1
   STP I_T nexus loss occurred: 0
   affiliations supported: 1
   affiliation valid: 1
   STP SAS address: 0x50014380182cf0c1
   register device to host FIS:
     34 00 50 01 01 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
   affiliated STP initiator SAS address: 0x5003048007abbc00
   STP I_T nexus loss SAS address: 0x0
   affiliation context: 0
   current affiliation contexts: 1
   maximum affiliation contexts: 1
# smp_discover --phy=3D1 /dev/bsg/expander-6\:0
Discover response:
   expander change count: 468
   phy identifier: 1
   attached device type: end device
   attached reason: unknown
   negotiated logical link rate: phy enabled; 3 Gbps
   attached initiator: ssp=3D0 stp=3D0 smp=3D0 sata_host=3D0
   attached sata port selector: 0
   STP buffer too small: 0
   attached target: ssp=3D0 stp=3D0 smp=3D0 sata_device=3D1
   SAS address: 0x50014380182cf0e6
   attached SAS address: 0x50014380182cf0c1
   attached phy identifier: 0
   attached power capable: 0
   attached slumber capable: 0
   attached partial capable: 0
   attached inside ZPSDS persistent: 0
   attached requested inside ZPSDS: 0
   attached break_reply capable: 0
   programmed minimum physical link rate: 3 Gbps
   hardware minimum physical link rate: 1.5 Gbps
   programmed maximum physical link rate: 6 Gbps
   hardware maximum physical link rate: 6 Gbps
   phy change count: 104
   virtual phy: 0
   partial pathway timeout value: 7 us
   routing attribute: direct
   connector type: SAS Drive backplane receptacle (SFF-8482) [max 2 phy=
s]
   connector element index: 34
   connector physical link: 2
   phy power condition: 0
   sas power capable: 0
   sas slumber capable: 0
   sas partial capable: 0
   sata slumber capable: 0
   sata partial capable: 0
   sas slumber enabled: 0
   sas partial enabled: 0
   sata slumber enabled: 0
   sata partial enabled: 0
   attached device name: 0x0
   requested inside ZPSDS changed by expander: 0
   inside ZPSDS persistent: 0
   requested inside ZPSDS: 0
   zone group persistent: 0
   inside ZPSDS: 0
   zoning enabled: 0
   zone group: 0
   self-configuration status: 0
   self-configuration levels completed: 0
   self-configuration sas address: 0x0
   programmed phy capabilities: 0xc0ac0000
   current phy capabilities: 0x0
   attached phy capabilities: 0x0
   reason: SMP phy control requested
   negotiated physical link rate: phy enabled; 3 Gbps
   optical mode enabled: 0
   negotiated SSC: 0
   hardware muxing supported: 0
   default inside ZPSDS persistent: 1
   default requested inside ZPSDS: 1
   default zone group persistent: 1
   default zoning enabled: 0
   default zone group: 1
   saved inside ZPSDS persistent: 0
   saved requested inside ZPSDS: 0
   saved zone group persistent: 0
   saved zoning enabled: 0
   saved zone group: 0
   shadow inside ZPSDS persistent: 0
   shadow requested inside ZPSDS: 0
   shadow zone group persistent: 0
   shadow zone group: 0

# dmesg | grep mpt2sas
[    5.542063] mpt2sas version 15.00.00.00 loaded
[    5.542484] mpt2sas 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -=
>=20
IRQ 16
[    5.542563] mpt2sas 0000:01:00.0: setting latency timer to 64
[    5.542568] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total=
=20
mem (8191044 kB)
[    5.542734] mpt2sas 0000:01:00.0: irq 31 for MSI/MSI-X
[    5.542750] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 31
[    5.542813] mpt2sas0: iomem(0x00000000fad3c000),=20
mapped(0xffffc90011be0000), size(16384)
[    5.542895] mpt2sas0: ioport(0x000000000000c000), size(256)
[    5.986044] mpt2sas0: Allocated physical memory: size(7445 kB)
[    5.986111] mpt2sas0: Current Controller Queue Depth(3307), Max=20
Controller Queue Depth(3432)
[    5.986193] mpt2sas0: Scatter Gather Elements per IO(128)
[    6.217017] mpt2sas0: LSISAS2008: FWVersion(15.00.00.00),=20
ChipRevision(0x03), BiosVersion(07.29.00.00)
[    6.217107] mpt2sas0: Protocol=3D(Initiator,Target),=20
Capabilities=3D(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Ful=
l,NCQ)
[    6.217907] mpt2sas0: sending port enable !!
[    7.790439] mpt2sas0: host_add: handle(0x0001),=20
sas_addr(0x5003048007abbc00), phys(8)
[    7.801837] mpt2sas0: expander_add: handle(0x0009), parent(0x0001),=20
sas_addr(0x50014380182cf0e6), phys(37)
[    7.814058] mpt2sas0: detecting: handle(0x000a),=20
sas_address(0x50014380182cf0c0), phy(0)
[    7.814156] mpt2sas0: REPORT_LUNS: handle(0x000a), retries(0)
[   12.779517] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   12.779634] mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
[   15.774375] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   15.774486] mpt2sas0: SATA Initialization Timeout,sending a retry
[   15.774559] mpt2sas0: TEST_UNIT_READY: handle(0x000a), lun(0)
[   18.769218] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   18.769326] mpt2sas0: SATA Initialization Failed
[   18.769809] mpt2sas0: detecting: handle(0x000b),=20
sas_address(0x50014380182cf0c1), phy(1)
[   18.769907] mpt2sas0: REPORT_LUNS: handle(0x000b), retries(0)
[   22.013644] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   22.013751] mpt2sas0: TEST_UNIT_READY: handle(0x000b), lun(0)
[   25.008556] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   25.008662] mpt2sas0: SATA Initialization Timeout,sending a retry
[   25.008734] mpt2sas0: TEST_UNIT_READY: handle(0x000b), lun(0)
[   28.003361] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   28.003464] mpt2sas0: SATA Initialization Failed
[   28.003936] mpt2sas0: detecting: handle(0x000c),=20
sas_address(0x50014380182cf0c2), phy(2)
[   28.004031] mpt2sas0: REPORT_LUNS: handle(0x000c), retries(0)
[   30.998244] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   31.003976] mpt2sas0: TEST_UNIT_READY: handle(0x000c), lun(0)
[   34.242687] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   34.242794] mpt2sas0: SATA Initialization Timeout,sending a retry
[   34.242862] mpt2sas0: TEST_UNIT_READY: handle(0x000c), lun(0)
[   37.237516] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[   37.237621] mpt2sas0: SATA Initialization Failed
=2E..
[  616.243950] mpt2sas0: log_info(0x31111000): originator(PL),=20
code(0x11), sub_code(0x1000)
[  616.244055] mpt2sas0: SATA Initialization Failed
[  616.247503] mpt2sas0: detecting: handle(0x004c),=20
sas_address(0x5001438018c7ed25), phy(36)
[  616.247601] mpt2sas0: REPORT_LUNS: handle(0x004c), retries(0)
[  616.248431] mpt2sas0: TEST_UNIT_READY: handle(0x004c), lun(0)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

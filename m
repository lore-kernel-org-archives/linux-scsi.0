From: Robert Edmonds <edmonds@debian.org>
Subject: LSI SAS HBA hard resets
Date: Wed, 31 Mar 2010 16:19:55 +0000 (UTC)
Message-ID: <hovsna$mso$1@dough.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46465 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab0CaQZG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2010 12:25:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1Nx0j2-0004hB-2A
	for linux-scsi@vger.kernel.org; Wed, 31 Mar 2010 18:25:04 +0200
Received: from chase.mycre.ws ([216.27.162.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2010 18:25:04 +0200
Received: from edmonds by chase.mycre.ws with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2010 18:25:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi,

i have a supermicro X8DT3-F system with an onboard LSI 1068E controller
attached to an LSI SASX28 port expander with 12 disks.  occasionally
(e.g., about once per md array check) the controller will lock up and
i'll see messages like this in the kernel log:

[11644.739733] mptscsih: ioc0: attempting task abort! (sc=ffff81063cd64980)
[11644.739776] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fa 89 00 00 b8 00
[11644.739854] mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational (0x40007810)!
[11644.739906] mptscsih: ioc0: WARNING -  Issuing HardReset!!
[11644.739938] mptbase: ioc0: Initiating recovery
[11644.739970] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[11644.740004] mptbase: ioc0: WARNING -            FAULT code = 7810h

followed by more error messages and I/O errors that cause most of the
component devices in one of the md arrays to fail.  i've tried both the
2.6.26 and 2.6.32 kernels and see the same problem.  is there a
solution?

detailed kernel logs follow.

[    1.967515] Fusion MPT base driver 3.04.06
[    1.967515] Copyright (c) 1999-2007 LSI Corporation
[    1.971590] Fusion MPT SAS Host driver 3.04.06
[    1.971590] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.971590] mptbase: ioc0: Initiating bringup
[    2.689216] ioc0: LSISAS1068E B3: Capabilities={Initiator}
[    2.689536] mptbase: ioc0: PCI-MSI enabled
[    2.689614] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   14.463628] scsi0 : ioc0: LSISAS1068E B3, FwRev=011c0200h, Ports=1, MaxQ=483, IRQ=1273
[   15.237934] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.243833] scsi 0:0:1:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.249525] scsi 0:0:2:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.253355] scsi 0:0:3:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.257356] scsi 0:0:4:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.261367] scsi 0:0:5:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.265363] scsi 0:0:6:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.269361] scsi 0:0:7:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.273252] scsi 0:0:8:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.277246] scsi 0:0:9:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.281243] scsi 0:0:10:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.285240] scsi 0:0:11:0: Direct-Access     ATA      WDC WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   15.289428] scsi 0:0:12:0: Enclosure         LSILOGIC SASX28 A.1       7015 PQ: 0 ANSI: 3
[   15.320222] Driver 'sd' needs updating - please use bus_type methods
[   15.323231] sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.329864] sd 0:0:0:0: [sda] Write Protect is off
[   15.329864] sd 0:0:0:0: [sda] Mode Sense: 73 00 00 08
[   15.331704] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.332528] sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.340836] sd 0:0:0:0: [sda] Write Protect is off
[   15.340836] sd 0:0:0:0: [sda] Mode Sense: 73 00 00 08
[   15.343013] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.343013]  sda: sda1 sda2
[   15.349612] sd 0:0:0:0: [sda] Attached SCSI disk
[   15.350223] sd 0:0:1:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.356145] sd 0:0:1:0: [sdb] Write Protect is off
[   15.356209] sd 0:0:1:0: [sdb] Mode Sense: 73 00 00 08
[   15.358335] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.360075] sd 0:0:1:0: [sdb] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.365684] sd 0:0:1:0: [sdb] Write Protect is off
[   15.365749] sd 0:0:1:0: [sdb] Mode Sense: 73 00 00 08
[   15.368713] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.368801]  sdb: sdb1 sdb2
[   15.389474] sd 0:0:1:0: [sdb] Attached SCSI disk
[   15.390604] sd 0:0:2:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.401537] sd 0:0:2:0: [sdc] Write Protect is off
[   15.401537] sd 0:0:2:0: [sdc] Mode Sense: 73 00 00 08
[   15.405668] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.406245] sd 0:0:2:0: [sdc] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.417029] sd 0:0:2:0: [sdc] Write Protect is off
[   15.417029] sd 0:0:2:0: [sdc] Mode Sense: 73 00 00 08
[   15.419712] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.419712]  sdc: sdc1 sdc2
[   15.425060] sd 0:0:2:0: [sdc] Attached SCSI disk
[   15.425809] sd 0:0:3:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.436835] Driver 'ses' needs updating - please use bus_type methods
[   15.437757] sd 0:0:3:0: [sdd] Write Protect is off
[   15.437757] sd 0:0:3:0: [sdd] Mode Sense: 73 00 00 08
[   15.440928] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.441868] sd 0:0:3:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.447615] sd 0:0:3:0: [sdd] Write Protect is off
[   15.447615] sd 0:0:3:0: [sdd] Mode Sense: 73 00 00 08
[   15.451677] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.451677]  sdd: sdd1 sdd2
[   15.464536] sd 0:0:3:0: [sdd] Attached SCSI disk
[   15.464840] sd 0:0:4:0: [sde] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.481724] sd 0:0:4:0: [sde] Write Protect is off
[   15.481724] sd 0:0:4:0: [sde] Mode Sense: 73 00 00 08
[   15.486306] sd 0:0:4:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.486900] sd 0:0:4:0: [sde] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.492884] sd 0:0:4:0: [sde] Write Protect is off
[   15.492884] sd 0:0:4:0: [sde] Mode Sense: 73 00 00 08
[   15.495286] sd 0:0:4:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.495286]  sde: sde1 sde2
[   15.513035] sd 0:0:4:0: [sde] Attached SCSI disk
[   15.513638] sd 0:0:5:0: [sdf] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.521045] sd 0:0:5:0: [sdf] Write Protect is off
[   15.521045] sd 0:0:5:0: [sdf] Mode Sense: 73 00 00 08
[   15.525140] sd 0:0:5:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.525924] sd 0:0:5:0: [sdf] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.531583] sd 0:0:5:0: [sdf] Write Protect is off
[   15.531583] sd 0:0:5:0: [sdf] Mode Sense: 73 00 00 08
[   15.533758] sd 0:0:5:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.533850]  sdf: sdf1 sdf2
[   15.553596] sd 0:0:5:0: [sdf] Attached SCSI disk
[   15.554196] sd 0:0:6:0: [sdg] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.568949] sd 0:0:6:0: [sdg] Write Protect is off
[   15.569014] sd 0:0:6:0: [sdg] Mode Sense: 73 00 00 08
[   15.571237] sd 0:0:6:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.572043] sd 0:0:6:0: [sdg] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.578015] sd 0:0:6:0: [sdg] Write Protect is off
[   15.578080] sd 0:0:6:0: [sdg] Mode Sense: 73 00 00 08
[   15.580214] sd 0:0:6:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.582063]  sdg: sdg1 sdg2
[   15.596459] sd 0:0:6:0: [sdg] Attached SCSI disk
[   15.597218] sd 0:0:7:0: [sdh] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.604093] sd 0:0:7:0: [sdh] Write Protect is off
[   15.604158] sd 0:0:7:0: [sdh] Mode Sense: 73 00 00 08
[   15.606340] sd 0:0:7:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.606954] sd 0:0:7:0: [sdh] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.612865] sd 0:0:7:0: [sdh] Write Protect is off
[   15.612931] sd 0:0:7:0: [sdh] Mode Sense: 73 00 00 08
[   15.616072] sd 0:0:7:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.616166]  sdh: sdh1 sdh2
[   15.634602] sd 0:0:7:0: [sdh] Attached SCSI disk
[   15.635362] sd 0:0:8:0: [sdi] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.646659] sd 0:0:8:0: [sdi] Write Protect is off
[   15.646724] sd 0:0:8:0: [sdi] Mode Sense: 73 00 00 08
[   15.648913] sd 0:0:8:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.650743] sd 0:0:8:0: [sdi] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.656465] sd 0:0:8:0: [sdi] Write Protect is off
[   15.656530] sd 0:0:8:0: [sdi] Mode Sense: 73 00 00 08
[   15.658861] sd 0:0:8:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.658947]  sdi: sdi1 sdi2
[   15.676107] sd 0:0:8:0: [sdi] Attached SCSI disk
[   15.676863] sd 0:0:9:0: [sdj] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.682541] sd 0:0:9:0: [sdj] Write Protect is off
[   15.687813] sd 0:0:9:0: [sdj] Mode Sense: 73 00 00 08
[   15.689970] sd 0:0:9:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.690744] sd 0:0:9:0: [sdj] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.697260] sd 0:0:9:0: [sdj] Write Protect is off
[   15.697325] sd 0:0:9:0: [sdj] Mode Sense: 73 00 00 08
[   15.699512] sd 0:0:9:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.699605]  sdj: sdj1 sdj2
[   15.720541] sd 0:0:9:0: [sdj] Attached SCSI disk
[   15.721565] sd 0:0:10:0: [sdk] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.727243] sd 0:0:10:0: [sdk] Write Protect is off
[   15.727308] sd 0:0:10:0: [sdk] Mode Sense: 73 00 00 08
[   15.730590] sd 0:0:10:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.731380] sd 0:0:10:0: [sdk] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.741513] sd 0:0:10:0: [sdk] Write Protect is off
[   15.741513] sd 0:0:10:0: [sdk] Mode Sense: 73 00 00 08
[   15.743588] sd 0:0:10:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.743588]  sdk: sdk1 sdk2
[   15.760228] sd 0:0:10:0: [sdk] Attached SCSI disk
[   15.761173] sd 0:0:11:0: [sdl] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.766881] sd 0:0:11:0: [sdl] Write Protect is off
[   15.766881] sd 0:0:11:0: [sdl] Mode Sense: 73 00 00 08
[   15.769854] sd 0:0:11:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.770635] sd 0:0:11:0: [sdl] 1953525168 512-byte hardware sectors (1000205 MB)
[   15.776280] sd 0:0:11:0: [sdl] Write Protect is off
[   15.776280] sd 0:0:11:0: [sdl] Mode Sense: 73 00 00 08
[   15.778534] sd 0:0:11:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   15.778626]  sdl: sdl1 sdl2
[   15.791798] sd 0:0:11:0: [sdl] Attached SCSI disk
[   15.797037] ses 0:0:12:0: Attached Enclosure device

[  211.098021] md: md1 switched to read-write mode.
[  215.690323] md: data-check of RAID array md1
[  215.690323] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  215.690323] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[  215.690323] md: using 128k window, over a total of 960751168 blocks.
[11644.739733] mptscsih: ioc0: attempting task abort! (sc=ffff81063cd64980)
[11644.739776] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fa 89 00 00 b8 00
[11644.739854] mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational (0x40007810)!
[11644.739906] mptscsih: ioc0: WARNING -  Issuing HardReset!!
[11644.739938] mptbase: ioc0: Initiating recovery
[11644.739970] mptbase: ioc0: WARNING - IOC is in FAULT state!!!
[11644.740004] mptbase: ioc0: WARNING -            FAULT code = 7810h
[11644.844714] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a9c5840, mf = ffff81063a484400, idx=38
[11644.844779] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a146940, mf = ffff81063a484880, idx=41
[11644.844841] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a9c5200, mf = ffff81063a485080, idx=51
[11644.844908] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff81063cd64e80, mf = ffff81063a485880, idx=61
[11644.844973] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff81063cd64980, mf = ffff81063a485980, idx=63
[11644.845038] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3cc7fe40, mf = ffff81063a486980, idx=83
[11644.845102] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a056c00, mf = ffff81063a487100, idx=92
[11644.845171] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a9c5c00, mf = ffff81063a48ab80, idx=107
[11644.845235] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff81063a401580, mf = ffff81063a48ad00, idx=10a
[11644.845303] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a178c00, mf = ffff81063a48e780, idx=17f
[11644.845369] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff81063a806080, mf = ffff81063a48e800, idx=180
[11644.845434] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff81063a401bc0, mf = ffff81063a48ef80, idx=18f
[11644.845499] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff81063a401940, mf = ffff81063a490400, idx=1b8
[11644.845564] sd 0:0:10:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 18, sc=ffff810c3a056e80, mf = ffff81063a490600, idx=1bc
[11647.855740] mptbase: ioc0: Recovered from IOC FAULT
[11660.218016] mptscsih: ioc0: task abort: FAILED (sc=ffff81063cd64980)
[11660.218054] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a9c5840)
[11660.218122] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fb 41 00 00 48 00
[11660.218201] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a9c5840)
[11660.244527] mptscsih: ioc0: attempting task abort! (sc=ffff810c3cc7fe40)
[11660.244527] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fb 89 00 01 00 00
[11660.244527] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3cc7fe40)
[11660.244808] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a178c00)
[11660.244808] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fc 89 00 00 40 00
[11660.244808] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a178c00)
[11660.245090] mptscsih: ioc0: attempting task abort! (sc=ffff81063a806080)
[11660.245090] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fd 89 00 00 60 00
[11660.245090] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81063a806080)
[11660.245090] mptscsih: ioc0: attempting task abort! (sc=ffff81063a401940)
[11660.245090] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fd e9 00 00 40 00
[11660.245090] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81063a401940)
[11660.245385] mptscsih: ioc0: attempting task abort! (sc=ffff81063a401580)
[11660.245385] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fe 29 00 00 60 00
[11660.245385] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81063a401580)
[11660.245698] mptscsih: ioc0: attempting task abort! (sc=ffff81063cd64e80)
[11660.245698] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fe 89 00 00 e0 00
[11660.245698] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81063cd64e80)
[11660.245698] mptscsih: ioc0: attempting task abort! (sc=ffff81063a401bc0)
[11660.245698] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 ff 69 00 00 20 00
[11660.245698] mptscsih: ioc0: task abort: SUCCESS (sc=ffff81063a401bc0)
[11660.245978] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a056c00)
[11660.245978] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 8a 00 91 00 00 58 00
[11660.245978] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a056c00)
[11660.245978] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a146940)
[11660.245978] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fc c9 00 00 08 00
[11660.245978] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a146940)
[11660.246278] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a9c5c00)
[11660.246278] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fc d1 00 00 b8 00
[11660.246278] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a9c5c00)
[11660.246564] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a056e80)
[11660.246564] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 ff 89 00 01 00 00
[11660.246564] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a056e80)
[11660.246564] mptscsih: ioc0: attempting task abort! (sc=ffff810c3a9c5200)
[11660.246564] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 8a 00 89 00 00 08 00
[11660.246564] mptscsih: ioc0: task abort: SUCCESS (sc=ffff810c3a9c5200)
[11660.246860] mptscsih: ioc0: attempting target reset! (sc=ffff81063cd64980)
[11660.246860] sd 0:0:10:0: [sdk] CDB: Read(10): 28 00 4d 89 fa 89 00 00 b8 00
[11661.803458] mptscsih: ioc0: target reset: SUCCESS (sc=ffff81063cd64980)
[11661.816045] end_request: I/O error, dev sda, sector 32017343
[11661.816045] md: super_written gets error=-5, uptodate=0
[11661.816045] raid1: Disk failure on sda1, disabling device.
[11661.816045] raid1: Operation continuing on 11 devices.
[11661.816045] end_request: I/O error, dev sdc, sector 32017343
[11661.816045] md: super_written gets error=-5, uptodate=0
[11661.816045] raid1: Disk failure on sdc1, disabling device.
[11661.816045] raid1: Operation continuing on 10 devices.
[11661.833492] end_request: I/O error, dev sdg, sector 32017343
[11661.833492] md: super_written gets error=-5, uptodate=0
[11661.833492] raid1: Disk failure on sdg1, disabling device.
[11661.833492] raid1: Operation continuing on 9 devices.
[11661.833492] end_request: I/O error, dev sdl, sector 32017343
[11661.833492] md: super_written gets error=-5, uptodate=0
[11661.833492] raid1: Disk failure on sdl1, disabling device.
[11661.833492] raid1: Operation continuing on 8 devices.
[11661.833821] end_request: I/O error, dev sdb, sector 32017343
[11661.833821] md: super_written gets error=-5, uptodate=0
[11661.833821] raid1: Disk failure on sdb1, disabling device.
[11661.833821] raid1: Operation continuing on 7 devices.
[11661.834596] end_request: I/O error, dev sde, sector 32017343
[11661.834596] md: super_written gets error=-5, uptodate=0
[11661.834596] raid1: Disk failure on sde1, disabling device.
[11661.834596] raid1: Operation continuing on 6 devices.
[11661.834596] end_request: I/O error, dev sdd, sector 32017343
[11661.834596] md: super_written gets error=-5, uptodate=0
[11661.834596] raid1: Disk failure on sdd1, disabling device.
[11661.834596] raid1: Operation continuing on 5 devices.
[11661.835057] end_request: I/O error, dev sdj, sector 32017343
[11661.835057] md: super_written gets error=-5, uptodate=0
[11661.835057] raid1: Disk failure on sdj1, disabling device.
[11661.835057] raid1: Operation continuing on 4 devices.
[11661.835057] end_request: I/O error, dev sdi, sector 32017343
[11661.835057] md: super_written gets error=-5, uptodate=0
[11661.835057] raid1: Disk failure on sdi1, disabling device.
[11661.835057] raid1: Operation continuing on 3 devices.
[11661.835057] end_request: I/O error, dev sdh, sector 32017343
[11661.835057] md: super_written gets error=-5, uptodate=0
[11661.835057] raid1: Disk failure on sdh1, disabling device.
[11661.835057] raid1: Operation continuing on 2 devices.
[11662.979604] end_request: I/O error, dev sdf, sector 32017343
[11662.979639] md: super_written gets error=-5, uptodate=0
[11662.979817] raid1: Disk failure on sdf1, disabling device.
[11662.979818] raid1: Operation continuing on 1 devices.
[11663.095251] RAID1 conf printout:
[11663.099189]  --- wd:1 rd:12
[11663.099189]  disk 0, wo:1, o:0, dev:sda1
[11663.099189]  disk 1, wo:1, o:0, dev:sdb1
[11663.099189]  disk 2, wo:1, o:0, dev:sdc1
[11663.099189]  disk 3, wo:1, o:0, dev:sdd1
[11663.099189]  disk 4, wo:1, o:0, dev:sde1
[11663.099189]  disk 5, wo:1, o:0, dev:sdf1
[11663.099189]  disk 6, wo:1, o:0, dev:sdg1
[11663.099189]  disk 7, wo:1, o:0, dev:sdh1
[11663.099189]  disk 8, wo:1, o:0, dev:sdi1
[11663.099189]  disk 9, wo:1, o:0, dev:sdj1
[11663.099189]  disk 10, wo:0, o:1, dev:sdk1
[11663.099189]  disk 11, wo:1, o:0, dev:sdl1
[11663.114698] RAID1 conf printout:
[11663.114729]  --- wd:1 rd:12
[11663.114754]  disk 1, wo:1, o:0, dev:sdb1
[11663.114781]  disk 2, wo:1, o:0, dev:sdc1
[11663.114807]  disk 3, wo:1, o:0, dev:sdd1
[11663.114834]  disk 4, wo:1, o:0, dev:sde1
[11663.114882]  disk 5, wo:1, o:0, dev:sdf1
[11663.114918]  disk 6, wo:1, o:0, dev:sdg1
[11663.120848]  disk 7, wo:1, o:0, dev:sdh1
[11663.120891]  disk 8, wo:1, o:0, dev:sdi1
[11663.120918]  disk 9, wo:1, o:0, dev:sdj1
[11663.120945]  disk 10, wo:0, o:1, dev:sdk1
[11663.120986]  disk 11, wo:1, o:0, dev:sdl1
[11663.121022] RAID1 conf printout:
[11663.121046]  --- wd:1 rd:12
[11663.121070]  disk 1, wo:1, o:0, dev:sdb1
[11663.121097]  disk 2, wo:1, o:0, dev:sdc1
[11663.121123]  disk 3, wo:1, o:0, dev:sdd1
[11663.121149]  disk 4, wo:1, o:0, dev:sde1
[11663.121175]  disk 5, wo:1, o:0, dev:sdf1
[11663.121211]  disk 6, wo:1, o:0, dev:sdg1
[11663.121237]  disk 7, wo:1, o:0, dev:sdh1
[11663.121263]  disk 8, wo:1, o:0, dev:sdi1
[11663.121289]  disk 9, wo:1, o:0, dev:sdj1
[11663.121315]  disk 10, wo:0, o:1, dev:sdk1
[11663.121342]  disk 11, wo:1, o:0, dev:sdl1
[11663.134598] RAID1 conf printout:
[11663.134628]  --- wd:1 rd:12
[11663.134653]  disk 1, wo:1, o:0, dev:sdb1
[11663.134680]  disk 2, wo:1, o:0, dev:sdc1
[11663.134707]  disk 3, wo:1, o:0, dev:sdd1
[11663.134745]  disk 4, wo:1, o:0, dev:sde1
[11663.134772]  disk 5, wo:1, o:0, dev:sdf1
[11663.134798]  disk 6, wo:1, o:0, dev:sdg1
[11663.134825]  disk 7, wo:1, o:0, dev:sdh1
[11663.134851]  disk 8, wo:1, o:0, dev:sdi1
[11663.134878]  disk 9, wo:1, o:0, dev:sdj1
[11663.134904]  disk 10, wo:0, o:1, dev:sdk1
[11663.134939] RAID1 conf printout:
[11663.134963]  --- wd:1 rd:12
[11663.135071]  disk 1, wo:1, o:0, dev:sdb1
[11663.135097]  disk 2, wo:1, o:0, dev:sdc1
[11663.135124]  disk 3, wo:1, o:0, dev:sdd1
[11663.135150]  disk 4, wo:1, o:0, dev:sde1
[11663.135176]  disk 5, wo:1, o:0, dev:sdf1
[11663.135202]  disk 6, wo:1, o:0, dev:sdg1
[11663.135248]  disk 7, wo:1, o:0, dev:sdh1
[11663.135394]  disk 8, wo:1, o:0, dev:sdi1
[11663.135420]  disk 9, wo:1, o:0, dev:sdj1
[11663.135447]  disk 10, wo:0, o:1, dev:sdk1
[11663.148037] RAID1 conf printout:
[11663.148067]  --- wd:1 rd:12
[11663.148094]  disk 1, wo:1, o:0, dev:sdb1
[11663.148120]  disk 2, wo:1, o:0, dev:sdc1
[11663.150587]  disk 3, wo:1, o:0, dev:sdd1
[11663.150613]  disk 4, wo:1, o:0, dev:sde1
[11663.150639]  disk 5, wo:1, o:0, dev:sdf1
[11663.150666]  disk 6, wo:1, o:0, dev:sdg1
[11663.150692]  disk 7, wo:1, o:0, dev:sdh1
[11663.150718]  disk 8, wo:1, o:0, dev:sdi1
[11663.150745]  disk 10, wo:0, o:1, dev:sdk1
[11663.150776] RAID1 conf printout:
[11663.150800]  --- wd:1 rd:12
[11663.150824]  disk 1, wo:1, o:0, dev:sdb1
[11663.150850]  disk 2, wo:1, o:0, dev:sdc1
[11663.150877]  disk 3, wo:1, o:0, dev:sdd1
[11663.150903]  disk 4, wo:1, o:0, dev:sde1
[11663.150929]  disk 5, wo:1, o:0, dev:sdf1
[11663.150955]  disk 6, wo:1, o:0, dev:sdg1
[11663.150981]  disk 7, wo:1, o:0, dev:sdh1
[11663.151008]  disk 8, wo:1, o:0, dev:sdi1
[11663.151034]  disk 10, wo:0, o:1, dev:sdk1
[11663.166371] RAID1 conf printout:
[11663.166577]  --- wd:1 rd:12
[11663.166602]  disk 1, wo:1, o:0, dev:sdb1
[11663.166629]  disk 2, wo:1, o:0, dev:sdc1
[11663.166655]  disk 3, wo:1, o:0, dev:sdd1
[11663.166682]  disk 4, wo:1, o:0, dev:sde1
[11663.166708]  disk 5, wo:1, o:0, dev:sdf1
[11663.166735]  disk 6, wo:1, o:0, dev:sdg1
[11663.166761]  disk 7, wo:1, o:0, dev:sdh1
[11663.166788]  disk 10, wo:0, o:1, dev:sdk1
[11663.166821] RAID1 conf printout:
[11663.166861]  --- wd:1 rd:12
[11663.166885]  disk 1, wo:1, o:0, dev:sdb1
[11663.166911]  disk 2, wo:1, o:0, dev:sdc1
[11663.166938]  disk 3, wo:1, o:0, dev:sdd1
[11663.166964]  disk 4, wo:1, o:0, dev:sde1
[11663.166991]  disk 5, wo:1, o:0, dev:sdf1
[11663.167043]  disk 6, wo:1, o:0, dev:sdg1
[11663.167070]  disk 7, wo:1, o:0, dev:sdh1
[11663.167119]  disk 10, wo:0, o:1, dev:sdk1
[11663.183789] RAID1 conf printout:
[11663.183820]  --- wd:1 rd:12
[11663.183845]  disk 1, wo:1, o:0, dev:sdb1
[11663.183872]  disk 2, wo:1, o:0, dev:sdc1
[11663.183898]  disk 3, wo:1, o:0, dev:sdd1
[11663.183925]  disk 4, wo:1, o:0, dev:sde1
[11663.183951]  disk 5, wo:1, o:0, dev:sdf1
[11663.183978]  disk 6, wo:1, o:0, dev:sdg1
[11663.184004]  disk 10, wo:0, o:1, dev:sdk1
[11663.184055] RAID1 conf printout:
[11663.184080]  --- wd:1 rd:12
[11663.184105]  disk 1, wo:1, o:0, dev:sdb1
[11663.184145]  disk 2, wo:1, o:0, dev:sdc1
[11663.206083]  disk 3, wo:1, o:0, dev:sdd1
[11663.206110]  disk 4, wo:1, o:0, dev:sde1
[11663.206136]  disk 5, wo:1, o:0, dev:sdf1
[11663.206375]  disk 6, wo:1, o:0, dev:sdg1
[11663.206412]  disk 10, wo:0, o:1, dev:sdk1
[11663.242945] RAID1 conf printout:
[11663.242990]  --- wd:1 rd:12
[11663.243015]  disk 1, wo:1, o:0, dev:sdb1
[11663.243051]  disk 2, wo:1, o:0, dev:sdc1
[11663.243078]  disk 3, wo:1, o:0, dev:sdd1
[11663.243104]  disk 4, wo:1, o:0, dev:sde1
[11663.243137]  disk 5, wo:1, o:0, dev:sdf1
[11663.243164]  disk 10, wo:0, o:1, dev:sdk1
[11663.243197] RAID1 conf printout:
[11663.243222]  --- wd:1 rd:12
[11663.243246]  disk 1, wo:1, o:0, dev:sdb1
[11663.243272]  disk 2, wo:1, o:0, dev:sdc1
[11663.243299]  disk 3, wo:1, o:0, dev:sdd1
[11663.243332]  disk 4, wo:1, o:0, dev:sde1
[11663.243375]  disk 5, wo:1, o:0, dev:sdf1
[11663.243401]  disk 10, wo:0, o:1, dev:sdk1
[11663.272237] RAID1 conf printout:
[11663.272270]  --- wd:1 rd:12
[11663.272306]  disk 1, wo:1, o:0, dev:sdb1
[11663.272333]  disk 2, wo:1, o:0, dev:sdc1
[11663.272383]  disk 3, wo:1, o:0, dev:sdd1
[11663.272421]  disk 4, wo:1, o:0, dev:sde1
[11663.272453]  disk 10, wo:0, o:1, dev:sdk1
[11663.272487] RAID1 conf printout:
[11663.272517]  --- wd:1 rd:12
[11663.272542]  disk 1, wo:1, o:0, dev:sdb1
[11663.272592]  disk 2, wo:1, o:0, dev:sdc1
[11663.272620]  disk 3, wo:1, o:0, dev:sdd1
[11663.272649]  disk 4, wo:1, o:0, dev:sde1
[11663.272676]  disk 10, wo:0, o:1, dev:sdk1
[11663.288631] RAID1 conf printout:
[11663.288666]  --- wd:1 rd:12
[11663.290900]  disk 1, wo:1, o:0, dev:sdb1
[11663.290927]  disk 2, wo:1, o:0, dev:sdc1
[11663.290953]  disk 3, wo:1, o:0, dev:sdd1
[11663.290980]  disk 10, wo:0, o:1, dev:sdk1
[11663.291013] RAID1 conf printout:
[11663.291038]  --- wd:1 rd:12
[11663.291062]  disk 1, wo:1, o:0, dev:sdb1
[11663.291116]  disk 2, wo:1, o:0, dev:sdc1
[11663.291147]  disk 3, wo:1, o:0, dev:sdd1
[11663.291174]  disk 10, wo:0, o:1, dev:sdk1
[11663.306013] RAID1 conf printout:
[11663.306059]  --- wd:1 rd:12
[11663.306083]  disk 1, wo:1, o:0, dev:sdb1
[11663.306888]  disk 2, wo:1, o:0, dev:sdc1
[11663.306914]  disk 10, wo:0, o:1, dev:sdk1
[11663.306965] RAID1 conf printout:
[11663.307010]  --- wd:1 rd:12
[11663.307039]  disk 1, wo:1, o:0, dev:sdb1
[11663.307071]  disk 2, wo:1, o:0, dev:sdc1
[11663.307097]  disk 10, wo:0, o:1, dev:sdk1
[11663.323409] RAID1 conf printout:
[11663.323448]  --- wd:1 rd:12
[11663.324189]  disk 1, wo:1, o:0, dev:sdb1
[11663.324229]  disk 10, wo:0, o:1, dev:sdk1
[11663.324263] RAID1 conf printout:
[11663.324288]  --- wd:1 rd:12
[11663.324311]  disk 1, wo:1, o:0, dev:sdb1
[11663.324338]  disk 10, wo:0, o:1, dev:sdk1
[11663.341590] RAID1 conf printout:
[11663.341621]  --- wd:1 rd:12
[11663.341646]  disk 10, wo:0, o:1, dev:sdk1
[17759.127633] md: md1: data-check done.
[17759.204572] RAID5 conf printout:
[17759.204572]  --- rd:12 wd:12
[17759.204572]  disk 0, o:1, dev:sda2
[17759.204572]  disk 1, o:1, dev:sdb2
[17759.204572]  disk 2, o:1, dev:sdc2
[17759.204572]  disk 3, o:1, dev:sdd2
[17759.204572]  disk 4, o:1, dev:sde2
[17759.204572]  disk 5, o:1, dev:sdf2
[17759.204572]  disk 6, o:1, dev:sdg2
[17759.204572]  disk 7, o:1, dev:sdh2
[17759.204572]  disk 8, o:1, dev:sdi2
[17759.204572]  disk 9, o:1, dev:sdj2
[17759.204572]  disk 10, o:1, dev:sdk2
[17759.204572]  disk 11, o:1, dev:sdl2

-- 
Robert Edmonds
edmonds@debian.org

